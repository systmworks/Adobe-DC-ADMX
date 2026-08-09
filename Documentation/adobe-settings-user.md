<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](../README.md)

# Adobe DC Settings (User)

Complete list of 267 unique Adobe DC settings (268 table entries where the same `ValueName` has more than one friendly name) in the combined v4.0 ADMX templates, grouped by product applicability.

## Common to Acrobat & Reader

### Context, Tools & Search

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Base Folder Name | ``tBaseFolderName`` | An alias referring to a particular folder. |
| Column Select Halo | ``iColumnSelectHalo`` | Adobe's preference reference does not describe this value; use the URL column for the documentation link. |
| File Format Version | ``tFileFormat`` | The version number associated with the file format. |
| Filename as Title | ``bAlwaysUseFileNameAsDocTitle`` | Use the PDF file name as the display name in the application's title bar. |
| Fixed Snapshot Resolution | ``bUseFixedSnapshotResolution`` | Adobe's preference reference does not describe this value; use the URL column for the documentation link. |
| Flash Player for 3D | ``ADC4318556`` | Enables playing 3D and multimedia content using a Flash player in PDF. |
| Hand Tool Select | ``bHandSelects`` | Specifies whether the hand tool should be able to select text and images. |
| Max Recent Files | ``iMaxMRUCntToBeStored`` | Stores the number of recent files that should be listed in the recent files list. |
| Modern Viewer | ``bEnableAv2`` | Show the modern viewer first released in July 2022. |
| Multiple Comment Panels | ``bAllowMultipleExpandedPanels`` | Specifies whether multiple comment panels can be expanded. |
| New Look Coachmark | ``iNumSwitcherContextualToolTipAV2Shown`` | Show the "Acrobat has a new look" coachmark after launching Acrobat the first time. |
| Pin HUD Toolbar | ``bPinHUD`` | Pin the HUD to the toolbar. |
| Prompt Close Tabs | ``bPromptBeforeClosingMultipleTabs`` | Warn the user before closing documents open in multiple tabs. |
| Select Images First | ``bImagesFirst`` | Adobe's preference reference does not describe this value; use the URL column for the documentation link. |
| Show Tool Pane Tips | ``bInfobubble`` | Specifies whether the popup tooltips for the Tools, Comments, and Share panes should appear. |
| Show Touch Keyboard | ``bKeyPrefsShowVirtualKeyoard`` | Show the touch keyboard if device is in touch or tablet mode on Win 8 and later. |
| Snapshot Resolution DPI | ``iSnapshotResolution`` | Adobe's preference reference does not describe this value; use the URL column for the documentation link. |
| Tools Pane State | ``irightPaneState`` | Automatically open the Tools Pane on launch. |
| Tools Pane Sticky | ``iBasicSharePaneStickyStatus`` | Remember the Tools Pane state across sessions. |
| Try New Coachmark | ``iNumSwitcherContextualToolTipAVShown`` | Show the "Try the new Acrobat/Reader" coachmark after launching Acrobat the first time. |
| UI Switcher Sessions | ``iNumSessionAV2`` | Show the UI switcher coachmark based on the number of user sessions. |

