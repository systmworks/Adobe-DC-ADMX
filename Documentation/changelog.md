<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](../README.md)

# Changelog (Combined - Device + User)

Version history for the combined `AdobeDC.admx`/ADML template. Legacy per-scope changelogs are frozen in [changelog-retired.md](changelog-retired.md).

---

## v4.2 - 8 September 2026

**828 policies** (310 machine + 518 user) - Disable Adobe Express Photos install.

- Added **Disable Adobe Express Photos Install** (`bDisableHarmonyInstallationFeature`) for Acrobat DC under Updates & Desktop Integration. Machine FeatureLockDown toggle: Enabled writes DWORD `1` (block install), Disabled writes DWORD `0` (Adobe default: allow install).
- Registry path: `HKLM\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown`. Acrobat Continuous track (Windows). Unified 64-bit Reader uses the Acrobat hive, so configure this under **Acrobat & Reader DC**, not Reader DC (32-bit).
- Adobe PrefRef documents the preference (default 0; 1 disables install on Acrobat launch). Adobe's June 2026 community announcement uses the same value as the opt-out for auto-update install of Adobe Express Photos. This policy does not uninstall an already-installed copy.
- Documentation: [Suppress Nags and Upsells](reduce-nags.md) lists this setting under Acrobat Only. Install guide Namespace table now matches the ADMX `revision`. Wiki includes [Browser Extension Settings](browser-extension.md) as a first-class wiki page.

