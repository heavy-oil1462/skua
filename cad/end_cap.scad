// ==============================================================================
//   END CAP — arm tip: retains the vane and carries the swing-stop
//   wedge, the vane's ONLY stop (print TWO).
//
//   Slides over the end of the stub rod, closed end up. The axial
//   wedge on the open face rides in the vane sleeve's top notch —
//   rotate the cap to set where the vane's driven stop sits, then
//   close the clamp. The seat below is the smooth PTFE washer, so
//   the driven-stop angle belongs entirely to this clamp: loosening
//   two bolts moves it anywhere, the field-testing knob.
//
//   A WIDE DUAL-BOLT slit clamp, like the collars: 16 mm of rod inside
//   the bore, two M3 bolts crossing the slit. The slit sits
//   cap_slit_deg around from the wedge so the wedge base stays solid;
//   the flag's cut-away top inner corner (vane_shoulder_w) keeps the
//   nut corners and bolt tips clear of the fold at ANY cap angle.
//   Friction, not a drilled lock — the stop angle stays
//   re-adjustable, and the price is a seasonal re-torque of the
//   clamp bolts (see CLAUDE.md).
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
        // its base stays solid; slit over the bore region only so
        // the closed end stays a solid disc
        rotate([0, 0, cap_slit_deg]) {
            translate([0, -collar_slit / 2, cap_t - cap_bore_depth])
                cube([cap_d / 2 + 1, collar_slit, cap_bore_depth + 1]);
            for (z = [cap_t - cap_bore_depth + 4, cap_t - 4])
                clamp_bolt(z, cap_d);
        }
    }
}

end_cap();
