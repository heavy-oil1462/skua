// ==============================================================================
//   END CAP — arm tip: retains the vane and carries the swing-stop
//   wedge (print TWO).
//
//   Slides over the end of the arm rod, closed end outboard. The axial
//   wedge on the open face rides in the vane sleeve's outboard stop
//   notch (the arm collar's wedge takes the inboard notch, sharing the
//   impact) — rotate the cap to set where the vane's driven stop sits
//   (just past hanging-vertical, see README), then drill the rod
//   through the printed hole and fit the M3 through-bolt with a nyloc:
//   a positive lock for angle and axial position, where a screw
//   pressing on smooth aluminum would work loose under the stop
//   impacts.
//
//   Prints closed-end-down: the wedge is a small vertical prism, the
//   rod bore a clean blind vertical hole, the bolt bore a horizontal
//   teardrop.
// ==============================================================================

include <design_params.scad>
use <lib/bores.scad>
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
        // M3 through-bolt crossing cap and rod at mid bore: teardrop
        // clearance bore, head seat -Y, nyloc pocket +Y (one flat up)
        translate([0, 0, cap_t - cap_bore_depth / 2]) {
            translate([0, -cap_d / 2 - 1, 0])
                rotate([0, 0, 90])
                    rod_bore(m3_clear_d, cap_d + 2);
            translate([0, -cap_d / 2 - 1, 0])
                rotate([0, 0, 90])
                    rod_bore(m3_head_d + 0.6, 2.5);
            translate([0, cap_d / 2 - m3_locknut_t, 0])
                rotate([-90, 0, 0])
                    rotate([0, 0, 30])
                        cylinder(h = m3_locknut_t + 1,
                                 d = m3_nut_af / cos(30), $fn = 6);
        }
    }
}

end_cap();
