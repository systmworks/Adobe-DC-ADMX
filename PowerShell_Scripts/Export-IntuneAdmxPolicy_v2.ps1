#Requires -Version 5.1
#Requires -Modules Microsoft.Graph.Authentication
<#
.SYNOPSIS
    Exports an Intune Administrative Template (ADMX-backed) policy to JSON (v2).
.DESCRIPTION
    Clears the host at startup, then same behavior as Export-IntuneAdmxPolicy.ps1, with:
    - Throttling-safe Graph requests (429 / ThrottledByInfra) with Retry-After,
      embedded RetryAfter hints, and exponential backoff.
    - Does not call Set-MgRequestContext (some SDK builds break the next Invoke-MgGraphRequest with
      "Invalid URI"); throttling is handled by Invoke-GraphRequestWithRetry instead.
    - Invoke-MgGraphRequest GET calls use path-only URIs (/beta/...) so the SDK attaches the correct
      Graph host (commercial or sovereign cloud); full https://... URLs are still used in exported JSON.
    - Loads definitionValues without OData $expand (Intune rejects that pattern); each setting uses two GETs.
    - Console colours: Cyan = connection / listing policies; Magenta = selection and export start;
      Yellow = notes and warnings; DarkYellow = Graph throttling retries; DarkGray = technical detail;
      Gray = per-setting progress; Green = completion.
    - Optional -BetweenSettingDelayMs: sleep after each setting's GET pair (pace busy tenants).
    - Optional -SlowGraphCallNoticeSeconds (default 5): per-setting GETs log a gray line when a call exceeds this many seconds.

    The exported JSON matches Import-IntuneAdmxPolicy.ps1 expectations.
.NOTES
    Requires the Microsoft.Graph.Authentication module:
      Install-Module Microsoft.Graph.Authentication -Scope CurrentUser

    Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0).
    https://creativecommons.org/licenses/by-sa/4.0/
.EXAMPLE
    .\Export-IntuneAdmxPolicy_v2.ps1
.EXAMPLE
    .\Export-IntuneAdmxPolicy_v2.ps1 -PolicyName "Adobe Reader" -BetweenSettingDelayMs 75
.EXAMPLE
    .\Export-IntuneAdmxPolicy_v2.ps1 -SlowGraphCallNoticeSeconds 0
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$PolicyName,

    [Parameter(Mandatory = $false)]
    [ValidateRange(0, 600000)]
    [int]$BetweenSettingDelayMs = 0,

    # If a successful Graph GET takes this many seconds or more, print a DarkGray hint during per-setting export.
    [Parameter(Mandatory = $false)]
    [ValidateRange(0, 120)]
    [int]$SlowGraphCallNoticeSeconds = 5
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$graphBase = 'https://graph.microsoft.com/beta'

Clear-Host

# -- Connect to Microsoft Graph -----------------------------------------------

$requiredScopes = @('DeviceManagementConfiguration.Read.All')

function Connect-WithFallback([string[]]$Scopes) {
    try {
        Connect-MgGraph -Scopes $Scopes -NoWelcome -ErrorAction Stop
    } catch {
        Write-Host '  Browser popup failed, trying with WAM disabled...' -ForegroundColor DarkYellow
        $env:MSAL_INTERACTIVE_BROWSER_DISABLE_WAM = '1'
        try {
            Connect-MgGraph -Scopes $Scopes -NoWelcome -ErrorAction Stop
        } catch {
            Write-Host '  Browser still unavailable, falling back to device-code flow...' -ForegroundColor DarkYellow
            Write-Host '  (Open a browser and enter the device code when prompted.)' -ForegroundColor DarkYellow
            Connect-MgGraph -Scopes $Scopes -NoWelcome -UseDeviceCode -ContextScope Process
        }
    }
}

$ctx = Get-MgContext -ErrorAction SilentlyContinue
if ($null -eq $ctx) {
    Write-Host 'Connecting to Microsoft Graph...' -ForegroundColor Cyan
    Connect-WithFallback $requiredScopes
} else {
    $missing = $requiredScopes | Where-Object { $ctx.Scopes -notcontains $_ }
    if ($missing) {
        Write-Host 'Re-connecting with required scopes...' -ForegroundColor Cyan
        Connect-WithFallback $requiredScopes
    } else {
        Write-Host "Already connected as $($ctx.Account)" -ForegroundColor Cyan
    }
}

