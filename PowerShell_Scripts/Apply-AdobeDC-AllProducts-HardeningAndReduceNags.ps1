#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Applies recommended security-hardening and reduce-nags settings for all Adobe DC
    products: Reader DC x86/x64 and Acrobat DC x86/x64.
.DESCRIPTION
    Writes HKLM machine-policy DWORDs across all four product/architecture registry
    branches in a single pass.

    Values are aligned to:
      - Documentation\security-hardening.md  (all Recommended + Optional entries)
      - Documentation\reduce-nags.md         (all entries)
      - v2.15 ADMX registry key paths

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
# ╚════════════════════════════════════════════════════════════════════════════╝
$CommonPolicyEntries = @(
    # ── Security Hardening (Recommended) ─────────────────────────────────────
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bEnhancedSecurityInBrowser';       Value = 1 }   # Enhanced Security in Browser
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bEnhancedSecurityStandalone';      Value = 1 }   # Enhanced Security Standalone
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bEnableFlash';                     Value = 0 }   # Disable Flash Content
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bEnable3D';                        Value = 0 }   # Disable 3D Content in PDFs
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bDisablePDFRedirectionActions';    Value = 1 }   # Block PDF Link Actions
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bEnableGentech';                   Value = 0 }   # Disable Generative AI
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bDisableJavaScript';               Value = 1 }   # Block JavaScript Execution
    @{ Subkey = 'FeatureLockDown\cDefaultLaunchURLPerms';              Name = 'iUnknownURLPerms';                 Value = 1 }   # Unknown URL Access: always ask
    @{ Subkey = 'FeatureLockDown\cDefaultLaunchAttachmentPerms';       Name = 'iUnlistedAttachmentTypePerm';      Value = 0 }   # Unlisted attachments: prompt without ability to allow
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bToggleWebConnectors';             Value = 1 }   # Disable Third-Party Cloud Connectors
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bBoxConnectorEnabled';             Value = 0 }   # Disable Box Connector
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bDropboxConnectorEnabled';         Value = 0 }   # Disable Dropbox Connector
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bGoogleDriveConnectorEnabled';     Value = 0 }   # Disable Google Drive Connector
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bOneDriveConnectorEnabled';        Value = 0 }   # Disable OneDrive Connector
    @{ Subkey = 'FeatureLockDown\cSecurity\cPPKLite';                  Name = 'bAllowPasswordSaving';             Value = 0 }   # Disable Password Caching
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bToggleDocumentCloud';             Value = 1 }   # Disable Document Cloud Storage
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bToggleAdobeDocumentServices';     Value = 1 }   # Disable Document Cloud Services
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bTogglePrefsSync';                 Value = 1 }   # Disable Preferences Synchronization
    @{ Subkey = 'FeatureLockDown\cCloud';                              Name = 'bAdobeSendPluginToggle';           Value = 1 }   # Disable Send & Track Outlook Plugin
    @{ Subkey = 'FeatureLockDown\cSharePoint';                         Name = 'bDisableSharePointFeatures';       Value = 1 }   # Disable SharePoint & Office 365 Integration
    @{ Subkey = 'FeatureLockDown\cWebmailProfiles';                    Name = 'bDisableWebmail';                  Value = 1 }   # Disable WebMail Integration

    # ── Security Hardening (Optional) ────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bToggleFillSign';                  Value = 1 }   # Disable Adobe Fill & Sign
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bDisableOSTrustedSites';           Value = 1 }   # Disable IE Trusted Sites as Privileged Locations
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bDisableTrustedFolders';           Value = 1 }   # Lock Trusted Folders and Files
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bDisableTrustedSites';             Value = 1 }   # Lock Trusted Host Sites
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bToggleAdobeSign';                 Value = 1 }   # Disable Adobe Acrobat Sign
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bToggleSendAndTrack';              Value = 1 }   # Disable Adobe Send & Track
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bToggleAdobeReview';               Value = 1 }   # Disable Document Cloud Review Service
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bToggleFSSSignatureSaving';        Value = 1 }   # Disable Save Signature to Cloud

    # ── Reduce Nags: Startup & Experience ────────────────────────────────────
    @{ Subkey = 'FeatureLockDown\cIPM';                                Name = 'bShowMsgAtLaunch';                 Value = 0 }   # Suppress Adobe Messages at Launch
    @{ Subkey = 'FeatureLockDown\cIPM';                                Name = 'bAllowUserToChangeMsgPrefs';       Value = 0 }   # Lock Message Preferences
    @{ Subkey = 'FeatureLockDown\cIPM';                                Name = 'bDontShowMsgWhenViewingDoc';       Value = 0 }   # Hide Messages on Document Open
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bToggleNotifications';             Value = 1 }   # Disable Desktop Notifications
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bToggleFTE';                       Value = 1 }   # Disable First Time Experience
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bEnableBellButton';                Value = 1 }   # Hide Notifications Bell
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bToggleShareFeedback';             Value = 0 }   # Hide Send Feedback Icon
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bToggleToDoList';                  Value = 1 }   # Disable Home Screen To Do List
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bToggleNotificationToasts';        Value = 1 }   # Disable Desktop Notification Toasts
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bTogglePDFOwnershipToasts';        Value = 1 }   # Disable PDF Ownership Notifications
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bToggleToDoTiles';                 Value = 1 }   # Disable To Do Cards in Recent Tab
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bWhatsNewExp';                     Value = 1 }   # Disable What's New Experience
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bShowScanTabInHomeView';           Value = 0 }   # Hide Scan Tab in Home View

    # ── Reduce Nags: Context, Tools & Search ─────────────────────────────────
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bEnableContextualTips';            Value = 0 }   # Disable Contextual Help Tips
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bFindMoreWorkflowsOnline';         Value = 0 }   # Hide Online Actions Library Link
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bFindMoreCustomizationsOnline';    Value = 0 }   # Hide Online Tool Set Exchange Link
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bEnableAV2Enterprise';             Value = 1 }   # Modern Viewer (enterprise mode)

    # ── Reduce Nags: Sharing & Features ──────────────────────────────────────
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bToggleManageSign';                Value = 1 }   # Hide Acrobat Sign Tracking Tab

    # ── Reduce Nags: Upsell ──────────────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bLimitPromptsFeatureKey';          Value = 1 }   # Limit Informational Prompts
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bToggleDCAppCenter';               Value = 1 }   # Disable App Center UI
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bAcroSuppressUpsell';              Value = 1 }   # Suppress Upgrade Prompts

    # ── Reduce Nags: Updates ─────────────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown\cServices';                           Name = 'bUpdater';                         Value = 0 }   # Disable Services & Web-Plugin Updates
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bUpdater';                         Value = 0 }   # Disable Product Updater
    @{ Subkey = 'FeatureLockDown';                                     Name = 'PatchCleanFlag';                   Value = 1 }   # Patch Cache Cleanup
    @{ Subkey = 'FeatureLockDown';                                     Name = 'bDisablePDFHandlerSwitching';      Value = 1 }   # Lock Default PDF Viewer
)

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║  READER-ONLY POLICY ENTRIES — applied to Reader x64 + Reader x86 only      ║
# ╚════════════════════════════════════════════════════════════════════════════╝
$ReaderOnlyPolicyEntries = @(
    # ── Security Hardening ───────────────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown';      Name = 'bProtectedMode';                    Value = 1 }   # Protected Mode Sandbox
    @{ Subkey = 'FeatureLockDown';      Name = 'bEnableProtectedModeAppContainer';  Value = 1 }   # AppContainer Sandbox

    # ── Reduce Nags ──────────────────────────────────────────────────────────
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
    @{ Subkey = 'FeatureLockDown';      Name = 'bEnableCloudPoweredSearch';         Value = 0 }   # Disable Cloud-Powered Search
    @{ Subkey = 'FeatureLockDown';      Name = 'bEnableCloudPoweredSearchTokenCaching'; Value = 0 }   # Disable Cloud Search Token Caching

    # ── Reduce Nags ──────────────────────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown';      Name = 'bIsSCReducedModeEnforcedEx';        Value = 1 }   # Reader mode on Acrobat (reduced mode)
    @{ Subkey = 'FeatureLockDown';      Name = 'bToggleBillingIssue';               Value = 0 }   # Disable Billing Issue Call to Action
    @{ Subkey = 'FeatureLockDown';      Name = 'bToggleSophiaWebInfra';             Value = 0 }   # Disable Promotional Campaign Messages
    @{ Subkey = 'FeatureLockDown';      Name = 'bMerchandizingEnabled';             Value = 0 }   # Disable Express Templates in Create PDF
    @{ Subkey = 'FeatureLockDown';      Name = 'bEnableTrialistLaunchCard';         Value = 0 }   # Disable Trial Purchase Prompt
    @{ Subkey = 'FeatureLockDown';      Name = 'bEnableReviewPromote';              Value = 0 }   # Disable Share and Review Reminder
    @{ Subkey = 'FeatureLockDown';      Name = 'bCrashReporterEnabled';             Value = 0 }   # Disable Crash Reporter Dialog
)

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║  EXTRA ENTRIES — absolute paths outside the Policy root                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

