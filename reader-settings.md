[<- Back to Documentation](README.md)

<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

# Reader DC Settings

Complete list of 116 Reader DC policies in the v2.10 ADMX templates, sorted by category.

## Cloud & Connectors

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Adobe Fill & Sign | ``bToggleFillSign`` | Disables Adobe Fill and Sign. |
| Box Cloud Connector | ``bBoxConnectorEnabled`` | Enable connection to the Box cloud when bToggleWebConnectors is set to 1. |
| Document Cloud Services | ``bToggleAdobeDocumentServices`` | Disables Document Cloud service access except those features controlled by the other preferences. |
| Document Cloud Storage | ``bToggleDocumentCloud`` | Enable Document Cloud storage. |
| Dropbox Cloud Connector | ``bDropboxConnectorEnabled`` | Enable connection to the Dropbox cloud when bToggleWebConnectors is set to 1. |
| Generative AI Technology | ``bEnableGentech`` | Enable generative AI features in Acrobat and Reader. |
| Google Drive Connector | ``bGoogleDriveConnectorEnabled`` | Enable connection to the Google Drive cloud when bToggleWebConnectors is set to 1. |
| Hide Fill & Sign Send a Copy Button | ``bToggleSendACopy`` | Hide the Send a Copy button from the Fill & Sign tool in Acrobat and Reader. |
| Hide Sign Out Menu Item | ``bSuppressSignOut`` | Specifies whether the sign-in and sign-out Help menu item should be enabled. |
| OneDrive Connector | ``bOneDriveConnectorEnabled`` | Enable connection to the OneDrive cloud when bToggleWebConnectors is set to 1. |
| Preferences Synchronization | ``bTogglePrefsSync`` | Disables preferences synchronization. |
| Services & Web-Plugin Updates | ``bUpdater`` | Disables both updates to the product's web-plugin components as well as all services. |
| Third-Party Cloud Connectors | ``bToggleWebConnectors`` | Enable cloud storage connectors. |

## Context, Tools & Search

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Auto UI Density Detection | ``bUIDensityAutoDetectionEnabled`` | Disable the auto detection logic and bezel for changing Acrobat's display size. |
| Contextual Help Tips | ``bEnableContextualTips`` | Controls whether to automatically display help tips based on the current context. |
| Contextual Toolbar | ``bEnableContextualToolbar`` | Show the context toolbar (popup) when selecting a PDF object. |
| Extract Page Range UI | ``bEnableExtractPageRange`` | Show the page range UI in the Extract Page dialog. |
| Legacy Protect Tool Menu | ``ProtectOldExperience`` | Use the disable the new Protect tool and revert to the old menu |
| Lock Tool Shortcut Customization | ``bDisableAcrobatShortcutCustomization`` | Prevents end users from modifying the tool shortcuts in the right hand pane. |
| Modern Viewer | ``bEnableAV2Enterprise`` | Enable the Modern Viewer. |
| New Right-Click Context Menu | ``bEnableRCMNewPOPUp`` | Disable the new context menu and use the legacy version. |
| Online Actions Library Link | ``bFindMoreWorkflowsOnline`` | Show the menu item that opens the online Actions file library. |
| Online Tool Set Exchange Link | ``bFindMoreCustomizationsOnline`` | Show the menu item that opens the online Acrobat Tool Set Exchange. |
| Paste in Place | ``ADC4302862`` | Past copied elements to the exact location as the copied element. |
| Show Combine Files Context Menu | ``bRCMCombineFeatureKey`` | Display the Combine Files item in a document's right-click context menu. |

## Documents, Editing & Accessibility

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Create PDF Split Menu | ``bGlobalBarMenuFeatureKey`` | Show the Create Split Menu under Create a PDF menu item. |
| Online Create PDF in Reader | ``bEnableFrictionlessInChromeExtn`` | Show Reader users the online Create PDF service option. |
| Restrict Form Data to Schema | ``bIgnoreDataSchema`` | Specifies whether all data in a form is saved rather than only data related to the form's schema. |