### Documents, Editing & Accessibility

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| 2D GPU Acceleration | ``bUse2DGPUf`` | Specifies whether 2D graphics acceleration should be used. |
| Allow Hide UI | ``bAllowDocsToHideUI`` | Allow documents to hide the menu bar, toolbars, and window controls. |
| Annotation Text Selection | ``benableTextSelection`` | Enable text selection on highlight, strikethrough, and underline annotations. |
| Assistive Technology | ``bEnableAT`` | Enable assistive technology workflows. |
| Attach Report | ``bAttachLog`` | Toggles whether to attach the accessibility report to the checked document after running accessibility full check. |
| Auto-Complete on Tab | ``bAutoCompleteOnTab`` | Auto complete form field entries on a tab key action. |
| Auto-Open Drawing Popup | ``bautoOpenOther`` | Automatically adds a popup note when another type of annotation is added. |
| Auto-Save | ``bAutoSaveDocsEnabled`` | Specifies whether or not to automatically save documents. |
| Auto-Save Interval | ``iAutoSaveDocsInterval`` | Specifies the time interval in minutes at which to automatically save docs. |
| Auto-Set Layers | ``bAutoSetLayers`` | Allow the document's layer state to be set by user information. |
| Check Page Range | ``iPages`` | Toggles whether to check all pages of a document or a subset of pages when running an accessibility full check. |
| ClearType Smoothing | ``benableDDR`` | Further smooth text on LCD screens. |
| Color Replace Policy | ``iAccessColorPolicy`` | Replace Document Colors panel policy. |
| Combine Reading Order | ``bCombineContent`` | Specifies whether similar content should be displayed together or separately. |
| Comment Author | ``tauthor`` | The author name specified by balwaysUseIdent. |
| Comment Font Name | ``tNoteFontName`` | Sets the comment font name for the viewer. |
| Comment Font Size | ``dNoteFontSize`` | Sets the font size. |
| Complex Script Support | ``bComplexScript`` | Enable support for writing direction switching (complex script). |
| Confirm Review Import | ``bconfirmEBRMerge`` | Displays an alert on document open asking the user to confirm importing comments into an active review. |
| Copy Text to Drawing | ``bcopyTextToDrawAnnot`` | Copy the encircled text into drawing comment popups. |
| Copy Text to Markup | ``bcopyTextToMarkupAnnot`` | Copies the selected text into highlight, cross-out, and underline comment popups. |
| Create Report | ``bCreateLog`` | Toggles whether to create an accessibility report when running an accessibility full check. |
| Default Page Layout | ``iPageViewLayoutMode`` | Specifies the default page layout when a PDF opens. |
| Default Paragraph Dir | ``iParaDir`` | Specifies the paragraph direction. |
| Default Zoom Type | ``iDefaultZoomType`` | Specifies the default zoom type (other than a %) to use when a PDF opens. |
| Dictionary Name | ``tDictionaryName`` | Identifies the default spelling dictionary name. |
| Embedded Comment Limit | ``imaxPDFCommentsSize`` | Sets the comment threshold size for determining whether comments are embedded or sent as FDF files. |
| Empty Comment Tooltip | ``bemptyContentToolTip`` | Displays a tooltip stating the comment being hovered over is empty. |
| Enhance Thin Lines | ``bUseThinCode`` | Enhance thin lines to improve visibility. |
| Fast Scroll Drawing | ``bSuperFastDrawing`` | Use low-resolution rendering during scroll, zoom, and pan. |
| Form Email Prompt | ``iaskFormsSelectEmailCLient`` | Specifies whether the dialog confirming selection of desktop vs. internet email on XFA form submit appears. |
| Hide Popup on Summary | ``bHidePopupIfShowSummary`` | Hide comment popups when comment's list is open. |
| Hindi Digits | ``bHindiDigit`` | Enable support for Hindi digits. |
| Hover Popups | ``bHoveringPopups`` | Automatically open popups on mouse rollover. |
| Inline Auto-Complete | ``bInlineAutoComplete`` | Auto complete a field based on remembered values when a user starts typing. |
| International Font | ``iIntlSelectFont`` | Specifies the font to use. |
| Ligatures | ``bLigatures`` | Enable support for ligatures. |
| Login Name as Author | ``balwaysUseIdent`` | Use login name as comment author. |
| Open Links in Place | ``bOpenInPlace`` | Open cross document links in the same window. |
| Overprint Shift+Click | ``bOverprintPreviewUseShiftClick`` | Shift+Click behavior in the output preview dialog. |
| Override Document Colors | ``bAccessOverrideDocColors`` | Replace black text or line art colors when iAccessColorPolicy is enabled and a replacement color has been specified. |
| Override Line Art Colors | ``bOverrideLineArtColors`` | Limits color changes to black text and line art when iAccessColorPolicy is enabled and a replacement color has been specified. |
| Override Page Layout | ``iPageLayout`` | Specifies the user selected page layout override. |
| Override Zoom | ``bOverrideZoom`` | Let users set a default zoom for all documents. |
| Override Zoom Type | ``iZoomType`` | Specifies the zoom scale for all other documents other than a % scale and overrides Page Display settings. |
| Paragraph Direction | ``iParagraphDirection`` | Specifies the paragraph direction. |
| Popup When Selected | ``bPopupsOpenIffSelected`` | Open a popup when it is selected. |
| Portfolio File List | ``bUseDetailsNavigator`` | Show portfolio component files and file details in an accessible list. |
| Print Annotations | ``bPrintAnnots`` | Print notes, popups, and other annotations. |
| Print Comment Popups | ``bprintCommentPopups`` | Enables printing of comments and other annotations. |
| Print Popups Opaque | ``bprintNotesOpaque`` | Makes popups opaque regardless of other settings. |
| Prompt Auto-Complete | ``bUserAskedToEnableAutoComplete`` | Specifies whether the user is asked to enable auto complete at runtime. |
| Reading Order Display | ``iShowOrder`` | Specifies the type of grouping order to display in the touchup reading order panel. |
| Remember Form Entries | ``bRecordNewEntries`` | Remember form field entries for use with future auto-complete actions. |
| Restore Last View | ``iRememberView`` | Restore last view settings when reopening documents. |
| Right-to-Left UI | ``bRTLUI`` | Enable right to left language options. |
| RTL Digit Display | ``bDigitsUI`` | Display digits in a way that's consistent with right to left language display. |
| Save Toner/Ink | ``bPrintSaveToner`` | Optimize content so that the printer uses less ink. |
| SDI Mode | ``bSDIMode`` | Open documents in a new window or in tabs in the same window. |
| Send Approval Email | ``bsendFinalApprovalEmail`` | Send a notification email when the current approval is identified as the final one. |
| Show Check Options | ``bShowOptionsDialog`` | Toggles whether to display the options dialog when running an accessibility full check. |
| Show Comments on Import | ``bcommentPanelOnImport`` | Open the comment list when comments are imported. |
| Show Connector Lines | ``bShowAnnotConnector`` | Show lines connecting comment markups to their popups on mouse rollover. |
| Show Focus Rectangle | ``bFocusRect`` | Surround a field with a rectangle when it has focus. |
| Show Keyboard Cursor | ``bShowKeyboardSelectionCursor`` | Specifies whether the keyboard selection cursor should always be active in the document. |
| Show Markup Indicators | ``bshowMarkupModifiers`` | Show markup tool-tips and text indicators. |
| Show Stamps Palette | ``bStampsPaletteInvisible`` | Show the stamps palette automatically when the commenting toolbar is displayed. |
| Show Tab Order | ``bShowAnnotSequence`` | Show tab order of fields for Acroforms and XFA forms. |
| Side-Aligned Popups | ``bsideNotes`` | Creates new popups aligned to the edge of the document. |
| Smooth Images | ``bAntialiasImages`` | Use anti-aliasing (smoothing) for images. |
| Smooth Line Art | ``bAntialiasGraphics`` | Use anti-aliasing (smoothing) for line art. |
| Smooth Text | ``bAntialiasText`` | Anti-alias text when Smooth Text is Monitor or Laptop/LCD. |
| Smooth Zooming | ``bSmoothZooming`` | Specifies whether smooth zooming should be enabled. |
| Spell Check Underline | ``bSpellingUnderline`` | Turns off and on spell checking as you type. |
| Store Numeric Entries | ``bStoreNumericEntries`` | Store user entered numeric values. |
| Structure Tab Order | ``bUseStructTabOrder`` | Use the PDF document structure for determining the tab order. |
| System Selection Color | ``bUseSystemSelectionColor`` | Specifies whether the default selection color (blue) is overridden with a color that the system specifies. |
| Use Local Fonts | ``bUseLocalFonts`` | Use local fonts. |
| XFA Email Client | ``iEmailClientSelection`` | Specifies the email client to use when submitting an XFA form. |
| XObjects View Mode | ``iRXOPolicy`` | Sets XObject access to either Never (0), Always (1), or Only PDF/X-5 Compliant Ones (2). |

