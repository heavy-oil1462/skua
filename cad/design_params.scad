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
shaft_length = 145;  // vertical shaft; sets how high the rotor rides.
                     // Long enough that the hanging vanes clear the
                     // plank (geometry_check.py gates the clearance)
                     // and that the tip reaches down through the
                     // uplift retainer inside the base cavity.
arm_length   = 600;  // each horizontal arm (two of them)
stub_length  = 120;  // the vertical hinge rod at each arm tip (two of
                     // them, same stock): clamped through the tip
                     // bracket, carrying the vane sleeve and its cap

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
bearing_press_d = 21.95; // pocket that grips the outer race — cad/calibration/bearing_pocket_gauge.scad
rod_snug_d      = 8.0;  // sockets the rod presses into (hub, collar, cap) — cad/calibration/rod_fit_gauge.scad
rod_free_d      = 8.2;  // bores that must SPIN on the rod (vane sleeve) — same gauge
fit_tol         = 0.2;  // clearance for printed slots/pockets

// --- Base (screwed to the plank) ---
base_d         = 120;
base_t         = 8;
screw_hole_d   = 4.5;   // 4.2 mm wood screws
screw_head_d   = 9.5;   // countersink cone top diameter
screw_circle_d = 95;
screw_count    = 4;
tower_od       = 40;    // 9 mm wall around the bearing pockets
tower_h        = 74;    // top bearing pocket at the top; the bottom
                        // pocket sits base_cavity_h up, above the
                        // retainer cavity, keeping the races 45 mm apart
tower_bore_d   = 19;    // between the pockets: retains the outer races,
                        // clears the 12 mm inner-race shoulders
gusset_t       = 6;
gusset_reach   = 25;    // how far a gusset runs out from the tower wall
gusset_h       = 55;

// --- Hub (clamps the shaft top, carries both arms) ---
// A CLAMSHELL: split on the vertical plane that contains all three rod
// axes, so the two halves close over the rods like a pillow block and
// five M3 bolts with wide washers clamp everything at once. No hole is
// drilled in any rod at the hub, which is where rod bending is worst.
hub_len          = 80;  // along the arms
hub_w            = 32;
hub_h            = 54;
hub_arm_z        = 44;  // arm bore axis above the hub bottom face
hub_shaft_socket = 30;  // blind shaft socket depth, from the bottom
hub_arm_socket   = 35;  // blind arm socket depth, from each end
hub_beam_z       = 28;  // T profile: below this only the stem and its 45
hub_stem_w       = 34;  // degree chamfers remain — the lower corners of
                        // the old box carried no load and cost print time
hub_clamp_gap    = 0.8; // total gap between the closed halves: the rods
                        // stand proud of their grooves by this much, so
                        // bolt preload lands on the rods, never on
                        // face-to-face plastic
hub_bolt_stem_x  = 10;  // M5 clamp bolts: two flanking the shaft groove
hub_bolt_beam_x  = 25;  // ... two under the beam, outboard ...
hub_bolt_beam_z  = 34;  // ... plus one through the center web at arm
                        // height; geometry_check verifies every wall
hub_peg_x        = 33;  // registration pegs, so the bolts never carry
hub_peg_z        = 32;  // the job of aligning the halves
hub_peg_d        = 4;

// --- M3 hardware (collar and cap clamps: each is a wide slit clamp
//     closed by TWO bolts crossing the slit — friction on the rod, but
//     spread over a long grip and generous bolt preload; nothing is
//     drilled into any rod, and every joint stays re-adjustable.
//     Tradeoff: printed clamps relax over time, re-torque seasonally) ---
m3_clear_d    = 3.4;
m3_nut_af     = 5.8;  // nut across flats, incl. pocket clearance
m3_locknut_t  = 4.4;  // nyloc nut height, incl. pocket clearance
m3_head_d     = 6.4;

// --- M5 hardware (hub clamshell only: the clamp preload lives or dies
//     on washer bearing area and survivable hand-torque, and M5 wins
//     both; heads and nylocs sit on the flat faces with wide washers,
//     so only the clearance bore is modeled) ---
m5_clear_d    = 5.5;

// --- Vane (the flapping flag; TWO of them). The sleeve rides a
//     VERTICAL stub rod at the arm tip, so folding never fights
//     gravity: a hanging panel only folds when wind pressure beats
//     its weight (~7 m/s for printed plastic), and below that a
//     horizontal-hinge rotor just rocks in place. On a vertical
//     hinge the free vane weathervanes at a whisper, the stopped
//     vane presents its face, and the rotor self-starts in near-calm ---
vane_sleeve_len = 70;
vane_sleeve_od  = 22;   // thick walls: the stop notch shoulders take the
                        // wedge impact every pass
vane_width      = 140; // panel length ALONG the sleeve axis, so vertical
                       // in use; spans the sleeve and overhangs its top
vane_reach      = 150; // hinge axis to the panel's outer vertical edge,
                       // horizontal in use
