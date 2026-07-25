// ============================================================
// SKUA v2 CONCEPT PARAMETERS — study values only, v2_ prefixed so
// nothing shadows design_params.scad (check_params enforces that).
// The v2 concept keeps the stub-side stack of v1 (8 mm stubs, stop
// ring, end cap, sleeve bore) and changes what scripts/v2_study.py
// says matters: arm count, arm rod, the vane construction, and the
// span-held reach-for-arm trade. Values mirror the study's ladder.
// ============================================================

v2_arms       = 3;    // the consistency fix: no dead parking angle
v2_arm_rod_d  = 10;   // arm rod ONLY; stubs and shaft stay 8 mm
v2_arm_length = 500;  // span held: shorter arms buy the longer reach
v2_vane_reach = 250;  // film vane reach (v1: 150)
v2_frame_w    = 8;    // printed perimeter frame member width
v2_frame_t    = 4;    // ... and thickness
v2_skin_t     = 0.4;  // membrane, drawn translucent
v2_washer_t   = 1;    // PTFE washer on the stop ring boss
v2_washer_od  = 14;
v2_mast_h     = 300;  // drawn stub of the taller mounting (the study
                      // credits ~10 percent wind for +1 m)
