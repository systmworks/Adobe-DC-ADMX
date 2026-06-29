[<- Back to Documentation](README.md)

# STIG: Adobe Acrobat Reader DC Continuous Track

**Source:** [DISA STIG — Adobe Acrobat Reader DC Continuous Track](https://public.cyber.mil/stigs/downloads/)
**Version:** V2R1 · Benchmark Date: 23 Jul 2021
**Registry scope:** `HKLM\Software\Policies\Adobe\Acrobat Reader\DC\` (enforced via Group Policy)

> **Important — registry path applies to 32-bit Reader only.**
> This STIG was written before Adobe merged the Acrobat and Reader code bases into the
> [unified installer](https://helpx.adobe.com/acrobat/kb/acrobat-unified-installer-windows-overview.html).
> All registry paths reference the legacy `Acrobat Reader\DC` hive. That hive is only written
> by **32-bit Reader** (`SOFTWARE\WOW6432Node\...`).
>
> **64-bit Reader (UCB)** is installed by the unified installer and shares the `Adobe Acrobat\DC`
> registry hive with Acrobat. Applying this STIG's registry values to a 64-bit Reader deployment
> will have no effect — use the [Acrobat Pro DC STIG](stig-acrobat-pro-dc.md) paths instead.

---

## Controls

26 total. The **ADMX Policy** column shows the display name as it appears in GPMC and Intune Admin Templates.
For 32-bit Reader on a 64-bit machine, policies appear under
`Computer Configuration → Administrative Templates → Adobe → Acrobat Reader DC (32-bit)`.

> **Note on V-213172 (iURLPerms):** The STIG lists this as a Computer-scope control under `FeatureLockDown`,
> but Adobe's preference documentation marks `iURLPerms` as not lockable via HKLM. The correct registry path
> is `HKCU\...\TrustManager\cDefaultLaunchURLPerms\iURLPerms` (User scope). An ADMX policy exists for this
> path — use **URL Access Permissions** under *User Configuration*.

| VUL ID | STIG Rule | Severity | Requirement | ADMX Policy | Registry Value | Setting | Scope |
|---|---|---|---|---|---|---|---|
| V-213192 | ARDC-CN-000340 | CAT I | Latest security-related software updates must be installed | — (procedural) | — | Verify via Help → About | — |
| V-213168 | ARDC-CN-000005 | CAT II | Enhanced Security in standalone mode must be enabled | Enhanced Security Standalone | `FeatureLockDown\bEnhancedSecurityStandalone` | `1` | Computer |
| V-213169 | ARDC-CN-000010 | CAT II | Enhanced Security in browser mode must be enabled | Enhanced Security in Browser | `FeatureLockDown\bEnhancedSecurityInBrowser` | `1` | Computer |
| V-213170 | ARDC-CN-000015 | CAT II | Protected Mode must be enabled | Protected Mode Sandbox | `FeatureLockDown\bProtectedMode` | `1` | Computer |
| V-213171 | ARDC-CN-000020 | CAT II | Protected View must be enabled | Protected View Mode | `FeatureLockDown\iProtectedView` | `2` (All files) | Computer |
| V-213172 | ARDC-CN-000025 | CAT II | Access to websites must be blocked | URL Access Permissions *(STIG scope error — is User, not Computer)* | `TrustManager\cDefaultLaunchURLPerms\iURLPerms` | `1` | User |
| V-213173 | ARDC-CN-000030 | CAT II | Access to unknown websites must be blocked | Unknown URL Access Policy | `FeatureLockDown\cDefaultLaunchURLPerms\iUnknownURLPerms` | `3` (Block) | Computer |
| V-213174 | ARDC-CN-000035 | CAT II | Files other than PDF or FDF must be blocked | Block non-PDF file attachments | `FeatureLockDown\iFileAttachmentPerms` | `1` | Computer |
| V-213175 | ARDC-CN-000045 | CAT II | Flash Content must be blocked | Flash Content in PDFs | `FeatureLockDown\bEnableFlash` | `0` | Computer |
| V-213178 | ARDC-CN-000060 | CAT II | Document Cloud Services must be disabled | Document Cloud Services | `FeatureLockDown\cServices\bToggleAdobeDocumentServices` | `1` | Computer |
| V-213179 | ARDC-CN-000065 | CAT II | Cloud Synchronization must be disabled | Preferences Synchronization | `FeatureLockDown\cServices\bTogglePrefsSync` | `1` | Computer |
| V-213181 | ARDC-CN-000075 | CAT II | Third-party web connectors must be disabled | Third-Party Cloud Connectors | `FeatureLockDown\cServices\bToggleWebConnectors` | `1` | Computer |
| V-213184 | ARDC-CN-000090 | CAT II | Webmail access must be disabled | Disable WebMail Integration | `FeatureLockDown\cWebmailProfiles\bDisableWebmail` | `1` | Computer |
| V-213185 | ARDC-CN-000100 | CAT II | Online SharePoint access must be disabled | Disable SharePoint & Office 365 Integration | `FeatureLockDown\cSharePoint\bDisableSharePointFeatures` | `1` | Computer |
| V-213188 | ARDC-CN-000315 | CAT II | Ability to add Trusted Files and Folders must be disabled | Lock Trusted Folders and Files | `FeatureLockDown\bDisableTrustedFolders` | `1` | Computer |
| V-213189 | ARDC-CN-000320 | CAT II | Ability to elevate IE Trusted Sites to Privileged Locations must be disabled | Lock Trusted Host Sites | `FeatureLockDown\bDisableTrustedSites` | `1` | Computer |
| V-213193 | ARDC-CN-000345 | CAT II | FIPS mode must be enabled | FIPS Mode | `AVGeneral\bFIPSMode` | `1` | User |
| V-213176 | ARDC-CN-000050 | CAT III | Ability to change the Default Handler must be disabled | Lock Default PDF Viewer | `FeatureLockDown\bDisablePDFHandlerSwitching` | `1` | Computer |
| V-213177 | ARDC-CN-000055 | CAT III | Adobe Send and Track plugin for Outlook must be disabled | Send & Track Outlook Plugin | `FeatureLockDown\cCloud\bAdobeSendPluginToggle` | `1` | Computer |
| V-213180 | ARDC-CN-000070 | CAT III | Repair Installation must be disabled | Disable Repair for All Users | `Acrobat Reader\DC\Installer\DisableMaintenance` | `1` | Computer |
| V-213182 | ARDC-CN-000080 | CAT III | Acrobat upsell prompts must be disabled | Show Upgrade Prompts | `FeatureLockDown\bAcroSuppressUpsell` | `1` | Computer |
| V-213183 | ARDC-CN-000085 | CAT III | Adobe Send for Signature must be disabled | Adobe Acrobat Sign | `FeatureLockDown\cServices\bToggleAdobeSign` | `1` | Computer |
| V-213186 | ARDC-CN-000115 | CAT III | Welcome Screen must be disabled | Welcome Screen on Startup | `FeatureLockDown\cWelcomeScreen\bShowWelcomeScreen` | `0` | Computer |
| V-213187 | ARDC-CN-000120 | CAT III | Service upgrades must be disabled | Services & Web-Plugin Updates | `FeatureLockDown\cServices\bUpdater` | `0` | Computer |
| V-213190 | ARDC-CN-000330 | CAT III | Periodic uploading of European certificates must be disabled | Load Security Settings from Server (European Certificates) | `Security\cDigSig\cEUTLDownload\bLoadSettingsFromURL` | `0` | User |
| V-213191 | ARDC-CN-000335 | CAT III | Periodic uploading of Adobe certificates must be disabled | Load Security Settings from Server (Adobe Certificates) | `Security\cDigSig\cAdobeDownload\bLoadSettingsFromURL` | `0` | User |

---

## Differences from the Acrobat Pro DC STIG

The Reader DC STIG was published when Reader had its own separate codebase and installer. Key differences from the [Pro DC STIG](stig-acrobat-pro-dc.md):

| Aspect | Acrobat Pro DC STIG | Acrobat Reader DC STIG |
|---|---|---|
| Computer policy base path | `HKLM\Software\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown` | `HKLM\Software\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown` |
| User policy base path | `HKCU\Software\Adobe\Adobe Acrobat\DC\` | `HKCU\Software\Adobe\Acrobat Reader\DC\` |
| Installer key (DisableMaintenance) | `Software\Adobe\Adobe Acrobat\DC\Installer` | `Software\Adobe\Acrobat Reader\DC\Installer` |
| FIPS control | V-245874 (CAT II, User scope) | V-213193 (CAT II, User scope) |
| Upsell suppression | Not in STIG | V-213182 (`bAcroSuppressUpsell`) |
| Service updater lockdown | Not in STIG | V-213187 (`bUpdater = 0`) |
| Document Cloud Services | Not a separate control | V-213178 (`bToggleAdobeDocumentServices`) |
| Adobe Sign | Not a separate control | V-213183 (`bToggleAdobeSign`) |
| Website access controls | iURLPerms is CAT III | iURLPerms (V-213172) is **CAT II** |
| Protected View value | `iProtectedView = 2` (CAT II) | `iProtectedView = 2` (CAT II) |

---

## Registry path notes

All Computer-scope policy values sit under:

```
HKLM\Software\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\
```

User-scope values (V-213190, V-213191, V-213193) sit under:

```
HKCU\Software\Adobe\Acrobat Reader\DC\
```

The Repair Installation value (V-213180) is a non-policy key:

```
HKLM\Software\Adobe\Acrobat Reader\DC\Installer\DisableMaintenance
  (64-bit Windows Wow6432Node path: HKLM\SOFTWARE\Wow6432Node\Adobe\Acrobat Reader\DC\Installer)
```

> 32-bit Reader is the only product that writes to the `Acrobat Reader\DC` registry hive.
> 64-bit Reader (UCB) does **not** use this hive — it uses `Adobe Acrobat\DC` exactly like
> Acrobat Pro. Applying this STIG to a 64-bit Reader environment will set registry values
> that the application does not read.
