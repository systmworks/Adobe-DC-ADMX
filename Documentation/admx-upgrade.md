<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](../README.md)

# ADMX Upgrade

Guide for replacing an imported **AdobeDC** ADMX in Microsoft Intune with a newer release. This applies to **any** ingested ADMX template in Intune, not only this project.

Microsoft documents the same constraint: [Replace existing ADMX files](https://learn.microsoft.com/en-us/intune/device-configuration/settings-catalog/import-custom-admx-templates#replace-existing-admx-files) - you must delete configuration profiles that use the ADMX **before** you can remove and re-import the template.

## What does not work

These common assumptions fail in Intune:

1. Upload the newer ADMX and replace the existing import.
2. Remove the existing ADMX import, then upload the new version - **while a configuration profile still references that ADMX**.

If profiles still exist, the old ADMX may not fully delete and the new upload can fail with a namespace error.

## Intune upgrade steps

Plan for a **temporary policy gap** while profiles are removed and recreated.

| Step | Action |
|------|--------|
| 1 | **Back up** the existing Intune configuration profile (export settings, screenshot assignments, or use the helper script below). |
| 2 | **Delete** every configuration profile that uses the imported AdobeDC ADMX. |
| 3 | **Delete** the imported `AdobeDC.admx` (and ADML) from **Devices > Configuration > Import ADMX**. |
| 4 | **Wait** 2-5 minutes for Intune to finish processing the deletions. |
| 5 | **Upload** the new `AdobeDC.admx` and `en-US/AdobeDC.adml` together. |
| 6 | **Recreate** the configuration profile (manually or by importing your backup). Re-assign scope tags and assignments. |

### Backup and restore helper scripts

To speed up steps 1 and 6, export before the upgrade and import after the new ADMX is uploaded:

| Script | Purpose |
|--------|---------|
| [`Helper_Scripts/Export-IntuneAdmxPolicy_v3.0.ps1`](../Helper_Scripts/Export-IntuneAdmxPolicy_v3.0.ps1) | Export an Administrative Template profile to JSON (uses stable category paths that survive ADMX re-upload). |
| [`Helper_Scripts/Import-IntuneAdmxPolicy_v3.0.ps1`](../Helper_Scripts/Import-IntuneAdmxPolicy_v3.0.ps1) | Recreate a profile from exported JSON after the new ADMX is imported. |

Requires Microsoft Graph (`Microsoft.Graph.Authentication`) and `DeviceManagementConfiguration.ReadWrite.All`.

> [!NOTE]
> Exports from **combined v2.x** or the separate **User ADMX v1.x** cannot be imported into current combined releases without conversion. Use [`Helper_Scripts/Convert-AdobeDcIntuneExportToCombinedV3.ps1`](../Helper_Scripts/Convert-AdobeDcIntuneExportToCombinedV3.ps1) first. See the [ADMX install guide](../ADMX/readme.md#migrating-from-v221--user-v110).

## Before you upgrade

1. Read the [Changelog (Combined)](changelog.md) entry for your current version and the target release.
2. Combined **v3.4+** releases are additive-only unless the changelog documents a one-time control-type correction - existing bindings are preserved after re-upload.
3. Combined **v3.0-v3.3** may require one-time re-selection; read the matching changelog entry first.

## Group Policy (on-premises)

Group Policy does not use Intune ADMX ingestion. To upgrade:

1. Copy the new `AdobeDC.admx` to `%SystemRoot%\PolicyDefinitions` and `AdobeDC.adml` to `%SystemRoot%\PolicyDefinitions\en-US`.
2. Run `gpupdate /force` on clients (or wait for the next policy refresh cycle).

Existing GPO links and configured values remain unless the changelog documents a breaking rename or control-type change.

## Related links

- [Import custom ADMX templates in Intune (Microsoft Learn)](https://learn.microsoft.com/en-us/intune/device-configuration/settings-catalog/import-custom-admx-templates)
- [Replace existing ADMX files (Microsoft Learn)](https://learn.microsoft.com/en-us/intune/device-configuration/settings-catalog/import-custom-admx-templates#replace-existing-admx-files)
- [ADMX install guide](../ADMX/readme.md)
- [Changelog (Combined)](changelog.md)

---

**Sharing & responsibility** - Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
