<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](../README.md)

# Adobe DC Settings (Device)

Complete list of 154 unique Adobe DC settings (156 table entries where the same `ValueName` has more than one friendly name) in the combined v3.8 ADMX templates, grouped by product applicability.

- Settings marked ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) are under **Adobe DC > Non-Policy Settings** in Group Policy or Intune, not under **Adobe DC > Acrobat & Reader DC**. Configure the sub-node that matches your installed architecture: **Acrobat & Reader DC (64-bit)** (64-bit Acrobat and unified 64-bit Reader), **Acrobat DC (32-bit)** (32-bit Acrobat), or **Reader DC (32-bit)** (32-bit Reader).

## Common to Acrobat & Reader

### Cloud & Connectors

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Adobe Fill & Sign | ``bToggleFillSign`` | Disables Adobe Fill and Sign. |
| Box Cloud Connector | ``bBoxConnectorEnabled`` | Enable connection to the Box cloud when bToggleWebConnectors is set to 1. |
| Document Cloud Services | ``bToggleAdobeDocumentServices`` | Enable Document Cloud services (except those controlled by other prefs). |
| Document Cloud Storage | ``bToggleDocumentCloud`` | Enable Document Cloud storage. |
| Dropbox Cloud Connector | ``bDropboxConnectorEnabled`` | Enable connection to the Dropbox cloud when bToggleWebConnectors is set to 1. |
| Generative AI Technology | ``bEnableGentech`` | Enable generative AI features in Acrobat and Reader. |
| Google Drive Connector | ``bGoogleDriveConnectorEnabled`` | Enable connection to the Google Drive cloud when bToggleWebConnectors is set to 1. |
| Hide Fill & Sign Send a Copy Button | ``bToggleSendACopy`` | Hide the Send a Copy button from the Fill & Sign tool in Acrobat and Reader. |
| Hide Sign Out Menu Item | ``bSuppressSignOut`` | Specifies whether the sign-in and sign-out Help menu item should be enabled. |
| OneDrive Connector | ``bOneDriveConnectorEnabled`` | Enable connection to the OneDrive cloud when bToggleWebConnectors is set to 1. |
| Preferences Synchronization | ``bTogglePrefsSync`` | Sync desktop preferences across signed-in devices. |
| Services & Web-Plugin Updates | ``bUpdater`` | Web-plugin updates and cloud services. |
| Third-Party Cloud Connectors | ``bToggleWebConnectors`` | Third-party cloud storage connectors (Continuous track). |

### Context, Tools & Search

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Auto UI Density Detection | ``bUIDensityAutoDetectionEnabled`` | Disable the auto detection logic and bezel for changing Acrobat's display size. |
| Contextual Help Tips | ``bEnableContextualTips`` | Controls whether to automatically display help tips based on the current context. |
| Contextual Toolbar | ``bEnableContextualToolbar`` | Show the context toolbar (popup) when selecting a PDF object. |
| Extract Page Range UI | ``bEnableExtractPageRange`` | Show the page range UI in the Extract Page dialog. |
| Legacy Protect Tool Menu ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``ProtectOldExperience`` | Use legacy Protect tool menus instead of the new UI. |
| Lock Tool Shortcut Customization | ``bDisableAcrobatShortcutCustomization`` | Prevents end users from modifying the tool shortcuts in the right hand pane. |
| Modern Viewer | ``bEnableAV2Enterprise`` | Enable the Modern Viewer. |
| New Right-Click Context Menu | ``bEnableRCMNewPOPUp`` | Disable the new context menu and use the legacy version. |
| Online Actions Library Link | ``bFindMoreWorkflowsOnline`` | Show the menu item that opens the online Actions file library. |
| Online Tool Set Exchange Link | ``bFindMoreCustomizationsOnline`` | Show the menu item that opens the online Acrobat Tool Set Exchange. |
| Paste in Place ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``ADC4302862`` | Paste copied elements to the same location as the source. |
| Show Combine Files Context Menu | ``bRCMCombineFeatureKey`` | Display the Combine Files item in a document's right-click context menu. |

### Documents, Editing & Accessibility

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Create PDF Split Menu | ``bGlobalBarMenuFeatureKey`` | Show the Create Split Menu under Create a PDF menu item. |
| Disable Scanned PDF Text Recognition ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``DisableScannedDocumentEditing`` | Disable text recognition while editing scanned PDFs. |
| Restrict Form Data to Schema | ``bIgnoreDataSchema`` | Specifies whether all data in a form is saved rather than only data related to the form's schema. |

