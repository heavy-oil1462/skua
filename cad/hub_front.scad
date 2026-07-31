// ==============================================================================
//   HUB FRONT HALF — the clamshell VARIANT's half with the
//   registration pegs (print ONE, only for the no-rod-prep clamshell
//   build; see hub.scad for how the clamshell works).
//
//   Prints split face UP: the rod grooves are open channels, the bolt
//   bores vertical, the pegs small towers. No supports.
// ==============================================================================

include <design_params.scad>
use <hub.scad>

$fn = 80;

translate([0, 0, hub_w / 2])
    rotate([90, 0, 0])
        hub_half(pegs = true);
