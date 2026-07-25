// ============================================================
// TRI VARIANT CONCEPT ASSEMBLY — open this file in OpenSCAD to review.
//
// The tri v0.1: three arms at 120 degrees (the worst-parking-angle
// fix) cradled in the sandwich hub from tri_hub.scad, two
// identical half-shells clamped between fender washers by M8
// nylocs on the shaft's die-threaded top (the slot-disc variant
// with steel-on-rod jaws is modeled alongside; one-line swap
// below). The tip is the DUAL's verbatim (clamped stub, tip
// bracket, stop ring, vane) except the cap: the tri clamp cap is
// the dual's minus the stop wedge, because in the tri the ring
// fin is the only stop. No rod prep beyond the die pass. A
// PTFE washer rides each thrust seat (ladder step two; lift it
// off and the seat is pure dual). The screwed-stub tip in
// tri_tip_bracket.scad / tri_end_cap.scad is the deferred kit
// direction, not in this scene.
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
use <../tip_bracket.scad>
use <../stop_ring.scad>
use <../vane.scad>
use <tri_clamp_cap.scad>
use <tri_hub.scad>

$fn = 48;

// stations: the dual's relations with the tri joints in place;
// the top nut lands flush with the shaft tip, everything hangs
// from there
shaft_top   = shaft_tip_h + shaft_length;
tri_arm_z   = shaft_top - tri_nut_t - tri_m8_washer_t
              - tri_hub_shell_h - tri_hub_gap / 2;
arm_root    = tri_hub_boss_d / 2;            // arms butt the boss circle
arm_tip     = arm_root + arm_length;
bracket_x   = arm_tip - bracket_arm_grip;
stub_x      = bracket_x + bracket_stub_x;
bracket_bot = tri_arm_z - bracket_h / 2;
sleeve_bot  = tri_arm_z + bracket_h / 2 + collar_boss_h + tri_washer_t;
cap_face    = sleeve_bot + vane_sleeve_len + 1;

// the dual base, plank level at z = 0 (the taller mounting from
// the study's ladder is numbers only, not drawn)
color("Tomato") base();

// shaft (top tri_shaft_thread of it die-threaded M8, drawn plain),
// then the sandwich hub: lower washer and nut the shoulder, two
// identical half-shells cradling the arms, upper washer and nut
// the clamp (swap the shells for tri_hub_disc to see the slot-disc
// variant)
color("DarkGray") translate([0, 0, shaft_tip_h])
    cylinder(h = shaft_length, d = rod_d);
color("Silver")
    translate([0, 0, tri_arm_z - tri_hub_gap / 2 - tri_hub_shell_h])
        rotate([180, 0, 0]) tri_m8_stack();
color("SteelBlue")
    translate([0, 0, tri_arm_z - tri_hub_gap / 2 - tri_hub_shell_h])
        tri_hub_shell();
color("SteelBlue")
    translate([0, 0, tri_arm_z + tri_hub_gap / 2 + tri_hub_shell_h])
        rotate([180, 0, 0]) tri_hub_shell();
color("Silver")
    translate([0, 0, tri_arm_z + tri_hub_gap / 2 + tri_hub_shell_h])
        tri_m8_stack();

// poses: driven stop, weathervaned, mid re-arm
poses = [0, vane_swing_deg, vane_swing_deg / 2];

for (k = [0 : tri_arms - 1]) rotate([0, 0, k * 360 / tri_arms]) {
    // arm rod, boss circle to tip, seated in the hub's radial seat
    color("DarkGray")
        translate([arm_root, 0, tri_arm_z])
            rotate([0, 90, 0])
                cylinder(h = arm_length, d = rod_d);
    // the dual tip stack, verbatim: clamshell bracket on the arm,
    // clamped stub standing through, keyed stop ring in the pocket
    color("SteelBlue")
        translate([bracket_x, 0, bracket_bot])
            tip_bracket();
    color("DarkGray")
        translate([stub_x, 0, bracket_bot])
            cylinder(h = stub_length, d = rod_d);
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
    // the tri clamp cap, wedge-free: clamped at the dual's usual
    // orientation only so its bolts park in the gated clear arc
    color("SteelBlue")
        translate([stub_x, 0, cap_face + cap_t])
            rotate([0, 0, 90 - (vane_swing_deg + ring_wedge_deg) / 2
                           + stop_wedge_deg / 2])
                rotate([180, 0, 0])
                    tri_clamp_cap();
}
