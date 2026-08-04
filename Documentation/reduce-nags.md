<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](../README.md)

# Suppress Nags & Upsells

Settings to suppress unwanted messages, popups, and promotions, plus the toolbars, panels, HUD bar, splash and welcome screens, and onboarding coachmarks that open automatically - for organisations that prefer a clean, uncluttered reading view.

- Settings marked ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) are under **Adobe DC > Non-Policy Settings** in Group Policy or Intune, not under **Adobe DC > Acrobat & Reader DC**. Configure the sub-node that matches your installed architecture: **Acrobat & Reader DC (64-bit)** (64-bit Acrobat and unified 64-bit Reader), **Acrobat DC (32-bit)** (32-bit Acrobat), or **Reader DC (32-bit)** (32-bit Reader).

## Device

### Common to Acrobat & Reader

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![Recommended Setting](https://img.shields.io/badge/Recommended%20Setting-316dca?style=flat-square) |
|---|---|---|
| Context, Tools & Search | Contextual Help Tips | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Context, Tools & Search | Contextual Toolbar | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Context, Tools & Search | Modern Viewer | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Context, Tools & Search | Online Actions Library Link | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Context, Tools & Search | Online Tool Set Exchange Link | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Sharing & Features | Show Acrobat Sign Tracking Tab | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Adobe Messages at Launch | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Allow Users to Change Message Preferences | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Desktop Notifications | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Disable Welcome Screen | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Startup & Experience | First Time Experience | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Hide Adobe Messages on Document Open | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Startup & Experience | Hide In-Product Notifications Bell | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Startup & Experience | Hide Send Feedback Icon | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Startup & Experience | Home Screen To Do List | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Scan Tab in Home View | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Show Desktop Notification Toasts | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Show PDF Ownership Notification | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Show To Do Cards in Recent Tab | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Usage Measurement (legacy) | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | What's New Experience | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Updates & Desktop Integration | Auto Dock HUD Bar | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Updates & Desktop Integration | Disable Repair for All Users ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Updates & Desktop Integration | Disable Repair for Standard Users ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Updates & Desktop Integration | Hide Document Message Bar | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Updates & Desktop Integration | Lock Default PDF Viewer | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Updates & Desktop Integration | Patch Cache Cleanup | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Updates & Desktop Integration | Product Updater | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Upsell | Disable Promotional Campaign Messages | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Upsell | Limit Informational Prompts | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Upsell | Show App Center UI | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Upsell | Show Upgrade Prompts | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |

- **Usage Measurement (legacy)** - Also stops all usage data collection sent to Adobe, including dialog analytics that Hide Send Feedback Icon does not cover. Also listed on Security Hardening.
- **Hide Document Message Bar** - Hides the document message bar, including Protected View and trust prompts. Adobe documents that this adversely affects signing when preview mode is used.

### Acrobat Only

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![Recommended Setting](https://img.shields.io/badge/Recommended%20Setting-316dca?style=flat-square) |
|---|---|---|
| Sharing & Features | Share and Review Reminder Tip | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Reader mode on Acrobat (Unified x64) | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Updates & Desktop Integration | Crash Reporter Dialog | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Updates & Desktop Integration | Disable Major Version Upgrade Prompt (32-bit Updater) ![Non-Policy](https://img.shields.io/badge/Non--Policy-8250df?style=flat-square) | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Upsell | Disable Billing Issue Call to Action | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Upsell | Express Templates in Create PDF | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Upsell | Trial Purchase Prompt | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |

### Reader Only

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![Recommended Setting](https://img.shields.io/badge/Recommended%20Setting-316dca?style=flat-square) |
|---|---|---|
| Updates & Desktop Integration | Prompt to Use Acrobat from Reader | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Upsell | Prompt Reader Users to Download Acrobat | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Upsell | Show Purchasable Tools in Search | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |

## User

### Common to Acrobat & Reader

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![Recommended Setting](https://img.shields.io/badge/Recommended%20Setting-316dca?style=flat-square) |
|---|---|---|
| Context, Tools & Search | New Look Coachmark | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Context, Tools & Search | Pin HUD Toolbar | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Context, Tools & Search | Show Tool Pane Tips | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Context, Tools & Search | Tools Pane State | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) - Always closed |
| Context, Tools & Search | Tools Pane Sticky | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) - Don't remember the Tool Pane's state (always closed on launch) |
| Context, Tools & Search | Try New Coachmark | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Context, Tools & Search | UI Switcher Sessions | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Documents, Editing & Accessibility | Form Email Prompt | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Create Form Onboarding | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Edit Onboarding | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Fill & Sign Onboarding | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Hide Help Welcome | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Startup & Experience | Home Onboarding | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Organize Onboarding | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Redaction Onboarding | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Show About Dialog | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Show Getting Started | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Show Skip Card | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Show Splash Screen | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Startup & Experience | Viewer Onboarding | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Upsell | Acrobat App Promo | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Upsell | Scan App Promo | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |

- **Tools Pane Sticky** - Pair with Tools Pane State for a consistently closed Tools pane on launch.

### Acrobat Only

| ![Category](https://img.shields.io/badge/Category-316dca?style=flat-square) | ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![Recommended Setting](https://img.shields.io/badge/Recommended%20Setting-316dca?style=flat-square) |
|---|---|---|
| Context, Tools & Search | Suppress PDF/UA Dialog | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) |
| Sharing & Features | Show Review Tip | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Sharing & Features | Show Share Tip | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |
| Upsell | Show Trial Nag | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) |

**Sharing & responsibility** - Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.