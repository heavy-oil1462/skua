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
//   stub as a pillow block, and four M3 bolts clamp both rods at
//   once: this joint rides 620 mm out on the arm, so it is sized for
//   weight, and M3 preload is plenty for a clamp whose only friction
//   duty is gust torsion about the arm. The nylocs sit captive in hex
//   pockets in the plain half's outer face, so tightening is a
//   screwdriver on the head side alone. No teardrops and no press
//   fits: with the ASA snug a true 8.0 the rods LAY IN and the bolts
//   do the gripping.
//
//   The top face is FLAT: the stub groove runs straight through with
//   a funnel mouth at the top, so the clamshell closes over the ARM
//   alone and the stub then slides down through the closed groove
//   from above. The bought PTFE washer drops over the stub onto the
//   flat annulus outside the funnel mouth (geometry_check gates that
//   seat), and the sleeve rides the washer — the vane's whole thrust
//   bearing. The tri variant prints this exact bracket too (its
//   whole vane assembly is the dual's, three times over).
//
//   Both halves print split face up as plain blocks with open
//   channels: grooves, funnel and bolt bores, nothing to support
//   anywhere (the nut pockets open into the bed face; their shallow
//   ceilings bridge the width of a nut flat, which any printer
//   crosses).
//
//   Hub rules apply: the halves NEVER touch (bracket_clamp_gap keeps
//   the bolt preload on the rods; an even gap all around means the
//   rods are gripped), and the pegs, not the bolts, do alignment.
// ==============================================================================

include <design_params.scad>

$fn = 80;

peg_d = 4;             // registration pegs, same size as the hub's
zc    = bracket_h / 2; // the arm axis height

// The assembled clamshell, halves gapped on the rods (for the scene;
// the halves are modeled in place, peg half on +y).
module tip_bracket() {
    bracket_plain_half();
    bracket_peg_half();
}

// The plain half (y < 0), split face toward +y, recessed by half the
// clamp gap; carries the peg sockets and the captive nyloc pockets.
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
        // captive nyloc pockets in the outer face, one per clamp
        // bolt: a hex with flats toward the part faces, so the thin
        // walls beside the arm bolts are flat-to-flat, not corners
        for (p = bolt_positions())
            translate([p[0], -bracket_w / 2 - 0.1, p[1]])
                rotate([-90, 0, 0])
                    cylinder(h = m3_locknut_t + 0.1,
                             d = m3_nut_af / cos(30), $fn = 6);
    }
}

// The peg half (y > 0): the same block with the pegs; heads and
// washers sit on its flat outer face.
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

// The four clamp bolts: a pair flanking the arm groove over the
// grip, a pair flanking the stub groove (walls gated by
// geometry_check).
function bolt_positions() =
    [[bracket_arm_grip / 2, zc - bracket_bolt_dz],
     [bracket_arm_grip / 2, zc + bracket_bolt_dz],
     [bracket_stub_x - bracket_bolt_dx, zc],
     [bracket_stub_x + bracket_bolt_dx, zc]];

// The bracket as one solid: block minus rod grooves, funnel and M3
// bores. The halving above turns them into open channels.
module bracket_solid() {
    difference() {
        translate([0, -bracket_w / 2, 0])
            cube([bracket_len, bracket_w, bracket_h]);

        // arm groove, blind, from the inboard face (the arm stock's
        // own gauged fit)
        translate([-0.1, 0, zc])
            rotate([0, 90, 0])
                cylinder(h = bracket_arm_grip + 0.1, d = arm_snug_d);

        // stub groove, straight through
        translate([bracket_stub_x, 0, -0.1])
            cylinder(h = bracket_h + 0.2, d = rod_snug_d);

        // funnel mouth on the stub groove: the stub goes in from
        // above with the halves already closed over the arm
        // (docs/assembly.md step 4); an open-channel cut in each
        // half, nothing to support
        translate([bracket_stub_x, 0, bracket_h - stub_lead_in])
            cylinder(h = stub_lead_in + 0.1, d1 = rod_snug_d,
                     d2 = rod_snug_d + 2 * (stub_lead_in + 0.1));

        // M3 clamp bolt clearance bores; heads sit on the peg half's
        // flat face with small washers, nylocs in the plain half's
        // pockets
        for (p = bolt_positions())
            translate([p[0], 0, p[1]])
                rotate([90, 0, 0])
                    cylinder(h = bracket_w + 2, d = m3_clear_d,
                             center = true);
    }
}

tip_bracket();
