#Requires -Version 5.1
#Requires -Modules Microsoft.Graph.Authentication
<#
.SYNOPSIS
    Imports an Intune Administrative Template (ADMX-backed) policy from JSON (v2).
.DESCRIPTION
    Same behaviour as Import-IntuneAdmxPolicy.ps1, aligned with Export-IntuneAdmxPolicy_v2.ps1:
    - Clears the host at startup; coloured host output for main phases.
    - Throttling-safe Graph requests (429 / ThrottledByInfra) via Invoke-GraphRequestWithRetry for GET and POST.
    - GETs use path-only URIs (/beta/...); POST bodies still use full https://... odata.bind strings from JSON.
    - Optional -SlowGraphCallNoticeSeconds (default 5) and -BetweenSettingDelayMs (default 0).

    Re-creates a policy exported by Export-IntuneAdmxPolicy.ps1 or Export-IntuneAdmxPolicy_v2.ps1 using stable
    identifiers (categoryPath, displayName, classType) so import survives ADMX re-upload with new GUIDs.
.NOTES
    Requires the Microsoft.Graph.Authentication module:
      Install-Module Microsoft.Graph.Authentication -Scope CurrentUser

    Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0).
    https://creativecommons.org/licenses/by-sa/4.0/
.EXAMPLE
    .\Import-IntuneAdmxPolicy_v2.ps1
.EXAMPLE
    .\Import-IntuneAdmxPolicy_v2.ps1 -FilePath '.\Exports\MyPolicy_20260101-120000.json' -PolicyName 'Restored Policy'
.EXAMPLE
    .\Import-IntuneAdmxPolicy_v2.ps1 -SlowGraphCallNoticeSeconds 0
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$FilePath,

    [Parameter(Mandatory = $false)]
    [string]$PolicyName,

    [Parameter(Mandatory = $false)]
    [ValidateRange(0, 600000)]
    [int]$BetweenSettingDelayMs = 0,

    [Parameter(Mandatory = $false)]
    [ValidateRange(0, 120)]
    [int]$SlowGraphCallNoticeSeconds = 5
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$graphBase = 'https://graph.microsoft.com/beta'

Clear-Host

# -- Connect to Microsoft Graph -----------------------------------------------

$requiredScopes = @('DeviceManagementConfiguration.ReadWrite.All')

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
        [ValidateSet('GET', 'POST')]
        [string]$Method = 'GET',
        [string]$Body,
        [string]$ContentType = 'application/json',
        [int]$MaxAttempts = 12,
        [ValidateRange(0, 120)]
        [int]$SlowRequestNoticeSeconds = 0
    )
    $invokeUri = ConvertTo-MgGraphRelativeUri $RequestUri
    if ($Method -eq 'POST' -and [string]::IsNullOrWhiteSpace($Body)) {
        throw 'Invoke-GraphRequestWithRetry: POST requires a Body.'
    }
    $attempt = 0
    while ($true) {
        $attempt++
        try {
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            if ($Method -eq 'POST') {
                $respObj = Invoke-MgGraphRequest -Method POST -Uri $invokeUri -Body $Body -ContentType $ContentType -ErrorAction Stop
            } else {
                $respObj = Invoke-MgGraphRequest -Method GET -Uri $invokeUri -ErrorAction Stop
            }
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
        $resp = Invoke-GraphRequestWithRetry -RequestUri $url -Method GET -SlowRequestNoticeSeconds $SlowGraphCallNoticeSeconds
        foreach ($item in (Get-GraphODataValueCollection $resp)) {
            $results.Add($item)
        }
        $next = [string](Get-GraphProp -Object $resp -Name '@odata.nextLink')
        $url = if ([string]::IsNullOrWhiteSpace($next)) { $null } else { (ConvertTo-MgGraphRelativeUri $next) }
    } while ($url)
    return $results
}

# -- Select JSON file ---------------------------------------------------------

