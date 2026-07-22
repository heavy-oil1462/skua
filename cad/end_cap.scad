// ==============================================================================
//   END CAP — arm tip: retains the vane and carries the swing-stop
//   wedge (print TWO).
//
//   Slides over the end of the arm rod, closed end outboard. The axial
//   wedge on the open face rides in the vane sleeve's outboard stop
//   notch (the arm collar's wedge takes the inboard notch, sharing the
//   impact) — rotate the cap to set where the vane's driven stop sits
//   (just past hanging-vertical, see README), then tighten the M3 set
//   screw. The screw cuts its own thread in the printed 2.9 mm hole; it
//   only holds angle and axial position, so that is plenty.
//
//   Prints closed-end-down: the wedge is a small vertical prism, the
//   rod bore a clean blind vertical hole.
// ==============================================================================

include <design_params.scad>
use <lib/stop_wedge.scad>

$fn = 80;

module end_cap() {
    difference() {
        union() {
            cylinder(h = cap_t, d = cap_d);
            // stop wedge, on the open (rod-entry) face
            translate([0, 0, cap_t])
                stop_wedge(stop_wedge_ri, stop_wedge_ro,
                           stop_wedge_deg, stop_wedge_len);
        }
        // blind rod bore from the open face
        translate([0, 0, cap_t - cap_bore_depth])
            cylinder(h = cap_bore_depth + 0.1, d = rod_snug_d);
        // self-tapping M3 set screw, radial, from the outside INTO the
        // bore (cut from the axis outward so it always breaks through)
        translate([0, 0, cap_t - cap_bore_depth / 2])
            rotate([90, 0, 0])
                cylinder(h = cap_d / 2 + 1, d = m3_thread_d);
    }
}

end_cap();
