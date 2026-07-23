// ==============================================================================
//   BASE — screws flat onto the plank, carries the whole rotor.
//
//   Prints flange-down, no supports. A flange with countersunk
//   wood-screw holes, a central tower, and gussets between them. The
//   bottom of the tower is hollow: a base_cavity_d cavity, open to the
//   plank, holds the uplift retainer, and two windows in the tower
//   wall (at the screw-hole angles, clear of the gussets) give finger
//   and hex-key access to it. The retainer itself goes in from below
//   before the base is screwed down; the windows are too narrow to
//   pass it, which is what keeps it captive.
//
//   Above the cavity the tower holds TWO 608 bearings: the bottom
//   pocket opens down into the cavity (that bearing is pressed up from
//   below, use a spare 608 as the drift so the force lands on the
//   outer race), the top pocket opens up. Between the pockets the bore
//   narrows to tower_bore_d, which shoulders the OUTER races only; the
//   12 mm inner-race shoulders spin free of it.
//
//   Both bearings sit pocket_recess inside their pocket mouths, so the
//   rotating inner races never rub the cavity ceiling (bottom) or the
//   thrust collar body (top).
//
//   Load path: rotor weight -> thrust collar -> top bearing inner race
//   -> balls -> outer race -> the upward-facing pocket shoulder ->
//   tower. Uplift (a wave or gust unloading the rotor) reverses it:
//   retainer -> bottom inner race -> balls -> outer race -> the
//   bridged pocket ceiling -> tower.
//
//   Print notes: the cavity ceiling at z=base_cavity_h and the window
//   tops bridge over open space, and the bottom pocket's 1.5 mm
//   shoulder ring bridges over the pocket above that. They droop a
//   little, which only softens faces a race presses against. Fine.
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

        // retainer cavity, open to the plank
        translate([0, 0, -0.1])
            cylinder(h = base_cavity_h + 0.1, d = base_cavity_d);
        // two access windows through the tower wall, between the gussets
        for (a = [0, 180])
            rotate([0, 0, a])
                translate([base_cavity_d / 2 - 2, -base_window_w / 2, base_t])
                    cube([(tower_od - base_cavity_d) / 2 + 3,
                          base_window_w, base_cavity_h - base_t]);
        // bottom bearing pocket (opens down into the cavity)
        translate([0, 0, base_cavity_h])
            cylinder(h = pocket_depth, d = bearing_press_d);
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
