#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Applies recommended security-hardening and reduce-nags settings for all Adobe DC
    products: Reader DC x86/x64 and Acrobat DC x86/x64.
.DESCRIPTION
    Writes HKLM machine-policy DWORDs across all four product/architecture registry
    branches in a single pass.

    Values are aligned to:
      - Documentation\data\security-hardening.json  (Recommended entries only)
      - Documentation\data\reduce-nags.json          (all entries)
      - v2.7 ADMX registry key paths

    IT admins: edit the arrays below to adjust individual settings.
    Do NOT modify the apply loops at the bottom unless changing the script structure.

    Designed for 64-bit Windows (writes both native and WOW6432Node branches).
.NOTES
    Must run as Administrator (HKLM writes).
    Close and reopen all Adobe products after running to see changes.
#>
[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║  PRODUCT TARGETS — one entry per product/architecture combination          ║
# ║  Comment out a row to skip that target.                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝
$ProductTargets = @(
    @{ Name = 'Reader x64';  Product = 'Reader';  PolicyRoot = 'HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC';              InstallerRoot = 'HKLM:\SOFTWARE\Adobe\Acrobat Reader\DC' }
    @{ Name = 'Reader x86';  Product = 'Reader';  PolicyRoot = 'HKLM:\SOFTWARE\WOW6432Node\Policies\Adobe\Acrobat Reader\DC';  InstallerRoot = 'HKLM:\SOFTWARE\WOW6432Node\Adobe\Acrobat Reader\DC' }
    @{ Name = 'Acrobat x64'; Product = 'Acrobat'; PolicyRoot = 'HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC';               InstallerRoot = 'HKLM:\SOFTWARE\Adobe\Adobe Acrobat\DC' }
    @{ Name = 'Acrobat x86'; Product = 'Acrobat'; PolicyRoot = 'HKLM:\SOFTWARE\WOW6432Node\Policies\Adobe\Adobe Acrobat\DC';   InstallerRoot = 'HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe Acrobat\DC' }
)

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║  COMMON POLICY ENTRIES — applied to ALL four targets                       ║
# ║  Subkey is relative to each target's PolicyRoot.                           ║
# ║  Each row: Subkey, Name (registry value), Value (DWORD), # comment         ║
# ╚════════════════════════════════════════════════════════════════════════════╝
$CommonPolicyEntries = @(
    # ── Security Hardening (Recommended) ─────────────────────────────────────
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnhancedSecurityInBrowser';       Value = 1 }   # Enhanced Security in Browser
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnhancedSecurityStandalone';      Value = 1 }   # Enhanced Security Standalone
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnableFlash';                     Value = 0 }   # Disable Flash Content
    @{ Subkey = 'FeatureLockDown';                          Name = 'bDisablePDFRedirectionActions';    Value = 1 }   # Block PDF Link Actions
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnableGentech';                   Value = 0 }   # Disable Generative AI
    @{ Subkey = 'FeatureLockDown\cDefaultLaunchURLPerms';   Name = 'iUnknownURLPerms';                 Value = 1 }   # Unknown URL Access: always ask
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleWebConnectors';             Value = 1 }   # Disable Third-Party Cloud Connectors (inverted: 1=off)
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bBoxConnectorEnabled';             Value = 0 }   # Disable Box Connector
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bDropboxConnectorEnabled';         Value = 0 }   # Disable Dropbox Connector
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bGoogleDriveConnectorEnabled';     Value = 0 }   # Disable Google Drive Connector
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bOneDriveConnectorEnabled';        Value = 0 }   # Disable OneDrive Connector
    @{ Subkey = 'FeatureLockDown\cSecurity\cPPKLite';       Name = 'bAllowPasswordSaving';             Value = 0 }   # Disable Password Caching
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleDocumentCloud';             Value = 1 }   # Disable Document Cloud Storage (inverted: 1=off)
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleAdobeDocumentServices';     Value = 1 }   # Disable Document Cloud Services (inverted: 1=off)

    # ── Reduce Nags: Startup & Experience ────────────────────────────────────
    @{ Subkey = 'FeatureLockDown\cIPM';                     Name = 'bShowMsgAtLaunch';                 Value = 0 }   # Suppress Adobe Messages at Launch
    @{ Subkey = 'FeatureLockDown\cIPM';                     Name = 'bAllowUserToChangeMsgPrefs';       Value = 0 }   # Lock Message Preferences
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleNotifications';             Value = 1 }   # Disable Desktop Notifications (inverted: 1=off)
    @{ Subkey = 'FeatureLockDown';                          Name = 'bToggleFTE';                       Value = 1 }   # Disable First Time Experience (inverted: 1=off)
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bEnableBellButton';                Value = 1 }   # Hide Notifications Bell (1=hidden)
    @{ Subkey = 'FeatureLockDown';                          Name = 'bToggleShareFeedback';             Value = 0 }   # Hide Send Feedback Icon
    @{ Subkey = 'FeatureLockDown';                          Name = 'bToggleToDoList';                  Value = 1 }   # Disable Home Screen To Do List (inverted: 1=off)
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleNotificationToasts';        Value = 1 }   # Disable Desktop Notification Toasts (inverted: 1=off)
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bTogglePDFOwnershipToasts';        Value = 1 }   # Disable PDF Ownership Notifications (inverted: 1=off)
    @{ Subkey = 'FeatureLockDown';                          Name = 'bToggleToDoTiles';                 Value = 1 }   # Disable To Do Cards in Recent Tab (inverted: 1=off)
    @{ Subkey = 'FeatureLockDown';                          Name = 'bWhatsNewExp';                     Value = 1 }   # Disable What's New Experience (inverted: 1=off)

    # ── Reduce Nags: Context, Tools & Search ─────────────────────────────────
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnableContextualTips';            Value = 0 }   # Disable Contextual Help Tips
    @{ Subkey = 'FeatureLockDown';                          Name = 'bFindMoreWorkflowsOnline';         Value = 0 }   # Hide Online Actions Library Link
    @{ Subkey = 'FeatureLockDown';                          Name = 'bFindMoreCustomizationsOnline';    Value = 0 }   # Hide Online Tool Set Exchange Link
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnableAV2Enterprise';             Value = 1 }   # Modern Viewer (enterprise mode)

    # ── Reduce Nags: Upsell ──────────────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown';                          Name = 'bLimitPromptsFeatureKey';          Value = 1 }   # Limit Informational Prompts
    @{ Subkey = 'FeatureLockDown';                          Name = 'bToggleDCAppCenter';               Value = 1 }   # Disable App Center UI (inverted: 1=off)

    # ── Reduce Nags: Updates ─────────────────────────────────────────────────
    # bUpdater appears in two ADMX keys; set both to ensure full coverage
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bUpdater';                         Value = 0 }   # Disable Services & Web-Plugin Updates
    @{ Subkey = 'FeatureLockDown';                          Name = 'bUpdater';                         Value = 0 }   # Disable Product Updater
)

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║  READER-ONLY POLICY ENTRIES — applied to Reader x64 + Reader x86 only      ║
# ╚════════════════════════════════════════════════════════════════════════════╝
$ReaderOnlyPolicyEntries = @(
    # ── Security Hardening ───────────────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown';      Name = 'bProtectedMode';                    Value = 1 }   # Protected Mode Sandbox
    @{ Subkey = 'FeatureLockDown';      Name = 'bEnableProtectedModeAppContainer';  Value = 1 }   # AppContainer Sandbox

    # ── Reduce Nags ──────────────────────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown\cIPM'; Name = 'bDontShowMsgWhenViewingDoc';        Value = 0 }   # Hide Messages on Document Open
    @{ Subkey = 'FeatureLockDown';      Name = 'bAcroSuppressUpsell';               Value = 1 }   # Suppress Upgrade Prompts
    @{ Subkey = 'FeatureLockDown';      Name = 'bReaderRetentionExperiment';        Value = 0 }   # Disable Acrobat Download Prompt
    @{ Subkey = 'FeatureLockDown';      Name = 'bShowRhpToolSearch';                Value = 0 }   # Hide Purchasable Tools in Search
    @{ Subkey = 'FeatureLockDown';      Name = 'bEnableAcrobatPromptForDocOpen';    Value = 0 }   # Disable "Use Acrobat" Prompt
)

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║  ACROBAT-ONLY POLICY ENTRIES — applied to Acrobat x64 + Acrobat x86 only   ║
# ╚════════════════════════════════════════════════════════════════════════════╝
$AcrobatOnlyPolicyEntries = @(
    # ── Security Hardening ───────────────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown';      Name = 'iProtectedView';                    Value = 1 }   # Protected View: unsafe locations

    # ── Reduce Nags ──────────────────────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown';      Name = 'bToggleBillingIssue';               Value = 0 }   # Disable Billing Issue Call to Action
    @{ Subkey = 'FeatureLockDown';      Name = 'bToggleSophiaWebInfra';             Value = 0 }   # Disable Promotional Campaign Messages
    @{ Subkey = 'FeatureLockDown';      Name = 'bMerchandizingEnabled';             Value = 0 }   # Disable Express Templates in Create PDF
    @{ Subkey = 'FeatureLockDown';      Name = 'bEnableTrialistLaunchCard';         Value = 0 }   # Disable Trial Purchase Prompt
    @{ Subkey = 'FeatureLockDown';      Name = 'bEnableReviewPromote';              Value = 0 }   # Disable Share and Review Reminder
    @{ Subkey = 'FeatureLockDown';      Name = 'bCrashReporterEnabled';             Value = 0 }   # Disable Crash Reporter Dialog
)

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║  EXTRA ENTRIES — absolute paths outside the Policy root                    ║
# ║  ARM updater paths and per-product Installer keys.                         ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Adobe ARM upgrade prompt (shared by all products; one per registry view)
$ArmEntries = @(
    @{ Path = 'HKLM:\SOFTWARE\Adobe\Adobe ARM\1.0\ARM';                    Name = 'iDisablePromptForUpgrade'; Value = 1 }   # x64 ARM
    @{ Path = 'HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe ARM\1.0\ARM';        Name = 'iDisablePromptForUpgrade'; Value = 1 }   # x86 ARM (WOW64)
)

# Installer repair settings — built dynamically per target in the apply loop
$InstallerEntries = @(
    @{ Subkey = 'Installer'; Name = 'Disable_Repair';     Value = 1 }    # Disable Repair for Standard Users
    @{ Subkey = 'Installer'; Name = 'DisableMaintenance';  Value = 1 }   # Disable Repair for All Users
)

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║  APPLY LOGIC — do not modify unless changing the script structure          ║
# ╚════════════════════════════════════════════════════════════════════════════╝

function Set-RegistryDword {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$KeyPath,
        [string]$Name,
        [int]$Value
    )
    if (-not (Test-Path $KeyPath)) {
        if ($PSCmdlet.ShouldProcess($KeyPath, 'Create registry key')) {
            New-Item -Path $KeyPath -Force | Out-Null
        }
    }
    if ($PSCmdlet.ShouldProcess("$KeyPath  ->  $Name = $Value", 'Set DWORD')) {
        New-ItemProperty -Path $KeyPath -Name $Name -Value $Value -PropertyType DWord -Force | Out-Null
        Write-Host "  [OK]  $KeyPath\$Name = $Value"
        return 1
    }
    return 0
}

