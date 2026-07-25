#!/usr/bin/env python3
"""Regenerate ALL derived artifacts for Skua in one command.

Run after ANY change to cad/*.scad — never hand-compose openscad command
lines (see the regen-outputs skill).

Pipeline:
  1. scripts/check_params.py          — interface dimensions must agree
  2. scripts/geometry_check.py        — assembly stack-up stays legal
  3. every part in cad/ + cad/calibration/  -> stl/<name>.stl
  4. scripts/performance_check.py     — spin-up wind, drag ratchet and
                                        storm safety factors (needs the
                                        fresh STLs for the mass model,
                                        so it runs after the STL stage)
  5. cad/main_assembly.scad           -> main_assembly.png (README image)
  6. cad/main_assembly.scad -D step=N -> docs/assembly/step<N>.png
                                         (the assembly guide images)
  7. cad/tri/tri_assembly.scad          -> docs/tri_assembly.png (the tri
                                         concept scene; cad/tri/ holds
                                         study models, never printable
                                         parts, so it is not scanned
                                         for STL export)

STLs are committed build products (print-ready). A part whose STL gains a
second volume or errors out is a finding, not something to ignore.

Usage:
    scripts/regen_all.py [part ...]    # no args = everything
    scripts/regen_all.py --stl-only    # export the printable STLs, skip the
                                       # assembly PNG (the "give me everything
                                       # to print" mode)
    scripts/regen_all.py --check       # read-only gate (the verify skill and
                                       # CI): render everything to a temp dir
                                       # and byte-compare against the committed
                                       # artifacts; [STALE] means a source
                                       # changed without regenerating. Renders
                                       # are byte-deterministic only on the
                                       # same OpenSCAD build, so a full regen
                                       # records its version in
                                       # stl/openscad_version.txt and --check
                                       # self-skips the byte comparison when
                                       # the running version differs (warnings,
                                       # manifold status, params, throw and
                                       # orphan checks still run in full).
"""

import re
import subprocess
import sys
import tempfile
from pathlib import Path

from render_scad import render, openscad_version

ROOT = Path(__file__).resolve().parent.parent
PARTS_DIRS = [ROOT / "cad", ROOT / "cad" / "calibration"]
# Not printable parts: the assembly renders to PNG, design_params is data,
# bearing_608 (bought bearing) is a visual model only, and hub and
# tip_bracket are clamshell libraries (hub_front/hub_back and
# bracket_half are the printed halves).
NON_PARTS = {"main_assembly", "design_params", "bearing_608", "hub",
             "tip_bracket"}
# Which OpenSCAD build produced the committed artifacts. Byte equality only
# holds within one build, so --check compares bytes only when the running
# version matches this file.
VERSION_FILE = ROOT / "stl" / "openscad_version.txt"
# docs/assembly.md's images: main_assembly.scad rendered at each step
ASSEMBLY_STEPS = range(1, 6)
# Per-step extra args (render_scad skips --viewall/--autocenter when a
# --camera is passed). Step 3 is a close-up of the tower with the base
# half cut away so the collars, bearings and retainer cavity read;
# --render because the OpenCSG preview draws the section cube wrong
# (the flange sections, the tower stays whole).
STEP_CAMERAS = {3: ["--render", "--camera=0,0,50,70,0,0,420"]}


def parts():
    for d in PARTS_DIRS:
        for p in sorted(d.glob("*.scad")):
            if p.stem not in NON_PARTS:
                yield p


def run_one(scad: Path, out: Path, expect: Path = None, shown: Path = None,
            extra=None) -> bool:
    """Render scad -> out; with expect set (check mode), also byte-compare
    the fresh render against the committed artifact. shown is the path to
    print (the committed one when out is a temp file)."""
    proc = render(str(scad), str(out), extra)
    warnings = sorted({l.strip() for l in proc.stderr.splitlines() if "WARNING" in l or "ERROR" in l})
    # Manifold backend reports geometry health as "Status: NoError"
    geom = re.search(r"Status:\s+(\w+)", proc.stderr)
    geom_ok = geom is None or geom.group(1) == "NoError"
    render_ok = proc.returncode == 0 and not warnings and geom_ok
    stale = expect is not None and render_ok and (
        not expect.exists() or expect.read_bytes() != out.read_bytes())
    ok = render_ok and not stale
    shown = shown or expect or out
    tag = "ok" if ok else ("STALE" if stale else "FAIL")
    print(f"[{tag}] {scad.relative_to(ROOT)} -> {shown.relative_to(ROOT)}")
    for w in warnings:
        print(f"        {w}")
    if not geom_ok:
        print(f"        geometry status: {geom.group(1)} — part is not cleanly manifold")
    if stale:
        print("        committed artifact does not match its sources —"
              " run scripts/regen_all.py and commit the result")
    return ok


def main(argv):
    stl_only = "--stl-only" in argv
    check = "--check" in argv
    only = {a for a in argv[1:] if not a.startswith("--")}

    compare = check
    if check:
        recorded = VERSION_FILE.read_text().strip() if VERSION_FILE.exists() else "(none recorded)"
        current = openscad_version()
        if current != recorded:
            compare = False
            print(f"[note] OpenSCAD {current} does not match {recorded} in "
                  f"{VERSION_FILE.relative_to(ROOT)} — byte drift check "
                  "self-skips; every other check runs at full strength")

    ok = True
    for gate in ("check_params.py", "geometry_check.py"):
        ok &= subprocess.run([sys.executable, str(ROOT / "scripts" / gate)]).returncode == 0

    (ROOT / "stl").mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory() as td:
        def target(committed):
            if not check:
                return committed, None, None
            return Path(td) / committed.name, committed if compare else None, committed

        for scad in parts():
            if only and scad.stem not in only:
                continue
            ok &= run_one(scad, *target(ROOT / "stl" / f"{scad.stem}.stl"))

        # performance gate after the STL stage: its mass model reads the
        # committed stl/ files, which the loop above just refreshed (or,
        # in check mode, just byte-verified against the sources)
        ok &= subprocess.run([sys.executable, str(
            ROOT / "scripts" / "performance_check.py")]).returncode == 0

        if not stl_only and (not only or "main_assembly" in only):
            assembly = ROOT / "cad" / "main_assembly.scad"
            ok &= run_one(assembly, *target(ROOT / "main_assembly.png"))
            if not check:
                (ROOT / "docs" / "assembly").mkdir(parents=True, exist_ok=True)
            for n in ASSEMBLY_STEPS:
                committed = ROOT / "docs" / "assembly" / f"step{n}.png"
                ok &= run_one(assembly, *target(committed),
                              extra=["-D", f"step={n}"] + STEP_CAMERAS.get(n, []))

        tri_scene = ROOT / "cad" / "tri" / "tri_assembly.scad"
        if (tri_scene.exists() and not stl_only
                and (not only or "tri_assembly" in only)):
            ok &= run_one(tri_scene, *target(ROOT / "docs" / "tri_assembly.png"))

    if check and not only:
        expected = {f"{p.stem}.stl" for p in parts()}
        for f in sorted((ROOT / "stl").glob("*.stl")):
            if f.name not in expected:
                print(f"[STALE] {f.relative_to(ROOT)} has no source part — delete it")
                ok = False

    if not check and not only and not stl_only and ok:
        VERSION_FILE.write_text(openscad_version() + "\n")

    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
