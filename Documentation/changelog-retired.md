<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](../README.md)

# Changelog (Retired)

> **Retired.** Version history for combined releases is maintained in [Changelog (Combined)](changelog.md). This file is frozen for reference to pre-combined device-only and user-only releases.

Settings changes across ADMX versions. Only new, renamed, or reclassified settings are listed.

---

## Device history

## Combined v3.0 - 18 July 2026

**797 policies** (296 machine + 501 user) - first combined Machine + User template.

- Single `AdobeDC.admx`/ADML under namespace `Adobe.Policies.AdobeDC`.
- Merged from Device v2.21 + User v1.10.

---

## v2.21 - 1 July 2026

**Bug fix:** Restored five Reader-only settings missing from the Unified x64 branch after the v2.20 merge.

| Setting | ValueName | Category |
|---|---|---|
| Online Create PDF in Reader | `bEnableFrictionlessInChromeExtn` | Documents, Editing & Accessibility |
| Protected Mode Whitelist Config | `bUseWhitelistConfigFile` | Security: Execution & Protection |
| Prompt to Use Acrobat from Reader | `bEnableAcrobatPromptForDocOpen` | Updates & Desktop Integration |
| Prompt Reader Users to Download Acrobat | `bReaderRetentionExperiment` | Upsell |
| Show Purchasable Tools in Search | `bShowRhpToolSearch` | Upsell |

Policy count: **436** (was 431).

---

## v2.20 - 30 June 2026

**Structural release:** Single combined machine template with a flattened three-branch Group Policy tree.

- Tree: **Adobe (Machine)** -> **Acrobat & Reader DC (Unified x64)** -> **Acrobat DC (x86)** -> **Reader DC (x86)**.
- Unified x64 uses Acrobat HKLM hive for x64 Reader and Acrobat.
- **431** policies (was 552 in v2.19).

**Added (STIG gaps):**

| Setting | ValueName |
|---|---|
| Disable Acrobat.com File Storage | `bDisableADCFileStore` |
| Disable Welcome Screen | `bShowWelcomeScreen` |
| Usage Measurement (legacy) | `bUsageMeasurement` |

