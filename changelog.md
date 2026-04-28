[<- Back to Documentation](README.md)

<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

# Changelog

Settings changes across ADMX versions. Only new, renamed, or reclassified settings are listed — internal script and formatting changes are omitted.

---

## v2.16 — 28 April 2026

**No settings changes:** Policy definitions are unchanged from **v2.15** below; this drop updates ADMX/ADML-only metadata (`revision`/`minRequiredRevision` alignment and three-line localization root element layout for Group Policy interoperability). Omitted per the rule above; see [readme in v2.16](../v2.16/readme.md).

---

## v2.15 — 16 April 2026

**Breaking change:** Corrected Enabled/Disabled toggle mapping for three policies where "Enabled" in Group Policy wrote the wrong DWORD value.

| Setting | ValueName | v2.14 (old) | v2.15 (new) |
|---|---|---|---|
| Block JavaScript Execution | `bDisableJavaScript` | Enabled → DWORD 0 (allow) | Enabled → DWORD 1 (block) |
| Disable SharePoint & Office 365 Integration | `bDisableSharePointFeatures` | Enabled → DWORD 0 (enable) | Enabled → DWORD 1 (disable) |
| Disable WebMail Integration | `bDisableWebmail` | Enabled → DWORD 0 (enable) | Enabled → DWORD 1 (disable) |

**If you previously deployed these policies, verify and re-apply the intended state after upgrading.**

### FriendlyName corrections

| ValueName | Old FriendlyName | New FriendlyName |
|---|---|---|
| `bDisableSharePointFeatures` | SharePoint & Office 365 Integration | Disable SharePoint & Office 365 Integration |
| `bDisableWebmail` | WebMail Integration | Disable WebMail Integration |

The old names were misleading because selecting "Enabled" in Group Policy actually disabled the feature. The new names make the admin intent clear.

### Summary text improvements

Four policies reworded from "Disables X" to "Controls whether X is enabled" for neutral, descriptive text:

| ValueName | FriendlyName |
|---|---|
| `bToggleAdobeDocumentServices` | Document Cloud Services |
| `bTogglePrefsSync` | Preferences Synchronization |
| `bUpdater` (cServices) | Services & Web-Plugin Updates |
| `bToggleAdobeSign` | Adobe Acrobat Sign |

### DISA STIG cross-references

Policy description text now includes DISA STIG rule references where applicable (20 registry settings; 26 Reader rules, 23 Pro rules).

### Documentation updates

- **Security Hardening page:** 10 new entries added (5 Recommended, 5 Optional) for settings that had GoodSetting recommendations but were not previously listed.
- **Reduce Nags page:** 2 new entries added; existing Product Updater entry corrected to reference the FeatureLockDown path.

### Combined ADMX file

A new combined ADMX file (`AdobeDC.admx`) is now provided alongside the existing per-architecture files.

| ADMX File | Products & Architectures | Policies |
|---|---|---:|
| `AdobeDC.admx` | Reader DC (x86 + x64) and Acrobat DC (x86 + x64) | 520 |
| `AdobeDC_x64.admx` | Reader DC (x64) and Acrobat DC (x64) | 260 |
| `AdobeDC_x86.admx` | Reader DC (x86) and Acrobat DC (x86) | 260 |

Policy count unchanged from v2.14.

---

## v2.13 — 14 April 2026

Two settings added for both products, bringing the total to **262 policies** (144 Acrobat + 118 Reader).

| Setting | ValueName | Change |
|---|---|---|
| Block JavaScript Execution | `bDisableJavaScript` | New — Both products. Blocks and locks JavaScript execution; prevents users from bypassing via privileged locations. Added to **Security Hardening** page as Recommended (Enabled). |
| Accept EULA for Updater | `EULA` | New — Both products. Accepts the EULA on behalf of the user so the built-in updater can download product updates. |

