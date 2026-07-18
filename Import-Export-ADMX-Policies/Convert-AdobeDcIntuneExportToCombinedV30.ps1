#Requires -Version 5.1
<#
.SYNOPSIS
  Converts Intune ADMX policy export JSON to combined v3.0 category layout.
.DESCRIPTION
  Maps v2.19 four-branch, v2.21 three-branch machine, and v2.21 user paths to the
  combined v3.0 tree under \Adobe DC\. De-duplicates redundant Policies-branch entries.
  Clears definitionId GUIDs (re-bind after uploading combined ADMX to Intune).

  Output: converted JSON + migration report markdown alongside each input file.
.PARAMETER InputPath
  Path to a single export JSON file.
.PARAMETER InputDir
  Directory of export JSON files (skips *_combined-v3.0.json outputs).
.PARAMETER AdmxPath
  Path to combined AdobeDC.admx (default: ../v3.0/AdobeDC.admx).
.PARAMETER AdmlPath
  Path to combined ADML (default: ../v3.0/en-US/AdobeDC.adml).
.EXAMPLE
  .\Convert-AdobeDcIntuneExportToCombinedV30.ps1 -InputDir '..\Convert_Policies'
#>
[CmdletBinding(DefaultParameterSetName = 'File')]
param(
    [Parameter(ParameterSetName = 'File', Mandatory = $true)]
    [string]$InputPath,

    [Parameter(ParameterSetName = 'Dir', Mandatory = $true)]
    [string]$InputDir,

    [string]$AdmxPath,
    [string]$AdmlPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Definition }
$combinedRoot = Split-Path $scriptDir -Parent
if (-not $AdmxPath) { $AdmxPath = Join-Path $combinedRoot 'Publish_to_GitHub\v3.0\AdobeDC.admx' }
if (-not $AdmlPath) { $AdmlPath = Join-Path $combinedRoot 'Publish_to_GitHub\v3.0\en-US\AdobeDC.adml' }

$Script:ArmFriendlyNames = [System.Collections.Generic.HashSet[string]]::new(
    [string[]]@(
        'Disable Major Version Upgrade Prompt',
        'Update Watchdog Interval (Days)',
        'Updater Log Level'
    ),
    [StringComparer]::OrdinalIgnoreCase
)

function Decode-AdmlString([string]$Text) {
    if ([string]::IsNullOrEmpty($Text)) { return '' }
    return $Text.Replace('&amp;', '&').Replace('&lt;', '<').Replace('&gt;', '>').Replace('&#10;', "`n")
}

function Resolve-AdmxStringRef([string]$Ref, [hashtable]$Strings) {
    if ($Ref -match '\$\(string\.([^)]+)\)') {
        $id = $Matches[1]
        if ($Strings.ContainsKey($id)) { return $Strings[$id] }
    }
    return $Ref
}

function Get-BranchKindFromPolicy {
    param([string]$PolicyName, [string]$Class)
    if ($Class -eq 'User') {
        if ($PolicyName -match 'DC_User$') { return 'UserAcrobat' }
        if ($PolicyName -match '_User$') { return 'UserReader' }
        return 'UserUnknown'
    }
    if ($PolicyName -match '_AcrobatX64$') { return 'AcrobatX64' }
    if ($PolicyName -match '_AcrobatX86$') { return 'AcrobatX86' }
    if ($PolicyName -match '_ReaderX86$') { return 'ReaderX86' }
    if ($PolicyName -match '_Acrobat$') { return 'AcrobatPolicies' }
    if ($PolicyName -match '_Reader$') { return 'ReaderPolicies' }
    return 'MachineUnknown'
}

