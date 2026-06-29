[<- Back to Documentation](README.md)

# STIG: Adobe Acrobat Professional DC Continuous Track

**Source:** [DISA STIG — Adobe Acrobat Pro DC Continuous Track](https://public.cyber.mil/stigs/downloads/)
**Version:** V2R1 · Benchmark Date: 23 Jul 2021
**Registry scope:** `HKLM\Software\Policies\Adobe\Adobe Acrobat\DC\` (enforced via Group Policy / Intune)

> This STIG applies to **Adobe Acrobat Pro DC** on the Continuous update track.
> Because 64-bit Reader uses Adobe's [unified installer](https://helpx.adobe.com/acrobat/kb/acrobat-unified-installer-windows-overview.html)
> and shares the same `Adobe Acrobat\DC` registry hive, these controls also apply to **64-bit Reader
> (UCB)** deployments. See [stig-acrobat-reader-dc.md](stig-acrobat-reader-dc.md) for the separate
> pre-UCB Reader STIG that targets the legacy `Acrobat Reader\DC` hive.

---

## Controls

23 total. The **ADMX Policy** column shows the display name as it appears in GPMC and Intune Admin Templates
(`Computer Configuration → Administrative Templates → Adobe → Adobe Acrobat DC`; User-scope policies appear
under `User Configuration → Administrative Templates → Adobe → Adobe Acrobat DC (User)`).
Entries marked *"— (not lockable; deploy via direct registry)"* have no corresponding ADMX policy —
Adobe's preference reference marks them as not lockable via Group Policy — and must be deployed via
direct registry write (LGPO, Intune remediation script, or custom OMA-URI).

| VUL ID | STIG Rule | Severity | Requirement | ADMX Policy | Registry Value | Setting | Scope |
|---|---|---|---|---|---|---|---|
| V-213129 | AADC-CN-001075 | CAT I | Latest security-related software updates must be installed | — (procedural) | — | Verify via Help → About | — |
| V-213117 | AADC-CN-000205 | CAT II | Enhanced Security for standalone mode must be enabled | Enhanced Security Standalone | `FeatureLockDown\bEnhancedSecurityStandalone` | `1` | Computer |
| V-213118 | AADC-CN-000210 | CAT II | Enhanced Security for browser mode must be enabled | Enhanced Security in Browser | `FeatureLockDown\bEnhancedSecurityInBrowser` | `1` | Computer |
| V-213119 | AADC-CN-000275 | CAT II | PDF file attachments must be blocked | Block non-PDF file attachments | `FeatureLockDown\iFileAttachmentPerms` | `1` | Computer |
| V-213122 | AADC-CN-000290 | CAT II | Flash Content must be blocked | Flash Content in PDFs | `FeatureLockDown\bEnableFlash` | `0` | Computer |
| V-213123 | AADC-CN-000295 | CAT II | Send and Track plugin for Outlook must be disabled | Send & Track Outlook Plugin | `FeatureLockDown\cCloud\bAdobeSendPluginToggle` | `1` | Computer |
| V-213124 | AADC-CN-000840 | CAT II | Privileged file and folder locations must be disabled | Lock Trusted Folders and Files | `FeatureLockDown\bDisableTrustedFolders` | `1` | Computer |
| V-213127 | AADC-CN-001010 | CAT II | Protected Mode must be enabled | Protected Mode Sandbox | `FeatureLockDown\bProtectedMode` | `1` | Computer |
| V-213128 | AADC-CN-001015 | CAT II | Protected View must be enabled | Protected View Mode | `FeatureLockDown\iProtectedView` | `2` (All files) | Computer |
| V-213131 | AADC-CN-001285 | CAT II | Ability to store files on Acrobat.com must be disabled | Disable Acrobat.com File Storage | `FeatureLockDown\cCloud\bDisableADCFileStore` | `1` | Computer |
| V-213132 | AADC-CN-001290 | CAT II | Cloud Synchronization must be disabled | Preferences Synchronization | `FeatureLockDown\cServices\bTogglePrefsSync` | `1` | Computer |
| V-245874 | AADC-CN-000955 | CAT II | FIPS mode must be enabled | FIPS Mode | `AVGeneral\bFIPSMode` | `1` | User |
| V-213120 | AADC-CN-000280 | CAT III | Access to unknown websites must be restricted | Unknown URL Access Policy | `FeatureLockDown\cDefaultLaunchURLPerms\iUnknownURLPerms` | `3` (Block) | Computer |
| V-213121 | AADC-CN-000285 | CAT III | Access to websites must be blocked | — (not lockable; deploy via direct registry) | `FeatureLockDown\cDefaultLaunchURLPerms\iURLPerms` | `1` | Computer |
| V-213126 | AADC-CN-000990 | CAT III | Periodic downloading of Adobe European certificates must be disabled | Load Security Settings from Server (European Certificates) | `Security\cDigSig\cEUTLDownload\bLoadSettingsFromURL` | `0` | User |
| V-213130 | AADC-CN-001280 | CAT III | Default Handler changes must be disabled | Lock Default PDF Viewer | `FeatureLockDown\bDisablePDFHandlerSwitching` | `1` | Computer |
| V-213133 | AADC-CN-001295 | CAT III | Repair Installation must be disabled | Disable Repair for All Users | `Adobe Acrobat\DC\Installer\DisableMaintenance` | `1` | Computer |
| V-213134 | AADC-CN-001300 | CAT III | Third-party web connectors must be disabled | Third-Party Cloud Connectors | `FeatureLockDown\cServices\bToggleWebConnectors` | `1` | Computer |
| V-213135 | AADC-CN-001305 | CAT III | Webmail must be disabled | Disable WebMail Integration | `FeatureLockDown\cWebmailProfiles\bDisableWebmail` | `1` | Computer |
| V-213136 | AADC-CN-001310 | CAT III | Welcome Screen must be disabled | Welcome Screen on Startup | `FeatureLockDown\cWelcomeScreen\bShowWelcomeScreen` | `0` | Computer |
| V-213137 | AADC-CN-001315 | CAT III | SharePoint and Office 365 access must be disabled | Disable SharePoint & Office 365 Integration | `FeatureLockDown\cSharePoint\bDisableSharePointFeatures` | `1` | Computer |
| V-213138 | AADC-CN-001320 | CAT III | Periodic downloading of Adobe certificates must be disabled | Load Security Settings from Server (Adobe Certificates) | `Security\cDigSig\cAdobeDownload\bLoadSettingsFromURL` | `0` | User |
| V-213139 | AADC-CN-001325 | CAT III | Privileged host locations must be disabled | Lock Trusted Host Sites | `FeatureLockDown\bDisableTrustedSites` | `1` | Computer |

---

## Registry path notes

All Computer-scope policy values sit under:

```
HKLM\Software\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\
```

User-scope values (V-213126, V-213138, V-245874) sit under:

```
HKCU\Software\Adobe\Adobe Acrobat\DC\
```

The Repair Installation value (V-213133) is a non-policy key:

```
HKLM\Software\Adobe\Adobe Acrobat\DC\Installer\DisableMaintenance
  (32-bit on 64-bit Windows: HKLM\SOFTWARE\Wow6432Node\Adobe\Adobe Acrobat\DC\Installer)
```

For **32-bit Acrobat on 64-bit Windows**, the `Software\Policies\` path is mirrored under
`Software\WOW6432Node\Policies\` by the OS. Group Policy and the ADMX template handle both
paths automatically.