## Security: Execution & Protection

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| 3D Content in PDFs | ``bEnable3D`` | Trust and render 3D content in PDFs. |
| AppContainer Sandbox | ``bEnableProtectedModeAppContainer`` | Enable the AppContainer sandbox. |
| Attachment Extension Blocklist in Dialogs | ``bEnableBlacklistForOpenSave`` | Reverts the tBuiltInPermList behavior to that of the pre 21.011.20029 build. |
| Block PDF Link Actions | ``bDisablePDFRedirectionActions`` | Block specific PDF actions (listed below) which result in opening a link. |
| Built-in Attachment Permissions List | ``tBuiltInPermList`` | Defines the white and black list of file types that can be saved and opened from a document. |
| Certification Status in Protected View | ``bEnablePVCertificateBasedTrust`` | Specifies whether a document's certification status should appear in the Protected View document message bar. |
| Enhanced Security in Browser | ``bEnhancedSecurityInBrowser`` | Toggles enhanced security when the application is running in the browser. |
| Enhanced Security Standalone | ``bEnhancedSecurityStandalone`` | Toggles enhanced security for the standalone application. |
| Flash Content in PDFs | ``bEnableFlash`` | Specifies whether Flash content should be rendered in a PDF. |
| Protected Mode Sandbox | ``bProtectedMode`` | Enables Protected Mode which sandboxes Acrobat and Reader processes. |
| Protected Mode Whitelist Config | ``bUseWhitelistConfigFile`` | Allows the use of the policy whitelist to allow behavior that Protected Mode would otherwise prevent. |
| Protected View Exit Shortcut Key | ``bEnablePVSwitchoutShortcut`` | Enables a shortcut key that allows users to exit Protected View for a specific document. |
| Unlisted Attachment Type Permissions | ``iUnlistedAttachmentTypePerm`` | Specifies the default permissions for file types that aren't listed in the default or user-specified lists. |

## Security: Trust & Permissions

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Allow Changes to Windows Certificate Store Trust | ``bMSStoreTrusted`` | Locks the UI so that end users cannot change the value set by iMSStoreTrusted |
| Allow Invisible Signatures | ``bAllowInvisibleSig`` | Allow invisible certification signatures. |
| Allow Password Caching | ``bAllowPasswordSaving`` | Controls whether certain passwords can be cached to disk; for example, passwords for digital IDs. |
| Allow Signature Clearing | ``bEnableSignatureClear`` | Disable and lock the ability for a signer to clear their own signature. |
| Always Use Specified Verify Handler | ``bVerifyUseAlways`` | Qualifies the use of aVerify. |
| Block User Library Trust in Protected View | ``bDisableExpandEnvironmentVariables`` | Provides a method for admins to whitelist user libraries as trusted locations when Protected View is enabled. |
| Cache Digital ID Session Handles | ``bWinCacheSessionHandles`` | Retain cryptographic service provider (CSP) handles when a user authenticates to a digital ID. |
| Disable IE Trusted Sites as Privileged Locations | ``bDisableOSTrustedSites`` | Locks the ability to treat IE trusted sites as privileged locations either on or off so the users can't change the bTrustOSTrustedSites value via the user... |
| LiveCycle RMS Server Config | ``bAllowAPSConfig`` | Prevents a LiveCycle Right Management Server from being configured by disabling the menu option in the Security Settings Console. |
| Lock Revocation Check Setting | ``bReqRevCheck`` | Locks Security\cASPKI\cASPKI\cVerify\iReqRevCheck and disables the user interface item. |
| Lock Signing Reasons Settings | ``bReasons`` | Prevents users from modifying reason's settings. |
| Lock Trusted Folders and Files | ``bDisableTrustedFolders`` | Disables trusted folders AND files and prevents users from specifying a privileged location for directories. |
| Lock Trusted Host Sites | ``bDisableTrustedSites`` | Disables and locks the ability to specify host-based privileged locations. |
| Modern Digital Signature UI | ``bEnableCEFBasedUI`` | Enable the CEF-based, modern UI for digital signature workflows. |
| Show Timestamp in Signature | ``bUseTSAsSigningTime`` | Specifies whether the timestamp time should be displayed in the signature appearance. |
| Signing Reason UI | ``bAllowReasonWhenSigning`` | Specifies whether the reason UI will appear during signing. |
| Trust Certified Documents | ``bEnableCertificateBasedTrust`` | Elevates (trusts) certified documents as a privileged location. |
| Unknown URL Access Policy | ``iUnknownURLPerms`` | Ask for, allow, or block access to web sites that are not in the user specified list. |
| Validate Signatures on Open | ``bValidateOnOpen`` | Automatically validate all signatures on document open. |

