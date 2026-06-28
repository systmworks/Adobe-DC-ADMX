"""
Validate the merged AdobeDC.admx / AdobeDC.adml in build/.

Checks:
  - XML is well-formed
  - Namespace is correct
  - Policy counts match expected values (552 Machine + 495 User = 1047)
  - No class="Both" policies remain (all user policies must be class="User")
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

EXPECTED_MACHINE = 552
EXPECTED_USER    = 495


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

    # --- Policy class counts ---
    machine_count = admx_text.count('class="Machine"')
    user_count    = admx_text.count('class="User"')
    both_count    = admx_text.count('class="Both"')

    if machine_count != EXPECTED_MACHINE:
        errors.append(
            f"Machine policy count: expected {EXPECTED_MACHINE}, got {machine_count}"
        )
    if user_count != EXPECTED_USER:
        errors.append(
            f"User policy count: expected {EXPECTED_USER}, got {user_count}"
        )
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

    total = machine_count + user_count
    print(
        f"OK  {ADMX.name}: {machine_count} Machine + {user_count} User = {total} policies  "
        f"| no class=Both | no duplicate IDs"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
