# v2.5 — Adobe DC ADMX/ADML for Intune

Generated April 2026 from `2026-4-8-Adobe_Lockable_PrefRef_v1.csv`.

## Files

| File | Scope | Policies |
|------|-------|----------|
| `AdobeDC_x64.admx` + `en-US/AdobeDC_x64.adml` | Acrobat DC (x64) + Reader DC (x64) | 248 (136 Acrobat + 112 Reader) |
| `AdobeDC_x86.admx` + `en-US/AdobeDC_x86.adml` | Acrobat DC (x86) + Reader DC (x86) | 248 (136 Acrobat + 112 Reader) |

## Changes from v2.4

### Acrobat DC (x86) support

The x86 template is no longer Reader-only. `AdobeDC_x86.admx` now includes all Acrobat DC and Reader DC settings with `WOW6432Node` registry paths derived programmatically from the canonical `HKLM_Path_Reader_DC` and `HKLM_Path_Acrobat_DC` CSV columns, matching the same category and policy structure as the x64 template. The file has been renamed from `ReaderDC_x86` to `AdobeDC_x86` to reflect its expanded scope.

### License change

All generated ADMX/ADML files and build scripts now use **Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)** instead of CC0. The templates are free to use and redistribute, including for commercial purposes, with attribution required. ShareAlike applies to adaptations you distribute.

### Revision metadata

- ADMX/ADML `revision` is **2.5**; descriptions reference v2.5.
- Policy namespace prefixes (`Adobe_x64`, `Adobe_x86`) and namespace URIs (`Adobe.Policies.Adobe_x64`, `Adobe.Policies.Adobe_x86`) are unchanged from v2.4, so Intune upgrades are compatible.

## Known Issues

- The `bToggle*` family uses inverted registry values (0=feature ON, 1=feature OFF). FriendlyNames from v2.2 still apply; raw registry checks may look counterintuitive.
- ARM Legacy settings (**Check**, **Mode**) remain excluded due to unresolvable `(product name)\(product code)` placeholders.
- All x86 paths (both Reader and Acrobat) are derived by inserting `WOW6432Node\` into the native registry path. The CSV stores only two path columns (`HKLM_Path_Reader_DC` and `HKLM_Path_Acrobat_DC`); the x86 builder applies the WOW64 transform programmatically.

## Builder Scripts

Located in `tools/`:

| Script | Purpose |
|--------|---------|
| `Build-AdobeX64AdmxFromLockableCsv.ps1` | Generates `AdobeDC_x64.admx` + ADML (default output `v2.5/`) |
| `Build-AdobeX86AdmxFromLockableCsv.ps1` | Generates `AdobeDC_x86.admx` + ADML (default output `v2.5/`) |
| `Validate-X64AdmxAdml.ps1` | Cross-validates x64 ADMX/ADML (defaults to `v2.5/`) |
| `Validate-X86AdmxAdml.ps1` | Cross-validates x86 ADMX/ADML (defaults to `v2.5/`) |
| `Build-DocumentationFromLockableCsv.ps1` | Regenerates `Documentation/*.md` (defaults to `-Version 2.5`) |

### Rebuilding

```powershell
cd tools
powershell -ExecutionPolicy Bypass -File Build-AdobeX64AdmxFromLockableCsv.ps1
powershell -ExecutionPolicy Bypass -File Validate-X64AdmxAdml.ps1

powershell -ExecutionPolicy Bypass -File Build-AdobeX86AdmxFromLockableCsv.ps1
powershell -ExecutionPolicy Bypass -File Validate-X86AdmxAdml.ps1

powershell -ExecutionPolicy Bypass -File Build-DocumentationFromLockableCsv.ps1
```

## Intune Upload

Remove existing ADMX entries for the same namespaces (`Adobe.Policies.Adobe_x64`, `Adobe.Policies.Adobe_x86`) before uploading v2.5, or Intune will treat them as conflicts.
