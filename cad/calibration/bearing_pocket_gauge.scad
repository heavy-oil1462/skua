// BEARING POCKET GAUGE — dials in the 608 press fit before printing the
// whole base.
//
// One print gives three rings, each bored to a different candidate
// bearing_press_d and engraved with that number. Press a bearing into
// each: keep the one that takes a firm thumb/vise push and does not
// rock, then put ITS number into bearing_press_d in
// cad/design_params.scad — both base pockets export from that value.
//
// If the best fit is one of the outer rings the truth is outside the
// bracket: move bearing_press_d to that number and reprint to bracket
// it again. Recalibrate when changing filament or printer.

include <../design_params.scad>
include <../lib/labels.scad>

variant_count = 3;
variant_step  = 0.15;
ring_gap      = 8;
label_size    = 4;
label_depth   = 0.8;

$fn = 128;

wall  = (tower_od - bearing_od) / 2;
ring_h = bearing_w + 2;

function variant_d(i) = bearing_press_d + (i - (variant_count - 1) / 2) * variant_step;

module pocket_ring(d) {
    outer_r = d / 2 + wall;
    difference() {
        cylinder(h = ring_h, r = outer_r);
        // pocket depth as in the base: a real shoulder to press against
        translate([0, 0, ring_h - bearing_w - pocket_recess])
            cylinder(h = bearing_w + pocket_recess + 0.1, d = d);
        translate([0, 0, -0.1])
            cylinder(h = ring_h + 0.2, d = tower_bore_d);
        translate([0, 0, ring_h / 2])
            curved_text(str(d), outer_r, label_size, label_depth);
    }
}

pitch = bearing_od + 2 * wall + variant_count * variant_step + ring_gap;

for (i = [0 : variant_count - 1])
    translate([(i - (variant_count - 1) / 2) * pitch, 0, 0])
        pocket_ring(variant_d(i));
