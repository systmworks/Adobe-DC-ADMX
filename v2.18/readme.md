<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

# AdobeDC ADMX v2.18

## Changes from v2.17

One new **machine** policy for **Adobe Acrobat DC** and **Adobe Reader DC** (x64 and x86 in the unified file; mirrored in the split files):

| Friendly name | Value name | Category | Effect when Enabled |
|---|---|---|---|
| Block non-PDF file attachments | `iFileAttachmentPerms` | Security: Execution & Protection | Writes DWORD **1** under the product `FeatureLockDown` policy key for Reader DC and Acrobat DC. Aligns with DISA STIG Reader **V-213174** (ARDC-CN-000035) and Acrobat Pro **V-213119** (AADC-CN-000275), and NSA-style hardening for PDF file attachments. |

**Not configured** leaves attachment behavior to defaults; **Disabled** in policy terms writes DWORD **0** (allows opening non-PDF attachments with external applications per Trust Manager).

**Thanks** to community member **CyberChelonian** for flagging **`iFileAttachmentPerms`** (this release) and for flagging the Acrobat DC coverage gap for **Protected Mode** and **AppContainer** (`bProtectedMode` / `bEnableProtectedModeAppContainer`, v2.17).

Earlier release history: [Documentation/changelog.md](../Documentation/changelog.md).

## Changes in v2.17 (relative to v2.16)

Two machine policies were exposed for **Adobe Acrobat DC** (x64 and x86) in addition to **Adobe Reader DC**:

| Friendly name | Value name | Category | Effect when Enabled |
|---|---|---|---|
| Protected Mode Sandbox | `bProtectedMode` | Security: Execution & Protection | Writes DWORD **1** under `HKLM\...\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown` (Recommended). Aligns with [Privileged (Protected Mode)](https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/Privileged.html) and DISA STIG Acrobat Pro DC rule **V-213127** (AADC-CN-001010). |
| AppContainer Sandbox | `bEnableProtectedModeAppContainer` | Security: Execution & Protection | Writes DWORD **1** under the same `FeatureLockDown` path (Recommended). Requires Protected Mode; see Adobe documentation above. |

Previously, Group Policy and Intune admins could enforce these values for Reader DC only; v2.17 added them under the **Acrobat DC** policy tree as well.

**v2.16 (metadata only):** The same PrefRef-derived policy definitions as **v2.15**, with ADMX/ADML metadata alignment for legacy Group Policy import (`revision` / `minRequiredRevision` and three-line localization root layout).

## ADMX Files

A combined ADMX file (`AdobeDC.admx`) is provided alongside per-architecture files. Deploy the combined file if you manage both 32-bit and 64-bit installations, or use the individual x64/x86 files to target one or both architectures. The x86 and x64 files can be deployed together, but **do not** deploy them alongside the combined file — that duplicates policy entries in Group Policy.

| ADMX File | Products & Architectures | Policies |
|---|---|---:|
| `AdobeDC.admx` | Reader DC (x86 + x64) and Acrobat DC (x86 + x64) | 528 |
| `AdobeDC_x64.admx` | Reader DC (x64) and Acrobat DC (x64) | 264 |
| `AdobeDC_x86.admx` | Reader DC (x86) and Acrobat DC (x86) | 264 |

**Sharing & responsibility** — Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