*Thanks to **[@virtitnerd](https://github.com/virtitnerd)** for community review (ARM path fix and STIG gap policies).*

---

## v2.19 - 28 June 2026

**Added (Reader + Acrobat):** Six Microsoft Purview (MIP) lockdown policies under `FeatureLockDown`.

*Thanks to **[@virtitnerd](https://github.com/virtitnerd)** for the original feature request.*

| Setting | ValueName |
|---|---|
| Enable MIP Labelling | `bMIPLabelling` |
| Check MIP Policy on Save | `bMIPCheckPolicyOnDocSave` |
| MIP Sovereign Cloud | `iMIPCloud` |
| MIP External Browser Auth | `bMIPExternalAuthAdmin` |
| MIP Double Key Encryption | `bEnableDKEAdmin` |
| Suppress OS Auth Prompts (MIP) | `bSilentAuth` |

Per-user HKCU policies (`bShowDMB`, `bEnablePolicyAuthentication`, `bEnableLogging`) ship in User ADMX v1.6 only.

---

## v2.18 - 20 May 2026

**Added (Reader + Acrobat):** Block non-PDF file attachments (`iFileAttachmentPerms`, DWORD 1 under `FeatureLockDown`), per DISA STIG.

*Thanks to **CyberChelonian** for flagging this setting.*

| Setting | ValueName |
|---|---|
| Block non-PDF file attachments | `iFileAttachmentPerms` |

---

## v2.17 - 19 May 2026

**Added (Acrobat DC):** Protected Mode and AppContainer sandbox settings (previously Reader-only).

*Thanks to **CyberChelonian** for flagging the need for Acrobat DC coverage.*

| Setting | ValueName |
|---|---|
| Protected Mode Sandbox | `bProtectedMode` |
| AppContainer Sandbox | `bEnableProtectedModeAppContainer` |

---

## v2.16 - 28 April 2026

**No settings changes** - ADMX/ADML metadata only (`revision`/`minRequiredRevision` alignment).

---

## v2.15 - 16 April 2026

**Breaking change:** Corrected Enabled/Disabled toggle mapping for three policies.

| Setting | ValueName | Fix |
|---|---|---|
| Block JavaScript Execution | `bDisableJavaScript` | Enabled now blocks (DWORD 1) |
| Disable SharePoint & Office 365 Integration | `bDisableSharePointFeatures` | Enabled now disables (DWORD 1) |
| Disable WebMail Integration | `bDisableWebmail` | Enabled now disables (DWORD 1) |

**FriendlyName corrections:** `bDisableSharePointFeatures`, `bDisableWebmail` - names now match admin intent.

**Summary text:** Four policies reworded for neutral, descriptive text (`bToggleAdobeDocumentServices`, `bTogglePrefsSync`, `bUpdater`, `bToggleAdobeSign`).

**Added to Security Hardening page:** 10 new entries. **Reduce Nags page:** 2 new entries.

**Upgrade:** Verify and re-apply intended state for the three toggle fixes above.

---

## v2.13 - 14 April 2026

**Added (Both products):**

| Setting | ValueName |
|---|---|
| Block JavaScript Execution | `bDisableJavaScript` |
| Accept EULA for Updater | `EULA` |

`bDisableJavaScript` was present in v1.x but omitted in v2.x generation; v2.13 restores it with correct toggle polarity.

---

## v2.12 - 13 April 2026

**Breaking change:** Corrected toggle mapping for two Acrobat DC policies.

| Setting | ValueName | Fix |
|---|---|---|
| Block EMF to PDF Conversion | `BlockEMFParsing` | Enabled now blocks (DWORD 1) |
| Block XPS to PDF Conversion | `BlockXPSParsing` | Enabled now blocks (DWORD 1) |

**Upgrade:** Verify and re-apply intended state after upgrading.

---

## v2.11 - 13 April 2026

**Expanded to Acrobat DC:**

| Setting | ValueName | Change |
|---|---|---|
| Hide Adobe Messages on Document Open | `bDontShowMsgWhenViewingDoc` | Reader-only -> Both |

---

## v2.10 - 13 April 2026

**Added (Both products):**

| Setting | ValueName |
|---|---|
| Patch Cache Cleanup | `PatchCleanFlag` |

---

## v2.9 - 11 April 2026

**Added (Acrobat only):**

| Setting | ValueName |
|---|---|
| Reader mode on Acrobat (Unified x64) | `bIsSCReducedModeEnforcedEx` |

**Renamed:** Generative AI Technology (`bEnableGentech`) - FriendlyName was "Enable Generative AI".

*Thanks to **[@MHimken](https://www.reddit.com/user/MHimken/)** for flagging unused Windows ADMX namespace reference.*

---

## v2.8 - 10 April 2026

**Added (Both products):**

| Setting | ValueName | Category |
|---|---|---|
| 3D Content in PDFs | `bEnable3D` | Security: Execution & Protection |
| Unlisted Attachment Type Permissions | `iUnlistedAttachmentTypePerm` | Security: Execution & Protection |
| Built-in Attachment Permissions List | `tBuiltInPermList` | Security: Execution & Protection |

---

## v2.7 - 9 April 2026

**Added:**

| Setting | ValueName |
|---|---|
| OneDrive Connector | `bOneDriveConnectorEnabled` |

**Moved to Security Hardening page (Recommended Disabled):** `bToggleWebConnectors`, `bBoxConnectorEnabled`, `bDropboxConnectorEnabled`, `bGoogleDriveConnectorEnabled`.

---

## v2.5 - 8 April 2026

No new settings. Acrobat DC x86 policies added to `AdobeDC_x86.admx` (previously Reader-only).

---

## v2.2 - 8 April 2026

No new settings. **15** FriendlyNames corrected (double-negative logic); **6** clarified for consistency. Registry values unchanged.

---

## v2.1 - 7 April 2026

Initial release. **247 policies** (135 Acrobat + 112 Reader) covering 9 categories.

---

## User history

## Combined v3.0 - 18 July 2026

Merged into the combined `AdobeDC.admx`/ADML bundle (see [Device history](#device-history)). User namespace `Adobe.Policies.Adobe_User` dropped; policies retain `(User)` suffix.

---

## v1.10 - 1 Jul 2026

**501 policies** - same inventory as v1.9.

- Every policy display name gains ` (User)` suffix (e.g. `Show Splash Screen` -> `Show Splash Screen (User)`).

---

## v1.9 - 30 Jun 2026

**501 policies** - unchanged from v1.8.

- Category layout restructured to **Adobe (User)** -> **Acrobat DC** / **Reader DC**.

---

## v1.8 - 30 Jun 2026

**501 policies** - PR #9 user-scope additions.

**Added (Acrobat + Reader, Security: Trust & Permissions):**

| Setting | ValueName |
|---|---|
| Load Security Settings from Server (Adobe Certificates) | `bLoadSettingsFromURL` @ `cAdobeDownload` |
| Load Security Settings from Server (European Certificates) | `bLoadSettingsFromURL` @ `cEUTLDownload` |
| Trusted/Blocked URL List | `tHostPerms` |

*Thanks to **[@virtitnerd](https://github.com/virtitnerd)** for [PR #9](https://github.com/systmworks/Adobe-DC-ADMX/pull/9).*

---

## v1.7 - 30 Jun 2026

**495 policies** - unchanged from v1.6.

- All user-scope policies now use `class="User"` instead of `class="Both"` (correct scope for HKCU settings).

*Thanks to **[@virtitnerd](https://github.com/virtitnerd)** for identifying this during PR #9 review.*

---

## v1.6 - 28 Jun 2026

**495 policies** (up from 484 in v1.5).

**Added (Security: Trust & Permissions):**

| Setting | ValueName |
|---|---|
| Open Non-PDF Attachments | `bAllowOpenFile` |
| Secure Open Attachments | `bSecureOpenFile` |
| Outlook Protected View (Reader) | `bEnableAlwaysOutlookAttachmentProtectedView` |

**Added (Microsoft Purview MIP category):**

| Setting | ValueName |
|---|---|
| Show Document Message Bar (MIP) | `bShowDMB` |
| MIP Policy Authentication | `bEnablePolicyAuthentication` |
| MIP Logging | `bEnableLogging` |

*Thanks to **[@CyberChelonian](https://github.com/CyberChelonian)** for issues #4 and #5, and **[@virtitnerd](https://github.com/virtitnerd)** for issue #8.*

---

## v1.5 - 28 Jun 2026

**No new policies** (484 unchanged). ADML generation fix for Windows Server 2019 GPMC import failures.

*Thanks to **[@raschle](https://github.com/raschle)** for [PR #1](https://github.com/systmworks/Adobe-DC-User-ADMX/pull/1).*

---

## v1.4 - 7 May 2026

**No policy inventory change** (484 policies). Revision metadata aligned to 1.4.

**Sharing & responsibility** - Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
