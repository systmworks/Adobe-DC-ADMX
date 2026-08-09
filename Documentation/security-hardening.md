<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](../README.md)

# Security Hardening

Recommended and optional security settings for the combined v4.0 ADMX templates.

- ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) settings most organisations should apply.
- ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) stronger hardening that may affect workflows.

- Settings marked ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) are under **Adobe DC > Non-Policy Settings** in Group Policy or Intune, not under **Adobe DC > Acrobat & Reader DC**. Configure the sub-node that matches your installed architecture: **Acrobat & Reader DC (64-bit)** (64-bit Acrobat and unified 64-bit Reader), **Acrobat DC (32-bit)** (32-bit Acrobat), or **Reader DC (32-bit)** (32-bit Reader).

## Device

### Common to Acrobat & Reader

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![Hardened Value](https://img.shields.io/badge/Hardened%20Value-316dca?style=flat-square) | ![Recommendation](https://img.shields.io/badge/Recommendation-316dca?style=flat-square) |
|---|---|---|---|
| Cloud & Connectors | Adobe Fill & Sign | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Cloud & Connectors | Box Cloud Connector | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Document Cloud Services | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Document Cloud Storage | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Dropbox Cloud Connector | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Generative AI Technology | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Google Drive Connector | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | OneDrive Connector | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Preferences Synchronization | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Third-Party Cloud Connectors | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | 3D Content in PDFs | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | AppContainer Sandbox | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Attachment Extension Blocklist in Dialogs | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Block JavaScript Execution | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Block non-PDF file attachments | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Block PDF Link Actions | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Enhanced Security in Browser | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Enhanced Security Standalone | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Flash Content in PDFs | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Protected Mode Sandbox | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Protected View Mode | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) - Enable Protected View for unsafe locations only | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Unlisted Attachment Type Permissions | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) - Prompt without ability to allow (most restrictive prompt) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Trust & Permissions | Allow Password Caching | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Trust & Permissions | Disable IE Trusted Sites as Privileged Locations | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Lock Trusted Folders and Files | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Lock Trusted Host Sites | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Trust Certified Documents | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Unknown URL Access Policy | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) - Always ask | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Trust & Permissions | Validate Signatures on Open | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Sharing & Features | Adobe Acrobat Sign | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Sharing & Features | Adobe Send & Track | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Sharing & Features | Disable SharePoint & Office 365 Integration | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Sharing & Features | Disable WebMail Integration | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Sharing & Features | Document Cloud Review Service | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Sharing & Features | Save Signature to Cloud | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Sharing & Features | Send & Track Outlook Plugin | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Startup & Experience | Disable Welcome Screen | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Startup & Experience | Usage Measurement (legacy) | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Updates & Desktop Integration | Product Updater | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |

- **Trust Certified Documents** - Does not apply in Protected View.
- **Validate Signatures on Open** - Locks the HKCU setting and user interface rather than configuring the feature itself.
- **Usage Measurement (legacy)** - DWORD 0 also disables the welcome screen at launch. Also listed on Suppress Nags and Upsells.

### Acrobat Only

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![Hardened Value](https://img.shields.io/badge/Hardened%20Value-316dca?style=flat-square) | ![Recommendation](https://img.shields.io/badge/Recommendation-316dca?style=flat-square) |
|---|---|---|---|
| Context, Tools & Search | Cloud Search Token Caching | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Context, Tools & Search | Cloud-Powered Search | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Documents, Editing & Accessibility | Block EMF to PDF Conversion ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Documents, Editing & Accessibility | Block XPS to PDF Conversion ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Disable Acrobat.com File Storage | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |

## User

### Common to Acrobat & Reader

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![Hardened Value](https://img.shields.io/badge/Hardened%20Value-316dca?style=flat-square) | ![Recommendation](https://img.shields.io/badge/Recommendation-316dca?style=flat-square) |
|---|---|---|---|
| Security: Execution & Protection | 3D Content Trust | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Execution & Protection | Enable JS Debugger | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Execution & Protection | FIPS Mode | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | JS Global Security | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Execution & Protection | JS Menu Items | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Execution & Protection | Outlook Protected View | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Accept Expired Timestamps | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Allow LiveCycle HTTP | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Load Security Settings from Server (Adobe Certificates) | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Trust & Permissions | Load Security Settings from Server (European Certificates) | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Trust & Permissions | Open Non-PDF Attachments | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Secure Open Attachments | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |

**Sharing & responsibility** - Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.