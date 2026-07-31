// ==============================================================================
//   STOP RING — print TWO. The vane's thrust seat, SMOOTH: one
//   D-footed piece per arm tip, no fin.
//
//   A D-shaped foot drops into the matching pocket in the tip
//   bracket's top face and is trapped when the clamshell closes, the
//   same way the rods are. On top of the flush foot sits the boss
//   ring, the small ring the sleeve spins on. Field finding from the
//   built machine: two stops never land exactly together, one face
//   takes every hit anyway, and a fin near the sleeve's end face is
//   friction risk on the wing — so the fin is gone, the cap's wedge
//   is the only stop, and the driven-stop angle is a two-bolt cap
//   adjustment instead of baked-in geometry. The D flat still keys
//   the foot into the pocket, it just no longer has an angle to set.
//
//   Being its own part is what makes it print perfectly: on its
//   back, foot and boss are plain vertical prisms with no overhang
//   anywhere. It is also the sacrificial piece: the thrust seat
//   takes all the spin friction, and a worn one is a tiny reprint.
//
//   The fin stays available as a module option (fin_deg > 0 grows a
//   fin of that arc, contact flank at the driven stop): the tri
//   variant's keyed-ring stop uses it, and it is the way back if the
//   cap-only experiment loses.
// ==============================================================================

include <design_params.scad>
use <lib/stop_wedge.scad>

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

stop_ring();
