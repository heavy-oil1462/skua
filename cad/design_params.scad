// ============================================================
// SKUA SHARED DESIGN PARAMETERS — single source of truth for
// every dimension two parts must agree on.
//
// Consumers:
//   - every part in cad/ does        include <design_params.scad>
//   - parts in cad/calibration/ do   include <../design_params.scad>
//   - scripts/check_params.py FAILS the build if any of these names
//     is re-declared anywhere else — change values HERE only.
//
// Keep this file to simple `name = value;` lines so the tooling can
// parse it. One-off experiments: `openscad -D name=value` beats the
// include, no need to edit this file.
// ============================================================

// --- Aluminum rod stock (bought; ONE diameter everywhere) ---
// 8 mm rod is chosen to match the 608 bearing bore, so the shaft and
// both arms cut from the same stock.
rod_d        = 8;
shaft_length = 300;  // vertical shaft; sets how high the rotor rides.
                     // Long enough that the hanging vanes clear the
                     // plank — geometry_check.py gates the clearance.
arm_length   = 600;  // each horizontal arm (two of them)

// --- 608 skateboard bearing (bought, TWO of them) ---
// Two bearings spaced apart in the base tower instead of one: a single
// 7 mm-wide bearing lets a 1.2 m rotor wobble; two races 45 mm apart
// make the shaft run true. They come in packs of 8 anyway.
bearing_od = 22;
bearing_w  = 7;
bearing_inner_shoulder_d = 12;  // inner-ring shoulder: anything riding
                                // the INNER race (collar boss) stays
                                // inside this; anything static stays
                                // outside it
pocket_recess = 0.5;  // bearings sit this far below the tower faces so
                      // the rotating inner race never rubs plank or collar body

// --- Calibrated fits (print the gauges, type the winners in here) ---
bearing_press_d = 21.8; // pocket that grips the outer race — cad/calibration/bearing_pocket_gauge.scad
rod_snug_d      = 8.2;  // sockets the rod presses into (hub, collar, cap) — cad/calibration/rod_fit_gauge.scad
rod_free_d      = 8.6;  // bores that must SPIN on the rod (vane sleeve) — same gauge
fit_tol         = 0.2;  // clearance for printed slots/pockets

// --- Base (screwed to the plank) ---
base_d         = 110;
base_t         = 6;
screw_hole_d   = 4.5;   // 4.2 mm wood screws
screw_head_d   = 9.5;   // countersink cone top diameter
screw_circle_d = 90;
screw_count    = 4;
tower_od       = 32;
tower_h        = 60;    // bearing pockets at top and bottom of this
tower_bore_d   = 19;    // between the pockets: retains the outer races,
                        // clears the 12 mm inner-race shoulders
gusset_t       = 4;
gusset_reach   = 16;    // how far a gusset runs out from the tower wall
gusset_h       = 35;

// --- Hub (clamps the shaft top, carries both arms) ---
hub_len          = 70;  // along the arms
hub_w            = 26;
hub_h            = 38;
hub_arm_z        = 30;  // arm bore axis above the hub bottom face
hub_shaft_socket = 22;  // blind shaft socket depth, from the bottom
hub_arm_socket   = 30;  // blind arm socket depth, from each end
hub_corner_r     = 6;

// --- M3 hardware (set screws and the collar clamp) ---
m3_thread_d = 2.9;  // screw forms its own thread (end cap set screw)
m3_clear_d  = 3.4;
m3_nut_af   = 5.8;  // nut across flats, incl. pocket clearance
m3_nut_t    = 2.6;
m3_head_d   = 6.4;

// --- Vane (the flapping flag; TWO of them) ---
vane_sleeve_len = 70;
vane_sleeve_od  = 16;
vane_width      = 150; // panel size along the arm
vane_drop       = 150; // sleeve AXIS to the panel bottom edge
vane_t          = 2;
vane_rim_w      = 3;   // stiffening rim around the panel
vane_rim_h      = 5;
vane_swing_deg  = 120; // free swing between the two stops

// --- Stop cap (arm tip: retains the vane, carries the stop pin) ---
cap_d          = 20;
cap_t          = 10;
cap_bore_depth = 8;
cap_pin_d      = 3.5;
cap_pin_len    = 5;
cap_pin_r      = 6.4;  // pin center radius: clears the rod, lands on the
                       // vane sleeve wall (geometry_check.py verifies both)

// --- Clamp collar (THREE: shaft thrust support + one per arm) ---
collar_od     = 20;
collar_w      = 8;
collar_boss_d = 12;    // rides the bearing inner race / vane sleeve end
collar_boss_h = 2;
collar_slit   = 2;

// --- Assembly stations / sanity limits ---
shaft_bottom_gap = 2;   // shaft tip hovers this far above the plank
printer_bed      = 210; // largest printable footprint, gates part sizes
