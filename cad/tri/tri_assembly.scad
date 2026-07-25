// ============================================================
// TRI VARIANT CONCEPT ASSEMBLY — open this file in OpenSCAD to review.
//
// The tri v0.1: three arms at 120 degrees (the worst-parking-angle
// fix) meeting in the split hub from tri_hub.scad, one central M5
// down into the tapped shaft end. At each tip the tri's screwed
// stub replaces the dual's clamped one: the stub drops through the
// bracket onto a printed step and is pulled home by an M5 from
// below; the smooth end cap lands on the stub's top face and is
// pulled home by an M5 from above. The stop is the ring fin alone.
// The vane, stop ring and arm rods are the dual's verbatim, and a
// PTFE washer rides each thrust seat (ladder step two; lift it off
// and the seat is pure dual).
//
// Later ladder steps (film vanes, the reach-for-arm trade) live in
// film_vane.scad and scripts/tri_study.py, not in this scene.
//
// Nothing from cad/tri/ is exported to stl/. regen_all renders
// this scene to docs/tri_assembly.png.
//
// The three vanes are posed mid-action: one hard on its driven
// stop, one weathervaned, one mid re-arm swing.
// ============================================================

include <../design_params.scad>
include <tri_params.scad>
use <../base.scad>
use <../stop_ring.scad>
use <../vane.scad>
use <tri_hub.scad>
use <tri_tip_bracket.scad>
use <tri_end_cap.scad>

$fn = 48;

// stations: the dual's relations with the tri joints in place
shaft_top   = shaft_tip_h + shaft_length;
hub_bot_z   = shaft_top - tri_hub_socket;
split_z     = hub_bot_z + tri_hub_bot_h;     // bottom half's top face
tri_arm_z   = split_z + tri_hub_gap / 2;     // arm axes ride the gap
arm_root    = tri_hub_boss_d / 2;            // arms butt the boss circle
arm_tip     = arm_root + arm_length;
bracket_x   = arm_tip - bracket_arm_grip;
stub_x      = bracket_x + bracket_stub_x;
bracket_bot = tri_arm_z - bracket_h / 2;
sleeve_bot  = tri_arm_z + bracket_h / 2 + collar_boss_h + tri_washer_t;
cap_under   = sleeve_bot + vane_sleeve_len + 1;

// an M5 with its washer: seat at z = 0, head up, shank reaching
// down into a tapped rod end (the tri's one recurring fastener)
module tri_m5_screw(reach) {
    cylinder(h = 1.2, d = 12);                            // washer
    translate([0, 0, 1.2]) cylinder(h = 4, d = 8.5);      // head
    translate([0, 0, -reach]) cylinder(h = reach, d = 5); // shank
}

// mast stub (the taller mounting, drawn as a pole), then the dual
// base on top of it
color("Silver") translate([0, 0, -tri_mast_h])
    cylinder(h = tri_mast_h, d = 25);
color("Tomato") base();

// shaft, then the split hub closed over the arms: bottom half
// socketed on the shaft, top half flipped seats-down, the central
// M5 seated in the counterbore reaching the tapped shaft end
color("DarkGray") translate([0, 0, shaft_tip_h])
    cylinder(h = shaft_length, d = rod_d);
color("SteelBlue") translate([0, 0, hub_bot_z]) tri_hub_bottom();
color("SteelBlue")
    translate([0, 0, split_z + tri_hub_gap + tri_hub_top_h])
        rotate([180, 0, 0]) tri_hub_top();
color("Silver")
    translate([0, 0, split_z + tri_hub_gap + tri_hub_top_h
                     - tri_bolt_cbore_h])
        tri_hub_bolt();

// poses: driven stop, weathervaned, mid re-arm
poses = [0, vane_swing_deg, vane_swing_deg / 2];

for (k = [0 : tri_arms - 1]) rotate([0, 0, k * 360 / tri_arms]) {
    // arm rod, boss circle to tip, seated in the hub's radial seat
    color("DarkGray")
        translate([arm_root, 0, tri_arm_z])
            rotate([0, 90, 0])
                cylinder(h = arm_length, d = rod_d);
    // the tri bracket, the stub standing on its printed step, and
    // the M5 from below pulling the stub's tapped bottom end home
    color("SteelBlue")
        translate([bracket_x, 0, bracket_bot])
            tri_tip_bracket();
    color("DarkGray")
        translate([stub_x, 0, bracket_bot + tri_step_t])
            cylinder(h = tri_stub_length, d = rod_d);
    color("Silver")
        translate([stub_x, 0, bracket_bot])
            rotate([180, 0, 0])
                tri_m5_screw(tri_step_t + tri_rod_thread);
    // the dual stop ring, keyed in the pocket: the only stop
    color("SteelBlue")
        translate([stub_x, 0, tri_arm_z + bracket_h / 2 - ring_foot_t])
            stop_ring();
    // the PTFE washer on the ring's thrust boss
    color("White")
        translate([stub_x, 0, tri_arm_z + bracket_h / 2 + collar_boss_h])
            difference() {
                cylinder(h = tri_washer_t, d = tri_washer_od);
                translate([0, 0, -0.5])
                    cylinder(h = tri_washer_t + 1, d = rod_free_d);
            }
    // the dual vane, panel out along the arm at the driven stop
    color("Gold")
        translate([stub_x, 0, sleeve_bot])
            rotate([0, 0, -90 - poses[k]])
                translate([vane_sleeve_od / 2, 0, vane_sleeve_len / 2])
                    rotate([0, -90, 0])
                        vane();
    // the tri cap, a smooth screwed-down retainer: its bore ceiling
    // lands on the stub's top face, the M5 from above pulls it home
    color("SteelBlue")
        translate([stub_x, 0, cap_under + tri_cap_t])
            rotate([180, 0, 0])
                tri_end_cap();
    color("Silver")
        translate([stub_x, 0, cap_under + tri_cap_t - tri_cap_cbore_h])
            tri_m5_screw(tri_cap_t - tri_cap_bore_h - tri_cap_cbore_h
                         + tri_rod_thread);
}
