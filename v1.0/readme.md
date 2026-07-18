<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

# AdobeDC ADMX v1.0 — Combined Machine + User

18 July 2026

**Current production release.** Supersedes the separate machine template (v2.21) and user template ([Adobe-DC-User-ADMX v1.10](https://github.com/systmworks/Adobe-DC-User-ADMX)) for new Group Policy and Intune deployments.

## What is new in v1.0

| Area | Change |
|------|--------|
| **Packaging** | Single `AdobeDC.admx`/ADML pair for **Computer + User** configuration under one namespace |
| **Policy inventory** | **797** policies — **296** machine + **501** user |
| **Namespace** | `Adobe.Policies.AdobeDC` (replaces separate `Adobe.Policies.Adobe_User` user namespace) |
| **Computer tree** | **Adobe DC** → **Acrobat & Reader DC** / **Reader DC (32-bit)** / **Non-Policy Settings** |
| **User tree** | **Adobe DC** → **Acrobat DC** / **Reader DC** — leaf display names retain ` (User)` suffix |
| **De-duplication** | `HKLM\SOFTWARE\Policies` settings emit once per product hive (no redundant `WOW6432Node\Policies` copies) |
| **Sources** | Device v2.21 + User v1.10 |

### Why combine?

Previously, machine policies (`AdobeDC.admx`) and user preferences (`AdobeDC_User.admx`) lived in separate ADMX files and GitHub repos. v1.0 merges both into a single template so admins import one file, assign one Intune administrative template, and manage Computer Configuration and User Configuration from the same policy namespace.

User policies still use `class="User"` and appear under User Configuration only. Machine policies use `class="Machine"`. The `(User)` suffix on user-scope display names is unchanged — it helps distinguish scope when both appear in the same Intune profile.

### Migrating from v2.21 + User v1.10

| Step | Action |
|------|--------|
| 1 | Remove existing `Adobe.Policies.AdobeDC` **and** `Adobe.Policies.Adobe_User` ADMX imports from Intune (wait 2–5 minutes after deletion) |
| 2 | Upload `AdobeDC.admx` and `en-US/AdobeDC.adml` from this folder |
| 3 | Re-bind policy settings — `definitionId` GUIDs from old exports will not match the combined template |
| 4 | For Intune export migration, see converted JSON examples in the repo wiki or use the migration tooling described in [Changelog (Device)](../Documentation/changelog-device.md) |

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
| ADMX / ADML `revision` | 1.0 |
| `minRequiredRevision` (`resources`) | 1.0 |

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
