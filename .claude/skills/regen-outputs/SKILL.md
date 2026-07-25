---
name: regen-outputs
description: Regenerate ALL derived artifacts for Skua in one command (parameter, geometry and performance gates, every printable STL, main_assembly.png). Use after ANY change to cad/*.scad — never hand-run individual openscad commands.
---

# Regenerate derived outputs

One command rebuilds everything that is committed but derived:

```bash
python3 scripts/regen_all.py            # everything
python3 scripts/regen_all.py base vane  # just these parts
python3 scripts/regen_all.py --stl-only # all printable STLs, skip the assembly PNG
```

Pipeline:
1. `scripts/check_params.py` — no file may shadow a design_params.scad name (FAIL gates the commit)
2. `scripts/geometry_check.py` — assembly stack-up: clearances, engagements, stop-wedge geometry, bed fit (FAIL gates too)
3. every part in `cad/` + `cad/calibration/` → `stl/<name>.stl`
4. `scripts/performance_check.py` — self-start wind, parasitic drag
   ratchet, storm safety factors (FAIL gates; runs after the STL stage
   because its mass model reads the fresh `stl/` files)
5. `cad/main_assembly.scad` → `main_assembly.png` (the README image)
6. `cad/main_assembly.scad -D step=N` → `docs/assembly/step<N>.png`
   (the assembly guide images; docs/assembly.md's text is hand-written,
   its images are build products)

## Rules

- Do NOT compose ad-hoc render command lines; if a new artifact appears, add it to `regen_all.py` so the pipeline stays the single entry point.
- The committed STLs and `main_assembly.png` are build products — regenerate them in the same change that alters their sources, never edit around them.
- After running, read the output: every part must be `[ok]` (no warnings, geometry status `NoError`). A bad status usually means coincident faces in a `difference()` — extend the cutter past both surfaces, don't ship the STL.
- Finish by eyeballing `main_assembly.png` (Read tool) — parts floating apart or interpenetrating are findings even when everything compiles.
