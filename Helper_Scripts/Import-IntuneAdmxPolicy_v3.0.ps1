#Requires -Version 5.1
#Requires -Modules Microsoft.Graph.Authentication
<#
.SYNOPSIS
    Imports an Intune Administrative Template (ADMX-backed) policy from JSON.
.DESCRIPTION
    Re-creates a policy exported by Export-IntuneAdmxPolicy_v3.0.ps1 (or v2.0). Resolves definition GUIDs via categoryPath, displayName, and classType so import works after ADMX re-upload.
    File-browse dialog (or paste prompt) and policy-name prompt by default; pass -FilePath and/or -PolicyName for non-interactive use. Optional -SettingDelayMs if Graph throttles large imports.
.PARAMETER FilePath
    Path to exported JSON. When omitted, file-browse dialog or paste prompt.
.PARAMETER PolicyName
    Display name for the new policy. When omitted, prompts interactively (exported name is the default).
.NOTES
    Version 3.0 - see CHANGELOG.md. Requires Microsoft.Graph.Authentication (Install-Module -Scope CurrentUser). Scope DeviceManagementConfiguration.ReadWrite.All (shared with Export).
    Licensed CC BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/
.EXAMPLE
    .\Import-IntuneAdmxPolicy_v3.0.ps1
.EXAMPLE
    .\Import-IntuneAdmxPolicy_v3.0.ps1 -FilePath '.\Exports\policy.json' -PolicyName 'Test Import'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$FilePath,

    [Parameter(Mandatory = $false)]
    [string]$PolicyName,

    [Parameter(Mandatory = $false)]
    [int]$SettingDelayMs = 0
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
Clear-Host

# Absolute HTTPS base for odata.bind values in POST bodies (Graph expects canonical URLs).
$graphJsonBase = 'https://graph.microsoft.com/beta'
# Relative API root for Invoke-MgGraphRequest URIs (required for Set-MgRequestContext retry handling).
$graphApiRoot = '/beta'

# Cap silent token refresh attempts per run (403 is never retried).
$script:AuthRefreshCount = 0
$script:MaxAuthRefresh = 3
$script:FullCatalogLoaded = $false

# ── Connect to Microsoft Graph ───────────────────────────────────────────────

$script:requiredScopes = @('DeviceManagementConfiguration.ReadWrite.All')

function Test-GraphSession([string[]]$Scopes) {
    $ctx = Get-MgContext -ErrorAction SilentlyContinue
    if ($null -eq $ctx) { return $false }
    foreach ($scope in $Scopes) {
        if ($ctx.Scopes -notcontains $scope) { return $false }
    }
    return $true
}

function Connect-WithFallback([string[]]$Scopes) {
    try {
        # CurrentUser scope persists the MSAL cache so repeat runs and mid-import refresh stay silent.
        Connect-MgGraph -Scopes $Scopes -NoWelcome -ErrorAction Stop
        return
    } catch {
        Write-Information "Sign-in attempt failed: $($_.Exception.Message)"
    }

    # The SDK can give up while a browser or WAM prompt is still on screen, so a failure does
    # not prove no session was established. Re-check before discarding it and prompting again.
    Write-Information '  Checking for up to 10s in case the sign-in completes...'
    for ($i = 0; $i -lt 5; $i++) {
        Start-Sleep -Seconds 2
        if (Test-GraphSession $Scopes) {
            Write-Information '  Sign-in completed; keeping the established session.'
            return
        }
    }

    Write-Information '  Retrying with WAM disabled...'
    $env:MSAL_INTERACTIVE_BROWSER_DISABLE_WAM = '1'
    try {
        Connect-MgGraph -Scopes $Scopes -NoWelcome -ErrorAction Stop
        return
    } catch {
        Write-Information "  Retry failed: $($_.Exception.Message)"
    }

    Write-Information '  Browser unavailable, falling back to device-code flow...'
    Write-Information '  (You will need to open a browser and enter a code)'
    # Device-code flow keeps process scope so the token is not persisted to disk.
    Connect-MgGraph -Scopes $Scopes -NoWelcome -UseDeviceCode -ContextScope Process
}

function Get-TenantDisplayName {
    try {
        $org = Invoke-MgGraphRequest -Method GET -Uri '/v1.0/organization' -OutputType PSObject -ErrorAction Stop
        if ($org.value -and $org.value.Count -gt 0) { return $org.value[0].displayName }
    } catch {
        # Best effort only; the caller falls back to showing the tenant GUID.
        Write-Verbose "Tenant name lookup failed: $($_.Exception.Message)"
    }
    return $null
}

