# Adobe DC ADMX/ADML Documentation

These ADMX/ADML templates (v2.5) provide Group Policy and Intune management of Adobe Acrobat DC and Adobe Reader DC on Windows. They define machine-level (`HKLM`) policies covering cloud connectors, security hardening, trust and permissions, UI experience, updates, and upsell controls.

The templates ship in two namespaces:

| ![File](https://img.shields.io/badge/File-316dca?style=flat-square) | ![Scope](https://img.shields.io/badge/Scope-316dca?style=flat-square) | ![Policies](https://img.shields.io/badge/Policies-316dca?style=flat-square) |
|------|-------|----------|
| `AdobeDC_x64.admx` + ADML | Acrobat DC (x64) + Reader DC (x64) | 248 (136 Acrobat + 112 Reader) |
| `AdobeDC_x86.admx` + ADML | Acrobat DC (x86) + Reader DC (x86) | 248 (136 Acrobat + 112 Reader) |

> **Note:** Several ``bToggle*`` policies use inverted registry values (DWORD 0 = feature ON, DWORD 1 = feature OFF). The ADMX templates handle this so that the Group Policy **Enabled**/**Disabled** states match the FriendlyName intent, but raw registry checks may look counterintuitive.

> **x86 templates:** The ``AdobeDC_x86`` template targets 32-bit Adobe applications on 64-bit Windows. Both Acrobat and Reader x86 registry paths are derived programmatically by inserting ``WOW6432Node`` into the native paths stored in the CSV.

## Quick Links

| ![Page](https://img.shields.io/badge/Page-316dca?style=flat-square) | ![Description](https://img.shields.io/badge/Description-316dca?style=flat-square) |
|------|-------------|
| [Reader DC Settings](reader-settings.md) | Complete list of all Reader DC policies |
| [Acrobat DC Settings](acrobat-settings.md) | Complete list of all Acrobat DC policies |
| [Security Hardening](security-hardening.md) | Recommended and optional security configurations |
| [Reduce Nags & Upsells](reduce-nags.md) | Settings to suppress unwanted messages, popups, and promotions |

## Category Overview

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![Overview](https://img.shields.io/badge/Overview-316dca?style=flat-square) | ![Reader](https://img.shields.io/badge/Reader-316dca?style=flat-square) | ![Acrobat](https://img.shields.io/badge/Acrobat-316dca?style=flat-square) |
|----------|----------|:------:|:-------:|
| Cloud & Connectors | Cloud storage connectors (Box, Dropbox, Google Drive, OneDrive), Document Cloud services, preferences sync, generative AI, and sign-in controls. | 13 | 13 |
| Context, Tools & Search | UI toolbars, context menus, search features, Modern Viewer, tool shortcuts, and editing mode settings. | 12 | 22 |
| Documents, Editing & Accessibility | PDF creation, editing, form handling, accessibility tagging, and document conversion controls. | 3 | 12 |
| Security: Execution & Protection | Sandbox modes (Protected Mode, AppContainer, Protected View), enhanced security, Flash content, and dangerous action blocking. | 10 | 9 |
| Security: Trust & Permissions | Digital signatures, trusted locations, certificate trust, security handlers, and URL access policies. | 19 | 20 |
| Sharing & Features | Adobe Sign, Send & Track, shared reviews, SharePoint/Office 365 integration, WebMail configuration, and cloud signature storage. | 20 | 22 |
| Startup & Experience | Launch messages, notifications, First Time Experience, What's New, Home screen widgets, and feedback prompts. | 13 | 12 |
| Updates & Desktop Integration | Product updater, Chrome extension, Explorer thumbnails, repair options, desktop UI, and deployment settings. | 17 | 19 |
| Upsell | Upgrade prompts, trial purchase dialogs, promotional campaigns, App Center, and purchasable tool visibility. | 5 | 7 |