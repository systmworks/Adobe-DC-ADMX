#Requires -Version 5.1
<#
.SYNOPSIS
  Reads or writes Adobe DC Built-in Attachment Permissions List (tBuiltInPermList) as REG_BINARY.

.DESCRIPTION
  WHY THIS SCRIPT EXISTS (NOT IN THE ADMX)
  ----------------------------------------
  Built-in Attachment Permissions List (tBuiltInPermList) defines which file extensions may be
  opened or saved from PDF attachments. It is a security control referenced by the ADMX policy
  Attachment Extension Blocklist in Dialogs (bEnableBlacklistForOpenSave).

  Acrobat/Reader stores this preference as REG_BINARY — an opaque, app-serialized byte blob.
  The ADMX/ADML schema has no binary element type (only text, decimal, enum, boolean, list), so
  REG_BINARY cannot be authored via Group Policy or Intune ADMX upload.

  Combined ADMX v3.1 incorrectly exposed this setting as a <text> REG_SZ box; Acrobat cannot
  read that form. It was removed in v3.2. Use this script, Group Policy Preferences registry
  items, or Intune custom OMA-URI with captured bytes instead.

  RECOMMENDED DEPLOYMENT PATH
  ---------------------------
  1. Configure the attachment list once in Acrobat Trust Manager on a reference machine.
  2. Run -ExportHex on that machine to capture the exact REG_BINARY bytes Acrobat wrote.
  3. Deploy those bytes with -ImportHex (this script), GPP registry items, or Intune OMA-URI.

  -ImportHex is the trusted path. -PermList writes UTF-8 bytes of the logical string and is
  best-effort only — Acrobat may expect a different encoding on your build.

  PERMISSION STRING FORMAT (for -PermList / decode reference)
  ----------------------------------------------------------
  Adobe documents the logical value as a pipe-separated string, for example:
    version:1|.pdf:2|.zip:1|.exe:3
  Levels: 0=prompt (no allow), 1=prompt (allow/prohibit), 2=always open, 3=never open.

.PARAMETER PermList
  Permission string in Adobe format (version:1|.ext:N|...). Best-effort encoding only.

.PARAMETER Product
  Target product hive: Acrobat, Reader, or Both (default).

.PARAMETER Export
  Read current value and print decoded string (best effort) plus hex.

.PARAMETER ExportHex
  Print raw hex only (for Intune OMA-URI / GPP binary import). Primary capture method.

.PARAMETER ImportHex
  Write exact byte values from a hex string (spaces optional). Preferred deployment method.

.EXAMPLE
  .\Set-AdobeBuiltInPermList.ps1 -Product Reader -ExportHex

.EXAMPLE
  .\Set-AdobeBuiltInPermList.ps1 -Product Both -ImportHex '76 65 72 73 69 6F 6E 3A 31 ...'

.EXAMPLE
  .\Set-AdobeBuiltInPermList.ps1 -Product Both -PermList 'version:1|.pdf:2|.zip:3' -WhatIf

.NOTES
  Registry paths (Policies):
    HKLM\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cDefaultLaunchAttachmentPerms
    HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\cDefaultLaunchAttachmentPerms
  Value name: tBuiltInPermList (REG_BINARY)
  License: CC BY-SA 4.0 — https://github.com/systmworks/Adobe-DC-ADMX/
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(ParameterSetName = 'Set')]
    [ValidateNotNullOrEmpty()]
    [string]$PermList,

    [Parameter(ParameterSetName = 'ImportHex')]
    [ValidateNotNullOrEmpty()]
    [string]$ImportHex,

    [ValidateSet('Acrobat', 'Reader', 'Both')]
    [string]$Product = 'Both',

    [Parameter(ParameterSetName = 'Export')]
    [switch]$Export,

    [Parameter(ParameterSetName = 'ExportHex')]
    [switch]$ExportHex
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Script:ProductPaths = @{
    Acrobat = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cDefaultLaunchAttachmentPerms'
    Reader  = 'SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\cDefaultLaunchAttachmentPerms'
}

function Get-TargetProducts {
    if ($Product -eq 'Both') { return @('Acrobat', 'Reader') }
    return @($Product)
}

function ConvertTo-HexString([byte[]]$Bytes) {
    return (($Bytes | ForEach-Object { $_.ToString('X2') }) -join ' ')
}

