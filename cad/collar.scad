// ==============================================================================
//   PLAIN COLLAR — print ONE (the bottom of the shaft gets
//   retainer.scad, its narrow single-bolt cousin).
//
//   The rotor's THRUST collar: sits on the shaft boss down, riding the
//   top bearing's INNER race, and the whole rotating mass hangs on it.
//   The boss stays inside bearing_inner_shoulder_d so it never touches
//   the static outer race.
//
//   A WIDE DUAL-BOLT slit clamp: 16 mm of grip on the rod, closed by
//   two M3 bolts crossing the slit, each with a nyloc in a flat-up hex
//   pocket. Friction, not a drilled lock: the trade for a machine
//   with no drilled rods and every joint re-adjustable. Grip fades as
//   printed plastic relaxes, so re-torque the clamp bolts seasonally.
//   If it ever slips, the shaft tip lands on the plank inside the base
//   cavity after shaft_tip_h mm and grinds audibly; nothing lets go.
//
//   Prints ring-face down (boss up), slit vertical, the bolt bores
//   lying horizontal as teardrops.
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
        // bore — snug, so the collar holds position while positioning
        translate([0, 0, -0.5])
            cylinder(h = collar_w + collar_boss_h + 1, d = rod_snug_d);
        // slit, along +x
        translate([0, -collar_slit / 2, -0.5])
            cube([collar_od / 2 + 1, collar_slit,
                  collar_w + collar_boss_h + 1]);
        // two clamp bolts crossing the slit
        for (z = [0.28, 0.72]) clamp_bolt(z * collar_w, collar_od);
    }
}

// One clamp bolt cut, shared with end_cap.scad: teardrop clearance
// bore across the part at mid-wall of the +x side (crossing the slit),
// a teardrop head seat from -y, and a nyloc pocket (one flat up) whose
// floor sits just clear of the rod bore. z is the bolt height, od the
// part's outer diameter.
module clamp_bolt(z, od) {
    x = (rod_snug_d / 2 + od / 2) / 2;
    translate([x, 0, z]) {
        translate([0, -od / 2 - 1, 0])
            rotate([0, 0, 90]) {
                rod_bore(m3_clear_d, od + 2);
                rod_bore(m3_head_d + 0.6, od / 2 - 4);  // head seat
            }
        translate([0, rod_snug_d / 2 + 0.4, 0])
            rotate([-90, 0, 0])
                rotate([0, 0, 30])
                    cylinder(h = od, d = m3_nut_af / cos(30), $fn = 6);
    }
}

collar();
