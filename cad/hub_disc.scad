// ==============================================================================
//   HUB DISC — optional VARIANT of the hub clamshell (hub.scad): the
//   tri's washer-jaw hub sized for the dual's two arms. Print ONE.
//
//   One spacer disc thinner than the rod, a slot per arm from the
//   boss circle to the rim, arms butted against the boss and proud
//   of both faces by half the clamp gap. Two M8 fender washers press
//   directly on the rods from either side, clamped by M8 nylocs on
//   the shaft's die-threaded top end. Load path steel washer,
//   aluminum rod, steel washer: no plastic in compression, so this
//   joint never needs the seasonal re-torque, and disc plus M8 stack
//   weigh about a third of the clamshell plus its five M5s.
//
//   The price is the one rod prep in the build: an M8x1.25 hand die
//   run hub_shaft_thread down the shaft top (8 mm rod is an M8
//   thread blank, the die self-aligns, still nothing drilled), and
//   an arm station about 27 mm lower on the same shaft, which the
//   stack has room for (geometry_check gates the collar room).
//   Assembly: lower nyloc and washer to a thread-gauge height, disc
//   and arms on, upper washer and nyloc, done — the slot flanks key
//   the arms, the washers grip them.
//
//   Prints flat on its face in minutes: bore and slots are vertical
//   walls, no bridges, no supports.
// ==============================================================================

include <design_params.scad>

$fn = 80;

module hub_disc() {
    difference() {
        cylinder(h = hub_disc_h, d = hub_disc_d);
        // free over the thread crests; the washers do the locating
        translate([0, 0, -0.1])
            cylinder(h = hub_disc_h + 0.2, d = rod_free_d);
        // one full-height slot per arm, snug on the rod flanks, boss
        // circle to rim
        for (m = [0, 1]) mirror([m, 0, 0])
            translate([hub_disc_boss_d / 2, -rod_snug_d / 2, -0.1])
                cube([hub_disc_d / 2 - hub_disc_boss_d / 2 + 1,
                      rod_snug_d, hub_disc_h + 0.2]);
    }
}

hub_disc();