# (Intentionally no Set-MgRequestContext here: it has correlated with UriFormatException on the
#  next Invoke-MgGraphRequest in some Microsoft.Graph.Authentication builds. Use custom retries below.)

# -- Graph property helper (hashtable vs PSCustomObject) ---------------------

function Get-GraphProp {
    param($Object, [string]$Name)
    if ($null -eq $Object) { return $null }
    if ($Object -is [System.Collections.IDictionary]) {
        foreach ($k in $Object.Keys) {
            if ([string]::Equals([string]$k, $Name, [StringComparison]::OrdinalIgnoreCase)) {
                return $Object[$k]
            }
        }
        return $null
    }
    $p = $Object.PSObject.Properties[$Name]
    if ($p) { return $p.Value }
    foreach ($q in $Object.PSObject.Properties) {
        if ([string]::Equals($q.Name, $Name, [StringComparison]::OrdinalIgnoreCase)) {
            return $q.Value
        }
    }
    return $null
}

function Get-GraphODataValueCollection {
    param($Resp)
    [object[]]$out = @()
    if ($null -eq $Resp) {
        return Microsoft.PowerShell.Utility\Write-Output -InputObject $out -NoEnumerate
    }
    $val = Get-GraphProp -Object $Resp -Name 'value'
    if ($null -eq $val) {
        return Microsoft.PowerShell.Utility\Write-Output -InputObject $out -NoEnumerate
    }
    if ($val -is [System.Array]) {
        $out = [object[]]$val
        return Microsoft.PowerShell.Utility\Write-Output -InputObject $out -NoEnumerate
    }
    if ($val -is [System.Collections.IDictionary]) {
        $out = [object[]](, $val)
        return Microsoft.PowerShell.Utility\Write-Output -InputObject $out -NoEnumerate
    }
    if ($val -is [System.Collections.IEnumerable] -and $val -isnot [string]) {
        $list = [System.Collections.Generic.List[object]]::new()
        foreach ($x in $val) {
            if ($null -ne $x) { $list.Add($x) }
        }
        $out = $list.ToArray()
        return Microsoft.PowerShell.Utility\Write-Output -InputObject $out -NoEnumerate
    }
    $out = [object[]](, $val)
    return Microsoft.PowerShell.Utility\Write-Output -InputObject $out -NoEnumerate
}

function Test-GraphThrottleError([System.Management.Automation.ErrorRecord]$ErrorRecord) {
    $msg = $ErrorRecord.Exception.Message
    if ($msg -match 'TooManyRequests|ThrottledByInfra|\b429\b|Throttled|tooManyRetries') {
        return $true
    }
    try {
        $resp = $ErrorRecord.Exception.Response
        if ($resp -and [int]$resp.StatusCode -eq 429) { return $true }
    } catch { }
    return $false
}

function Get-ThrottleWaitSeconds {
    param(
        [System.Exception]$Exception,
        [int]$FailedCount
    )
    $wait = 0
    foreach ($ex in @($Exception, $Exception.InnerException)) {
        if ($null -eq $ex) { continue }
        try {
            $resp = $ex.Response
            if ($resp -and $resp.Headers) {
                if ($resp.Headers.RetryAfter -and $resp.Headers.RetryAfter.DeltaTicks) {
                    $wait = [int][Math]::Ceiling($resp.Headers.RetryAfter.TotalSeconds)
                }
                if ($wait -le 0) {
                    $vals = $resp.Headers.GetValues('Retry-After')
                    if ($vals -and $vals.Count -gt 0) {
                        $wait = [int]$vals[0]
                    }
                }
            }
        } catch { }
        if ($wait -gt 0) { break }
    }

    $blob = "$($Exception.Message)$([Environment]::NewLine)$($Exception.ToString())"
    if ($wait -le 0 -and $blob -match '(?i)RetryAfter[^\"]{0,40}\"(\d{2}):(\d{2}):(\d{2})') {
        $wait = [int]$Matches[1] * 3600 + [int]$Matches[2] * 60 + [int]$Matches[3]
    }

    if ($wait -le 0) {
        $cap = 60.0
        $exp = [Math]::Min($cap, [Math]::Pow(2, [Math]::Min($FailedCount, 6)))
        $jitter = (Get-Random -Maximum 750) / 1000.0
        $wait = [int][Math]::Ceiling($exp + $jitter)
        if ($wait -lt 2) { $wait = 2 }
    }
    if ($wait -gt 120) { $wait = 120 }
    return $wait
}

