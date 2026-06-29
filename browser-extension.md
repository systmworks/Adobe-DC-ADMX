<p align="center"><a href="https://buymeacoffee.com/systmworks"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="45" alt="Buy me a coffee"></a></p>

> I have spent many, many hours creating and testing this ADMX. If it helps you please consider buying me a Coffee :)

[<- Back to Documentation](README.md)

# Browser Extension Settings

Complete list of 12 policies for the Adobe Acrobat browser extension (Chrome and Edge).

These configure the extension itself, not whether it's installed — installation and force-install
behavior remain controlled by the browser's own policies (`ExtensionInstallForcelist`,
`ExtensionInstallBlocklist`, etc.). The settings here come from the extension's own
`schema.json`, surfaced through each browser's managed-storage policy mechanism rather than
Adobe's `FeatureLockDown` registry namespace used by the rest of this template.

| ![Note](https://img.shields.io/badge/Note-316dca?style=flat-square) |
|------|
| All values are **strings** (`"true"`/`"false"`), not DWORD — a quirk of the browser's managed-storage policy format, unlike every other policy in this template. |
| Registry paths are under each browser's own policy namespace: `HKLM\Software\Policies\Google\Chrome\3rdparty\extensions\efaidnbmnnnibpcajpcglclefindmkaj\policy` (Chrome) and `HKLM\Software\Policies\Microsoft\Edge\3rdparty\extensions\elhekieabhbkpmcefcoobjddigjcaadp\policy` (Edge) — not under `Software\Policies\Adobe\...`. |
| `UsageMeasurement` here is unrelated to the desktop application's own `bUsageMeasurement` preference — they're separate settings for separate products (extension vs. desktop app). |

## Chrome

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Disable Express Features | ``DisableExpress`` | Disables Adobe Express features (such as Edit Image) in the extension. |
| Disable GenAI Features | ``DisableGenAI`` | Disables generative AI features in the extension. |
| Disable What's New Auto-Open | ``DisableWhatsNewAutoOpen`` | Stops the What's New page from automatically opening when the extension updates. |
| Open Help Tab on Install | ``OpenHelpx`` | Controls whether the extension opens its help/onboarding tab automatically. |
| Uninstall Popup for Free Users | ``UninstallPopup`` | Controls whether free-plan users see an uninstall prompt popup. |
| Usage Analytics | ``UsageMeasurement`` | Controls whether the extension collects and sends usage analytics. |

## Microsoft Edge

| ![FriendlyName](https://img.shields.io/badge/FriendlyName-316dca?style=flat-square) | ![ValueName](https://img.shields.io/badge/ValueName-316dca?style=flat-square) | ![Summary](https://img.shields.io/badge/Summary-316dca?style=flat-square) |
|---|---|---|
| Disable Express Features | ``DisableExpress`` | Disables Adobe Express features (such as Edit Image) in the extension. |
| Disable GenAI Features | ``DisableGenAI`` | Disables generative AI features in the extension. |
| Disable What's New Auto-Open | ``DisableWhatsNewAutoOpen`` | Stops the What's New page from automatically opening when the extension updates. |
| Open Help Tab on Install | ``OpenHelpx`` | Controls whether the extension opens its help/onboarding tab automatically. |
| Uninstall Popup for Free Users | ``UninstallPopup`` | Controls whether free-plan users see an uninstall prompt popup. |
| Usage Analytics | ``UsageMeasurement`` | Controls whether the extension collects and sends usage analytics. |

**Sharing & responsibility** — Built for the community, shared with good intentions. Use at your own risk. The author accepts no responsibility for any outcomes resulting from the use of these files. Always verify registry paths and values, and test in a safe environment first. If you find an issue or have a suggestion, contributions are welcome.
