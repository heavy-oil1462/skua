// ==============================================================================
//   VANE — the flapping flag at the end of each arm (print TWO).
//
//   A sleeve that spins freely on the VERTICAL stub rod at the arm
//   tip, with a stiffened panel reaching out horizontally from it,
//   like a door on a hinge. The hinge being vertical is the low-wind
//   self-start: folding never lifts any weight, so the free vane
//   weathervanes at a whisper while the stopped vane presents its
//   face. The wind mechanism still needs ASYMMETRY: a vane that could
//   swing all the way around would just weathervane and the rotor
//   would never start. So the sleeve's end faces carry a pie-shaped
//   stop notch; a stop wedge rides in each (end cap on top, the tip
//   bracket's printed wedge underneath, sharing the impact) and
//   limits the swing to
//   vane_swing_deg. Pushed one way the vane trails flat and slips
//   through the wind; pushed the other way it hits the stop, presents
//   its full face, and drags the rotor around. Both vanes stop in the
//   same rotational sense seen from above, so their torques add. The
//   bang against the stop is free gull-scaring percussion.
//
//   The panel spans the sleeve and overhangs its top end by
//   vane_width - vane_sleeve_len (in use: past the end cap, which the
//   panel's near edge clears; geometry_check gates it), so the sleeve
//   sits toward the bottom of the flag. The sleeve's lower end face
//   rests on the tip bracket's boss ring, so the vane spins with
//   little friction and no printed face rubs a large one.
//
//   The notch is cut into BOTH ends: the cap wedge and the collar
//   wedge each get one. Its radial walls match the wedge's flat side
//   faces, so the stop is a face contact. The stop positions are set
//   at assembly by rotating cap and collar before clamping (see
//   README): panel pointing straight out along the arm is the driven
//   stop.
//
//   Prints flat on the panel, no supports: the sleeve lies on the bed
//   and its bore is a teardrop (lib/bores.scad).
// ==============================================================================

include <design_params.scad>
use <lib/bores.scad>

$fn = 80;

// the stop wedge's own width eats stop_wedge_deg of the notch arc
notch_deg   = vane_swing_deg + stop_wedge_deg;
notch_depth = stop_wedge_len + 1;

module vane() {
    sleeve_r = vane_sleeve_od / 2;
    difference() {
        union() {
            // sleeve, axis along X at z = sleeve_r (lying on the bed)
            translate([-vane_sleeve_len / 2, 0, sleeve_r])
                rotate([0, 90, 0])
                    cylinder(h = vane_sleeve_len, r = sleeve_r);
            // wedge web joining the sleeve to the panel's top edge
            hull() {
                translate([-vane_sleeve_len / 2, 0, sleeve_r])
                    rotate([0, 90, 0])
                        cylinder(h = vane_sleeve_len, r = sleeve_r);
                translate([-vane_sleeve_len / 2, sleeve_r + 4, 0])
                    cube([vane_sleeve_len, 4, vane_t]);
            }
            // the panel: one edge flush with the sleeve's lower end
            // (-x, the bottom in use), overhanging the other
            translate([-vane_sleeve_len / 2, sleeve_r, 0])
                cube([vane_width, vane_reach - sleeve_r, vane_t]);
            // stiffening rim: both x edges (bottom and top in use),
            // the outer edge, and the near edge of the overhang
            translate([-vane_sleeve_len / 2, sleeve_r, 0])
                cube([vane_rim_w, vane_reach - sleeve_r, vane_rim_h]);
            translate([-vane_sleeve_len / 2 + vane_width - vane_rim_w,
                       sleeve_r, 0])
                cube([vane_rim_w, vane_reach - sleeve_r, vane_rim_h]);
            translate([-vane_sleeve_len / 2, vane_reach - vane_rim_w, 0])
                cube([vane_width, vane_rim_w, vane_rim_h]);
            translate([vane_sleeve_len / 2, sleeve_r, 0])
                cube([vane_width - vane_sleeve_len, vane_rim_w,
                      vane_rim_h]);
        }

        // free-spinning bore
        translate([-vane_sleeve_len / 2 - 0.5, 0, sleeve_r])
            rod_bore(rod_free_d, vane_sleeve_len + 1);

        // stop notches, both end faces, centered on the panel side
        for (m = [0, 1]) mirror([m, 0, 0])
            translate([vane_sleeve_len / 2 - notch_depth, 0, sleeve_r])
                rotate([0, 90, 0])
                    linear_extrude(height = notch_depth + 0.5)
                        pie(sleeve_r + 1, notch_deg);
    }
}

// 2D pie wedge of the given radius/angle. Drawn centered on the -X
// direction of the extrusion plane, which after the rotate([0, 90, 0])
// above points straight up in print orientation — the panel plane's
// NORMAL, not the panel side. Mechanically the notch's angular position
// is arbitrary (the stop angle is set at assembly by rotating cap and
// collar), but main_assembly.scad's wedge_set is derived from this
// reference, so move both together.
module pie(r, deg) {
    polygon(concat([[0, 0]],
        [for (a = [-deg / 2 : 5 : deg / 2]) [-r * cos(a), r * sin(a)]],
        [[-r * cos(deg / 2), r * sin(deg / 2)]]));
}

vane();
