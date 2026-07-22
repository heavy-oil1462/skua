// ==============================================================================
//   THRUST COLLAR — print ONE (the arms use arm_collar.scad, which is
//   this part plus the inboard stop wedge).
//
//   Goes on the shaft: boss down, riding the top bearing's INNER race.
//   This is the rotor's thrust bearing seat — the whole rotating mass
//   hangs on it. The boss stays inside bearing_inner_shoulder_d so it
//   never touches the static outer race.
//
//   Held by an M3 THROUGH-BOLT crossing collar and rod: at assembly the
//   collar is positioned on its snug bore, the rod is drilled through
//   the printed hole (the collar is its own drill jig), and the bolt
//   goes through with a nyloc nut in the side pocket. No friction grip
//   on smooth aluminum — printed clamps creep loose over the years,
//   a bolt through the rod cannot.
//
//   Prints ring-face down (boss up), the bolt hole lying horizontal as
//   a teardrop.
// ==============================================================================

include <design_params.scad>
use <lib/bores.scad>

$fn = 80;

module collar() {
    difference() {
        union() {
            cylinder(h = collar_w, d = collar_od);
            translate([0, 0, collar_w])
                cylinder(h = collar_boss_h, d = collar_boss_d);
        }
        // bore — snug, so the collar holds position while drilling
        translate([0, 0, -0.5])
            cylinder(h = collar_w + collar_boss_h + 1, d = rod_snug_d);
        bolt_pocket(collar_od);
    }
}

// The through-bolt cut, shared with arm_collar via this file: teardrop
// clearance bore across the given diameter at mid ring height, a
// teardrop head seat on the -Y side, a nyloc pocket (one flat up) on
// the +Y side.
module bolt_pocket(od) {
    translate([0, 0, collar_w / 2]) {
        translate([0, -od / 2 - 1, 0])
            rotate([0, 0, 90])
                rod_bore(m3_clear_d, od + 2);
        translate([0, -od / 2 - 1, 0])
            rotate([0, 0, 90])
                rod_bore(m3_head_d + 0.6, 2.5);
        translate([0, od / 2 - m3_locknut_t, 0])
            rotate([-90, 0, 0])
                rotate([0, 0, 30])
                    cylinder(h = m3_locknut_t + 1,
                             d = m3_nut_af / cos(30), $fn = 6);
    }
}

collar();
