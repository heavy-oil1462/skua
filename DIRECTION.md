# Direction

Set by the owner, heavy-oil1462. The supervisor reads this at the start of
every session. Change it through a pull request, or ask on the board issue.

## Goal

Skua is a wind-only gull scarer for a boat: a printed 1.2 m rotor of
flapping vanes on a plank-mounted 608 bearing tower, buildable by anyone
with a printer, 8 mm aluminum rod, M3 hardware and a hand die. The dual
(two arms) is the mature machine, released as v1.1; it should stay
buildable from the README and docs/assembly.md alone, every artifact
regenerated and gated. The tri (three arms, docs/tri_concept.md) is its
light-wind sibling with its own tri-vX.Y release line, growing toward
tri-v0.1.

## Guiding principles

The core design ideas in CLAUDE.md are binding; these are the rules that
decide between two working changes.

- Swing asymmetry drives the rotor: never remove or soften the vane's
  hard stop (the end cap wedge), never tilt the hinge off vertical.
- No rod or printed part is ever drilled; every joint is a clamp. The
  shaft's one M8 die pass is the only rod prep.
- Clamps never close solid: hub_clamp_gap and bracket_clamp_gap stay
  above zero, so preload is on the rods, not on plastic faces.
- Friction joints are wide dual-bolt clamps; the uplift retainer is the
  only narrow single-bolt clamp, and it stays in the design.
- Rotor weight rides the thrust collar on the top bearing's inner race;
  nothing else takes axial load, no rotating face touches a static one.
- Two rod stocks at most: 8 mm for shaft and stubs, arm_rod_d for arms.
- cad/design_params.scad is the single source of every shared dimension;
  fits are measured with the calibration gauges, never tuned by eye.
- Gates decide: a change that fails params, geometry or performance does
  not merge, and gates are not loosened to let a change through.
- Lighter wins between two parts that pass the gates: weight is what the
  self-start and the return swing pay for.
- One part set serves both machines: the tri reuses the dual's vane
  assembly and hub design verbatim and only adds tri_-prefixed hub sizing.

## Architecture

- `cad/design_params.scad` — shared dimensions. Every part includes it;
  `scripts/design_params.py` parses it for the Python gates.
- `cad/*.scad` — one file per printable dual part, modeled in print
  orientation; `main_assembly.scad` composes them. Parts include
  design_params and may `use` `cad/lib/` or a parent part's modules
  (bracket halves on tip_bracket, end cap and retainer on collar, hub
  halves on hub); a shared shape lives in one file.
- `cad/lib/` — helpers (teardrop bores, stop wedge, labels), no parts.
- `cad/calibration/` — fit gauges; their results go into design_params.
- `cad/tri/` — the tri variant: `tri_params.scad` adds tri_ names on top
  of design_params; it may use dual parts, dual parts never use it, and
  for now nothing in it exports to `stl/`.
- `scripts/` — stdlib-only Python. `regen_all.py` is the one entry point
  for derived artifacts and runs check_params → geometry_check → STLs →
  performance_check → images. `render_scad.py` owns the OpenSCAD pin.
- `stl/`, `main_assembly.png`, `docs/assembly/*.png`,
  `docs/tri_assembly.png` — build products, regenerated, never edited.
- Docs: README (the default dual build), `docs/assembly.md` (the guide),
  `docs/tri_concept.md` (tri home). Architectural decisions go into ADRs
  in docs/adr (none written yet; the first one starts the directory).

## Priorities, in order

1. Keep the dual v1.1 build correct: fix anything that makes the docs,
   STLs or gates disagree with each other or with a field build.
2. Bring the tri to tri-v0.1: a buildable three-arm machine whose hub
   prints from `stl/`, with its own gates and an assembly section.
3. The open field question in CLAUDE.md: whether the tip clamps hold
   the stop angle over years of impacts. Upgrades wait for field data.

## Not now

- Electronics, motors, or anything not driven by the wind.
- Tip clamp upgrades (knurl transfer, rod flats, dimpled grubs) until
  the field says the clamps slip.
- Revived dropped directions recorded in docs/tri_concept.md (keyed stop
  ring, screwed stubs, taps).

## How to work

- After any .scad change run `python3 scripts/regen_all.py` and commit
  the regenerated artifacts with the source; before every commit
  `python3 scripts/regen_all.py --check` must pass. CI runs the same.
- Review CAD by rendering and looking at the PNG, not from source.
- New shared dimensions go into design_params.scad as plain numbers.
- A change to parts, hardware or assembly updates README's BOM,
  CLAUDE.md's off-the-shelf list and docs/assembly.md in the same PR.

## Ask the owner first

- Release tags (vX.Y, tri-vX.Y) and anything published outside the repo.
- Changing any core design idea in CLAUDE.md, or the default build
  (which hub, which variant is the main path).
- New measured fit values: they come from the owner's printed gauges.
- Adding or removing a bought part from the BOM.
