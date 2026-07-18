<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

# AdobeDC ADMX v3.0 — Combined Machine + User

18 July 2026

**Current production release.** Supersedes the separate machine template (v2.21) and user template ([Adobe-DC-User-ADMX v1.10](https://github.com/systmworks/Adobe-DC-User-ADMX)) for new Group Policy and Intune deployments.

> [!WARNING]
> **Breaking change.** v3.0 uses a new combined namespace (`Adobe.Policies.AdobeDC`) and a re-organised policy tree. **Intune ADMX policy backups / exports taken against v2.x (or the separate User ADMX v1.x) will not import into v3.0** — the `definitionId` GUIDs and category paths no longer match. To migrate an existing v2.x export, run [`Import-Export-ADMX-Policies/Convert-AdobeDcIntuneExportToCombinedV30.ps1`](../Import-Export-ADMX-Policies/Convert-AdobeDcIntuneExportToCombinedV30.ps1) to convert it to the v3.0 layout before re-importing. See [Migrating from v2.21 + User v1.10](#migrating-from-v221--user-v110).

## What is new in v3.0

| Area | Change |
|------|--------|
| **Packaging** | Single `AdobeDC.admx`/ADML pair for **Computer + User** configuration under one namespace |
| **Policy inventory** | **797** policies — **296** machine + **501** user |
| **Namespace** | `Adobe.Policies.AdobeDC` (replaces separate `Adobe.Policies.Adobe_User` user namespace) |
| **Computer tree** | **Adobe DC** → **Acrobat & Reader DC** / **Reader DC (32-bit)** / **Non-Policy Settings** |
| **User tree** | **Adobe DC** → **Acrobat DC** / **Reader DC** — leaf display names retain ` (User)` suffix |
| **De-duplication** | `HKLM\SOFTWARE\Policies` settings emit once per product hive (no redundant `WOW6432Node\Policies` copies) |
| **Sources** | Device v2.21 + User v1.10 |

### Why v3.0?

This release continues the machine ADMX version line (v2.21 → **v3.0**) and merges in the user preference policies that previously shipped as a separate template. The version number avoids confusion with the retired v2.x machine-only templates and the separate User ADMX repo line (v1.x).

Previously, machine policies (`AdobeDC.admx`) and user preferences (`AdobeDC_User.admx`) lived in separate ADMX files and GitHub repos. v3.0 merges both into a single template so admins import one file, assign one Intune administrative template, and manage Computer Configuration and User Configuration from the same policy namespace.

User policies still use `class="User"` and appear under User Configuration only. Machine policies use `class="Machine"`. The `(User)` suffix on user-scope display names is unchanged — it helps distinguish scope when both appear in the same Intune profile.

### Migrating from v2.21 + User v1.10

Because v3.0 is a breaking change (see the warning above), existing Intune ADMX policy exports/backups cannot be re-imported as-is. Convert them first:

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
| `AdobeDC.admx` + `en-US/AdobeDC.adml` | Machine + User | 797 (296 machine + 501 user) |

Published policy reference tables: [Documentation](../README.md).

## Namespace

| Attribute | Value |
|-----------|-------|
| Prefix | `AdobeDC` |
| Namespace URI | `Adobe.Policies.AdobeDC` |
| ADMX / ADML `revision` | 3.0 |
| `minRequiredRevision` (`resources`) | 3.0 |

## Intune upload

1. **Remove** any existing ADMX entry for `Adobe.Policies.AdobeDC` and `Adobe.Policies.Adobe_User` before uploading — including failed or stuck imports.
2. Wait 2–5 minutes after deletion.
3. Upload `AdobeDC.admx` and `en-US/AdobeDC.adml` together.
4. Assign machine settings to a **device group**; assign user settings to a **user group** (or combine both in one profile — scope is determined by each policy's `class` attribute).

## Group Policy

Copy `AdobeDC.admx` to `%SystemRoot%\PolicyDefinitions` and `AdobeDC.adml` to `%SystemRoot%\PolicyDefinitions\en-US`, then run `gpupdate /force`. Machine policies appear under **Computer Configuration**; user policies under **User Configuration**.

Earlier release history: [Changelog (Device)](../Documentation/changelog-device.md) and [Changelog (User)](../Documentation/changelog-user.md).

---

**Sharing & responsibility** — Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
