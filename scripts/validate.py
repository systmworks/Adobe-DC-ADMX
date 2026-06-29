"""
Validate build/AdobeDC.admx and build/en-US/AdobeDC.adml.

Checks:
  - XML is well-formed
  - Namespace is correct (Adobe.Policies.AdobeDC)
  - No class="Both" policies (all user policies must be class="User")
  - No duplicate string IDs in ADML
  - No duplicate presentation IDs in ADML

Exit 0 on success, 1 on failure.
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).parent.parent
ADMX = ROOT / "build" / "AdobeDC.admx"
ADML = ROOT / "build" / "en-US" / "AdobeDC.adml"


def main() -> int:
    errors: list[str] = []

    for path in (ADMX, ADML):
        if not path.exists():
            errors.append(f"Missing file: {path}")

    if errors:
        for e in errors:
            print(f"ERROR: {e}", file=sys.stderr)
        return 1

    admx_text = ADMX.read_text(encoding="utf-8")
    adml_text = ADML.read_text(encoding="utf-8")

    # --- XML well-formedness ---
    try:
        import xml.etree.ElementTree as ET
        ET.fromstring(admx_text)
        ET.fromstring(adml_text)
    except ET.ParseError as exc:
        errors.append(f"XML parse error: {exc}")

    # --- Namespace ---
    if 'namespace="Adobe.Policies.AdobeDC"' not in admx_text:
        errors.append("Missing expected namespace Adobe.Policies.AdobeDC in ADMX")

    # --- No class="Both" ---
    both_count = admx_text.count('class="Both"')
    if both_count > 0:
        errors.append(
            f'Found {both_count} class="Both" policies — all user policies must be class="User"'
        )

    # --- Duplicate string IDs ---
    seen: set[str] = set()
    dupes: list[str] = []
    for sid in re.findall(r'<string id="([^"]+)"', adml_text):
        if sid in seen:
            dupes.append(sid)
        seen.add(sid)
    if dupes:
        errors.append(f"Duplicate ADML string IDs ({len(dupes)}): {dupes[:5]}")

    # --- Duplicate presentation IDs ---
    seen = set()
    pdupes: list[str] = []
    for pid in re.findall(r'<presentation id="([^"]+)"', adml_text):
        if pid in seen:
            pdupes.append(pid)
        seen.add(pid)
    if pdupes:
        errors.append(f"Duplicate ADML presentation IDs ({len(pdupes)}): {pdupes[:5]}")

    if errors:
        for e in errors:
            print(f"ERROR: {e}", file=sys.stderr)
        return 1

    machine_count = admx_text.count('class="Machine"')
    user_count    = admx_text.count('class="User"')
    print(
        f"OK  {ADMX.name}: {machine_count} Machine + {user_count} User = {machine_count + user_count} policies"
        f"  |  no class=Both  |  no duplicate IDs"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
