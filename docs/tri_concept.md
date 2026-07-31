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
the tri as currently planned: the ENTIRE vane assembly, tip
bracket, stub, PTFE thrust washer, vane and cap-wedge stop, is the
dual's verbatim, printed and bought once more per extra arm. Only
the hub is the tri's own (its wider washer-jaw sizing lives in
`tri_` prefixed parameters), and nothing from `cad/tri/` is
exported to `stl/`.

The recipe is deliberately minimal: the only new joint is the hub,
and the only rod prep in the whole machine is one M8x1.25 die pass
on the shaft's top end (8 mm rod is an M8 blank, so a hand die
self-aligns; no drilling, no taps, no lathe). A third vane-arm set
from the dual's own STLs plus the hub hardware turn dual spares
into a tri rotor, and every spare fits both machines.

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

A second variant sits between this and the split hub it replaced,
modeled alongside it (`tri_hub_shell`, currently the one in the
scene): two identical thin half-shells, each a 3.6 mm half-seat
over a 2.4 mm web, cradle the arms over the full grip, and the
washers clamp the sandwich. The arms get distributed bearing top
and bottom instead of the washer rim's edge clamp, and nothing
can ever rattle; the price is those webs putting plastic back in
the clamp path, so a mild version of the dual's clamp creep
returns (low stress over a large washer footprint, and a spring
washer under each nut absorbs what little there is). Same
hardware, same print-two-of-one-part, 13 mm tall against 7. The
slot disc is the no-re-torque purist, the shells are the gentler
cradle; the bench and the water pick between them. The dual has
since adopted exactly this shell sandwich as its own hub
(`cad/hub_shell.scad`), sized for two arms.

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

## Dropped directions, recorded so they stay dropped

The tri once carried its own vane-assembly variants: a keyed stop
ring with a fin (angle baked into a bracket pocket, no
set-at-assembly step), a wedge-free clamp cap, a bottom-notched
vane, and a deferred screwed-stub tip (stubs tapped both ends,
pulled home by M5s, the direction a commercial kit might take).
All of it was deleted when the tri adopted the dual's vane
assembly wholesale. The reasons, so nobody re-derives the parts:
one part set now serves both machines (every printed spare fits
either rotor), the taps stay out of the toolchain, and the dual's
field seasons showed the adjustable cap stop is the knob you
actually want on the water, worth its price of hand-setting the
caps to a common sense — a price the tri pays once more per extra
arm. The keyed-stop idea itself was sound and lives in git
history if a kit round ever wants it back.

What the tri needs, beyond printed parts and rod stock: the hub's
two M8 nylocs with fender washers, and the dual's own tip
hardware three times over (four M3x25 per bracket clamshell, two
M3x16 per cap, two more at the thrust collar). Rod prep is the
single die pass on the shaft. The arms butt the hub's boss
circle; the set-by-hand joints are the gauged thrust collar and
the three cap wedges, same sense seen from above so the torques
add.

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
- The PTFE thrust washer, once a tri ladder rung, is the dual's
  own baseline seat now. Film-and-frame vanes (printed perimeter,
  mylar or ripstop skin, ~28 g against 78) are the next real rung:
  they cut self-start sharply and also fix the re-arm margin (run
  the study for current numbers).
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
