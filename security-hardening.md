[<- Back to Documentation](README.md)

<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

# Security Hardening Guide

Recommended and optional security settings for the v2.7 ADMX templates. These complement (but do not replace) Adobe's own [Application Security Guide](https://www.adobe.com/devnet-docs/acrobatetk/tools/AppSec/index.html).

- ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) settings most organisations should apply; minimal workflow impact.
- ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) stronger hardening that may break specific features or workflows.

## Reader DC

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![Hardened Value](https://img.shields.io/badge/Hardened%20Value-316dca?style=flat-square) | ![Recommendation](https://img.shields.io/badge/Recommendation-316dca?style=flat-square) |
|---|---|---|---|
| Cloud & Connectors | Box Cloud Connector | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Document Cloud Services | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Document Cloud Storage | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Dropbox Cloud Connector | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Enable Generative AI | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Google Drive Connector | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | OneDrive Connector | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Third-Party Cloud Connectors | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | AppContainer Sandbox | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Block PDF Link Actions | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Enhanced Security in Browser | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Enhanced Security Standalone | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Flash Content in PDFs | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Protected Mode Sandbox | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Trust & Permissions | Allow Password Caching | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Trust & Permissions | Disable IE Trusted Sites as Privileged Locations | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Lock Trusted Folders and Files | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Lock Trusted Host Sites | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Unknown URL Access Policy | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) - Always ask | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |

## Acrobat DC

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![Hardened Value](https://img.shields.io/badge/Hardened%20Value-316dca?style=flat-square) | ![Recommendation](https://img.shields.io/badge/Recommendation-316dca?style=flat-square) |
|---|---|---|---|
| Cloud & Connectors | Box Cloud Connector | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Document Cloud Services | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Document Cloud Storage | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Dropbox Cloud Connector | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Enable Generative AI | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Google Drive Connector | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | OneDrive Connector | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Cloud & Connectors | Third-Party Cloud Connectors | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Context, Tools & Search | Cloud Search Token Caching | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Context, Tools & Search | Cloud-Powered Search | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Documents, Editing & Accessibility | Block EMF to PDF Conversion | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Documents, Editing & Accessibility | Block XPS to PDF Conversion | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Execution & Protection | Block PDF Link Actions | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Enhanced Security in Browser | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Enhanced Security Standalone | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Flash Content in PDFs | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Execution & Protection | Protected View Mode | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) - Enable for unsafe locations only | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Trust & Permissions | Allow Password Caching | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |
| Security: Trust & Permissions | Disable IE Trusted Sites as Privileged Locations | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Lock Trusted Folders and Files | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Lock Trusted Host Sites | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) | ![Optional](https://img.shields.io/badge/Optional-1f6feb?style=flat-square) |
| Security: Trust & Permissions | Unknown URL Access Policy | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) - Always ask | ![Recommended](https://img.shields.io/badge/Recommended-238636?style=flat-square) |