<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

# AdobeDC ADMX — Combined Machine + User

**Current version: v3.2** (20 July 2026). Full version history: [Changelog (Combined)](../Documentation/changelog.md).

**Current production release.** Supersedes the separate machine template (v2.21) and user template ([Adobe-DC-User-ADMX v1.10](https://github.com/systmworks/Adobe-DC-User-ADMX)) for new Group Policy and Intune deployments.

> [!WARNING]
> **Breaking change when migrating from v2.x or User ADMX v1.x.** Combined v3.0+ uses namespace `Adobe.Policies.AdobeDC` and a re-organised policy tree. **Intune ADMX policy backups / exports taken against v2.x (or the separate User ADMX v1.x) will not import** — the `definitionId` GUIDs and category paths no longer match. To migrate an existing v2.x export, run [`Import-Export-ADMX-Policies/Convert-AdobeDcIntuneExportToCombinedV30.ps1`](../Import-Export-ADMX-Policies/Convert-AdobeDcIntuneExportToCombinedV30.ps1) to convert it to the combined layout before re-importing. See [Migrating from v2.21 + User v1.10](#migrating-from-v221--user-v110).

> [!NOTE]
> **Upgrading from combined v3.1 to v3.2** keeps the same namespace and policy `name` attributes. Re-upload `AdobeDC.admx` + ADML. **40 user-scope policies** change from toggles to enum dropdowns or numeric spinners — re-select those settings in Intune/GPO after re-upload. **Built-in Attachment Permissions List** (`tBuiltInPermList`) is **removed** (REG_BINARY; ADMX cannot author it). See [v3.2 changelog](../Documentation/changelog.md#v32---20-july-2026).

> [!NOTE]
> **Upgrading from combined v3.0 to v3.1** is not import-breaking (same namespace and policy `name` attributes). Re-upload `AdobeDC.admx` + ADML. The v3.1 release corrects **Usage Measurement (legacy)** (`bUsageMeasurement`) polarity — see [v3.1 changelog](../Documentation/changelog.md#v31---20-july-2026).

## What is in the combined template

| Area | Detail |
|------|--------|
| **Packaging** | Single `AdobeDC.admx`/ADML pair for **Computer + User** configuration under one namespace |
| **Policy inventory** | **795** policies — **294** machine + **501** user (ADMX `<policy>` entries; see note below) |
| **Namespace** | `Adobe.Policies.AdobeDC` (replaces separate `Adobe.Policies.Adobe_User` user namespace) |
| **Computer tree** | **Adobe DC** → **Acrobat & Reader DC** / **Reader DC (32-bit)** / **Non-Policy Settings** |
| **User tree** | **Adobe DC** → **Acrobat DC** / **Reader DC** — leaf display names retain ` (User)` suffix |
| **De-duplication** | `HKLM\SOFTWARE\Policies` settings emit once per product hive (no redundant `WOW6432Node\Policies` copies) |
| **Sources** | Device v2.21 + User v1.10 |

**Policy count note:** **795** is the number of configurable policy entries in the ADMX (what Intune and GPMC show). **294** machine includes architecture-specific non-policy settings emitted separately for x64 and x86. There are **157** unique machine settings in the source reference (123 apply to both Reader and Acrobat; `tBuiltInPermList` is excluded as REG_BINARY). Product-scoped tables in [Documentation](../README.md) list **128** Reader + **153** Acrobat machine settings because shared settings appear under each product.

### Migrating from v2.21 + User v1.10

Because the initial combined release (v3.0) is a breaking change (see the warning above), existing Intune ADMX policy exports/backups cannot be re-imported as-is. Convert them first:

| Step | Action |
|------|--------|
| 1 | Convert any v2.x Intune export/backup JSON with [`Import-Export-ADMX-Policies/Convert-AdobeDcIntuneExportToCombinedV30.ps1`](../Import-Export-ADMX-Policies/Convert-AdobeDcIntuneExportToCombinedV30.ps1) — it remaps category paths, de-duplicates redundant Policies-branch entries, and clears stale `definitionId` GUIDs (outputs `*_combined-v3.0.json`) |
| 2 | Remove existing `Adobe.Policies.AdobeDC` **and** `Adobe.Policies.Adobe_User` ADMX imports from Intune (wait 2–5 minutes after deletion) |
| 3 | Upload `AdobeDC.admx` and `en-US/AdobeDC.adml` from this folder |
| 4 | Import the converted `*_combined-v3.0.json` and re-bind / re-assign the policy settings |

If you migrated Intune exports from v2.19, Reader-only x64 upsell settings already map to Unified x64 — they will bind after uploading this ADMX.

## Files

| File | Scope | Policies |
|------|-------|----------|
| `AdobeDC.admx` + `en-US/AdobeDC.adml` | Machine + User | 795 (294 machine + 501 user) |

*294 machine = ADMX policy entries; 157 unique machine settings; product-scoped reference tables total 128 Reader + 153 Acrobat.*

Published policy reference tables: [Documentation](../README.md).

## Namespace

| Attribute | Value |
|-----------|-------|
| Prefix | `AdobeDC` |
| Namespace URI | `Adobe.Policies.AdobeDC` |
| ADMX / ADML `revision` | 3.2 |
| `minRequiredRevision` (`resources`) | 3.2 |

## Intune upload

1. **Remove** any existing ADMX entry for `Adobe.Policies.AdobeDC` and `Adobe.Policies.Adobe_User` before uploading — including failed or stuck imports.
2. Wait 2–5 minutes after deletion.
3. Upload `AdobeDC.admx` and `en-US/AdobeDC.adml` together.
4. Assign machine settings to a **device group**; assign user settings to a **user group** (or combine both in one profile — scope is determined by each policy's `class` attribute).
5. After upgrading to v3.2, re-select **User** policies that changed from toggles to enum/numeric controls (see [v3.2 changelog](../Documentation/changelog.md#v32---20-july-2026)). After upgrading from v3.0 to v3.1, re-verify **Usage Measurement (legacy)** if configured — **Disabled** now correctly writes telemetry **off** (DWORD 0).

## Group Policy

Copy `AdobeDC.admx` to `%SystemRoot%\PolicyDefinitions` and `AdobeDC.adml` to `%SystemRoot%\PolicyDefinitions\en-US`, then run `gpupdate /force`. Machine policies appear under **Computer Configuration**; user policies under **User Configuration**.

Earlier release history: [Changelog (Combined)](../Documentation/changelog.md) · legacy per-scope logs [Device](../Documentation/changelog-device-retired.md) · [User](../Documentation/changelog-user-retired.md).

---

**Sharing & responsibility** — Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
