// ==============================================================================
//   STOP RING — print TWO. The vane's lower stop and its thrust
//   seat, one keyed piece per arm tip.
//
//   A D-shaped foot drops into the matching pocket in the tip
//   bracket's top face and is trapped when the clamshell closes, the
//   same way the rods are: the D flat can only fit one way, so the
//   stop angle, and with it the rotor's rotational sense, is set by
//   geometry and cannot be assembled wrong. On top of the flush foot
//   sit the boss ring (the small ring the sleeve spins on) and the
//   stop fin: its contact flank sits where the flag stops exactly at
//   panel-along-the-arm, and the sleeve's notch is cut for the fin's
//   ring_wedge_deg width, so the full vane_swing_deg stays free. The
//   cap's wedge is set at assembly to land together with the fin.
//
//   Being its own part is what makes it print perfectly: on its
//   back, foot, boss and fin are plain vertical prisms with no
//   overhang anywhere. It is also the sacrificial piece: stop faces
//   take every clack, and a worn one is a tiny reprint.
// ==============================================================================

include <design_params.scad>
use <lib/stop_wedge.scad>

$fn = 80;

// the contact flank's angle past outboard: puts the driven stop at
// exactly panel-along-the-arm (main_assembly draws the same relation)
wall_lo = 90 - (vane_swing_deg + ring_wedge_deg) / 2;

module stop_ring() {
    difference() {
        union() {
            // D foot, flat toward outboard (+x)
            intersection() {
                cylinder(h = ring_foot_t, d = ring_foot_d);
                translate([ring_flat_x - 1000, -500, -1]) cube(1000);
            }
            // boss: the sleeve's thrust seat
            translate([0, 0, ring_foot_t])
                cylinder(h = collar_boss_h, d = collar_boss_d);
            // the stop fin, through the boss layer and into the notch
            translate([0, 0, ring_foot_t])
                rotate([0, 0, wall_lo + ring_wedge_deg / 2])
                    stop_wedge(stop_wedge_ri, stop_wedge_ro,
                               ring_wedge_deg,
                               collar_boss_h + stop_wedge_len);
        }
        // free over the (static) stub: the ring is keyed, not clamped
        translate([0, 0, -0.5])
            cylinder(h = ring_foot_t + collar_boss_h + 1, d = rod_free_d);
    }
}

stop_ring();
