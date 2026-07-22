// ==============================================================================
//   VISUAL FIT CHECK — renders to main_assembly.png via scripts/regen_all.py.
//   All placement derives from design_params.scad; the numeric relations
//   (clearances, engagements) are gated by scripts/geometry_check.py.
//
//   Shown mid-action: the right vane is hard against its driven stop,
//   hanging flat and dragging the rotor around; the left vane has folded
//   toward its free stop, slipping through the wind. Bought parts (plank,
//   rods, bearings) render in wood/metal colors, printed parts in solids.
// ==============================================================================

use <base.scad>
use <hub.scad>
use <vane.scad>
use <end_cap.scad>
use <collar.scad>
use <arm_collar.scad>
use <bearing_608.scad>
include <design_params.scad>

$fn = 60;

// Stations, bottom to top (z = 0 is the plank top / base bottom)
shaft_top  = shaft_bottom_gap + shaft_length;
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

// --- the plank (bought lumber, whatever is on the boat) ---
color("BurlyWood") translate([-160, -70, -21]) cube([320, 140, 21]);

// --- printed base + its two press-fit bearings ---
color("Tomato") base();
translate([0, 0, pocket_recess]) bearing_608();
translate([0, 0, tower_h - bearing_w - pocket_recess]) bearing_608();

// --- shaft: aluminum rod through both inner races ---
color("DarkGray")
    translate([0, 0, shaft_bottom_gap])
        cylinder(h = shaft_length, d = rod_d);

// --- thrust collar: boss down, riding the top bearing's inner race ---
color("SteelBlue")
    translate([0, 0, tower_h - pocket_recess + collar_w + collar_boss_h])
        rotate([180, 0, 0])
            collar();

// --- hub, clamped at the shaft top ---
color("SteelBlue") translate([0, 0, hub_bottom]) hub();

// --- arms: right vane driving (hanging on its stop), left vane folded ---
arm_side(swing = 0);
mirror([1, 0, 0]) arm_side(swing = 75);

module arm_side(swing) {
    // Cap and collar are clamped at the stop-set angle (README step 5):
    // with the vane hanging (swing = 0) the wedge rests flush on its
    // notch wall, leaving the full vane_swing_deg free the other way.
    // The notch is centered on the vane panel's normal, so that angle
    // is vane_swing_deg/2 - 90 off vertical.
    wedge_set = vane_swing_deg / 2 - 90;

    // arm rod
    color("DarkGray")
        translate([arm_root, 0, arm_z])
            rotate([0, 90, 0])
                cylinder(h = arm_length, d = rod_d);

    // inboard arm collar, boss and stop wedge outboard into the sleeve's
    // inboard notch (its wedge lands at the same angle as the cap's)
    color("SteelBlue")
        translate([collar_x - collar_w, 0, arm_z])
            rotate([wedge_set, 0, 0])
                rotate([0, 90, 0])
                    arm_collar();

    // vane, swung about the arm axis; 0 = hanging straight down
    color("Gold")
        translate([(sleeve_start + sleeve_end) / 2, 0, arm_z])
            rotate([swing, 0, 0])
                translate([0, -vane_sleeve_od / 2, 0])
                    rotate([-90, 0, 0])
                        vane();

    // end cap, closed end outboard, wedge toward the sleeve notch
    color("SteelBlue")
        translate([cap_face + cap_t, 0, arm_z])
            rotate([wedge_set, 0, 0])
                rotate([0, -90, 0])
                    end_cap();
}
