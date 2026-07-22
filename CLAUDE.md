# Skua

Wind-driven gull scarer for a boat: a 1.2 m rotor of flapping flags on a
plank-mounted bearing tower, named for the bird that chases gulls off.
3D-printed structure, 8 mm aluminum rod, two 608 skateboard bearings, M3
hardware. No electronics — the wind does everything.

## Core design ideas (do not design against these)

- **The rotor is driven by swing asymmetry, not by airfoils.** Each vane
  pivots on its arm like a flag: free through vane_swing_deg one way,
  hard stop the other (a stop wedge on the end cap and one on the arm
  collar, each riding a notch in its end of the sleeve; the flat faces
  land flush on the notch walls and share the impact; set both to the
  same angle at assembly). Pushed
  toward the stop it presents its full face and drags the rotor; pushed
  the other way it folds flat and slips through. Both stops are set in
  the same rotational sense so the torques add. A vane that is fixed
  rigidly, or that can swing all the way around, produces no net torque
  — never "simplify" the stop away. The clack of the vanes hitting the
  stops is part of the product.
- **One rod stock.** Shaft and arms are all 8 mm aluminum rod (the 608
  bore). No second diameter may creep in.
- **Rotor weight hangs on the thrust collar,** through-bolted to the shaft and
  riding the top bearing's INNER race (boss stays inside
  bearing_inner_shoulder_d). Nothing else may take axial load: the hub
  joint transmits torque only, and no rotating face may touch a static
  one — recesses (pocket_recess) and bosses exist to keep rubbing rings
  small and on the right races.
- **Every rod joint is a through-bolt, drilled at assembly**: slide the
  part to position (stop angles set first), drill the rod through the
  part's own bolt hole, bolt through with a nyloc. Friction clamps and
  set screws on smooth aluminum creep loose over years; a bolt through
  the rod cannot. No dimension chain depends on cutting rods to
  sub-millimeter length.

## Layout

- `cad/design_params.scad` — **single source of truth** for every dimension
  two parts share. Parts `include` it; `check_params.py` fails the build if
  any file shadows one of its names. Change shared values there and only there.
- `cad/` — one .scad per printable part + `main_assembly.scad` (visual fit
  check, renders to `main_assembly.png`)
- `cad/calibration/` — gauges for the three fits (bearing press, rod snug,
  rod free). Print, pick the best fit, type that number into design_params.
- `cad/lib/` — shared OpenSCAD helpers, not printable parts (regen_all
  does not scan it). `bores.scad` holds the teardrop rod bore: every
  horizontal rod hole prints support-free through it, so parts must be
  MODELED in their print orientation.
- `stl/` — committed build products, print-ready; regenerate, never hand-edit
- `scripts/` — Python tools (see below)

## Tools & workflow

Everything runs headless through nix — **never download or manually install
binaries** (`nix shell` / `nix build` only). OpenSCAD comes from
`nixpkgs#openscad-unstable` via the pin in `render_scad.py`. No-nix escape
hatch: set `OPENSCAD=/path/to/openscad`; the scripts are stdlib-only Python.

- `python3 scripts/regen_all.py` — the single entry point for derived
  artifacts: gates (params, geometry) → all STLs → `main_assembly.png`. Run
  after ANY .scad change (see the `regen-outputs` skill). `--check` is the
  read-only commit gate (the `verify` skill): fresh renders are
  byte-compared against the committed artifacts. The byte comparison
  self-skips when the running OpenSCAD differs from `stl/openscad_version.txt`.
- `python3 scripts/check_params.py` — no file may shadow a design_params name.
- `python3 scripts/geometry_check.py` — recomputes the assembly stack-up
  (clearances, engagements, the stop-wedge geometry, bed fit) from the shared
  params and fails on any violation. Run after ANY parameter change.
- `python3 scripts/render_scad.py <file.scad> <out.png|stl> [args]` —
  one-off headless renders (see the `openscad-review` skill).

Conventions:
- Review CAD by rendering and looking at the PNG, never from source alone.
- Keep top-level `name = value;` parameters parseable (plain numbers).
- The three fit values (bearing_press_d, rod_snug_d, rod_free_d) are
  MEASURED via the calibration gauges, never tuned by eye.

## Key off-the-shelf parts

- 2x 608 bearing (8x22x7, any skateboard bearing; ZZ shields preferred
  outdoors)
- 8 mm aluminum rod: one 150 mm shaft + two 600 mm arms
- 8x M3 bolts + nyloc nuts (3x M3x35 hub, 5x M3x25 collars and caps):
  every rod joint is through-bolted, the rod drilled 3 mm at assembly
  through the part's own printed hole
- 4x 4.2 mm wood screws for the plank
