// ==============================================================================
//   END CAP — arm tip: retains the vane and carries the swing-stop
//   wedge (print TWO).
//
//   Slides over the end of the arm rod, closed end outboard. The axial
//   wedge on the open face rides in the vane sleeve's outboard stop
//   notch (the arm collar's wedge takes the inboard notch, sharing the
//   impact) — rotate the cap to set where the vane's driven stop sits
//   (just past hanging-vertical, see README), then close the clamp.
//
//   A WIDE DUAL-BOLT slit clamp, like the collars: 16 mm of rod inside
//   the bore, two M3 bolts crossing the slit. The slit sits
//   cap_slit_deg around from the wedge: the nut corners and bolt tips
//   are the only things proud of the cylinder, so they must live in
//   the arc the folding flag's near edge never sweeps, and the offset
//   also keeps the wedge base solid. Friction, not a drilled
//   lock — the stop angle stays re-adjustable, and the price is a
//   seasonal re-torque of the clamp bolts (see CLAUDE.md).
//
//   Prints closed-end-down: the wedge is a small vertical prism, the
//   rod bore a clean blind vertical hole, the bolt bores horizontal
//   teardrops (clamp_bolt comes from collar.scad).
// ==============================================================================

include <design_params.scad>
use <collar.scad>
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
        // slit and clamp bolts, swung cap_slit_deg from the wedge so
        // the nuts and bolt tips sit where the flag never sweeps
        // (geometry_check gates the band); slit over the bore region
        // only so the closed end stays a solid disc
        rotate([0, 0, cap_slit_deg]) {
            translate([0, -collar_slit / 2, cap_t - cap_bore_depth])
                cube([cap_d / 2 + 1, collar_slit, cap_bore_depth + 1]);
            for (z = [cap_t - cap_bore_depth + 4, cap_t - 4])
                clamp_bolt(z, cap_d);
        }
    }
}

end_cap();