## Sharing & Features

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Adobe Acrobat Sign | ``bToggleAdobeSign`` | Disables Adobe Send for Signature (Acrobat Sign). |
| Adobe Send & Track | ``bToggleSendAndTrack`` | Disables Adobe Send and Track (some UI is renamed to "Share" since October, 2018) |
| Document Cloud Review Service | ``bToggleAdobeReview`` | Remove all UI related to the Document Cloud Review service. |
| Email Icon Attach to Email Behavior | ``bSendMailShareRedirection`` | Change the email icon behavior so that it attaches the document to an email. |
| Hide Shared Files from Recent List | ``bMixRecentFilesFeatureLockDown`` | Show shared files in the Recent file list. |
| Save Signature to Cloud | ``bToggleFSSSignatureSaving`` | Save a newly created signature in the cloud. |
| Send & Track Outlook Plugin | ``bAdobeSendPluginToggle`` | Toggles the Adobe Send and Track plugin for Outlook |
| SharePoint & Office 365 Integration | ``bDisableSharePointFeatures`` | Disables the SharePoint and Office 365 integration features. |
| SharePoint Chrome Extension Previous State | ``bPreviouslyEnabledSharePointInChromeExtn`` | Stores the previous state of the Sharepoint FeatureLockDown settings. |
| SharePoint in Chrome Extension | ``bEnableSharePointInChromeExtn`` | Integrate Sharepoint into the Acrobat's Chrome extension. |
| Show Acrobat Sign Tracking Tab | ``bToggleManageSign`` | Remove the Signature tab from the Home page's left-hand pane, notifications, and sign tracking cards. |
| Show Comment Author in Shared Review | ``bDisableOnBehalfOfText`` | If false, the string "On behalf of" does not append the author's name in the comment when another person opens the document in a shared-review workflow. |
| WebMail Client Type (Gmail) | ``iClientType`` | Identifies the Gmail Mail client type for WebMail. |
| WebMail Client Type (Yahoo) | ``iClientType`` | Identifies the Yahoo Mail client type for WebMail. |
| WebMail IMAP Drafts Folder | ``tIMAPDraftsFolder`` | Identifies the My Profile Mail draft folder for WebMail. |
| WebMail IMAP Port | ``iIMAPPort`` | Identifies the My Profile Mail IMAP server port number for WebMail. |
| WebMail IMAP Security | ``iIMAPSecurity`` | Enable the My Profile Mail IMAP security for WebMail. |
| WebMail Integration | ``bDisableWebmail`` | Disable WebMail. |
| WebMail SMTP Port | ``iSMTPPort`` | Identifies the My Profile Mail SMTP server port number for WebMail. |
| WebMail SMTP Security | ``iSMTPSecurity`` | Enable the My Profile Mail SMTP security for WebMail. |

## Startup & Experience

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Adobe Messages at Launch | ``bShowMsgAtLaunch`` | Show messages from Adobe when the product launches. |
| Allow Users to Change Message Preferences | ``bAllowUserToChangeMsgPrefs`` | Locks the features associated with bShowMsgAtLaunch and bDontShowMsgWhenViewingDoc so that ends users can't change the settings. |
| Desktop Notifications | ``bToggleNotifications`` | Disable all in-product and desktop notifications. |
| First Time Experience | ``bToggleFTE`` | Enable the First Time Experience (FTE) feature (Welcome tour/page). |
| Hide Adobe Messages on Document Open | ``bDontShowMsgWhenViewingDoc`` | Show messages from Adobe when a document opens. |
| Hide In-Product Notifications Bell | ``bEnableBellButton`` | Hide in-product messages. |
| Hide Send Feedback Icon | ``bToggleShareFeedback`` | Show the Send Feedback icon. |
| Home Screen To Do List | ``bToggleToDoList`` | Show a "to do" list on the Home screen. |
| Scan Tab in Home View | ``bShowScanTabInHomeView`` | Disable the Scan tab in Home view. |
| Show Desktop Notification Toasts | ``bToggleNotificationToasts`` | Hide desktop notifications. |
| Show PDF Ownership Notification | ``bTogglePDFOwnershipToasts`` | Show a notification on machine startup that allows the user to make Acrobat the default PDF viewer. |
| Show To Do Cards in Recent Tab | ``bToggleToDoTiles`` | Show To Do Cards in the Recent Tab view |
| What's New Experience | ``bWhatsNewExp`` | Disable the What's New experience. |

