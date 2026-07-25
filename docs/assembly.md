# Assembly guide

What you need at the bench: the printed parts (see the BOM in the
README), the two 608 bearings, the five rod pieces (1x 145 mm, 2x
600 mm, 2x 113 mm of 8 mm aluminum), the M5 clamp bolts with wide washers and the
M3 bolts, all with nyloc nuts, four wood screws, screwdrivers or hex
keys to suit, and, only if you fit the optional retainer, something
about 1 mm thick and no wider than about 15 mm (a strip of folded
business card, a feeler gauge) for gauging the thrust collar. Nothing
is drilled in the whole build: not the rods, not the printed parts,
and not the plank either.

Two joint types cover the whole build, and both are clamps. The hub
and the tip brackets are clamshells: lay the rods into the grooves
and bolt the halves together with washered bolts (M5 at the hub, M3
at the light tip brackets). The collars and
end caps are wide slit clamps, each closed
by two M3 bolts crossing the slit: slide to position, set the angle,
tighten both bolts. Every joint stays re-adjustable by loosening two
bolts, and the flip side of friction everywhere is maintenance:
re-torque every clamp bolt at the start of each season, because
printed plastic relaxes.

The images regenerate from the CAD via `python3 scripts/regen_all.py`
(they are `cad/main_assembly.scad` rendered at `-D step=N`), so they
always match the current parameters.

## 1. Base and bearings

Press one bearing into the pocket on top of the tower, flush to its
recess floor. The bottom pocket sits up inside the tower, above the
retainer cavity: turn the base over, drop the bearing into the
cavity, and press it up until it seats against the pocket ceiling.
Push on the OUTER race only; a spare 608 from the pack, held flat on
top, makes a good drift. If either fit fights you, recheck
`bearing_press_d` with the calibration gauge instead of forcing it.

Do NOT screw the base to the plank yet. The shaft and its retainer
enter the cavity from below, so the base meets the plank only at the
end of step 3, with the rotor already in it.

![step 1](assembly/step1.png)

## 2. Rotor core, clamped in the clamshell

This all happens on the bench, and nothing is drilled. First slide
the thrust collar (the wide plain one, no wedge) onto the shaft and
leave it loose: it cannot pass the hub later, so it must be on the
shaft now. The small single-bolt retainer goes on at the end of this
step, at the other end of the shaft.

Lay the hub front half (the one with the pegs) split face up and set
the rods into its grooves: shaft into the center groove until it
bottoms out, both 600 mm arms into the end grooves until they bottom
out against the center web, which guarantees both arms reach equally
far. Fit the back half over the registration pegs, then fit the five
M5x40 clamp bolts, each with a wide washer under the head and under
the nyloc, and tighten evenly in a couple of rounds.

The halves must NOT touch when tight: the design leaves a 0.8 mm gap
between the faces so all the bolt force squeezes the rods. An even
gap all around means the rods are gripped; faces touching anywhere
means something is not seated.

Last, the retainer, and this one is OPTIONAL: the rotor's weight
alone keeps the shaft seated in its bearings in all ordinary
conditions, so most builds skip it and add it later only if the
mooring proves rough (how, at the end of step 3). The shaft is the
same length either way. To fit it now: slide the small single-bolt
collar onto the shaft tip, boss first (boss toward the hub), and
push it flush with the tip. Easiest is to stand the tip on the bench
so tip and collar press flat against the same surface, then tighten
the bolt. Flush is the whole trick: it needs no measuring, and it is
the reference that makes the next step work.

![step 2](assembly/step2.png)

## 3. Mate rotor and base, gauge the gap, screw down

Turn the rotor upside down: hub flat on the bench, shaft pointing
up, bare arms out over the bench edges. Lower the base over the
shaft, tower top first: the shaft threads through both bearings, the
retainer disappears into its cavity, and the base comes to rest with
the bottom bearing's inner race sitting on the retainer boss.
Gravity does the aligning, and that resting contact is exactly the
uplift catch, which is what makes the next move exact.

Now gauge the running clearance, with everything out in the open:
the thrust collar hangs loose on the shaft by the tower top. Lay the
1 mm card strip on the top bearing's inner race (it must be narrow
enough to sit down on the race, inside the pocket mouth, not on the
plastic rim), push the collar boss against it, and tighten the two
clamp bolts evenly. The whole rotor will hang on this collar, so
give its bolts a deliberate, even torque, then pull the strip out.

