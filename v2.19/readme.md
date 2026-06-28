<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

# AdobeDC ADMX v2.19

## Changes from v2.18

Six new **machine** lockdown policies for **Adobe Acrobat DC** and **Adobe Reader DC** under a new **Microsoft Purview (MIP)** category (x64 and x86 in the unified file; mirrored in the split files):

| Friendly name | Value name | Category | Effect when Enabled |
|---|---|---|---|
| Enable MIP Labelling | `bMIPLabelling` | Microsoft Purview (MIP) | Writes DWORD **1** under `HKLM\...\Policies\Adobe\...\DC\FeatureLockDown`. Locks the Enable Microsoft Purview Information Protection option in Preferences > Security. |
| Check MIP Policy on Save | `bMIPCheckPolicyOnDocSave` | Microsoft Purview (MIP) | Writes DWORD **1** under the same `FeatureLockDown` path. Locks save-time labeling policy checks (requires default/mandatory labeling in the Purview compliance portal). |
| MIP Sovereign Cloud | `iMIPCloud` | Microsoft Purview (MIP) | Dropdown under `FeatureLockDown` (0=Unknown through 10=China; **3**=Commercial). For DoD, GCC, GCC High, and other sovereign tenants. |
| MIP External Browser Auth | `bMIPExternalAuthAdmin` | Microsoft Purview (MIP) | Writes DWORD **1** — locks browser-based authentication for MIP operations enabled. |
| MIP Double Key Encryption | `bEnableDKEAdmin` | Microsoft Purview (MIP) | Writes DWORD **1** — locks double key encryption (DKE) label support enabled. |
| Suppress OS Auth Prompts (MIP) | `bSilentAuth` | Microsoft Purview (MIP) | Writes DWORD **1** — locks suppression of OS auth prompts during MIP. Set **Disabled** (DWORD **0**) when troubleshooting AADSTS50020-type errors. |

These are **HKLM FeatureLockDown lockdown** policies: they gray out or lock admin-controlled settings. They are **not** the per-user `HKCU\...\MicrosoftAIP` preferences (`bShowDMB`, `bEnablePolicyAuthentication`, `bEnableLogging`), which ship in **[User ADMX v1.6](https://github.com/systmworks/Adobe-DC-User-ADMX)**. Both template families can be deployed together (separate ADMX namespaces).

Registry paths follow [Adobe enterprise MIP guidance](https://helpx.adobe.com/enterprise/kb/mpip-support-acrobat.html). Test in your environment before production rollout.

**Thanks** to community member **virtitnerd** for [issue #8](https://github.com/systmworks/Adobe-DC-ADMX/issues/8) (MIP/Purview support).

Earlier release history: [Documentation/changelog.md](../Documentation/changelog.md).

## Changes in v2.18 (relative to v2.17)

One new **machine** policy for **Adobe Acrobat DC** and **Adobe Reader DC** (x64 and x86 in the unified file; mirrored in the split files):

| Friendly name | Value name | Category | Effect when Enabled |
|---|---|---|---|
| Block non-PDF file attachments | `iFileAttachmentPerms` | Security: Execution & Protection | Writes DWORD **1** under the product `FeatureLockDown` policy key for Reader DC and Acrobat DC. Aligns with DISA STIG Reader **V-213174** (ARDC-CN-000035) and Acrobat Pro **V-213119** (AADC-CN-000275), and NSA-style hardening for PDF file attachments. |

**Not configured** leaves attachment behavior to defaults; **Disabled** in policy terms writes DWORD **0** (allows opening non-PDF attachments with external applications per Trust Manager).

**Thanks** to community member **CyberChelonian** for flagging **`iFileAttachmentPerms`** (v2.18) and for flagging the Acrobat DC coverage gap for **Protected Mode** and **AppContainer** (`bProtectedMode` / `bEnableProtectedModeAppContainer`, v2.17).

## ADMX Files

A combined ADMX file (`AdobeDC.admx`) is provided alongside per-architecture files. Deploy the combined file if you manage both 32-bit and 64-bit installations, or use the individual x64/x86 files to target one or both architectures. The x86 and x64 files can be deployed together, but **do not** deploy them alongside the combined file — that duplicates policy entries in Group Policy.

| ADMX File | Products & Architectures | Policies |
|---|---|---:|
| `AdobeDC.admx` | Reader DC (x86 + x64) and Acrobat DC (x86 + x64) | 552 |
| `AdobeDC_x64.admx` | Reader DC (x64) and Acrobat DC (x64) | 276 |
| `AdobeDC_x86.admx` | Reader DC (x86) and Acrobat DC (x86) | 276 |

**Sharing & responsibility** — Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
