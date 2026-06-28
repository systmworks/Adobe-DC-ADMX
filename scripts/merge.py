"""
Merge Adobe DC machine ADMX (v2.19) + user ADMX (v1.6) into a single template.

Strategy:
  - Single namespace: Adobe.Policies.AdobeDC  (machine namespace, primary)
  - supportedOn:  machine defs + user defs concatenated
  - categories:   machine categories + user categories (no name collisions; user names end in _User)
  - policies:     machine policies (class=Machine) + user policies (class=User, corrected from Both)
  - ADML strings: machine strings + user strings (no ID collisions; user IDs end in _User)
  - ADML presentations: same, concatenated

Usage:
  python scripts/merge.py [version]

  version  Optional SemVer string (e.g. 3.1.0) stamped into the ADMX revision attribute.
           Defaults to "3.1.0" when omitted.
"""

import re
import sys
from pathlib import Path
from xml.etree import ElementTree as ET

SRC = Path(__file__).parent.parent / "src"
OUT = Path(__file__).parent.parent / "build"
OUT.mkdir(exist_ok=True)

MACHINE_ADMX = SRC / "AdobeDC_machine.admx"
MACHINE_ADML = SRC / "AdobeDC_machine.adml"
USER_ADMX    = SRC / "AdobeDC_user.admx"
USER_ADML    = SRC / "AdobeDC_user.adml"

MERGED_REVISION = sys.argv[1] if len(sys.argv) > 1 else "3.1.0"

NS_MAP = {
    "": "http://schemas.microsoft.com/GroupPolicy/2006/07/PolicyDefinitions",
    "xsd": "http://www.w3.org/2001/XMLSchema",
    "xsi": "http://www.w3.org/2001/XMLSchema-instance",
}

# ── helpers ──────────────────────────────────────────────────────────────────

def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")

def strip_xml_decl(text: str) -> str:
    return re.sub(r"^<\?xml[^?]*\?>\s*", "", text.strip())

def extract_block(text: str, tag: str) -> str:
    """Return everything between <tag ...> and </tag>, inclusive."""
    pattern = rf"(<{tag}[\s>].*?</{tag}>)"
    m = re.search(pattern, text, re.DOTALL)
    if not m:
        raise ValueError(f"Could not find <{tag}> block in source")
    return m.group(1)

def inner_xml(text: str, tag: str) -> str:
    """Return the inner content of the FIRST matching <tag>...</tag>."""
    # (?:\s[^>]*)? handles both <tag> and <tag attr="val">
    pattern = rf"<{tag}(?:\s[^>]*)?>(.+?)</{tag}>"
    m = re.search(pattern, text, re.DOTALL)
    if not m:
        raise ValueError(f"Could not find inner content of <{tag}>")
    return m.group(1)

def check_no_string_collisions(machine_adml: str, user_adml: str) -> None:
    machine_ids = set(re.findall(r'<string id="([^"]+)"', machine_adml))
    user_ids    = set(re.findall(r'<string id="([^"]+)"', user_adml))
    collisions  = machine_ids & user_ids
    if collisions:
        print(f"WARNING: {len(collisions)} string ID collision(s): {sorted(collisions)[:5]} ...", file=sys.stderr)

def check_no_presentation_collisions(machine_adml: str, user_adml: str) -> None:
    machine_ids = set(re.findall(r'<presentation id="([^"]+)"', machine_adml))
    user_ids    = set(re.findall(r'<presentation id="([^"]+)"', user_adml))
    collisions  = machine_ids & user_ids
    if collisions:
        print(f"WARNING: {len(collisions)} presentation ID collision(s): {sorted(collisions)[:5]} ...", file=sys.stderr)

# ── ADMX merge ────────────────────────────────────────────────────────────────

