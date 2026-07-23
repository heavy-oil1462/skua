// ==============================================================================
//   TIP BRACKET FIN HALF — print TWO (one per bracket; see
//   tip_bracket.scad for how the clamshell works). This is the half
//   with the registration pegs and the LOWER STOP FIN.
//
//   Prints split face UP: the grooves are open channels, the M5 bores
//   vertical, the pegs small towers, and the fin lies flush at the
//   top surface with its far flank on a printable lean. Its boss arc
//   sticks out sideways on its 45-degree flare. No supports, and no
//   teardrops needed anywhere.
// ==============================================================================

include <design_params.scad>
use <tip_bracket.scad>

$fn = 80;

translate([0, 0, bracket_w / 2])
    rotate([-90, 0, 0])
        bracket_fin_half();
