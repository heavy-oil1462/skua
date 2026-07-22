// ==============================================================================
//   HUB — clamps the top of the vertical shaft and carries both arm rods.
//
//   T-shaped in the arm/shaft plane: a full-length beam wraps the arm
//   sockets, a center stem wraps the shaft socket, and the unloaded
//   lower corners of the bounding box are gone (the arm rods flex long
//   before this block would). The beam undersides slope at 45 degrees
//   so it still prints flat on its bottom face with no supports: the
//   shaft socket is a clean vertical bore, the two arm sockets are
//   horizontal teardrop bores (lib/bores.scad), and the bolt bores are
//   horizontal teardrops.
//
//   Each of the three rods is held by an M3 THROUGH-BOLT crossing the
//   hub and the rod: seat the rod, drill it through the printed hole
//   (the hub is its own drill jig), and bolt through with a nyloc in
//   the pocket on the +Y face. Set screws pressing on smooth aluminum
//   creep and work loose; a bolt through the rod cannot slip or pull
//   out. All three heads sit on the same side face (-Y).
//
//   The arm sockets are blind: the center web between them doubles as
//   the depth stop, so both arms end up at the same reach by
//   construction. The shaft socket is blind from below; hub weight and
//   rotor thrust are carried by the shaft COLLAR on the top bearing, not
//   by this clamp — the set screws only transmit torque.
// ==============================================================================

include <design_params.scad>
use <lib/bores.scad>

$fn = 80;

module hub() {
    difference() {
        // rounded-corner body, cut to the T profile
        intersection() {
            linear_extrude(height = hub_h)
                offset(r = hub_corner_r)
                    square([hub_len - 2 * hub_corner_r,
                            hub_w - 2 * hub_corner_r], center = true);
            t_profile();
        }

        // shaft socket, blind, from the bottom
        translate([0, 0, -0.1])
            cylinder(h = hub_shaft_socket + 0.1, d = rod_snug_d);

        // arm sockets, blind, from each end
        for (m = [0, 1]) mirror([m, 0, 0])
            translate([hub_len / 2 - hub_arm_socket, 0, hub_arm_z])
                rod_bore(rod_snug_d, hub_arm_socket + 1);

        // through-bolts: arms at their socket midpoints, shaft mid-socket
        through_bolt([ (hub_len - hub_arm_socket) / 2, hub_arm_z]);
        through_bolt([-(hub_len - hub_arm_socket) / 2, hub_arm_z]);
        through_bolt([0, hub_shaft_socket / 2]);
    }
}

// The T profile in the arm/shaft plane, extruded across the hub width:
// a full-width beam above hub_beam_z wrapping the arm sockets, a stem
// of hub_stem_w wrapping the shaft socket, and 45 degree chamfers
// between them so the beam prints support-free in the flat-on-bottom
// orientation. Oversized in x and y; the intersection trims it.
module t_profile() {
    s = hub_stem_w / 2;
    rotate([90, 0, 0])
        linear_extrude(height = hub_w + 2, center = true)
            polygon([[-s, -1], [s, -1], [s, 0],
                     [s + hub_beam_z, hub_beam_z],
                     [hub_len / 2 + 1, hub_beam_z],
                     [hub_len / 2 + 1, hub_h + 1],
                     [-hub_len / 2 - 1, hub_h + 1],
                     [-hub_len / 2 - 1, hub_beam_z],
                     [-s - hub_beam_z, hub_beam_z],
                     [-s, 0]]);
}

// One M3 through-bolt: teardrop clearance bore across the full width,
// crossing the rod socket, with a teardrop head seat in the -Y face
// and a nyloc pocket (one flat up) in the +Y face. pos = [x, z] of the
// bolt axis.
module through_bolt(pos) {
    translate([pos[0], 0, pos[1]]) {
        translate([0, -hub_w / 2 - 1, 0])
            rotate([0, 0, 90])
                rod_bore(m3_clear_d, hub_w + 2);
        translate([0, -hub_w / 2 - 1, 0])
            rotate([0, 0, 90])
                rod_bore(m3_head_d + 0.6, 3);
        translate([0, hub_w / 2 - m3_locknut_t, 0])
            rotate([-90, 0, 0])
                rotate([0, 0, 30])
                    cylinder(h = m3_locknut_t + 1,
                             d = m3_nut_af / cos(30), $fn = 6);
    }
}

hub();
