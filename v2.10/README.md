# v2.10 — Adobe DC ADMX/ADML for Intune

13 April 2026

## Files

| File | Scope | Policies |
|------|-------|----------|
| `AdobeDC_x64.admx` + `en-US/AdobeDC_x64.adml` | Acrobat DC (x64) + Reader DC (x64) | 257 (141 Acrobat + 116 Reader) |
| `AdobeDC_x86.admx` + `en-US/AdobeDC_x86.adml` | Acrobat DC (x86) + Reader DC (x86) | 257 (141 Acrobat + 116 Reader) |

## Changes from v2.9

### New setting: Patch Cache Cleanup (+2 policies)

One new setting added, generating one policy per product per architecture:

- **`PatchCleanFlag`** — "Patch Cache Cleanup" (DWORD toggle). Triggers cleanup of old cached update patch files (MSI/MSP) on the next update cycle. The Adobe ARM updater downloads patch files that accumulate over time, potentially consuming multiple gigabytes of disk space. Setting this value to 1 causes the updater to remove old cached files during the next update.

Sourced from an [Adobe Employee response on Adobe Community (Feb 2026)](https://community.adobe.com/questions-9/we-have-a-few-computers-wtih-literally-hundreds-of-1gb-update-msi-files-downloading-constantly-1302886). Not listed on lockable.html or PrefRef.

### Documentation update

- `PatchCleanFlag` added to the **Reduce Nags** page as a Recommended setting (Enabled).

### Revision metadata

- ADMX/ADML `revision` is **2.10**; descriptions reference v2.10.
- Policy namespace prefixes (`Adobe_x64`, `Adobe_x86`) and namespace URIs (`Adobe.Policies.Adobe_x64`, `Adobe.Policies.Adobe_x86`) are unchanged, so Intune upgrades are compatible.

## Known Issues

- The `bToggle*` family uses inverted registry values (0=feature ON, 1=feature OFF). FriendlyNames from v2.2 still apply; raw registry checks may look counterintuitive.
- ARM Legacy settings (**Check**, **Mode**) remain excluded due to unresolvable `(product name)\(product code)` placeholders.
- All x86 paths (both Reader and Acrobat) are derived by inserting `WOW6432Node\` into the native registry path.
- `tBuiltInPermList` is stored by Adobe as REG_BINARY but the ADMX text element writes REG_SZ. Admins may need to verify compatibility or deploy via registry script if the application requires the binary type.
- The Adobe enterprise KB also documents `cIPM\bDontShowMsgWhenViewingDoc` under the Acrobat FeatureLockDown path for Unified Acrobat in reader mode. That setting currently exists as Reader DC only; evaluate adding an Acrobat DC entry in a future version for full KB parity.

## Intune Upload

Remove existing ADMX entries for the same namespaces (`Adobe.Policies.Adobe_x64`, `Adobe.Policies.Adobe_x86`) before uploading v2.10, or Intune will treat them as conflicts.
