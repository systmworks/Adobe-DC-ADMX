# Adobe DC ADMX/ADML Documentation

<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

## Quick Links

| ![Page](https://img.shields.io/badge/Page-316dca?style=flat-square) | ![Description](https://img.shields.io/badge/Description-316dca?style=flat-square) |
|------|-------------|
| [Reader DC Settings](reader-settings.md) | Complete list of all Reader DC policies |
| [Acrobat DC Settings](acrobat-settings.md) | Complete list of all Acrobat DC policies |
| [Security Hardening](security-hardening.md) | Recommended and optional security configurations |
| [Reduce Nags & Upsells](reduce-nags.md) | Settings to suppress unwanted messages, popups, and promotions |
| [Screenshots](screenshots.md) | GPMC and Intune screenshots showing policy configuration |
| [Changelog](changelog.md) | Settings changes across ADMX versions |

These ADMX/ADML templates (v2.15) provide Group Policy and Intune management of Adobe Acrobat DC and Adobe Reader DC on Windows. They define machine-level (`HKLM`) policies covering cloud connectors, security hardening, trust and permissions, UI experience, updates, and upsell controls.

A new combined ADMX file (`AdobeDC.admx`) is now provided alongside the existing per-architecture files. Deploy the combined file if you manage both 32-bit and 64-bit installations, or use the individual x64/x86 files to target one or both architectures. The x86 and x64 files can be deployed together, but **do not deploy them alongside the combined file** — this will create duplicate policy entries in Group Policy.

| ![ADMX File](https://img.shields.io/badge/ADMX_File-316dca?style=flat-square) | ![Products & Architectures](https://img.shields.io/badge/Products_&_Architectures-316dca?style=flat-square) | ![Policies](https://img.shields.io/badge/Policies-316dca?style=flat-square) |
|------|-------|----------|
| `AdobeDC.admx` | Reader DC (x86 + x64) and Acrobat DC (x86 + x64) | 520 |
| `AdobeDC_x64.admx` | Reader DC (x64) and Acrobat DC (x64) | 260 |
| `AdobeDC_x86.admx` | Reader DC (x86) and Acrobat DC (x86) | 260 |

## Important Notes

| ![Note](https://img.shields.io/badge/Note-316dca?style=flat-square) |
|------|
| Acrobat Reader (x64) using the new **Unified Installer** runs ``Acrobat.exe``, so it requires configuration of the **Acrobat** settings rather than the Reader settings. To be safe, configure both. |
| Several ``bToggle*`` policies use inverted registry values (DWORD 0 = feature ON, DWORD 1 = feature OFF). The ADMX templates handle this so that the Group Policy **Enabled**/**Disabled** states match the FriendlyName intent, but raw registry checks may look counterintuitive. |

## Category Overview

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![Overview](https://img.shields.io/badge/Overview-316dca?style=flat-square) | ![Reader](https://img.shields.io/badge/Reader-316dca?style=flat-square) | ![Acrobat](https://img.shields.io/badge/Acrobat-316dca?style=flat-square) |
|----------|----------|:------:|:-------:|
| Cloud & Connectors | Cloud storage connectors (Box, Dropbox, Google Drive, OneDrive), Document Cloud services, preferences sync, generative AI, and sign-in controls. | 13 | 13 |
| Context, Tools & Search | UI toolbars, context menus, search features, Modern Viewer, tool shortcuts, and editing mode settings. | 12 | 21 |
| Documents, Editing & Accessibility | PDF creation, editing, form handling, accessibility tagging, and document conversion controls. | 4 | 11 |
| Security: Execution & Protection | Sandbox modes (Protected Mode, AppContainer, Protected View), enhanced security, Flash content, and dangerous action blocking. | 15 | 13 |
| Security: Trust & Permissions | Digital signatures, trusted locations, certificate trust, security handlers, and URL access policies. | 19 | 20 |
| Sharing & Features | Adobe Sign, Send & Track, shared reviews, SharePoint/Office 365 integration, WebMail configuration, and cloud signature storage. | 19 | 21 |
| Startup & Experience | Launch messages, notifications, First Time Experience, What's New, Home screen widgets, and feedback prompts. | 13 | 14 |
| Updates & Desktop Integration | Product updater, Chrome extension, Explorer thumbnails, repair options, desktop UI, and deployment settings. | 19 | 21 |
| Upsell | Upgrade prompts, trial purchase dialogs, promotional campaigns, App Center, and purchasable tool visibility. | 5 | 7 |

---

**Sharing & Responsibility** — Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.