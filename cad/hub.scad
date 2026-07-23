// ==============================================================================
//   HUB — clamps the top of the vertical shaft and carries both arm rods.
//
//   A CLAMSHELL split on the vertical plane through all three rod axes:
//   lay the shaft and both arms into one half's grooves, close the
//   other half over them, and five M5 through-bolts with wide washers
//   clamp every joint at once. The grip is friction, but the contact
//   area is enormous compared to any set screw, and no rod gets a hole
//   drilled where its bending load peaks. The halves NEVER touch:
//   each split face is recessed by hub_clamp_gap/2, so the rods stand
//   proud of their grooves and the full bolt preload lands on them.
//
//   Two printed parts (hub_front.scad with the registration pegs,
//   hub_back.scad with their sockets); the back half is the same shape
//   rotated 180 degrees at assembly, so both print in the same
//   orientation: split face UP, grooves as open channels, bolt bores
//   vertical. No supports, and no teardrops needed anywhere.
//
//   T-shaped in the arm/shaft plane, as before: a full-length beam
//   wraps the arm grooves, a center stem wraps the shaft groove, 45
//   degree chamfers between them.
//
//   This file is the shared library (and renders the closed pair for
//   viewing); regen_all treats it as a non-part.
// ==============================================================================

include <design_params.scad>

$fn = 80;

// The complete hub as assembled, halves gapped on the rods.
module hub() {
    hub_half(pegs = true);
    rotate([0, 0, 180]) hub_half(pegs = false);
}

// One half (the y < 0 side), split face toward +y, recessed by half
// the clamp gap. The peg half carries pins proud of its face; the
// other half gets matching sockets.
module hub_half(pegs) {
    difference() {
        intersection() {
            hub_solid();
            translate([-500, -1000 - hub_clamp_gap / 2, -500]) cube(1000);
        }
        if (!pegs)
            for (s = [1, -1])
                translate([s * hub_peg_x, -hub_clamp_gap / 2 + 0.1, hub_peg_z])
                    rotate([90, 0, 0])
                        cylinder(h = 4.6, d = hub_peg_d + 0.4);
    }
    if (pegs)
        for (s = [1, -1])
            translate([s * hub_peg_x, -hub_clamp_gap / 2 - 0.1, hub_peg_z])
                rotate([-90, 0, 0])
                    cylinder(h = 4 + hub_clamp_gap / 2 + 0.1, d = hub_peg_d);
}

// The hub as one solid: T body minus rod grooves and bolt bores. The
// halving above turns the plain round bores into open half-grooves.
module hub_solid() {
    difference() {
        intersection() {
            // plain square outline: the halves print lying down, and a
            // rounded corner here turns into a bed-side overhang curling
            // under both ends of the beam
            linear_extrude(height = hub_h)
                square([hub_len, hub_w], center = true);
            t_profile();
        }

        // shaft groove, blind, from the bottom
        translate([0, 0, -0.1])
            cylinder(h = hub_shaft_socket + 0.1, d = rod_snug_d);

        // arm grooves, blind, from each end
        for (m = [0, 1]) mirror([m, 0, 0])
            translate([hub_len / 2 - hub_arm_socket, 0, hub_arm_z])
                rotate([0, 90, 0])
                    cylinder(h = hub_arm_socket + 1, d = rod_snug_d);

        // clamp bolt bores: through the center web, flanking the shaft,
        // under the beam (positions gated by geometry_check.py)
        bolt_bore([0, hub_arm_z]);
        for (s = [1, -1]) {
            bolt_bore([s * hub_bolt_stem_x, hub_shaft_socket / 2]);
            bolt_bore([s * hub_bolt_beam_x, hub_bolt_beam_z]);
        }
    }
}

module bolt_bore(pos) {
    translate([pos[0], 0, pos[1]])
        rotate([90, 0, 0])
            cylinder(h = hub_w + 2, d = m5_clear_d, center = true);
}

// The T profile in the arm/shaft plane, extruded across the hub width:
// a full-width beam above hub_beam_z wrapping the arm grooves, a stem
// of hub_stem_w wrapping the shaft groove, and 45 degree chamfers
// between them. Oversized in x and y; the intersection trims it.
module t_profile() {
    s = hub_stem_w / 2;
    rotate([90, 0, 0])
        linear_extrude(height = hub_w + 2, center = true)
            polygon([[-s, -1], [s, -1], [s, 0],
                     [s + hub_beam_z, hub_beam_z],
                     [hub_len / 2 + 1, hub_beam_z],
                     [hub_len / 2 + 1, hub_h + 1],
                     [-hub_len / 2 - 1, hub_h + 1],
                     [-hub_len / 2 - 1, hub_beam_z],
                     [-s - hub_beam_z, hub_beam_z],
                     [-s, 0]]);
}

hub();
