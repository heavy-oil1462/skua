// ==============================================================================
//   VISUAL FIT CHECK — renders to main_assembly.png via scripts/regen_all.py.
//   All placement derives from design_params.scad; the numeric relations
//   (clearances, engagements) are gated by scripts/geometry_check.py.
//
//   Shown mid-action: the right vane is hard against its driven stop,
//   hanging flat and dragging the rotor around; the left vane has folded
//   toward its free stop, slipping through the wind. Bought parts (plank,
//   rods, bearings) render in wood/metal colors, printed parts in solids.
//
//   The step variable drives the docs/assembly step images (regen_all
//   renders -D step=1..5), following the bench-first build order:
//   1 the base alone with both bearings pressed, 2 the rotor core
//   ALONE as it is built at the bench (no base), with the retainer
//   clamped flush with the shaft tip, 3 rotor and base mated, base
//   drawn half cut away so the thrust collar and the retainer at its
//   running gap are visible, 4 the arm hardware slid apart on the
//   rod, 5 everything seated at rest. The default 99 is the complete
//   mid-action scene above.
// ==============================================================================

step = 99;

use <base.scad>
use <hub.scad>
use <vane.scad>
use <end_cap.scad>
use <collar.scad>
use <retainer.scad>
use <arm_collar.scad>
use <bearing_608.scad>
include <design_params.scad>

$fn = 60;

// Stations, bottom to top (z = 0 is the plank top / base bottom; the
// shaft tip and the uplift retainer live inside the base cavity)
shaft_top  = shaft_tip_h + shaft_length;
retainer_z = base_cavity_h + pocket_recess - retainer_gap
             - collar_boss_h - retainer_w;
hub_bottom = shaft_top - hub_shaft_socket;
arm_z      = hub_bottom + hub_arm_z;          // arm rod axis height
arm_root   = hub_len / 2 - hub_arm_socket;    // rod start (inside the hub)
arm_tip    = arm_root + arm_length;

// Stations along one arm, from geometry_check.py's model:
// [arm collar | boss+wedge][sleeve ......][gap][wedge face | cap, closed end out]
cap_face     = arm_tip + 4 - cap_t;           // rod ends 2 mm shy of the cap
                                              // bore floor: slack for rod cut length
sleeve_end   = cap_face - 1;                  // 1 mm running gap to the wedge face
sleeve_start = sleeve_end - vane_sleeve_len;
collar_x     = sleeve_start - collar_boss_h;  // boss touches the sleeve end

// --- base, bearings, plank (hidden in the bench-only step 2). In
//     step 3 the base is drawn half cut away so the collars and the
//     bottom bearing read; the plank has no hole, nothing protrudes
//     below the base ---
if (step == 1 || step >= 3) {
    color("Tomato")
        if (step == 3)
            difference() {
                base();
                // the step 3 camera looks from -y, so the -y half goes
                translate([-500, -1000, -1]) cube(1000);
            }
        else
            base();
    translate([0, 0, base_cavity_h + pocket_recess]) bearing_608();
    translate([0, 0, tower_h - bearing_w - pocket_recess]) bearing_608();

}

// --- step 2: shaft through both inner races, thrust collar on top ---
if (step >= 2) {
    color("DarkGray")
        translate([0, 0, shaft_tip_h])
            cylinder(h = shaft_length, d = rod_d);
    color("SteelBlue")
        translate([0, 0, tower_h - pocket_recess + collar_w + collar_boss_h])
            rotate([180, 0, 0])
                collar();
}

// --- uplift retainer: clamped at the bench flush with the shaft tip
//     in step 2, which puts it boss up retainer_gap under the bottom
//     bearing's inner race once mounted (retainer_z == shaft_tip_h,
//     gated by geometry_check) ---
if (step >= 2)
    color("SteelBlue") translate([0, 0, retainer_z]) retainer();

// --- step 2: hub, clamped at the shaft top on the bench ---
if (step >= 2)
    color("SteelBlue") translate([0, 0, hub_bottom]) hub();

// --- arms: right vane driving (hanging on its stop); the left vane
//     hangs too in every step image, folded only in the complete
//     mid-action scene ---
arm_side(swing = 0);
mirror([1, 0, 0]) arm_side(swing = step > 5 ? 75 : 0);

module arm_side(swing) {
    // Cap and collar are clamped at the stop-set angle (README step 5):
    // with the vane hanging (swing = 0) the wedge rests flush on its
    // notch wall, leaving the full vane_swing_deg free the other way.
    // The notch is centered on the vane panel's normal, so that angle
    // is vane_swing_deg/2 - 90 off vertical.
    wedge_set = vane_swing_deg / 2 - 90;
    e = step == 4 ? 18 : 0;   // step 4: hardware slid apart on the rod

    // step 2: arm rod seated in the hub on the bench
    if (step >= 2)
        color("DarkGray")
            translate([arm_root, 0, arm_z])
                rotate([0, 90, 0])
                    cylinder(h = arm_length, d = rod_d);

    if (step >= 4) {
        // inboard arm collar, boss and stop wedge outboard into the
        // sleeve's inboard notch (same angle as the cap's wedge)
        color("SteelBlue")
            translate([collar_x - collar_w - 2 * e, 0, arm_z])
                rotate([wedge_set, 0, 0])
                    rotate([0, 90, 0])
                        arm_collar();

        // vane, swung about the arm axis; 0 = hanging straight down
        color("Gold")
            translate([(sleeve_start + sleeve_end) / 2 - e, 0, arm_z])
                rotate([swing, 0, 0])
                    translate([0, -vane_sleeve_od / 2, 0])
                        rotate([-90, 0, 0])
                            vane();

        // end cap, closed end outboard, wedge toward the sleeve notch
        color("SteelBlue")
            translate([cap_face + cap_t + 2 * e, 0, arm_z])
                rotate([wedge_set, 0, 0])
                    rotate([0, -90, 0])
                        end_cap();
    }
}