## Updates & Desktop Integration

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| 32-Bit Plugin Upgrade Notification | ``bDisableThirdPartyPluginNotif`` | Notify users with 32 bit plugins that the app will soon update to 64 bit. |
| Auto Dock HUD Bar | ``bEnableAutoDockUndockHUD`` | Automatically doc and undock the HUD bar based on the window size. |
| Auto Open Acrobat from Reader | ``bHasAcrobatConsent`` | Specifies whether the Reader process should automatically open Acrobat for the current file. |
| Disable Chrome PDF Extension | ``bAcroSuppressOpenInReader`` | Disable and lock the PDF viewer Chrome extension. |
| Disable Major Version Upgrade Prompt | ``iDisablePromptForUpgrade`` | Specifies whether the application should show a prompt suggesting the user upgrade to the next major version (for example, 10.0 to 11.0). |
| Disable Repair for All Users | ``DisableMaintenance`` | Disable the Help > Repair Installation menu for all users on virtual and and regular installs. |
| Disable Repair for Standard Users | ``Disable_Repair`` | Disable the Help > Repair Installation menu for standard users on virtualized installations. |
| Hide Document Message Bar | ``bSuppressMessageBar`` | Prevents the appearance of the document message bar. |
| Lock Default PDF Viewer | ``bDisablePDFHandlerSwitching`` | Disables the ability to change the specified default handler (PDF viewer). |
| Lock PDF Thumbnails in Explorer | ``bDisableThumbnailPreviewHandler`` | Disable and lock the user interface option that controls Acrobat-generated PDF thumbnail previews in Windows Explorer. |
| Merge Title and Menu Bar | ``bMergeMenuBar`` | Merge the application's title bar and menu bar into a single bar. |
| Patch Cache Cleanup | ``PatchCleanFlag`` | Triggers cleanup of old cached update patch files (MSI/MSP) on the next update cycle. |
| Product Updater | ``bUpdater`` | Disables the Updater and removes associated user interface items. |
| Prompt to Use Acrobat from Reader | ``bEnableAcrobatPromptForDocOpen`` | Prompt users to use Acrobat when both Reader and Acrobat are installed. |
| Scalable Cursor | ``bShouldUseScalableCursor`` | Disable the scalable cursor. |
| Starred Files Feature | ``bFavoritesFeaturesLockDown`` | Disable and lock the starred file feature. |
| Update Watchdog Interval (Days) | ``iInterval`` | Sets the time that can elapse without a successful update before the Watchdog dialog appears suggesting the user manually update. |
| Updater Log Level | ``iLogLevel`` | Sets the log level to either brief (0) or verbose (1). |

## Upsell

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Limit Informational Prompts | ``bLimitPromptsFeatureKey`` | Limit the number of prompts a user will see in a 24 hour period. |
| Prompt Reader Users to Download Acrobat | ``bReaderRetentionExperiment`` | Prompt Acrobat subscribers using Reader to download Acrobat. |
| Show App Center UI | ``bToggleDCAppCenter`` | Show the UI that helps users find and download additional apps. |
| Show Purchasable Tools in Search | ``bShowRhpToolSearch`` | Show "for purchase" tools when searching for tools in Reader. |
| Show Upgrade Prompts | ``bAcroSuppressUpsell`` | For 12.x and later products, disables messages which encourage the user to upgrade the product. |