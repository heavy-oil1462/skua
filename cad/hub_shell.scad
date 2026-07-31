// ==============================================================================
//   HUB SHELL — one half of the hub sandwich, THE hub of the machine.
//   Print TWO; they are identical and close seats to seats over the
//   arms (the tri's shell hub, sized for the dual's two arms).
//
//   Each shell is a thin disc with a half-round seat per arm cut into
//   its mating face, running from the boss circle to the rim. The
//   seats are shallower than half the arm by half the clamp gap, so
//   the closed shells never touch: the arms hold them apart and the
//   preload lands on the rods (the clamshell rule). Two M8 fender
//   washers press the sandwich together from either end, clamped by
//   M8 nylocs on the shaft's die-threaded top end. The arms butt the
//   shaft's thread through the boss gap and key the shells, so
//   nothing needs registration pegs.
//
//   The one rod prep in the build: an M8x1.25 hand die run
//   hub_shaft_thread down the shaft top (8 mm rod is an M8 thread
//   blank, the die self-aligns, still nothing drilled). Assembly:
//   lower nyloc and washer to a thread-gauge height, lower shell,
//   arms into the seats, upper shell, washer and nyloc, done. The
//   webs put a little plastic in the clamp path, so these two nuts
//   join the seasonal re-torque round.
//
//   Prints seat face UP: bore vertical, seats open channels, no
//   bridges, no supports.
// ==============================================================================

include <design_params.scad>

$fn = 80;

module hub_shell() {
    difference() {
        cylinder(h = hub_shell_h, d = hub_shell_d);
        // free over the thread crests; the washers do the locating
        translate([0, 0, -0.1])
            cylinder(h = hub_shell_h + 0.2, d = rod_free_d);
        // one half-round seat per arm in the top (mating) face, boss
        // circle to rim, its center half the clamp gap above the
        // face so the closed shells stay apart on the rods
        for (m = [0, 1]) mirror([m, 0, 0])
            translate([hub_shell_boss_d / 2, 0,
                       hub_shell_h + hub_clamp_gap / 2])
                rotate([0, 90, 0])
                    cylinder(h = hub_shell_d / 2 - hub_shell_boss_d / 2 + 1,
                             d = arm_snug_d);
    }
}

// an M8 fender washer and nyloc for the assembly scenes, washer at
// z = 0 (bought parts, never exported)
module m8_stack() {
    cylinder(h = m8_washer_t, d = m8_washer_od);
    translate([0, 0, m8_washer_t])
        cylinder(h = m8_nut_t, d = m8_nut_af / cos(30), $fn = 6);
}

hub_shell();
