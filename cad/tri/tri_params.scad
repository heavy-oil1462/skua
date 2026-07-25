// ============================================================
// SKUA TRI VARIANT PARAMETERS — study values only, tri_ prefixed so
// nothing shadows design_params.scad (check_params enforces that).
// The tri variant keeps the stub-side stack of v1 (8 mm stubs, stop
// ring, end cap, sleeve bore) and changes what scripts/tri_study.py
// says matters: arm count, arm rod, the vane construction, and the
// span-held reach-for-arm trade. Values mirror the study's ladder.
// ============================================================

tri_arms       = 3;    // the consistency fix: no dead parking angle
tri_arm_rod_d  = 10;   // arm rod ONLY; stubs and shaft stay 8 mm
tri_arm_length = 500;  // span held: shorter arms buy the longer reach
tri_vane_reach = 250;  // film vane reach (v1: 150)
tri_frame_w    = 8;    // printed perimeter frame member width
tri_frame_t    = 4;    // ... and thickness
tri_skin_t     = 0.4;  // membrane, drawn translucent
tri_washer_t   = 1;    // PTFE washer on the stop ring boss
tri_washer_od  = 14;
tri_mast_h     = 300;  // drawn stub of the taller mounting (the study
                      // credits ~10 percent wind for +1 m)
