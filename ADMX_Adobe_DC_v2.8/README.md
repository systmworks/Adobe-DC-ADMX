# v2.8 — Adobe DC ADMX/ADML for Intune

Generated April 2026 from `2026-4-8-Adobe_Lockable_PrefRef_v1.csv`.

## Files

| File | Scope | Policies |
|------|-------|----------|
| `AdobeDC_x64.admx` + `en-US/AdobeDC_x64.adml` | Acrobat DC (x64) + Reader DC (x64) | 254 (139 Acrobat + 115 Reader) |
| `AdobeDC_x86.admx` + `en-US/AdobeDC_x86.adml` | Acrobat DC (x86) + Reader DC (x86) | 254 (139 Acrobat + 115 Reader) |

## Changes from v2.7

### New settings: Attachment security and 3D content (+6 policies)

Three new settings added from Adobe's Application Security Guide (AppSec), each generating policies for both Acrobat and Reader:

- **`bEnable3D`** — "3D Content in PDFs" (DWORD toggle). Controls whether 3D content is rendered in PDFs. Sourced from Adobe PrefRef `3D.html` and AppSec `external.html`.
- **`iUnlistedAttachmentTypePerm`** — "Unlisted Attachment Type Permissions" (4-value dropdown). Controls the default behaviour for file types not in the built-in or user-specified attachment lists. Sourced from PrefRef `Attachments.html` and AppSec `attachments.html`.
- **`tBuiltInPermList`** — "Built-in Attachment Permissions List" (text box). Pipe-separated list of file extensions with permission levels controlling which attachment types can be opened or saved. Sourced from AppSec `attachments.html`. Note: Adobe stores this as REG_BINARY; the ADMX text element writes REG_SZ which may require the admin to verify application compatibility.

### Security hardening — new Recommended entries

The following were added to the Security Hardening page as **Recommended**:

- `bEnable3D` = **Disabled** (value 0) — Disabling 3D content reduces attack surface, similar to the existing `bEnableFlash` recommendation.
- `iUnlistedAttachmentTypePerm` = **Enabled — Prompt without ability to allow** (value 0) — Prevents users from permanently whitelisting unknown attachment types.

`tBuiltInPermList` is intentionally excluded from hardening recommendations. The built-in default already blocks ~100 dangerous extensions, and deploying a custom list via policy freezes it at a point-in-time snapshot, preventing Adobe from updating it with future product releases.

### Build script enhancements

- `Get-EnumSpec` now handles `iUnlistedAttachmentTypePerm` with a 4-option dropdown.
- New `Get-TextSpec` function supports text-element policies (used by `tBuiltInPermList`).
- `Write-PolicyXml` extended with a third code path for text elements alongside the existing enum and DWORD toggle paths.

### Revision metadata

- ADMX/ADML `revision` is **2.8**; descriptions reference v2.8.
- Policy namespace prefixes (`Adobe_x64`, `Adobe_x86`) and namespace URIs (`Adobe.Policies.Adobe_x64`, `Adobe.Policies.Adobe_x86`) are unchanged, so Intune upgrades are compatible.

## Known Issues

- The `bToggle*` family uses inverted registry values (0=feature ON, 1=feature OFF). FriendlyNames from v2.2 still apply; raw registry checks may look counterintuitive.
- ARM Legacy settings (**Check**, **Mode**) remain excluded due to unresolvable `(product name)\(product code)` placeholders.
- All x86 paths (both Reader and Acrobat) are derived by inserting `WOW6432Node\` into the native registry path.
- `tBuiltInPermList` is stored by Adobe as REG_BINARY but the ADMX text element writes REG_SZ. Admins may need to verify compatibility or deploy via registry script if the application requires the binary type.

## Builder Scripts

Located in `tools/`:

| Script | Purpose |
|--------|---------|
| `Build-AdobeX64AdmxFromLockableCsv.ps1` | Generates `AdobeDC_x64.admx` + ADML (default output `v2.8/`) |
| `Build-AdobeX86AdmxFromLockableCsv.ps1` | Generates `AdobeDC_x86.admx` + ADML (default output `v2.8/`) |
| `Validate-X64AdmxAdml.ps1` | Cross-validates x64 ADMX/ADML |
| `Validate-X86AdmxAdml.ps1` | Cross-validates x86 ADMX/ADML |
| `Build-DocumentationFromLockableCsv.ps1` | Regenerates `Documentation/*.md` (defaults to `-Version 2.8`) |

### Rebuilding

```powershell
cd tools
powershell -ExecutionPolicy Bypass -File Build-AdobeX64AdmxFromLockableCsv.ps1
powershell -ExecutionPolicy Bypass -File Validate-X64AdmxAdml.ps1 -AdmxPath ..\v2.8\AdobeDC_x64.admx -AdmlPath ..\v2.8\en-US\AdobeDC_x64.adml

powershell -ExecutionPolicy Bypass -File Build-AdobeX86AdmxFromLockableCsv.ps1
powershell -ExecutionPolicy Bypass -File Validate-X86AdmxAdml.ps1 -AdmxPath ..\v2.8\AdobeDC_x86.admx -AdmlPath ..\v2.8\en-US\AdobeDC_x86.adml

powershell -ExecutionPolicy Bypass -File Build-DocumentationFromLockableCsv.ps1
```

## Intune Upload

Remove existing ADMX entries for the same namespaces (`Adobe.Policies.Adobe_x64`, `Adobe.Policies.Adobe_x86`) before uploading v2.8, or Intune will treat them as conflicts.