function ConvertTo-MgGraphRelativeUri([string]$Raw) {
    if ([string]::IsNullOrWhiteSpace($Raw)) {
        throw 'Graph request URI is null or empty.'
    }
    $t = $Raw.Trim()
    if ($t.StartsWith('/')) {
        return $t
    }
    try {
        $u = [Uri]$t
        if ($u.IsAbsoluteUri) {
            $pq = $u.PathAndQuery
            if ([string]::IsNullOrWhiteSpace($pq) -or $pq.Length -lt 2) {
                throw "No path in URI: $Raw"
            }
            return $pq
        }
    } catch {
        if ($_.Exception.Message -match 'No path in URI') { throw }
    }
    return '/' + $t.TrimStart('/')
}

function Invoke-GraphRequestWithRetry {
    param(
        [Parameter(Mandatory = $true)][string]$RequestUri,
        [int]$MaxAttempts = 12,
        [ValidateRange(0, 120)]
        [int]$SlowRequestNoticeSeconds = 0
    )
    # Path-only (/beta/...): Invoke-MgGraphRequest binds the session host (avoids UriFormatException on some
    # builds when passing a full https://graph.microsoft.com/... string).
    $invokeUri = ConvertTo-MgGraphRelativeUri $RequestUri
    $attempt = 0
    while ($true) {
        $attempt++
        try {
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            $respObj = Invoke-MgGraphRequest -Method GET -Uri $invokeUri -ErrorAction Stop
            $sw.Stop()
            if ($SlowRequestNoticeSeconds -gt 0 -and $sw.Elapsed.TotalSeconds -ge $SlowRequestNoticeSeconds) {
                Write-Host ('  Slow Graph response ({0:n1}s). Intune often queues; the SDK may retry 429/503 before this script sees it.' -f $sw.Elapsed.TotalSeconds) -ForegroundColor DarkGray
            }
            return $respObj
        } catch {
            if ($attempt -ge $MaxAttempts) {
                throw
            }
            if (-not (Test-GraphThrottleError $_)) {
                throw
            }
            $waitSec = Get-ThrottleWaitSeconds -Exception $_.Exception -FailedCount $attempt
            $retryNum = $attempt + 1
            $throttleMsg = '  Graph throttled; waiting {0}s (retry {1} of {2})...' -f $waitSec, $retryNum, $MaxAttempts
            Write-Host $throttleMsg -ForegroundColor DarkYellow
            Start-Sleep -Seconds $waitSec
        }
    }
}

function Invoke-GraphGetAll([string]$Uri) {
    $results = [System.Collections.Generic.List[object]]::new()
    $url = $Uri
    do {
        $resp = Invoke-GraphRequestWithRetry -RequestUri $url
        foreach ($item in (Get-GraphODataValueCollection $resp)) {
            $results.Add($item)
        }
        $next = [string](Get-GraphProp -Object $resp -Name '@odata.nextLink')
        $url = if ([string]::IsNullOrWhiteSpace($next)) { $null } else { (ConvertTo-MgGraphRelativeUri $next) }
    } while ($url)
    return $results
}

