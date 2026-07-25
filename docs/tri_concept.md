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

The idea: every rod in the tri lands on a printed step and is
pulled home by one M5 with a washer into a tapped hole in the
rod's end. The dual clamps rods because a DIY build cannot machine
them; the tri PREPARES its rods (drill 4.2 mm, tap M5x0.8, 10 mm
deep) and buys back almost every fastener and every set-by-hand
step. One drill size, one tap, no lathe.

## The split hub

The tri's hub (`cad/tri/tri_hub.scad`) is a cylinder split on the
horizontal plane containing all three arm axes. The arms lie in
radial half-round seats and butt against the boss circle around
the bolt bore; the top half closes over them, and one central M5
with a washer runs down through both halves into a tapped hole in
the shaft's top end. Tightening it pulls the shaft face up against
the socket shoulder and presses the halves together, so a single
bolt clamps three arms and locks the shaft axially at once. The
three rods at 120 degrees key the halves against relative
rotation, so there are no registration pegs, and the dual's
clamshell rule carries over: the seats are cut shy by
`tri_hub_gap`, so preload lands on the rods, never on
face-to-face plastic. Both halves print seats-up with every bore
vertical.

This is a deliberate divergence from the dual's no-rod-is-ever-
drilled rule, and it marks the variants' characters: the dual is
the fully DIY machine (hacksaw and hex keys only), the tri leans
commercial-kit, with a PREPARED shaft (drill 4.2 mm, tap M5x0.8,
10 mm deep in one end). Sourcing that prepared shaft:

- Tube cannot be tapped: any 8 mm tube has a bore at or above 5
  mm, which is already larger than the M5 thread. Solid rod only.
- Solid 8 mm aluminum rod taps easily by hand: center punch,
  drill 4.2 mm about 14 mm deep, tap M5x0.8. A lathe makes it
  concentric and fast but is not required, because the socket
  locates the shaft and the bolt only supplies axial preload, so
  thread concentricity is not critical.
- For kits, linear-motion suppliers sell ground 8 mm shafts with
  female-tapped ends as a standard catalog option, which is zero
  machining.

Considered and set aside, recorded so it is not rediscovered: a
MALE die thread on the shaft top instead of the tap (8 mm rod is
an M8 blank, so a hand die is the cheapest prep of all), with the
hub squeezed between a shoulder nut under its bottom face and a
top nut. Mechanically it works, but it puts thread roots at the
shaft's highest-bending cross-section, right where the shaft
exits the hub: the M8 minor diameter of about 6.5 mm roughly
halves the bending section modulus and adds a fatigue notch to a
joint the stop clack vibrates for years, and the shoulder nut
reintroduces a set-by-position adjustment where the tap gives
pure geometry. The female tap keeps the critical section a solid
8 mm circle inside a snug printed socket. Die threads remain a
good trick for any future joint that carries no bending.

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
seven M5 screws with washers (one hub, three stub, three cap, all
into tapped rod ends, threadlocked against stop vibration), eight
M3s with nylocs (three arm-clamp pairs and the thrust collar),
and the rod prep of seven M5 taps across four rods. No nuts are
juggled anywhere, and nothing is set by feel: the arms butt the
hub's boss circle, the stubs land on their steps, every stop angle
is keyed geometry, and the one adjustable joint left in the whole
machine is the gauged thrust collar on the shaft.

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
arms first via the split hub above (pure consistency, dual vanes
throughout), then washers, then film vanes, then the reach-for-arm
trade only if the water still asks for it. Further tri ideas land
here as they come.
