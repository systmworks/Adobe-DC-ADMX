<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](../README.md)

# Changelog (Combined - Device + User)

Version history for the combined `AdobeDC.admx`/ADML template. Legacy per-scope changelogs are frozen in [changelog-device-retired.md](changelog-device-retired.md) and [changelog-user-retired.md](changelog-user-retired.md).

---

## v3.1 - 20 July 2026

**797 policies** (296 machine + 501 user) — policy count unchanged.

| Change | Detail |
|---|---|
| **Bug fix (Device)** | **Usage Measurement (legacy)** (`bUsageMeasurement`) — corrected inverted ADMX polarity. **Enabled** now writes DWORD **1** (telemetry on); **Disabled** writes DWORD **0** (telemetry off), matching Adobe PrefRef semantics and `GoodSetting="Set to Disabled"`. |
| **User scope** | No user-policy changes in this release. |
| **Import impact** | Same namespace and policy `name` attributes as v3.0 — **not** import-breaking. Intune bindings for this setting survive re-upload; verify/re-apply the intended Enabled/Disabled state because the registry value written for each GPO state is corrected. |

After re-uploading the v3.1 ADMX to Intune, re-check any policy using **Usage Measurement (legacy)**: previously **Disabled** incorrectly wrote **1** (telemetry ON); now **Disabled** writes **0** (OFF).

Historical ADMX/ADML files for this release: [GitHub Release v3.1](https://github.com/systmworks/Adobe-DC-ADMX/releases/tag/v3.1).

---

## Combined v3.0 - 18 July 2026

**797 policies** (296 machine + 501 user) in a single `AdobeDC.admx`/ADML pair.

| Change | Detail |
|---|---|
| Packaging | Single combined template (Machine + User) under namespace `Adobe.Policies.AdobeDC` |
| Tree | **Adobe DC** → **Acrobat & Reader DC** / **Reader DC (32-bit)** / **Non-Policy Settings** (Computer); **Acrobat DC** / **Reader DC** (User) |
| De-duplication | `HKLM\SOFTWARE\Policies` settings emit once per product hive (no redundant `WOW6432Node\Policies` copies) |
| Sources | Device v2.21 + User v1.10 |
| User merge | User namespace `Adobe.Policies.Adobe_User` dropped; policies retain `(User)` suffix and `class="User"` |

**Breaking change** when migrating from v2.x machine templates or separate User ADMX v1.x — see [ADMX install guide](../ADMX/readme.md).

---

**Sharing & responsibility** — Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
