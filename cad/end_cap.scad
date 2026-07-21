// ==============================================================================
//   END CAP — arm tip: retains the vane and carries the swing-stop pin
//   (print TWO).
//
//   Slides over the last 8 mm of the arm rod, closed end outboard. The
//   axial pin on the open face rides in the vane sleeve's stop notch —
//   rotate the cap to set where the vane's driven stop sits (just past
//   hanging-vertical, see README), then tighten the M3 set screw. The
//   screw cuts its own thread in the printed 2.9 mm hole; it only holds
//   angle and axial position, so that is plenty.
//
//   Prints closed-end-down: the pin is a small vertical tower, the rod
//   bore a clean blind vertical hole.
// ==============================================================================

include <design_params.scad>

$fn = 80;

module end_cap() {
    difference() {
        union() {
            cylinder(h = cap_t, d = cap_d);
            // stop pin, on the open (rod-entry) face
            translate([cap_pin_r, 0, cap_t])
                cylinder(h = cap_pin_len, d = cap_pin_d);
        }
        // blind rod bore from the open face
        translate([0, 0, cap_t - cap_bore_depth])
            cylinder(h = cap_bore_depth + 0.1, d = rod_snug_d);
        // self-tapping M3 set screw, radial, into the bore
        translate([0, -cap_pin_r, cap_t - cap_bore_depth / 2])
            rotate([90, 0, 0])
                cylinder(h = cap_d / 2 + 1, d = m3_thread_d);
    }
}

end_cap();