function Select-JsonFile {
    $filePath = $null
    try {
        Add-Type -AssemblyName System.Windows.Forms
        $dlg = [System.Windows.Forms.OpenFileDialog]::new()
        $dlg.Title  = 'Select exported ADMX policy JSON'
        $dlg.Filter = 'JSON files (*.json)|*.json|All files (*.*)|*.*'

        $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Definition }
        $exportsDir = Join-Path $scriptDir 'Exports'
        if (Test-Path $exportsDir) { $dlg.InitialDirectory = $exportsDir }

        if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $filePath = $dlg.FileName
        }
    } catch {
        Write-Verbose 'File dialog unavailable, falling back to manual input.'
    }

    if (-not $filePath) {
        Write-Host 'Paste the full path to the JSON file: ' -ForegroundColor Magenta -NoNewline
        $filePath = (Read-Host).Trim().Trim('"')
    }
    return $filePath
}

Write-Host 'Select JSON to import (dialog or path)...' -ForegroundColor Cyan

if ($FilePath) {
    $jsonPath = $FilePath
} else {
    $jsonPath = Select-JsonFile
}
if (-not $jsonPath -or -not (Test-Path -LiteralPath $jsonPath)) {
    Write-Host "File not found: $jsonPath" -ForegroundColor Yellow
    Write-Error "File not found: $jsonPath"
    return
}
Write-Host "Loading: $jsonPath" -ForegroundColor Magenta

# -- Load and validate JSON ---------------------------------------------------

$raw = Get-Content -LiteralPath $jsonPath -Raw -Encoding utf8 | ConvertFrom-Json

if (-not $raw.policyDisplayName -or -not $raw.settings) {
    Write-Host 'Invalid export file - missing policyDisplayName or settings array.' -ForegroundColor Yellow
    Write-Error 'Invalid export file - missing policyDisplayName or settings array.'
    return
}

if ($PolicyName) {
    $policyName = $PolicyName
    Write-Host "Using custom policy name: $policyName" -ForegroundColor Magenta
} else {
    $policyName = $raw.policyDisplayName
}
$policyDesc = if ($raw.policyDescription) { $raw.policyDescription } else { '' }
$settings   = @($raw.settings)
Write-Host "Policy: $policyName  ($($settings.Count) settings)" -ForegroundColor Magenta

$scriptStartTime = Get-Date

# -- Build definition lookup from tenant -------------------------------------
#    Index by "categoryPath|displayName|classType" -> definition object

Write-Host 'Building definition lookup (this may take a moment for large tenants)...' -ForegroundColor Cyan
$gpDefsUri = "$graphBase/deviceManagement/groupPolicyDefinitions"
$allDefs = Invoke-GraphGetAll $gpDefsUri
Write-Host "  Loaded $($allDefs.Count) definitions from tenant" -ForegroundColor Cyan

$defLookup = @{}
foreach ($d in $allDefs) {
    $key = "$($d.categoryPath)|$($d.displayName)|$($d.classType)"
    $defLookup[$key] = $d
}

# -- Build presentation lookup per definition ---------------------------------
#    Only fetches presentations for definitions we actually need.

function Get-PresentationLookup([string]$definitionId) {
    $presUri = "$graphBase/deviceManagement/groupPolicyDefinitions/$definitionId/presentations"
    $presentations = Invoke-GraphGetAll $presUri
    $lookup = @{}
    foreach ($p in $presentations) {
        $lookup[$p.label] = $p
    }
    return $lookup
}

# -- Create the new policy shell ----------------------------------------------

Write-Host ''
Write-Host "  Creating policy: $policyName" -ForegroundColor Magenta

$policyBody = @{
    displayName = $policyName
    description = $policyDesc
} | ConvertTo-Json

$gcUri = "$graphBase/deviceManagement/groupPolicyConfigurations"
$newPolicy = Invoke-GraphRequestWithRetry -RequestUri $gcUri -Method POST -Body $policyBody -ContentType 'application/json' -SlowRequestNoticeSeconds $SlowGraphCallNoticeSeconds

$newPolicyId = $newPolicy.id
Write-Host "  Policy created: $newPolicyId" -ForegroundColor Magenta

$dvPostUri = "$graphBase/deviceManagement/groupPolicyConfigurations/$newPolicyId/definitionValues"

# -- Import each setting -------------------------------------------------------

$successCount = 0
$skipCount    = 0
$warnings     = [System.Collections.Generic.List[string]]::new()

