# The tri variant: consistent spin in the least wind

Skua ships in two parallel variants, each with its own release line
tagged on main:

- the DUAL: two arms, solid vanes, the mature machine (v1.0 at tag
  time). Its docs are the README and the assembly guide.
- the TRI: three arms, the light-wind variant, young (tri-v0.1
  when it first flies). This document and `cad/tri/` are its home
  while it grows; it is a sibling of the dual, not its successor,
  and both live on.

Status: concept study. Nothing under `cad/tri/` changes dual parts,
parameters or gates, and nothing from it is exported to `stl/`.

One constraint carries over from the dual: the overall span stays
close to today's sweep circle, so when vane reach grows the arms
shorten to match. Everything else is open.

![tri concept](tri_assembly.png)

The scene is `cad/tri/tri_assembly.scad`; open it in OpenSCAD to
walk around it (regen_all renders it to the image above). It shows
the tri v0.1 as currently planned: the vane, stop ring and all rod
stock are the dual's verbatim, while the hub, tip bracket and end
cap are the tri's own joints, built on one recurring idea. The tri
models use `tri_` prefixed parameters and nothing from `cad/tri/`
is exported to `stl/`.

The idea: the tri's rods end in threads, and every joint is a
face pulled home along that thread, with printed plastic doing
only keying and spacing. The dual clamps rods because a DIY build
cannot machine them; the tri PREPARES its rods and buys back
almost every fastener and every set-by-hand step. The whole
toolchain is hand tools: one M8x1.25 die for the shaft, one 4.2 mm
drill and M5x0.8 tap for the stubs, no lathe.

## The washer-jaw hub

The hub (`cad/tri/tri_hub.scad`) went through several sizes on
the way down and landed as small as the job allows: ONE printed
spacer disc, thinner than the rod. Three full-height slots key
the arms at 120 degrees, the arms butt the boss circle and stand
proud of both faces by 0.4 mm each, and two large M8
fender washers press onto the rods from either side, clamped by
M8 nylocs on the shaft's die-threaded top end (8 mm rod is
exactly an M8 thread blank, so a hand die self-aligns and this
rod is never drilled at all; the lower nut is the shoulder, run
to the die's thread runout, and the upper one is the clamp).

The load path is worth stating: steel washer, aluminum rod, steel
washer, steel nut. No plastic sits in compression anywhere in
this joint, so unlike every clamp on the dual it does not relax
and never needs the seasonal re-torque. The disc only keys: its
slot flanks carry the arms' horizontal storm bending as bearing
over 18 mm, the washer faces square the hub on the shaft, and the
disc prints flat in minutes.

A structural note, recording a correction: an earlier pass
rejected male thread on the shaft, claiming the storm case fails
at the threaded exit with a safety factor near 0.7. That number
was wrong, it borrowed the ARM's root moment (about 5.8 Nm). The
shaft at the hub only carries the vane drag over the short lever
down to the top bearing, about 1 Nm at survival wind, so even on
the M8 minor section the stress is about 42 MPa against the
alloy's 160: a storm factor near four, with gust amplitudes far
below fatigue concern. The storm-critical member is and remains
the arm, unaffected by any hub choice.

Sourcing notes for the prepared rods, kept from earlier rounds:

- Tube cannot be tapped: any 8 mm tube has a bore at or above 5
  mm, already larger than the M5 thread. Solid rod only.
- Solid 8 mm rod taps easily by hand (center punch, drill 4.2 mm
  about 14 mm deep, tap M5x0.8), and dies easily by hand (chamfer
  the end, run the die). Concentricity is not critical in either
  case, because bores and steps locate the rods and the threads
  only supply axial preload.
- For kits, linear-motion suppliers sell ground 8 mm shafts with
  threaded ends as a standard catalog option, which is zero
  machining.

## The screwed stub tip

