<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](../README.md)

# Changelog (User)

Settings changes across User ADMX versions. Only new, renamed, or reclassified settings are listed - internal script and formatting changes are omitted.

---
## Combined v3.0 - 18 July 2026

Merged into the combined `AdobeDC.admx`/ADML bundle (see [Changelog (Device)](changelog-device.md)). User namespace `Adobe.Policies.Adobe_User` dropped; policies retain `(User)` suffix and `class="User"`.

---

## v1.10 - 1 Jul 2026

**501 policies** (258 Acrobat DC + 243 Reader DC) - same inventory as v1.9.

### `(User)` suffix on all leaf display names

Every policy ADML display string gains ` (User)` (e.g. `Show Splash Screen` → `Show Splash Screen (User)`). Matches Microsoft convention for user-scope administrative templates. Helps IT admins tell user vs machine Adobe settings apart when both are in the same Intune profile - imported ADMX does not show hive or category path in the configuration list.

Same namespace, files, registry keys, and ADMX `name` attributes as v1.9. Validated Intune import after delete-and-reupload workflow.

See [readme in v1.10 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.10%20(User)/readme.md).

| ADMX File | Policies |
|---|---:|
| `AdobeDC_User.admx` + ADML | 501 |

---

## v1.9 - 30 Jun 2026

**501 policies** (258 Acrobat DC + 243 Reader DC) - unchanged from v1.8. **Superseded by v1.10** for new deployments.

### Category layout for Intune

Category folders restructured to **`Adobe (User)`** → **`Acrobat DC`** / **`Reader DC`** (product branches no longer repeat `(User)`).

ADML strings are sanitized for Intune (no bare `http://` literals in policy text; empty explain strings get a fallback). Leaf display names have no scope suffix (use v1.10 for `(User)` on all settings).

See [readme in v1.9 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.9%20(User)/readme.md).

| ADMX File | Policies |
|---|---:|
| `AdobeDC_User.admx` + ADML | 501 |

---

## v1.8 - 30 Jun 2026

**501 policies** (258 Acrobat DC + 243 Reader DC). **Superseded by v1.10** for new deployments.

### PR #9 user-scope policy additions

**New DWORD toggles** under **Security: Trust & Permissions** (Acrobat + Reader):

| Setting | ValueName | Suggested hardening |
|---|---|---|
| Load Security Settings from Server (Adobe Certificates) | `bLoadSettingsFromURL` @ `cAdobeDownload` | Disabled |
| Load Security Settings from Server (European Certificates) | `bLoadSettingsFromURL` @ `cEUTLDownload` | Disabled |

**New text policy** - companion to existing **`iURLPerms`**:

| Setting | ValueName | Notes |
|---|---|---|
| Trusted/Blocked URL List | `tHostPerms` | REG_SZ text box; only applies when `iURLPerms` = Custom Setting (0) |