function Get-SafeProperty($obj, [string]$name, $default = $null) {
    if ($null -eq $obj) { return $default }
    $prop = $obj.PSObject.Properties[$name]
    if ($prop) { return $prop.Value }
    return $default
}

function Show-TenantAndConfirm([string[]]$Scopes) {
    $ctx = Get-MgContext -ErrorAction SilentlyContinue
    $tenantName = Get-TenantDisplayName
    $tenantLabel = if ($tenantName) { $tenantName } else { $ctx.TenantId }
    $dmScopes = @($ctx.Scopes | Where-Object { $_ -like 'DeviceManagementConfiguration.*' })
    $scopeLabel = if ($dmScopes.Count -gt 0) { $dmScopes -join ', ' } else { '(none listed)' }
    Write-Host ''
    Write-Host '  Connected to Microsoft Graph' -ForegroundColor Cyan
    Write-Host "  Account: $($ctx.Account)" -ForegroundColor White
    Write-Host "  Tenant:  $tenantLabel" -ForegroundColor White
    Write-Host "  Consented scopes (all-time): $scopeLabel" -ForegroundColor White
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

function Write-GraphForbiddenHelp {
    Write-Host ''
    Write-Host '  Graph returned 403 Forbidden on a write operation.' -ForegroundColor Red
    Write-Host '  Reads succeeded, so Intune refused the write; this is not a sign-in problem.' -ForegroundColor Yellow
    Write-Host '  Common causes:' -ForegroundColor Yellow
    Write-Host '    - Account lacks Intune Administrator / Intune Policy Administrator in this tenant' -ForegroundColor Yellow
    Write-Host '    - PIM role not activated' -ForegroundColor Yellow
    Write-Host '    - Wrong tenant selected at the prompt above' -ForegroundColor Yellow
    Write-Host '    - Intune RBAC scope tags exclude this policy type' -ForegroundColor Yellow
    Write-Host '  A role activated in PIM after sign-in is not in the cached token. Activate the role,' -ForegroundColor Yellow
    Write-Host '  then choose [2] on the tenant prompt to get a new token, then retry.' -ForegroundColor Yellow
    Write-Host ''
}

# Reuse an existing Graph session when present. Never disconnect here: Disconnect-MgGraph
# clears the persisted MSAL cache, which forces a fresh sign-in for every later run.
$ctx = Get-MgContext -ErrorAction SilentlyContinue
if ($null -eq $ctx) {
    Write-Information 'Connecting to Microsoft Graph...'
    Connect-WithFallback $script:requiredScopes
} else {
    $missing = $script:requiredScopes | Where-Object { $ctx.Scopes -notcontains $_ }
    if ($missing) {
        Write-Information 'Re-connecting with required scopes...'
        Connect-WithFallback $script:requiredScopes
    }
}
Show-TenantAndConfirm $script:requiredScopes

Set-MgRequestContext -MaxRetry 10 -RetryDelay 5 | Out-Null

function Test-IsLikelyGraphAuthError([System.Management.Automation.ErrorRecord]$err) {
    $text = $err.Exception.Message
    $inner = $err.Exception.InnerException
    if ($inner) { $text += ' ' + $inner.Message }
    # 403 is permissions denied, not an expired token.
    if ($text -match '\b403\b|Forbidden') { return $false }
    if ($text -match '401|Unauthorized|Authentication|InvalidAuthenticationToken|token has expired|Lifetime validation failed') { return $true }
    return $false
}

function ConvertTo-GraphRequestUri([string]$UriOrUrl) {
    if ([string]::IsNullOrWhiteSpace($UriOrUrl)) {
        throw 'ConvertTo-GraphRequestUri: Uri is empty.'
    }
    $s = $UriOrUrl.Trim()
    if ($s.StartsWith('/')) { return $s }
    if ($s -match '^https?://') {
        try {
            $u = [System.Uri]$s
            $pq = $u.PathAndQuery
            if ([string]::IsNullOrWhiteSpace($pq)) { throw "URI has no path: $s" }
            return $pq
        } catch {
            throw "Invalid Graph URI: $s - $($_.Exception.Message)"
        }
    }
    return $s
}

function Invoke-GraphRequestWithRecovery {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('GET', 'POST')]
        [string]$Method,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$RequestUri,

        [Parameter(Mandatory = $false)]
        [string]$Body,

        [Parameter(Mandatory = $false)]
        [string]$ContentType = 'application/json'
    )
    $reqUri = ConvertTo-GraphRequestUri $RequestUri
    while ($true) {
        try {
            if ($Method -eq 'GET') {
                return Invoke-MgGraphRequest -Method GET -Uri $reqUri -OutputType PSObject -ErrorAction Stop
            }
            return Invoke-MgGraphRequest -Method POST -Uri $reqUri -Body $Body -ContentType $ContentType -OutputType PSObject -ErrorAction Stop
        } catch {
            if ((Test-IsLikelyGraphAuthError $_) -and $script:AuthRefreshCount -lt $script:MaxAuthRefresh) {
                $script:AuthRefreshCount++
                Write-Information "  Graph token may have expired; silent refresh ($script:AuthRefreshCount/$script:MaxAuthRefresh)..."
                Connect-MgGraph -Scopes $script:requiredScopes -NoWelcome -ErrorAction Stop
                continue
            }
            throw
        }
    }
}