function ConvertFrom-HexString([string]$Hex) {
    $clean = ($Hex -replace '\s', '' -replace '0x', '')
    if ($clean.Length % 2 -ne 0) { throw 'Hex string must have an even number of digits.' }
    $bytes = New-Object byte[] ($clean.Length / 2)
    for ($i = 0; $i -lt $bytes.Length; $i++) {
        $bytes[$i] = [Convert]::ToByte($clean.Substring($i * 2, 2), 16)
    }
    return $bytes
}

function ConvertFrom-RegistryBinaryText([byte[]]$Bytes) {
    if ($Bytes.Length -eq 0) { return '' }
    foreach ($enc in @(
            [System.Text.Encoding]::UTF8,
            [System.Text.Encoding]::Unicode,
            [System.Text.Encoding]::ASCII
        )) {
        $text = $enc.GetString($Bytes).Trim([char]0)
        if (-not [string]::IsNullOrWhiteSpace($text) -and $text -match '^version:\d') {
            return $text
        }
    }
    return $null
}

function ConvertTo-RegistryBinaryText([string]$Text) {
    if ($Text -notmatch '^version:\d+\|') {
        throw "PermList must start with version:N| (Adobe format). Example: version:1|.pdf:2"
    }
    return [System.Text.Encoding]::UTF8.GetBytes($Text)
}

function Get-BuiltInPermListBytes {
    param(
        [ValidateSet('Acrobat', 'Reader')][string]$TargetProduct
    )
    $path = "HKLM:\$($Script:ProductPaths[$TargetProduct])"
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Registry key not found: $path. Configure tBuiltInPermList in Acrobat Trust Manager first, or deploy with -ImportHex."
    }
    $props = Get-ItemProperty -LiteralPath $path -ErrorAction Stop
    if ($props.PSObject.Properties.Name -notcontains 'tBuiltInPermList') {
        throw "Value tBuiltInPermList not found under $path. Capture bytes with -ExportHex after configuring Acrobat Trust Manager."
    }
    return [byte[]]$props.tBuiltInPermList
}

function Set-BuiltInPermListBytes {
    param(
        [ValidateSet('Acrobat', 'Reader')][string]$TargetProduct,
        [byte[]]$Bytes,
        [string]$ActionLabel
    )
    $path = "HKLM:\$($Script:ProductPaths[$TargetProduct])"
    if (-not $PSCmdlet.ShouldProcess($path, $ActionLabel)) {
        return $false
    }
    if (-not (Test-Path -LiteralPath $path)) {
        New-Item -Path $path -Force | Out-Null
    }
    Set-ItemProperty -LiteralPath $path -Name 'tBuiltInPermList' -Value $Bytes -Type Binary
    return $true
}

foreach ($target in Get-TargetProducts) {
    if ($Export -or $ExportHex) {
        $bytes = Get-BuiltInPermListBytes -TargetProduct $target
        Write-Host "[$target] tBuiltInPermList ($($bytes.Length) bytes)"
        if ($ExportHex) {
            Write-Host (ConvertTo-HexString $bytes)
        }
        else {
            $decoded = ConvertFrom-RegistryBinaryText $bytes
            if ($decoded) {
                Write-Host "Decoded: $decoded"
            }
            else {
                Write-Host 'Decoded: (unable to decode as version:N| string — use hex below for deployment)'
            }
            Write-Host "Hex: $(ConvertTo-HexString $bytes)"
        }
        continue
    }

    if ($PSCmdlet.ParameterSetName -eq 'ImportHex') {
        $bytes = ConvertFrom-HexString $ImportHex
        if (Set-BuiltInPermListBytes -TargetProduct $target -Bytes $bytes -ActionLabel "Set tBuiltInPermList REG_BINARY from hex ($($bytes.Length) bytes)") {
            Write-Host "[$target] Wrote tBuiltInPermList from hex ($($bytes.Length) bytes)."
        }
        continue
    }

    Write-Warning "[$target] -PermList writes UTF-8 bytes (best-effort). Prefer -ExportHex from a configured machine, then deploy with -ImportHex."
    $bytes = ConvertTo-RegistryBinaryText $PermList
    if (Set-BuiltInPermListBytes -TargetProduct $target -Bytes $bytes -ActionLabel "Set tBuiltInPermList REG_BINARY from PermList ($($bytes.Length) bytes)") {
        Write-Host "[$target] Wrote tBuiltInPermList from PermList ($($bytes.Length) bytes)."
    }
}