### Microsoft Purview (MIP)

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Check MIP Policy on Save | ``bMIPCheckPolicyOnDocSave`` | Lock MIP labeling checks on save (admin). |
| Enable MIP Labelling | ``bMIPLabelling`` | Lock Enable MIP labeling in Preferences > Security. |
| MIP Double Key Encryption | ``bEnableDKEAdmin`` | Locks double key encryption (DKE) label support for Microsoft Purview Information Protection. |
| MIP External Browser Auth | ``bMIPExternalAuthAdmin`` | Locks browser-based authentication for Microsoft Purview Information Protection operations. |
| MIP Sovereign Cloud | ``iMIPCloud`` | Locks which Microsoft cloud instance Acrobat and Reader use for MIP SDK operations. |
| Suppress OS Auth Prompts (MIP) | ``bSilentAuth`` | Locks whether operating-system authentication prompts are suppressed during MIP operations. |

### Security: Execution & Protection

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| 3D Content in PDFs | ``bEnable3D`` | Trust and render 3D content in PDFs. |
| AppContainer Sandbox | ``bEnableProtectedModeAppContainer`` | Enable the AppContainer sandbox. |
| Attachment Extension Blocklist in Dialogs | ``bEnableBlacklistForOpenSave`` | Hide tBuiltInPermList level-3 extensions from Open/Save dialogs. |
| Block JavaScript Execution | ``bDisableJavaScript`` | Blocks and locks JavaScript execution in PDF documents, preventing users from bypassing via privileged locations. |
| Block non-PDF file attachments | ``iFileAttachmentPerms`` | Block opening non-PDF/FDF file attachments. |
| Block PDF Link Actions | ``bDisablePDFRedirectionActions`` | Block specific PDF actions (listed below) which result in opening a link. |
| Certification Status in Protected View | ``bEnablePVCertificateBasedTrust`` | Specifies whether a document's certification status should appear in the Protected View document message bar. |
| Enhanced Security in Browser | ``bEnhancedSecurityInBrowser`` | Enhanced security when running in the browser. |
| Enhanced Security Standalone | ``bEnhancedSecurityStandalone`` | Enhanced security in the standalone application. |
| Flash Content in PDFs | ``bEnableFlash`` | Render Flash content in PDFs. |
| Flash Editing Tools ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``EnableFlashEditing`` | Enable the Flash tools for adding annotations or Flash in the Rich Media app. |
| Protected Mode Sandbox | ``bProtectedMode`` | Enables Protected Mode which sandboxes Acrobat and Reader processes. |
| Protected View Exit Shortcut Key ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``bEnablePVSwitchoutShortcut`` | Shortcut key to exit Protected View for the current document. |
| Protected View Mode | ``iProtectedView`` | Protected View mode. |
| Unlisted Attachment Type Permissions | ``iUnlistedAttachmentTypePerm`` | Specifies the default permissions for file types that aren't listed in the default or user-specified lists. |

### Security: Trust & Permissions

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Allow Changes to Windows Certificate Store Trust | ``bMSStoreTrusted`` | Locks the UI so that end users cannot change the value set by iMSStoreTrusted. |
| Allow Invisible Signatures | ``bAllowInvisibleSig`` | Allow invisible certification signatures. |
| Allow Password Caching | ``bAllowPasswordSaving`` | Controls whether certain passwords can be cached to disk; for example, passwords for digital IDs. |
| Allow Signature Clearing | ``bEnableSignatureClear`` | Disable and lock the ability for a signer to clear their own signature. |
| Always Use Specified Verify Handler | ``bVerifyUseAlways`` | Qualifies the use of aVerify. |
| Block User Library Trust in Protected View | ``bDisableExpandEnvironmentVariables`` | Allow user-specific paths as trusted locations in Protected View. |
| Cache Digital ID Session Handles | ``bWinCacheSessionHandles`` | Retain cryptographic service provider (CSP) handles when a user authenticates to a digital ID. |
| Disable IE Trusted Sites as Privileged Locations | ``bDisableOSTrustedSites`` | Locks the ability to treat IE trusted sites as privileged locations either on or off so the users can't change the bTrustOSTrustedSites value via the user... |
| LiveCycle RMS Server Config | ``bAllowAPSConfig`` | Prevents a LiveCycle Rights Management Server from being configured by disabling the menu option in the Security Settings Console. |
| Lock Revocation Check Setting | ``bReqRevCheck`` | Locks Security\cASPKI\cASPKI\cVerify\iReqRevCheck and disables the user interface item. |
| Lock Signing Reasons Settings | ``bReasons`` | Prevents users from modifying reason settings. |
| Lock Trusted Folders and Files | ``bDisableTrustedFolders`` | Disable and lock trusted folders and files. |
| Lock Trusted Host Sites | ``bDisableTrustedSites`` | Disable and lock host-based privileged locations. |
| Modern Digital Signature UI | ``bEnableCEFBasedUI`` | Modern CEF-based digital signature UI. |
| Show Timestamp in Signature | ``bUseTSAsSigningTime`` | Show timestamp server time in signature appearance. |
| Signing Reason UI | ``bAllowReasonWhenSigning`` | Specifies whether the reason UI will appear during signing. |
| Trust Certified Documents | ``bEnableCertificateBasedTrust`` | Trust certified documents as privileged locations (admin lock). |
| Unknown URL Access Policy | ``iUnknownURLPerms`` | Access policy for URLs not in the user list. |
| Validate Signatures on Open | ``bValidateOnOpen`` | Automatically validate all signatures on document open. |

