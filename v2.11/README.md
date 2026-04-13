# v2.11 — Adobe DC ADMX/ADML for Intune

13 April 2026

## Files

| File | Scope | Policies |
|------|-------|----------|
| `AdobeDC_x64.admx` + `en-US/AdobeDC_x64.adml` | Acrobat DC (x64) + Reader DC (x64) | 258 (142 Acrobat + 116 Reader) |
| `AdobeDC_x86.admx` + `en-US/AdobeDC_x86.adml` | Acrobat DC (x86) + Reader DC (x86) | 258 (142 Acrobat + 116 Reader) |

## Changes from v2.10

### Expanded setting: Hide Adobe Messages on Document Open (+1 Acrobat policy)

- **`bDontShowMsgWhenViewingDoc`** — previously Reader DC only, now applies to both Reader and Acrobat. The Unified x64 installer runs Acrobat.exe in Reader mode and reads Acrobat registry keys, so this setting must be configurable under the Acrobat DC `cIPM` path to take effect on Unified deployments.

This resolves the Known Issue noted in v2.10 regarding KB parity for `cIPM\bDontShowMsgWhenViewingDoc`.

### Documentation update

- **Reduce Nags** page: `bDontShowMsgWhenViewingDoc` scope updated from Reader to Both.
- **Acrobat Settings** page: now lists `bDontShowMsgWhenViewingDoc`.

### Revision metadata

- ADMX/ADML `revision` is **2.11**; descriptions reference v2.11.
- Policy namespace prefixes (`Adobe_x64`, `Adobe_x86`) and namespace URIs (`Adobe.Policies.Adobe_x64`, `Adobe.Policies.Adobe_x86`) are unchanged, so Intune upgrades are compatible.

## Known Issues

- The `bToggle*` family uses inverted registry values (0=feature ON, 1=feature OFF). FriendlyNames from v2.2 still apply; raw registry checks may look counterintuitive.
- ARM Legacy settings (**Check**, **Mode**) remain excluded due to unresolvable `(product name)\(product code)` placeholders.
- All x86 paths (both Reader and Acrobat) are derived by inserting `WOW6432Node\` into the native registry path.
- `tBuiltInPermList` is stored by Adobe as REG_BINARY but the ADMX text element writes REG_SZ. Admins may need to verify compatibility or deploy via registry script if the application requires the binary type.

## Intune Upload

Remove existing ADMX entries for the same namespaces (`Adobe.Policies.Adobe_x64`, `Adobe.Policies.Adobe_x86`) before uploading v2.11, or Intune will treat them as conflicts.