function Build-PresentationValuesFromItems {
    param(
        $Definition,
        $PresItems
    )
    $definitionId = [string](Get-GraphProp -Object $Definition -Name 'id')
    $definitionBindRoot = "$graphBase/deviceManagement/groupPolicyDefinitions('$definitionId')"
    $outList = [System.Collections.Generic.List[object]]::new()
    $items = if ($null -eq $PresItems) { [object[]]@() } elseif ($PresItems -is [System.Array]) { [object[]]$PresItems } elseif ($PresItems -is [System.Collections.IList]) {
        $tmp = [System.Collections.Generic.List[object]]::new()
        for ($i = 0; $i -lt $PresItems.Count; $i++) { $tmp.Add($PresItems[$i]) }
        $tmp.ToArray()
    } else {
        [object[]](, $PresItems)
    }

    foreach ($pv in $items) {
        if ($null -eq $pv) { continue }
        $pres = Get-GraphProp -Object $pv -Name 'presentation'
        $presLabel = [string](Get-GraphProp -Object $pres -Name 'label')
        $presId = [string](Get-GraphProp -Object $pres -Name 'id')
        $entry = [ordered]@{
            '@odata.type'             = (Get-GraphProp -Object $pv -Name '@odata.type')
            'presentationLabel'     = $presLabel
            'presentationId'        = $presId
            'presentation@odata.bind' = "$definitionBindRoot/presentations('$presId')"
        }
        if ($pv -is [System.Collections.IDictionary]) {
            if ($pv.ContainsKey('value')) { $entry['value'] = $pv['value'] }
            if ($pv.ContainsKey('values')) { $entry['values'] = $pv['values'] }
        } else {
            $pn = @($pv.PSObject.Properties | ForEach-Object { $_.Name })
            if ($pn -contains 'value') { $entry['value'] = $pv.value }
            if ($pn -contains 'values') { $entry['values'] = $pv.values }
        }
        $outList.Add($entry)
    }
    return Microsoft.PowerShell.Utility\Write-Output -InputObject ($outList.ToArray()) -NoEnumerate
}

function New-ExportedSetting {
    param(
        $Dv,
        $Definition,
        $PresItems
    )
    # @(...) prevents PowerShell from unrolling a 1-element array into a single hashtable (no .Length in StrictMode).
    $presValues = @(Build-PresentationValuesFromItems -Definition $Definition -PresItems $PresItems)
    $definitionId = [string](Get-GraphProp -Object $Definition -Name 'id')
    $setting = [ordered]@{
        'enabled'                = Get-GraphProp -Object $Dv -Name 'enabled'
        'definitionDisplayName'  = Get-GraphProp -Object $Definition -Name 'displayName'
        'definitionCategoryPath' = Get-GraphProp -Object $Definition -Name 'categoryPath'
        'definitionClassType'    = Get-GraphProp -Object $Definition -Name 'classType'
        'definitionId'           = $definitionId
        'definition@odata.bind'  = "$graphBase/deviceManagement/groupPolicyDefinitions('$definitionId')"
    }
    if ($presValues.Length -gt 0) {
        $setting['presentationValues'] = @($presValues)
    }
    return $setting
}

# -- List all Administrative Template policies --------------------------------

Write-Host 'Retrieving Administrative Template policies...' -ForegroundColor Cyan
$allPolicies = Invoke-GraphGetAll "$graphBase/deviceManagement/groupPolicyConfigurations"

if ($allPolicies.Count -eq 0) {
    Write-Host 'No Administrative Template policies found in this tenant.' -ForegroundColor Yellow
    return
}

Write-Host ''
Write-Host '  Administrative Template Policies' -ForegroundColor Cyan
Write-Host '  ================================' -ForegroundColor Cyan
for ($i = 0; $i -lt $allPolicies.Count; $i++) {
    Write-Host "  [$($i + 1)] $($allPolicies[$i].displayName)" -ForegroundColor White
}
Write-Host ''

# -- Select policy (parameter, prompt, or auto-match) ------------------------

function Find-Policy([string]$Search, $Policies) {
    if ([string]::IsNullOrWhiteSpace($Search)) { return $null }
    if ($Search -match '^\d+$') {
        $idx = [int]$Search - 1
        if ($idx -ge 0 -and $idx -lt $Policies.Count) { return $Policies[$idx] }
    }
    $exact = @($Policies | Where-Object { $_.displayName -eq $Search })
    if ($exact.Count -eq 1) { return $exact[0] }
    $partial = @($Policies | Where-Object { $_.displayName -like "*$Search*" })
    if ($partial.Count -eq 1) { return $partial[0] }
    if ($partial.Count -gt 1) {
        Write-Host '  Multiple matches:' -ForegroundColor Yellow
        foreach ($p in $partial) { Write-Host "    - $($p.displayName)" -ForegroundColor Yellow }
    }
    return $null
}

