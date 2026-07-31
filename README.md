# Skua

A wind-driven gull scarer for a boat, named for the bird that chases
gulls away. A 1.2 m rotor of flapping plastic flags spins on a
plank-mounted bearing tower; the motion and the clatter keep gulls off.
No electronics, no motor — wind only.

![assembly](main_assembly.png)

## How it works

Each vane is a flag on a VERTICAL hinge: a sleeve spinning on a short
vertical stub rod, held at the arm tip by a printed knuckle bracket,
with the panel reaching out sideways like a door. The end cap's stop
wedge rides in a notch in the sleeve's top end and is the vane's only
stop; below, the sleeve rests on a smooth stop ring trapped in the
bracket, the vane's thrust seat and the replaceable wear part. The
vane swings freely through about 90 degrees one way and hits the
hard stop the other way, the impact landing flat on the notch walls.
The cap is a clamp, so the driven-stop angle is set, and re-set, by
loosening two bolts — the field-testing knob. The swing angle is the
sleeve notch minus the wedge width, so trying a different swing is a
reprint of two small caps; the vanes do not change. Wind pushing a
vane onto its stop gets the full panel face and drags the rotor
around; wind pushing the other vane (coming back upwind) just
weathervanes it flat. Set both caps the same way around seen from
above so the torques add and the rotor self-starts in any wind
direction. Every pass the driving vane bangs against its stop — free
percussion.

The flag itself is built for the return trip, not the push: catching
wind is the easy half, the swing back to the driven stop is the
fight. So the panel is a thin arched pennant: it spans the sleeve,
runs flat a short shoulder past the sleeve top, rises in a quarter
circle to the arch peak, then sweeps down to the bottom outer tip.
It is a bare 2 mm skin with no stiffening rim, weight being what
the return swing pays for; if a flag ever creep-curls in the sun,
that is the sign to reprint with a slim rim on the arch edge.
Height is free for the
swing mechanics (only the spread over reach enters the hinge
integrals), so the raised arch carries face area near the hinge
where folding wants it, while the shortened reach keeps the tip
inertia the return swing hates low. Compared to the old full
rectangle the hinge inertia drops by more than half and the flappy
free top corner is gone. Nothing of the flag sits close to the end
cap, so the cap's bolt hardware clears the fold at any cap angle.

The hinge being vertical is what makes it start in light wind: folding
never lifts any weight. A vane hanging from a horizontal hinge only
folds when wind pressure beats its weight, roughly a moderate breeze
for printed plastic, and below that both vanes present the same face
and the rotor just rocks. On vertical hinges the returning flag
weathervanes at a whisper, so the asymmetry, and the spin, are there
from the first puff.

The rotor rides on two 608 skateboard bearings spaced 45 mm apart in the
base tower, so the 1.2 m span runs true. All rotating weight hangs on a
collar clamped to the shaft, resting on the top bearing's inner race.

There is also an OPTIONAL uplift retainer: a smaller single-bolt collar
clamped under the bottom bearing, a millimeter clear of its inner race,
living in a cavity inside the base tower. It carries nothing while the
rotor runs, but a wave slam or a gust that unloads the rotor cannot
lift the shaft out of its bearings, and it keeps the bottom bearing
captive. In practice the rotor's weight alone keeps the shaft seated
in all ordinary conditions, so most builds can leave the retainer out;
the shaft is the same length either way, the tip just rides loose in
the cavity, and one can be printed and retrofitted through the open
cavity later if the mooring proves rough (see the assembly guide).

## Bill of materials

- printed: 1 base, 1 hub front + 1 hub back (a clamshell), 2 vanes,
  2 tip bracket peg halves + 2 plain halves (each arm tip clamps
  between one of each), 2 stop rings, 2 end caps, 1 thrust collar,
  and optionally 1 retainer collar (see `stl/`)
- filament: something UV-stable (ASA) for a machine that lives on a
  boat; PLA is fine for prototyping and fit checks but creeps under
  clamp preload and degrades in the sun
- 2x 608 bearing (8x22x7 — any skateboard bearing, shielded preferred)
- 8 mm aluminum rod: 1x 145 mm (shaft), 2x 600 mm (arms), 2x 113 mm
  (the vertical hinge stubs)
- 5x M5x35 bolt + nyloc + 2 wide washers each (the hub clamshell; no
  drilling there)
- 8x M3x30 bolt + nyloc + 2 small washers each (the tip bracket
  clamshells: kept light because they ride at the arm tips)
- 6x M3x16 bolt + nyloc (two each for the dual-bolt clamps: the
  thrust collar and 2 caps), plus one more if the retainer is fitted
- 4x 4.2 mm wood screws, and a plank to screw the base onto (any
  thickness, no hole: nothing reaches below the base)

## Calibration before printing the real parts

Printers and filaments vary; the three fits are measured, not guessed.
They are specific to the printer, the slicing profile, AND the
filament: gauges sliced with a different nozzle profile or printed in
a different material do not transfer, so prototyping in PLA and then
building the real machine in ASA means running the gauges again in
ASA with the production profile.

1. Print `stl/bearing_pocket_gauge.stl`, press a bearing into each ring,
   put the number of the firm-but-not-brutal one into `bearing_press_d`
   in `cad/design_params.scad`.
2. Print `stl/rod_fit_gauge.stl`, push the rod through the holes. The
   one it presses into firmly is `rod_snug_d`; the smallest one it spins
   in without grabbing is `rod_free_d`.
3. `python3 scripts/regen_all.py` and print the real parts.

## Assembly

Step-by-step guide with rendered images: [docs/assembly.md](docs/assembly.md).
The short version: bearings pressed into the base; shaft and arms
laid into the hub clamshell and bolted, the retainer clamped flush
with the shaft tip; the base slid onto the shaft from the tip end
until its bottom race rests on the retainer, the thrust collar
gauged a millimeter off the top race and clamped, then everything
flipped upright and the base screwed down; the tip bracket
clamshells bolted over arms and stubs, sleeves and caps slid on, and
each cap rotated to its driven-stop angle, both the same way around,
and clamped.
Nothing is drilled anywhere, not the rods, not
the printed parts, not even the plank, and no joint is permanent: the
hub is a clamshell, everything else is a slit clamp, so every
position and stop angle can be reset by loosening a bolt or two.
Re-torque the clamps at the start of each season, printed plastic
relaxes.

## Working on the design

CAD is OpenSCAD, rendered headlessly through nix; derived artifacts are
regenerated by one command and gated before commit:

- `python3 scripts/regen_all.py` after any .scad change
- `python3 scripts/regen_all.py --check` before any commit

The gates cover interface dimensions (`check_params.py`), the assembly
stack-up (`geometry_check.py`), and performance (`performance_check.py`:
the wind speed the rotor spins up at, a parasitic drag ratchet, and
storm-case safety factors for every load path). CI runs the same
command, so a change that would not fit, not start, or not survive
does not merge.

See `CLAUDE.md` for the full workflow and design rules.
