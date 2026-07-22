// Annular-sector stop wedge, shared by end_cap.scad and arm_collar.scad.
// Sits on z = 0, extends +z, centered on the +x direction. Its flat
// radial side faces land flush on the vane sleeve notch's walls (cut by
// the same kind of radial plane in vane.scad), so the stop impact is a
// face contact, not a cylinder's line contact.
//
// Fully parameterized like bores.scad: callers pass the shared
// stop_wedge_* values from design_params.scad.
//
// deg should be a multiple of 4 so the 2-degree facet steps land
// exactly on the side faces.

module stop_wedge(ri, ro, deg, h) {
    linear_extrude(height = h)
        polygon(concat(
            [for (a = [-deg / 2 : 2 : deg / 2]) [ro * cos(a), ro * sin(a)]],
            [for (a = [deg / 2 : -2 : -deg / 2]) [ri * cos(a), ri * sin(a)]]));
}
