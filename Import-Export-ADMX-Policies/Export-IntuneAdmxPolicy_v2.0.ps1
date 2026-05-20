#Requires -Version 5.1
#Requires -Modules Microsoft.Graph.Authentication
<#
.SYNOPSIS
    Exports Intune Administrative Template (ADMX-backed) policies to JSON. With no parameters,
    after each export the policy list is shown again; enter Q to quit. Any bound parameter runs one export then exits.
.DESCRIPTION
    Connects to Microsoft Graph via interactive browser sign-in, lists all
    Administrative Template policies, lets you pick one by friendly name,
    then exports every configured setting — including stable identifiers
    (categoryPath, displayName, classType) that survive ADMX delete/re-upload.

    The exported JSON can be re-imported by Import-IntuneAdmxPolicy.ps1 even
    after the ADMX namespaces have been deleted and re-uploaded with new GUIDs.

    With no parameters, after each export you can pick another policy or Q to quit (repeat menu).
    If you pass any parameter (e.g. -PolicyName or -DelayMillisecondsBetweenSettings), the script runs a single export and exits.

    No command-line parameters are required for interactive use in VS Code;
    just Run/Debug with the default configuration.
.PARAMETER PolicyName
    Display name (or partial match) of the policy to export.  When omitted,
    the script lists all policies and prompts for selection by name or number.
.NOTES
    Requires the Microsoft.Graph.Authentication module:
      Install-Module Microsoft.Graph.Authentication -Scope CurrentUser

    Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0).
    https://creativecommons.org/licenses/by-sa/4.0/
.EXAMPLE
    .\Export-IntuneAdmxPolicy_v2.0.ps1
    Interactive run — lists policies; after each export the list appears again until you enter Q.
.EXAMPLE
    .\Export-IntuneAdmxPolicy_v2.0.ps1 -PolicyName 'Firefox'
    Single export: auto-selects the policy whose name contains 'Firefox' (if unique match), then exits.
.EXAMPLE
    .\Export-IntuneAdmxPolicy_v2.0.ps1 -PolicyName 'Firefox' -DelayMillisecondsBetweenSettings 150
    Single export with 150ms delay between settings (no repeat menu).
.PARAMETER DelayMillisecondsBetweenSettings
    Optional delay after each setting is exported. Use 100–300 if you still see HTTP 429
    (ThrottledByInfra) after other mitigations.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$PolicyName,

    [Parameter(Mandatory = $false)]
    [ValidateRange(0, 600000)]
    [int]$DelayMillisecondsBetweenSettings = 0
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
Clear-Host

# Repeat policy list after each export only when the script is invoked with no bound parameters.
$allowRepeatMenu = ($PSBoundParameters.Count -eq 0)

# Full base URL for odata.bind values in exported JSON (import expects canonical https URLs).
$graphJsonBase = 'https://graph.microsoft.com/beta'
# Relative API root for Invoke-MgGraphRequest GETs (avoids "Invalid URI" with some SDK + Set-MgRequestContext combinations).
$graphApiRoot = '/beta'

# ── Connect to Microsoft Graph ───────────────────────────────────────────────

$requiredScopes = @('DeviceManagementConfiguration.Read.All')

function Connect-WithFallback([string[]]$Scopes) {
    try {
        Connect-MgGraph -Scopes $Scopes -NoWelcome -ErrorAction Stop
    } catch {
        Write-Information 'Browser popup failed, trying with WAM disabled...'
        $env:MSAL_INTERACTIVE_BROWSER_DISABLE_WAM = '1'
        try {
            Connect-MgGraph -Scopes $Scopes -NoWelcome -ErrorAction Stop
        } catch {
            Write-Information 'Browser still unavailable, falling back to device-code flow...'
            Write-Information '  (You will need to open a browser and enter a code)'
            Connect-MgGraph -Scopes $Scopes -NoWelcome -UseDeviceCode -ContextScope Process
        }
    }
}

function Get-TenantDisplayName {
    try {
        $org = Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/organization' -ErrorAction Stop
        if ($org.value -and $org.value.Count -gt 0) { return $org.value[0].displayName }
    } catch { }
    return $null
}

function Get-SafeProperty($obj, [string]$name, $default = $null) {
    if ($null -eq $obj) { return $default }
    if ($obj -is [System.Collections.IDictionary]) {
        if ($obj.Contains($name)) { return $obj[$name] }
        return $default
    }
    $prop = $obj.PSObject.Properties[$name]
    if ($prop) { return $prop.Value }
    return $default
}