*Thanks to **[@grimson73](https://github.com/grimson73)** for [Issue #16](https://github.com/systmworks/Adobe-DC-ADMX/issues/16).*

**Upgrade:** Re-upload ADMX + ADML. Additive only; all v4.1 bindings are preserved.

---

## v4.1 - 18 August 2026

**827 policies** (309 machine + 518 user) - Auto Document Open user preferences.

- Added three **User Configuration** policies under **Acrobat DC (User)** > Startup & Experience for the Auto Document Open feature: `bIsAutoDocOpenFeatureEnabled`, `bAutoOpenFromAllBrowsers`, and `bIsAutoDocOpenEnabledForEdge`.
- Registry path: `HKCU\Software\Adobe\Adobe Acrobat\DC\AutoDocOpen`. Covers Acrobat DC and Unified 64-bit Reader (Acrobat hive). Not FeatureLockDown; users may still change the preference in the UI.
- Adobe documents the UI in [Open PDFs automatically](https://helpx.adobe.com/acrobat/using/auto-open-pdfs.html); registry value names are from enterprise observation (Issue #15).

*Thanks to **[@nynsen](https://github.com/nynsen)** for [Issue #15](https://github.com/systmworks/Adobe-DC-ADMX/issues/15).*

**Upgrade:** Re-upload ADMX + ADML. Additive only; all v4.0 bindings are preserved.

---

## v4.0 - 9 August 2026

**824 policies** (309 machine + 515 user) - Browser Extensions leaf for Chrome and Edge.

- Added **Browser Extensions** computer branch with **Google Chrome** and **Microsoft Edge** sub-nodes (12 new machine policies).
- Six managed-storage settings from the Adobe Acrobat extension `schema.json` (Chrome 26.8.1.5 / Edge 26.7.1.0): `OpenHelpx`, `UsageMeasurement`, `UninstallPopup`, `DisableGenAI`, `DisableWhatsNewAutoOpen`, `DisableExpress`.
- New `StringToggle` control type writes REG_SZ `true`/`false` via ADMX `<string>` enabled/disabled values (per-row polarity: three settings harden with `false`, three with `true`).
- Registry paths: `HKLM\SOFTWARE\Policies\Google\Chrome\3rdparty\extensions\efaidnbmnnnibpcajpcglclefindmkaj\policy` and `HKLM\SOFTWARE\Policies\Microsoft\Edge\3rdparty\extensions\elhekieabhbkpmcefcoobjddigjcaadp\policy`.
- Documentation: new [Browser Extension Settings](browser-extension.md) page.

*Thanks to **[@virtitnerd](https://github.com/virtitnerd)** for proposing browser extension managed-storage coverage in [PR #9](https://github.com/systmworks/Adobe-DC-ADMX/pull/9).*

**Upgrade:** Re-upload ADMX + ADML. Additive only; all v3.9 bindings are preserved.

---

## v3.9 - 8 August 2026

**812 policies** (297 machine + 515 user) - Acrobat sign-in and federated login domain.

- Added **External Browser Sign-In** (`iAcroLoginType_Acrobat`) for Acrobat DC under Cloud and Connectors. Single-item enum writes iAcroLoginType = 5 for Azure AD Conditional Access workaround 1.
- Added **Legacy Sign-In Engine (HTTPS Calls)** (`iNGLCEFWorkflowEnabled_Acrobat`) for Acrobat DC under Cloud and Connectors. Single-item enum writes iNGLCEFWorkflowEnabled = 0 for Azure AD Conditional Access workaround 2.
- Added **Federated Login Domain** (`login_domain_Acrobat`) for Acrobat DC under Cloud and Connectors. Machine-scope text policy under HKLM\SOFTWARE\Policies\Adobe\NGL\AuthInfo.

*Thanks to **[@korzynski](https://github.com/korzynski)** for [PR #14](https://github.com/systmworks/Adobe-DC-ADMX/pull/14).*

- Documentation: new [Contributors](contributors.md) page.

**Upgrade:** Re-upload ADMX + ADML. Additive only; all v3.8 bindings are preserved.

---

## v3.8 - 4 August 2026

**809 policies** (294 machine + 515 user) - Reader promotional campaign messages.

- Added **Disable Promotional Campaign Messages** (`bToggleSophiaWebInfra_Reader`) for Reader DC under Upsell. Same scoping error class as v3.7 `iProtectedView`; Adobe documents both tracks and the explain text targets Reader's right-hand pane banner.
- Documentation: [Suppress Nags and Upsells](reduce-nags.md) lists this setting under Common to Acrobat & Reader.

**Upgrade:** Re-upload ADMX + ADML. Additive only; all v3.7 bindings are preserved.

---

## v3.7 - 4 August 2026

**808 policies** (293 machine + 515 user) - Reader Protected View; Product Updater explain text.

- Added **Protected View Mode** (`iProtectedView_Reader`) for Reader DC under Security: Execution & Protection (fixes GitHub issue #13). Previously Acrobat-only due to a source scoping error; Reader support is documented by Adobe from 11.0 and cited by STIG ARDC-CN-000020.
- Clarified **Product Updater** (`bUpdater`) explain text: for 12.x and later this setting overrides the ARM Legacy `Mode` preference, and setting to 0 also removes the updater UI.
- Documentation: [Security Hardening](security-hardening.md) lists Protected View Mode under Common to Acrobat & Reader.

*Thanks to **[@wauifsafis](https://github.com/wauifsafis)** for reporting issue #13.*

**Upgrade:** Re-upload ADMX + ADML. Additive only; all v3.6 bindings are preserved.

---

## v3.6 - 22 July 2026

**807 policies** (292 machine + 515 user) - quality and text fixes; 12 app-internal settings removed.

- Grammar and typo fixes in policy help text (no `ValueName` changes).
- Number defaults corrected: `iResponseFreshness`, `iMaxRevInfoArchiveSize` (1500 KB), `iMaxVerifySession` (5).
- Removed non-configurable settings: `bPreviouslyEnabledSharePointInChromeExtn`, `iAccessTextColor`, `iNoteOpacity`, `iDefaultZoomScale`, `iZoomScale`, `iDictionaryDefaultID`.
- Control type changed to numeric: `iRSAPSSSaltLength`, `iSize`.
- Documentation: curated guides and settings pages now mark **Non-Policy Settings** branch entries with a badge and legend (fixes GitHub issues #11 and #12). No ADMX change; no re-upload required for this documentation update.
- Documentation: expanded [Suppress Nags and Upsells](reduce-nags.md) with toolbar, panel, HUD, splash, welcome-screen, and onboarding settings for a cleaner reading view; added Attachment Extension Blocklist, Validate Signatures on Open, and Trust Certified Documents to [Security Hardening](security-hardening.md). Curated pages support optional per-setting notes. No ADMX change.

*Thanks to **[@robertRuncak](https://github.com/robertRuncak)** for issues #11 and #12.*

**Upgrade:** Re-upload ADMX + ADML. Removed entries need no re-selection; all other v3.5 bindings are preserved.

---

## v3.5 - 22 July 2026

**819 policies** (294 machine + 525 user) - text fixes and two control-type corrections.

- Fixed Product Updater (`bUpdater`) description text (was copied from cloud-services row). Other grammar and typo fixes in policy text.
- Control type changed: `tauthor` (Comment Author, User) Toggle -> Text; `iLogLevel` (Updater Log Level, Device) Toggle -> Enum (Brief / Verbose).
- Documentation: merged settings pages into combined [Adobe DC Settings (Device)](adobe-settings-device.md) and [Adobe DC Settings (User)](adobe-settings-user.md).

**Upgrade:** Re-select `tauthor` and `iLogLevel` in Intune/GPO after upgrade from v3.4.

---

## v3.4 - 20 July 2026

**819 policies** (294 machine + 525 user) - final control-type pass; additive-only from this release forward.

- Control type changed to enum: `iAccessColorPolicy`, `iPageLayout`.
- **Added** (User, Text policies): `tNoteFontName`, `tEditorFontName`, `tEditorPath`, `tEditorFontSize`, `tSignHash`, `aRSAPSSHashAlgorithm`, `tSAML_Name_Format`, `tSAML_Name_Qualifier`, `tDictionaryName`, `tBrokerLogfilePath`, `tLoadSettingsNAME`, `cReasons`, `tContactInfo`, `aDefDirectory`, `tFileFormat`, `tBaseFolderName`, `tLockboxId` (30 ADMX entries across Acrobat + Reader).

**Upgrade:** Re-select `iAccessColorPolicy`, `iPageLayout`, and the new text policies after re-upload.

---

## v3.3 - 20 July 2026

**789 policies** (294 machine + 495 user) - user text policies added; app-internal toggles removed.

- **Added** (User, Text): `tServerURL`, `xDefEnrollmentURL`, `tServer`, `tURL`, `tSAML_Assertion_Source`.
- Control type changed: `iMSStoreTrusted` enum -> numeric bitmask (0-255).
- Removed app-internal toggles: `iSens`, `iType`, `iAPIndex`, `iSHS`, `iSVS`, `iSendForReviewConfirm`, `iEULAAcceptanceTime`, `iAccessBackgroundColor`.
- Attachment permissions helper script added for `tBuiltInPermList` (REG_BINARY; not in ADMX).

**Upgrade:** Re-select affected User settings after re-upload.

Historical ADMX/ADML: [GitHub Release v3.3](https://github.com/systmworks/Adobe-DC-ADMX/releases/tag/v3.3).

---

## v3.2 - 20 July 2026

**795 policies** (294 machine + 501 user) - user control types corrected; attachment permissions removed from ADMX.

- **Removed** (Device): Built-in Attachment Permissions List (`tBuiltInPermList`) - Adobe stores this as REG_BINARY; ADMX cannot author it.
- **29** user settings reclassified from toggle to enum (e.g. `irightPaneState`, `iURLPerms`, `iRXOPolicy`).
- **11** user settings reclassified from toggle to numeric (e.g. `iMaxMRUCntToBeStored`, `iAutoSaveDocsInterval`, `iResponseFreshness`).

**Upgrade:** Re-select affected User settings after re-upload.

Historical ADMX/ADML: [GitHub Release v3.2](https://github.com/systmworks/Adobe-DC-ADMX/releases/tag/v3.2).

---

## v3.1 - 20 July 2026

**797 policies** (296 machine + 501 user) - one toggle polarity fix.

- **Fixed** (Device): Usage Measurement (`bUsageMeasurement`) - Enabled/Disabled now writes the correct registry value (was inverted).

**Upgrade:** Re-check Usage Measurement after re-upload; previously Disabled incorrectly enabled telemetry.

Historical ADMX/ADML: [GitHub Release v3.1](https://github.com/systmworks/Adobe-DC-ADMX/releases/tag/v3.1).

---

## Combined v3.0 - 18 July 2026

**797 policies** (296 machine + 501 user) - first combined Machine + User template.

- Single `AdobeDC.admx`/ADML under namespace `Adobe.Policies.AdobeDC`.
- Tree: **Adobe DC** -> **Acrobat & Reader DC** / **Reader DC (32-bit)** / **Non-Policy Settings** (Computer); **Acrobat DC** / **Reader DC** (User).
- Merged from Device v2.21 + User v1.10. User policies retain `(User)` suffix.

**Breaking change** when migrating from v2.x machine templates or separate User ADMX v1.x - see [ADMX install guide](../ADMX/readme.md).

---

**Sharing & responsibility** - Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
