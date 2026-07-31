// ==============================================================================
//   TRI STOP RING — TRI VARIANT ONLY (the dual deleted its ring: the
//   cap wedge is its only stop and its thrust seat is the bought
//   PTFE washer on the bracket's flat top).
//
//   A D-shaped foot drops into the matching pocket in the tip
//   bracket's top face (the bracket's ring_pocket = true option) and
//   is trapped when the clamshell closes, the same way the rods are.
//   On top of the flush foot sits the boss ring the sleeve spins on,
//   and through it the keyed stop FIN (fin_deg grows a fin of that
//   arc, contact flank at the driven stop): in the tri the fin is
//   the only stop, the cap is a smooth retainer, and the D flat is
//   what bakes the stop angle in.
//
//   On its back, foot, boss and fin are plain vertical prisms with
//   no overhang anywhere. The thrust seat takes all the spin
//   friction, and a worn one is a tiny reprint.
// ==============================================================================

include <../design_params.scad>
use <../lib/stop_wedge.scad>

$fn = 80;

module stop_ring(fin_deg = 0) {
    // the fin's contact flank sits where the flag stops exactly at
    // panel-along-the-arm (the tri scene draws the same relation)
    wall_lo = 90 - (vane_swing_deg + fin_deg) / 2;
    difference() {
        union() {
            // D foot, flat toward outboard (+x)
            intersection() {
                cylinder(h = ring_foot_t, d = ring_foot_d);
                translate([ring_flat_x - 1000, -500, -1]) cube(1000);
            }
            // boss: the sleeve's thrust seat, as narrow as printable
            // so the friction radius, and with it the self-start
            // wind, stays minimal (performance_check gates it)
            translate([0, 0, ring_foot_t])
                cylinder(h = collar_boss_h, d = ring_boss_d);
            // optional stop fin, through the boss layer and into the
            // sleeve's lower notch (tri variant only)
            if (fin_deg > 0)
                translate([0, 0, ring_foot_t])
                    rotate([0, 0, wall_lo + fin_deg / 2])
                        stop_wedge(stop_wedge_ri, stop_wedge_ro,
                                   fin_deg,
                                   collar_boss_h + stop_wedge_len);
        }
        // free over the (static) stub: the ring is keyed, not clamped
        translate([0, 0, -0.5])
            cylinder(h = ring_foot_t + collar_boss_h + 1, d = rod_free_d);
    }
}

stop_ring(stop_wedge_deg);
