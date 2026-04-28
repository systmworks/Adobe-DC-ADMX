# AdobeDC ADMX v2.16

## Changes from v2.15

- **Metadata only (no policy deltas):** The same PrefRef-derived policy definitions and registry behaviour as [v2.15](../v2.15/readme.md).
- **Group Policy interoperability:** `<resources minRequiredRevision="…"/>` now uses the **same version string** as `policyDefinitions` / paired ADML (`revision`), and `<policyDefinitionResources>` opens on **three lines** matching `<policyDefinitions>` (xmlns:xsd/xsi; revision/schemaVersion; default xmlns)—to avoid issues importing templates into legacy Group Policy tools.

## ADMX Files

A combined ADMX file (`AdobeDC.admx`) is provided alongside per-architecture files. Deploy the combined file if you manage both 32-bit and 64-bit installations, or use the individual x64/x86 files to target one or both architectures. The x86 and x64 files can be deployed together, but **do not** deploy them alongside the combined file — that duplicates policy entries in Group Policy.

| ADMX File | Products & Architectures | Policies |
|---|---|---:|
| `AdobeDC.admx` | Reader DC (x86 + x64) and Acrobat DC (x86 + x64) | 520 |
| `AdobeDC_x64.admx` | Reader DC (x64) and Acrobat DC (x64) | 260 |
| `AdobeDC_x86.admx` | Reader DC (x86) and Acrobat DC (x86) | 260 |

## Changes from v2.14 (carried forward in v2.15/v2.16)

These items were introduced in **v2.15** relative to **v2.14** and apply to v2.16 unless superseded above.

### Bug Fixes — Corrected Enabled/Disabled Values

Three policies had their `enabledValue` and `disabledValue` swapped in v2.14, causing "Enabled" in Group Policy to write the wrong registry value. These are corrected across all product and architecture variants (Acrobat x64, Acrobat x86, Reader x64, Reader x86):

| Policy (valueName) | Category | v2.14 (incorrect) | v2.15+ (corrected) |
|---|---|---|---|
| `bDisableJavaScript` | Security — Execution | Enabled = 0, Disabled = 1 | Enabled = 1, Disabled = 0 |
| `bDisableSharePointFeatures` | Sharing & Features | Enabled = 0, Disabled = 1 | Enabled = 1, Disabled = 0 |
| `bDisableWebmail` | Sharing & Features | Enabled = 0, Disabled = 1 | Enabled = 1, Disabled = 0 |

**Impact:** Environments that had these policies set to "Enabled" in Group Policy were actually writing the opposite value to the registry. After upgrading to v2.15 or later, existing GPOs with these policies apply the correct registry values without any policy reconfiguration.

### Structural Improvement

Enabled/Disabled values for all toggle policies are sourced from authoritative per-policy reference data rather than inferred by naming-convention heuristics. This eliminates an entire class of potential value-swap bugs going forward.

### DISA STIG Cross-References in Policy Descriptions

Policy description (explain) text includes DISA STIG references where applicable. Policies that map to a DISA STIG rule show a "Security Reference" line at the end of their description, citing the STIG rule version and Vulnerability ID for both the Adobe Reader DC and Adobe Acrobat Pro DC Continuous Track STIGs.

Example: `Security Reference: STIG ARDC-CN-000005 (V-213168) Medium; STIG AADC-CN-000205 (V-213117) Medium`

This covers 20 registry settings across both STIGs (26 Reader rules, 23 Pro rules). Six severity differences exist between the Reader and Pro STIGs for the same registry key; the recommended registry values are consistent.

### FriendlyName Corrections for Admin Clarity

Two policies had FriendlyNames that were misleading when combined with the Enable/Disable toggle. In both cases, selecting "Enabled" in Group Policy actually disabled the feature, contradicting the policy name. The FriendlyNames now include "Disable" to make the admin intent clear:

| ValueName | Old FriendlyName | New FriendlyName |
|---|---|---|
| `bDisableSharePointFeatures` | SharePoint & Office 365 Integration | Disable SharePoint & Office 365 Integration |
| `bDisableWebmail` | WebMail Integration | Disable WebMail Integration |

### Summary Text Improvements

Four policies had Summary text that described only the disabled state ("Disables X") rather than neutrally describing what the setting controls. These were reworded for clarity:

| ValueName | FriendlyName | Old Summary | New Summary |
|---|---|---|---|
| `bToggleAdobeDocumentServices` | Document Cloud Services | Disables Document Cloud service access... | Controls whether Document Cloud services are enabled... |
| `bTogglePrefsSync` | Preferences Synchronization | Disables preferences synchronization. | Controls whether preferences synchronization across devices is enabled. |
| `bUpdater` (cServices) | Services & Web-Plugin Updates | Disables both updates... | Controls whether web-plugin component updates and cloud services are enabled. |
| `bToggleAdobeSign` | Adobe Acrobat Sign | Disables Adobe Send for Signature... | Controls whether Adobe Acrobat Sign (Send for Signature) is enabled. |

### Documentation Updates — Security Hardening & Reduce Nags Pages

Ten settings with recommended security values were added to the Security Hardening documentation page, and two settings were added to the Reduce Nags page. These reflect settings that already had GoodSetting recommendations in the policy reference data but were not previously surfaced in the curated documentation pages.

### No schema changes affecting v2.16 identification

- All category structures, registry paths, enum/dropdown options, and text-field policies match v2.15.
- The ADMX namespace (`Adobe.Policies.AdobeDC`) and schema version are unchanged.
