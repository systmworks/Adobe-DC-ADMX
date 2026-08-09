#Requires -Version 5.1
#Requires -Modules Microsoft.Graph.Authentication
<#
.SYNOPSIS
    Exports Intune Administrative Template (ADMX-backed) policies to JSON.
.DESCRIPTION
    Connects to Microsoft Graph, lists Administrative Template policies, and exports configured settings with stable identifiers (categoryPath, displayName, classType) that survive ADMX delete/re-upload. JSON is consumed by Import-IntuneAdmxPolicy_v3.0.ps1.
    No parameters: interactive picker with repeat menu (Q to quit). Any bound parameter: single export then exit. Optional -DelayMillisecondsBetweenSettings (default 0) if Graph returns HTTP 429.
.PARAMETER PolicyName
    Policy display name or partial match. When omitted, prompts from the numbered list.
.NOTES
    Version 3.0 — see CHANGELOG.md. Requires Microsoft.Graph.Authentication (Install-Module -Scope CurrentUser). Scope DeviceManagementConfiguration.ReadWrite.All (shared with Import).
    Licensed CC BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/
.EXAMPLE
    .\Export-IntuneAdmxPolicy_v3.0.ps1
.EXAMPLE
    .\Export-IntuneAdmxPolicy_v3.0.ps1 -PolicyName 'Adobe Reader'
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