That card thickness is exactly the play the shaft ends up with: flip
the assembly upright and the rotor settles onto the thrust collar,
leaving the retainer floating 1 mm under the bottom race, touching
nothing, ready to catch the inner race if a wave or a gust unloads
the rotor. Set the base on the plank and drive the four wood screws.
The shaft can never lift out and the bottom bearing is captive. To
re-torque the retainer bolt at season start, take out the four wood
screws and reach into the open cavity from below; every other bolt
is in the open.

Building WITHOUT the retainer: same upside-down mating, but there is
nothing for the base to rest on and no gap to gauge. Lower the base
until the tip sits a few millimeters down inside the cavity (the
cavity mouth faces up in this pose, so you can see the tip in it),
hold the base there, seat the thrust collar directly on the top race
with no card, and clamp. Flip, screw down, done; the tip just rides
loose in the cavity.

Adding the retainer later: print one, take out the four wood screws,
and lay the whole machine on its side. Slide the retainer through
the open cavity mouth onto the tip, boss toward the bearing, push it
to 1 mm short of the bottom race with the card strip between boss
and race, and tighten its bolt through the mouth. Stand it up and
screw it back down.

The image below shows the base cut open so the collars and the
retainer are visible; yours is in one piece.

![step 3](assembly/step3.png)

## 4. Tip bracket clamshells, stubs, vanes

Each tip bracket is two printed halves that close over the arm and
the stub the way the hub closes over its rods: the PEG half and the
PLAIN half (the peg sockets). Nothing needs to be juggled in
mid-air here: the stub groove runs straight through the bracket and
the ring pocket opens through its top face, so the clamshell closes
over the arm alone and the stub and ring feed in from above
afterward.

Lay the peg half groove side up and set the arm end into the long
groove until it bottoms out. Fit the plain half over the pegs and
add the four M3x30s with a small washer under each head and each
nyloc, but leave them a turn loose so the halves can float. Roll
the bracket on the arm until the stub groove points straight up,
pocket face on top, and slide a 113 mm stub down through the groove
until it sits flush with the bracket's underside; the funnel mouth
in the pocket floor guides it in. Drop the stop ring down over the
stub, D flat toward the arm tip, and seat its foot in the pocket.
The flat only fits one way, and that keyed angle is the driven
stop, so it cannot be assembled wrong and both flags get the same
rotational sense for free. Check the stub still points straight
up, ring on top, then tighten the four bolts evenly. Same rule as
the hub: the halves must NOT touch; an even gap all around means
the rods, not the plastic, carry the preload.

The stub is the vane's hinge, and vertical is the point: a hinge
gravity cannot fight is what lets the rotor start in light wind.
Drop the vane sleeve over each stub; its lower end rests on the
stop ring's boss (that small ring is the vane's whole thrust
bearing, so it spins freely) with the ring's fin inside its lower
notch. Then the end cap, open face and wedge DOWN, bolts loose; it
gets set in step 5. Stop faces take every clack; if one ever wears,
open the clamshell and drop in a freshly printed ring.

![step 4](assembly/step4.png)

## 5. Set the caps, then clamp them

The lower stop needs no setting: the keyed stop ring fixes it at
the driven angle, so the flag stops exactly at panel-along-the-arm.
Only the cap's wedge is set, to land together with the ring's fin,
because two faces sharing the impact is what the stop design counts
on.

Swing the vane against the ring's fin and hold it there. Push the
end cap down to leave the sleeve about a millimeter of vertical
play, rotate it until its wedge face just touches the upper notch
wall on the stopped side, and tighten its two clamp bolts while
holding the angle.

When both are done, each flag swings freely about 120 degrees
toward trailing (the far wall of the ring's fin catches it there)
and stops hard at panel-along-the-arm the other way. Both flags stop in the same
rotational sense automatically, courtesy of the brackets; if one
seems mirrored, its bracket is upside down (step 4). If a cap angle
ends up wrong, loosen two bolts and set it again, nothing is
permanent.

![step 5](assembly/step5.png)

## 6. Test

Spin the rotor by hand. It should coast freely on the bearings, and
each vane should clack firmly against its stops with no plastic
rubbing anywhere. In wind, the driven vane presents its face while the
returning vane folds flat, like this:

![complete](../main_assembly.png)

If it turns stiffly, either a wedge is rubbing its notch floor (the
vane needs its millimeter of end play from step 5) or something is
pressing a rotating face against a static one. Everything here is a
clamp, so any position or angle can be corrected by loosening two
bolts. The one recurring duty: re-torque all the clamp bolts at the
start of each season, and after the first week of running, because
printed plastic relaxes under preload.
