// Visual model of a bought 608 bearing — NOT a printed part
// (regen_all.py deliberately exports no STL for it). Exists so
// main_assembly.scad can show the parts in context.

include <design_params.scad>

module bearing_608() {
    color("Silver") {
        // outer ring
        difference() {
            cylinder(h = bearing_w, d = bearing_od);
            translate([0, 0, -0.1])
                cylinder(h = bearing_w + 0.2, d = bearing_od - 3.5);
        }
        // inner ring
        difference() {
            cylinder(h = bearing_w, d = bearing_inner_shoulder_d);
            translate([0, 0, -0.1])
                cylinder(h = bearing_w + 0.2, d = rod_d);
        }
    }
    // shield band between the rings
    color("DarkSlateGray")
        translate([0, 0, bearing_w * 0.2])
            difference() {
                cylinder(h = bearing_w * 0.6, d = bearing_od - 3.5 + 0.1);
                translate([0, 0, -0.1])
                    cylinder(h = bearing_w, d = bearing_inner_shoulder_d - 0.1);
            }
}

$fn = 60;
bearing_608();
