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
shaft_length = 150;  // vertical shaft; sets how high the rotor rides.
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
base_d         = 120;
base_t         = 8;
screw_hole_d   = 4.5;   // 4.2 mm wood screws
screw_head_d   = 9.5;   // countersink cone top diameter
screw_circle_d = 95;
screw_count    = 4;
tower_od       = 40;    // 9 mm wall around the bearing pockets
tower_h        = 70;    // bearing pockets at top and bottom of this
tower_bore_d   = 19;    // between the pockets: retains the outer races,
                        // clears the 12 mm inner-race shoulders
gusset_t       = 6;
gusset_reach   = 25;    // how far a gusset runs out from the tower wall
gusset_h       = 55;

// --- Hub (clamps the shaft top, carries both arms) ---
hub_len          = 80;  // along the arms
hub_w            = 32;
hub_h            = 48;
hub_arm_z        = 38;  // arm bore axis above the hub bottom face
hub_shaft_socket = 30;  // blind shaft socket depth, from the bottom
hub_arm_socket   = 35;  // blind arm socket depth, from each end
hub_corner_r     = 6;
hub_beam_z       = 28;  // T profile: below this only the stem and its 45
hub_stem_w       = 30;  // degree chamfers remain — the lower corners of
                        // the old box carried no load and cost print time

// --- M3 hardware (set screws and the collar clamp) ---
m3_thread_d = 2.9;  // screw forms its own thread (end cap set screw)
m3_clear_d  = 3.4;
m3_nut_af   = 5.8;  // nut across flats, incl. pocket clearance
m3_nut_t    = 2.6;
m3_head_d   = 6.4;

// --- Vane (the flapping flag; TWO of them) ---
vane_sleeve_len = 70;
vane_sleeve_od  = 22;   // thick walls: the stop notch shoulders take the
                        // wedge impact every pass
vane_width      = 200; // panel size along the arm; wide-and-short so the
vane_drop       = 100; // panel (sleeve AXIS to bottom edge) keeps its area
                       // while clearing the plank under the 150 mm shaft
vane_t          = 3;
vane_rim_w      = 4;   // stiffening rim around the panel
vane_rim_h      = 6;
vane_swing_deg  = 120; // free swing between the two stops

// --- Stop cap (arm tip: retains the vane, carries the outboard stop wedge) ---
cap_d          = 24;
cap_t          = 12;
cap_bore_depth = 10;

// --- Stop wedges (SHARED: one on the end cap, one on the arm collar;
//     each rides a notch in its end of the vane sleeve so the stop
//     impact is carried by two, and their flat radial faces land flush
//     on the notch walls — lib/stop_wedge.scad) ---
stop_wedge_deg = 40;   // angular thickness; the notch arc grows by this
stop_wedge_len = 6;    // proud of the carrier face, riding in the notch
stop_wedge_ri  = 4.5;  // inner radius: clears the rod
stop_wedge_ro  = 10.5; // outer radius: spans the sleeve wall, inside the
                       // carrier faces (geometry_check.py verifies all)

// --- Clamp collars (ONE plain on the shaft as thrust support; the arm
//     collars in arm_collar.scad add the inboard stop wedge) ---
collar_od     = 24;
collar_w      = 10;
collar_boss_d = 12;    // rides the bearing inner race / vane sleeve end
collar_boss_h = 2;
collar_slit   = 2;

// --- Assembly stations / sanity limits ---
shaft_bottom_gap = 2;   // shaft tip hovers this far above the plank
printer_bed      = 210; // largest printable footprint, gates part sizes