vane_t          = 3;
vane_rim_w      = 4;   // stiffening rim around the panel
vane_rim_h      = 6;
vane_swing_deg  = 120; // free swing between the two stops

// --- Stop cap (stub tip: retains the vane, carries the upper stop
//     wedge; a wide dual-bolt slit clamp on the rod end) ---
cap_d          = 24;
cap_t          = 20;
cap_bore_depth = 18;

// --- Tip bracket (the clamshell knuckle at each arm tip that turns
//     the hinge vertical; TWO half designs, print two of each: the
//     FIN half carries the lower stop, the PLAIN half the pegs'
//     sockets, and the assembled bracket rotated 180 about the stub
//     serves the other arm). Both rod axes lie in the split plane,
//     so the halves close over arm and stub like the hub closes over
//     its rods, bolted with M5x40s and wide washers. The bracket also
//     carries the sleeve's boss seat and the LOWER stop fin on its
//     top face, baked at the driven-stop angle, so the stub stack is
//     just sleeve and end cap ---
bracket_w        = 24;  // clamshell thickness across the split
bracket_h        = 30;  // height; also the stub clamp's grip length
bracket_len      = 52;  // along the arm
bracket_arm_grip = 22;  // blind arm groove depth
bracket_stub_x   = 36;  // stub axis from the bracket's inboard face
bracket_bolt_dz  = 9.5; // arm-clamp M5s at mid-grip, this far above
                        // and below the arm axis
bracket_bolt_dx  = 9;   // stub-clamp M5s at mid-height, this far
                        // inboard and outboard of the stub axis
bracket_peg_x    = 28;  // the two registration pegs (fin half),
bracket_peg_dz   = 10;  // this far above and below the arm axis
bracket_clamp_gap = 0.8; // total gap between the closed halves, hub
                         // rule: bolt preload lands on the rods,
                         // never on face-to-face plastic
bracket_wedge_deg = 50; // the lower stop fin's arc. One flank lies
                        // exactly IN the split plane, which is the
                        // print's top surface, so it prints clean
                        // with no ramp; the other flank then leans
                        // 90 - this from vertical, so keep >= 45.
                        // The sleeve notch grows to match, keeping
                        // the full vane_swing_deg of free swing ---

// --- Stop wedges (SHARED: one on the end cap, set at assembly, and
//     one printed into the tip bracket's top face at the fixed
//     driven-stop angle; each rides a notch in its end of the vane
//     sleeve so the stop impact is carried by two, and their flat
//     radial faces land flush on the notch walls — lib/stop_wedge.scad) ---
stop_wedge_deg = 40;   // angular thickness; the notch arc grows by this
stop_wedge_len = 6;    // proud of the carrier face, riding in the notch
stop_wedge_ri  = 4.5;  // inner radius: clears the rod
stop_wedge_ro  = 10.5; // outer radius: spans the sleeve wall, inside the
                       // carrier faces (geometry_check.py verifies all)

// --- Clamp collars (the plain thrust collar rides the top bearing's
//     inner race and carries the rotor; the uplift retainer in
//     retainer.scad shares these diameters with its own narrower
//     width; the boss diameters also size the tip bracket's sleeve
//     seat). Wide dual-bolt slit clamps, like the cap. ---
collar_od     = 24;
collar_w      = 16;
collar_boss_d = 12;    // rides the bearing inner race / vane sleeve end
collar_boss_h = 2;
collar_slit   = 2;

// --- Uplift retainer (single-bolt collar, boss up under the bottom
//     bearing inside the base cavity; carries nothing in normal
//     running, catches the inner race if a wave or gust unloads the
//     rotor, and keeps the bottom bearing captive). Clamped to the
//     shaft AT THE BENCH, flush with the tip; the running gap is then
//     created at mounting by gauging the THRUST collar 1 mm off the
//     top race while the bottom race rests on the retainer boss, so
//     the finished gap never depends on reaching inside the base ---
retainer_w     = 8;    // narrower than the dual-bolt clamps: it sees no
                       // load in normal running, so one M3 across the
                       // slit is enough (the one sanctioned narrow clamp)
retainer_gap   = 1;    // running clearance between boss and inner race,
                       // and the gauge thickness at the thrust collar

// --- Base cavity (the space under the bottom bearing that the
//     retainer lives in; shaft and retainer enter it from below
//     before the base is screwed down) ---
base_cavity_d  = 30;   // clears the spinning retainer all round
base_cavity_h  = 14;   // plank top to the bottom bearing pocket: the
                       // retainer stack plus tip clearance, nothing more

// --- Assembly stations / sanity limits ---
shaft_tip_h      = 3.5; // where the shaft tip rides above the plank.
                        // NOT free: the tip is flush with the retainer
                        // bottom (the bench clamping reference), so this
                        // equals the retainer's resting height and
                        // geometry_check pins the two together
printer_bed      = 210; // largest printable footprint, gates part sizes
