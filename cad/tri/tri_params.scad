// ============================================================
// SKUA TRI VARIANT PARAMETERS — study values only, tri_ prefixed so
// nothing shadows design_params.scad (check_params enforces that).
//
// The tri v0.1 keeps the dual's vane side verbatim (8 mm arms and
// stubs, the tip bracket, stop ring, solid vane, end cap) and
// changes only the center: three arms into the split hub in
// tri_hub.scad, closed by one central M5 into the tapped shaft end.
// The later ladder steps from scripts/tri_study.py (PTFE washers,
// film vanes, the reach-for-arm trade) keep their values below.
// ============================================================

tri_arms       = 3;    // the consistency fix: no dead parking angle

// --- Split hub (tri_hub.scad): a cylinder split on the arm plane,
//     one central M5 through the top half into the tapped shaft end ---
tri_hub_d        = 60;   // seats run boss to rim: 23 mm grip per arm
tri_hub_bot_h    = 34;   // socket + shoulder + its half of the seats
tri_hub_top_h    = 14;   // the cap half
tri_hub_socket   = 25;   // blind shaft socket depth, from the bottom
tri_hub_gap      = 0.8;  // clamshell rule carried over from the dual:
                         // the arms stand proud of their seats, so the
                         // bolt preload lands on the rods, never on
                         // face-to-face plastic
tri_hub_boss_d   = 14;   // arm butt circle around the M5 clearance bore
tri_bolt_cbore_d = 16;   // washer + head counterbore in the top half
tri_bolt_cbore_h = 5;
tri_rod_thread   = 10;   // M5x0.8 tap depth (rod prep, not a printed
                         // dimension): the shaft's top end and both
                         // stub ends; an M5x30 reaches through the
                         // whole hub stack

// --- Prepared stub tip (tri_tip_bracket.scad, tri_end_cap.scad):
//     the stub is tapped both ends and SCREWED, never clamped.
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
tri_skin_t     = 0.4;  // membrane, drawn translucent
tri_washer_t   = 1;    // PTFE washer on the stop ring boss
tri_washer_od  = 14;
tri_mast_h     = 300;  // drawn stub of the taller mounting (the study
                      // credits ~10 percent wind for +1 m)