def merge_admx(machine: str, user: str) -> str:
    # --- supportedOn: extract the individual <definition> items (one level inside <definitions>) ---
    sup_machine = inner_xml(inner_xml(machine, "supportedOn"), "definitions").strip()
    sup_user    = inner_xml(inner_xml(user,    "supportedOn"), "definitions").strip()

    # --- categories inner content ---
    cat_machine = inner_xml(machine, "categories").strip()
    cat_user    = inner_xml(user,    "categories").strip()

    # --- policies inner content ---
    pol_machine = inner_xml(machine, "policies").strip()
    # Source user ADMX marks all policies class="Both" (shows in both Computer and
    # User Configuration). They all write to HKCU, so correct to class="User".
    pol_user    = inner_xml(user, "policies").strip().replace('class="Both"', 'class="User"')

    header = f"""<?xml version="1.0" encoding="utf-8"?>
<!-- ================================================================= -->
<!--                                                                   -->
<!--    ADMX templates created by Darren Milne                         -->
<!--    Source: https://github.com/systmworks/Adobe-DC-ADMX/           -->
<!--            https://github.com/systmworks/Adobe-DC-User-ADMX/      -->
<!--                                                                   -->
<!--    Merged: machine (v2.19) + user (v1.6) into a single template   -->
<!--    Merge rationale: Intune custom ADMX upload limit (20 files)    -->
<!--                                                                   -->
<!--    License: CC BY-SA 4.0                                          -->
<!--    Free to use and redistribute, including commercially, with     -->
<!--    attribution; ShareAlike applies to adaptations you distribute. -->
<!--                                                                   -->
<!-- ================================================================= -->

<policyDefinitions xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  revision="{MERGED_REVISION}" schemaVersion="1.0"
  xmlns="http://schemas.microsoft.com/GroupPolicy/2006/07/PolicyDefinitions">
  <policyNamespaces>
    <target prefix="AdobeDC" namespace="Adobe.Policies.AdobeDC" />
  </policyNamespaces>
  <resources minRequiredRevision="{MERGED_REVISION}" />"""

    supported_on = f"""
  <supportedOn>
    <definitions>
      <!-- Machine-scope supported-on definitions (Acrobat DC / Reader DC x86 + x64) -->
{_indent(sup_machine, 6)}

      <!-- User-scope supported-on definitions -->
{_indent(sup_user, 6)}
    </definitions>
  </supportedOn>"""

    categories = f"""
  <categories>
    <!-- ============================================================= -->
    <!--  Machine-scope categories (Computer Configuration)            -->
    <!-- ============================================================= -->
{_indent(cat_machine, 4)}

    <!-- ============================================================= -->
    <!--  User-scope categories (User Configuration)                   -->
    <!-- ============================================================= -->
{_indent(cat_user, 4)}
  </categories>"""

    policies = f"""
  <policies>

    <!-- ============================================================= -->
    <!--  Machine-scope policies (Computer Configuration)              -->
    <!--  Acrobat DC x86 → HKLM\\SOFTWARE\\WOW6432Node\\Policies\\Adobe   -->
    <!--  Acrobat DC x64 → HKLM\\SOFTWARE\\Policies\\Adobe               -->
    <!-- ============================================================= -->
{_indent(pol_machine, 4)}

    <!-- ============================================================= -->
    <!--  User-scope policies (User Configuration)                     -->
    <!--  → HKCU\\Software\\Adobe\\...                                   -->
    <!-- ============================================================= -->
{_indent(pol_user, 4)}

  </policies>"""

    footer = "\n</policyDefinitions>"

    return header + supported_on + categories + policies + footer


def _indent(block: str, spaces: int) -> str:
    pad = " " * spaces
    return "\n".join(pad + line if line.strip() else line for line in block.splitlines())


# ── ADML merge ────────────────────────────────────────────────────────────────

def merge_adml(machine: str, user: str) -> str:
    check_no_string_collisions(machine, user)
    check_no_presentation_collisions(machine, user)

    strings_machine = inner_xml(machine, "stringTable").strip()
    strings_user    = inner_xml(user,    "stringTable").strip()

    # presentationTable is optional
    def safe_inner(text, tag):
        try:
            return inner_xml(text, tag).strip()
        except ValueError:
            return ""

    pres_machine = safe_inner(machine, "presentationTable")
    pres_user    = safe_inner(user,    "presentationTable")

    strings_block = f"""    <stringTable>
      <!-- Machine-scope strings -->
{_indent(strings_machine, 6)}

      <!-- User-scope strings -->
{_indent(strings_user, 6)}
    </stringTable>"""

    if pres_machine or pres_user:
        pres_block = f"""    <presentationTable>
      <!-- Machine-scope presentations -->
{_indent(pres_machine, 6)}

      <!-- User-scope presentations -->
{_indent(pres_user, 6)}
    </presentationTable>"""
    else:
        pres_block = ""

    return f"""<?xml version="1.0" encoding="utf-8"?>
<!-- Merged ADML: AdobeDC machine (v2.19) + user (v1.6) -->
<policyDefinitionResources xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  revision="{MERGED_REVISION}" schemaVersion="1.0"
  xmlns="http://schemas.microsoft.com/GroupPolicy/2006/07/PolicyDefinitions">
  <displayName>Adobe Acrobat DC (Machine + User)</displayName>
  <description>Merged machine-scope (v2.19) and user-scope (v1.6) Adobe DC ADMX policies.</description>
  <resources>
{strings_block}
{pres_block}
  </resources>
</policyDefinitionResources>
"""


# ── main ──────────────────────────────────────────────────────────────────────

def main():
    print("Reading source files...")
    machine_admx = read_text(MACHINE_ADMX)
    machine_adml = read_text(MACHINE_ADML)
    user_admx    = read_text(USER_ADMX)
    user_adml    = read_text(USER_ADML)

    print("Merging ADMX...")
    merged_admx = merge_admx(machine_admx, user_admx)

    print("Merging ADML...")
    merged_adml = merge_adml(machine_adml, user_adml)

    out_admx = OUT / "AdobeDC.admx"
    out_en   = OUT / "en-US"
    out_en.mkdir(exist_ok=True)
    out_adml = out_en / "AdobeDC.adml"

    out_admx.write_text(merged_admx, encoding="utf-8")
    out_adml.write_text(merged_adml, encoding="utf-8")

    print(f"\nOutput:")
    print(f"  ADMX  {out_admx}  ({out_admx.stat().st_size:,} bytes)")
    print(f"  ADML  {out_adml}  ({out_adml.stat().st_size:,} bytes)")

    # Quick sanity: count merged policy elements
    machine_count = machine_admx.count('<policy ')
    user_count    = user_admx.count('<policy ')
    merged_count  = merged_admx.count('<policy ')
    print(f"\nPolicy count:  machine={machine_count}  user={user_count}  merged={merged_count}")
    if merged_count != machine_count + user_count:
        print("  WARNING: merged count doesn't match sum — check for dropped policies", file=sys.stderr)
    else:
        print("  OK: counts add up correctly")

    print("\nDone.")

if __name__ == "__main__":
    main()
