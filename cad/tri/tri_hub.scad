// ============================================================
// TRI WASHER-CLAMPED HUB — concept CAD, reviewable in
// tri_assembly.scad. TWO variants, both clamped between M8 fender
// washers and nylocs on the shaft's die-threaded top end, both
// print-two-of-one-part (the slot disc is a single part):
//
// tri_hub_disc — the SLOT DISC: one spacer thinner than the rod,
// three full-height slots, arms proud of both faces, washers
// pressing directly on the rods. Load path steel washer, aluminum
// rod, steel washer: no plastic in compression, never needs a
// re-torque. The slot flanks carry horizontal storm bending; the
// washer rims edge-clamp the rods vertically.
//
// tri_hub_shell — the SANDWICH: two identical thin half-shells
// (a half-seat plus a web) cradle the arms over the full grip and
// the washers clamp the sandwich. Kinder vertical bearing on the
// arms and nothing can rattle, at the price of the webs putting
// plastic back in the clamp path, so a mild version of the dual's
// clamp creep returns (a spring washer under each nut absorbs
// it). Open A/B for the bench and the water; the scene shows the
// sandwich.
//
// The shaft prep is a hand die, not a tap: 8 mm rod is an M8
// thread blank, so the die self-aligns and this rod is never
// drilled at all. The disc bore rides the thread crests at the
// free fit. The shaft's storm bending at the hub is small (the
// lever down to the top bearing is short), so the threaded
// section carries the storm with a factor near four
// (docs/tri_concept.md records the numbers).
//
// Prints flat on its face in minutes: bore and slots are vertical
// walls, no bridges, no supports.
// ============================================================

include <../design_params.scad>
include <tri_params.scad>

$fn = 80;

// three half-round arm seats cut into a face at z = 0, radial from
// the boss circle to the rim, centers tri_hub_gap/2 beyond the face
module tri_arm_seats() {
    for (k = [0 : tri_arms - 1]) rotate([0, 0, k * 360 / tri_arms])
        translate([tri_hub_boss_d / 2, 0, tri_hub_gap / 2])
            rotate([0, 90, 0])
                cylinder(h = tri_hub_d / 2 - tri_hub_boss_d / 2 + 1,
                         d = rod_snug_d);
}

// the sandwich variant's half-shell: print two, close seats to
// seats over the arms
module tri_hub_shell() {
    difference() {
        cylinder(h = tri_hub_shell_h, d = tri_hub_d);
        translate([0, 0, -0.1])
            cylinder(h = tri_hub_shell_h + 0.2, d = rod_free_d);
        translate([0, 0, tri_hub_shell_h]) tri_arm_seats();
    }
}

// the slot-disc variant: one part is the whole hub
module tri_hub_disc() {
    difference() {
        cylinder(h = tri_hub_disc_h, d = tri_hub_d);
        // free over the thread crests; the washers do the locating
        translate([0, 0, -0.1])
            cylinder(h = tri_hub_disc_h + 0.2, d = rod_free_d);
        // three full-height slots, snug on the rod flanks, boss
        // circle to rim; the arms butt the boss and stand proud of
        // both faces by half the gap
        for (k = [0 : tri_arms - 1]) rotate([0, 0, k * 360 / tri_arms])
            translate([tri_hub_boss_d / 2, -rod_snug_d / 2, -0.1])
                cube([tri_hub_d / 2 - tri_hub_boss_d / 2 + 1,
                      rod_snug_d, tri_hub_disc_h + 0.2]);
    }
}

// an M8 fender washer and nyloc for the scene, washer at z = 0
module tri_m8_stack() {
    cylinder(h = m8_washer_t, d = m8_washer_od);
    translate([0, 0, m8_washer_t])
        cylinder(h = m8_nut_t, d = m8_nut_af / cos(30), $fn = 6);
}

// preview: the sandwich pair as it prints, the slot disc beside it
tri_hub_shell();
translate([tri_hub_d + 10, 0, 0]) tri_hub_shell();
translate([0, tri_hub_d + 10, 0]) tri_hub_disc();