The stub is the tri's second prepared rod, tapped at BOTH ends
(`cad/tri/tri_tip_bracket.scad`, `cad/tri/tri_end_cap.scad`). At
the bottom, the bracket's through groove becomes a plain snug bore
over a printed step: the stub drops in from above, lands face-down
on the step, and an M5 from below pulls it home, so stub height is
geometry and the bracket's stub-clamp bolt pair is gone; the
clamshell's only remaining duty is clamping the arm with two M3s.
At the top, the cap is a smooth disc whose bore ceiling lands on
the stub's top face, pulled home by an M5 from above.

The cap is smooth because the tri drops the upper stop wedge
entirely, on a field finding from the dual: two stop faces never
land exactly together, so one face takes every hit regardless of
the design intent. The tri accepts that and makes it official: the
ring fin is the ONLY stop. The stop-face gate in
`performance_check` already sizes a single face for the full
dynamic impact, the ring is the cheap keyed sacrificial part and
swaps by popping the cap, and with no wedge the cap has no angular
job: no key, no flat on the stub, no set-at-assembly step, and
nothing proud of the cap cylinder for the folding flag to hit.
The vane sleeve's upper notch simply goes unused, so the vane
stays the shared dual part. If the water agrees that one stop is
enough, the same deletion is a candidate for the dual line later.

A tri-only vane with no upper notch is a noted option, deferred on
purpose: the unused notch costs nothing, keeping the dual vane
means every existing print builds a tri, and the tri's real own
vane is the film-and-frame one further down the ladder, which
will be drawn notchless from the start rather than forking the
solid vane for a cosmetic deletion now.

What the whole tri now needs, beyond printed parts and rod stock:
six M5 screws with washers (three stub, three cap, into tapped
rod ends, threadlocked against stop vibration), two M8 nylocs
with fender washers at the hub, eight M3s with nylocs (three
arm-clamp pairs and the thrust collar), and the rod prep of one
die pass on the shaft and six taps across the three stubs.
Nothing is set by feel: the arms butt the hub's boss circle, the
stubs land on their steps, every stop angle is keyed geometry,
and the one adjustable joint left in the whole machine is the
gauged thrust collar on the shaft.

The dual's performance work showed what limits low-wind running
once the geometry is tuned: thrust-seat friction, vane mass, and
the two-arm torque gap. `scripts/tri_study.py` models the candidate
fixes as a cumulative ladder; run it for current numbers. The
directional findings:

- The worst parking angle of the two-arm rotor produces NEGATIVE
  torque (the wind holds it against rotation), which is the rocking
  behavior seen at low wind. Three arms at 120 degrees turn the
  worst angle into about 0.7 of mean torque; this is the single
  biggest consistency change and needs a new hub, a third arm and a
  third vane, nothing else.
- A PTFE washer on each thrust seat cuts self-start from about 1.0
  to about 0.66 m/s; film-and-frame vanes (printed perimeter,
  mylar or ripstop skin, ~28 g against 78) take it to about 0.4 and
  also fix the re-arm margin (about 70 degrees of transit against
  the 90 degree window, comfortably early).
- Holding the span while trading arm length for vane reach (500 mm
  arms, 250 mm reach) needs 10 mm arm rod, abandoning the dual's
  one-rod-stock rule, and lands self-start around 0.26 m/s with a
  better storm margin than the dual has today.
- A meter more tower height is worth about ten percent of wind at
  threshold from the boundary layer alone.

Rejected endpoint, recorded so it is not rediscovered: cup or
Savonius geometry spins earliest of all but loses the flapping and
the clack that actually scare gulls; a rotation-driven clacker
would have to be bolted on, at which point the swing-vane concept
is the simpler machine.

Build order as the tri matures toward its first release: three
arms first via the washer-jaw hub above (pure consistency, dual
vanes throughout), then washers, then film vanes, then the
reach-for-arm trade only if the water still asks for it. Further
tri ideas land here as they come.
