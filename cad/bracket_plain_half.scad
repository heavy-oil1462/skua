// ==============================================================================
//   TIP BRACKET PLAIN HALF — print TWO (one per bracket; see
//   tip_bracket.scad for how the clamshell works). This is the half
//   with the peg sockets and no fin.
//
//   Prints split face UP: the grooves are open channels, the M5 bores
//   vertical, and its boss arc sticks out sideways on its 45-degree
//   flare. No supports, and no teardrops needed anywhere.
// ==============================================================================

include <design_params.scad>
use <tip_bracket.scad>

$fn = 80;

translate([0, 0, bracket_w / 2])
    rotate([90, 0, 0])
        bracket_plain_half();
