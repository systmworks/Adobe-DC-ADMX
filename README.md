<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

# Adobe DC ADMX/ADML Documentation

Detailed policy reference pages, changelogs, and curated guides live under [Documentation/](Documentation/).

> [!WARNING]
> **Migrating from v2.x or User ADMX v1.x is a breaking change.** The combined namespace and re-organised tree mean **Intune ADMX backups/exports from those versions will not import into v3.2**.
>
> Convert them first with [`Import-Export-ADMX-Policies/Convert-AdobeDcIntuneExportToCombinedV30.ps1`](Import-Export-ADMX-Policies/Convert-AdobeDcIntuneExportToCombinedV30.ps1), then re-import.
>
> See the [ADMX install guide](ADMX/readme.md) for migration steps. Upgrading from combined v3.0/v3.1 to v3.2 keeps the same namespace and policy names; v3.2 reclassifies some **User** policies from toggles to enum/numeric controls (re-select those settings after ADMX re-upload).

## Quick Links

| ![Page](https://img.shields.io/badge/Page-316dca?style=flat-square) | ![Description](https://img.shields.io/badge/Description-316dca?style=flat-square) |
|------|-------------|
| [Acrobat DC Settings (Device)](Documentation/acrobat-settings-device.md) | Machine-scope Acrobat DC policies |
| [Acrobat DC Settings (User)](Documentation/acrobat-settings-user.md) | User-scope Acrobat DC policies |
| [Reader DC Settings (Device)](Documentation/reader-settings-device.md) | Machine-scope Reader DC policies |
| [Reader DC Settings (User)](Documentation/reader-settings-user.md) | User-scope Reader DC policies |
| [Security Hardening (Device)](Documentation/security-hardening-device.md) | Recommended device security configurations |
| [Security Hardening (User)](Documentation/security-hardening-user.md) | Recommended user security configurations |
| [Reduce Nags & Upsells (Device)](Documentation/reduce-nags-device.md) | Device-scope nag and upsell controls |
| [Reduce Nags & Upsells (User)](Documentation/reduce-nags-user.md) | User-scope nag and upsell controls |
| [Changelog (Combined)](Documentation/changelog.md) | Combined device + user version history |
| [Changelog (Device, Retired)](Documentation/changelog-device-retired.md) | Legacy device-side ADMX version history |
| [Changelog (User, Retired)](Documentation/changelog-user-retired.md) | Legacy user-side ADMX version history |
| [Screenshots](Documentation/screenshots.md) | GPMC and Intune screenshots |
| [License](LICENSE.md) | CC BY-SA 4.0 license |

These ADMX/ADML templates (v3.2) provide Group Policy and Intune management of Adobe Acrobat DC and Adobe Reader DC on Windows. A single `AdobeDC.admx`/ADML pair covers machine-level (`HKLM`) and user-level (`HKCU`) policies.

| ![File](https://img.shields.io/badge/File-316dca?style=flat-square) | ![Scope](https://img.shields.io/badge/Scope-316dca?style=flat-square) | ![Policies](https://img.shields.io/badge/Policies-316dca?style=flat-square) |
|------|-------|----------|
| `AdobeDC.admx` + ADML | **Adobe DC** (Computer + User) | 795 (294 machine + 501 user) |

### Computer Configuration tree

- **Acrobat & Reader DC** - shared ``HKLM\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\...`` (Acrobat x86/x64 + modern x64 Reader)
- **Reader DC (32-bit)** - shared ``HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\...`` (legacy 32-bit standalone Reader)
- **Non-Policy Settings** - architecture-specific non-Policies registry paths (64-bit Acrobat/Reader, 32-bit Acrobat, 32-bit Reader)

### User Configuration tree

- **Acrobat DC** / **Reader DC** - ``HKCU`` preferences; leaf names include `` (User)`` suffix

## Important Notes

| ![Note](https://img.shields.io/badge/Note-316dca?style=flat-square) |
|------|
| x64 Reader (Unified Installer) is configured under **Acrobat & Reader DC** (Acrobat hive), not the Reader hive. Configure legacy 32-bit Reader under **Reader DC (32-bit)**. |
| ``HKLM\SOFTWARE\Policies`` is shared across WOW64; lockable policies are not duplicated per architecture. |
| Several ``bToggle*`` policies use inverted registry values (DWORD 0 = feature ON, DWORD 1 = feature OFF). |
| User policies use ``class=`"User`"`` and appear under User Configuration only. |

## Category Overview (Device)

> Counts are product-scoped: settings that apply to both Reader and Acrobat are listed under each product, so Reader + Acrobat column totals are higher than the number of unique settings. The ADMX contains **294** machine policy entries (157 unique machine settings after removing non-ADMX `tBuiltInPermList`; architecture-specific non-policy settings are emitted separately for x64 and x86). Overall template: **294** machine + **501** user = **795** policy entries.

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![Overview](https://img.shields.io/badge/Overview-316dca?style=flat-square) | ![Reader](https://img.shields.io/badge/Reader-316dca?style=flat-square) | ![Acrobat](https://img.shields.io/badge/Acrobat-316dca?style=flat-square) |
|----------|----------|:------:|:-------:|
| Cloud & Connectors | Cloud storage connectors (Box, Dropbox, Google Drive, OneDrive), Document Cloud services, preferences sync, generative AI, and sign-in controls. | 13 | 13 |
| Context, Tools & Search | UI toolbars, context menus, search features, Modern Viewer, tool shortcuts, and editing mode settings. | 12 | 21 |
| Documents, Editing & Accessibility | PDF creation, editing, form handling, accessibility tagging, and document conversion controls. | 4 | 11 |
| Microsoft Purview (MIP) | Machine-level FeatureLockDown policies for Microsoft Purview Information Protection: MIP labelling lockdown, save-time policy checks, sovereign cloud selection, browser auth, double key encryption, and OS auth prompt control. | 6 | 6 |
| Security: Execution & Protection | Sandbox modes (Protected Mode, AppContainer, Protected View), enhanced security, Flash content, and dangerous action blocking. | 15 | 15 |
| Security: Trust & Permissions | Digital signatures, trusted locations, certificate trust, security handlers, and URL access policies. | 19 | 21 |
| Sharing & Features | Adobe Sign, Send & Track, shared reviews, SharePoint/Office 365 integration, WebMail configuration, and cloud signature storage. | 19 | 21 |
| Startup & Experience | Launch messages, notifications, First Time Experience, What's New, Home screen widgets, and feedback prompts. | 15 | 16 |
| Updates & Desktop Integration | Product updater, Chrome extension, Explorer thumbnails, repair options, desktop UI, and deployment settings. | 19 | 21 |
| Upsell | Upgrade prompts, trial purchase dialogs, promotional campaigns, App Center, and purchasable tool visibility. | 5 | 7 |
| **Total** | | **127** | **152** |

## Category Overview (User)

> Counts are product-scoped: settings that apply to both Reader and Acrobat are listed under each product. The ADMX contains **501** user policy entries (243 Reader + 258 Acrobat in these tables).

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![Overview](https://img.shields.io/badge/Overview-316dca?style=flat-square) | ![Reader](https://img.shields.io/badge/Reader-316dca?style=flat-square) | ![Acrobat](https://img.shields.io/badge/Acrobat-316dca?style=flat-square) |
|----------|----------|:------:|:-------:|
| Context, Tools & Search | Cursor and selection tools, hand-tool behavior, filename-as-title, recent files, Modern Viewer/HUD, search, and workflow UI preferences under HKCU. | 19 | 22 |
| Documents, Editing & Accessibility | Page display, zoom and layout defaults, rendering and fonts, commenting, forms, measurement, accessibility color replacement, and editing-related user preferences. | 86 | 89 |
| Microsoft Purview (MIP) | Per-user Microsoft Purview Information Protection (MIP) preferences under HKCU MicrosoftAIP, including document message bar visibility, policy authentication, and debug logging. | 3 | 3 |
| Security: Execution & Protection | User-level execution controls such as 3D/multimedia trust, JavaScript debugger and menu behavior, FIPS mode, and related HKCU security execution settings. | 8 | 13 |
| Security: Trust & Permissions | Digital signatures, certificate and timestamp validation, OCSP/CRL behavior, trust-manager URL permissions, and other HKCU signing and trust preferences. | 76 | 77 |
| Sharing & Features | Collaboration, Send & Track, shared reviews, cloud sharing hooks, and related feature toggles stored as per-user preferences. | 9 | 11 |
| Startup & Experience | Splash screen, launch alerts, onboarding and What's New dialogs, home-screen widgets, notifications, and first-run experience controls. | 29 | 29 |
| Updates & Desktop Integration | Product updater behavior, browser and Fast Web View integration, background download, thumbnails/shell integration, and desktop UI preferences. | 11 | 11 |
| Upsell | Upgrade prompts, trial purchase dialogs, promotional surfaces, App Center visibility, and purchasable-tool upsell controls. | 2 | 3 |
| **Total** | | **243** | **258** |

**Sharing & responsibility** - Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.