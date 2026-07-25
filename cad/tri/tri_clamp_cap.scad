// ============================================================
// TRI CLAMP CAP — the tri v0.1's one tip part of its own (print
// THREE): the dual's end cap with the stop wedge deleted.
//
// Field finding from the dual, adopted by the tri from day one:
// two stop faces never land exactly together, so one face takes
// every hit regardless of intent. The tri makes it official; the
// stop ring's fin is the ONLY stop (the stop-face gate already
// sizes a single face for the full dynamic impact, and the keyed
// ring is the cheap replaceable part). That leaves the cap with
// no angular job: it is a pure vane retainer, the same wide
// dual-bolt slit clamp as the dual's, with nothing to set at
// assembly beyond parking the bolts in the arc the folding flag
// never sweeps. The slit sits at the dual's cap_slit_deg in the
// same frame, so clamping it at the dual's usual orientation
// lands the hardware in the same gated clearance band.
//
// The vane sleeve's upper notch goes unused; the vane stays the
// shared dual part. Prints closed-end-down like the dual cap:
// blind vertical bore, teardrop bolt bores, no supports.
// ============================================================

include <../design_params.scad>
use <../collar.scad>

$fn = 80;

module tri_clamp_cap() {
    difference() {
        cylinder(h = cap_t, d = cap_d);
        // blind rod bore from the open face
        translate([0, 0, cap_t - cap_bore_depth])
            cylinder(h = cap_bore_depth + 0.1, d = rod_snug_d);
        // slit and clamp bolts, dual verbatim: over the bore region
        // only, so the closed end stays a solid disc
        rotate([0, 0, cap_slit_deg]) {
            translate([0, -collar_slit / 2, cap_t - cap_bore_depth])
                cube([cap_d / 2 + 1, collar_slit, cap_bore_depth + 1]);
            for (z = [cap_t - cap_bore_depth + 4, cap_t - 4])
                clamp_bolt(z, cap_d);
        }
    }
}

tri_clamp_cap();
