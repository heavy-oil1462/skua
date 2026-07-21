---
name: openscad-review
description: Render and review the OpenSCAD models in cad/ headlessly (via nix, no GUI needed). Use after any .scad change, or when asked to verify/review the CAD. Checks compile warnings, manifold geometry, visual correctness, and Skua's interface rules.
---

# OpenSCAD Review

Review OpenSCAD changes by actually rendering them — never approve a .scad edit from source reading alone.

## Rendering (headless, via nix)

Use the helper — it resolves OpenSCAD + Mesa from nixpkgs (never download binaries manually) and renders without any display:

```bash
scripts/render_scad.py cad/<file>.scad <out.png|out.stl> [extra openscad args]
```

Notes (learned in earlier projects — do not rediscover):
- The sandbox's `LD_LIBRARY_PATH=/lib` crashes nix binaries; the script overrides it. Do the same if running openscad manually via `nix shell`.
- PNG rendering uses Mesa software GL via `EGL_PLATFORM=surfaceless` — no X/xvfb needed. `libEGL warning: Not allowed to force software rendering` on stderr is benign.
- `nixpkgs#openscad-unstable` (registry unstable) has no hydra cache and its
  source build fails at link, costing an hour before dying. `render_scad.py`
  therefore pins `NIXPKGS` to a release branch, which ships the identical
  snapshot prebuilt. Probe for a cached build with `--max-jobs 0` (fails fast
  instead of source-building) before changing the pin.
- Section views: subtract a half-space cube from a wrapper assembly and
  view from the CUT side (`--camera=...,90,0,0,dist --projection=o` looks
  from -y, so remove the -y half). Cut faces render green in the PNG —
  that is normal, judge the geometry.

## Review procedure

1. **Run `python3 scripts/check_params.py` and `python3 scripts/geometry_check.py` first.** A `[FAIL]` means parts physically won't fit. This gates everything else.

2. **Render every changed .scad to PNG** (into the scratchpad dir) and **look at it** with the Read tool. Capture stderr — any `WARNING:`/`ERROR:` is a finding; zero warnings is the baseline.

3. **Export changed printable parts to STL** and check the stderr geometry summary: a printable part must be **exactly 1 volume**. Two volumes usually means coincident faces in a `difference()` (extend cutters by an epsilon beyond both ends).

4. If a file becomes library-only (modules, no top-level call), wrap it — the `use <>` path MUST be absolute (it resolves relative to the wrapper file):
   ```bash
   echo 'use </workspace/skua/cad/vane.scad>; vane();' > "$SCRATCH/wrap.scad"
   scripts/render_scad.py "$SCRATCH/wrap.scad" "$SCRATCH/vane.png"
   ```

## Skua interface rules to verify

- **`cad/design_params.scad` is the single source of truth** for every dimension two parts share (rod and bearing sizes, the three calibrated fits, socket depths, stop-pin geometry, stations). Parts `include` it; `check_params.py` FAILS if any file re-declares one of its names. Never fix a mismatch locally — change the shared value.
- **The three fits are calibrated, not designed**: bearing_press_d, rod_snug_d, rod_free_d come from the gauges in `cad/calibration/`. A part needing a different fit of the same stock is a smell.
- **Horizontal rod holes go through `lib/bores.scad` (teardrop)** and parts are modeled in their print orientation — a plain horizontal cylinder bore is a finding.
- **Rotating never rubs static**: bosses that ride a bearing must stay inside bearing_inner_shoulder_d; static shoulders (tower_bore_d) must stay outside it; bearings sit pocket_recess below their faces. The rotor's weight path is shaft collar -> top bearing inner race only.
- **The swing-stop mechanism is load-bearing design**: each vane must swing vane_swing_deg freely and hit a hard stop (cap pin in sleeve notch). Changes to sleeve, cap, or pin must keep `geometry_check.py`'s pin checks meaningful — never widen the notch to "fix" a stop collision.
- **Assembly is slide-and-clamp**: no feature may require a rod cut to better than a couple of millimeters (the cap bore leaves slack for this).

## Report

Summarize per file: render OK/warnings, volume count, visual findings, rule violations. Include rendered PNG paths so the user can look.
