// ============================================================
// SKUA TRI VARIANT PARAMETERS — study values only, tri_ prefixed so
// nothing shadows design_params.scad (check_params enforces that).
//
// The tri keeps the dual's ENTIRE vane assembly verbatim (bracket,
// stub, PTFE seat, vane, cap-wedge stop; three caps hand-set to
// the same rotational sense instead of two) and changes only the
// count and the hub sizing: three arms at 120 degrees in its own
// wider washer-jaw hub from tri_hub.scad. The later ladder steps
// from scripts/tri_study.py (film vanes, the reach-for-arm trade)
// keep their values below.
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
                         // (rod prep: a hand die, no drilling at
                         // all). The nut and fender-washer sizes are
                         // the shared m8_* values in design_params
                         // (the dual's hub sandwich uses the same
                         // jaw stack)

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
tri_skin_t     = 0.4;  // membrane, drawn translucent (the PTFE
                       // washer on the ring boss is the shared
                       // ptfe_washer_* part in design_params, the
                       // dual's thrust seat)
tri_mast_h     = 300;  // the taller mounting, study numbers only,
                       // not drawn (the ladder credits ~10 percent
                       // wind for +1 m)
