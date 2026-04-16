#Requires -Version 5.1
#Requires -Modules Microsoft.Graph.Authentication
<#
.SYNOPSIS
    Exports an Intune Administrative Template (ADMX-backed) policy to JSON.
.DESCRIPTION
    Connects to Microsoft Graph via interactive browser sign-in, lists all
    Administrative Template policies, lets you pick one by friendly name,
    then exports every configured setting — including stable identifiers
    (categoryPath, displayName, classType) that survive ADMX delete/re-upload.

    The exported JSON can be re-imported by Import-IntuneAdmxPolicy.ps1 even
    after the ADMX namespaces have been deleted and re-uploaded with new GUIDs.
.NOTES
    Requires the Microsoft.Graph.Authentication module:
      Install-Module Microsoft.Graph.Authentication -Scope CurrentUser

    Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0).
    https://creativecommons.org/licenses/by-sa/4.0/
.EXAMPLE
    .\Export-IntuneAdmxPolicy.ps1
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$PolicyName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

$graphBase = 'https://graph.microsoft.com/beta'

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

# ── List all Administrative Template policies ────────────────────────────────

Write-Information 'Retrieving Administrative Template policies...'
$allPolicies = Invoke-GraphGetAll "$graphBase/deviceManagement/groupPolicyConfigurations"

if ($allPolicies.Count -eq 0) {
    Write-Warning 'No Administrative Template policies found in this tenant.'
    return
}

Write-Host ''
Write-Host '  Administrative Template Policies' -ForegroundColor Cyan
Write-Host '  ================================' -ForegroundColor Cyan
for ($i = 0; $i -lt $allPolicies.Count; $i++) {
    Write-Host "  [$($i + 1)] $($allPolicies[$i].displayName)" -ForegroundColor White
}
Write-Host ''

# ── Select policy (parameter, prompt, or auto-match) ────────────────────────

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
    $input_val = Read-Host 'Enter the policy name (or number from the list above)'
    if ($null -eq $input_val) {
        Write-Error 'No input received. Run the script with -PolicyName to skip the prompt.'
        return
    }
    $selected = Find-Policy $input_val.Trim() $allPolicies
    if (-not $selected) { Write-Host '  No match found. Try again.' -ForegroundColor Red }
}

$policyId = $selected.id
$policyName = $selected.displayName
Write-Information "Selected: $policyName ($policyId)"

# ── Export definition values with stable identifiers ─────────────────────────

Write-Information 'Exporting policy settings...'
$definitionValues = Invoke-GraphGetAll "$graphBase/deviceManagement/groupPolicyConfigurations/$policyId/definitionValues"

if ($definitionValues.Count -eq 0) {
    Write-Warning 'Policy has no configured settings.'
    return
}

$exportedSettings = [System.Collections.Generic.List[object]]::new()
$settingNum = 0

foreach ($dv in $definitionValues) {
    $settingNum++
    $dvId = $dv.id

    $definition = Invoke-MgGraphRequest -Method GET `
        -Uri "$graphBase/deviceManagement/groupPolicyConfigurations/$policyId/definitionValues/$dvId/definition"

    Write-Host "  [$settingNum/$($definitionValues.Count)] $($definition.displayName)" -ForegroundColor Gray

    $presResp = Invoke-MgGraphRequest -Method GET `
        -Uri "$graphBase/deviceManagement/groupPolicyConfigurations/$policyId/definitionValues/$dvId/presentationValues?`$expand=presentation"

    $presValues = @()
    $presItems = @(if ($presResp.ContainsKey('value')) { $presResp.value } else { })
    if ($presItems.Count -gt 0) {
        $presValues = foreach ($pv in $presItems) {
            $pres = if ($pv.ContainsKey('presentation')) { $pv.presentation } else { $null }
            $presLabel = if ($pres -and $pres.ContainsKey('label')) { $pres.label } else { '' }
            $presId    = if ($pres -and $pres.ContainsKey('id'))    { $pres.id }    else { '' }
            $entry = [ordered]@{
                '@odata.type'          = $pv.'@odata.type'
                'presentationLabel'    = $presLabel
                'presentationId'       = $presId
                'presentation@odata.bind' = "$graphBase/deviceManagement/groupPolicyDefinitions('$($definition.id)')/presentations('$presId')"
            }
            if ($pv.ContainsKey('value'))  { $entry['value']  = $pv.value }
            if ($pv.ContainsKey('values')) { $entry['values'] = $pv.values }
            $entry
        }
    }

    $setting = [ordered]@{
        'enabled'                 = $dv.enabled
        'definitionDisplayName'   = $definition.displayName
        'definitionCategoryPath'  = $definition.categoryPath
        'definitionClassType'     = $definition.classType
        'definitionId'            = $definition.id
        'definition@odata.bind'   = "$graphBase/deviceManagement/groupPolicyDefinitions('$($definition.id)')"
    }
    if ($presValues.Count -gt 0) {
        $setting['presentationValues'] = @($presValues)
    }
    $exportedSettings.Add($setting)
}

# ── Build export envelope ────────────────────────────────────────────────────

$envelope = [ordered]@{
    'schemaVersion'    = 1
    'policyDisplayName' = $policyName
    'policyDescription' = if ($selected.description) { $selected.description } else { '' }
    'exportDate'       = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssZ')
    'settingCount'     = $exportedSettings.Count
    'settings'         = @($exportedSettings)
}

# ── Write JSON ───────────────────────────────────────────────────────────────

$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Definition }
$exportDir = Join-Path $scriptDir 'Exports'
if (-not (Test-Path $exportDir)) { New-Item -ItemType Directory -Path $exportDir -Force | Out-Null }

$invalidChars = [regex]::Escape([string]::new([IO.Path]::GetInvalidFileNameChars()))
$safeName = [regex]::Replace($policyName, "[$invalidChars]", '_')
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$outPath = Join-Path $exportDir "${safeName}_${timestamp}.json"

$envelope | ConvertTo-Json -Depth 20 | Out-File -LiteralPath $outPath -Encoding utf8
Write-Host ''
Write-Host "  Export complete: $($exportedSettings.Count) settings" -ForegroundColor Green
Write-Host "  File: $outPath" -ForegroundColor Green
Write-Host ''
