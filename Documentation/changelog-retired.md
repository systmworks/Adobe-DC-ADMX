<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](../README.md)

# Changelog (Retired)

> **Retired.** Version history for combined releases is maintained in [Changelog (Combined)](changelog.md). This file is frozen for reference to pre-combined device-only and user-only releases.

Settings changes across ADMX versions. Only new, renamed, or reclassified settings are listed - internal script and formatting changes are omitted.

---

## Device history
## Combined v3.0 - 18 July 2026

**797 policies** (296 machine + 501 user) in a single `AdobeDC.admx`/ADML pair.

| Change | Detail |
|---|---|
| Packaging | Single combined template (Machine + User) under namespace `Adobe.Policies.AdobeDC` |
| Tree | **Adobe DC** -> **Acrobat & Reader DC** / **Reader DC (32-bit)** / **Non-Policy Settings** (Computer); **Acrobat DC** / **Reader DC** (User) |
| De-duplication | `HKLM\SOFTWARE\Policies` settings emit once per product hive (no redundant `WOW6432Node\Policies` copies) |
| Sources | Device v2.21 + User v1.10 |

---

## v2.21 - 1 July 2026

**Bug fix:** Restored five Reader-only settings that were missing from the **Acrobat & Reader DC (Unified x64)** branch after the v2.20 merge.

| Setting | ValueName | Category | Unified x64 hive |
|---|---|---|---|
| Online Create PDF in Reader | `bEnableFrictionlessInChromeExtn` | Documents, Editing & Accessibility | Acrobat |
| Protected Mode Whitelist Config | `bUseWhitelistConfigFile` | Security: Execution & Protection | Acrobat |
| Prompt to Use Acrobat from Reader | `bEnableAcrobatPromptForDocOpen` | Updates & Desktop Integration | Acrobat |
| Prompt Reader Users to Download Acrobat | `bReaderRetentionExperiment` | Upsell | Acrobat |
| Show Purchasable Tools in Search | `bShowRhpToolSearch` | Upsell | Acrobat |

Policy count: **436** (was 431). Reader x86 branch unchanged (WOW6432Node `Acrobat Reader\DC` hive). Unified x64 uses the Acrobat hive because UCB x64 Reader mode reads Acrobat registry keys, not the legacy Reader x64 hive.

---

## v2.20 - 30 June 2026

**Structural release:** Single combined machine template with a flattened three-branch Group Policy tree. Split `AdobeDC_x64` / `AdobeDC_x86` templates are no longer published.

| Change | Detail |
|---|---|
| Tree | **Adobe (Machine)** -> **Acrobat & Reader DC (Unified x64)** -> **Acrobat DC (x86)** -> **Reader DC (x86)** |
| Unified x64 | Uses Acrobat HKLM hive for x64 Reader and Acrobat (Unified Codebase); separate Reader x64 branch removed |
| ARM updater | All ARM hive policies use `WOW6432Node`; duplicated under Unified x64 and Acrobat x86 |
| File size | **431** policies (was 552 in v2.19 combined template) |

**New machine policies (STIG gaps):**

| Setting | ValueName | Old version | New version |
|---|---|---|---|
| Disable Acrobat.com File Storage | `bDisableADCFileStore` | N/A | Enabled -> DWORD **1** (Acrobat only) |
| Disable Welcome Screen | `bShowWelcomeScreen` | N/A | Enabled -> DWORD **0** |
| Usage Measurement (legacy) | `bUsageMeasurement` | N/A | Disabled -> DWORD **0** |