### Microsoft Purview (MIP)

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| MIP Logging | ``bEnableLogging`` | Enable debug logging for Microsoft Purview Information Protection operations. |
| MIP Policy Authentication | ``bEnablePolicyAuthentication`` | Specifies whether MIP policy authentication is enabled for the current user. |
| Show Document Message Bar (MIP) | ``bShowDMB`` | Show Microsoft Purview Information Protection label information in the document message bar. |

### Security: Execution & Protection

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| 3D Content Trust | ``b3DEnableContent`` | Trust and render 3D content. |
| Cross-Domain Logging | ``bCrossDomainLogging`` | Enable cross-domain logging for non-same-origin server communication. |
| Enable JS Debugger | ``bEnableDebugger`` | Enables the debugger. |
| FIPS Mode | ``bFIPSMode`` | Turns FIPS mode on and off thereby requiring stronger encryption algorithm and limiting certain application behavior. |
| JS Global Security | ``bEnableGlobalSecurity`` | Controls whether or not a script in one sandbox can access a script object in another sandbox. |
| JS Menu Items | ``bEnableMenuItems`` | Toggles off and on JavaScript's ability to execute menu items. |
| Outlook Protected View | ``bEnableAlwaysOutlookAttachmentProtectedView`` | Protected View for Outlook attachments. |
| Recent Files Migrated | ``bOldRecentFilesMigrated`` | Indicates whether the recent files list has been migrated. |

