# v2.12 — Adobe DC ADMX/ADML for Intune

13 April 2026

## Files

| File | Scope | Policies |
|------|-------|----------|
| `AdobeDC_x64.admx` + `en-US/AdobeDC_x64.adml` | Acrobat DC (x64) + Reader DC (x64) | 258 (142 Acrobat + 116 Reader) |
| `AdobeDC_x86.admx` + `en-US/AdobeDC_x86.adml` | Acrobat DC (x86) + Reader DC (x86) | 258 (142 Acrobat + 116 Reader) |

## Changes from v2.11

### Breaking change: Block EMF / Block XPS toggle fix

The GPO Enabled/Disabled mapping for two Acrobat DC policies has been corrected:

| Setting | ValueName | v2.11 (old) | v2.12 (new) |
|---|---|---|---|
| Block EMF to PDF Conversion | `BlockEMFParsing` | Enabled → DWORD 0 (allow) | Enabled → DWORD 1 (block) |
| Block XPS to PDF Conversion | `BlockXPSParsing` | Enabled → DWORD 0 (allow) | Enabled → DWORD 1 (block) |

In v2.11, setting these policies to **Enabled** in GPMC/Intune wrote DWORD 0, which *allowed* conversion — contradicting the "Block..." friendly name. In v2.12, **Enabled** correctly writes DWORD 1 (block conversion) and **Disabled** writes DWORD 0 (allow conversion).

**Migration action required:** If you previously deployed either of these policies, verify and re-apply the intended Enabled/Disabled state after upgrading to v2.12. Use `gpresult /h` or registry spot-checks (`HKLM\SOFTWARE\Adobe\Adobe Acrobat\DC\FeatureState\BlockEMFParsing` / `BlockXPSParsing`) to confirm the correct value is applied.

The ADML Explain text for both policies now includes a GPO-oriented clarification: *"When this policy is Enabled, conversion is blocked. When Disabled, conversion is allowed."*

### Documentation updates

- **Reduce Nags** page: `bAcroSuppressUpsell` (Show Upgrade Prompts) scope corrected from Reader to Both — the Unified x64 installer runs Acrobat.exe in Reader mode, so this setting must appear under Acrobat DC as well.
- **Security Hardening** page: Block EMF and Block XPS now correctly show **Enabled** as the hardened setting.

### Revision metadata

- ADMX/ADML `revision` is **2.12**; descriptions reference v2.12.
- Policy namespace prefixes (`Adobe_x64`, `Adobe_x86`) and namespace URIs (`Adobe.Policies.Adobe_x64`, `Adobe.Policies.Adobe_x86`) are unchanged, so Intune upgrades are compatible.

## Known Issues

- The `bToggle*` family uses inverted registry values (0=feature ON, 1=feature OFF). FriendlyNames from v2.2 still apply; raw registry checks may look counterintuitive.
- ARM Legacy settings (**Check**, **Mode**) remain excluded due to unresolvable `(product name)\(product code)` placeholders.
- All x86 paths (both Reader and Acrobat) are derived by inserting `WOW6432Node\` into the native registry path.
- `tBuiltInPermList` is stored by Adobe as REG_BINARY but the ADMX text element writes REG_SZ. Admins may need to verify compatibility or deploy via registry script if the application requires the binary type.

## Intune Upload

Remove existing ADMX entries for the same namespaces (`Adobe.Policies.Adobe_x64`, `Adobe.Policies.Adobe_x86`) before uploading v2.12, or Intune will treat them as conflicts.