function Build-CombinedAdmxPolicyIndex {
    param(
        [string]$AdmxFile,
        [string]$AdmlFile
    )
    $ns = 'http://schemas.microsoft.com/GroupPolicy/2006/07/PolicyDefinitions'
    $adml = [xml](Get-Content -LiteralPath $AdmlFile -Raw -Encoding UTF8)
    $admx = [xml](Get-Content -LiteralPath $AdmxFile -Raw -Encoding UTF8)

    $strings = @{}
    foreach ($s in $adml.policyDefinitionResources.resources.stringTable.string) {
        $strings[$s.id] = Decode-AdmlString $s.'#text'
    }

    $categories = @{}
    foreach ($c in $admx.policyDefinitions.categories.category) {
        $parentRef = $null
        if ($c.PSObject.Properties['parentCategory'] -and $c.parentCategory) {
            $parentRef = $c.parentCategory.ref
        }
        $categories[$c.name] = [pscustomobject]@{
            Name        = $c.name
            DisplayName = Resolve-AdmxStringRef $c.displayName $strings
            ParentRef   = $parentRef
        }
    }

    function Get-CategoryIntunePath([string]$CatName) {
        $parts = [System.Collections.Generic.List[string]]::new()
        $current = $CatName
        $guard = 0
        while ($current -and $categories.ContainsKey($current) -and $guard -lt 20) {
            $guard++
            $cat = $categories[$current]
            $parts.Insert(0, $cat.DisplayName)
            $current = $cat.ParentRef
        }
        return '\' + ($parts -join '\')
    }

    $allPaths = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    $byDisplayBranch = @{}
    $byDisplayName = @{}
    $policies = @()

    foreach ($p in $admx.policyDefinitions.policies.policy) {
        $displayRef = $p.displayName
        $displayName = Resolve-AdmxStringRef $displayRef $strings
        $catPath = Get-CategoryIntunePath $p.parentCategory.ref
        $isPolicies = [bool]($p.key -match '\\Policies\\')
        $branchKind = Get-BranchKindFromPolicy -PolicyName $p.name -Class $p.class
        $valueName = ''
        if ($p.PSObject.Properties['valueName'] -and $p.valueName) { $valueName = $p.valueName }
        $entry = [pscustomobject]@{
            PolicyName      = $p.name
            DisplayName     = $displayName
            ValueName       = $valueName
            Class           = $p.class
            RegistryKey     = $p.key
            IsPolicies      = $isPolicies
            BranchKind      = $branchKind
            CategoryPath    = $catPath
            ParentCategory  = $p.parentCategory.ref
        }
        $policies += $entry
        [void]$allPaths.Add($catPath)

        $branchKey = "$displayName|$branchKind"
        if (-not $byDisplayBranch.ContainsKey($branchKey)) {
            $byDisplayBranch[$branchKey] = $entry
        }
        if (-not $byDisplayName.ContainsKey($displayName)) {
            $byDisplayName[$displayName] = [System.Collections.Generic.List[object]]::new()
        }
        $byDisplayName[$displayName].Add($entry)
    }

    return [pscustomobject]@{
        Policies         = $policies
        ByDisplayBranch  = $byDisplayBranch
        ByDisplayName    = $byDisplayName
        ValidPaths       = $allPaths
        CategoryPaths    = ($policies | ForEach-Object { $_.CategoryPath } | Sort-Object -Unique)
    }
}