### Security: Trust & Permissions

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Accept Expired Timestamps | ``bUseExpiredTimestamps`` | Specifies whether expired timestamps should be used. |
| Allow LiveCycle HTTP | ``bAllowConnectViaHTTP`` | If true, the server connection URI uses the format http://server:port/path; otherwise, it uses the format https://server:port/path. |
| Allow Non-Green Cert | ``bAllowCertNonGreen`` | Specifies whether a certification signature may be applied to a document containing Legal PDF warnings. |
| Allow OCSP NoCheck | ``bAllowOCSPNoCheck`` | Specifies whether the OCSPNoCheck extension is allowed in the response signing certificate. |
| Always Consult CDP | ``bAlwaysConsult`` | Determines when the URL is used for an additional URL CRL distribution point. |
| Auth Mechanisms | ``iAuthMechanisms`` | Specifies which registered provider(s) to use. |
| Auto-Accept Privacy | ``iAutoAcceptEDCPrivacyNotification`` | Show an alert confirming acceptance of the privacy policy. |
| Auto-Add LTV Info | ``iAutoAddLTV`` | Auto-add LTV information to signatures. |
| Cache Server Password | ``bSavePassword`` | Indicates whether the password has been cached for this server. |
| CRL Cache Lifetime | ``iMaxRevokeInfoCacheLifetime`` | Maximum lifetime in hours the cached CRL is used for revocation checking. |
| Custom Cert Prefs | ``bCustomPrefsCreated`` | Indicates whether a custom certificate specific preference (e.g. Identrus) has already been created and written to the registry. |
| Default ID Directory | ``aDefDirectory`` | Default directory when searching for digital IDs. |
| Directory Provider | ``iDirectoryProvider`` | Specifies a directory provider for signature validation. |
| Enforce Digest Compare | ``bEnforceSecureChannel`` | Block signing when original and signed message digests differ. |
| Examine on Close | ``bAutoLaunchAtDocClose`` | Automatically examines the document for hidden content when it is closed. |
| Examine on Send | ``bAutoLaunchAtSendMail`` | Automatically examines the document for hidden content when it is sent in an email. |
| Expired Cert Go Online | ``bExpiredCertGoOnline`` | Go online for revocation on expired certificates. |
| FDF Exclude Cert | ``bFDFRequestExcludeCert`` | Similar to the bFDFRequestSave. |
| FDF Export Save | ``bFDFExportSave`` | Persists whether user chose to save (1) or email (0) the FDF during export. |
| FDF Export Sign | ``bFDFExportSign`` | Persists whether the user chose to sign the FDF during export. |
| FDF Request Save | ``bFDFRequestSave`` | Caches a user's answer to the question whether they want to save the request as an FDF or email it directly when that user requests a certificate. |
| Follow AIA URIs | ``bFollowURIsFromAIA`` | Allow the chain builder to follow URIs in AIA certificate extensions so that certificates can be downloaded if they are not available locally. |
| Hide Sig Status Icon | ``bSigAPStatusIconDisable`` | Controls whether the signature status icon is displayed in the signature appearance on the document. |
| ID Dialog Position | ``cDialogs:xSelHandler`` | The last on-screen coordinates of a handler's digital ID selection dialog |
| ID Enrollment URL | ``xDefEnrollmentURL`` | The destination URL when the user selects "Enroll at an online CA" while adding a new digital ID. |
| Ignore OCSP NextUpdate | ``bIgnoreNextUpdate`` | Use embedded OCSP when nextUpdate is absent (with iMaxClockSkew). |
| Import Address Book | ``iImportAddressBook`` | Import addressbook.acrodata on new install. |
| Import Windows Certs | ``bCertStoreImportEnable`` | If true, then users can import from MSCAPI certificate stores into their Trusted Identity Manager. |
| List Of Signing Reasons | ``cReasons`` | Custom signing reason list. |
| Load Security Settings from Server (Adobe Certificates) | ``bLoadSettingsFromURL`` | Controls whether trust anchors are periodically downloaded from Adobe's certificate server. |
| Load Security Settings from Server (European Certificates) | ``bLoadSettingsFromURL`` | Controls whether trust anchors are periodically downloaded from the European Union Trusted Lists (EUTL) server. |
| Load Settings NAME | ``tLoadSettingsNAME`` | Specifies the signing certificate for the imported settings file. |
| Long Term Validation | ``bIsEnabled`` | Specifies whether the signature revocation status is included in the signature. |
| Max Rev Info Archive | ``iMaxRevInfoArchiveSize`` | The maximum size of the revocation archival information in kilobytes. |
| Max Verify Sessions | ``iMaxVerifySession`` | Specifies the maximum number of nested verification sessions allowed. |
| New Sig Field Alert | ``iCreateNewSigFieldAVAlert`` | Show the alert asking whether a new signature field should be created. |
| Non-Embedded Font Warn | ``bEnNonEmbFontLegPDFWarn`` | Turns on and off warnings about non-embedded fonts. |
| OCSP Nonce Behavior | ``iSendNonce`` | Specifies signature validation behavior with respect to nonces. |
| OCSP Responder URL | ``iURLToConsult`` | Specifies how the revocation checker chooses which responder to use. |
| OCSP Response Freshness | ``iResponseFreshness`` | Specifies the amount of time in minutes after the response's published thisUpdate time for which the response will be valid. |
| Open Non-PDF Attachments | ``bAllowOpenFile`` | Open non-PDF attachments in native applications. |
| Password Lockbox ID | ``tLockboxId`` | Set if bSavePassword is not 0 to look up the password in a user's secure password cache. |
| Preview Before Signing | ``bPreviewModeBeforeSigning`` | Specifies whether a signer is forced to use preview mode during signing. |
| Require AKI in CRL | ``bRequireAKI`` | Specifies whether the Authority Key Identifier extension must be present in a CRL. |
| Require OCSP Cert Hash | ``bRequireOCSPCertHash`` | Specifies whether a certificate public key hash extension must be present in OCSP responses. |
| Require Sign Warnings | ``iRequireReviewWarnings`` | Specifies whether the user is required to review document warnings before signing via the signing dialog. |
| Require Timestamp | ``bReqSigPropRetrieval`` | Require successful timestamp retrieval when signing. |
| Require Valid Sig Chain | ``bRequireValidSigForChaining`` | Stop chain building at invalid RSA signatures on intermediates. |
| Return Rev Info to JS | ``bReturnRevInfoToUser`` | If true, the revocation information is maintained within the SignatureInfo object and can be retrieved through JavaScript. |
| Revocation Checker | ``iRevocationChecker`` | Specifies a provider for revocation checking. |
| Revoke Check Trust | ``bRevCheckTrust`` | Revocation-check intermediate (non-root) trust anchors. |
| RSA-PSS Salt Length | ``iRSAPSSSaltLength`` | Specifies the Salt Length the RSA-PSS algorithm uses. |
| RSA-PSS Signing | ``bEnableRSAPSSSigning`` | Specifies whether a signature should be created with the RSA-PSS algorithm. |
| RSAPSS Hash Algorithm | ``aRSAPSSHashAlgorithm`` | Specifies the hash algorithm used for RSA-PSS signing. |
| SAML Auth Server URL | ``tSAML_Assertion_Source`` | Holds the URL of the authentication server from which the SAML assertion stored in cSAML_Assertion was obtained. |
| SAML Name Format | ``tSAML_Name_Format`` | SAML_NAME_<Value, Format, Qualifier> comprise the subject name identifier taken from the SAML assertion received during the account's last user authentication. |
| SAML Name Qualifier | ``tSAML_Name_Qualifier`` | SAML_NAME_<Value, Format, Qualifier> comprise the subject name identifier taken from the SAML assertion received during the account's last user authentication. |
| Save Certified Alert | ``iDigSigSaveAsCertified`` | Controls whether to show an alert when saving a certified document. |
| Secure Open Attachments | ``bSecureOpenFile`` | Restrict attachment opens to PDF only. |
| Self-Sign ID Create | ``bSelfSignCertGen`` | Allow Create a self-signed ID in Add ID workflows. |
| Server URL | ``tServerURL`` | The default server URL. |
| Show All Chains | ``bShowAllChains`` | Show all chains in the Certificate Viewer. |
| Show Document Warnings | ``iShowDocumentWarnings`` | Specifies whether a button to allow reviewing document warnings shows up on the signing dialog. |
| Show Post-Sign Warning | ``bShowWarningForChanges`` | Show blue info icon when a validated approval signature document changes after signing. |
| Show Sign Contact Info | ``bAllowOtherInfoWhenSigning`` | Specifies whether the location and contact information UI will appear during signing. |
| Show Signer Warnings | ``bShowSignerWarnings`` | Show a warning that there is a greater forgery risk when revocation information is embedded in the signature. |
| Show Valid Sig Icon | ``iDisplayValidIcon`` | When to show signature status icon in appearance. |
| Sig Property Verify | ``bReqSigPropVerification`` | Specifies whether signature property verification must succeed for a signature to be valid. |
| Sig Verification Time | ``iSigVerificationTime`` | Indicates the time at which signature validation should occur. |
| Sign Certified Only | ``bAllowSigCertOnly`` | Specifies whether any subsequent signers can sign a certified document containing LegalPDF warnings with additional approval signatures. |
| Sign Done Dialog | ``isignDone`` | Show a dialog indicating that a document was successfully signed. |
| Sign Green Cert Only | ``bAllowSigCertGreenOnly`` | Specifies whether any subsequent signers can sign a certified document that does not contain LegalPDF warnings with additional approval signatures. |
| Sign Hash Algorithm | ``tSignHash`` | A text entry that contains the OID of the hashing algorithm. |
| Sign OCSP Requests | ``bSignRequest`` | Specifies whether the OCSP request should be signed. |
| Signing Contact Info | ``tContactInfo`` | When bAllowOtherInfoWhenSigning is true (on), the signing dialog displays a location and contact field. |
| Timestamp Hash Algo | ``iHashAlgo`` | Identifies the hashing algorithm used to hash the timestamped data. |
| Timestamp Sig Size | ``iSize`` | ASPKI requires the signature property to predict the size (in bytes) so that enough space can be set aside. |
| Tracker Server URL | ``tServer`` | The DNS server name (i.e. alrms.adobe.com). |
| TrueType Font Warn | ``bTrueTypeFontPDFSigQWarn`` | Turns on and off warnings about True Type fonts. |
| Trust Certified Docs | ``bTrustCertifiedDocuments`` | Trust certified documents as privileged locations. |
| Trust IE Trusted Sites | ``bTrustOSTrustedSites`` | Treat IE Trusted Sites and Local Intranet as privileged locations. |
| Trusted/Blocked URL List | ``tHostPerms`` | Stores the list of trusted and blocked URLs used when URL Access Permissions (iURLPerms) is set to Custom Setting. |
| URL Access Permissions | ``iURLPerms`` | Allow, block, or custom website access. |
| Url Of The Roaming Id | ``tURL`` | The URL of the Roaming ID server. |
| Use Archived Rev Info | ``iUseArchivedRevInfo`` | Indicates whether the revocation information archived with the signature is used for revocation checking. |
| Validity Model | ``iValidityModel`` | Signature and certificate validity model. |
| Windows Store Trust | ``iMSStoreTrusted`` | Trust Windows Certificate Store certs for signing and certifying. |