for ($i = 0; $i -lt $settings.Count; $i++) {
    $s = $settings[$i]
    $settingLabel = "$($s.definitionCategoryPath) > $($s.definitionDisplayName)"

    $lookupKey = "$($s.definitionCategoryPath)|$($s.definitionDisplayName)|$($s.definitionClassType)"
    $newDef = $defLookup[$lookupKey]

    if (-not $newDef) {
        $msg = "SKIPPED: $settingLabel - definition not found in tenant (removed in new ADMX version?)"
        Write-Host "  [$($i+1)/$($settings.Count)] $msg" -ForegroundColor Yellow
        $warnings.Add($msg)
        $skipCount++
        continue
    }

    $newDefId = $newDef.id

    $dvBody = [ordered]@{
        'enabled'              = $s.enabled
        'definition@odata.bind' = "$graphBase/deviceManagement/groupPolicyDefinitions('$newDefId')"
    }

    if ($s.presentationValues -and @($s.presentationValues).Count -gt 0) {
        $presLookup = Get-PresentationLookup $newDefId
        $newPresValues = [System.Collections.Generic.List[object]]::new()

        foreach ($pv in $s.presentationValues) {
            $matchedPres = $null
            if ($pv.presentationLabel) {
                $matchedPres = $presLookup[$pv.presentationLabel]
            }

            if (-not $matchedPres -and $presLookup.Count -eq 1) {
                $matchedPres = $presLookup.Values | Select-Object -First 1
            }

            if (-not $matchedPres) {
                $msg = "WARNING: $settingLabel - could not match presentation '$($pv.presentationLabel)', skipping presentation value"
                Write-Host "    $msg" -ForegroundColor Yellow
                $warnings.Add($msg)
                continue
            }

            $presEntry = [ordered]@{
                '@odata.type'             = $pv.'@odata.type'
                'presentation@odata.bind' = "$graphBase/deviceManagement/groupPolicyDefinitions('$newDefId')/presentations('$($matchedPres.id)')"
            }
            if ($null -ne $pv.value)  { $presEntry['value']  = $pv.value }
            if ($null -ne $pv.values) { $presEntry['values'] = @($pv.values) }

            $newPresValues.Add($presEntry)
        }

        if ($newPresValues.Count -gt 0) {
            $dvBody['presentationValues'] = @($newPresValues)
        }
    }

    try {
        $null = Invoke-GraphRequestWithRetry -RequestUri $dvPostUri -Method POST -Body ($dvBody | ConvertTo-Json -Depth 20) -ContentType 'application/json' -SlowRequestNoticeSeconds $SlowGraphCallNoticeSeconds

        Write-Host "  [$($i+1)/$($settings.Count)] $settingLabel" -ForegroundColor Gray
        $successCount++
    } catch {
        $msg = "FAILED: $settingLabel - $($_.Exception.Message)"
        Write-Host "  [$($i+1)/$($settings.Count)] $msg" -ForegroundColor Red
        $warnings.Add($msg)
        $skipCount++
    }

    if ($BetweenSettingDelayMs -gt 0) {
        Start-Sleep -Milliseconds $BetweenSettingDelayMs
    }
}

$runSeconds = [int][math]::Floor(((Get-Date) - $scriptStartTime).TotalSeconds)
$secWord = if ($runSeconds -eq 1) { 'second' } else { 'seconds' }

# -- Summary ------------------------------------------------------------------

Write-Host ''
Write-Host '  Import Summary' -ForegroundColor Cyan
Write-Host '  ==============' -ForegroundColor Cyan
Write-Host "  Policy:    $policyName" -ForegroundColor White
Write-Host "  Imported:  $successCount settings ($runSeconds $secWord)" -ForegroundColor Green
if ($skipCount -gt 0) {
    Write-Host "  Skipped:   $skipCount settings" -ForegroundColor Yellow
}
if ($warnings.Count -gt 0) {
    Write-Host ''
    Write-Host '  Warnings:' -ForegroundColor Yellow
    foreach ($w in $warnings) {
        Write-Host "    - $w" -ForegroundColor Yellow
    }
}
Write-Host ''
Write-Host '  IMPORTANT: Assign the new policy to your device/user groups in Intune.' -ForegroundColor Magenta
Write-Host '  Group assignments are NOT included in the export.' -ForegroundColor Magenta
Write-Host ''