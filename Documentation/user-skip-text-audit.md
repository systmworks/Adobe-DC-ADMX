# User REG_SZ Skip-row audit (v3.3)

Audit of user-scope `ControlType=Skip` rows with `DataType=REG_SZ`. Disposition applied in v3.3 unless noted.

| ValueName | Category | Disposition | Reason |
|-----------|----------|-------------|--------|
| tBaseFolderName | Context, Tools & Search | Keep Skip | Folder alias (`install`/`user`/custom path picker), not a plain URL |
| tServerURL | Security: Trust & Permissions | **Adopt as Text** | Admin-configurable default server URL |
| xDefEnrollmentURL | Security: Trust & Permissions | **Adopt as Text** | Admin-configurable enrollment URL |
| tServer | Security: Trust & Permissions | **Adopt as Text** | Admin-configurable server name |
| tURL | Security: Trust & Permissions | **Adopt as Text** | Admin-configurable URL |
| tSAML_Assertion_Source | Security: Trust & Permissions | **Adopt as Text** | Admin-configurable SAML source URL/path |
| tLastServerURL | Security: Trust & Permissions | Keep Skip | Last-used server URL (app-managed session state) |
| tLast* (other) | various | Keep Skip | Last-used / cache values (`tLast*`) |
| a* font/array prefs | Documents, Editing & Accessibility | Keep Skip | Font arrays / structured lists, not plain text |
| SAML / dictionary / folder pickers | various | Keep Skip | Opaque IDs, blobs, or UI-driven pickers |

**v3.3 adopted:** 5 text policies (`tServerURL`, `xDefEnrollmentURL`, `tServer`, `tURL`, `tSAML_Assertion_Source`).

**Remaining Skip count:** 40 user REG_SZ rows (45 before adoption).

See [changelog](changelog.md#v33---20-july-2026) for full v3.3 changes.