$ArmEntries = @(
    @{ Path = 'HKLM:\SOFTWARE\Adobe\Adobe ARM\1.0\ARM';                    Name = 'iDisablePromptForUpgrade'; Value = 1 }   # x64 ARM
    @{ Path = 'HKLM:\SOFTWARE\WOW6432Node\Adobe\Adobe ARM\1.0\ARM';        Name = 'iDisablePromptForUpgrade'; Value = 1 }   # x86 ARM (WOW64)
)

$InstallerEntries = @(
    @{ Subkey = 'Installer';     Name = 'Disable_Repair';     Value = 1 }   # Disable Repair for Standard Users
    @{ Subkey = 'Installer';     Name = 'DisableMaintenance';  Value = 1 }   # Disable Repair for All Users
    @{ Subkey = 'AdobeViewer';   Name = 'EULA';                Value = 1 }   # Accept EULA for Updater
)

# FeatureState entries (non-Policies paths) — Acrobat targets only
$AcrobatFeatureStateEntries = @(
    @{ Subkey = 'FeatureState';  Name = 'BlockEMFParsing';     Value = 1 }   # Block EMF to PDF Conversion
    @{ Subkey = 'FeatureState';  Name = 'BlockXPSParsing';     Value = 1 }   # Block XPS to PDF Conversion
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

# ── 4. Installer entries (Disable_Repair, DisableMaintenance, EULA) → all ──
Write-Host ''
Write-Host '── Installer settings (all products) ──'
foreach ($target in $ProductTargets) {
    foreach ($e in $InstallerEntries) {
        $keyPath = Join-Path $target.InstallerRoot $e.Subkey
        $totalCount += Set-RegistryDword -KeyPath $keyPath -Name $e.Name -Value $e.Value
    }
}

# ── 5. Acrobat FeatureState entries (non-Policies paths) ────────────────────
Write-Host ''
Write-Host '── Acrobat FeatureState settings ──'
foreach ($target in $ProductTargets | Where-Object { $_.Product -eq 'Acrobat' }) {
    foreach ($e in $AcrobatFeatureStateEntries) {
        $keyPath = Join-Path $target.InstallerRoot $e.Subkey
        $totalCount += Set-RegistryDword -KeyPath $keyPath -Name $e.Name -Value $e.Value
    }
}

# ── 6. ARM updater entries (shared, fixed paths) ────────────────────────────
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