### Sharing & Features

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Default Email Prompt | ``iSendMailDefaultAccountAlert`` | Specifies whether a dialog should appear asking if a PDF should be sent via the user's default email account. |
| Default Email Set | ``bDefaultSet`` | Indicates whether a default email client has been set. |
| Disable Shared Review | ``bDisableSharedReview`` | Control cloud-based shared review availability. |
| Enable Synchronizer | ``bNeedSynchronizer`` | Enable the synchronizer. |
| Fill & Sign Pane | ``bEnableFillSign`` | Remove the Fill and Sign pane without removing the Work with Certificates menu. |
| Remove Comma Delimiter | ``bRemoveCommaDelimiter`` | Remove the comma in comma-delimited addressbook entries. |
| Show Connect Dialog | ``bShowConnectDialog`` | Display the Connect dialog in Shared Reviews. |
| Show Welcome Dialog | ``bShowWelcomeDialog`` | Show the Welcome dialog when a shared review is initiated. |

### Startup & Experience

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| App Activated | ``bActivated`` | Records whether the application has been activated online after installation. |
| App Has Launched | ``bHasLaunched`` | Records whether the application has been launched after installation. |
| App Initialized | ``bAppInitialized`` | Records whether the application has been initialized after installation. |
| App Launched | ``bLaunched`` | Caches whether or not the application has ever been launched. |
| Choose Language Startup | ``bChooseLangAtStartup`` | Allows the user to choose the language at startup. |
| Create Form Onboarding | ``bCreateFormDiscoveryShown`` | Show the onboarding coachmark when the user invokes the Create Form panel. |
| Edit Onboarding | ``bEditDiscoveryShown`` | Show the onboarding coachmark when the user invokes the Edit panel. |
| Fill & Sign Onboarding | ``bFillSignDiscoveryShown`` | Show the onboarding coachmark when the user invokes the Fill & Sign panel. |
| Hide Help Welcome | ``bHideHelpWelcome`` | Disable the Welcome menu item under Help. |
| Home Onboarding | ``bShownHomeOnboarding`` | Invoke the home onboarding tour when the modern viewer is invoked the first time. |
| Load All Plugins | ``bLoadAllPluginsAtStartup`` | Specifies whether all plugins should be loaded when the application is started. |
| Organize Onboarding | ``bOrganizeDiscoveryShown`` | Show the onboarding coachmark when the user invokes the Organize panel. |
| Page Caching | ``bUsePageCache`` | Cache pages that have been loaded. |
| Redaction Onboarding | ``bRedactDiscoveryShown`` | Show the onboarding coachmark when the user invokes the Redaction panel. |
| Show About Dialog | ``bDisplayAboutDialog`` | Specifies whether or not to display the startup splash screen at every launch. |
| Show Alt Text Alert | ``idontShowAllImagesHaveAltText`` | Toggles whether to show an alert when a user executes the Set Alternate Text dialog and there are no images missing alternate text. |
| Show EULA Startup | ``bshowEULA`` | Toggles on and off whether the end user license agreement appears. |
| Show Getting Started | ``bLastShowStatus`` | Show "Get Started with Acrobat" on startup. |
| Show H-Scrollbar | ``bShowHorizontalScrollbar`` | Show a horizontal scrollbar when the viewing area is narrower than the width of the loaded document. |
| Show Report Alert | ``bShowExistingAttachedReportAlert`` | Toggles whether to show an alert when a user tries to attach a report if there is already a report attached. |
| Show Set Alt Alert | ``idontShowSetAltTextInfo`` | Toggles whether to show an informative alert when a user executes the Set Alternate Text dialog. |
| Show Skip Card | ``bShowedSkipCard`` | Show the skipped onboarding coachmark. |
| Show Splash Screen | ``bSplashDisplayedAtStartup`` | Toggles whether the splash screen appears on startup. |
| Splash Displayed | ``bDisplayedSplash`` | Indicates whether or not the application has started up and invoked the splash screen. |
| Trial Mode Active | ``bInTrialMode`` | Records whether the application is operating in Trial Mode. |
| Viewer Onboarding | ``bShownViewerOnboarding`` | Invoke the new viewer onboarding tour when a PDF opens in the modern viewer the first time. |
| Viewer Quit Delay | ``iDelayBeforeQuitViewer`` | Specifies the number of seconds the standalone application stays in memory before it shuts down. |