*Thanks to **[@virtitnerd](https://github.com/virtitnerd)** for community review (ARM path fix and STIG gap policies).*

See readme in v2.19 (retired) (archived locally; see git history or GitHub Releases for v2.19 release notes).

| ADMX File | Policies |
|---|---:|
| `AdobeDC.admx` | 431 |

---

## v2.19 - 28 June 2026

**New machine policies (Reader + Acrobat):** Six **Microsoft Purview (MIP)** lockdown policies under `FeatureLockDown`, completing the HKLM portion of [issue #8](https://github.com/systmworks/Adobe-DC-ADMX/issues/8). These are admin lockdown policies (they gray out or lock Preferences UI); they complement the per-user `MicrosoftAIP` preferences in [User ADMX v1.6](https://github.com/systmworks/Adobe-DC-User-ADMX).

Registry values are sourced from [Adobe enterprise MIP guidance](https://helpx.adobe.com/enterprise/kb/mpip-support-acrobat.html) (community-verified; not in the official PrefRef lockable table).

*Thanks to **[@virtitnerd](https://github.com/virtitnerd)** for the original feature request.*

| Setting | ValueName | Old version | New version |
|---|---|---|---|
| Enable MIP Labelling | `bMIPLabelling` | N/A | Enabled -> DWORD **1** |
| Check MIP Policy on Save | `bMIPCheckPolicyOnDocSave` | N/A | Enabled -> DWORD **1** |
| MIP Sovereign Cloud | `iMIPCloud` | N/A | Dropdown (0-10; Commercial = **3**) |
| MIP External Browser Auth | `bMIPExternalAuthAdmin` | N/A | Enabled -> DWORD **1** |
| MIP Double Key Encryption | `bEnableDKEAdmin` | N/A | Enabled -> DWORD **1** |
| Suppress OS Auth Prompts (MIP) | `bSilentAuth` | N/A | Enabled -> DWORD **1** (Disabled -> **0** for auth troubleshooting) |

Per-user HKCU policies (`bShowDMB`, `bEnablePolicyAuthentication`, `bEnableLogging`) ship in **User ADMX v1.6** only. Computer and User templates use separate namespaces (`Adobe.Policies.AdobeDC` vs `Adobe.Policies.Adobe_User`) and can be deployed together.

See readme in v2.19 (retired) (archived locally; see git history or GitHub Releases - includes **v2.18** release notes in the same file).

| ADMX File | Policies |
|---|---:|
| `AdobeDC.admx` | 552 |
| `AdobeDC_x64.admx` / `AdobeDC_x86.admx` | 276 each |

---

## v2.18 - 20 May 2026

**New machine policy (Reader + Acrobat):** **Block non-PDF file attachments** (`iFileAttachmentPerms`, DWORD **1** under `FeatureLockDown`), per DISA STIG Reader **V-213174** (ARDC-CN-000035) and Acrobat Pro **V-213119** (AADC-CN-000275), and consistent with NSA hardening guidance for Adobe Acrobat.

*Thanks to **CyberChelonian** for flagging this setting.*

| Setting | ValueName | Old version | New version |
|---|---|---|---|
| Block non-PDF file attachments | `iFileAttachmentPerms` | N/A | Enabled -> DWORD **1** (Not configured = product default; Disabled -> DWORD **0**) |

See readme in v2.19 (retired) (archived locally; see git history or GitHub Releases - includes **v2.17** release notes in the same file; version readmes do not link across folders).

| ADMX File | Policies |
|---|---:|
| `AdobeDC.admx` | 528 |
| `AdobeDC_x64.admx` / `AdobeDC_x86.admx` | 264 each |

---

## v2.17 - 19 May 2026

**New Acrobat DC policies (machine):** **Protected Mode Sandbox** (`bProtectedMode`) and **AppContainer Sandbox** (`bEnableProtectedModeAppContainer`) under `FeatureLockDown`, aligned with Adobe's [Privileged (Protected Mode)](https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/Privileged.html) reference and DISA STIG Acrobat Pro DC **V-213127** (AADC-CN-001010). They were previously available in the templates under **Reader DC** only; they now appear under **Acrobat DC** as well so administrators can enforce sandbox settings on full Acrobat through Group Policy or Intune.

*Thanks to **CyberChelonian** for flagging the need for Acrobat DC coverage of these sandbox settings.*

| Setting | ValueName | Old version | New version |
|---|---|---|---|
| Protected Mode Sandbox | `bProtectedMode` | N/A | New for **Acrobat DC**; Enabled -> DWORD **1** |
| AppContainer Sandbox | `bEnableProtectedModeAppContainer` | N/A | New for **Acrobat DC**; Enabled -> DWORD **1** |

Release notes for **v2.17** and **v2.16** are documented in the v2.19 (retired) readme (archived locally; see git history or GitHub Releases - version readmes do not link across folders).

| ADMX File | Policies |
|---|---:|
| `AdobeDC.admx` | 524 |
| `AdobeDC_x64.admx` / `AdobeDC_x86.admx` | 262 each |

---

## v2.16 - 28 April 2026

**No settings changes:** Policy definitions are unchanged from **v2.15** below; this drop updates ADMX/ADML-only metadata (`revision`/`minRequiredRevision` alignment and three-line localization root element layout for Group Policy interoperability). Omitted per the rule above; see readme in v2.19 (retired) (archived locally; see git history or GitHub Releases).

---

## v2.15 - 16 April 2026

**Breaking change:** Corrected Enabled/Disabled toggle mapping for three policies where "Enabled" in Group Policy wrote the wrong DWORD value.

| Setting | ValueName | v2.14 (old) | v2.15 (new) |
|---|---|---|---|
| Block JavaScript Execution | `bDisableJavaScript` | Enabled -> DWORD 0 (allow) | Enabled -> DWORD 1 (block) |
| Disable SharePoint & Office 365 Integration | `bDisableSharePointFeatures` | Enabled -> DWORD 0 (enable) | Enabled -> DWORD 1 (disable) |
| Disable WebMail Integration | `bDisableWebmail` | Enabled -> DWORD 0 (enable) | Enabled -> DWORD 1 (disable) |

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

## v2.13 - 14 April 2026

Two settings added for both products, bringing the total to **262 policies** (144 Acrobat + 118 Reader).

| Setting | ValueName | Change |
|---|---|---|
| Block JavaScript Execution | `bDisableJavaScript` | New - Both products. Blocks and locks JavaScript execution; prevents users from bypassing via privileged locations. Added to **Security Hardening** page as Recommended (Enabled). |
| Accept EULA for Updater | `EULA` | New - Both products. Accepts the EULA on behalf of the user so the built-in updater can download product updates. |

`bDisableJavaScript` was present in all v1.x ADMX versions but was inadvertently omitted when the v2.x series was generated from Adobe's lockable preference reference. The v1.3 ADMX had the enabledValue/disabledValue wired backwards (Enabled=0=allow); v2.13 corrects this to match the `bDisablePDFRedirectionActions` pattern (Enabled=1=block). `EULA` is a non-policy HKLM key under `AdobeViewer` that was present in v1.3 but dropped in v2.x; it has been re-added as an enterprise convenience for deployments that did not set `EULA_ACCEPT=YES` at install time.

---

## v2.12 - 13 April 2026

**Breaking change:** Corrected the GPO Enabled/Disabled toggle mapping for two Acrobat DC policies.

| Setting | ValueName | v2.11 (old) | v2.12 (new) |
|---|---|---|---|
| Block EMF to PDF Conversion | `BlockEMFParsing` | Enabled -> DWORD 0 (allow) | Enabled -> DWORD 1 (block) |
| Block XPS to PDF Conversion | `BlockXPSParsing` | Enabled -> DWORD 0 (allow) | Enabled -> DWORD 1 (block) |

In v2.11, setting these policies to **Enabled** wrote DWORD 0 (allow conversion), contradicting the "Block..." friendly name. v2.12 aligns the toggle so **Enabled = block** and **Disabled = allow**, matching both the policy name and Adobe's documented registry semantics.

**If you previously deployed these policies, verify and re-apply the intended state after upgrading.**

Also updated the ADML Explain text to include a GPO-oriented clarification for both policies.

Documentation: `bAcroSuppressUpsell` (Show Upgrade Prompts) scope corrected from Reader to Both on the **Reduce Nags** page - the Unified x64 installer reads Acrobat registry keys, so this setting must be configurable under Acrobat DC.

---

## v2.11 - 13 April 2026

Existing setting expanded to Acrobat DC, bringing the total to **258 policies** (142 Acrobat + 116 Reader).

| Setting | ValueName | Change |
|---|---|---|
| Hide Adobe Messages on Document Open | `bDontShowMsgWhenViewingDoc` | Expanded from Reader DC only to Both (Reader + Acrobat). The Unified x64 installer runs in Reader mode under Acrobat registry keys, so this setting must be configurable under the Acrobat DC path for Unified deployments. |

Also updated the **Reduce Nags** documentation page scope from Reader to Both.

Resolved **Known Issue** from v2.10: "`cIPM\bDontShowMsgWhenViewingDoc` evaluate adding an Acrobat DC entry" - now included.

---

## v2.10 - 13 April 2026

One new setting added for both products, bringing the total to **257 policies** (141 Acrobat + 116 Reader).

| Setting | ValueName | Change |
|---|---|---|
| Patch Cache Cleanup | `PatchCleanFlag` | New - Both products; sourced from [Adobe Employee response on Adobe Community (Feb 2026)](https://community.adobe.com/questions-9/we-have-a-few-computers-wtih-literally-hundreds-of-1gb-update-msi-files-downloading-constantly-1302886). Not listed on lockable.html or PrefRef. |

Also added to the **Reduce Nags** documentation page as a Recommended setting (Enabled).

---

## v2.9 - 11 April 2026

One new Acrobat-only setting added and one FriendlyName renamed, bringing the total to **255 policies** (140 Acrobat + 115 Reader).

| Setting | ValueName | Change |
|---|---|---|
| Reader mode on Acrobat (Unified x64) | `bIsSCReducedModeEnforcedEx` | New - Acrobat DC only; sourced from [Adobe enterprise KB](https://helpx.adobe.com/enterprise/kb/acrobat-64-bit-for-enterprises.html) |
| Generative AI Technology | `bEnableGentech` | FriendlyName renamed from "Enable Generative AI" |

[**MHimken**](https://www.reddit.com/user/MHimken/) flagged that the Windows ADMX is not required; the unused `<using namespace="Microsoft.Policies.Windows" prefix="windows"/>` line was removed from generated ADMX `policyNamespaces`.

---

## v2.8 - 10 April 2026

Three new settings added from Adobe's Application Security Guide, bringing the total to **254 policies** (139 Acrobat + 115 Reader).

| Setting | ValueName | Type | Category | Hardening |
|---|---|---|---|---|
| 3D Content in PDFs | `bEnable3D` | DWORD toggle | Security: Execution & Protection | Recommended - Disabled |
| Unlisted Attachment Type Permissions | `iUnlistedAttachmentTypePerm` | 4-value dropdown | Security: Execution & Protection | Recommended - Prompt without ability to allow |
| Built-in Attachment Permissions List | `tBuiltInPermList` | Text (pipe-separated list) | Security: Execution & Protection | Not on hardening page |

---

## v2.7 - 9 April 2026

One new setting added; five existing cloud connector settings moved from Reduce Nags to Security Hardening page as Recommended.

| Setting | ValueName | Change |
|---|---|---|
| OneDrive Connector | `bOneDriveConnectorEnabled` | New setting - Recommended Disabled on hardening page |
| Third-Party Cloud Connectors | `bToggleWebConnectors` | Moved to hardening page - Recommended Disabled |
| Box Cloud Connector | `bBoxConnectorEnabled` | Moved to hardening page - Recommended Disabled |
| Dropbox Cloud Connector | `bDropboxConnectorEnabled` | Moved to hardening page - Recommended Disabled |
| Google Drive Connector | `bGoogleDriveConnectorEnabled` | Moved to hardening page - Recommended Disabled |

Total: **248 policies** (136 Acrobat + 112 Reader).

---

## v2.5 - 8 April 2026

No new settings. Acrobat DC x86 policies added to `AdobeDC_x86.admx` (previously Reader-only). Total x64 policy count: **248**.

---

## v2.2 - 8 April 2026

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

## v2.1 - 7 April 2026

Initial release. **247 policies** (135 Acrobat + 112 Reader) covering 9 categories:

- Cloud & Connectors
- Context, Tools & Search
- Documents, Editing & Accessibility
- Security: Execution & Protection
- Security: Trust & Permissions
- Sharing & Features
- Startup & Experience
- Updates & Desktop Integration
- Upsell

**Sharing & responsibility** - Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.

---

## User history

## Combined v3.0 - 18 July 2026

Merged into the combined `AdobeDC.admx`/ADML bundle (see [Device history](#device-history)). User namespace `Adobe.Policies.Adobe_User` dropped; policies retain `(User)` suffix and `class="User"`.

---

## v1.10 - 1 Jul 2026

**501 policies** (258 Acrobat DC + 243 Reader DC) - same inventory as v1.9.

### `(User)` suffix on all leaf display names

Every policy ADML display string gains ` (User)` (e.g. `Show Splash Screen` -> `Show Splash Screen (User)`). Matches Microsoft convention for user-scope administrative templates. Helps IT admins tell user vs machine Adobe settings apart when both are in the same Intune profile - imported ADMX does not show hive or category path in the configuration list.

Same namespace, files, registry keys, and ADMX `name` attributes as v1.9. Validated Intune import after delete-and-reupload workflow.

See [readme in v1.10 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.10%20(User)/readme.md).

| ADMX File | Policies |
|---|---:|
| `AdobeDC_User.admx` + ADML | 501 |

---

## v1.9 - 30 Jun 2026

**501 policies** (258 Acrobat DC + 243 Reader DC) - unchanged from v1.8. **Superseded by v1.10** for new deployments.

### Category layout for Intune

Category folders restructured to **`Adobe (User)`** -> **`Acrobat DC`** / **`Reader DC`** (product branches no longer repeat `(User)`).

ADML strings are sanitized for Intune (no bare `http://` literals in policy text; empty explain strings get a fallback). Leaf display names have no scope suffix (use v1.10 for `(User)` on all settings).

See [readme in v1.9 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.9%20(User)/readme.md).

| ADMX File | Policies |
|---|---:|
| `AdobeDC_User.admx` + ADML | 501 |

---

## v1.8 - 30 Jun 2026

**501 policies** (258 Acrobat DC + 243 Reader DC). **Superseded by v1.10** for new deployments.

### PR #9 user-scope policy additions

**New DWORD toggles** under **Security: Trust & Permissions** (Acrobat + Reader):

| Setting | ValueName | Suggested hardening |
|---|---|---|
| Load Security Settings from Server (Adobe Certificates) | `bLoadSettingsFromURL` @ `cAdobeDownload` | Disabled |
| Load Security Settings from Server (European Certificates) | `bLoadSettingsFromURL` @ `cEUTLDownload` | Disabled |

**New text policy** - companion to existing **`iURLPerms`**:

| Setting | ValueName | Notes |
|---|---|---|
| Trusted/Blocked URL List | `tHostPerms` | REG_SZ text box; only applies when `iURLPerms` = Custom Setting (0) |

*Thanks to **[@virtitnerd](https://github.com/virtitnerd)** for [PR #9](https://github.com/systmworks/Adobe-DC-ADMX/pull/9) on the Computer ADMX repo.*

See [readme in v1.8 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.8%20(User)/readme.md).

| ADMX File | Policies |
|---|---:|
| `AdobeDC_User.admx` + ADML | 501 |

---

## v1.7 - 30 Jun 2026

**495 policies** (255 Acrobat DC + 240 Reader DC) - unchanged from v1.6.

### Policy class corrected to `User`

All user-scope policies now use `class="User"` instead of `class="Both"`. Earlier releases used `class="Both"` based on outdated Intune guidance; policies incorrectly appeared under **Computer Configuration** as well as User Configuration. v1.7 restricts them to **User Configuration** only, which is the correct scope for HKCU preference settings.

*Thanks to **[@virtitnerd](https://github.com/virtitnerd)** for identifying this during review of [PR #9](https://github.com/systmworks/Adobe-DC-ADMX/pull/9) on the Computer ADMX repo.*

See [readme in v1.7 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.7%20(User)/readme.md).

| ADMX File | Policies |
|---|---:|
| `AdobeDC_User.admx` + ADML | 495 |

---

## v1.6 - 28 Jun 2026

**495 policies** (255 Acrobat DC + 240 Reader DC), up from 484 in v1.5.

### HKCU attachment lockdown (Reader + Acrobat)

**New user policies** under **Security: Trust & Permissions** - complementary HKCU controls for PDF file attachment behaviour (not a substitute for HKLM `FeatureLockDown` lockdown):

| Setting | ValueName | Suggested hardening |
|---|---|---|
| Open Non-PDF Attachments | `bAllowOpenFile` | Disabled -> DWORD **0** |
| Secure Open Attachments | `bSecureOpenFile` | Enabled -> DWORD **1** |

*Thanks to **[@CyberChelonian](https://github.com/CyberChelonian)** for [issue #4](https://github.com/systmworks/Adobe-DC-ADMX/issues/4) on the Computer ADMX repo (mis-filed as HKCU; addressed here in the User ADMX line).*

Adobe PrefRef labels these as version 10.x; community verification on current DC - test in your environment before production rollout.

### Reader Outlook Protected View

**New Reader DC policy** under **Security: Execution & Protection**:

| Setting | ValueName | Notes |
|---|---|---|
| Outlook Protected View | `bEnableAlwaysOutlookAttachmentProtectedView` | New for **Reader DC**; Enabled -> DWORD **0** (Protected View on for Outlook attachments). Acrobat DC was already present from v1.4. |

*Thanks to **[@CyberChelonian](https://github.com/CyberChelonian)** for [issue #5](https://github.com/systmworks/Adobe-DC-ADMX/issues/5). Adobe documentation shows the Acrobat icon only; Reader path included per community request - verify Reader behaviour in your environment.*

### Microsoft Purview (MIP) - HKCU preferences only

**New category:** **Microsoft Purview (MIP)** - per-user `HKCU` preferences under `MicrosoftAIP` (not `FeatureLockDown` machine lockdown):

| Setting | ValueName |
|---|---|
| Show Document Message Bar (MIP) | `bShowDMB` |
| MIP Policy Authentication | `bEnablePolicyAuthentication` |
| MIP Logging | `bEnableLogging` |

*Thanks to **[@virtitnerd](https://github.com/virtitnerd)** for [issue #8](https://github.com/systmworks/Adobe-DC-ADMX/issues/8). This release covers the **HKCU `MicrosoftAIP`** slice of that request only. HKLM `FeatureLockDown` MIP lockdown policies (`bMIPLabelling`, `bMIPCheckPolicyOnDocSave`, `iMIPCloud`, `bMIPExternalAuthAdmin`, `bEnableDKEAdmin`, `bSilentAuth`) remain in scope for the **Computer ADMX** repo.*

See [readme in v1.6 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.6%20(User)/readme.md).

| ADMX File | Policies |
|---|---:|
| `AdobeDC_User.admx` + ADML | 495 |

---

## v1.5 - 28 Jun 2026

**No new policies** (484 unchanged). ADML generation fix: empty `presentationTable` omitted when there are no presentation entries, resolving Windows Server 2019 Group Policy Management Console import failures reported against v1.4.

*Thanks to **[@raschle](https://github.com/raschle)** for [PR #1](https://github.com/systmworks/Adobe-DC-User-ADMX/pull/1) identifying the WS2019 GPMC load failure.*

See [readme in v1.5 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.5%20(User)/readme.md).

---

## v1.4 - 7 May 2026

**No policy inventory change** (484 policies). Revision metadata aligned to **1.4** across ADMX, ADML, and `minRequiredRevision` for Group Policy and Intune consistency.

See [readme in v1.4 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.4%20(User)/readme.md).

**Sharing & responsibility** - Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
