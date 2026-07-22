# Assembly guide

What you need at the bench: the printed parts (see the BOM in the
README), the two 608 bearings, the three rod pieces (1x 150 mm, 2x
600 mm of 8 mm aluminum), the M3 bolts with nyloc nuts, four wood
screws, a vise, and a drill with a 3 mm bit.

One technique repeats through the whole build. Every rod joint is a
through-bolt: hold the printed part at its final position and angle,
drill 3 mm through the aluminum rod using the part's own printed bolt
hole as the guide, push the M3 bolt through and tighten the nyloc nut
into its pocket. Nothing relies on friction against the smooth rod, so
nothing can creep or twist loose later.

ALL drilling happens at the bench, never on the mounted machine. The
rotor lifts freely out of the bearings, so whenever a position can
only be found on the machine, you set it there, then lift the rotor
out and drill on the bench. Position and angle are permanent once
bolted, so each step says when to drill.

The images regenerate from the CAD via `python3 scripts/regen_all.py`
(they are `cad/main_assembly.scad` rendered at `-D step=N`), so they
always match the current parameters.

## 1. Base, bearings, plank

Press one bearing into the pocket on top of the tower and one into the
pocket underneath, both flush to their recess floors. If the fit
fights you, recheck `bearing_press_d` with the calibration gauge
instead of forcing it. Screw the base to the plank with the four wood
screws; the plank itself keeps the bottom bearing captive.

![step 1](assembly/step1.png)

## 2. Rotor core, drilled in the vise

This all happens on the bench. First slide the plain collar (the one
without a wedge) onto the shaft from one end and leave it loose; it
cannot pass the hub later, so it must be on the shaft now.

Push the shaft into the hub's bottom socket and both 600 mm arms into
the end sockets. All three sockets are blind: the shaft bottoms out,
and the arms bottom out against the hub's center web, which guarantees
both arms reach equally far, so every position is defined without the
machine. Clamp the hub in the vise and drill all three rods through
the hub's printed holes, then bolt, heads on the same side.

![step 2](assembly/step2.png)

## 3. Mount, mark, and bolt the thrust collar

The collar's position is the one thing the bearing stack defines, so
it gets marked on the machine and drilled at the bench. Lower the
shaft through both bearings and rest its tip on a roughly 2 mm spacer
on the plank (a couple of coins). Slide the collar down, boss DOWN,
until the boss sits on the top bearing's inner race, and mark the rod
through the collar's bolt hole. Lift the rotor back out, line the
collar's hole up on the mark, drill and bolt at the bench, then
remount and remove the spacer. The whole rotor now hangs on this
collar, and the shaft tip hovers clear of the plank.

![step 3](assembly/step3.png)

## 4. Vane hardware on each arm

On each arm, slide on in this order: the arm collar (boss and wedge
facing outboard), then the vane sleeve, then the end cap with its
wedge facing inboard so it enters the sleeve's outboard notch. Nothing
is drilled yet; everything must stay free to slide and rotate for the
stop setting.

![step 4](assembly/step4.png)

## 5. Set the stops, then drill them

Set the stops with the rotor mounted, because hanging is defined by
gravity. Push the parts together at each arm tip: cap on the rod end,
about a millimeter of sideways play for the vane, arm collar boss
against the sleeve. Hold the vane hanging straight down, rotate the
end cap until its wedge face just touches the notch wall on the driven
side, and rotate the arm collar until its wedge touches the matching
wall of the inboard notch. Both wedges must land together, that is
what shares the impact; if one lands first the other is dead weight.

The two arms are set on the SAME rotational side of the rotor: viewed
from outside the arm tip, one reads clockwise and the other
counterclockwise.

Then drill at the bench: lift the whole rotor out with the hardware in
place (the snug bores hold position and angle while you carry it; a
strip of tape over each joint is cheap insurance), clamp each arm in
the vise, drill through the four printed holes, bolt, and remount.
When both arms are done, each vane swings freely about 120 degrees one
way and stops exactly at hanging the other way.

![step 5](assembly/step5.png)

## 6. Test

Spin the rotor by hand. It should coast freely on the bearings, and
each vane should clack firmly against its stops with no plastic
rubbing anywhere. In wind, the driven vane presents its face while the
returning vane folds flat, like this:

![complete](../main_assembly.png)

If it turns stiffly, either a wedge is rubbing its notch floor (the
vane needs its millimeter of end play from step 5) or something is
pressing a rotating face against a static one. That is why the stops
and the collar are positioned BEFORE their holes are drilled: a
through-bolted joint does not adjust afterwards, it gets a new hole.