### Updates & Desktop Integration

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Background Download | ``bDownloadEntireFile`` | Allow background downloading of resources the view thinks it needs to properly display the PDF. |
| Browser Quit Delay | ``iDelayBeforeQuitBrowser`` | Specifies the number of seconds the browser-based application stays in memory before it shuts down. |
| Browser Read Mode | ``bBrowserDisplayInReadMode`` | Open browser PDFs in Read Mode. |
| Cleanup Check Done | ``bInstalledCleanupCheckDone`` | A preference used by the usage measurement feature to determine whether the previously set UsageMeasurement-related keys should be reset. |
| Collab Sync Startup | ``bLoadOnStart`` | Specifies whether the collaboration executable should be invoked and run as a background process on startup. |
| Fast Web View | ``bAllowByteRangeRequests`` | Enable Fast Web View by allowing display of the PDF before the entire file is downloaded. |
| Remember Stars Choice | ``bFavoriteFilesRememberChoice`` | Specifies the user's choice |
| Show Starred Files | ``bFavoritesStripInRFL`` | Show starred files in the recent files list. |
| Starred Files Action | ``iFavoriteFilesAccessOption`` | Specifies what action to take when starring a file. |
| Store Credentials | ``bStoreCredentials`` | Specifies whether the user logon credentials for the Tracker should be stored. |
| Suppress Update Warning | ``iAVARMNoAutoUpdateWarning`` | Turn off the "Updater has not been able to check for updates recently" dialog. |

