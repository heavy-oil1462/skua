// ============================================================
// TRI WASHER-JAW HUB — concept CAD, reviewable in tri_assembly.scad.
//
// As small as the job allows: ONE printed spacer disc, just high
// enough to key the rods. Three full-height radial slots hold the
// arms at 120; the disc is thinner than the rod, so the arms stand
// proud of both faces, and two large M8 fender washers press onto
// the rods from either side, clamped by M8 nylocs on the shaft's
// die-threaded top end. The washers are the clamp jaws: the load
// path is steel washer, aluminum rod, steel washer, steel nut,
// with NO plastic in compression anywhere, so unlike every clamp
// on the dual this joint never needs a seasonal re-torque. The
// disc only keys: slot flanks carry the arms' horizontal storm
// bending as bearing, the arms butt the boss circle, and the
// washer faces square the hub on the shaft.
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

// the one printed part of the hub
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
    cylinder(h = tri_m8_washer_t, d = tri_m8_washer_od);
    translate([0, 0, tri_m8_washer_t])
        cylinder(h = tri_nut_t, d = tri_nut_af / cos(30), $fn = 6);
}

tri_hub_disc();
