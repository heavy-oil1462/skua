// ==============================================================================
//   BASE — screws flat onto the plank, carries the whole rotor.
//
//   Prints flange-down, no supports. A flange with countersunk wood-screw
//   holes, a central tower, and gussets between them. The tower holds TWO
//   608 bearings: the top pocket opens up, the bottom pocket opens down
//   (that bearing goes in from underneath before the base is screwed on;
//   the uplift retainer collar on the shaft keeps it captive — the plank
//   has a plank_hole_d clearance hole under the tower, so the plank no
//   longer does). Between the pockets the bore narrows to tower_bore_d,
//   which shoulders the OUTER races only — the 12 mm inner-race
//   shoulders spin free of it.
//
//   Both bearings sit pocket_recess below their tower face, so the
//   rotating inner races never rub the plank (bottom) or the thrust
//   collar body (top).
//
//   Load path: rotor weight -> shaft collar -> top bearing inner race ->
//   balls -> outer race -> the upward-facing pocket shoulder -> tower.
//   Uplift (a wave or gust unloading the rotor) reverses it: retainer
//   collar -> bottom inner race -> balls -> outer race -> the bridged
//   pocket ceiling -> tower.
//
//   Print note: the bottom pocket's shoulder is a 1.5 mm ring bridged
//   over the pocket at z=7.5 — it droops a little, which only softens
//   the face the outer race presses against. Fine.
// ==============================================================================

include <design_params.scad>

$fn = 100;

module base() {
    pocket_depth = bearing_w + pocket_recess;
    difference() {
        union() {
            // flange
            cylinder(h = base_t, d = base_d);
            // bearing tower
            cylinder(h = tower_h, d = tower_od);
            // gussets, rotated off the screw holes so heads stay reachable
            for (i = [0 : screw_count - 1])
                rotate([0, 0, (i + 0.5) * 360 / screw_count])
                    gusset();
        }

        // countersunk wood-screw holes
        for (i = [0 : screw_count - 1])
            rotate([0, 0, i * 360 / screw_count])
                translate([screw_circle_d / 2, 0, 0]) {
                    translate([0, 0, -1])
                        cylinder(h = base_t + 2, d = screw_hole_d);
                    // countersink cone, flush at the flange top
                    translate([0, 0, base_t - (screw_head_d - screw_hole_d) / 2])
                        cylinder(h = (screw_head_d - screw_hole_d) / 2 + 0.01,
                                 d1 = screw_hole_d, d2 = screw_head_d);
                }

        // bottom bearing pocket (opens down)
        translate([0, 0, -0.1])
            cylinder(h = pocket_depth + 0.1, d = bearing_press_d);
        // top bearing pocket (opens up)
        translate([0, 0, tower_h - pocket_depth])
            cylinder(h = pocket_depth + 0.1, d = bearing_press_d);
        // through bore between the pockets
        translate([0, 0, -0.1])
            cylinder(h = tower_h + 0.2, d = tower_bore_d);
    }
}

// Triangular rib from the tower wall out along the flange
module gusset() {
    rotate([90, 0, 0])
        translate([0, 0, -gusset_t / 2])
            linear_extrude(height = gusset_t)
                polygon([[tower_od / 2 - 1, 0],
                         [tower_od / 2 + gusset_reach, 0],
                         [tower_od / 2 - 1, gusset_h]]);
}

base();
