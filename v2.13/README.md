# v2.13 — Adobe DC ADMX/ADML for Intune

14 April 2026

## Files

| File | Scope | Policies |
|------|-------|----------|
| `AdobeDC_x64.admx` + `en-US/AdobeDC_x64.adml` | Acrobat DC (x64) + Reader DC (x64) | 262 (144 Acrobat + 118 Reader) |
| `AdobeDC_x86.admx` + `en-US/AdobeDC_x86.adml` | Acrobat DC (x86) + Reader DC (x86) | 262 (144 Acrobat + 118 Reader) |

## Changes from v2.12

### New settings

Two settings added for both products:

| Setting | ValueName | Category | Notes |
|---|---|---|---|
| Block JavaScript Execution | `bDisableJavaScript` | Security: Execution & Protection | Blocks and locks JavaScript execution. Added to **Security Hardening** page as Recommended (Enabled). |
| Accept EULA for Updater | `EULA` | Updates & Desktop Integration | Accepts the EULA so the built-in updater can download product updates. |

`bDisableJavaScript` was present in all v1.x ADMX versions but was inadvertently omitted when the v2.x series was generated. The setting is documented on Adobe's PrefRef (JSPrefs) page and resides at the standard lockable path under `FeatureLockDown`. GPO **Enabled** writes DWORD 1 (block JavaScript) and **Disabled** writes DWORD 0 (allow JavaScript), matching the `bDisablePDFRedirectionActions` pattern.

`EULA` is a non-policy HKLM key under `AdobeViewer`. The EULA must be accepted before the built-in updater will download product updates. In enterprise deployments the EULA is typically accepted at install time via `EULA_ACCEPT=YES`; this policy provides an alternative when that property was not set.

### Revision metadata

- ADMX/ADML `revision` is **2.13**; descriptions reference v2.13.
- Policy namespace prefixes (`Adobe_x64`, `Adobe_x86`) and namespace URIs (`Adobe.Policies.Adobe_x64`, `Adobe.Policies.Adobe_x86`) are unchanged, so Intune upgrades are compatible.

## Known Issues

- The `bToggle*` family uses inverted registry values (0=feature ON, 1=feature OFF). FriendlyNames from v2.2 still apply; raw registry checks may look counterintuitive.
- `bDisableJavaScript` uses straightforward logic: GPO **Enabled** = DWORD 1 = JavaScript is blocked and locked. This matches the `bDisablePDFRedirectionActions` pattern (Enabled = protection on).
- ARM Legacy settings (**Check**, **Mode**) remain excluded due to unresolvable `(product name)\(product code)` placeholders.
- All x86 paths (both Reader and Acrobat) are derived by inserting `WOW6432Node\` into the native registry path.
- `tBuiltInPermList` is stored by Adobe as REG_BINARY but the ADMX text element writes REG_SZ. Admins may need to verify compatibility or deploy via registry script if the application requires the binary type.

## Intune Upload

Remove existing ADMX entries for the same namespaces (`Adobe.Policies.Adobe_x64`, `Adobe.Policies.Adobe_x86`) before uploading v2.13, or Intune will treat them as conflicts.
