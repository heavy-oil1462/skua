// ==============================================================================
//   HUB BACK HALF — the clamshell half with the peg sockets (print
//   ONE; see hub.scad for how the clamshell works). At assembly it is
//   the same shape as the front half turned 180 degrees, so it prints
//   in the same orientation: split face UP, grooves as open channels,
//   bolt bores vertical. No supports.
// ==============================================================================

include <design_params.scad>
use <hub.scad>

$fn = 80;

translate([0, 0, hub_w / 2])
    rotate([90, 0, 0])
        hub_half(pegs = false);
