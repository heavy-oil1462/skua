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
the tri v0.1 as currently planned: the vane side is the dual's
verbatim (8 mm arms and stubs, real tip bracket, stop ring, solid
vane and end cap), and only the center is new. The tri models use
`tri_` prefixed parameters and nothing from `cad/tri/` is exported
to `stl/`.

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
