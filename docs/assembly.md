# Assembly guide

What you need at the bench: the printed parts (see the BOM in the
README), the two 608 bearings, the three rod pieces (1x 145 mm, 2x
600 mm of 8 mm aluminum), the M5 clamp bolts with wide washers and the
M3 bolts, all with nyloc nuts, four wood screws, screwdrivers or hex
keys to suit (a ball-end hex key is worth having: it reaches the
retainer bolt through the tower window at an angle), and something
about 1 mm thick (a folded business card, a feeler gauge) for setting
the retainer gap. Nothing is drilled in the whole build: not the
rods, not the printed parts, and not the plank either.

Two joint types cover the whole build, and both are clamps. The hub
is a clamshell: lay the rods into the grooves and bolt the halves
together. The collars and end caps are wide slit clamps, each closed
by two M3 bolts crossing the slit: slide to position, set the angle,
tighten both bolts. Every joint stays re-adjustable by loosening two
bolts, and the flip side of friction everywhere is maintenance:
re-torque every clamp bolt at the start of each season, because
printed plastic relaxes.

The images regenerate from the CAD via `python3 scripts/regen_all.py`
(they are `cad/main_assembly.scad` rendered at `-D step=N`), so they
always match the current parameters.

## 1. Base, bearings, retainer in, base screwed down

Press one bearing into the pocket on top of the tower, flush to its
recess floor. The bottom pocket sits 20 mm up inside the tower, above
the retainer cavity: turn the base over, drop the bearing into the
cavity, and press it up until it seats against the pocket ceiling.
Push on the OUTER race only; a spare 608 from the pack, held flat on
top, makes a good drift. If either fit fights you, recheck
`bearing_press_d` with the calibration gauge instead of forcing it.

Drop the retainer collar (the small single-bolt one) into the cavity.
It must go in now, from below, before the base is screwed down: the
tower windows are deliberately too narrow to pass it. Once it is
clamped to the shaft in step 3 it also keeps the bottom bearing
captive.

Set the base on the plank, retainer lying loose inside, and drive the
four wood screws. The plank needs no hole and no minimum thickness;
nothing reaches below the base.

![step 1](assembly/step1.png)

## 2. Rotor core, clamped in the clamshell

This all happens on the bench, and nothing is drilled. First slide
the thrust collar (the wide plain one, no wedge) onto the shaft and
leave it loose: it cannot pass the hub later, so it must be on the
shaft now. The small single-bolt retainer is not part of this step;
it is already waiting inside the base cavity from step 1.

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

![step 2](assembly/step2.png)

## 3. Mount the rotor, clamp both shaft collars

Lower the shaft down through both bearings. Near the bottom, guide
the tip into the retainer waiting in the cavity (a finger through a
tower window centers it under the shaft) and push on until the tip
rests on the plank; the last centimeter presses snugly through the
retainer bore, which is by design, that snugness is what will hold
the retainer in place while its gap is set.

Lift the whole rotor a few millimeters, watching the tip through a
window: anywhere clearly off the plank and still inside the retainer
is right. Hold it there, slide the thrust collar down, boss DOWN,
onto the top bearing's inner race, and tighten its two clamp bolts
evenly. The whole rotor now hangs on this collar, so give its bolts
a deliberate, even torque.

Now the retainer: through a window, slide it up the shaft to about
1 mm short of the bottom bearing's inner race, boss UP. Hold the
folded business card between boss and race, push the collar against
it, tighten its single bolt with the ball-end hex key through the
opposite window, and pull the card out. The gap matters: the
retainer must touch nothing while the rotor runs. Its job is to
catch the inner race if a wave or a gust unloads the rotor, so the
shaft can never lift out of its bearings, and it keeps the bottom
bearing captive.

The image below shows the base cut open so the collars and the
retainer are visible; yours is in one piece.

![step 3](assembly/step3.png)

## 4. Vane hardware on each arm

On each arm, slide on in this order: the arm collar (boss and wedge
facing outboard), then the vane sleeve, then the end cap with its
wedge facing inboard so it enters the sleeve's outboard notch. Leave
every clamp bolt loose; everything must stay free to slide and rotate
for the stop setting.

![step 4](assembly/step4.png)

## 5. Set the stops, then clamp them

Set the stops with the rotor mounted, because hanging is defined by
gravity. Push the parts together at each arm tip: cap on the rod end,
about a millimeter of sideways play for the vane, arm collar boss
against the sleeve. Hold the vane hanging straight down, rotate the
end cap until its wedge face just touches the notch wall on the driven
side, and rotate the arm collar until its wedge touches the matching
wall of the inboard notch. Both wedges must land together, that is
what shares the impact; if one lands first the other is dead weight.
Tighten each part's two clamp bolts while holding its angle.

The two arms are set on the SAME rotational side of the rotor: viewed
from outside the arm tip, one reads clockwise and the other
counterclockwise. When both are done, each vane swings freely about
120 degrees one way and stops exactly at hanging the other way. If an
angle ends up wrong, loosen two bolts and set it again, nothing is
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
