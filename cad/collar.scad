// ==============================================================================
//   CLAMP COLLAR — print ONE (the arms use arm_collar.scad, which is
//   this part plus the inboard stop wedge).
//
//   Goes on the shaft: boss down, riding the top bearing's INNER race.
//   This is the rotor's thrust bearing seat — the whole rotating mass
//   hangs on it. The boss stays inside bearing_inner_shoulder_d so it
//   never touches the static outer race.
//
//   A slit ring closed by an M3 screw and nut across the gap — a plain
//   set screw would slide on smooth aluminum under sustained load, a
//   clamp will not. Prints ring-face down (boss up), the screw hole
//   lying horizontal.
// ==============================================================================

include <design_params.scad>

$fn = 80;

screw_x = (rod_snug_d / 2 + collar_od / 2) / 2;  // mid-wall, crossing the slit

module collar() {
    difference() {
        union() {
            cylinder(h = collar_w, d = collar_od);
            translate([0, 0, collar_w])
                cylinder(h = collar_boss_h, d = collar_boss_d);
        }
        // bore — snug pre-clamp so the collar stays put while positioning
        translate([0, 0, -0.5])
            cylinder(h = collar_w + collar_boss_h + 1, d = rod_snug_d);
        // slit
        translate([0, -collar_slit / 2, -0.5])
            cube([collar_od / 2 + 1, collar_slit, collar_w + collar_boss_h + 1]);
        // clamp screw across the slit
        translate([screw_x, 0, collar_w / 2]) {
            rotate([90, 0, 0])
                cylinder(h = collar_od, d = m3_clear_d, center = true);
            // screw head counterbore
            translate([0, -collar_od / 2 + 1.8, 0])
                rotate([90, 0, 0])
                    cylinder(h = collar_od / 2, d = m3_head_d);
            // nut pocket, one flat up so the roof prints
            translate([0, collar_od / 2 - 1.8, 0])
                rotate([-90, 0, 0])
                    rotate([0, 0, 30])
                        cylinder(h = collar_od / 2, d = m3_nut_af / cos(30), $fn = 6);
        }
    }
}

collar();
