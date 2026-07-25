// ============================================================
// TRI END CAP — concept CAD, reviewable in tri_assembly.scad.
//
// The dual's cap with both the clamp and the wedge designed out.
// Field finding from the dual: two stops never land exactly
// together, so one face takes every hit anyway; in the tri the
// stop is the ring fin ALONE (the replaceable part, and the stop-
// face gate already sizes one face for the full impact), and the
// cap is a pure vane retainer with no angular job at all. That
// makes it a smooth disc: a free locating bore rides the stub,
// an internal step lands on the stub's top face, and one M5 with
// a washer pulls it home into the stub's tapped end. Nothing to
// set, nothing proud of the cylinder, nothing to key.
//
// The vane sleeve's upper notch goes unused; the vane stays the
// shared dual part.
//
// Prints closed-end-down like the dual cap: the counterbore
// ceiling is a small bridged annulus, everything else faces up,
// no supports.
// ============================================================

include <../design_params.scad>
include <tri_params.scad>

$fn = 80;

module tri_end_cap() {
    difference() {
        cylinder(h = tri_cap_t, d = cap_d);
        // free locating bore from the open face; its ceiling is the
        // step that lands on the stub's top face
        translate([0, 0, tri_cap_t - tri_cap_bore_h])
            cylinder(h = tri_cap_bore_h + 0.1, d = rod_free_d);
        // M5 clearance through the plate, washer and head recessed
        // in a counterbore on the closed face
        translate([0, 0, -0.1])
            cylinder(h = tri_cap_t + 0.2, d = m5_clear_d);
        translate([0, 0, -0.1])
            cylinder(h = tri_cap_cbore_h + 0.1, d = tri_cap_cbore_d);
    }
}

tri_end_cap();
