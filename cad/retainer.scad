// ==============================================================================
//   UPLIFT RETAINER — print ONE. A single-bolt slit collar clamped to
//   the shaft boss UP under the bottom bearing's inner race, inside
//   the base cavity, with retainer_gap of running clearance. It
//   carries nothing while the rotor runs; its job is to catch the
//   inner race if a wave or gust unloads the rotor, so the shaft can
//   never lift out of its bearings, and it keeps the bottom bearing
//   captive. The boss stays inside bearing_inner_shoulder_d so it
//   only ever meets the inner race.
//
//   One M3 across the slit instead of the usual two: this is the one
//   sanctioned narrow clamp, because it sees no load in normal running
//   and only a short catch when something unloads the rotor. Same
//   outer and boss diameters as the plain collar, narrower body.
//
//   Goes into the base cavity from below BEFORE the base is screwed
//   down (the tower windows are too narrow to pass it later); at
//   mounting the shaft is pressed into its snug bore and the gap is
//   set through the windows.
//
//   Prints ring-face down (boss up), slit vertical, the bolt bore
//   lying horizontal as a teardrop.
// ==============================================================================

include <design_params.scad>
use <collar.scad>

$fn = 80;

module retainer() {
    difference() {
        union() {
            cylinder(h = retainer_w, d = collar_od);
            translate([0, 0, retainer_w])
                cylinder(h = collar_boss_h, d = collar_boss_d);
        }
        // snug bore, so the collar holds position while positioning
        translate([0, 0, -0.5])
            cylinder(h = retainer_w + collar_boss_h + 1, d = rod_snug_d);
        // slit, along +x
        translate([0, -collar_slit / 2, -0.5])
            cube([collar_od / 2 + 1, collar_slit,
                  retainer_w + collar_boss_h + 1]);
        // the single clamp bolt, mid-width, crossing the slit
        clamp_bolt(retainer_w / 2, collar_od);
    }
}

retainer();