function Expand-ODataValue([object]$values) {
    $out = [System.Collections.Generic.List[object]]::new()
    if ($null -eq $values) { return $out }
    if ($values -is [string]) { $out.Add($values); return $out }
    if ($values -is [System.Array]) {
        foreach ($item in $values) { if ($null -ne $item) { $out.Add($item) } }
        return $out
    }
    # Invoke-MgGraphRequest may return Newtonsoft JObject, JsonElement, etc. Some implement IList
    # with one entry per JSON property (e.g. 5 keys -> 5 bogus "rows"). JSON round-trip yields
    # normal PSCustomObject or Object[] that enumerate correctly.
    try {
        $json = $values | ConvertTo-Json -Depth 100 -Compress -ErrorAction Stop
        $round = $json | ConvertFrom-Json -ErrorAction Stop
        if ($round -is [System.Array]) {
            foreach ($item in $round) { if ($null -ne $item) { $out.Add($item) } }
        } else {
            $out.Add($round)
        }
    } catch {
        $out.Add($values)
    }
    return $out
}

function Test-IsLikelyGraphThrottleError([System.Management.Automation.ErrorRecord]$err) {
    $text = $err.Exception.Message
    $inner = $err.Exception.InnerException
    if ($inner) { $text += ' ' + $inner.Message }
    if ($text -match 'TooManyRequests|429|Throttled|ThrottledByInfra|too many retries') { return $true }
    return $false
}

function ConvertTo-GraphRequestUri([string]$UriOrUrl) {
    if ([string]::IsNullOrWhiteSpace($UriOrUrl)) {
        throw 'ConvertTo-GraphRequestUri: Uri is empty.'
    }
    $s = $UriOrUrl.Trim()
    if ($s.StartsWith('/')) {
        return $s
    }
    if ($s -match '^https?://') {
        try {
            $u = [System.Uri]$s
            $pq = $u.PathAndQuery
            if ([string]::IsNullOrWhiteSpace($pq)) {
                throw "URI has no path: $s"
            }
            return $pq
        } catch {
            throw "Invalid Graph URI: $s - $($_.Exception.Message)"
        }
    }
    return $s
}

function Get-GraphRetryAfterSeconds([System.Management.Automation.ErrorRecord]$err) {
    $defaultSec = 60
    $ex = $err.Exception
    while ($null -ne $ex) {
        try {
            $respProp = $ex.GetType().GetProperty('Response')
            if ($respProp) {
                $resp = $respProp.GetValue($ex)
                if ($null -ne $resp -and $resp.Headers) {
                    $ra = $resp.Headers.RetryAfter
                    if ($null -ne $ra -and $null -ne $ra.Delta) {
                        $s = [int][math]::Ceiling($ra.Delta.TotalSeconds)
                        if ($s -gt 0 -and $s -le 600) { return $s }
                    }
                }
            }
        } catch { }
        $ex = $ex.InnerException
    }
    $msg = $err.Exception.Message
    if ($msg -match 'Retry-After[:\s"]+(\d+)') {
        $s = [int]$Matches[1]
        if ($s -gt 0 -and $s -le 600) { return $s }
    }
    return $defaultSec
}

function Invoke-GraphGetWithThrottleRecovery {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$RequestUri,

        [Parameter(Mandatory = $false)]
        [int]$MaxOuterAttempts = 4
    )
    $reqUri = ConvertTo-GraphRequestUri $RequestUri
    $attempt = 0
    while ($true) {
        $attempt++
        try {
            return Invoke-MgGraphRequest -Method GET -Uri $reqUri -ErrorAction Stop
        } catch {
            if (-not (Test-IsLikelyGraphThrottleError $_)) { throw }
            if ($attempt -ge $MaxOuterAttempts) { throw }
            $sec = Get-GraphRetryAfterSeconds $_
            Write-Information "  Graph throttled; waiting ${sec}s before retry (attempt $attempt/$MaxOuterAttempts)..."
            Start-Sleep -Seconds $sec
        }
    }
}

function Show-TenantAndConfirm([string[]]$Scopes) {
    $ctx = Get-MgContext -ErrorAction SilentlyContinue
    $tenantName = Get-TenantDisplayName
    $tenantLabel = if ($tenantName) { $tenantName } else { $ctx.TenantId }
    Write-Host ''
    Write-Host '  Connected to Microsoft Graph' -ForegroundColor Cyan
    Write-Host "  Account: $($ctx.Account)" -ForegroundColor White
    Write-Host "  Tenant:  $tenantLabel" -ForegroundColor White
    Write-Host ''
    Write-Host '  [1] Continue with this tenant' -ForegroundColor White
    Write-Host '  [2] Switch to a different tenant (disconnect & re-auth)' -ForegroundColor White
    $choice = Read-Host '  Select (1/2)'
    if ($choice -eq '2') {
        Write-Information 'Disconnecting...'
        Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
        Connect-WithFallback $Scopes
        Show-TenantAndConfirm $Scopes
    }
}