`bDisableJavaScript` was present in all v1.x ADMX versions but was inadvertently omitted when the v2.x series was generated from the lockable PrefRef CSV. The v1.3 ADMX had the enabledValue/disabledValue wired backwards (Enabled=0=allow); v2.13 corrects this to match the `bDisablePDFRedirectionActions` pattern (Enabled=1=block). `EULA` is a non-policy HKLM key under `AdobeViewer` that was present in v1.3 but dropped in v2.x; it has been re-added as an enterprise convenience for deployments that did not set `EULA_ACCEPT=YES` at install time.

---

## v2.12 — 13 April 2026

**Breaking change:** Corrected the GPO Enabled/Disabled toggle mapping for two Acrobat DC policies.

| Setting | ValueName | v2.11 (old) | v2.12 (new) |
|---|---|---|---|
| Block EMF to PDF Conversion | `BlockEMFParsing` | Enabled → DWORD 0 (allow) | Enabled → DWORD 1 (block) |
| Block XPS to PDF Conversion | `BlockXPSParsing` | Enabled → DWORD 0 (allow) | Enabled → DWORD 1 (block) |

In v2.11, setting these policies to **Enabled** wrote DWORD 0 (allow conversion), contradicting the "Block..." friendly name. v2.12 aligns the toggle so **Enabled = block** and **Disabled = allow**, matching both the policy name and Adobe's documented registry semantics.

**If you previously deployed these policies, verify and re-apply the intended state after upgrading.**

Also updated the ADML Explain text to include a GPO-oriented clarification for both policies.

Documentation: `bAcroSuppressUpsell` (Show Upgrade Prompts) scope corrected from Reader to Both on the **Reduce Nags** page — the Unified x64 installer reads Acrobat registry keys, so this setting must be configurable under Acrobat DC.

---

## v2.11 — 13 April 2026

Existing setting expanded to Acrobat DC, bringing the total to **258 policies** (142 Acrobat + 116 Reader).

| Setting | ValueName | Change |
|---|---|---|
| Hide Adobe Messages on Document Open | `bDontShowMsgWhenViewingDoc` | Expanded from Reader DC only to Both (Reader + Acrobat). The Unified x64 installer runs in Reader mode under Acrobat registry keys, so this setting must be configurable under the Acrobat DC path for Unified deployments. |

Also updated the **Reduce Nags** documentation page scope from Reader to Both.

Resolved **Known Issue** from v2.10: "`cIPM\bDontShowMsgWhenViewingDoc` evaluate adding an Acrobat DC entry" — now included.

---

## v2.10 — 13 April 2026

One new setting added for both products, bringing the total to **257 policies** (141 Acrobat + 116 Reader).

| Setting | ValueName | Change |
|---|---|---|
| Patch Cache Cleanup | `PatchCleanFlag` | New — Both products; sourced from [Adobe Employee response on Adobe Community (Feb 2026)](https://community.adobe.com/questions-9/we-have-a-few-computers-wtih-literally-hundreds-of-1gb-update-msi-files-downloading-constantly-1302886). Not listed on lockable.html or PrefRef. |

Also added to the **Reduce Nags** documentation page as a Recommended setting (Enabled).

---

## v2.9 — 11 April 2026

One new Acrobat-only setting added and one FriendlyName renamed, bringing the total to **255 policies** (140 Acrobat + 115 Reader).

| Setting | ValueName | Change |
|---|---|---|
| Reader mode on Acrobat (Unified x64) | `bIsSCReducedModeEnforcedEx` | New — Acrobat DC only; sourced from [Adobe enterprise KB](https://helpx.adobe.com/enterprise/kb/acrobat-64-bit-for-enterprises.html) |
| Generative AI Technology | `bEnableGentech` | FriendlyName renamed from "Enable Generative AI" |

[**MHimken**](https://www.reddit.com/user/MHimken/) flagged that the Windows ADMX is not required; the unused `<using namespace="Microsoft.Policies.Windows" prefix="windows"/>` line was removed from generated ADMX `policyNamespaces`.

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

---

**Sharing & Responsibility** — Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
