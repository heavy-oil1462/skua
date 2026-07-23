// ==============================================================================
//   TIP BRACKET PEG HALF — print TWO (one per bracket; see
//   tip_bracket.scad for how the clamshell works). This is the half
//   with the registration pegs.
//
//   Prints split face UP: grooves and ring pocket are open channels,
//   the M5 bores vertical, the pegs small towers. A plain block, no
//   supports, no teardrops, nothing protruding.
// ==============================================================================

include <design_params.scad>
use <tip_bracket.scad>

$fn = 80;

translate([0, 0, bracket_w / 2])
    rotate([-90, 0, 0])
        bracket_peg_half();
