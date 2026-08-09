<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](../README.md)

# Browser Extension Settings

Complete list of 6 unique Adobe Acrobat browser extension managed-storage settings in the combined v4.0 ADMX templates (12 policy entries: 6 per browser).

| ![Note](https://img.shields.io/badge/Note-316dca?style=flat-square) |
|------|
| These configure the Adobe Acrobat extension itself, not whether it is installed. Installation remains controlled by each browser's own extension policies. |
| Values are **REG_SZ** strings (`true`/`false`), not DWORD - unlike every other policy in this template. |
| Registry paths are under each browser's 3rdparty extension policy namespace, not under `Software\Policies\Adobe\...`. |
| Extension `UsageMeasurement` here is unrelated to the desktop application's `bUsageMeasurement` preference. |
| If Edge force-installs the extension from the Chrome Web Store, policy may instead be under extension ID `efaidnbmnnnibpcajpcglclefindmkaj` under the Edge path - not covered by this template. |

## Settings

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Enabled](https://img.shields.io/badge/Enabled-316dca?style=flat-square) | ![Disabled](https://img.shields.io/badge/Disabled-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|---|---|
| Disable Express Features | ``DisableExpress`` | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) -> REG_SZ `true` | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) -> REG_SZ `false` | Disables Adobe Express features (such as Edit Image) in the extension. |
| Disable Extension Usage Analytics | ``UsageMeasurement`` | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) -> REG_SZ `false` | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) -> REG_SZ `true` | Controls whether the Adobe Acrobat browser extension collects and sends usage analytics. |
| Disable Generative AI Features | ``DisableGenAI`` | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) -> REG_SZ `true` | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) -> REG_SZ `false` | Disables generative AI features in the Adobe Acrobat browser extension. |
| Disable Help Tab on Install | ``OpenHelpx`` | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) -> REG_SZ `false` | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) -> REG_SZ `true` | Controls whether the extension opens its help or onboarding tab automatically on install. |
| Disable Uninstall Popup for Free Users | ``UninstallPopup`` | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) -> REG_SZ `false` | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) -> REG_SZ `true` | Controls whether free-plan users see an uninstall prompt popup in the extension. |
| Disable What's New Auto-Open | ``DisableWhatsNewAutoOpen`` | Set to ![Enabled](https://img.shields.io/badge/Enabled-238636?style=flat-square) -> REG_SZ `true` | Set to ![Disabled](https://img.shields.io/badge/Disabled-f85149?style=flat-square) -> REG_SZ `false` | Stops the What's New page from automatically opening when the extension updates. |

## Registry keys

- **Google Chrome:** `HKLM\SOFTWARE\Policies\Google\Chrome\3rdparty\extensions\efaidnbmnnnibpcajpcglclefindmkaj\policy`
- **Microsoft Edge:** `HKLM\SOFTWARE\Policies\Microsoft\Edge\3rdparty\extensions\elhekieabhbkpmcefcoobjddigjcaadp\policy`

Verify applied policy in `chrome://policy` or `edge://policy` under the extension ID after GPO or Intune deployment.

**Sharing & responsibility** - Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.