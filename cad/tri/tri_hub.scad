// ============================================================
// TRI SPLIT HUB — concept CAD, reviewable in tri_assembly.scad.
//
// The tri's own hub: a cylinder split on the horizontal plane that
// contains all three arm axes. The arms lie in radial half-round
// seats and butt against the boss circle around the bolt bore; the
// top half closes over them and ONE central M5 with a washer runs
// down through both halves into a tapped hole in the shaft's top
// end. Tightening it pulls the shaft face up against the socket
// shoulder and presses the halves together, so a single bolt clamps
// three arms and axially locks the shaft at once. The three rods at
// 120 degrees key the halves against relative rotation, so no
// registration pegs are needed.
//
// This is the kit-focused variant: the shaft end is PREPARED (drill
// 4.2 mm, tap M5x0.8, tri_rod_thread deep), a deliberate divergence
// from the dual's no-rod-is-ever-drilled rule, recorded in
// docs/tri_concept.md with the sourcing options.
//
// Both halves are modeled in print orientation, seats up, so every
// bore is vertical: the bottom half prints standing on its socket
// face, the top half prints standing on its counterbore face (the
// counterbore ceiling and the socket shoulder are small bridged
// annuli). The assembly flips the top half over; the 120 degree
// seat pattern is symmetric under that flip.
//
// The clamshell rule carries over from the dual: the seats are cut
// tri_hub_gap/2 shy, so the closed halves never touch face to face
// and the bolt preload lands on the rods.
// ============================================================

include <../design_params.scad>
include <tri_params.scad>

// three half-round arm seats cut into a face at z = 0, radial from
// the boss circle to the rim, centers tri_hub_gap/2 beyond the face
module tri_arm_seats() {
    for (k = [0 : tri_arms - 1]) rotate([0, 0, k * 360 / tri_arms])
        translate([tri_hub_boss_d / 2, 0, tri_hub_gap / 2])
            rotate([0, 90, 0])
                cylinder(h = tri_hub_d / 2 - tri_hub_boss_d / 2 + 1,
                         d = rod_snug_d);
}

// print orientation: socket face down, arm seats up at the split
module tri_hub_bottom() {
    difference() {
        cylinder(h = tri_hub_bot_h, d = tri_hub_d);
        // blind shaft socket from below; above its shoulder the bolt
        // clearance continues through, so the shoulder is an annulus
        translate([0, 0, -0.1])
            cylinder(h = tri_hub_socket + 0.1, d = rod_snug_d);
        translate([0, 0, -0.1])
            cylinder(h = tri_hub_bot_h + 0.2, d = m5_clear_d);
        translate([0, 0, tri_hub_bot_h]) tri_arm_seats();
    }
}

// print orientation: counterbore face down, arm seats up; flipped
// over in the assembly so the seats close onto the arms and the
// counterbore faces the sky
module tri_hub_top() {
    difference() {
        cylinder(h = tri_hub_top_h, d = tri_hub_d);
        translate([0, 0, -0.1])
            cylinder(h = tri_hub_top_h + 0.2, d = m5_clear_d);
        translate([0, 0, -0.1])
            cylinder(h = tri_bolt_cbore_h + 0.1, d = tri_bolt_cbore_d);
        translate([0, 0, tri_hub_top_h]) tri_arm_seats();
    }
}

// the central M5 with its washer, drawn for the assembly scene;
// z = 0 at the washer's seat in the counterbore
module tri_hub_bolt() {
    reach = tri_hub_top_h - tri_bolt_cbore_h + tri_hub_gap
            + (tri_hub_bot_h - tri_hub_socket) + tri_rod_thread;
    cylinder(h = 1.2, d = tri_bolt_cbore_d - 1);          // washer
    translate([0, 0, 1.2]) cylinder(h = 4, d = 8.5);      // head
    translate([0, 0, -reach]) cylinder(h = reach, d = 5); // shank
}

// preview: both halves as they print
tri_hub_bottom();
translate([tri_hub_d + 10, 0, 0]) tri_hub_top();
