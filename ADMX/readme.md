<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

# AdobeDC ADMX - Combined Machine + User

**Current version: v4.2** (8 September 2026). Full version history: [Changelog (Combined)](../Documentation/changelog.md).

**Current production release.** Supersedes the separate machine template (v2.21) and user template ([Adobe-DC-User-ADMX v1.10](https://github.com/systmworks/Adobe-DC-User-ADMX)) for new Group Policy and Intune deployments.

> [!NOTE]
> **Upgrading to v4.2 from combined v3.4+:** Delete the existing Intune ADMX import, wait 2-5 minutes, then re-upload `AdobeDC.admx` + ADML. Namespace and policy `name` attributes are unchanged; existing bindings are preserved. v4.2 adds **Disable Adobe Express Photos Install** (`bDisableHarmonyInstallationFeature`) under Acrobat & Reader DC. See [v4.2 changelog](../Documentation/changelog.md#v42---8-september-2026).

> [!NOTE]
> **Upgrading to v4.0 from combined v3.4+:** Delete the existing Intune ADMX import, wait 2-5 minutes, then re-upload `AdobeDC.admx` + ADML. Namespace and policy `name` attributes are unchanged; existing bindings are preserved. v4.0 adds **12** browser extension policies under **Browser Extensions** (6 Chrome + 6 Edge). See [v4.0 changelog](../Documentation/changelog.md#v40---9-august-2026).

> [!IMPORTANT]
> **Stable upgrade path (v3.4+).** Releases are **additive-only** except where a changelog entry documents a one-time control-type correction. The frozen policy set is in `Documentation/data/policy-baseline.json`.

> [!WARNING]
> **Migrating from v2.x or separate User ADMX v1.x:** Combined v3.0+ uses namespace `Adobe.Policies.AdobeDC` and a re-organised policy tree. v2.x Intune exports will not import without conversion. See [Migrating from v2.21 + User v1.10](#migrating-from-v221--user-v110).

> [!NOTE]
> **Upgrading from combined v3.0-v3.3:** One-time re-selection or control-type changes may apply. Read the matching [Changelog](../Documentation/changelog.md) entry for your current version before re-uploading.

## What is in the combined template

| Area | Detail |
|------|--------|
| **Packaging** | Single `AdobeDC.admx`/ADML pair for **Computer + User** configuration under one namespace |
| **Policy inventory** | **<!--COUNT:total-->828<!--/COUNT:total-->** policies - **<!--COUNT:machine-->310<!--/COUNT:machine-->** machine + **<!--COUNT:user-->518<!--/COUNT:user-->** user (ADMX `<policy>` entries; see note below) |
| **Namespace** | `Adobe.Policies.AdobeDC` (replaces separate `Adobe.Policies.Adobe_User` user namespace) |
| **Computer tree** | **Adobe DC** -> **Acrobat & Reader DC** / **Reader DC (32-bit)** / **Non-Policy Settings** / **Browser Extensions** |
| **User tree** | **Adobe DC** -> **Acrobat DC** / **Reader DC** - leaf display names retain ` (User)` suffix |
| **De-duplication** | `HKLM\SOFTWARE\Policies` settings emit once per product hive (no redundant `WOW6432Node\Policies` copies) |
| **Sources** | Device v2.21 + User v1.10 |

**Policy count note:** **<!--COUNT:total-->828<!--/COUNT:total-->** is the number of configurable policy entries in the ADMX (what Intune and GPMC show). **<!--COUNT:machine-->310<!--/COUNT:machine-->** machine includes **12** browser extension entries (6 Chrome + 6 Edge) plus architecture-specific non-policy settings emitted separately for x64 and x86. There are **<!--COUNT:machineUnique-->158<!--/COUNT:machineUnique-->** unique Adobe machine settings in the source reference (<!--COUNT:machineShared-->118<!--/COUNT:machineShared--> apply to both Reader and Acrobat; `tBuiltInPermList` is excluded as REG_BINARY), plus **6** unique browser extension settings (12 ADMX entries). Product-scoped tables in [Documentation](../README.md) list user and machine settings because shared settings appear under each product. Browser extension settings are documented separately in [Browser Extension Settings](../Documentation/browser-extension.md).

### Non-Policy Settings branch

Some machine settings write to native Adobe registry paths outside `HKLM\SOFTWARE\Policies`. They appear under **Adobe DC > Non-Policy Settings** in Group Policy or Intune, with architecture-specific sub-nodes:

| Sub-node | Applies to |
|----------|------------|
| **Acrobat & Reader DC (64-bit)** | 64-bit Acrobat and unified 64-bit Reader |
| **Acrobat DC (32-bit)** | 32-bit Acrobat (includes Adobe ARM updater prefs) |
| **Reader DC (32-bit)** | Legacy 32-bit Reader |

Examples include **Block EMF to PDF Conversion**, **Disable Repair for All Users**, and **Disable Major Version Upgrade Prompt**. Curated guides mark these with a **Non-Policy** badge and list the exact tree path. No ADMX re-upload is required when documentation is updated.

### Browser Extensions branch

Six managed-storage settings for the Adobe Acrobat browser extension are available under **Adobe DC > Browser Extensions**, with separate sub-nodes for **Google Chrome** and **Microsoft Edge**. These write to each browser's 3rdparty extension policy path (not under `Software\Policies\Adobe\...`). Values are **REG_SZ** strings (`true`/`false`), not DWORD. No additional Intune ADMX slot is consumed - they ship inside this template.

See [Browser Extension Settings](../Documentation/browser-extension.md) for registry keys, Enabled/Disabled values, and the Edge Chrome Web Store extension ID caveat.

### Built-in Attachment Permissions List (`tBuiltInPermList`)

This is the **only** REG_BINARY setting in the template. ADMX/ADML has **no binary element type**, so it cannot be authored via Group Policy or Intune ADMX upload. Combined v3.1 incorrectly used a text box (REG_SZ); v3.2 removed the policy.

Deploy the attachment allow/block list using [`Helper_Scripts/Set-AdobeBuiltInPermList.ps1`](../Helper_Scripts/Set-AdobeBuiltInPermList.ps1) (**`-ImportHex`** from `-ExportHex` is the trusted path; `-PermList` is best-effort), Group Policy Preferences registry items, or Intune custom OMA-URI with bytes captured from Acrobat Trust Manager.

### Migrating from v2.21 + User v1.10

Because the initial combined release (v3.0) is a breaking change (see the warning above), existing Intune ADMX policy exports/backups cannot be re-imported as-is. Convert them first:

| Step | Action |
|------|--------|
| 1 | Convert any v2.x Intune export/backup JSON with [`Helper_Scripts/Convert-AdobeDcIntuneExportToCombinedV3.ps1`](../Helper_Scripts/Convert-AdobeDcIntuneExportToCombinedV3.ps1) - it remaps category paths, de-duplicates redundant Policies-branch entries, and clears stale `definitionId` GUIDs (outputs `*_combined-v3.json`) |
| 2 | Remove existing `Adobe.Policies.AdobeDC` **and** `Adobe.Policies.Adobe_User` ADMX imports from Intune (wait 2-5 minutes after deletion) |
| 3 | Upload `AdobeDC.admx` and `en-US/AdobeDC.adml` from this folder |
| 4 | Import the converted `*_combined-v3.json` and re-bind / re-assign the policy settings |

If you migrated Intune exports from v2.19, Reader-only x64 upsell settings already map to Unified x64 - they will bind after uploading this ADMX.

## Files

| File | Scope | Policies |
|------|-------|----------|
| `AdobeDC.admx` + `en-US/AdobeDC.adml` | Machine + User | <!--COUNT:total-->828<!--/COUNT:total--> (<!--COUNT:machine-->310<!--/COUNT:machine--> machine + <!--COUNT:user-->518<!--/COUNT:user--> user) |

*<!--COUNT:machine-->310<!--/COUNT:machine--> machine = ADMX policy entries; <!--COUNT:machineUnique-->158<!--/COUNT:machineUnique--> unique machine settings; product-scoped reference tables total <!--COUNT:readerDevice-->125<!--/COUNT:readerDevice--> Reader + <!--COUNT:acrobatDevice-->173<!--/COUNT:acrobatDevice--> Acrobat.*

Published policy reference tables: [Documentation](../README.md).

## Namespace

| Attribute | Value |
|-----------|-------|
| Prefix | `AdobeDC` |
| Namespace URI | `Adobe.Policies.AdobeDC` |
| ADMX / ADML `revision` | 4.2 |
| `minRequiredRevision` (`resources`) | 4.2 |

## Intune upload

1. **Remove** any existing ADMX entry for `Adobe.Policies.AdobeDC` and `Adobe.Policies.Adobe_User` before uploading - including failed or stuck imports.
2. Wait 2-5 minutes after deletion.
3. Upload `AdobeDC.admx` and `en-US/AdobeDC.adml` together.
4. Assign machine settings to a **device group**; assign user settings to a **user group** (or combine both in one profile - scope is determined by each policy's `class` attribute).
5. If upgrading from an older combined release, check the [Changelog](../Documentation/changelog.md) for your version - v3.0-v3.3 may require one-time re-selection; v3.4+ is additive-only unless the entry says otherwise.

## Group Policy

Copy `AdobeDC.admx` to `%SystemRoot%\PolicyDefinitions` and `AdobeDC.adml` to `%SystemRoot%\PolicyDefinitions\en-US`, then run `gpupdate /force`. Machine policies appear under **Computer Configuration**; user policies under **User Configuration**.

Earlier release history: [Changelog (Combined)](../Documentation/changelog.md) - legacy per-scope log [Retired](../Documentation/changelog-retired.md).

---

**Sharing & responsibility** - Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
