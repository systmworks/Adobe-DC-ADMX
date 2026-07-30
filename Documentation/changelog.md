<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](../README.md)

# Changelog (Combined - Device + User)

Version history for the combined `AdobeDC.admx`/ADML template. Legacy per-scope changelogs are frozen in [changelog-retired.md](changelog-retired.md).

---

## v3.6 - 22 July 2026

**807 policies** (292 machine + 515 user) - quality and text fixes; 12 app-internal settings removed.

- Grammar and typo fixes in policy help text (no `ValueName` changes).
- Number defaults corrected: `iResponseFreshness`, `iMaxRevInfoArchiveSize` (1500 KB), `iMaxVerifySession` (5).
- Removed non-configurable settings: `bPreviouslyEnabledSharePointInChromeExtn`, `iAccessTextColor`, `iNoteOpacity`, `iDefaultZoomScale`, `iZoomScale`, `iDictionaryDefaultID`.
- Control type changed to numeric: `iRSAPSSSaltLength`, `iSize`.
- Documentation: curated guides and settings pages now mark **Non-Policy Settings** branch entries with a badge and legend (fixes GitHub issues #11 and #12). No ADMX change; no re-upload required for this documentation update.
- Documentation: expanded [Suppress Nags and Upsells](reduce-nags.md) with toolbar, panel, HUD, splash, welcome-screen, and onboarding settings for a cleaner reading view; added Attachment Extension Blocklist, Validate Signatures on Open, and Trust Certified Documents to [Security Hardening](security-hardening.md). Curated pages support optional per-setting notes. No ADMX change.

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