function Parse-OldCategoryPath {
    param([string]$Path, [string]$ClassType)
    if ([string]::IsNullOrWhiteSpace($Path)) { return $null }
    $n = $Path.TrimEnd('\')

    if ($n -match '^\\Adobe \(Machine\)\\Acrobat & Reader DC \(Unified x64\)\\(.+)$') {
        return [pscustomobject]@{ Format = 'V221'; Branch = 'UnifiedAcrobat'; Category = $Matches[1]; ClassType = $ClassType }
    }
    if ($n -match '^\\Adobe \(Machine\)\\Acrobat DC \(x86\)\\(.+)$') {
        return [pscustomobject]@{ Format = 'V221'; Branch = 'AcrobatX86'; Category = $Matches[1]; ClassType = $ClassType }
    }
    if ($n -match '^\\Adobe \(Machine\)\\Reader DC \(x86\)\\(.+)$') {
        return [pscustomobject]@{ Format = 'V221'; Branch = 'ReaderX86'; Category = $Matches[1]; ClassType = $ClassType }
    }
    if ($n -match '^\\Adobe \(User\)\\Acrobat DC\\(.+)$') {
        return [pscustomobject]@{ Format = 'V221'; Branch = 'UserAcrobat'; Category = $Matches[1]; ClassType = $ClassType }
    }
    if ($n -match '^\\Adobe \(User\)\\Reader DC\\(.+)$') {
        return [pscustomobject]@{ Format = 'V221'; Branch = 'UserReader'; Category = $Matches[1]; ClassType = $ClassType }
    }
    if ($n -match '^\\Adobe\\(Acrobat DC|Reader DC)\\(x86|x64)\\(.+)$') {
        return [pscustomobject]@{
            Format   = 'V219'
            Product  = $Matches[1]
            Arch     = $Matches[2]
            Category = $Matches[3]
            Branch   = switch ("$($Matches[1])|$($Matches[2])") {
                'Acrobat DC|x64' { 'AcrobatX64' }
                'Acrobat DC|x86' { 'AcrobatX86' }
                'Reader DC|x64'  { 'ReaderX64' }
                'Reader DC|x86'  { 'ReaderX86' }
                default { 'Unknown' }
            }
            ClassType = $ClassType
        }
    }
    return $null
}

function Get-BranchKindPriority([string]$Branch) {
    switch ($Branch) {
        'UnifiedAcrobat' { return 100 }
        'AcrobatX64'     { return 100 }
        'AcrobatX86'     { return 50 }
        'ReaderX86'      { return 40 }
        'ReaderX64'      { return 30 }
        'UserAcrobat'    { return 10 }
        'UserReader'     { return 10 }
        default          { return 0 }
    }
}

function Get-CandidateBranchKinds {
    param([pscustomobject]$Parsed)
    switch ($Parsed.Branch) {
        'UnifiedAcrobat' { return @('AcrobatPolicies', 'AcrobatX64') }
        'AcrobatX64'     { return @('AcrobatPolicies', 'AcrobatX64') }
        'AcrobatX86'     { return @('AcrobatPolicies', 'AcrobatX86') }
        'ReaderX86'      { return @('ReaderPolicies', 'ReaderX86') }
        'ReaderX64'      { return @('AcrobatPolicies', 'ReaderPolicies', 'AcrobatX64') }
        'UserAcrobat'    { return @('UserAcrobat') }
        'UserReader'     { return @('UserReader') }
        default          { return @() }
    }
}

function Find-PolicyIndexEntry {
    param(
        [string]$DisplayName,
        [pscustomobject]$Parsed,
        $Index
    )
    $fn = $DisplayName.Trim()
    $candidates = Get-CandidateBranchKinds -Parsed $Parsed
    foreach ($kind in $candidates) {
        $key = "$fn|$kind"
        if ($Index.ByDisplayBranch.ContainsKey($key)) {
            return $Index.ByDisplayBranch[$key]
        }
    }
    if ($Index.ByDisplayName.ContainsKey($fn)) {
        $matches = @($Index.ByDisplayName[$fn])
        foreach ($kind in $candidates) {
            $hit = $matches | Where-Object { $_.BranchKind -eq $kind } | Select-Object -First 1
            if ($hit) { return $hit }
        }
    }
    return $null
}

function Get-SettingSignature {
    param($Setting)
    $pv = $null
    if ($Setting.PSObject.Properties['presentationValues'] -and $Setting.presentationValues) {
        $pv = ($Setting.presentationValues | ForEach-Object { $_.value }) -join '|'
    }
    return [pscustomobject]@{
        Enabled            = [bool]$Setting.enabled
        PresentationValues = $pv
    }
}

function Convert-SettingForExport {
    param($Setting, [string]$NewCategoryPath)
    $out = [ordered]@{
        enabled                = $Setting.enabled
        definitionDisplayName  = $Setting.definitionDisplayName
        definitionCategoryPath = $NewCategoryPath
        definitionClassType    = $Setting.definitionClassType
        migrationSourcePath    = $Setting.definitionCategoryPath
    }
    if ($Setting.PSObject.Properties['presentationValues'] -and $Setting.presentationValues) {
        $pvList = [System.Collections.Generic.List[object]]::new()
        foreach ($pv in $Setting.presentationValues) {
            $pvList.Add([ordered]@{
                '@odata.type'     = $pv.'@odata.type'
                presentationLabel = $pv.presentationLabel
                value             = $pv.value
                migrationNote     = 'Re-link presentation after combined v3.0 ADMX upload (presentationId removed).'
            })
        }
        $out['presentationValues'] = $pvList.ToArray()
    }
    $out['migrationNote'] = 'definitionId cleared - assign via Intune after uploading combined AdobeDC.admx v3.0.'
    return [pscustomobject]$out
}

function Convert-SingleExportFile {
    param(
        [string]$SourcePath,
        $Index
    )
    $export = Get-Content -LiteralPath $SourcePath -Raw -Encoding UTF8 | ConvertFrom-Json
    if (-not $export.settings) { throw "Input JSON has no settings array: $SourcePath" }

    $dir = [System.IO.Path]::GetDirectoryName($SourcePath)
    $base = [System.IO.Path]::GetFileNameWithoutExtension($SourcePath)
    $outputPath = Join-Path $dir "${base}_combined-v3.0.json"
    $reportPath = Join-Path $dir "${base}_combined-v3.0.migration-report.md"

    $acrobatX64ByName = @{}
    $readerX64ByName = @{}
    foreach ($s in $export.settings) {
        $p = Parse-OldCategoryPath -Path $s.definitionCategoryPath -ClassType $s.definitionClassType
        if (-not $p) { continue }
        $fn = $s.definitionDisplayName.Trim()
        if ($p.Branch -in @('UnifiedAcrobat', 'AcrobatX64') -or ($p.Format -eq 'V219' -and $p.Product -eq 'Acrobat DC' -and $p.Arch -eq 'x64')) {
            $acrobatX64ByName[$fn] = $s
        }
        if ($p.Branch -eq 'ReaderX64' -or ($p.Format -eq 'V219' -and $p.Product -eq 'Reader DC' -and $p.Arch -eq 'x64')) {
            $readerX64ByName[$fn] = $s
        }
    }

    $converted  = [System.Collections.Generic.List[object]]::new()
    $dropped    = [System.Collections.Generic.List[object]]::new()
    $conflicts  = [System.Collections.Generic.List[object]]::new()
    $unparsed   = [System.Collections.Generic.List[object]]::new()
    $dedupeKeys = @{}
    $dedupeMeta = @{}

    foreach ($s in $export.settings) {
        $parsed = Parse-OldCategoryPath -Path $s.definitionCategoryPath -ClassType $s.definitionClassType
        $fn = $s.definitionDisplayName.Trim()

        if (-not $parsed) {
            $unparsed.Add([pscustomobject]@{ FriendlyName = $fn; Path = $s.definitionCategoryPath })
            continue
        }

        if ($parsed.Branch -eq 'ReaderX64' -or ($parsed.Format -eq 'V219' -and $parsed.Product -eq 'Reader DC' -and $parsed.Arch -eq 'x64')) {
            if ($acrobatX64ByName.ContainsKey($fn)) {
                $dropped.Add([pscustomobject]@{
                    FriendlyName = $fn
                    SourcePath   = $s.definitionCategoryPath
                    Reason       = 'Reader x64 superseded by Acrobat x64 / Unified (Acrobat hive Policies).'
                })
                continue
            }
        }

        if ($parsed.Branch -eq 'ReaderX86' -and $Script:ArmFriendlyNames.Contains($fn)) {
            $dropped.Add([pscustomobject]@{
                FriendlyName = $fn
                SourcePath   = $s.definitionCategoryPath
                Reason       = 'ARM updater setting: combined v3.0 exposes under Non-Policy Acrobat DC (32-bit) only.'
            })
            continue
        }

        $entry = Find-PolicyIndexEntry -DisplayName $fn -Parsed $parsed -Index $Index
        if (-not $entry -and $Script:ArmFriendlyNames.Contains($fn)) {
            $armKey = "$fn|AcrobatX86"
            if ($Index.ByDisplayBranch.ContainsKey($armKey)) {
                $entry = $Index.ByDisplayBranch[$armKey]
            }
        }
        if (-not $entry) {
            $unparsed.Add([pscustomobject]@{
                FriendlyName = $fn
                Path         = $s.definitionCategoryPath
                Note         = "No matching combined v3.0 policy (branch $($parsed.Branch))."
            })
            continue
        }

        $newPath = $entry.CategoryPath
        $dedupeKey = "$fn|$newPath|$($s.definitionClassType)"
        $priority = Get-BranchKindPriority -Branch $parsed.Branch

        if ($dedupeKeys.ContainsKey($dedupeKey)) {
            $existing = $dedupeMeta[$dedupeKey]
            $existingSig = Get-SettingSignature $existing.Setting
            $newSig = Get-SettingSignature $s
            if ($existingSig.Enabled -ne $newSig.Enabled -or $existingSig.PresentationValues -ne $newSig.PresentationValues) {
                if ($priority -gt $existing.Priority) {
                    $conflicts.Add([pscustomobject]@{
                        FriendlyName   = $fn
                        TargetPath     = $newPath
                        KeptSource     = $s.definitionCategoryPath
                        DroppedSource  = $existing.Setting.definitionCategoryPath
                        Resolution     = 'Higher-precedence branch value kept.'
                    })
                    $converted.Remove($existing.ConvertedIndex)
                    $dedupeMeta[$dedupeKey] = [pscustomobject]@{ Setting = $s; Priority = $priority; ConvertedIndex = $converted.Count }
                    $converted.Add((Convert-SettingForExport -Setting $s -NewCategoryPath $newPath))
                    $dedupeKeys[$dedupeKey] = $s.definitionCategoryPath
                }
                else {
                    $conflicts.Add([pscustomobject]@{
                        FriendlyName   = $fn
                        TargetPath     = $newPath
                        KeptSource     = $existing.Setting.definitionCategoryPath
                        DroppedSource  = $s.definitionCategoryPath
                        Resolution     = 'First/higher-precedence source kept.'
                    })
                    $dropped.Add([pscustomobject]@{
                        FriendlyName = $fn
                        SourcePath   = $s.definitionCategoryPath
                        Reason       = "Duplicate target (conflict): kept $($existing.Setting.definitionCategoryPath)"
                    })
                }
            }
            else {
                $dropped.Add([pscustomobject]@{
                    FriendlyName = $fn
                    SourcePath   = $s.definitionCategoryPath
                    Reason       = "Duplicate v3.0 target (first source kept): $($dedupeKeys[$dedupeKey])"
                })
            }
            continue
        }

        $dedupeKeys[$dedupeKey] = $s.definitionCategoryPath
        $dedupeMeta[$dedupeKey] = [pscustomobject]@{
            Setting         = $s
            Priority        = $priority
            ConvertedIndex  = $converted.Count
        }
        $converted.Add((Convert-SettingForExport -Setting $s -NewCategoryPath $newPath))
    }

    $outObj = [ordered]@{
        schemaVersion      = 1
        policyDisplayName  = if ($export.policyDisplayName) { "$($export.policyDisplayName) [combined v3.0 migrated]" } else { 'Adobe DC ADMX [combined v3.0 migrated]' }
        policyDescription  = @(
            ($export.policyDescription)
            ''
            'Migrated to combined v3.0 ADMX category paths (\Adobe DC\...).'
            'Redundant Policies-branch duplicates removed. definitionId values cleared - re-upload AdobeDC.admx v3.0 to Intune and re-bind settings.'
        ) -join "`n"
        exportDate         = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ssK')
        migratedFrom       = $SourcePath
        sourceExportDate   = $export.exportDate
        sourceSettingCount = @($export.settings).Count
        settingCount       = $converted.Count
        settings           = $converted.ToArray()
    }

    $jsonOut = $outObj | ConvertTo-Json -Depth 20
    [System.IO.File]::WriteAllText($outputPath, $jsonOut, [System.Text.UTF8Encoding]::new($false))

    $rb = [System.Text.StringBuilder]::new()
    [void]$rb.AppendLine('# Combined v3.0 ADMX migration report')
    [void]$rb.AppendLine()
    [void]$rb.AppendLine('| | |')
    [void]$rb.AppendLine('|---|---|')
    [void]$rb.AppendLine("| Source | ``$SourcePath`` |")
    [void]$rb.AppendLine("| Output | ``$outputPath`` |")
    [void]$rb.AppendLine("| Source settings | $(@($export.settings).Count) |")
    [void]$rb.AppendLine("| Converted settings | $($converted.Count) |")
    [void]$rb.AppendLine("| Dropped | $($dropped.Count) |")
    [void]$rb.AppendLine("| Conflicts resolved | $($conflicts.Count) |")
    [void]$rb.AppendLine("| Unparsed | $($unparsed.Count) |")
    [void]$rb.AppendLine()
    [void]$rb.AppendLine('## Next steps')
    [void]$rb.AppendLine()
    [void]$rb.AppendLine('1. Upload `v3.0/AdobeDC.admx` + ADML to Intune.')
    [void]$rb.AppendLine('2. Create or update Administrative Templates profiles using converted paths and display names.')
    [void]$rb.AppendLine('3. Re-select enum/dropdown settings where `presentationValues` were preserved without Intune IDs.')
    [void]$rb.AppendLine('4. Review dropped and unparsed rows below before assigning.')
    [void]$rb.AppendLine()

    if ($conflicts.Count -gt 0) {
        [void]$rb.AppendLine('## Conflicts resolved')
        [void]$rb.AppendLine()
        [void]$rb.AppendLine('| FriendlyName | Target | Kept source | Dropped source | Resolution |')
        [void]$rb.AppendLine('|---|---|---|---|---|')
        foreach ($c in $conflicts) {
            [void]$rb.AppendLine("| $($c.FriendlyName) | ``$($c.TargetPath)`` | ``$($c.KeptSource)`` | ``$($c.DroppedSource)`` | $($c.Resolution) |")
        }
        [void]$rb.AppendLine()
    }

    if ($dropped.Count -gt 0) {
        [void]$rb.AppendLine('## Dropped settings')
        [void]$rb.AppendLine()
        [void]$rb.AppendLine('| FriendlyName | Source path | Reason |')
        [void]$rb.AppendLine('|---|---|---|')
        foreach ($d in ($dropped | Sort-Object FriendlyName, SourcePath)) {
            [void]$rb.AppendLine("| $($d.FriendlyName) | ``$($d.SourcePath)`` | $($d.Reason) |")
        }
        [void]$rb.AppendLine()
    }

    if ($unparsed.Count -gt 0) {
        [void]$rb.AppendLine('## Unparsed / unmatched settings')
        [void]$rb.AppendLine()
        foreach ($u in $unparsed) {
            $note = if ($u.Note) { " - $($u.Note)" } else { '' }
            [void]$rb.AppendLine("- **$($u.FriendlyName)**: ``$($u.Path)``$note")
        }
    }

    [System.IO.File]::WriteAllText($reportPath, $rb.ToString(), [System.Text.UTF8Encoding]::new($false))

    return [pscustomobject]@{
        SourcePath = $SourcePath
        OutputPath = $outputPath
        ReportPath = $reportPath
        Converted  = $converted.Count
        Dropped    = $dropped.Count
        Unparsed   = $unparsed.Count
        Conflicts  = $conflicts.Count
    }
}

# --- Main ---
$AdmxPath = [System.IO.Path]::GetFullPath($AdmxPath)
$AdmlPath = [System.IO.Path]::GetFullPath($AdmlPath)
if (-not (Test-Path -LiteralPath $AdmxPath)) { throw "ADMX not found: $AdmxPath" }
if (-not (Test-Path -LiteralPath $AdmlPath)) { throw "ADML not found: $AdmlPath" }

Write-Host "Building policy index from combined ADMX..." -ForegroundColor Cyan
$index = Build-CombinedAdmxPolicyIndex -AdmxFile $AdmxPath -AdmlFile $AdmlPath
Write-Host "  Indexed $($index.Policies.Count) policies, $($index.ValidPaths.Count) unique category paths"

$files = [System.Collections.Generic.List[string]]::new()
if ($PSCmdlet.ParameterSetName -eq 'File') {
    $files.Add([System.IO.Path]::GetFullPath($InputPath))
}
else {
    $InputDir = [System.IO.Path]::GetFullPath($InputDir)
    Get-ChildItem -LiteralPath $InputDir -Filter '*.json' | ForEach-Object {
        if ($_.Name -notmatch '_combined-v3\.0\.json$') {
            $files.Add($_.FullName)
        }
    }
}

if ($files.Count -eq 0) { throw 'No input JSON files found.' }

$results = @()
foreach ($f in $files) {
    if (-not (Test-Path -LiteralPath $f)) { throw "Input file not found: $f" }
    Write-Host "`nConverting: $f" -ForegroundColor Cyan
    $r = Convert-SingleExportFile -SourcePath $f -Index $index
    $results += $r
    Write-Host "  Converted: $($r.Converted) | Dropped: $($r.Dropped) | Unparsed: $($r.Unparsed)"
    Write-Host "  Output:    $($r.OutputPath)"
    Write-Host "  Report:    $($r.ReportPath)"
}

Write-Host "`nDone. $($results.Count) file(s) converted." -ForegroundColor Green