### Sharing & Features

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Adobe Acrobat Sign | ``bToggleAdobeSign`` | Adobe Acrobat Sign (Send for Signature). |
| Adobe Send & Track | ``bToggleSendAndTrack`` | Disables Adobe Send and Track (some UI is renamed to "Share" since October, 2018) |
| Disable SharePoint & Office 365 Integration | ``bDisableSharePointFeatures`` | Disable SharePoint and Office 365 integration. |
| Disable WebMail Integration | ``bDisableWebmail`` | Disable WebMail integration. |
| Document Cloud Review Service | ``bToggleAdobeReview`` | Document Cloud Review service UI. |
| Email Icon Attach to Email Behavior | ``bSendMailShareRedirection`` | Email icon attaches document instead of opening the share pane. |
| Hide Shared Files from Recent List | ``bMixRecentFilesFeatureLockDown`` | Show shared files in the Recent list. |
| Save Signature to Cloud | ``bToggleFSSSignatureSaving`` | Save a newly created signature in the cloud. |
| Send & Track Outlook Plugin | ``bAdobeSendPluginToggle`` | Adobe Send and Track button in Outlook. |
| SharePoint in Chrome Extension | ``bEnableSharePointInChromeExtn`` | Integrate SharePoint into the Acrobat's Chrome extension. |
| Show Acrobat Sign Tracking Tab | ``bToggleManageSign`` | Signature tab on Home, notifications, and sign tracking. |
| Show Comment Author in Shared Review | ``bDisableOnBehalfOfText`` | If false, the string "On behalf of" does not append the author's name in the comment when another person opens the document in a shared-review workflow. |
| WebMail Client Type (Gmail) | ``iClientType`` | Identifies the Gmail Mail client type for WebMail. |
| WebMail Client Type (Yahoo) | ``iClientType`` | Identifies the Yahoo Mail client type for WebMail. |
| WebMail IMAP Port | ``iIMAPPort`` | Identifies the My Profile Mail IMAP server port number for WebMail. |
| WebMail IMAP Security | ``iIMAPSecurity`` | Enable the My Profile Mail IMAP security for WebMail. |
| WebMail SMTP Port | ``iSMTPPort`` | Identifies the My Profile Mail SMTP server port number for WebMail. |
| WebMail SMTP Security | ``iSMTPSecurity`` | Enable the My Profile Mail SMTP security for WebMail. |