function Invoke-GraphGetAll([string]$Uri, [string]$ProgressActivity) {
    $results = [System.Collections.Generic.List[object]]::new()
    $url = ConvertTo-GraphRequestUri $Uri
    if ([string]::IsNullOrWhiteSpace($url)) {
        throw 'Invoke-GraphGetAll: Uri parameter is empty.'
    }
    $pageNum = 0
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    do {
        $pageNum++
        $resp = Invoke-GraphRequestWithRecovery -Method GET -RequestUri $url
        $values = Get-SafeProperty $resp 'value'
        if ($values) {
            foreach ($item in @($values)) { $results.Add($item) }
        }
        $nextLink = Get-SafeProperty $resp '@odata.nextLink'
        $url = if ($nextLink) { ConvertTo-GraphRequestUri ([string]$nextLink) } else { $null }

        if ($ProgressActivity) {
            $status = "$($results.Count) items loaded (page $pageNum, $([math]::Round($sw.Elapsed.TotalSeconds))s)"
            Write-Progress -Activity $ProgressActivity -Status $status
        }
    } while ($url)

    if ($ProgressActivity) { Write-Progress -Activity $ProgressActivity -Completed }
    return $results
}

function Add-DefinitionsToLookup([System.Collections.IDictionary]$Lookup, [object[]]$Definitions) {
    foreach ($d in $Definitions) {
        $key = "$($d.categoryPath)|$($d.displayName)|$($d.classType)"
        if (-not $Lookup.ContainsKey($key)) {
            $Lookup[$key] = $d
        }
    }
}

