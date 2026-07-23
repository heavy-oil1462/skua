// ==============================================================================
//   TIP BRACKET — the clamshell knuckle at each arm tip. Each bracket
//   is a FIN half plus a PLAIN half (print two of each; the printable
//   parts are bracket_fin_half.scad and bracket_plain_half.scad, this
//   file is the shared library and renders the closed pair; regen_all
//   treats it as a non-part). The assembled bracket rotated 180 about
//   the stub serves the other arm.
//
//   Turns the vane hinge VERTICAL: the arm ends in a blind groove and
//   the stub rod stands in a through groove. Both rod axes lie in the
//   split plane, so like the hub the two halves close over arm and
//   stub as a pillow block, and four M5x40s with wide washers clamp
//   both rods at once. No teardrops and no press fits: with the ASA
//   snug a true 8.0 the rods LAY IN and the bolts do the gripping.
//
//   The bracket is also the vane's lower bearing and lower stop. Each
//   half's top face carries its half of the 45-degree flared boss
//   ring the sleeve rests on (small ring, low friction, collar_boss_*
//   sizes). The fin half adds the LOWER STOP FIN: an annular sector
//   rising beside the boss whose contact flank lies exactly IN the
//   split plane. That placement is what integrates it: in the fin
//   half's print the split face is the top surface, so the fin lies
//   flush at the top with its far flank leaning a printable
//   90 - bracket_wedge_deg from vertical, no support, no ramp. The
//   sleeve's notch is cut bracket_wedge_deg + vane_swing_deg wide, so
//   the wider fin costs no swing.
//
//   The fin fixes the driven stop: the flag stops a few degrees past
//   panel-along-the-arm (the notch wall lands on the split-plane
//   flank), and both arms get the same rotational sense by
//   construction. Only the end cap's wedge is set at assembly, to
//   land together with the fin.
//
//   Hub rules apply: the halves NEVER touch (bracket_clamp_gap keeps
//   the bolt preload on the rods; an even gap all around means the
//   rods are gripped), and the pegs, not the bolts, do alignment.
// ==============================================================================

include <design_params.scad>
use <lib/stop_wedge.scad>

$fn = 80;

peg_d = 4;               // registration pegs, same size as the hub's
zc    = bracket_h / 2;   // the arm axis height
fin_h = collar_boss_h + stop_wedge_len;  // fin, proud of the top face

// The assembled clamshell, halves gapped on the rods (for the scene;
// the halves are modeled in place, fin half on +y).
module tip_bracket() {
    bracket_plain_half();
    bracket_fin_half();
}

// The plain half (y < 0), split face toward +y, recessed by half the
// clamp gap; carries the peg sockets and its boss arc.
module bracket_plain_half() {
    difference() {
        intersection() {
            union() { bracket_solid(); boss_ring(); }
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

// The fin half (y > 0): pegs, its boss arc, and the lower stop fin
// spanning 0 to bracket_wedge_deg past outboard, contact flank flush
// with the split plane. Printed outer face down, the split face is
// the top surface, so the fin lies flush at the top; the 45-degree
// facet below shaves the only spot where its outer arc would curl
// past the printable lean, so every under-surface is self-supporting.
module bracket_fin_half() {
    intersection() {
        union() {
            bracket_solid();
            boss_ring();
            translate([bracket_stub_x, 0, bracket_h])
                difference() {
                    rotate([0, 0, bracket_wedge_deg / 2])
                        stop_wedge(stop_wedge_ri, stop_wedge_ro,
                                   bracket_wedge_deg, fin_h);
                    // facet: the tangent plane at 45 degrees off the
                    // split, where the arc would exceed the print lean
                    rotate([0, 0, 45])
                        translate([stop_wedge_ro, -500, -1])
                            cube(1000);
                }
        }
        translate([-500, bracket_clamp_gap / 2, -500]) cube(1000);
    }
    for (dz = [-1, 1])
        translate([bracket_peg_x, bracket_clamp_gap / 2 + 0.1,
                   zc + dz * bracket_peg_dz])
            rotate([90, 0, 0])
                cylinder(h = 4 + bracket_clamp_gap / 2 + 0.1, d = peg_d);
}

// The sleeve's seat: a 45-degree flared boss cone around the stub
// groove on the top face (each half keeps its own arc of it).
module boss_ring() {
    translate([bracket_stub_x, 0, bracket_h])
        difference() {
            cylinder(h = collar_boss_h,
                     d1 = collar_boss_d + 2 * collar_boss_h,
                     d2 = collar_boss_d);
            translate([0, 0, -0.1])
                cylinder(h = collar_boss_h + 0.2, d = rod_snug_d);
        }
}

// The bracket as one solid: block minus rod grooves and M5 bores.
// The halving above turns the plain round bores into open grooves.
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
            cylinder(h = bracket_w + 2, d = m5_clear_d, center = true);
}

tip_bracket();
