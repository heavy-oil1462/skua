// ==============================================================================
//   HUB — clamps the top of the vertical shaft and carries both arm rods.
//
//   Prints flat on its bottom face, no supports: the shaft socket is a
//   clean vertical bore, the two arm sockets are horizontal teardrop
//   bores (lib/bores.scad), and the set-screw nut slots drop in from the
//   top face.
//
//   Each of the three rods is held by an M3 set screw threading through
//   a nut in a top-entry slot. The nut sits BEHIND 5 mm of wall relative
//   to the screw's reaction force, so tightening cannot pop it out.
//   All three screws enter from the same side face (-Y).
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
        // rounded-corner body
        linear_extrude(height = hub_h)
            offset(r = hub_corner_r)
                square([hub_len - 2 * hub_corner_r, hub_w - 2 * hub_corner_r],
                       center = true);

        // shaft socket, blind, from the bottom
        translate([0, 0, -0.1])
            cylinder(h = hub_shaft_socket + 0.1, d = rod_snug_d);

        // arm sockets, blind, from each end
        for (m = [0, 1]) mirror([m, 0, 0])
            translate([hub_len / 2 - hub_arm_socket, 0, hub_arm_z])
                rod_bore(rod_snug_d, hub_arm_socket + 1);

        // set screws: arms at their socket midpoints, shaft mid-socket
        set_screw([ (hub_len - hub_arm_socket) / 2, hub_arm_z]);
        set_screw([-(hub_len - hub_arm_socket) / 2, hub_arm_z]);
        set_screw([0, hub_shaft_socket / 2]);
    }
}

// One M3 set screw: horizontal clearance hole from the -Y face to the
// rod, crossing a nut slot that drops in from the top face 5 mm behind
// that face. pos = [x, z] of the screw axis.
module set_screw(pos) {
    slot_y = -hub_w / 2 + 5;   // nut center, 5 mm in from the entry face
    translate([pos[0], 0, pos[1]]) {
        rotate([90, 0, 0])
            cylinder(h = hub_w / 2 + 1, d = m3_clear_d);
        // nut slot: sized for the flats in X/Y, corners run vertically
        translate([-m3_nut_af / 2, slot_y - (m3_nut_t + 0.4) / 2,
                   -(m3_nut_af / sqrt(3) + 0.4)])
            cube([m3_nut_af,
                  m3_nut_t + 0.4,
                  hub_h]);  // over-tall: opens through the top face
    }
}

hub();
