// ==============================================================================
//   TIP BRACKET — the clamshell knuckle at each arm tip. Each bracket
//   is a PEG half plus a PLAIN half (print two of each; the printable
//   parts are bracket_peg_half.scad and bracket_plain_half.scad, this
//   file is the shared library and renders the closed pair; regen_all
//   treats it as a non-part). The assembled bracket rotated 180 about
//   the stub serves the other arm.
//
//   Turns the vane hinge VERTICAL: the arm ends in a blind groove and
//   the stub rod stands in a through groove. Both rod axes lie in the
//   split plane, so like the hub the two halves close over arm and
//   stub as a pillow block, and four M3x30s with small washers clamp
//   both rods at once: this joint rides 620 mm out on the arm, so it
//   is sized for weight, and M3 preload is plenty for a clamp whose
//   only friction duty is gust torsion about the arm. No teardrops
//   and no press fits: with the ASA snug a true 8.0 the rods LAY IN
//   and the bolts do the gripping.
//
//   The pocket on top traps the STOP RING's D foot (stop_ring.scad)
//   exactly the way the grooves trap the rods: lay it in with the
//   rods, close the clamshell, and its angle is locked. The bracket
//   itself carries no protrusions at all, so both halves print split
//   face up as plain blocks with open channels: grooves, pocket and
//   bolt bores, nothing to support anywhere.
//
//   Hub rules apply: the halves NEVER touch (bracket_clamp_gap keeps
//   the bolt preload on the rods; an even gap all around means the
//   rods are gripped), and the pegs, not the bolts, do alignment.
// ==============================================================================

include <design_params.scad>

$fn = 80;

peg_d = 4;               // registration pegs, same size as the hub's
zc    = bracket_h / 2;   // the arm axis height

// The assembled clamshell, halves gapped on the rods (for the scene;
// the halves are modeled in place, peg half on +y).
module tip_bracket() {
    bracket_plain_half();
    bracket_peg_half();
}

// The plain half (y < 0), split face toward +y, recessed by half the
// clamp gap; carries the peg sockets.
module bracket_plain_half() {
    difference() {
        intersection() {
            bracket_solid();
            translate([-500, -1000 - bracket_clamp_gap / 2, -500])
                cube(1000);
        }
        for (dz = [-1, 1])
            translate([bracket_peg_x, -bracket_clamp_gap / 2 + 0.1,
                       zc + dz * bracket_peg_dz])
                rotate([90, 0, 0])
                    cylinder(h = 4.6, d = peg_d + 0.4);
    }
}

// The peg half (y > 0): the same block with the pegs.
module bracket_peg_half() {
    intersection() {
        bracket_solid();
        translate([-500, bracket_clamp_gap / 2, -500]) cube(1000);
    }
    for (dz = [-1, 1])
        translate([bracket_peg_x, bracket_clamp_gap / 2 + 0.1,
                   zc + dz * bracket_peg_dz])
            rotate([90, 0, 0])
                cylinder(h = 4 + bracket_clamp_gap / 2 + 0.1, d = peg_d);
}

// The bracket as one solid: block minus rod grooves, ring pocket and
// M5 bores. The halving above turns them into open channels.
module bracket_solid() {
    difference() {
        translate([0, -bracket_w / 2, 0])
            cube([bracket_len, bracket_w, bracket_h]);

        // arm groove, blind, from the inboard face
        translate([-0.1, 0, zc])
            rotate([0, 90, 0])
                cylinder(h = bracket_arm_grip + 0.1, d = rod_snug_d);

        // stub groove, straight through
        translate([bracket_stub_x, 0, -0.1])
            cylinder(h = bracket_h + 0.2, d = rod_snug_d);

        // keyed pocket for the stop ring's D foot, flat outboard
        translate([bracket_stub_x, 0, bracket_h - ring_foot_t])
            intersection() {
                cylinder(h = ring_foot_t + 0.1,
                         d = ring_foot_d + 2 * fit_tol);
                translate([ring_flat_x + fit_tol - 1000, -500, -0.1])
                    cube(1000);
            }

        // M5 clamp bolts: a pair flanking the arm groove over the
        // grip, a pair flanking the stub groove (walls gated by
        // geometry_check); heads and nylocs sit on the flat outer
        // faces with wide washers, hub style, so only clearance
        // bores are modeled
        for (dz = [-1, 1])
            bolt_bore([bracket_arm_grip / 2, zc + dz * bracket_bolt_dz]);
        for (dx = [-1, 1])
            bolt_bore([bracket_stub_x + dx * bracket_bolt_dx, zc]);
    }
}

module bolt_bore(pos) {
    translate([pos[0], 0, pos[1]])
        rotate([90, 0, 0])
            cylinder(h = bracket_w + 2, d = m3_clear_d, center = true);
}

tip_bracket();