### Upsell

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Acrobat App Promo | ``bAcrobatAppInstalled`` | Show the Acrobat mobile app promotion and link in the Home banner. |
| Scan App Promo | ``bScanAppInstalled`` | Show the Adobe Scan mobile app promotion and link in the Home banner. |

## Acrobat Only

### Context, Tools & Search

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Disable Sign in Office | ``DisableSignInOffice`` | Install PDFMaker's Acrobat Sign integration component so that the sign user interface appears in Microsoft Office products. |
| Enable Sign in Office | ``EnableSignInOffice`` | Install PDFMaker Acrobat Sign UI in Microsoft Office. |
| Suppress PDF/UA Dialog | ``4406238`` | Suppress the confirmation dialog when the Acrobat preference Mark PDF/UA compliant is checked in Microsoft Word. |

### Documents, Editing & Accessibility

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Cloud Auto Tagging | ``bEnableCloudBasedAT`` | Enable cloud-based auto-tagging. |
| Popups Scroll With Page | ``bPopupsScrollWithPage`` | Specifies whether popups are visible when a document is scrolled. |
| Show Rulers | ``bRulersVisible`` | Show or hide rulers for every new document launch. |

### Security: Execution & Protection

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Editor Font Name | ``tEditorFontName`` | Specifies the font for the script editor. |
| Editor Font Size | ``tEditorFontSize`` | Specifies the font size for the script editor. |
| Editor Path | ``tEditorPath`` | Provides a path to an external editor. |
| External JS Editor | ``bChooseDialog`` | Specifies whether or not to use the Acrobat editor or an external editor. |
| JS Console Input | ``bConsoleInput`` | Toggles whether or not the console appears if script execution results in an error or message. |
| JS Debugger Console | ``bConsoleOpen`` | Enables the interactive debugger console. |
| JS Exception Handling | ``iExceptions`` | Specifies how exceptions should be handled. |
| Save JS Breakpoints | ``bSaveBreakpoints`` | Stores breakpoints in a PDF file |

### Security: Trust & Permissions

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Keep Hidden Content | ``bDontRemoveOverlapping`` | Remove hidden content when sanitizing a document. |

### Sharing & Features

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Show Review Tip | ``bIsUsedShareReview`` | Show a popup tip that informs users of the collaborative review feature. |
| Show Share Tip | ``bIsUsedShare`` | Show a popup tip that informs users of the share file feature. |

### Startup & Experience

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Browser EULA Accepted | ``EULAAcceptedForBrowser`` | For Acrobat's browser plugin, caches whether the browser-based EULA has been accepted. |

### Upsell

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Show Trial Nag | ``bShowTrialNag`` | Specifies whether a "Trial Expired" dialog should appear after 30 days. |

## Reader Only

### Security: Execution & Protection

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Broker Logfile Path | ``tBrokerLogfilePath`` | Specifies the path and log file name for the Protected Mode log. |

### Startup & Experience

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| EULA Acceptance | ``EULA`` | Accept EULA for the built-in updater. |

**Sharing & responsibility** - Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.