// ==============================================================================
//   VISUAL FIT CHECK — renders to main_assembly.png via scripts/regen_all.py.
//   All placement derives from design_params.scad; the numeric relations
//   (clearances, engagements) are gated by scripts/geometry_check.py.
//
//   Shown mid-action: the right flag is hard against its driven stop,
//   face to the wind, dragging the rotor around; the left flag has
//   weathervaned toward trailing on its vertical hinge, slipping
//   through the wind. Bought parts (plank, rods, bearings) render in
//   wood/metal colors, printed parts in solids.
//
//   The step variable drives the docs/assembly step images (regen_all
//   renders -D step=1..5), following the bench-first build order:
//   1 the base alone with both bearings pressed, 2 the rotor core
//   ALONE as it is built at the bench (no base), with the retainer
//   clamped flush with the shaft tip, 3 rotor and base mated, base
//   drawn half cut away so the thrust collar and the retainer at its
//   running gap are visible, 4 the tip brackets clamped and the vane
//   hardware slid apart up the stubs, 5 everything seated at the
//   stops. The default 99 is the complete mid-action scene above.
// ==============================================================================

step = 99;

use <base.scad>
use <hub_shell.scad>
use <vane.scad>
use <end_cap.scad>
use <collar.scad>
use <retainer.scad>
use <tip_bracket.scad>
use <bearing_608.scad>
include <design_params.scad>

$fn = 60;

// Stations, bottom to top (z = 0 is the plank top / base bottom; the
// shaft tip and the uplift retainer live inside the base cavity).
// The hub sandwich hangs from the shaft top: top nyloc flush with
// the tip of the die-threaded section, arm axes on the sandwich's
// mid-plane
shaft_top  = shaft_tip_h + shaft_length;
retainer_z = base_cavity_h + pocket_recess - retainer_gap
             - collar_boss_h - retainer_w;
arm_z      = shaft_top - m8_nut_t - m8_washer_t - hub_shell_h
             - hub_clamp_gap / 2;             // arm rod axis height
arm_root   = hub_shell_boss_d / 2;            // arms butt the boss circle
arm_tip    = arm_root + arm_length;

// Stations at the arm tip, from geometry_check.py's model: the
// bracket clamps the arm's last bracket_arm_grip, the stub stands
// through it, and the sleeve rides the PTFE washer on the bracket's
// flat top under the cap
bracket_x  = arm_tip - bracket_arm_grip;      // bracket inboard face
stub_x     = bracket_x + bracket_stub_x;      // the vertical hinge axis
sleeve_bot = arm_z + bracket_h / 2 + ptfe_washer_t;  // on the washer
cap_face_z = sleeve_bot + vane_sleeve_len + 1;       // 1 mm running play

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

// --- step 2: the hub sandwich, threaded onto the shaft top on the
//     bench: lower nyloc and washer, two identical shells cradling
//     the arms, upper washer and nyloc (the top of the shaft is
//     die-threaded M8, drawn plain) ---
if (step >= 2) {
    color("Silver")
        translate([0, 0, arm_z - hub_clamp_gap / 2 - hub_shell_h])
            rotate([180, 0, 0]) m8_stack();
    color("SteelBlue")
        translate([0, 0, arm_z - hub_clamp_gap / 2 - hub_shell_h])
            hub_shell();
    color("SteelBlue")
        translate([0, 0, arm_z + hub_clamp_gap / 2 + hub_shell_h])
            rotate([180, 0, 0]) hub_shell();
    color("Silver")
        translate([0, 0, arm_z + hub_clamp_gap / 2 + hub_shell_h])
            m8_stack();
}

// --- arms: right vane driving (hanging on its stop); the left vane
//     hangs too in every step image, folded only in the complete
//     mid-action scene ---
arm_side(swing = 0);
mirror([1, 0, 0]) arm_side(swing = step > 5 ? 75 : 0);

module arm_side(swing) {
    // At the driven stop the notch's contact wall lies on the cap
    // wedge's flank; the cap is clamped so the panel points exactly
    // straight out along the arm (the test setting drawn here — on
    // the water any angle goes, two bolts). `swing` folds the vane
    // toward trailing.
    vane_ang = -90 - swing;
    e = step == 4 ? 22 : 0;   // step 4: hardware slid apart up the stub

    // step 2: arm rod seated in the hub on the bench
    if (step >= 2)
        color("DarkGray")
            translate([arm_root, 0, arm_z])
                rotate([0, 90, 0])
                    cylinder(h = arm_length, d = arm_rod_d);

    if (step >= 4) {
        // tip bracket on the arm end, stub rod standing through,
        // and the PTFE thrust washer on the bracket's flat top
        color("SteelBlue")
            translate([bracket_x, 0, arm_z - bracket_h / 2])
                tip_bracket();
        color("DarkGray")
            translate([stub_x, 0, arm_z - bracket_h / 2])
                cylinder(h = stub_length, d = rod_d);
        color("White")
            translate([stub_x, 0, arm_z + bracket_h / 2 + 0.4 * e])
                difference() {
                    cylinder(h = ptfe_washer_t, d = ptfe_washer_od);
                    translate([0, 0, -0.5])
                        cylinder(h = ptfe_washer_t + 1,
                                 d = ptfe_washer_id);
                }

        // vane on the stub: panel out along the arm at the stop
        color("Gold")
            translate([stub_x, 0, sleeve_bot + e])
                rotate([0, 0, vane_ang])
                    translate([vane_sleeve_od / 2, 0, vane_sleeve_len / 2])
                        rotate([0, -90, 0])
                            vane();

        // end cap on the stub tip, open face and wedge DOWN into the
        // sleeve's top notch, its contact flank on the notch wall
        // (the rotation reduces to 90 - swing/2 for any wedge width)
        color("SteelBlue")
            translate([stub_x, 0, cap_face_z + cap_t + 2 * e])
                rotate([0, 0, 90 - vane_swing_deg / 2])
                    rotate([180, 0, 0])
                        end_cap();
    }
}
