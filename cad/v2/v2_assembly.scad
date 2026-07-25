// ============================================================
// v2 CONCEPT ASSEMBLY — open this file in OpenSCAD to review.
//
// Three arms at 120 degrees (the worst-parking-angle fix), 10 mm
// arm rod on 500 mm arms carrying 250 mm film-and-frame vanes
// (span held near v1's sweep), PTFE washers on the thrust seats,
// and a taller mounting drawn as a mast stub. The stub-side stack
// is v1 verbatim: 8 mm stubs, the keyed stop ring, the end cap —
// those parts are used directly so proportions are honest.
//
// CONCEPT: hub and tip knuckles are massing models, not clamshell
// designs; nothing from cad/v2/ is exported to stl/. regen_all
// renders this scene to docs/v2_assembly.png.
//
// The three vanes are posed mid-action: one hard on its driven
// stop, one weathervaned, one mid re-arm swing.
// ============================================================

include <../design_params.scad>
include <v2_params.scad>
use <../base.scad>
use <../stop_ring.scad>
use <../end_cap.scad>
use <film_vane.scad>

$fn = 48;

// stations, v1 relations with v2 lengths
shaft_top  = shaft_tip_h + shaft_length;
hub_bottom = shaft_top - hub_shaft_socket;
v2_arm_z   = hub_bottom + hub_arm_z;
v2_hub_r   = 24;                       // concept hub barrel radius
v2_stub_x  = v2_hub_r + v2_arm_length - 24;   // hinge axis radius
v2_tip_x   = v2_stub_x - 36;                  // tip knuckle start
sleeve_bot = v2_arm_z + bracket_h / 2 + collar_boss_h + v2_washer_t;
cap_face   = sleeve_bot + vane_sleeve_len + 1;

// mast stub (the taller mounting), then the v1 base on top of it
color("Silver") translate([0, 0, -v2_mast_h])
    cylinder(h = v2_mast_h, d = tower_od);
color("Tomato") base();

// shaft and concept hub: a barrel with three sockets
color("DarkGray") translate([0, 0, shaft_tip_h])
    cylinder(h = shaft_length, d = rod_d);
color("SteelBlue") difference() {
    translate([0, 0, hub_bottom]) cylinder(h = hub_h, r = v2_hub_r);
    for (k = [0 : v2_arms - 1]) rotate([0, 0, k * 360 / v2_arms])
        translate([0, 0, v2_arm_z]) rotate([0, 90, 0])
            cylinder(h = v2_hub_r + 1, d = v2_arm_rod_d);
    translate([0, 0, hub_bottom - 0.1])
        cylinder(h = hub_shaft_socket, d = rod_d);
}

// poses: driven stop, weathervaned, mid re-arm
poses = [0, vane_swing_deg, vane_swing_deg / 2];

for (k = [0 : v2_arms - 1]) rotate([0, 0, k * 360 / v2_arms]) {
    // arm rod (10 mm) socketed into the hub barrel
    color("DarkGray")
        translate([v2_hub_r - 20, 0, v2_arm_z])
            rotate([0, 90, 0])
                cylinder(h = v2_arm_length + 20 - (v2_hub_r - 20),
                         d = v2_arm_rod_d);
    // tip knuckle: massing block, arm through, stub standing
    color("SteelBlue")
        translate([v2_tip_x, -bracket_w / 2, v2_arm_z - bracket_h / 2])
            cube([50, bracket_w, bracket_h]);
    color("DarkGray")
        translate([v2_stub_x, 0, v2_arm_z - bracket_h / 2])
            cylinder(h = stub_length, d = rod_d);
    // v1 stop ring, keyed flat outboard, then the PTFE washer
    color("SteelBlue")
        translate([v2_stub_x, 0, v2_arm_z + bracket_h / 2 - ring_foot_t])
            stop_ring();
    color("White")
        translate([v2_stub_x, 0, v2_arm_z + bracket_h / 2 + collar_boss_h])
            difference() {
                cylinder(h = v2_washer_t, d = v2_washer_od);
                translate([0, 0, -0.5])
                    cylinder(h = v2_washer_t + 1, d = rod_free_d);
            }
    // film vane: modeled frame-toward +Y; at the driven stop the
    // frame points out along the arm, folding is -psi like v1
    color("Gold")
        translate([v2_stub_x, 0, sleeve_bot])
            rotate([0, 0, -90 - poses[k]])
                film_vane();
    // v1 end cap, wedge down, set to land with the fin
    color("SteelBlue")
        translate([v2_stub_x, 0, cap_face + cap_t])
            rotate([0, 0, 90 - (vane_swing_deg + ring_wedge_deg) / 2
                           + stop_wedge_deg / 2])
                rotate([180, 0, 0])
                    end_cap();
}
