<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

# AdobeDC ADMX v2.17

## Changes from v2.16

Two machine policies are now exposed for **Adobe Acrobat DC** (x64 and x86) in addition to **Adobe Reader DC**:

| Friendly name | Value name | Category | Effect when Enabled |
|---|---|---|---|
| Protected Mode Sandbox | `bProtectedMode` | Security: Execution & Protection | Writes DWORD **1** under `HKLM\...\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown` (Recommended). Aligns with [Privileged (Protected Mode)](https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/Privileged.html) and DISA STIG Acrobat Pro DC rule **V-213127** (AADC-CN-001010). |
| AppContainer Sandbox | `bEnableProtectedModeAppContainer` | Security: Execution & Protection | Writes DWORD **1** under the same `FeatureLockDown` path (Recommended). Requires Protected Mode; see Adobe documentation above. |

Previously, Group Policy and Intune admins could enforce these values for Reader DC only; they now appear under the **Acrobat DC** policy tree as well, so full Acrobat installations can be locked the same way.

## Changes in v2.16 (relative to v2.15)

- **Metadata only (no policy deltas):** The same PrefRef-derived policy definitions and registry behaviour as **v2.15**.
- **Group Policy interoperability:** `<resources minRequiredRevision="…"/>` now uses the **same version string** as `policyDefinitions` / paired ADML (`revision`), and `<policyDefinitionResources>` opens on **three lines** matching `<policyDefinitions>` (xmlns:xsd/xsi; revision/schemaVersion; default xmlns)—to avoid issues importing templates into legacy Group Policy tools.

Earlier release history: [Documentation/changelog.md](../Documentation/changelog.md).

## ADMX Files

A combined ADMX file (`AdobeDC.admx`) is provided alongside per-architecture files. Deploy the combined file if you manage both 32-bit and 64-bit installations, or use the individual x64/x86 files to target one or both architectures. The x86 and x64 files can be deployed together, but **do not** deploy them alongside the combined file — that duplicates policy entries in Group Policy.

| ADMX File | Products & Architectures | Policies |
|---|---|---:|
| `AdobeDC.admx` | Reader DC (x86 + x64) and Acrobat DC (x86 + x64) | 524 |
| `AdobeDC_x64.admx` | Reader DC (x64) and Acrobat DC (x64) | 262 |
| `AdobeDC_x86.admx` | Reader DC (x86) and Acrobat DC (x86) | 262 |

**Sharing & responsibility** — Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
