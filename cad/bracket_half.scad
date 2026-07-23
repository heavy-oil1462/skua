// ==============================================================================
//   TIP BRACKET HALF — print FOUR, all identical (each bracket is two
//   of them; see tip_bracket.scad for how the clamshell works and why
//   one design mates with itself).
//
//   Prints split face UP: the arm and stub grooves are open channels,
//   the M5 bores vertical, the peg a small tower, and the boss arcs
//   and lower stop wedge stick out sideways on their 45-degree
//   self-supporting flares. No supports, and no teardrops needed
//   anywhere.
// ==============================================================================

include <design_params.scad>
use <tip_bracket.scad>

$fn = 80;

translate([0, 0, bracket_w / 2])
    rotate([90, 0, 0])
        bracket_half();
