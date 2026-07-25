// ============================================================
// TRI TIP BRACKET — concept CAD, reviewable in tri_assembly.scad.
//
// The dual's knuckle rebuilt around the tri's prepared stub: the
// stub is not clamped, it is SCREWED. The through stub groove
// becomes a plain snug bore over a printed step: the stub drops
// in from above, lands face-down on the step, and one M5 with a
// washer from below pulls its tapped bottom end home. Stub height
// is geometry (the step), stub rotation does not matter at all
// (with the cap wedge gone the stop is the keyed ring fin alone),
// so the rod prep is tapping both ends, nothing more.
//
// With the stub screwed, the clamshell's only clamping duty is
// the ARM: the stub-clamp bolt pair is gone and two M3s remain.
// The ring pocket, the funnel lead-in and the split-on-the-rod-
// plane clamshell construction carry over from the dual
// unchanged; this file models the closed solid for the concept
// scene, and the printable halves would split exactly like
// bracket_peg_half / bracket_plain_half do.
// ============================================================

include <../design_params.scad>
include <tri_params.scad>

$fn = 80;

zc           = bracket_h / 2;   // the arm axis height
stub_lead_in = 1.5;             // funnel mouth, dual verbatim

module tri_tip_bracket() {
    difference() {
        translate([0, -bracket_w / 2, 0])
            cube([bracket_len, bracket_w, bracket_h]);

        // arm groove, blind, from the inboard face (dual verbatim)
        translate([-0.1, 0, zc])
            rotate([0, 90, 0])
                cylinder(h = bracket_arm_grip + 0.1, d = rod_snug_d);

        // the stub bore, snug, from the top face down to the
        // printed step
        translate([bracket_stub_x, 0, tri_step_t])
            cylinder(h = bracket_h, d = rod_snug_d);

        // M5 clearance through the step floor for the stub screw;
        // its head and washer seat on the flat bottom face
        translate([bracket_stub_x, 0, -0.1])
            cylinder(h = tri_step_t + 0.2, d = m5_clear_d);

        // funnel mouth where the bore meets the ring pocket floor
        // (dual verbatim: the stub goes in from above, blind)
        translate([bracket_stub_x, 0,
                   bracket_h - ring_foot_t - stub_lead_in])
            cylinder(h = stub_lead_in + 0.1, d1 = rod_snug_d,
                     d2 = rod_snug_d + 2 * (stub_lead_in + 0.1));

        // keyed pocket for the stop ring's D foot, flat outboard
        translate([bracket_stub_x, 0, bracket_h - ring_foot_t])
            intersection() {
                cylinder(h = ring_foot_t + 0.1,
                         d = ring_foot_d + 2 * fit_tol);
                translate([ring_flat_x + fit_tol - 1000, -500, -0.1])
                    cube(1000);
            }

        // the surviving bolt pair: arm clamp only, at mid-grip
        for (dz = [-1, 1])
            translate([bracket_arm_grip / 2, 0, zc + dz * bracket_bolt_dz])
                rotate([90, 0, 0])
                    cylinder(h = bracket_w + 2, d = m3_clear_d,
                             center = true);
    }
}

tri_tip_bracket();
