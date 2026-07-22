// ==============================================================================
//   ARM COLLAR — inboard stop on each arm rod (print TWO).
//
//   The thrust collar (collar.scad) plus the inboard stop wedge: it
//   rides in the vane sleeve's inboard notch, mirroring the end cap's
//   wedge in the outboard notch, so every stop impact is shared by two
//   flat faces instead of hammering one. At assembly both are set to
//   the same angle before drilling the rod for the through-bolts
//   (README).
//
//   The wedge sits at 90 degrees to the through-bolt, so the bolt bore
//   never weakens its base. It clears the boss face by stop_wedge_len,
//   matching the cap wedge's engagement.
//
//   Prints like the collar: ring face down, boss and wedge up.
// ==============================================================================

include <design_params.scad>
use <collar.scad>
use <lib/stop_wedge.scad>

$fn = 80;

module arm_collar() {
    collar();
    // stop wedge: through the boss layer, then stop_wedge_len proud of it
    rotate([0, 0, 180])
        translate([0, 0, collar_w])
            stop_wedge(stop_wedge_ri, stop_wedge_ro, stop_wedge_deg,
                       collar_boss_h + stop_wedge_len);
}

arm_collar();