$ctx = Get-MgContext -ErrorAction SilentlyContinue
if ($null -eq $ctx) {
    Write-Information 'Connecting to Microsoft Graph...'
    Connect-WithFallback $requiredScopes
} else {
    $hasRead  = $ctx.Scopes -contains 'DeviceManagementConfiguration.Read.All'
    $hasWrite = $ctx.Scopes -contains 'DeviceManagementConfiguration.ReadWrite.All'
    if (-not $hasRead -and -not $hasWrite) {
        Write-Information 'Re-connecting with required scopes...'
        Connect-WithFallback $requiredScopes
    }
}
Show-TenantAndConfirm $requiredScopes

# SDK default is MaxRetry 3. Optional (run manually if you still see HTTP 429):
#   Set-MgRequestContext -MaxRetry 10 -RetryDelay 5
# Omitting it here: some Microsoft.Graph.Authentication builds throw "Invalid URI" on GETs after Set-MgRequestContext when using absolute Graph URLs.

# ── Helper: paginated GET ────────────────────────────────────────────────────

function Invoke-GraphGetAll([string]$Uri, [string]$ProgressActivity) {
    $results = [System.Collections.Generic.List[object]]::new()
    $url = [string]$Uri
    if ([string]::IsNullOrWhiteSpace($url)) {
        throw 'Invoke-GraphGetAll: Uri parameter is empty.'
    }
    $pageNum = 0
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    do {
        $pageNum++
        $resp = Invoke-GraphGetWithThrottleRecovery -RequestUri $url
        $values = Get-SafeProperty $resp 'value'
        if ($values) {
            foreach ($item in (Expand-ODataValue $values)) { $results.Add($item) }
        }
        $nextLink = Get-SafeProperty $resp '@odata.nextLink'
        $url = if ($null -ne $nextLink -and -not [string]::IsNullOrWhiteSpace([string]$nextLink)) {
            [string]$nextLink
        } else {
            $null
        }

        if ($ProgressActivity) {
            $status = "$($results.Count) items loaded (page $pageNum, $([math]::Round($sw.Elapsed.TotalSeconds))s)"
            Write-Progress -Activity $ProgressActivity -Status $status
        }
    } while ($url)

    if ($ProgressActivity) { Write-Progress -Activity $ProgressActivity -Completed }
    return $results
}

# ── List all Administrative Template policies ────────────────────────────────

Write-Information 'Retrieving Administrative Template policies...'
$allPolicies = Invoke-GraphGetAll "${graphApiRoot}/deviceManagement/groupPolicyConfigurations" -ProgressActivity 'Loading Administrative Template policies'

if ($allPolicies.Count -eq 0) {
    Write-Warning 'No Administrative Template policies found in this tenant.'
    return
}

function Show-AdministrativeTemplatePolicyList {
    param(
        [Parameter(Mandatory = $true)]
        [object[]]$Policies,

        [Parameter(Mandatory = $false)]
        [switch]$IncludeQuit
    )
    Write-Host ''
    Write-Host '  Administrative Template Policies' -ForegroundColor Cyan
    Write-Host '  ================================' -ForegroundColor Cyan
    for ($i = 0; $i -lt $Policies.Count; $i++) {
        Write-Host "  [$($i + 1)] $($Policies[$i].displayName)" -ForegroundColor White
    }
    if ($IncludeQuit) {
        Write-Host '  [Q]  Quit' -ForegroundColor Yellow
    }
    Write-Host ''
}

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
        Write-Host '  Multiple matches — enter a number from the list to select:' -ForegroundColor Yellow
        foreach ($p in $partial) { Write-Host "    - $($p.displayName)" -ForegroundColor Yellow }
    }
    return $null
}

