// ==============================================================================
//   DIE JIG — one soft vice jaw for the die pass. Print TWO; they
//   are identical and close groove to groove over the shaft.
//
//   The build's one rod prep is the M8x1.25 hand die run down the
//   shaft top, and the shaft has to be held hard for it without the
//   vice's steel teeth marking the rod (the marked length would ride
//   inside the hub bore and the collar). Each half is a plain block
//   with a full-length half-round groove at the gauged snug fit, so
//   the vice grips the rod over the whole groove area instead of on
//   two knurled lines.
//
//   The clamshell rule applies here like everywhere else: the groove
//   is shallower than half the rod by half the clamp gap, so the
//   closed halves never touch and every bit of vice preload lands on
//   the rod. An even gap between the blocks means the rod is gripped;
//   faces touching means it is not.
//
//   Nothing registers the halves; the rod keys them across the
//   grooves and the vice's flat jaws square their backs. Also handy
//   as a general soft jaw for holding 8 mm rod while cutting to
//   length.
//
//   Prints groove face UP: an open channel, no bridges, no supports.
// ==============================================================================

include <design_params.scad>

$fn = 80;

module die_jig_half() {
    difference() {
        cube([die_jig_len, die_jig_w, die_jig_h]);
        // the groove axis rides half the gap above the top face, so
        // the closed halves stay apart on the rod
        translate([-0.5, die_jig_w / 2, die_jig_h + die_jig_gap / 2])
            rotate([0, 90, 0])
                cylinder(h = die_jig_len + 1, d = rod_snug_d);
    }
}

die_jig_half();
