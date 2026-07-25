# Skua

Wind-driven gull scarer for a boat: a 1.2 m rotor of flapping flags on a
plank-mounted bearing tower, named for the bird that chases gulls off.
3D-printed structure, 8 mm aluminum rod, two 608 skateboard bearings, M3
hardware. No electronics — the wind does everything.

## Core design ideas (do not design against these)

- **The rotor is driven by swing asymmetry, not by airfoils.** Each vane
  pivots like a door on a VERTICAL stub rod at the arm tip (held by
  the tip bracket): free through vane_swing_deg one way, hard stop
  the other (a stop wedge on the end cap above and the STOP RING's
  fin below, each riding a notch in its end of the sleeve; the flat
  faces land flush on the notch walls and share the impact; only the
  cap is set at assembly, to land together with the fin. The stop
  ring is a D-footed piece trapped in the bracket clamshell's pocket
  like the rods are: the flat keys one orientation only, so the
  driven-stop angle and the rotor's rotational sense are geometry,
  not assembly care. It prints on its back with no overhangs, it is
  the replaceable wear part, and the notch is sized swing +
  ring_wedge_deg so the wider fin costs no swing). Pushed toward the stop it presents
  its full face and drags the rotor; pushed the other way it
  weathervanes flat and slips through. The brackets bake both arms
  into the same rotational sense, so the torques add. A vane that
  is fixed rigidly, or that can swing all the way around, produces no
  net torque — never "simplify" the stop away. The clack of the vanes
  hitting the stops is part of the product.
- **The hinge is vertical so folding never fights gravity.** That is
  the low-wind self-start: a hanging panel on a horizontal hinge
  needs a moderate breeze to fold, and below that the rotor only
  rocks in place. Never tilt the hinge or hang mass on the vane in a
  way that gives the free swing a gravity slope; the sleeve's weight
  rides the stop ring's small boss so spin friction stays low (that
  thrust face is what sets the self-start wind — performance_check
  gates it).
- **One rod stock.** Shaft, arms and the two vertical hinge stubs are
  all 8 mm aluminum rod (the 608 bore). No second diameter may creep
  in.
- **Rotor weight hangs on the thrust collar,** clamped to the shaft and
  riding the top bearing's INNER race (boss stays inside
  bearing_inner_shoulder_d). Nothing else may take axial load in normal
  running: the hub joint transmits torque only, and no rotating face may
  touch a static one — recesses (pocket_recess) and bosses exist to keep
  rubbing rings small and on the right races. The one sanctioned
  exception is the uplift retainer (retainer.scad): a single-bolt collar
  boss-up under the bottom bearing, running retainer_gap clear of its
  inner race, so a wave slam or gust that unloads the rotor cannot lift
  the shaft out of the bearings. It lives in the base_cavity_d cavity
  inside the base tower, is clamped at the bench flush with the shaft
  tip, and the gap is created at mounting by gauging the THRUST collar
  retainer_gap off the top race while the bottom race rests on the
  retainer boss, so no cavity access is ever needed. It carries nothing
  until an uplift event and only ever loads the bottom bearing's races
  — never a static face. It also keeps the bottom bearing captive.
  Fitting it is OPTIONAL at build time (rotor weight alone keeps the
  shaft seated in ordinary conditions, and field testing agrees); the
  shaft length is the same either way and the part can be retrofitted
  through the open cavity with the base unscrewed. But it stays in the
  DESIGN: never delete the part, the cavity, or their checks, and
  never "simplify" the gap to zero (that preloads the bearings).
- **No rod is ever drilled; every joint is a clamp.** The hub and
  the tip brackets are clamshells split on the plane containing their
  rod axes: lay in the rods, bolt the halves with washered bolts
  (M5 at the hub, M3 at the tip brackets, which ride 620 mm out and
  are sized for weight); the bracket's stub groove runs through and
  its ring pocket opens upward, so stub and stop ring feed in from
  above after the clamshell closes on the arm; the halves must never close solid
  (hub_clamp_gap and bracket_clamp_gap keep preload on the rods,
  never fix a "gap" by shrinking it to zero). The collars and end caps are
  WIDE dual-bolt slit clamps: friction-only joints live on grip
  length and bolt count, so a single set screw or a narrow ring is a
  design error here (geometry_check enforces the width; the one
  sanctioned narrow single-bolt clamp is the uplift retainer, which
  carries nothing in normal running). The price of
  an all-friction, fully re-adjustable, drill-free machine is that
  printed clamps relax: re-torque every clamp bolt at the start of
  each season. Known open question: whether the tip clamps hold the
  stop angle against years of stop impacts — candidate upgrades
  (knurl-transfer, rod flats, dimpled grubs) deliberately deferred.
  No dimension chain depends on cutting rods to sub-millimeter length.

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
  artifacts: gates (params, geometry) → all STLs → performance gate →
  `main_assembly.png`. Run
  after ANY .scad change (see the `regen-outputs` skill). `--check` is the
  read-only commit gate (the `verify` skill): fresh renders are
  byte-compared against the committed artifacts. The byte comparison
  self-skips when the running OpenSCAD differs from `stl/openscad_version.txt`.
- `python3 scripts/check_params.py` — no file may shadow a design_params name.
- `python3 scripts/geometry_check.py` — recomputes the assembly stack-up
  (clearances, engagements, the stop-wedge geometry, bed fit) from the shared
  params and fails on any violation. Run after ANY parameter change.
- `python3 scripts/performance_check.py` — the physics gate: self-start
  wind, parasitic drag ratchet, and storm safety factors for every load
  path (locked rotor, flag face-on at the survival wind). Mass model
  reads the committed STLs, so it runs after the STL stage in regen_all.
  Analysis constants (materials, drag coefficients, bolt preloads) live
  in this file with their rationale; they are not CAD dimensions.
- `python3 scripts/render_scad.py <file.scad> <out.png|stl> [args]` —
  one-off headless renders (see the `openscad-review` skill).

Conventions:
- Review CAD by rendering and looking at the PNG, never from source alone.
- Keep top-level `name = value;` parameters parseable (plain numbers).
- The three fit values (bearing_press_d, rod_snug_d, rod_free_d) are
  MEASURED via the calibration gauges, never tuned by eye. They are
  printer + profile + FILAMENT specific: a material switch (the PLA
  prototype vs the ASA the real build is printed in) means re-running
  the gauges in that material with the production profile.

## Key off-the-shelf parts

- 2x 608 bearing (8x22x7, any skateboard bearing; ZZ shields preferred
  outdoors)
- 8 mm aluminum rod: one 145 mm shaft + two 600 mm arms + two 113 mm
  hinge stubs
- 5x M5x40 with wide washers (hub clamshell), 8x M3x30 with small
  washers (tip bracket clamshells, kept light out at the arm tips)
  and 6x M3x16 (dual-bolt thrust collar and cap clamps; one more if
  the optional retainer is fitted), all with nyloc nuts; no rod or
  printed part is ever drilled
- 4x 4.2 mm wood screws, and any plank to screw the base onto (no
  hole: the shaft tip and retainer stay inside the base cavity)
