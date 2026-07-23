// ==============================================================================
//   TIP BRACKET — the clamshell knuckle at each arm tip. FOUR halves
//   of the ONE design below make the two brackets; the printable part
//   is bracket_half.scad, this file is the shared library (and renders
//   the closed pair for viewing); regen_all treats it as a non-part.
//
//   Turns the vane hinge VERTICAL: the arm ends in a blind groove and
//   the stub rod stands in a through groove. Both rod axes lie in the
//   split plane, so like the hub the two halves close over arm and
//   stub as a pillow block, and four M5x40s with wide washers clamp
//   both rods at once. No teardrops and no press fits: with the ASA
//   snug at a true 8.0 the rods LAY IN and the bolts do the gripping.
//
//   The bracket is also the vane's lower bearing and lower stop: its
//   top face carries the boss ring the sleeve rests on (small ring,
//   low friction, collar_boss_* sizes) and the LOWER STOP WEDGE,
//   printed at the driven-stop angle: wedge center 90 minus
//   vane_swing_deg/2 past the outboard arm direction, so the flag
//   stops exactly at panel-along-the-arm and both arms automatically
//   stop in the same rotational sense. Only the end cap's wedge is
//   set at assembly. The wedge's print ramp (below) doubles as a
//   soft cushion near the free-swing end, so the loud clack stays on
//   the driven stop.
//
//   Self-mating trick: the half is z-symmetric about the arm axis
//   where it must be (grooves, bolts) and carries ONE peg and ONE
//   socket placed symmetrically, so a half rotated 180 about the arm
//   axis mates with an unrotated one. The rotated half's boss arc
//   completes the top ring, and its wedge lands underneath as a
//   harmless vestige; one printed design is front, back, left arm
//   and right arm.
//
//   Prints split face up (see bracket_half.scad). The boss arcs and
//   the wedge protrude from faces that print as vertical walls, so
//   the bosses flare at 45 degrees and the wedge grows a 45-degree
//   ramp toward the bed: everything self-supporting.
//
//   Hub rules apply: the halves NEVER touch (bracket_clamp_gap keeps
//   the bolt preload on the rods; an even gap all around means the
//   rods are gripped), and the peg, not the bolts, does alignment.
// ==============================================================================

include <design_params.scad>
use <lib/stop_wedge.scad>

$fn = 80;

peg_d     = 4;               // registration peg, same size as the hub's
zc        = bracket_h / 2;   // the arm axis height in the half
wedge_h   = collar_boss_h + stop_wedge_len;  // proud of the top face
wedge_ang = 90 - vane_swing_deg / 2;         // driven-stop wedge center,
                                             // past +x (outboard)

// The assembled clamshell, halves gapped on the rods (for the scene;
// print bracket_half.scad four times).
module tip_bracket() {
    bracket_half();
    translate([0, 0, zc])
        rotate([180, 0, 0])
            translate([0, 0, -zc])
                bracket_half();
}

// One half (the y < 0 side), split face toward +y, recessed by half
// the clamp gap; one peg proud of the face, one socket opposite, on
// the z-symmetric positions that make the part mate with itself.
module bracket_half() {
    difference() {
        intersection() {
            union() {
                bracket_solid();
                boss_arcs_and_wedge();
            }
            half_slab();
        }
        translate([bracket_peg_x, -bracket_clamp_gap / 2 + 0.1,
                   zc + bracket_peg_dz])
            rotate([90, 0, 0])
                cylinder(h = 4.6, d = peg_d + 0.4);
    }
    translate([bracket_peg_x, -bracket_clamp_gap / 2 - 0.1,
               zc - bracket_peg_dz])
        rotate([-90, 0, 0])
            cylinder(h = 4 + bracket_clamp_gap / 2 + 0.1, d = peg_d);
}

// this half's world: outer face to just shy of the split plane
module half_slab() {
    translate([-500, -500 - bracket_w / 2, -500])
        cube([1000, 500 + bracket_w / 2 - bracket_clamp_gap / 2, 1000]);
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

// This half's share of the sleeve seat and the lower stop: a boss
// arc on top AND bottom (the mate's bottom arc completes the top
// ring), and the wedge hanging BELOW, at the mirrored angle that the
// mating rotation carries to 10..50 degrees past outboard on the
// assembled top. Bosses flare 45 degrees; the wedge gets a 45-degree
// ramp toward this half's outer face (the print bed).
module boss_arcs_and_wedge() {
    flare = collar_boss_d + 2 * collar_boss_h;
    for (p = [[bracket_h, flare, collar_boss_d],
              [-collar_boss_h, collar_boss_d, flare]])
        translate([bracket_stub_x, 0, p[0]])
            difference() {
                cylinder(h = collar_boss_h, d1 = p[1], d2 = p[2]);
                translate([0, 0, -0.1])
                    cylinder(h = collar_boss_h + 0.2, d = rod_snug_d);
            }
    translate([bracket_stub_x, 0, 0]) {
        hull() {
            hanging_wedge();
            translate([0, -wedge_h, 0])
                scale([1, 1, 0.02]) hanging_wedge();
        }
    }
}

module hanging_wedge() {
    rotate([0, 0, -wedge_ang])
        rotate([180, 0, 0])
            stop_wedge(stop_wedge_ri, stop_wedge_ro,
                       stop_wedge_deg, wedge_h);
}

module bolt_bore(pos) {
    translate([pos[0], 0, pos[1]])
        rotate([90, 0, 0])
            cylinder(h = bracket_w + 2, d = m5_clear_d, center = true);
}

tip_bracket();
