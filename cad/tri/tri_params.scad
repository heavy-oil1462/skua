// ============================================================
// SKUA TRI VARIANT PARAMETERS — study values only, tri_ prefixed so
// nothing shadows design_params.scad (check_params enforces that).
//
// The tri v0.1 keeps the dual's vane and rod stock (the vane with
// its bottom notch grown back, the stop ring with its fin option
// on, both one-argument variants of the dual parts: the tri's only
// stop is the keyed ring fin) and changes the joints: three arms
// keyed by the spacer
// disc in tri_hub.scad and clamped between fender washers on the
// die-threaded shaft, and screwed stubs at the tips. The later
// ladder steps from scripts/tri_study.py (PTFE washers, film
// vanes, the reach-for-arm trade) keep their values below.
// ============================================================

tri_arms       = 3;    // the consistency fix: no dead parking angle

// --- Washer-jaw hub (tri_hub.scad): one printed spacer disc keys
//     three arms in full-height slots; two large fender washers
//     press onto the proud rods from either side, clamped by M8
//     nylocs on the shaft's die-threaded top end. Steel jaws, no
//     plastic in compression, no seasonal re-torque ---
tri_hub_d        = 50;   // slot flanks run boss to rim: 18 mm of
                         // bearing per arm for horizontal bending
tri_hub_disc_h   = 7.2;  // rod_d minus the clamshell gap: the arms
                         // stand proud of both faces by 0.4, so the
                         // washer preload lands on the rods, never
                         // on face-to-face plastic
tri_hub_boss_d   = 14;   // arm butt circle around the bore
tri_hub_gap      = 0.8;  // clamshell rule: the rods stand proud of
                         // their seats or slots by half this per
                         // side, so preload lands on the rods
tri_hub_shell_h  = 6;    // the sandwich variant's half-shell: a
                         // 3.6 half-seat plus a 2.4 web under it
tri_shaft_thread = 40;   // M8x1.25 die length on the shaft's top end
                         // (rod prep: a hand die, no drilling at all)
tri_nut_af       = 13.4; // M8 nyloc across flats, drawn in the scene
tri_nut_t        = 8;
tri_m8_washer_od = 30;   // fender washer: the clamp jaw, gripping
                         // each rod from the boss edge outward
tri_m8_washer_t  = 1.5;
tri_rod_thread   = 10;   // M5x0.8 tap depth (rod prep): both ends of
                         // each stub; the shaft is die-threaded,
                         // never tapped or drilled

// --- Prepared stub tip (tri_tip_bracket.scad, tri_end_cap.scad):
//     DEFERRED kit direction, not in the v0.1 scene (v0.1 uses the
//     dual's clamped tip verbatim, so the only rod prep in the
//     whole machine is the shaft's die pass).
//     The stub is tapped both ends and SCREWED, never clamped.
//     The stop is the ring fin ALONE (field finding from the dual:
//     two stops never land exactly together, one face takes every
//     hit anyway, and the stop-face gate already sizes one face
//     for the full impact), so the cap is a smooth keyless
//     retainer, stub rotation is irrelevant, and the rod prep is
//     two taps, nothing more ---
tri_step_t      = 3;    // printed step under the stub in the bracket
tri_stub_length = 103;  // step to cap bore ceiling: bracket above the
                        // step (21) + boss (2) + washer (1) + sleeve
                        // (70) + running play (1) + cap bore (8)
tri_cap_t       = 14;
tri_cap_bore_h  = 8;    // free locating bore over the stub's top
tri_cap_cbore_d = 13;   // washer + head counterbore, closed face
tri_cap_cbore_h = 3;

// --- Later ladder steps (tri_study.py's numbers; NOT in the v0.1
//     scene, which uses the dual's rod_d / arm_length / vane) ---
tri_arm_rod_d  = 10;   // reach-for-arm trade only; arm rod, never stubs
tri_arm_length = 500;  // span held: shorter arms buy the longer reach
tri_vane_reach = 250;  // film vane reach (dual: 150)
tri_frame_w    = 8;    // printed perimeter frame member width
tri_frame_t    = 4;    // ... and thickness
tri_frame_h    = 140;  // film vane frame height (the dual's old
                       // full-height panel; the dual itself moved
                       // to the arched pennant with no height
                       // param). Keep in sync with FILM_FRAME_H in
                       // scripts/tri_study.py, which cannot read
                       // this file
tri_skin_t     = 0.4;  // membrane, drawn translucent
tri_washer_t   = 1;    // PTFE washer on the stop ring boss
tri_washer_od  = 14;
tri_mast_h     = 300;  // the taller mounting, study numbers only,
                       // not drawn (the ladder credits ~10 percent
                       // wind for +1 m)
