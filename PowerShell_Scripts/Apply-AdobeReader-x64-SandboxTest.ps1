#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Applies recommended security-hardening and reduce-nags settings for Reader DC under the
    native x64 hive.
.DESCRIPTION
    Writes HKLM machine-policy DWORDs that Reader DC (64-bit) reads.
    Policy root: HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC

    Values are aligned to:
      - Documentation\security-hardening.md  (all Recommended + Optional entries, Reader scope)
      - Documentation\reduce-nags.md          (all Reader-scoped entries)
      - v2.15 ADMX registry key paths

    Run this script ALONE (without the x86 Reader or Acrobat scripts) to confirm
    that 64-bit Reader reads from this native branch.
.NOTES
    Must run as Administrator (HKLM writes).
    Close and reopen Adobe Reader after running to see changes.
#>
[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'

$Root = 'HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC'
$InstallerRoot = 'HKLM:\SOFTWARE\Adobe\Acrobat Reader\DC'

# ── Policy entries (Subkey relative to $Root) ───────────────────────────────
$Entries = @(
    # ── Security Hardening (Recommended) ─────────────────────────────────────
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnhancedSecurityInBrowser';       Value = 1 }   # Enhanced Security in Browser
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnhancedSecurityStandalone';      Value = 1 }   # Enhanced Security Standalone
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnableFlash';                     Value = 0 }   # Disable Flash Content
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnable3D';                        Value = 0 }   # Disable 3D Content in PDFs
    @{ Subkey = 'FeatureLockDown';                          Name = 'bDisablePDFRedirectionActions';    Value = 1 }   # Block PDF Link Actions
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnableGentech';                   Value = 0 }   # Disable Generative AI
    @{ Subkey = 'FeatureLockDown';                          Name = 'bDisableJavaScript';               Value = 1 }   # Block JavaScript Execution
    @{ Subkey = 'FeatureLockDown\cDefaultLaunchURLPerms';   Name = 'iUnknownURLPerms';                 Value = 1 }   # Unknown URL Access: always ask
    @{ Subkey = 'FeatureLockDown\cDefaultLaunchAttachmentPerms'; Name = 'iUnlistedAttachmentTypePerm'; Value = 0 }   # Unlisted attachments: prompt without ability to allow
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleWebConnectors';             Value = 1 }   # Disable Third-Party Cloud Connectors
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bBoxConnectorEnabled';             Value = 0 }   # Disable Box Connector
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bDropboxConnectorEnabled';         Value = 0 }   # Disable Dropbox Connector
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bGoogleDriveConnectorEnabled';     Value = 0 }   # Disable Google Drive Connector
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bOneDriveConnectorEnabled';        Value = 0 }   # Disable OneDrive Connector
    @{ Subkey = 'FeatureLockDown\cSecurity\cPPKLite';       Name = 'bAllowPasswordSaving';             Value = 0 }   # Disable Password Caching
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleDocumentCloud';             Value = 1 }   # Disable Document Cloud Storage
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleAdobeDocumentServices';     Value = 1 }   # Disable Document Cloud Services
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bTogglePrefsSync';                 Value = 1 }   # Disable Preferences Synchronization
    @{ Subkey = 'FeatureLockDown\cCloud';                   Name = 'bAdobeSendPluginToggle';           Value = 1 }   # Disable Send & Track Outlook Plugin
    @{ Subkey = 'FeatureLockDown\cSharePoint';              Name = 'bDisableSharePointFeatures';       Value = 1 }   # Disable SharePoint & Office 365 Integration
    @{ Subkey = 'FeatureLockDown\cWebmailProfiles';         Name = 'bDisableWebmail';                  Value = 1 }   # Disable WebMail Integration
    @{ Subkey = 'FeatureLockDown';                          Name = 'bProtectedMode';                   Value = 1 }   # Protected Mode Sandbox
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnableProtectedModeAppContainer'; Value = 1 }   # AppContainer Sandbox

    # ── Security Hardening (Optional) ────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleFillSign';                  Value = 1 }   # Disable Adobe Fill & Sign
    @{ Subkey = 'FeatureLockDown';                          Name = 'bDisableOSTrustedSites';           Value = 1 }   # Disable IE Trusted Sites as Privileged Locations
    @{ Subkey = 'FeatureLockDown';                          Name = 'bDisableTrustedFolders';           Value = 1 }   # Lock Trusted Folders and Files
    @{ Subkey = 'FeatureLockDown';                          Name = 'bDisableTrustedSites';             Value = 1 }   # Lock Trusted Host Sites
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleAdobeSign';                 Value = 1 }   # Disable Adobe Acrobat Sign
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleSendAndTrack';              Value = 1 }   # Disable Adobe Send & Track
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleAdobeReview';               Value = 1 }   # Disable Document Cloud Review Service
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleFSSSignatureSaving';        Value = 1 }   # Disable Save Signature to Cloud

    # ── Reduce Nags: Startup & Experience ────────────────────────────────────
    @{ Subkey = 'FeatureLockDown\cIPM';                     Name = 'bShowMsgAtLaunch';                 Value = 0 }   # Suppress Adobe Messages at Launch
    @{ Subkey = 'FeatureLockDown\cIPM';                     Name = 'bAllowUserToChangeMsgPrefs';       Value = 0 }   # Lock Message Preferences
    @{ Subkey = 'FeatureLockDown\cIPM';                     Name = 'bDontShowMsgWhenViewingDoc';       Value = 0 }   # Hide Messages on Document Open
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleNotifications';             Value = 1 }   # Disable Desktop Notifications
    @{ Subkey = 'FeatureLockDown';                          Name = 'bToggleFTE';                       Value = 1 }   # Disable First Time Experience
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bEnableBellButton';                Value = 1 }   # Hide Notifications Bell
    @{ Subkey = 'FeatureLockDown';                          Name = 'bToggleShareFeedback';             Value = 0 }   # Hide Send Feedback Icon
    @{ Subkey = 'FeatureLockDown';                          Name = 'bToggleToDoList';                  Value = 1 }   # Disable Home Screen To Do List
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleNotificationToasts';        Value = 1 }   # Disable Desktop Notification Toasts
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bTogglePDFOwnershipToasts';        Value = 1 }   # Disable PDF Ownership Notifications
    @{ Subkey = 'FeatureLockDown';                          Name = 'bToggleToDoTiles';                 Value = 1 }   # Disable To Do Cards in Recent Tab
    @{ Subkey = 'FeatureLockDown';                          Name = 'bWhatsNewExp';                     Value = 1 }   # Disable What's New Experience
    @{ Subkey = 'FeatureLockDown';                          Name = 'bShowScanTabInHomeView';           Value = 0 }   # Hide Scan Tab in Home View

    # ── Reduce Nags: Context, Tools & Search ─────────────────────────────────
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnableContextualTips';            Value = 0 }   # Disable Contextual Help Tips
    @{ Subkey = 'FeatureLockDown';                          Name = 'bFindMoreWorkflowsOnline';         Value = 0 }   # Hide Online Actions Library Link
    @{ Subkey = 'FeatureLockDown';                          Name = 'bFindMoreCustomizationsOnline';    Value = 0 }   # Hide Online Tool Set Exchange Link
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnableAV2Enterprise';             Value = 1 }   # Modern Viewer (enterprise mode)

    # ── Reduce Nags: Sharing & Features ──────────────────────────────────────
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bToggleManageSign';                Value = 1 }   # Hide Acrobat Sign Tracking Tab

    # ── Reduce Nags: Reader-only ─────────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown';                          Name = 'bReaderRetentionExperiment';       Value = 0 }   # Disable Acrobat Download Prompt
    @{ Subkey = 'FeatureLockDown';                          Name = 'bShowRhpToolSearch';               Value = 0 }   # Hide Purchasable Tools in Search
    @{ Subkey = 'FeatureLockDown';                          Name = 'bEnableAcrobatPromptForDocOpen';   Value = 0 }   # Disable "Use Acrobat" Prompt

    # ── Reduce Nags: Upsell ──────────────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown';                          Name = 'bLimitPromptsFeatureKey';          Value = 1 }   # Limit Informational Prompts
    @{ Subkey = 'FeatureLockDown';                          Name = 'bToggleDCAppCenter';               Value = 1 }   # Disable App Center UI
    @{ Subkey = 'FeatureLockDown';                          Name = 'bAcroSuppressUpsell';              Value = 1 }   # Suppress Upgrade Prompts

    # ── Reduce Nags: Updates ─────────────────────────────────────────────────
    @{ Subkey = 'FeatureLockDown\cServices';                Name = 'bUpdater';                         Value = 0 }   # Disable Services & Web-Plugin Updates
    @{ Subkey = 'FeatureLockDown';                          Name = 'bUpdater';                         Value = 0 }   # Disable Product Updater
    @{ Subkey = 'FeatureLockDown';                          Name = 'PatchCleanFlag';                   Value = 1 }   # Patch Cache Cleanup
    @{ Subkey = 'FeatureLockDown';                          Name = 'bDisablePDFHandlerSwitching';      Value = 1 }   # Lock Default PDF Viewer
)

$InstallerEntries = @(
    @{ Subkey = 'Installer';     Name = 'Disable_Repair';     Value = 1 }   # Disable Repair for Standard Users
    @{ Subkey = 'Installer';     Name = 'DisableMaintenance';  Value = 1 }   # Disable Repair for All Users
    @{ Subkey = 'AdobeViewer';   Name = 'EULA';                Value = 1 }   # Accept EULA for Updater
)

$ExtraEntries = @(
    @{ Path = 'HKLM:\SOFTWARE\Adobe\Adobe ARM\1.0\ARM'; Name = 'iDisablePromptForUpgrade'; Value = 1 }   # Disable Major Version Upgrade Prompt (native x64 ARM)
)

$totalCount = 0

foreach ($e in $Entries) {
    $keyPath = Join-Path $Root $e.Subkey
    if (-not (Test-Path $keyPath)) {
        if ($PSCmdlet.ShouldProcess($keyPath, 'Create registry key')) {
            New-Item -Path $keyPath -Force | Out-Null
        }
    }
    if ($PSCmdlet.ShouldProcess("$keyPath  ->  $($e.Name) = $($e.Value)", 'Set DWORD')) {
        New-ItemProperty -Path $keyPath -Name $e.Name -Value $e.Value -PropertyType DWord -Force | Out-Null
        Write-Host "  [OK]  $keyPath\$($e.Name) = $($e.Value)"
        $totalCount++
    }
}

foreach ($e in $InstallerEntries) {
    $keyPath = Join-Path $InstallerRoot $e.Subkey
    if (-not (Test-Path $keyPath)) {
        if ($PSCmdlet.ShouldProcess($keyPath, 'Create registry key')) {
            New-Item -Path $keyPath -Force | Out-Null
        }
    }
    if ($PSCmdlet.ShouldProcess("$keyPath  ->  $($e.Name) = $($e.Value)", 'Set DWORD')) {
        New-ItemProperty -Path $keyPath -Name $e.Name -Value $e.Value -PropertyType DWord -Force | Out-Null
        Write-Host "  [OK]  $keyPath\$($e.Name) = $($e.Value)"
        $totalCount++
    }
}

foreach ($e in $ExtraEntries) {
    $keyPath = $e.Path
    if (-not (Test-Path $keyPath)) {
        if ($PSCmdlet.ShouldProcess($keyPath, 'Create registry key')) {
            New-Item -Path $keyPath -Force | Out-Null
        }
    }
    if ($PSCmdlet.ShouldProcess("$keyPath  ->  $($e.Name) = $($e.Value)", 'Set DWORD')) {
        New-ItemProperty -Path $keyPath -Name $e.Name -Value $e.Value -PropertyType DWord -Force | Out-Null
        Write-Host "  [OK]  $keyPath\$($e.Name) = $($e.Value)"
        $totalCount++
    }
}

Write-Host ''
Write-Host "Applied $totalCount registry values (Reader x64 / native Policies)."
Write-Host ''
Write-Host '--- How to verify ---'
Write-Host '1. Close Adobe Reader completely, then reopen it.'
Write-Host '2. Edit > Preferences > Security (Enhanced):'
Write-Host '     - Enhanced Security should be enabled for both browser and standalone.'
Write-Host '     - Protected Mode should be enabled.'
Write-Host '3. Unknown URL and attachment policies should match recommended hardening.'
Write-Host '4. Generative AI and cloud connectors should be disabled per policy.'
Write-Host '5. No launch messages, notifications, upsells, or first-time experience.'
Write-Host '6. No contextual tips, feedback icon, or to-do cards.'
Write-Host ''
Write-Host 'Cross-hive notes:'
Write-Host '  - If x86 script was run previously and those settings appeared in 64-bit Reader,'
Write-Host '    but THIS script also works, both hives may be read (unlikely).'
Write-Host '  - If only THIS script produces visible changes, x64 Reader reads native Policies only.'
