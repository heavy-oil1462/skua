# Assembly guide

What you need at the bench: the printed parts (see the BOM in the
README), the two 608 bearings, the three rod pieces (1x 150 mm, 2x
600 mm of 8 mm aluminum), the M3 bolts with nyloc nuts, four wood
screws, and a drill with a 3 mm bit.

One technique repeats through the whole build. Every rod joint is a
through-bolt: hold the printed part at its final position and angle,
drill 3 mm through the aluminum rod using the part's own printed bolt
hole as the guide, push the M3 bolt through and tighten the nyloc nut
into its pocket. Nothing relies on friction against the smooth rod, so
nothing can creep or twist loose later. Drill each hole only when the
step below tells you to, because position and angle are permanent once
bolted.

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

## 2. Shaft and thrust collar

Drop the 150 mm shaft down through both bearings until it almost
touches the plank. Slide the plain collar (the one without a wedge)
onto the shaft top, boss DOWN, and push it down until the boss rests
on the top bearing's inner race while the shaft tip hovers a couple of
millimeters above the plank. Drill and bolt. The whole rotor's weight
will hang on this collar.

![step 2](assembly/step2.png)

## 3. Hub and arms

Put the hub on the shaft top and push it down onto the shaft (the
socket is blind, it stops by itself). Seat both 600 mm arms fully into
their sockets; they bottom out against the hub's center web, which
guarantees both arms reach equally far. Check the hub is level, then
drill and bolt all three rods, heads on the same side.

![step 3](assembly/step3.png)

## 4. Vane hardware on each arm

On each arm, slide on in this order: the arm collar (boss and wedge
facing outboard), then the vane sleeve, then the end cap with its
wedge facing inboard so it enters the sleeve's outboard notch. Do not
drill anything yet; everything must stay free to slide and rotate for
the stop setting.

![step 4](assembly/step4.png)

## 5. Set the stops, then bolt them

Push the parts together at the arm tip: cap on the rod end, about a
millimeter of sideways play for the vane, arm collar boss against the
sleeve. Now set the stop angle. Hold the vane hanging straight down,
rotate the end cap until its wedge face just touches the notch wall on
the driven side, and rotate the arm collar until its wedge touches the
matching wall of the inboard notch. Both wedges must land together,
that is what shares the impact; if one lands first the other is dead
weight. Only now drill and bolt cap and collar.

The two arms are set on the SAME rotational side of the rotor: viewed
from outside the arm tip, one reads clockwise and the other
counterclockwise. When both are done, each vane swings freely about
120 degrees one way and stops exactly at hanging the other way.

![step 5](assembly/step5.png)

## 6. Test

Spin the rotor by hand. It should coast freely on the bearings, and
each vane should clack firmly against its stops with no plastic
rubbing anywhere. In wind, the driven vane presents its face while the
returning vane folds flat, like this:

![complete](../main_assembly.png)

If it turns stiffly, either a wedge is rubbing its notch floor (the
vane needs its millimeter of end play from step 5) or something is
pressing a rotating face against a static one. That is why each step
says to check the fit and spin BEFORE drilling: a through-bolted joint
does not adjust afterwards, it gets a new hole.
