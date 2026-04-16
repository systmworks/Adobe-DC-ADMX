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
    paste prompt) so you can select the JSON file interactively.
.NOTES
    Requires the Microsoft.Graph.Authentication module:
      Install-Module Microsoft.Graph.Authentication -Scope CurrentUser

    Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0).
    https://creativecommons.org/licenses/by-sa/4.0/
.EXAMPLE
    .\Import-IntuneAdmxPolicy.ps1
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

$ctx = Get-MgContext -ErrorAction SilentlyContinue
if ($null -eq $ctx) {
    Write-Information 'Connecting to Microsoft Graph...'
    Connect-WithFallback $requiredScopes
} else {
    $missing = $requiredScopes | Where-Object { $ctx.Scopes -notcontains $_ }
    if ($missing) {
        Write-Information 'Re-connecting with required scopes...'
        Connect-WithFallback $requiredScopes
    } else {
        Write-Information "Already connected as $($ctx.Account)"
    }
}

# ── Helper: paginated GET ────────────────────────────────────────────────────

function Invoke-GraphGetAll([string]$Uri) {
    $results = [System.Collections.Generic.List[object]]::new()
    $url = $Uri
    do {
        $resp = Invoke-MgGraphRequest -Method GET -Uri $url
        if ($resp.ContainsKey('value')) { $resp.value | ForEach-Object { $results.Add($_) } }
        $url = if ($resp.ContainsKey('@odata.nextLink')) { $resp.'@odata.nextLink' } else { $null }
    } while ($url)
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

if ($PolicyName) {
    $policyName = $PolicyName
    Write-Information "Using custom policy name: $policyName"
} else {
    $policyName = $raw.policyDisplayName
}
$policyDesc = if ($raw.policyDescription) { $raw.policyDescription } else { '' }
$settings   = @($raw.settings)
Write-Information "Policy: $policyName  ($($settings.Count) settings)"

# ── Build definition lookup from tenant ──────────────────────────────────────
#    Index by "categoryPath|displayName|classType" → definition object

Write-Information 'Building definition lookup (this may take a moment for large tenants)...'
$allDefs = Invoke-GraphGetAll "$graphBase/deviceManagement/groupPolicyDefinitions"
Write-Information "  Loaded $($allDefs.Count) definitions from tenant"

$defLookup = @{}
foreach ($d in $allDefs) {
    $key = "$($d.categoryPath)|$($d.displayName)|$($d.classType)"
    $defLookup[$key] = $d
}

# ── Build presentation lookup per definition ─────────────────────────────────
#    Only fetches presentations for definitions we actually need.

function Get-PresentationLookup([string]$definitionId) {
    $presentations = Invoke-GraphGetAll "$graphBase/deviceManagement/groupPolicyDefinitions/$definitionId/presentations"
    $lookup = @{}
    foreach ($p in $presentations) {
        $lookup[$p.label] = $p
    }
    return $lookup
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

Write-Host ''
Write-Host '  Import Summary' -ForegroundColor Cyan
Write-Host '  ==============' -ForegroundColor Cyan
Write-Host "  Policy:    $policyName" -ForegroundColor White
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
