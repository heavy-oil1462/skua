// ==============================================================================
//   TIP BRACKET — the knuckle at each arm tip (print TWO; the same
//   part serves both arms rotated 180 degrees about the stub bore).
//
//   Turns the vane hinge VERTICAL: a horizontal blind socket clamps
//   the last bracket_arm_grip of the arm rod, and a vertical through
//   bore clamps the stub rod the vane assembly rides on. With the
//   hinge vertical, folding a vane never fights gravity, which is
//   what lets the rotor self-start in near-calm air.
//
//   Both clamps are the usual wide dual-bolt slit clamps: the arm
//   slit opens upward over the socket, the stub slit opens outboard
//   through the end face, and each is crossed by two M3s with nylocs
//   in flat-up hex pockets. Nothing is drilled into either rod.
//
//   Prints as modeled, flat face down, no supports: the arm socket is
//   a horizontal teardrop, the stub bore a plain vertical hole, and
//   the bolt bores horizontal teardrops.
//
//   Origin: the arm enters at x=0, its axis along +x at y=0,
//   z=bracket_w/2. The stub bore is vertical at x=bracket_stub_x.
// ==============================================================================

include <design_params.scad>
use <lib/bores.scad>

$fn = 80;

module tip_bracket() {
    zc = bracket_w / 2;   // arm axis height above the bed
    difference() {
        translate([0, -bracket_w / 2, 0])
            cube([bracket_len, bracket_w, bracket_w]);

        // arm socket: blind horizontal teardrop
        translate([-0.5, 0, zc])
            rod_bore(rod_snug_d, bracket_arm_grip + 0.5);
        // arm clamp slit: down from the top face past the bore center
        translate([-1, -collar_slit / 2, zc - 4])
            cube([bracket_arm_grip + 5, collar_slit, zc + 5]);
        // two bolts along the grip, crossing the slit above the bore
        for (x = [6, bracket_arm_grip - 5])
            bracket_bolt(x, bracket_w - 3.5);

        // stub bore: plain vertical through hole
        translate([bracket_stub_x, 0, -0.1])
            cylinder(h = bracket_w + 0.2, d = rod_snug_d);
        // stub clamp slit: in from the end face past the bore center
        translate([bracket_stub_x - 4, -collar_slit / 2, -1])
            cube([bracket_len - bracket_stub_x + 5, collar_slit,
                  bracket_w + 2]);
        // two bolts along the vertical grip, crossing the slit
        for (z = [0.25 * bracket_w, 0.75 * bracket_w])
            bracket_bolt(bracket_len - 4, z);
    }
}

// One clamp bolt cut at (x, z), axis along y: teardrop clearance bore
// through the body, a teardrop head seat from -y, and a nyloc pocket
// (one flat up) opening at the +y face -- the same joint as
// collar.scad's clamp_bolt, placed in a rectangular body.
module bracket_bolt(x, z) {
    translate([x, 0, z]) {
        translate([0, -bracket_w / 2 - 1, 0])
            rotate([0, 0, 90]) {
                rod_bore(m3_clear_d, bracket_w + 2);
                rod_bore(m3_head_d + 0.6, bracket_w / 2 - 4);  // head seat
            }
        translate([0, collar_slit / 2 + 0.4, 0])
            rotate([-90, 0, 0])
                rotate([0, 0, 30])
                    cylinder(h = bracket_w, d = m3_nut_af / cos(30), $fn = 6);
    }
}

tip_bracket();
