// ROD FIT GAUGE — dials in the aluminum-rod fits with one print.
//
// A bar with five HORIZONTAL teardrop bores (same lib/bores.scad
// geometry, same lying-down orientation as the hub arm sockets and the
// vane sleeve), each engraved with its diameter. Push the rod through
// all five:
//
//   rod_snug_d = the bore the rod pushes into firmly and does not fall
//                out of (hub sockets, collar pre-clamp, end cap)
//   rod_free_d = the smallest bore the rod SPINS in without any grab
//                (the vane sleeve — err loose, gulls don't care)
//
// When arm_rod_d differs from rod_d a SECOND bar prints behind the
// first, stepped off the arm stock: push the ARM rod through it and
// type the firm one into arm_snug_d (the arms need no free fit,
// nothing spins on them).
//
// Type the numbers into cad/design_params.scad. Recalibrate when
// changing filament, printer, or rod stock.

include <../design_params.scad>
use <../lib/bores.scad>

hole_step  = 0.2;
hole_pitch = 16;
bar_w      = 14;
label_depth = 0.8;

$fn = 64;

module fit_bar(base) {
    diameters = [for (i = [0 : 4]) base + i * hole_step];
    bar_len = len(diameters) * hole_pitch;
    difference() {
        translate([0, -bar_w / 2, 0])
            cube([bar_len, bar_w, bar_w]);
        for (i = [0 : len(diameters) - 1]) {
            translate([i * hole_pitch + hole_pitch / 2, bar_w / 2 + 0.5,
                       bar_w / 2])
                rotate([0, 0, -90])
                    rod_bore(diameters[i], bar_w + 1);
            // engraved label on the top face
            translate([i * hole_pitch + hole_pitch / 2, 0,
                       bar_w - label_depth])
                linear_extrude(height = label_depth + 0.1)
                    text(str(diameters[i]), size = 3.4,
                         halign = "center", valign = "center");
        }
    }
}

fit_bar(rod_d);
if (arm_rod_d != rod_d)
    translate([0, bar_w + 4, 0]) fit_bar(arm_rod_d);