function Initialize-FullDefinitionCatalog([System.Collections.IDictionary]$Lookup) {
    if ($script:FullCatalogLoaded) { return }
    Write-Information 'Loading full group policy definition catalog (fallback for built-in or unmatched settings)...'
    $allDefs = Invoke-GraphGetAll "$graphApiRoot/deviceManagement/groupPolicyDefinitions" `
        -ProgressActivity 'Loading group policy definitions from tenant'
    Add-DefinitionsToLookup -Lookup $Lookup -Definitions @($allDefs)
    $script:FullCatalogLoaded = $true
    Write-Information "  Catalog merged; lookup now has $($Lookup.Count) definitions"
}

function Resolve-DefinitionForSetting {
    param(
        $Setting,
        [System.Collections.IDictionary]$Lookup
    )
    $lookupKey = "$($Setting.definitionCategoryPath)|$($Setting.definitionDisplayName)|$($Setting.definitionClassType)"
    if ($Lookup.ContainsKey($lookupKey)) {
        return $Lookup[$lookupKey]
    }
    # Lazy fallback: one full catalog fetch covers built-in templates and custom ADMX edge cases.
    Initialize-FullDefinitionCatalog $Lookup
    return $Lookup[$lookupKey]
}

# ── Select JSON file ────────────────────────────────────────────────────────

function Select-JsonFile {
    # Prefer Windows file dialog; fall back to pasted path for headless or remote sessions.
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
        $filePath = (Read-Host 'Paste the full path to the JSON file').Trim().Trim('"')
    }
    return $filePath
}

if ($FilePath) {
    $jsonPath = $FilePath
} else {
    $jsonPath = Select-JsonFile
}
if (-not $jsonPath -or -not (Test-Path -LiteralPath $jsonPath)) {
    Write-Error "File not found: $jsonPath"
    exit 1
}
Write-Information "Loading: $jsonPath"

# ── Load and validate JSON ───────────────────────────────────────────────────

$raw = Get-Content -LiteralPath $jsonPath -Raw -Encoding utf8 | ConvertFrom-Json

$rawPolicyName = Get-SafeProperty $raw 'policyDisplayName'
$rawSettings   = Get-SafeProperty $raw 'settings'

if (-not $rawPolicyName -or -not $rawSettings) {
    Write-Error 'Invalid export file - missing policyDisplayName or settings array.'
    exit 1
}

$policyDesc = [string](Get-SafeProperty $raw 'policyDescription' '')
$settings   = @($rawSettings)

if ($PSBoundParameters.ContainsKey('PolicyName') -and $PolicyName) {
    $policyName = $PolicyName
    Write-Information "Using policy name from parameter: $policyName"
} else {
    $defaultName = $rawPolicyName
    Write-Host ''
    Write-Host '  Enter a display name for the imported policy.' -ForegroundColor Cyan
    Write-Host "  Default (press Enter): $defaultName" -ForegroundColor Gray
    $inputName = Read-Host '  Policy name'
    $policyName = if ($inputName.Trim()) { $inputName.Trim() } else { $defaultName }
}
Write-Information "Policy: $policyName  ($($settings.Count) settings)"

$importStopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# ── Build definition lookup from tenant (custom ADMX first) ─────────────────

$defLookup = @{}
$customUri = "$graphApiRoot/deviceManagement/groupPolicyCategories" +
    "?`$expand=definitions(`$select=id,displayName,categoryPath,classType)" +
    "&`$select=id,displayName" +
    "&`$filter=ingestionSource eq 'custom'"

Write-Information 'Loading custom ADMX definitions from tenant...'
try {
    $customCategories = Invoke-GraphGetAll $customUri -ProgressActivity 'Loading custom ADMX definitions'
    foreach ($cat in $customCategories) {
        $catDefs = Get-SafeProperty $cat 'definitions'
        if ($catDefs) {
            Add-DefinitionsToLookup -Lookup $defLookup -Definitions @($catDefs)
        }
    }
    Write-Information "  Loaded $($defLookup.Count) custom definition(s)"
} catch {
    Write-Information "  Custom definition fetch failed ($($_.Exception.Message)); full catalog will load on first miss."
}

# ── Build presentation lookup per definition ─────────────────────────────────
#    Label match first, then positional index (handles blank labels e.g. Firefox).

$script:PresentationCache = @{}

function Get-PresentationLookup([string]$definitionId) {
    if ($script:PresentationCache.ContainsKey($definitionId)) {
        return $script:PresentationCache[$definitionId]
    }
    $presentations = Invoke-GraphGetAll "$graphApiRoot/deviceManagement/groupPolicyDefinitions/$definitionId/presentations"
    $byLabel = @{}
    foreach ($p in $presentations) {
        $lbl = Get-SafeProperty $p 'label'
        if ($null -ne $lbl -and $lbl -ne '') {
            $byLabel[$lbl] = $p
        }
    }
    $ordered = @($presentations)
    $info = [pscustomobject]@{
        ByLabel = $byLabel
        Ordered = $ordered
    }
    $script:PresentationCache[$definitionId] = $info
    return $info
}

# ── Create policy and POST each definitionValue ───────────────────────────────

Write-Host ''
Write-Host "  Creating policy: $policyName" -ForegroundColor Cyan

$policyBody = @{
    displayName = $policyName
    description = $policyDesc
} | ConvertTo-Json

$newPolicyId = $null

try {
    $newPolicy = Invoke-GraphRequestWithRecovery -Method POST `
        -RequestUri "$graphApiRoot/deviceManagement/groupPolicyConfigurations" `
        -Body $policyBody -ContentType 'application/json'
    $newPolicyId = $newPolicy.id
    Write-Information "  Policy created: $newPolicyId"
} catch {
    if ($_.Exception.Message -match '\b403\b|Forbidden') {
        Write-GraphForbiddenHelp
    }
    throw
}

$successCount = 0
$skipCount    = 0
$partialCount = 0
$warnings     = [System.Collections.Generic.List[string]]::new()
$postElapsedMs = 0L

for ($i = 0; $i -lt $settings.Count; $i++) {
    $s = $settings[$i]
    $settingLabel = "$($s.definitionCategoryPath) > $($s.definitionDisplayName)"
    $presentationsDropped = $false

    $newDef = Resolve-DefinitionForSetting -Setting $s -Lookup $defLookup

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
        'definition@odata.bind' = "$graphJsonBase/deviceManagement/groupPolicyDefinitions('$newDefId')"
    }

    $presValsRaw = Get-SafeProperty $s 'presentationValues'
    $hasPresentations = $null -ne $presValsRaw -and @($presValsRaw).Count -gt 0
    if ($hasPresentations) {
        $presInfo = Get-PresentationLookup $newDefId
        $presByLabel = $presInfo.ByLabel
        $presOrdered = $presInfo.Ordered
        $newPresValues = [System.Collections.Generic.List[object]]::new()
        $pvIndex = 0

        foreach ($pv in @($presValsRaw)) {
            $matchedPres = $null
            $presLabel = Get-SafeProperty $pv 'presentationLabel'
            if ($presLabel) {
                $matchedPres = $presByLabel[$presLabel]
            }

            if (-not $matchedPres -and $pvIndex -lt $presOrdered.Count) {
                $matchedPres = $presOrdered[$pvIndex]
            }

            $pvIndex++

            if (-not $matchedPres) {
                $msg = "WARNING: $settingLabel - could not match presentation (label='$presLabel', index $($pvIndex - 1); tenant has $($presOrdered.Count) presentation(s)), skipping"
                Write-Host "    $msg" -ForegroundColor Yellow
                $warnings.Add($msg)
                continue
            }

            $matchedId = Get-SafeProperty $matchedPres 'id'
            $odataType = Get-SafeProperty $pv '@odata.type'
            $presEntry = [ordered]@{
                '@odata.type'             = $odataType
                'presentation@odata.bind' = "$graphJsonBase/deviceManagement/groupPolicyDefinitions('$newDefId')/presentations('$matchedId')"
            }
            $pvValue  = Get-SafeProperty $pv 'value'
            $pvValues = Get-SafeProperty $pv 'values'
            if ($null -ne $pvValue)  { $presEntry['value']  = $pvValue }
            if ($null -ne $pvValues) { $presEntry['values'] = @($pvValues) }

            $newPresValues.Add($presEntry)
        }

        if ($newPresValues.Count -gt 0) {
            $dvBody['presentationValues'] = @($newPresValues)
        } else {
            $presentationsDropped = $true
        }
    }

    try {
        if ($SettingDelayMs -gt 0 -and $successCount -gt 0) {
            Start-Sleep -Milliseconds $SettingDelayMs
        }
        $postSw = [System.Diagnostics.Stopwatch]::StartNew()
        $null = Invoke-GraphRequestWithRecovery -Method POST `
            -RequestUri "$graphApiRoot/deviceManagement/groupPolicyConfigurations/$newPolicyId/definitionValues" `
            -Body ($dvBody | ConvertTo-Json -Depth 20) -ContentType 'application/json'
        $postSw.Stop()
        $postElapsedMs += $postSw.ElapsedMilliseconds

        if ($presentationsDropped) {
            $msg = "PARTIAL: $settingLabel - created WITHOUT its configured values (no presentation matched in this tenant)"
            Write-Host "  [$($i+1)/$($settings.Count)] $msg" -ForegroundColor Yellow
            $warnings.Add($msg)
            $partialCount++
        } else {
            Write-Host "  [$($i+1)/$($settings.Count)] $settingLabel" -ForegroundColor Gray
        }
        $successCount++
    } catch {
        $msg = "FAILED: $settingLabel ($($s.definitionCategoryPath) / $($s.definitionDisplayName)) - $($_.Exception.Message)"
        Write-Host "  [$($i+1)/$($settings.Count)] $msg" -ForegroundColor Red
        $warnings.Add($msg)
        $skipCount++
    }
}

# ── Summary ──────────────────────────────────────────────────────────────────

$importStopwatch.Stop()
$settingsPhaseSec = [math]::Round($importStopwatch.Elapsed.TotalSeconds, 1)
$postPhaseSec = [math]::Round($postElapsedMs / 1000.0, 1)
$avgPostMs = if ($successCount -gt 0) {
    [math]::Round($postElapsedMs / $successCount, 0)
} else {
    0
}

Write-Host ''
Write-Host '  Import Summary' -ForegroundColor Cyan
Write-Host '  ==============' -ForegroundColor Cyan
Write-Host "  Policy:    $policyName" -ForegroundColor White
Write-Host "  Policy Id: $newPolicyId" -ForegroundColor DarkGray
Write-Host "  Time (policy name set -> last setting): ${settingsPhaseSec}s" -ForegroundColor DarkGray
Write-Host "  POST phase: ${postPhaseSec}s ($successCount settings, ~${avgPostMs}ms per successful POST)" -ForegroundColor DarkGray
Write-Host "  Imported:  $successCount settings" -ForegroundColor Green
if ($partialCount -gt 0) {
    Write-Host "  Partial:   $partialCount setting(s) created WITHOUT their configured values - verify in Intune" -ForegroundColor Yellow
}
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
