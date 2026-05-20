#Requires -Version 5.1
#Requires -Modules Microsoft.Graph.Authentication
<#
.SYNOPSIS
    Imports an Intune Administrative Template (ADMX-backed) policy from JSON.
.DESCRIPTION
    Re-creates an Administrative Template policy that was previously exported
    by Export-IntuneAdmxPolicy.ps1.  Uses stable identifiers (categoryPath,
    displayName, classType) to look up the correct definition GUIDs in the
    current tenant, so the import works even after the ADMX has been deleted
    and re-uploaded with new GUIDs.

    On launch the script opens a file-browse dialog (or falls back to a
    paste prompt) so you can select the JSON file interactively.  You are
    then prompted for the new policy display name (the exported name is
    offered as the default).  Pass -PolicyName to skip the prompt, e.g. in
    pipelines or automated runs.

    No command-line parameters are required for interactive use in VS Code;
    just Run/Debug with the default configuration.
.PARAMETER FilePath
    Path to the exported JSON file.  When omitted, a file-browse dialog
    (or paste prompt) is shown.
.PARAMETER PolicyName
    Display name for the imported policy.  When omitted, the script prompts
    interactively (showing the exported name as the default).  Supply this
    parameter to skip the prompt for non-interactive / automated runs.
.NOTES
    Requires the Microsoft.Graph.Authentication module:
      Install-Module Microsoft.Graph.Authentication -Scope CurrentUser

    Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0).
    https://creativecommons.org/licenses/by-sa/4.0/
.EXAMPLE
    .\Import-IntuneAdmxPolicy_v2.0.ps1
    Interactive run — prompts for file and policy name.
.EXAMPLE
    .\Import-IntuneAdmxPolicy_v2.0.ps1 -PolicyName 'Firefox Hardening - TEST'
    Skips the name prompt and creates the policy with the given name.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$FilePath,

    [Parameter(Mandatory = $false)]
    [string]$PolicyName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
Clear-Host

$graphBase = 'https://graph.microsoft.com/beta'

# ── Connect to Microsoft Graph ───────────────────────────────────────────────

$requiredScopes = @('DeviceManagementConfiguration.ReadWrite.All')

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
    $missing = $requiredScopes | Where-Object { $ctx.Scopes -notcontains $_ }
    if ($missing) {
        Write-Information 'Re-connecting with required scopes...'
        Connect-WithFallback $requiredScopes
    }
}
Show-TenantAndConfirm $requiredScopes

# ── Helper: paginated GET ────────────────────────────────────────────────────

function Invoke-GraphGetAll([string]$Uri, [string]$ProgressActivity) {
    $results = [System.Collections.Generic.List[object]]::new()
    $url = $Uri
    $pageNum = 0
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    do {
        $pageNum++
        $resp = Invoke-MgGraphRequest -Method GET -Uri $url
        $values = Get-SafeProperty $resp 'value'
        if ($values) {
            foreach ($item in (Expand-ODataValue $values)) { $results.Add($item) }
        }
        $nextLink = Get-SafeProperty $resp '@odata.nextLink'
        $url = if ($nextLink) { $nextLink } else { $null }

        if ($ProgressActivity) {
            $status = "$($results.Count) items loaded (page $pageNum, $([math]::Round($sw.Elapsed.TotalSeconds))s)"
            Write-Progress -Activity $ProgressActivity -Status $status
        }
    } while ($url)

    if ($ProgressActivity) { Write-Progress -Activity $ProgressActivity -Completed }
    return $results
}

# ── Select JSON file ────────────────────────────────────────────────────────

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
    return
}
Write-Information "Loading: $jsonPath"

# ── Load and validate JSON ───────────────────────────────────────────────────

$raw = Get-Content -LiteralPath $jsonPath -Raw -Encoding utf8 | ConvertFrom-Json

if (-not $raw.policyDisplayName -or -not $raw.settings) {
    Write-Error 'Invalid export file - missing policyDisplayName or settings array.'
    return
}

$policyDesc = if ($raw.policyDescription) { $raw.policyDescription } else { '' }
$settings   = @($raw.settings)

if ($PSBoundParameters.ContainsKey('PolicyName') -and $PolicyName) {
    $policyName = $PolicyName
    Write-Information "Using policy name from parameter: $policyName"
} else {
    $defaultName = $raw.policyDisplayName
    Write-Host ''
    Write-Host '  Enter a display name for the imported policy.' -ForegroundColor Cyan
    Write-Host "  Default (press Enter): $defaultName" -ForegroundColor Gray
    $inputName = Read-Host '  Policy name'
    $policyName = if ($inputName.Trim()) { $inputName.Trim() } else { $defaultName }
}
Write-Information "Policy: $policyName  ($($settings.Count) settings)"

$importStopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# ── Build definition lookup from tenant ──────────────────────────────────────
#    Index by "categoryPath|displayName|classType" → definition object.
#    Tries a scoped fetch first (only the category-path prefixes present in
#    the export) to avoid enumerating the entire tenant catalog.  Falls back
#    to a full fetch when the Graph endpoint rejects the $filter.

$categoryPrefixes = @($settings | ForEach-Object {
    $segments = $_.definitionCategoryPath -split '\\'
    if ($segments.Count -ge 3) { "\$($segments[1])\$($segments[2])" }
    elseif ($segments.Count -ge 2) { "\$($segments[1])" }
} | Sort-Object -Unique)