function Invoke-AdmxPolicyExport {
    param(
        [Parameter(Mandatory = $true)]
        $Selected,

        [Parameter(Mandatory = $false)]
        [int]$DelayMs = 0
    )
    $policyId = $Selected.id
    $policyName = $Selected.displayName
    Write-Information "Selected: $policyName ($policyId)"

    $exportStopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    Write-Information 'Exporting policy settings...'

    $definitionValues = Invoke-GraphGetAll `
        "${graphApiRoot}/deviceManagement/groupPolicyConfigurations/$policyId/definitionValues" `
        -ProgressActivity 'Loading definition values'

    if ($definitionValues.Count -eq 0) {
        $exportStopwatch.Stop()
        $settingsPhaseSec = [math]::Round($exportStopwatch.Elapsed.TotalSeconds, 1)
        Write-Warning "Policy has no configured settings (${settingsPhaseSec}s)."
        return 'NoSettings'
    }

    $exportedSettings = [System.Collections.Generic.List[object]]::new()
    $skipCount = 0
    $warnings  = [System.Collections.Generic.List[string]]::new()

    for ($i = 0; $i -lt $definitionValues.Count; $i++) {
        $dv = $definitionValues[$i]
        $settingLabel = "Setting $($i + 1)/$($definitionValues.Count)"

        try {
            $dvId = Get-SafeProperty $dv 'id'
            if (-not $dvId) {
                $objType = if ($null -eq $dv) { 'null' } else { $dv.GetType().FullName }
                $objProps = ''
                if ($null -ne $dv) {
                    if ($dv -is [System.Collections.IDictionary]) {
                        $objProps = ($dv.Keys | Select-Object -First 10) -join ', '
                    } else {
                        $objProps = ($dv.PSObject.Properties | Select-Object -First 10 -ExpandProperty Name) -join ', '
                    }
                }
                throw "definitionValue has no id (type: $objType; keys: $objProps)"
            }

            $definition = Invoke-GraphGetWithThrottleRecovery -RequestUri `
                "${graphApiRoot}/deviceManagement/groupPolicyConfigurations/$policyId/definitionValues/$dvId/definition"

            $defId    = Get-SafeProperty $definition 'id' ''
            $defName  = Get-SafeProperty $definition 'displayName' '(unknown)'
            $defPath  = Get-SafeProperty $definition 'categoryPath' ''
            $defClass = Get-SafeProperty $definition 'classType' ''

            $settingLabel = "$defPath > $defName"
            Write-Host "  [$($i + 1)/$($definitionValues.Count)] $defName" -ForegroundColor Gray

            $presResp = Invoke-GraphGetWithThrottleRecovery -RequestUri `
                "${graphApiRoot}/deviceManagement/groupPolicyConfigurations/$policyId/definitionValues/$dvId/presentationValues?`$expand=presentation"

            $presValues = @()
            $presRespValue = Get-SafeProperty $presResp 'value'
            $presItems = @(Expand-ODataValue $presRespValue)
            if ($presItems.Count -gt 0) {
                $presValues = foreach ($pv in $presItems) {
                    $pres = Get-SafeProperty $pv 'presentation'
                    $presLabel = if ($pres) { Get-SafeProperty $pres 'label' '' } else { '' }
                    $presId    = if ($pres) { Get-SafeProperty $pres 'id' '' }    else { '' }
                    $entry = [ordered]@{
                        '@odata.type'          = Get-SafeProperty $pv '@odata.type' ''
                        'presentationLabel'    = $presLabel
                        'presentationId'       = $presId
                        'presentation@odata.bind' = "$graphJsonBase/deviceManagement/groupPolicyDefinitions('$defId')/presentations('$presId')"
                    }
                    $pvValue  = Get-SafeProperty $pv 'value'
                    $pvValues = Get-SafeProperty $pv 'values'
                    if ($null -ne $pvValue)  { $entry['value']  = $pvValue }
                    if ($null -ne $pvValues) { $entry['values'] = $pvValues }
                    $entry
                }
            }

            $setting = [ordered]@{
                'enabled'                 = Get-SafeProperty $dv 'enabled' $true
                'definitionDisplayName'   = $defName
                'definitionCategoryPath'  = $defPath
                'definitionClassType'     = $defClass
                'definitionId'            = $defId
                'definition@odata.bind'   = "$graphJsonBase/deviceManagement/groupPolicyDefinitions('$defId')"
            }
            if ($presValues.Count -gt 0) {
                $setting['presentationValues'] = @($presValues)
            }
            $exportedSettings.Add($setting)

        } catch {
            $baseMsg = $_.Exception.Message
            $msg = "FAILED: $settingLabel - $baseMsg"
            if (Test-IsLikelyGraphThrottleError $_) {
                $msg += ' If this was throttling, re-run with -DelayMillisecondsBetweenSettings 150 (or higher) or try off-peak.'
            }
            Write-Host "  [$($i + 1)/$($definitionValues.Count)] $msg" -ForegroundColor Red
            $warnings.Add($msg)
            $skipCount++
        }

        if ($DelayMs -gt 0) {
            Start-Sleep -Milliseconds $DelayMs
        }

        Write-Progress -Activity 'Exporting settings' `
            -Status "$($i + 1) of $($definitionValues.Count)" `
            -PercentComplete ([math]::Round(($i + 1) / $definitionValues.Count * 100))
    }
    Write-Progress -Activity 'Exporting settings' -Completed

    $exportStopwatch.Stop()
    $settingsPhaseSec = [math]::Round($exportStopwatch.Elapsed.TotalSeconds, 1)

    $exportDate = [DateTimeOffset]::Now.ToString('yyyy-MM-ddTHH:mm:sszzz')

    $envelope = [ordered]@{
        'schemaVersion'    = 1
        'policyDisplayName' = $policyName
        'policyDescription' = if ($Selected.description) { $Selected.description } else { '' }
        'exportDate'       = $exportDate
        'settingCount'     = $exportedSettings.Count
        'settings'         = @($exportedSettings)
    }

    $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } elseif ($PSCommandPath) { Split-Path -Parent $PSCommandPath } else { $null }
    if (-not $scriptDir) { throw 'Cannot resolve script directory (PSScriptRoot / PSCommandPath).' }
    $exportDir = Join-Path $scriptDir 'Exports'
    if (-not (Test-Path $exportDir)) { New-Item -ItemType Directory -Path $exportDir -Force | Out-Null }

    $invalidChars = [regex]::Escape([string]::new([IO.Path]::GetInvalidFileNameChars()))
    $safeName = [regex]::Replace($policyName, "[$invalidChars]", '_')
    $timestamp = Get-Date -Format 'yyyy-MM-dd-HHmm'
    $outPath = Join-Path $exportDir "${safeName}_${timestamp}.json"

    $json = $envelope | ConvertTo-Json -Depth 20
    [System.IO.File]::WriteAllText($outPath, $json, [System.Text.UTF8Encoding]::new($false))

    Write-Host ''
    Write-Host "  Time (policy selected → last setting): ${settingsPhaseSec}s" -ForegroundColor DarkGray
    Write-Host "  Export complete: $($exportedSettings.Count) settings" -ForegroundColor Green
    if ($skipCount -gt 0) {
        Write-Host "  Skipped:  $skipCount settings" -ForegroundColor Yellow
    }
    Write-Host "  File: $outPath" -ForegroundColor Green
    if ($warnings.Count -gt 0) {
        Write-Host ''
        Write-Host '  Warnings:' -ForegroundColor Yellow
        foreach ($w in $warnings) {
            Write-Host "    - $w" -ForegroundColor Yellow
        }
    }
    Write-Host ''
}

