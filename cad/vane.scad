// ==============================================================================
//   VANE — the flapping flag on the end of each arm (print TWO).
//
//   A sleeve that spins freely on the arm rod, with a stiffened panel
//   hanging from it. The wind mechanism needs ASYMMETRY: a vane that
//   could swing all the way around would just weathervane and the rotor
//   would never start. So the sleeve's end faces carry a pie-shaped stop
//   notch; a stop wedge rides in each (end cap outboard, arm collar
//   inboard, sharing the impact) and limits the swing to
//   vane_swing_deg. Pushed one way the vane folds flat and slips through
//   the wind; pushed the other way it hits the stop, presents its full
//   face, and drags the rotor around. Both vanes stop in the same
//   rotational sense, so their torques add. The bang against the stop is
//   free gull-scaring percussion.
//
//   The notch is cut into BOTH ends: the cap wedge and the collar wedge
//   each get one, and the part fits either arm with either end
//   outboard. Its radial walls match the wedge's flat side faces, so
//   the stop is a face contact. The stop positions are set at assembly
//   by rotating cap and collar to the same angle before clamping (see
//   README).
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
            // the panel
            translate([-vane_width / 2, sleeve_r, 0])
                cube([vane_width, vane_drop - sleeve_r, vane_t]);
            // stiffening rim: sides and bottom edge
            for (m = [0, 1]) mirror([m, 0, 0])
                translate([vane_width / 2 - vane_rim_w, sleeve_r, 0])
                    cube([vane_rim_w, vane_drop - sleeve_r, vane_rim_h]);
            translate([-vane_width / 2, vane_drop - vane_rim_w, 0])
                cube([vane_width, vane_rim_w, vane_rim_h]);
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
