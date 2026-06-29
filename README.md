<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

# Adobe DC ADMX/ADML Documentation

## Quick Links

| ![Page](https://img.shields.io/badge/Page-316dca?style=flat-square) | ![Description](https://img.shields.io/badge/Description-316dca?style=flat-square) |
|------|-------------|
| [Reader DC Settings](reader-settings.md) | Complete list of all Reader DC policies |
| [Acrobat DC Settings](acrobat-settings.md) | Complete list of all Acrobat DC policies |
| [Security Hardening](security-hardening.md) | Recommended and optional security configurations |
| [Reduce Nags & Upsells](reduce-nags.md) | Settings to suppress unwanted messages, popups, and promotions |
| [Screenshots](screenshots.md) | GPMC and Intune screenshots showing policy configuration |
| [Changelog](changelog.md) | Settings changes across ADMX versions |

These ADMX/ADML templates (v3.1) provide Group Policy and Intune management of Adobe Acrobat DC and Adobe Reader DC on Windows. They define both machine-level (`HKLM`) and user-level (`HKCU`) policies covering cloud connectors, security hardening, trust and permissions, UI experience, updates, and upsell controls.

The full policy set now ships as a single **combined** ``AdobeDC.admx``/ADML pair, covering Reader DC and Acrobat DC across both x86 and x64, plus all user-level policies:

| ![File](https://img.shields.io/badge/File-316dca?style=flat-square) | ![Scope](https://img.shields.io/badge/Scope-316dca?style=flat-square) | ![Policies](https://img.shields.io/badge/Policies-316dca?style=flat-square) |
|------|-------|----------|
| `AdobeDC.admx` + ADML | Reader DC (x86 + x64) and Acrobat DC (x86 + x64), Computer and User scope | 560 Machine + 495 User = 1,055 |

Deploy the one combined file — it covers every architecture, both products, and both Computer and User Configuration.

## Important Notes

| ![Note](https://img.shields.io/badge/Note-316dca?style=flat-square) |
|------|
| Acrobat Reader (x64) using the new **Unified Installer** runs ``Acrobat.exe``, so it requires configuration of the **Acrobat** settings rather than the Reader settings. To be safe, configure both. 32-bit Reader still uses its own legacy registry hive. |
| Several ``bToggle*`` policies use inverted registry values (DWORD 0 = feature ON, DWORD 1 = feature OFF). The ADMX templates handle this so that the Group Policy **Enabled**/**Disabled** states match the FriendlyName intent, but raw registry checks may look counterintuitive. |
| Adobe ARM (the background update service) is always a 32-bit process and writes to `SOFTWARE\WOW6432Node\Adobe\Adobe ARM\...`, even on x64 deployments. |
| User-scope policies are marked `class="User"` so they appear only under *User Configuration*, not *Computer Configuration*. |

## Category Overview

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![Overview](https://img.shields.io/badge/Overview-316dca?style=flat-square) | ![Reader](https://img.shields.io/badge/Reader-316dca?style=flat-square) | ![Acrobat](https://img.shields.io/badge/Acrobat-316dca?style=flat-square) |
|----------|----------|:------:|:-------:|
| Cloud & Connectors | Cloud storage connectors (Box, Dropbox, Google Drive, OneDrive), Document Cloud services, preferences sync, generative AI, and sign-in controls. | 13 | 13 |
| Context, Tools & Search | UI toolbars, context menus, search features, Modern Viewer, tool shortcuts, and editing mode settings. | 12 | 21 |
| Documents, Editing & Accessibility | PDF creation, editing, form handling, accessibility tagging, and document conversion controls. | 4 | 11 |
| Microsoft Purview (MIP) | Machine-level FeatureLockDown policies for Microsoft Purview Information Protection: MIP labelling lockdown, save-time policy checks, sovereign cloud selection, browser auth, double key encryption, and OS auth prompt control. | 6 | 6 |
| Security: Execution & Protection | Sandbox modes (Protected Mode, AppContainer, Protected View), enhanced security, Flash content, and dangerous action blocking. | 16 | 16 |
| Security: Trust & Permissions | Digital signatures, trusted locations, certificate trust, security handlers, and URL access policies. | 19 | 20 |
| Sharing & Features | Adobe Sign, Send & Track, shared reviews, SharePoint/Office 365 integration, WebMail configuration, Acrobat.com file storage, and cloud signature storage. | 20 | 22 |
| Startup & Experience | Launch messages, notifications, First Time Experience, Welcome screen, What's New, Home screen widgets, and feedback prompts. | 14 | 15 |
| Updates & Desktop Integration | Product updater, Chrome extension, Explorer thumbnails, repair options, desktop UI, and deployment settings. | 19 | 21 |
| Upsell | Upgrade prompts, trial purchase dialogs, promotional campaigns, App Center, and purchasable tool visibility. | 5 | 7 |

Counts above are machine-scope only — see [Reader DC Settings](reader-settings.md) and [Acrobat DC Settings](acrobat-settings.md) for the full per-policy lists. User-scope policies (495 total) ship in the same file but are not broken out by category here.

## Deployment

### Intune

1. *Devices → Configuration → + Create → Import ADMX* — upload `AdobeDC.admx`, then `AdobeDC.adml` for `en-US`.
2. Create configuration profiles using *Administrative Templates*:
   - Computer Configuration policies → *Devices → Configuration → + Create → Templates → Administrative Templates*
   - User Configuration policies → *Users → Configuration → + Create → Templates → Administrative Templates*

### Group Policy (GPMC / gpedit.msc)

Copy `AdobeDC.admx` and `en-US/AdobeDC.adml` to your Central Store or local policy folder:

```
C:\Windows\SYSVOL\domain\Policies\PolicyDefinitions\AdobeDC.admx
C:\Windows\SYSVOL\domain\Policies\PolicyDefinitions\en-US\AdobeDC.adml
```

Policies appear under:
- *Computer Configuration → Administrative Templates → Adobe → Adobe Acrobat DC*
- *User Configuration → Administrative Templates → Adobe → Adobe Acrobat DC (User)*

**Sharing & responsibility** — Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