# Absolute HTTPS base for odata.bind values in exported JSON (import expects canonical URLs).
$graphJsonBase = 'https://graph.microsoft.com/beta'
# Relative API root for Invoke-MgGraphRequest URIs (required for Set-MgRequestContext retry handling).
$graphApiRoot = '/beta'

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
    # Prefer interactive browser sign-in; fall back to device code when UI is unavailable.
    try {
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

# StrictMode throws on absent properties; use this for optional OData fields like @odata.nextLink.
function Get-SafeProperty($obj, [string]$name, $default = $null) {
    if ($null -eq $obj) { return $default }
    $prop = $obj.PSObject.Properties[$name]
    if ($prop) { return $prop.Value }
    return $default
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

# SDK honours Retry-After on 429 when request URIs are relative (see ConvertTo-GraphRequestUri).
Set-MgRequestContext -MaxRetry 10 -RetryDelay 5 | Out-Null

# ── Helper: paginated GET ────────────────────────────────────────────────────

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
        $resp = Invoke-MgGraphRequest -Method GET -Uri $url -OutputType PSObject -ErrorAction Stop
        $values = Get-SafeProperty $resp 'value'
        if ($values) {
            foreach ($item in @($values)) { $results.Add($item) }
        }
        $nextLink = Get-SafeProperty $resp '@odata.nextLink'
        $url = if ($null -ne $nextLink -and -not [string]::IsNullOrWhiteSpace([string]$nextLink)) {
            ConvertTo-GraphRequestUri ([string]$nextLink)
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

function Get-DefinitionValuesExpanded([string]$PolicyId) {
    $definitionValuesUri = "${graphApiRoot}/deviceManagement/groupPolicyConfigurations/$PolicyId/definitionValues"
    $expandBoth = $definitionValuesUri + '?$expand=definition,presentationValues'
    $expandDefOnly = $definitionValuesUri + '?$expand=definition'
    try {
        Write-Information 'Loading definition values with definition and presentationValue counts...'
        return @{
            Values = Invoke-GraphGetAll $expandBoth -ProgressActivity 'Loading definition values'
            ExpandPresentationCounts = $true
        }
    } catch {
        Write-Information "  Combined `$expand not supported ($($_.Exception.Message)); falling back to definition only..."
        return @{
            Values = Invoke-GraphGetAll $expandDefOnly -ProgressActivity 'Loading definition values'
            ExpandPresentationCounts = $false
        }
    }
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
    # Accept numeric list index (1-based) as well as exact or partial display name.
    if ($Search -match '^\d+$') {
        $idx = [int]$Search - 1
        if ($idx -ge 0 -and $idx -lt $Policies.Count) { return $Policies[$idx] }
    }
    $exact = @($Policies | Where-Object { $_.displayName -eq $Search })
    if ($exact.Count -eq 1) { return $exact[0] }
    $partial = @($Policies | Where-Object { $_.displayName -like "*$Search*" })
    if ($partial.Count -eq 1) { return $partial[0] }
    if ($partial.Count -gt 1) {
        Write-Host '  Multiple matches - enter a number from the list to select:' -ForegroundColor Yellow
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

    $defValueResult = Get-DefinitionValuesExpanded $policyId
    $definitionValues = $defValueResult.Values
    $hasPresentationCounts = $defValueResult.ExpandPresentationCounts

    if ($definitionValues.Count -eq 0) {
        $exportStopwatch.Stop()
        $settingsPhaseSec = [math]::Round($exportStopwatch.Elapsed.TotalSeconds, 1)
        Write-Warning "Policy has no configured settings (${settingsPhaseSec}s)."
        return 'NoSettings'
    }

    $exportedSettings = [System.Collections.Generic.List[object]]::new()
    $skipCount = 0
    $warnings  = [System.Collections.Generic.List[string]]::new()
    $presentationFetchCount = 0

    for ($i = 0; $i -lt $definitionValues.Count; $i++) {
        $dv = $definitionValues[$i]
        $settingLabel = "Setting $($i + 1)/$($definitionValues.Count)"

        try {
            $dvId = Get-SafeProperty $dv 'id'
            if (-not $dvId) {
                throw 'definitionValue has no id'
            }

            # Definition metadata arrives inline via $expand=definition (no per-setting GET).
            $definition = Get-SafeProperty $dv 'definition'
            if (-not $definition) {
                throw 'definitionValue has no expanded definition'
            }

            $defId    = Get-SafeProperty $definition 'id' ''
            $defName  = Get-SafeProperty $definition 'displayName' '(unknown)'
            $defPath  = Get-SafeProperty $definition 'categoryPath' ''
            $defClass = Get-SafeProperty $definition 'classType' ''

            $enabledVal = Get-SafeProperty $dv 'enabled'
            if ($null -eq $enabledVal) {
                throw "definitionValue for '$defName' has no enabled property"
            }

            $settingLabel = "$defPath > $defName"
            Write-Host "  [$($i + 1)/$($definitionValues.Count)] $defName" -ForegroundColor Gray

            $presValues = @()
            $expandedPres = Get-SafeProperty $dv 'presentationValues'
            $needsPresentationGet = $false
            if ($hasPresentationCounts) {
                if ($null -eq $expandedPres) {
                    # Graph often omits presentationValues on $expand even when settings have enum/text values.
                    # Enabled settings are the only ones that carry presentation data; fetch to verify.
                    $needsPresentationGet = ($enabledVal -eq $true)
                } else {
                    $needsPresentationGet = @($expandedPres).Count -gt 0
                }
            } else {
                # Fallback expand path: fetch presentation details per setting (legacy behaviour).
                $needsPresentationGet = $true
            }

            # Only settings with presentation elements need a second GET (typically a handful on Adobe policies).
            if ($needsPresentationGet) {
                $presentationFetchCount++
                $presResp = Invoke-MgGraphRequest -Method GET -Uri (ConvertTo-GraphRequestUri `
                    "${graphApiRoot}/deviceManagement/groupPolicyConfigurations/$policyId/definitionValues/$dvId/presentationValues?`$expand=presentation") `
                    -OutputType PSObject -ErrorAction Stop

                $presItems = @(Get-SafeProperty $presResp 'value')
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
            }

            $setting = [ordered]@{
                'enabled'                 = $enabledVal
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
            $msg = "FAILED: $settingLabel - $($_.Exception.Message)"
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

    # Envelope matches schemaVersion 1 consumed by Import-IntuneAdmxPolicy_v3.0.ps1 (and v2.0).
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
    Write-Host "  Time (policy selected -> last setting): ${settingsPhaseSec}s" -ForegroundColor DarkGray
    Write-Host "  Presentation detail GETs: $presentationFetchCount" -ForegroundColor DarkGray
    $exportedWithPres = 0
    foreach ($s in $exportedSettings) {
        # Settings are [ordered] hashtables; optional keys must use Contains under StrictMode.
        if ($s.Contains('presentationValues') -and @($s['presentationValues']).Count -gt 0) {
            $exportedWithPres++
        }
    }
    Write-Host "  Settings with presentationValues in file: $exportedWithPres" -ForegroundColor DarkGray
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

# ── Policy selection and export loop ─────────────────────────────────────────

$selected = $null
if ($PolicyName) {
    $selected = Find-Policy $PolicyName $allPolicies
}

do {
    if (-not $selected) {
        Show-AdministrativeTemplatePolicyList -Policies $allPolicies -IncludeQuit:($allowRepeatMenu)
        $prompt = if ($allowRepeatMenu) {
            'Enter policy number or name (or Q to quit)'
        } else {
            'Enter the policy name (or number from the list above)'
        }
        $input_val = Read-Host $prompt
        if ($null -eq $input_val) {
            if ($allowRepeatMenu) {
                Write-Warning 'No input - enter a selection or Q to quit.'
                continue
            }
            Write-Error 'No input received. Run the script with -PolicyName to skip the prompt.'
            exit 1
        }
        $trim = $input_val.Trim()
        if ($allowRepeatMenu -and $trim -match '^[qQ]$') { break }
        if ([string]::IsNullOrWhiteSpace($trim)) {
            if ($allowRepeatMenu) {
                Write-Warning 'Empty input - try again or Q to quit.'
                continue
            }
            Write-Warning 'Empty input - try again.'
            continue
        }
        $selected = Find-Policy $trim $allPolicies
        if (-not $selected) {
            Write-Host '  No match found. Try again.' -ForegroundColor Red
            continue
        }
    }

    $exportResult = Invoke-AdmxPolicyExport -Selected $selected -DelayMs $DelayMillisecondsBetweenSettings
    if ($exportResult -eq 'NoSettings') {
        if (-not $allowRepeatMenu) { exit 1 }
        $selected = $null
        continue
    }

    if (-not $allowRepeatMenu) { break }
    $selected = $null
} while ($allowRepeatMenu)