$selected = $null
if ($PolicyName) { $selected = Find-Policy $PolicyName $allPolicies }

while (-not $selected) {
    Write-Host 'Enter the policy name (or number from the list above): ' -ForegroundColor Magenta -NoNewline
    $input_val = Read-Host
    if ($null -eq $input_val) {
        Write-Error 'No input received. Run the script with -PolicyName to skip the prompt.'
        return
    }
    $selected = Find-Policy $input_val.Trim() $allPolicies
    if (-not $selected) { Write-Host '  No match found. Try again.' -ForegroundColor Red }
}

$policyId = $selected.id
$policyName = $selected.displayName
$scriptStartTime = Get-Date
Write-Host "Selected: $policyName ($policyId)" -ForegroundColor Magenta
Write-Host 'Exporting policy settings...' -ForegroundColor Magenta
Write-Host ''

$dvValuesUri = "$graphBase/deviceManagement/groupPolicyConfigurations/$policyId/definitionValues"
$definitionValues = Invoke-GraphGetAll $dvValuesUri

if ($null -eq $definitionValues -or $definitionValues.Count -eq 0) {
    Write-Host 'Policy has no configured settings.' -ForegroundColor Yellow
    return
}

Write-Host '  Two Graph GETs per setting (definition + presentation). Pauses are often the SDK waiting on Intune; use -SlowGraphCallNoticeSeconds 0 to hide slow-call lines.' -ForegroundColor DarkGray

$exportedSettings = [System.Collections.Generic.List[object]]::new()
$settingNum = 0

foreach ($dv in $definitionValues) {
    $settingNum++
    $dvId = [string](Get-GraphProp -Object $dv -Name 'id')

    $definition = Invoke-GraphRequestWithRetry -RequestUri "$dvValuesUri/$dvId/definition" -SlowRequestNoticeSeconds $SlowGraphCallNoticeSeconds

    Write-Host "  [$settingNum/$($definitionValues.Count)] $(Get-GraphProp -Object $definition -Name 'displayName')" -ForegroundColor Gray

    $presResp = Invoke-GraphRequestWithRetry -RequestUri "$dvValuesUri/$dvId/presentationValues?`$expand=presentation" -SlowRequestNoticeSeconds $SlowGraphCallNoticeSeconds

    $presItems = Get-GraphODataValueCollection $presResp
    $exportedSettings.Add((New-ExportedSetting -Dv $dv -Definition $definition -PresItems $presItems))

    if ($BetweenSettingDelayMs -gt 0) {
        Start-Sleep -Milliseconds $BetweenSettingDelayMs
    }
}

# -- Build export envelope ----------------------------------------------------

$envelope = [ordered]@{
    'schemaVersion'     = 1
    'policyDisplayName' = $policyName
    'policyDescription' = if ($selected.description) { $selected.description } else { '' }
    'exportDate'        = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ')
    'settingCount'      = $exportedSettings.Count
    'settings'          = @($exportedSettings)
}

# -- Write JSON ---------------------------------------------------------------

$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Definition }
$exportDir = Join-Path $scriptDir 'Exports'
if (-not (Test-Path $exportDir)) { New-Item -ItemType Directory -Path $exportDir -Force | Out-Null }

$invalidChars = [regex]::Escape([string]::new([IO.Path]::GetInvalidFileNameChars()))
$safeName = [regex]::Replace($policyName, "[$invalidChars]", '_')
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$outPath = Join-Path $exportDir "${safeName}_${timestamp}.json"

$envelope | ConvertTo-Json -Depth 20 | Out-File -LiteralPath $outPath -Encoding utf8
$runSeconds = [int][math]::Floor(((Get-Date) - $scriptStartTime).TotalSeconds)
Write-Host ''
$secWord = if ($runSeconds -eq 1) { 'second' } else { 'seconds' }
Write-Host "  Export complete: $($exportedSettings.Count) settings ($runSeconds $secWord)" -ForegroundColor Green
Write-Host "  File: $outPath" -ForegroundColor Green
Write-Host ''