*Thanks to **[@virtitnerd](https://github.com/virtitnerd)** for [PR #9](https://github.com/systmworks/Adobe-DC-ADMX/pull/9) on the Computer ADMX repo.*

See [readme in v1.8 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.8%20(User)/readme.md).

| ADMX File | Policies |
|---|---:|
| `AdobeDC_User.admx` + ADML | 501 |

---

## v1.7 - 30 Jun 2026

**495 policies** (255 Acrobat DC + 240 Reader DC) - unchanged from v1.6.

### Policy class corrected to `User`

All user-scope policies now use `class="User"` instead of `class="Both"`. Earlier releases used `class="Both"` based on outdated Intune guidance; policies incorrectly appeared under **Computer Configuration** as well as User Configuration. v1.7 restricts them to **User Configuration** only, which is the correct scope for HKCU preference settings.

*Thanks to **[@virtitnerd](https://github.com/virtitnerd)** for identifying this during review of [PR #9](https://github.com/systmworks/Adobe-DC-ADMX/pull/9) on the Computer ADMX repo.*

See [readme in v1.7 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.7%20(User)/readme.md).

| ADMX File | Policies |
|---|---:|
| `AdobeDC_User.admx` + ADML | 495 |

---

## v1.6 - 28 Jun 2026

**495 policies** (255 Acrobat DC + 240 Reader DC), up from 484 in v1.5.

### HKCU attachment lockdown (Reader + Acrobat)

**New user policies** under **Security: Trust & Permissions** - complementary HKCU controls for PDF file attachment behaviour (not a substitute for HKLM `FeatureLockDown` lockdown):

| Setting | ValueName | Suggested hardening |
|---|---|---|
| Open Non-PDF Attachments | `bAllowOpenFile` | Disabled → DWORD **0** |
| Secure Open Attachments | `bSecureOpenFile` | Enabled → DWORD **1** |

*Thanks to **[@CyberChelonian](https://github.com/CyberChelonian)** for [issue #4](https://github.com/systmworks/Adobe-DC-ADMX/issues/4) on the Computer ADMX repo (mis-filed as HKCU; addressed here in the User ADMX line).*

Adobe PrefRef labels these as version 10.x; community verification on current DC - test in your environment before production rollout.

### Reader Outlook Protected View

**New Reader DC policy** under **Security: Execution & Protection**:

| Setting | ValueName | Notes |
|---|---|---|
| Outlook Protected View | `bEnableAlwaysOutlookAttachmentProtectedView` | New for **Reader DC**; Enabled → DWORD **0** (Protected View on for Outlook attachments). Acrobat DC was already present from v1.4. |

*Thanks to **[@CyberChelonian](https://github.com/CyberChelonian)** for [issue #5](https://github.com/systmworks/Adobe-DC-ADMX/issues/5). Adobe documentation shows the Acrobat icon only; Reader path included per community request - verify Reader behaviour in your environment.*

### Microsoft Purview (MIP) - HKCU preferences only

**New category:** **Microsoft Purview (MIP)** - per-user `HKCU` preferences under `MicrosoftAIP` (not `FeatureLockDown` machine lockdown):

| Setting | ValueName |
|---|---|
| Show Document Message Bar (MIP) | `bShowDMB` |
| MIP Policy Authentication | `bEnablePolicyAuthentication` |
| MIP Logging | `bEnableLogging` |

*Thanks to **[@virtitnerd](https://github.com/virtitnerd)** for [issue #8](https://github.com/systmworks/Adobe-DC-ADMX/issues/8). This release covers the **HKCU `MicrosoftAIP`** slice of that request only. HKLM `FeatureLockDown` MIP lockdown policies (`bMIPLabelling`, `bMIPCheckPolicyOnDocSave`, `iMIPCloud`, `bMIPExternalAuthAdmin`, `bEnableDKEAdmin`, `bSilentAuth`) remain in scope for the **Computer ADMX** repo.*

See [readme in v1.6 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.6%20(User)/readme.md).

| ADMX File | Policies |
|---|---:|
| `AdobeDC_User.admx` + ADML | 495 |

---

## v1.5 - 28 Jun 2026

**No new policies** (484 unchanged). ADML generation fix: empty `presentationTable` omitted when there are no presentation entries, resolving Windows Server 2019 Group Policy Management Console import failures reported against v1.4.

*Thanks to **[@raschle](https://github.com/raschle)** for [PR #1](https://github.com/systmworks/Adobe-DC-User-ADMX/pull/1) identifying the WS2019 GPMC load failure.*

See [readme in v1.5 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.5%20(User)/readme.md).

---

## v1.4 - 7 May 2026

**No policy inventory change** (484 policies). Revision metadata aligned to **1.4** across ADMX, ADML, and `minRequiredRevision` for Group Policy and Intune consistency.

See [readme in v1.4 (User)](https://github.com/systmworks/Adobe-DC-User-ADMX/blob/main/v1.4%20(User)/readme.md).

**Sharing & responsibility** - Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.