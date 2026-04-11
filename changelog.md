[<- Back to Documentation](README.md)

<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

# Changelog

Settings changes across ADMX versions. Only new, renamed, or reclassified settings are listed — internal script and formatting changes are omitted.

---

## v2.9 — 11 April 2026

One new Acrobat-only setting added and one FriendlyName renamed, bringing the total to **255 policies** (140 Acrobat + 115 Reader).

| Setting | ValueName | Change |
|---|---|---|
| Reader mode on Acrobat (Unified x64) | `bIsSCReducedModeEnforcedEx` | New — Acrobat DC only; sourced from [Adobe enterprise KB](https://helpx.adobe.com/enterprise/kb/acrobat-64-bit-for-enterprises.html) |
| Generative AI Technology | `bEnableGentech` | FriendlyName renamed from "Enable Generative AI" |

Unused `<using namespace="Microsoft.Policies.Windows" prefix="windows"/>` line removed from generated ADMX `policyNamespaces`.

---

## v2.8 — 10 April 2026

Three new settings added from Adobe's Application Security Guide, bringing the total to **254 policies** (139 Acrobat + 115 Reader).

| Setting | ValueName | Type | Category | Hardening |
|---|---|---|---|---|
| 3D Content in PDFs | `bEnable3D` | DWORD toggle | Security: Execution & Protection | Recommended — Disabled |
| Unlisted Attachment Type Permissions | `iUnlistedAttachmentTypePerm` | 4-value dropdown | Security: Execution & Protection | Recommended — Prompt without ability to allow |
| Built-in Attachment Permissions List | `tBuiltInPermList` | Text (pipe-separated list) | Security: Execution & Protection | Not on hardening page |

---

## v2.7 — 9 April 2026

One new setting added; five existing cloud connector settings moved from Reduce Nags to Security Hardening page as Recommended.

| Setting | ValueName | Change |
|---|---|---|
| OneDrive Connector | `bOneDriveConnectorEnabled` | New setting — Recommended Disabled on hardening page |
| Third-Party Cloud Connectors | `bToggleWebConnectors` | Moved to hardening page — Recommended Disabled |
| Box Cloud Connector | `bBoxConnectorEnabled` | Moved to hardening page — Recommended Disabled |
| Dropbox Cloud Connector | `bDropboxConnectorEnabled` | Moved to hardening page — Recommended Disabled |
| Google Drive Connector | `bGoogleDriveConnectorEnabled` | Moved to hardening page — Recommended Disabled |

Total: **248 policies** (136 Acrobat + 112 Reader).

---

## v2.5 — 8 April 2026

No new settings. Acrobat DC x86 policies added to `AdobeDC_x86.admx` (previously Reader-only). Total x64 policy count: **248**.

---

## v2.2 — 8 April 2026

No new settings. 15 FriendlyNames corrected to fix double-negative logic, and 6 clarified for consistency. Registry values and toggle logic unchanged.

### Double-negative fixes (15 settings)

| Category | ValueName | Old FriendlyName | New FriendlyName |
|---|---|---|---|
| Context, Tools & Search | `ADC4275035` | Form Editing Tools (2019) | Remove Form Editing Tools (2019) |
| Cloud & Connectors | `bToggleSendACopy` | Fill & Sign Send a Copy Button | Hide Fill & Sign Send a Copy Button |
| Documents, Editing & Accessibility | `bIgnoreDataSchema` | Save All Form Data | Restrict Form Data to Schema |
| Documents, Editing & Accessibility | `DisableScannedDocumentEditing` | Scanned PDF Text Recognition | Disable Scanned PDF Text Recognition |
| Security: Trust & Permissions | `bDisableOSTrustedSites` | Lock IE Trusted Sites as Privileged | Disable IE Trusted Sites as Privileged Locations |
| Security: Trust & Permissions | `bMSStoreTrusted` | Lock Windows Certificate Store Trust UI | Allow Changes to Windows Certificate Store Trust |
| Security: Trust & Permissions | `bDisableExpandEnvironmentVariables` | Protected View User Library Trust | Block User Library Trust in Protected View |
| Sharing & Features | `bMixRecentFilesFeatureLockDown` | Shared Files in Recent List | Hide Shared Files from Recent List |
| Startup & Experience | `bDontShowMsgWhenViewingDoc` | Adobe Messages on Document Open | Hide Adobe Messages on Document Open |
| Startup & Experience | `bAllowUserToChangeMsgPrefs` | Lock Message Preferences | Allow Users to Change Message Preferences |
| Startup & Experience | `bToggleShareFeedback` | Send Feedback Icon | Hide Send Feedback Icon |
| Updates & Desktop Integration | `bAcroSuppressOpenInReader` | Chrome PDF Extension | Disable Chrome PDF Extension |
| Upsell | `bToggleBillingIssue` | Billing Issue Call to Action | Disable Billing Issue Call to Action |
| Upsell | `bToggleSophiaWebInfra` | Promotional Campaign Messages | Disable Promotional Campaign Messages |
| Upsell | `bAcroSuppressUpsell` | Suppress Upgrade Messages | Show Upgrade Prompts |

### Clarification renames (6 settings)

| Category | ValueName | Old FriendlyName | New FriendlyName |
|---|---|---|---|
| Context, Tools & Search | `bRCMCombineFeatureKey` | Combine Files Context Menu | Show Combine Files Context Menu |
| Sharing & Features | `bToggleManageSign` | Acrobat Sign Tracking Tab | Show Acrobat Sign Tracking Tab |
| Startup & Experience | `bToggleNotificationToasts` | Desktop Notification Toasts | Show Desktop Notification Toasts |
| Startup & Experience | `bTogglePDFOwnershipToasts` | PDF Ownership Notification | Show PDF Ownership Notification |
| Startup & Experience | `bToggleToDoTiles` | To Do Cards in Recent Tab | Show To Do Cards in Recent Tab |
| Upsell | `bToggleDCAppCenter` | App Center UI | Show App Center UI |

Total: **247 policies** (135 Acrobat + 112 Reader).

---

## v2.1 — 7 April 2026

Initial release. **247 policies** (135 Acrobat + 112 Reader) generated from 146 CSV rows covering 9 categories:

- Cloud & Connectors
- Context, Tools & Search
- Documents, Editing & Accessibility
- Security: Execution & Protection
- Security: Trust & Permissions
- Sharing & Features
- Startup & Experience
- Updates & Desktop Integration
- Upsell
