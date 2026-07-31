// ==============================================================================
//   VANE — the flapping flag at the end of each arm (print TWO).
//
//   A sleeve that spins freely on the VERTICAL stub rod at the arm
//   tip, with a stiffened panel reaching out horizontally from it,
//   like a door on a hinge. The hinge being vertical is the low-wind
//   self-start: folding never lifts any weight, so the free vane
//   weathervanes at a whisper while the stopped vane presents its
//   face. The wind mechanism still needs ASYMMETRY: a vane that could
//   swing all the way around would just weathervane and the rotor
//   would never start. So the sleeve's top end face carries a
//   pie-shaped stop notch; the end cap's stop wedge rides in it and
//   limits the swing to vane_swing_deg. Pushed one way the vane
//   trails flat and slips through the wind; pushed the other way it
//   hits the stop, presents its full face, and drags the rotor
//   around. Both vanes stop in the same rotational sense seen from
//   above, so their torques add. The bang against the stop is free
//   gull-scaring percussion.
//
//   The cap is the ONLY stop and it clamps at any angle, so the
//   driven-stop angle is a two-bolt adjustment (field testing knob);
//   the stop ring below is just the smooth thrust seat. The notch's
//   radial walls match the wedge's flat side faces, so the stop is a
//   face contact. The sleeve's bottom end face is left whole: a full
//   ring resting on the stop ring's boss.
//
//   The panel is an arched pennant, drawn for the return trip: it
//   spans the sleeve, runs flat for vane_shoulder_w past the sleeve
//   top, RISES vane_arch_h in a quarter circle to the arch peak,
//   then sweeps down in a quarter ellipse to the bottom outer tip
//   at vane_reach. Every join is tangent-smooth and the tip lands
//   square on the bottom edge. The swing mechanics only feel how
//   area spreads over REACH, so the arch concentrates face near
//   the hinge: the hinge inertia the re-arm swing has to turn
//   drops by more than the fold moment does (field finding:
//   catching wind is easy, the low-energy re-arm is the fight),
//   and raising the arch while shortening the reach buys fold
//   moment back without buying back tip inertia. Nothing of the
//   flag sits above the sleeve top closer than the shoulder
//   radius, so the cap's bolt hardware clears the flag at ANY cap
//   angle (geometry_check gates it). The panel is a bare vane_t
//   skin, rim deleted for weight; see the note at the panel below.
//
//   Prints flat on the panel, no supports: the sleeve lies on the bed
//   and its bore is a teardrop (lib/bores.scad).
// ==============================================================================

include <design_params.scad>
use <lib/bores.scad>

$fn = 80;

// the notch is sized for the cap's wedge, the only stop, so the full
// vane_swing_deg stays free
notch_deg   = vane_swing_deg + stop_wedge_deg;
notch_depth = stop_wedge_len + 1;

// bottom_notch mirrors the stop notch onto the lower end face for a
// ring-fin stop (the tri variant); the dual's printable vane keeps
// its bottom face whole.
module vane(bottom_notch = false) {
    sleeve_r = vane_sleeve_od / 2;
    difference() {
        union() {
            // sleeve, axis along X at z = sleeve_r (lying on the bed);
            // -x is the bottom in use, the panel tops out at +x
            translate([-vane_sleeve_len / 2, 0, sleeve_r])
                rotate([0, 90, 0])
                    cylinder(h = vane_sleeve_len, r = sleeve_r);
            // wedge web joining the sleeve to the panel's near edge
            hull() {
                translate([-vane_sleeve_len / 2, 0, sleeve_r])
                    rotate([0, 90, 0])
                        cylinder(h = vane_sleeve_len, r = sleeve_r);
                translate([-vane_sleeve_len / 2, sleeve_r + 4, 0])
                    cube([vane_sleeve_len, 4, vane_t]);
            }
            // the panel: bare vane_t skin, no rim. Weight is king:
            // the old perimeter rim carried about a quarter of the
            // flag's hinge inertia for 5 g. The accepted risk is
            // slow creep-curl of the bare plate in the sun — a
            // curled flag stops folding flat, so WATCH FOR CURL in
            // the field; if it shows, reprint with a slim rim on
            // the arch edge (this is a deliberate experiment, not
            // an oversight)
            linear_extrude(height = vane_t)
                panel_outline(sleeve_r);
        }

        // free-spinning bore
        translate([-vane_sleeve_len / 2 - 0.5, 0, sleeve_r])
            rod_bore(rod_free_d, vane_sleeve_len + 1);

        // stop notch, TOP end face (both ends for a ring-fin stop),
        // centered on the panel side
        for (m = bottom_notch ? [0, 1] : [0]) mirror([m, 0, 0])
            translate([vane_sleeve_len / 2 - notch_depth, 0, sleeve_r])
                rotate([0, 90, 0])
                    linear_extrude(height = notch_depth + 0.5)
                        pie(sleeve_r + 1, notch_deg);
    }
}

// The panel's 2D outline in print orientation (x along the sleeve
// axis from the bottom edge at -x, y out from the hinge axis): a
// rectangle over the sleeve's span, a flat shoulder at the sleeve
// top, a quarter-circle rise to the arch peak, then the
// quarter-ellipse sweep down to the bottom outer tip. The rise
// leaves the shoulder square (so the shoulder stays a real flat),
// crests tangent into the ellipse at the peak, and the ellipse
// lands square on the bottom edge at the tip.
module panel_outline(sleeve_r) {
    spring = sleeve_r + vane_shoulder_w;   // arch springing line
    peak_y = spring + vane_arch_h;         // peak position over reach
    peak_x = vane_sleeve_len / 2 + vane_arch_h;
    polygon(concat(
        [[-vane_sleeve_len / 2, sleeve_r],
         [vane_sleeve_len / 2, sleeve_r]],
        // quarter-circle rise off the shoulder
        [for (t = [0 : 5 : 90])
            [vane_sleeve_len / 2 + vane_arch_h * sin(t),
             peak_y - vane_arch_h * cos(t)]],
        // quarter-ellipse sweep from the peak down to the tip
        [for (t = [5 : 5 : 90])
            [-vane_sleeve_len / 2
             + (vane_sleeve_len + vane_arch_h) * cos(t),
             peak_y + (vane_reach - peak_y) * sin(t)]]));
}

// 2D pie wedge of the given radius/angle. Drawn centered on the -X
// direction of the extrusion plane, which after the rotate([0, 90, 0])
// above points straight up in print orientation — the panel plane's
// NORMAL, not the panel side. Mechanically the notch's angular position
// is arbitrary (the stop angle is set at assembly by rotating the cap),
// but main_assembly.scad's cap placement derives from this reference,
// so move both together.
module pie(r, deg) {
    polygon(concat([[0, 0]],
        [for (a = [-deg / 2 : 5 : deg / 2]) [-r * cos(a), r * sin(a)]],
        [[-r * cos(deg / 2), r * sin(deg / 2)]]));
}

vane();
