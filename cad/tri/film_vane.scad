// ============================================================
// TRI VARIANT CONCEPT: film-and-frame vane. A printed perimeter frame with a
// membrane skin (mylar or ripstop) instead of v1's solid panel:
// same face area at roughly a third of the mass, which the study
// says buys both the fold threshold and the re-arm margin.
//
// CONCEPT MODEL, not a printable part: modeled in USE orientation
// (sleeve axis vertical at the origin, frame reaching +Y), because
// nothing here is exported to stl/. The sleeve keeps v1's diameter,
// free bore and stop notches (pie() comes from vane.scad), so the
// v1 stop ring, washer and end cap drop straight on.
// ============================================================

include <../design_params.scad>
include <tri_params.scad>
use <../vane.scad>

$fn = 60;

tri_notch_deg = vane_swing_deg + stop_wedge_deg;
tri_panel_x   = vane_sleeve_od / 2 - tri_frame_t;  // frame plane offset,
                                                 // tangent like v1

module film_vane() {
    sleeve_r = vane_sleeve_od / 2;
    difference() {
        cylinder(h = vane_sleeve_len, d = vane_sleeve_od);
        translate([0, 0, -0.5])
            cylinder(h = vane_sleeve_len + 1, d = rod_free_d);
        // stop notches, both ends, centered on the panel normal (-X
        // here matches pie()'s convention with the frame along +Y)
        for (z = [-0.25, vane_sleeve_len - stop_wedge_len - 0.75])
            translate([0, 0, z])
                linear_extrude(height = stop_wedge_len + 1)
                    pie(sleeve_r + 1, tri_notch_deg);
    }
    // frame: a picture-frame rectangle from the sleeve to the reach,
    // overhanging the sleeve top (its own height: the dual's solid
    // vane became an arched pennant with no height param)
    frame_h = tri_frame_h;
    translate([tri_panel_x, 0, 0]) {
        for (y = [sleeve_r, tri_vane_reach - tri_frame_w])
            translate([0, y, 0])
                cube([tri_frame_t, tri_frame_w, frame_h]);
        for (z = [0, frame_h - tri_frame_w])
            translate([0, sleeve_r, z])
                cube([tri_frame_t, tri_vane_reach - sleeve_r, tri_frame_w]);
        // the skin
        color("LemonChiffon", 0.45)
            translate([tri_frame_t / 2, sleeve_r, 0])
                cube([tri_skin_t, tri_vane_reach - sleeve_r, frame_h]);
    }
    // web joining sleeve to the frame's near edge
    hull() {
        translate([tri_panel_x, sleeve_r, 0])
            cube([tri_frame_t, tri_frame_w, vane_sleeve_len]);
        cylinder(h = vane_sleeve_len, d = vane_sleeve_od - 4);
    }
}

film_vane();
