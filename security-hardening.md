<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](README.md)

# Security Hardening Guide

Recommended and optional security settings for the v2.16 ADMX templates. These complement (but do not replace) Adobe's own [Application Security Guide](https://www.adobe.com/devnet-docs/acrobatetk/tools/AppSec/index.html).

- ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) settings most organisations should apply; minimal workflow impact.
- ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) stronger hardening that may break specific features or workflows.

## Reader DC

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
| Cloud & Connectors | Services & Web-Plugin Updates | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Third-Party Cloud Connectors | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | 3D Content in PDFs | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | AppContainer Sandbox | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Block JavaScript Execution | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Block PDF Link Actions | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Enhanced Security in Browser | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Enhanced Security Standalone | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Flash Content in PDFs | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Protected Mode Sandbox | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Unlisted Attachment Type Permissions | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) - Prompt without ability to allow | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Trust & Permissions | Allow Password Caching | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Trust & Permissions | Disable IE Trusted Sites as Privileged Locations | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Lock Trusted Folders and Files | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Lock Trusted Host Sites | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Unknown URL Access Policy | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) - Always ask | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Sharing & Features | Adobe Acrobat Sign | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Sharing & Features | Adobe Send & Track | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Sharing & Features | Disable SharePoint & Office 365 Integration | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Sharing & Features | Disable WebMail Integration | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Sharing & Features | Document Cloud Review Service | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Sharing & Features | Save Signature to Cloud | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Sharing & Features | Send & Track Outlook Plugin | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |

## Acrobat DC

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
| Cloud & Connectors | Services & Web-Plugin Updates | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Third-Party Cloud Connectors | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Context, Tools & Search | Cloud Search Token Caching | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Context, Tools & Search | Cloud-Powered Search | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Documents, Editing & Accessibility | Block EMF to PDF Conversion | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Documents, Editing & Accessibility | Block XPS to PDF Conversion | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Execution & Protection | 3D Content in PDFs | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Block JavaScript Execution | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Block PDF Link Actions | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Enhanced Security in Browser | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Enhanced Security Standalone | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Flash Content in PDFs | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Protected View Mode | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) - Enable for unsafe locations only | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Unlisted Attachment Type Permissions | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) - Prompt without ability to allow | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Trust & Permissions | Allow Password Caching | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Trust & Permissions | Disable IE Trusted Sites as Privileged Locations | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Lock Trusted Folders and Files | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Lock Trusted Host Sites | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Unknown URL Access Policy | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) - Always ask | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Sharing & Features | Adobe Acrobat Sign | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Sharing & Features | Adobe Send & Track | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Sharing & Features | Disable SharePoint & Office 365 Integration | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Sharing & Features | Disable WebMail Integration | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Sharing & Features | Document Cloud Review Service | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Sharing & Features | Save Signature to Cloud | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Sharing & Features | Send & Track Outlook Plugin | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |

**Sharing & responsibility** — Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.