if ($allowRepeatMenu) {
    do {
        Show-AdministrativeTemplatePolicyList -Policies $allPolicies -IncludeQuit
        $input_val = Read-Host 'Enter policy number or name (or Q to quit)'
        if ($null -eq $input_val) {
            Write-Warning 'No input — enter a selection or Q to quit.'
            continue
        }
        $trim = $input_val.Trim()
        if ($trim -match '^[qQ]$') { break }
        if ([string]::IsNullOrWhiteSpace($trim)) {
            Write-Warning 'Empty input — try again or Q to quit.'
            continue
        }
        $selected = Find-Policy $trim $allPolicies
        if (-not $selected) {
            Write-Host '  No match found. Try again.' -ForegroundColor Red
            continue
        }
        if ((Invoke-AdmxPolicyExport -Selected $selected -DelayMs $DelayMillisecondsBetweenSettings) -eq 'NoSettings') {
            continue
        }
    } while ($true)
    return
}

$selected = $null
if ($PolicyName) { $selected = Find-Policy $PolicyName $allPolicies }

Show-AdministrativeTemplatePolicyList -Policies $allPolicies

while (-not $selected) {
    $input_val = Read-Host 'Enter the policy name (or number from the list above)'
    if ($null -eq $input_val) {
        Write-Error 'No input received. Run the script with -PolicyName to skip the prompt.'
        return
    }
    $selected = Find-Policy $input_val.Trim() $allPolicies
    if (-not $selected) { Write-Host '  No match found. Try again.' -ForegroundColor Red }
}

if ((Invoke-AdmxPolicyExport -Selected $selected -DelayMs $DelayMillisecondsBetweenSettings) -eq 'NoSettings') { return }