### Startup & Experience

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Adobe Messages at Launch | ``bShowMsgAtLaunch`` | Show Adobe messages at product launch. |
| Allow Users to Change Message Preferences | ``bAllowUserToChangeMsgPrefs`` | Locks the features associated with bShowMsgAtLaunch and bDontShowMsgWhenViewingDoc so that end users can't change the settings. |
| Desktop Notifications | ``bToggleNotifications`` | Disable all in-product and desktop notifications. |
| Disable Welcome Screen | ``bShowWelcomeScreen`` | Show the Welcome screen at product launch. |
| First Time Experience | ``bToggleFTE`` | First Time Experience (welcome tour and page). |
| Hide Adobe Messages on Document Open | ``bDontShowMsgWhenViewingDoc`` | Show messages from Adobe when a document opens. |
| Hide In-Product Notifications Bell | ``bEnableBellButton`` | Hide in-product messages. |
| Hide Send Feedback Icon | ``bToggleShareFeedback`` | Show the Send Feedback icon. |
| Home Screen To Do List | ``bToggleToDoList`` | Show a "to do" list on the Home screen. |
| Scan Tab in Home View | ``bShowScanTabInHomeView`` | Disable the Scan tab in Home view. |
| Show Desktop Notification Toasts | ``bToggleNotificationToasts`` | Hide desktop notifications. |
| Show PDF Ownership Notification | ``bTogglePDFOwnershipToasts`` | Show a notification on machine startup that allows the user to make Acrobat the default PDF viewer. |
| Show To Do Cards in Recent Tab | ``bToggleToDoTiles`` | Show To Do Cards in the Recent Tab view |
| Usage Measurement (legacy) | ``bUsageMeasurement`` | Legacy master switch for usage measurement and analytics. |
| What's New Experience | ``bWhatsNewExp`` | Disable the What's New experience. |

### Updates & Desktop Integration

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| 32-Bit Plugin Upgrade Notification | ``bDisableThirdPartyPluginNotif`` | Notify users with 32 bit plugins that the app will soon update to 64 bit. |
| Accept EULA for Updater ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``EULA`` | Accept EULA for the built-in updater. |
| Auto Dock HUD Bar | ``bEnableAutoDockUndockHUD`` | Automatically dock and undock the HUD bar based on the window size. |
| Auto Open Acrobat from Reader | ``bHasAcrobatConsent`` | Specifies whether the Reader process should automatically open Acrobat for the current file. |
| Disable Chrome PDF Extension | ``bAcroSuppressOpenInReader`` | Disable and lock the PDF viewer Chrome extension. |
| Disable Repair for All Users ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``DisableMaintenance`` | Disable Help > Repair for all users. |
| Disable Repair for Standard Users ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``Disable_Repair`` | Disable Help > Repair for standard users on virtual installs. |
| Hide Document Message Bar | ``bSuppressMessageBar`` | Prevents the appearance of the document message bar. |
| Lock Default PDF Viewer | ``bDisablePDFHandlerSwitching`` | Lock the default PDF viewer handler. |
| Lock PDF Thumbnails in Explorer | ``bDisableThumbnailPreviewHandler`` | Lock Explorer PDF thumbnail preview checkbox. |
| Merge Title and Menu Bar ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``bMergeMenuBar`` | Merge the application's title bar and menu bar into a single bar. |
| Patch Cache Cleanup | ``PatchCleanFlag`` | Clean cached MSI/MSP patches on next update. |
| Product Updater | ``bUpdater`` | Controls Adobe Acrobat/Reader product updates. |
| Scalable Cursor | ``bShouldUseScalableCursor`` | Disable the scalable cursor. |
| Starred Files Feature | ``bFavoritesFeaturesLockDown`` | Disable and lock the starred file feature. |

### Upsell

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Disable Promotional Campaign Messages | ``bToggleSophiaWebInfra`` | Show users messages which promote (Trials, Acrobat, PDF Pack etc.) |
| Limit Informational Prompts | ``bLimitPromptsFeatureKey`` | Limit the number of prompts a user will see in a 24 hour period. |
| Show App Center UI | ``bToggleDCAppCenter`` | App Center and get-apps banner on Home. |
| Show Upgrade Prompts | ``bAcroSuppressUpsell`` | Disable upgrade and upsell messages (12.x+). |

## Acrobat Only

### Context, Tools & Search

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Click-to-Edit Mode ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``ADC4275035_ClickEdit`` | Auto-enter edit mode when the user clicks a PDF object. |
| Cloud Search Token Caching | ``bEnableCloudPoweredSearchTokenCaching`` | Cache locally cloud-based search service suggestions. |
| Cloud-Powered Search | ``bEnableCloudPoweredSearch`` | Enable the cloud-based search service in the Find Tool. |
| Fill & Sign Color Picker ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``ADC4275034`` | Disable the color picker in the Fill and Sign tool. |
| Organize Pages Thumbnail Shortcut | ``bOrganizePagesFromThumbnails`` | Show shortcut UI for the Organize tool from thumbnails. |
| Remove Form Editing Tools (2019) ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``ADC4275035`` | Remove Oct 2019 AddText and EditText form tools from the UI. |
| Show Search Loading Message | ``bEnableAutoCompleteExactMatchLoader`` | Show a "Working on it" message when using the cloud-based search service. |
| Show Search No Internet Message | ``bEnableAutoCompleteNoInternetConnectionHeader`` | Show a "Requires internet connection" message when using the cloud-based search service. |
| Show Search No Match Message | ``bEnableAutoCompleteNoExactMatchHeader`` | Show a "No exact match" message when using the cloud-based search service. |