$allDefs = $null
if ($categoryPrefixes.Count -gt 0 -and $categoryPrefixes.Count -le 10) {
    Write-Information "Attempting scoped definition fetch for $($categoryPrefixes.Count) category prefix(es)..."
    try {
        $allDefs = [System.Collections.Generic.List[object]]::new()
        foreach ($prefix in $categoryPrefixes) {
            $escaped = $prefix.Replace("'", "''")
            $filterExpr = "startswith(categoryPath,'$escaped')"
            $encodedFilter = [Uri]::EscapeDataString($filterExpr)
            $filterUri = "$graphBase/deviceManagement/groupPolicyDefinitions?`$filter=$encodedFilter"
            $batch = Invoke-GraphGetAll $filterUri -ProgressActivity "Loading definitions for $prefix"
            $batch | ForEach-Object { $allDefs.Add($_) }
        }
        Write-Information "  Scoped fetch returned $($allDefs.Count) definitions"
    } catch {
        Write-Information "  Scoped fetch not supported by this tenant ($($_.Exception.Message)). Falling back to full fetch..."
        $allDefs = $null
    }
}

if ($null -eq $allDefs) {
    Write-Information 'Building full definition lookup (this may take a moment for large tenants)...'
    $allDefs = Invoke-GraphGetAll "$graphBase/deviceManagement/groupPolicyDefinitions" -ProgressActivity 'Loading group policy definitions from tenant'
}
Write-Information "  Loaded $($allDefs.Count) definitions from tenant"

$defLookup = @{}
foreach ($d in $allDefs) {
    $key = "$($d.categoryPath)|$($d.displayName)|$($d.classType)"
    $defLookup[$key] = $d
}

# ── Build presentation lookup per definition ─────────────────────────────────
#    Only fetches presentations for definitions we actually need.
#    Some ADMX (e.g. Firefox) expose empty presentation labels; a hashtable keyed
#    by label cannot hold multiple ''. We also keep a stable ordered list for
#    positional matching (export order ↔ same index in sorted tenant list).

function Get-PresentationLookup([string]$definitionId) {
    $presentations = Invoke-GraphGetAll "$graphBase/deviceManagement/groupPolicyDefinitions/$definitionId/presentations"
    $byLabel = @{}
    foreach ($p in $presentations) {
        $lbl = Get-SafeProperty $p 'label'
        if ($null -ne $lbl -and $lbl -ne '') {
            $byLabel[$lbl] = $p
        }
    }
    # Preserve Graph API order (same logical order as export) — do not sort by id; GUID order can differ across tenants.
    $ordered = @($presentations)
    return [pscustomobject]@{
        ByLabel = $byLabel
        Ordered = $ordered
    }
}

# ── Create the new policy shell ──────────────────────────────────────────────

Write-Host ''
Write-Host "  Creating policy: $policyName" -ForegroundColor Cyan

$policyBody = @{
    displayName = $policyName
    description = $policyDesc
} | ConvertTo-Json

$newPolicy = Invoke-MgGraphRequest -Method POST `
    -Uri "$graphBase/deviceManagement/groupPolicyConfigurations" `
    -Body $policyBody -ContentType 'application/json'

$newPolicyId = $newPolicy.id
Write-Information "  Policy created: $newPolicyId"

# ── Import each setting ──────────────────────────────────────────────────────

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

            if (-not $matchedPres -and $presOrdered.Count -eq 1) {
                $matchedPres = $presOrdered[0]
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
                'presentation@odata.bind' = "$graphBase/deviceManagement/groupPolicyDefinitions('$newDefId')/presentations('$matchedId')"
            }
            $pvValue  = Get-SafeProperty $pv 'value'
            $pvValues = Get-SafeProperty $pv 'values'
            if ($null -ne $pvValue)  { $presEntry['value']  = $pvValue }
            if ($null -ne $pvValues) { $presEntry['values'] = @($pvValues) }

            $newPresValues.Add($presEntry)
        }

        if ($newPresValues.Count -gt 0) {
            $dvBody['presentationValues'] = @($newPresValues)
        }
    }

    try {
        $null = Invoke-MgGraphRequest -Method POST `
            -Uri "$graphBase/deviceManagement/groupPolicyConfigurations/$newPolicyId/definitionValues" `
            -Body ($dvBody | ConvertTo-Json -Depth 20) -ContentType 'application/json'

        Write-Host "  [$($i+1)/$($settings.Count)] $settingLabel" -ForegroundColor Gray
        $successCount++
    } catch {
        $msg = "FAILED: $settingLabel - $($_.Exception.Message)"
        Write-Host "  [$($i+1)/$($settings.Count)] $msg" -ForegroundColor Red
        $warnings.Add($msg)
        $skipCount++
    }
}

# ── Summary ──────────────────────────────────────────────────────────────────

$importStopwatch.Stop()
$settingsPhaseSec = [math]::Round($importStopwatch.Elapsed.TotalSeconds, 1)

Write-Host ''
Write-Host '  Import Summary' -ForegroundColor Cyan
Write-Host '  ==============' -ForegroundColor Cyan
Write-Host "  Policy:    $policyName" -ForegroundColor White
Write-Host "  Time (policy name set → last setting): ${settingsPhaseSec}s" -ForegroundColor DarkGray
Write-Host "  Imported:  $successCount settings" -ForegroundColor Green
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