$totalCount = 0

# ── 1. Common policy entries → all four targets ─────────────────────────────
foreach ($target in $ProductTargets) {
    Write-Host ''
    Write-Host "── $($target.Name): Common settings ──"
    foreach ($e in $CommonPolicyEntries) {
        $keyPath = Join-Path $target.PolicyRoot $e.Subkey
        $totalCount += Set-RegistryDword -KeyPath $keyPath -Name $e.Name -Value $e.Value
    }
}

# ── 2. Reader-only policy entries → Reader targets ──────────────────────────
foreach ($target in $ProductTargets | Where-Object { $_.Product -eq 'Reader' }) {
    Write-Host ''
    Write-Host "── $($target.Name): Reader-only settings ──"
    foreach ($e in $ReaderOnlyPolicyEntries) {
        $keyPath = Join-Path $target.PolicyRoot $e.Subkey
        $totalCount += Set-RegistryDword -KeyPath $keyPath -Name $e.Name -Value $e.Value
    }
}

# ── 3. Acrobat-only policy entries → Acrobat targets ────────────────────────
foreach ($target in $ProductTargets | Where-Object { $_.Product -eq 'Acrobat' }) {
    Write-Host ''
    Write-Host "── $($target.Name): Acrobat-only settings ──"
    foreach ($e in $AcrobatOnlyPolicyEntries) {
        $keyPath = Join-Path $target.PolicyRoot $e.Subkey
        $totalCount += Set-RegistryDword -KeyPath $keyPath -Name $e.Name -Value $e.Value
    }
}

# ── 4. Installer entries (Disable_Repair, DisableMaintenance) → all targets ─
Write-Host ''
Write-Host '── Installer settings (all products) ──'
foreach ($target in $ProductTargets) {
    foreach ($e in $InstallerEntries) {
        $keyPath = Join-Path $target.InstallerRoot $e.Subkey
        $totalCount += Set-RegistryDword -KeyPath $keyPath -Name $e.Name -Value $e.Value
    }
}

# ── 5. ARM updater entries (shared, fixed paths) ────────────────────────────
Write-Host ''
Write-Host '── ARM updater settings ──'
foreach ($e in $ArmEntries) {
    $totalCount += Set-RegistryDword -KeyPath $e.Path -Name $e.Name -Value $e.Value
}

# ── Summary ──────────────────────────────────────────────────────────────────
Write-Host ''
Write-Host "Applied $totalCount registry values across all Adobe DC products."
Write-Host ''
Write-Host 'Close and reopen all Adobe products to see changes.'