### Documents, Editing & Accessibility

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Accessibility Auto Tagging | ``bCloudATFeatureEnable`` | Show the new auto tagging experience or revert to the old experience. |
| Bates Log Original File Name | ``bBatesLogOriginalFileName`` | Use original filename in Bates numbering log output. |
| Block EMF to PDF Conversion ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``BlockEMFParsing`` | Block EMF to PDF conversion. |
| Block XPS to PDF Conversion ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``BlockXPSParsing`` | Block XPS to PDF conversion. |
| PDFMaker Grouped Image Tag Fix ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``EnablePDFMakerGroupImagesTagCorrectionFeature`` | Disable accessibility fixes for tagging grouped images. |
| PDFMaker Table Header Tag Fix ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``EnablePDFMakerTableHeaderCellTagAndScopeUpdateFeature`` | Disable accessibility fixes for tagging table headers. |
| PDFMaker Text Path Tag Fix ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``EnablePDFMakerSplitTextPathElemsFeature`` | Fix Text Path rendering bug in PDFMaker tags. |
| Reflow Editing | ``bEnableReflowEditing`` | Lock ReflowEditing and the reflow feature. |

### Security: Trust & Permissions

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Disable Acrobat.com File Storage | ``bDisableADCFileStore`` | Disables Acrobat.com file storage integration. |
| Sign Menu in Menu Bar | ``bShowSignMenu`` | Show the Sign menu in Acrobat's top level menu bar. |

### Sharing & Features

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Allow @Mention Non-Reviewers | ``bEnableRecipientMention`` | Allow participants in a shared review to @mention people who are not review collaborators. |
| Share and Review Reminder Tip | ``bEnableReviewPromote`` | Display a Share/Review feature reminder message when users have used those features in the past. |

### Startup & Experience

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Reader mode on Acrobat (Unified x64) | ``bIsSCReducedModeEnforcedEx`` | Enforce Reader-like reduced mode on Unified Acrobat (64-bit MUI). |

### Updates & Desktop Integration

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Crash Reporter Dialog | ``bCrashReporterEnabled`` | Show the crash reporter dialog on application crash (Windows only). |
| Disable Major Version Upgrade Prompt (32-bit Updater) ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``iDisablePromptForUpgrade`` | Suppress major-version upgrade prompt. |
| Enforce AMT for AppV Deployment ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``IsAMTEnforced`` | Allows deployment of Acrobat on AppV for December, 2018 and later products. |
| Split by Size Maximum (MB) | ``dSplitBySizeMaxSize`` | Maximum MB per split file. |
| Update Watchdog Interval (Days) (32-bit Updater) ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``iInterval`` | Days before Watchdog prompts manual update after a failed update. |
| Updater Log Level (32-bit Updater) ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | ``iLogLevel`` | Updater log verbosity. |

### Upsell

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Disable Billing Issue Call to Action | ``bToggleBillingIssue`` | Show a Call to Action UI item in the top bar if a billing issue is detected. |
| Express Templates in Create PDF | ``bMerchandizingEnabled`` | Show the Express Templates options in Acrobat's Create PDF UI. |
| Trial Purchase Prompt | ``bEnableTrialistLaunchCard`` | Prompt Acrobat trial users to complete the purchase. |

## Reader Only

### Documents, Editing & Accessibility

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Online Create PDF in Reader | ``bEnableFrictionlessInChromeExtn`` | Show Reader users the online Create PDF service option. |

### Security: Execution & Protection

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Protected Mode Whitelist Config | ``bUseWhitelistConfigFile`` | Allows the use of the policy whitelist to allow behavior that Protected Mode would otherwise prevent. |

### Updates & Desktop Integration

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Prompt to Use Acrobat from Reader | ``bEnableAcrobatPromptForDocOpen`` | Prompt users to use Acrobat when both Reader and Acrobat are installed. |

### Upsell

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Prompt Reader Users to Download Acrobat | ``bReaderRetentionExperiment`` | Prompt Acrobat subscribers using Reader to download Acrobat. |
| Show Purchasable Tools in Search | ``bShowRhpToolSearch`` | Show "for purchase" tools when searching for tools in Reader. |

**Sharing & responsibility** - Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.