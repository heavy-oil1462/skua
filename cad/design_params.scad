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

// --- Aluminum rod stock (bought) ---
// 8 mm rod matches the 608 bearing bore, so shaft and stubs are
// PINNED to it (and the hub disc variant's M8 die pass rides on it).
// The arms default to the same stock but have their own knob below:
// thinner arms are a weight experiment, and the storm gate decides
// (the arm is the machine's fuse — watch its SF when thinning).
rod_d        = 8;
arm_rod_d    = 8;    // the two horizontal arms ONLY. Changing it
                     // (say to 6) resizes the hub shell seats and
                     // the bracket arm grooves; re-gauge arm_snug_d
                     // on the new stock first (the rod fit gauge
                     // grows a second bar when this differs from
                     // rod_d; the seat depth follows the gauged fit,
                     // and geometry_check gates the shell web left
                     // under it)
shaft_length = 145;  // vertical shaft; sets how high the rotor rides.
                     // Long enough that the hanging vanes clear the
                     // plank (geometry_check.py gates the clearance)
                     // and that the tip reaches down through the
                     // uplift retainer inside the base cavity.
arm_length   = 600;  // each horizontal arm (two of them)
stub_length  = 112;  // the vertical hinge rod at each arm tip (two of
                     // them, same stock): clamped through the tip
                     // bracket, carrying the vane sleeve and its cap
                     // (112 since the sleeve seat became the 1 mm PTFE
                     // washer; the old ring boss stood 2 mm)

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
arm_snug_d      = 8.0;  // grooves the ARM presses into (hub, bracket,
                        // disc slots) — same gauge, arm bar. MEASURED,
                        // never derived: while arm_rod_d == rod_d this
                        // must equal rod_snug_d (geometry_check pins
                        // it); on other arm stock, gauge that stock
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

// --- Hub clamshell VARIANT (hub.scad, optional alternative to the
//     sandwich below for a build that skips the die pass) ---
// A CLAMSHELL: split on the vertical plane that contains all three rod
// axes, so the two halves close over the rods like a pillow block and
// five M5 bolts with wide washers clamp everything at once. No hole is
// drilled in any rod at the hub, which is where rod bending is worst.
// Was the default until the washer-jaw sandwich took over: it needs
// no rod prep at all, at the price of five M5s and about 80 g. The
// arm station rides about 30 mm higher than the sandwich puts it,
// on the same shaft.
hub_len          = 70;  // along the arms
hub_w            = 22;  // across the split: each half is a groove
                        // (4) plus backing wall (7); the clamp
                        // preload is bolt-and-washer, not wall
hub_h            = 52;
hub_arm_z        = 44;  // arm bore axis above the hub bottom face
hub_shaft_socket = 30;  // blind shaft socket depth, from the bottom
hub_arm_socket   = 30;  // blind arm socket depth, from each end
                        // (still well past the bracket's 22 grip)
hub_beam_z       = 28;  // T profile: below this only the stem and its 45
hub_stem_w       = 30;  // degree chamfers remain — the lower corners of
                        // the old box carried no load and cost print time
hub_clamp_gap    = 0.8; // total gap between the closed halves: the rods
                        // stand proud of their grooves by this much, so
                        // bolt preload lands on the rods, never on
                        // face-to-face plastic
hub_bolt_stem_x  = 10;  // M5 clamp bolts: two flanking the shaft groove
hub_bolt_beam_x  = 25;  // ... two under the beam, outboard ...
hub_bolt_beam_z  = 34;  // ... plus one through the center web at arm
                        // height; geometry_check verifies every wall
hub_peg_x        = 30;  // registration pegs, so the bolts never carry
hub_peg_z        = 32;  // the job of aligning the halves
hub_peg_d        = 4;

// --- Hub sandwich (hub_shell.scad, THE hub; print TWO of the one
//     part): the tri's shell hub sized for two arms. Two identical
//     thin half-shells cradle the arms in half-round seats, arms
//     butted against the boss circle and standing proud of the
//     mating faces by half the clamp gap, so the shells never
//     touch; two M8 fender washers press the sandwich together
//     from either end, clamped by M8 nylocs on the shaft's
//     die-threaded top end. Full-length seats bear kindly on the
//     arms and nothing can rattle; the webs put a little plastic
//     in the clamp path, so the M8 nuts join the seasonal
//     re-torque round. About 80 g lighter than the clamshell plus
//     its M5 hardware, at the price of the one rod prep in the
//     build (a hand die on the shaft top, still no drilling) and
//     an arm station about 30 mm lower on the same shaft ---
hub_shell_d      = 50;  // seats run boss to rim: 18 mm of bearing
                        // per arm for horizontal storm bending
hub_shell_h      = 6;   // one half-shell: the half-seat (arm_snug_d/2
                        // minus half the clamp gap, cut in the scad)
                        // plus the web under it (geometry_check
                        // gates the web that remains)
hub_shell_boss_d = 14;  // arm butt circle around the free bore
hub_shaft_thread = 35;  // M8x1.25 die length on the shaft top: the
                        // nut-washer-sandwich-washer-nut stack plus lead

// --- M3 hardware (collar and cap clamps: each is a wide slit clamp
//     closed by TWO bolts crossing the slit — friction on the rod, but
//     spread over a long grip and generous bolt preload; nothing is
//     drilled into any rod, and every joint stays re-adjustable.
//     Tradeoff: printed clamps relax over time, re-torque seasonally) ---
m3_clear_d    = 3.4;
m3_nut_af     = 5.8;  // nut across flats, incl. pocket clearance
m3_locknut_t  = 4.4;  // nyloc nut height, incl. pocket clearance
m3_head_d     = 6.4;

// --- M5 hardware (hub clamshell VARIANT only: the clamp preload
//     lives or dies on washer bearing area and survivable
//     hand-torque, and M5 wins both; heads and nylocs sit on the
//     flat faces with wide washers, so only the clearance bore is
//     modeled) ---
m5_clear_d    = 5.5;

// --- M8 hardware (the washer-jaw hubs: hub_shell.scad, the hub,
//     and the tri variant's hubs, clamped by nylocs on the
//     die-threaded shaft top with fender washers as the jaws) ---
m8_nut_af     = 13.4;  // nyloc across flats, incl. drawing clearance
m8_nut_t      = 8;
m8_washer_od  = 30;    // fender washer: the clamp jaw, gripping each
m8_washer_t   = 1.5;   // rod from the boss circle outward

// --- PTFE washer (bought, TWO of them: the vane's thrust seat. The
//     sleeve end rides it directly on the tip bracket's flat top;
//     the whole self-start friction lives on this face, and PTFE
//     beats any printed seat. Also the sleeve's only lift over the
//     bracket top, so the flag swings this far above the plastic) ---
ptfe_washer_od = 14;
ptfe_washer_id = 8.2;  // spins free on the 8 mm stub
ptfe_washer_t  = 1;

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
vane_reach      = 130; // hinge axis to the flag's outer tip,
                       // horizontal in use; shortened from 150 when
                       // the arch went up instead of out. The panel
                       // has no height param: it spans the sleeve,
                       // runs flat for vane_shoulder_w past it,
                       // rises vane_arch_h in a quarter circle to
                       // the arch peak, then sweeps down to the
                       // bottom outer tip at this reach
vane_t          = 2;   // field finding: catching wind is easy, the
                       // low-energy re-arm is the fight, so the flag
                       // is as light as the storm gates allow: a
                       // bare skin, no stiffening rim (the rim cost
                       // 5 g and a quarter of the hinge inertia;
                       // the accepted risk is slow creep-curl in
                       // the sun — watch the flags for curl, and if
                       // it shows, bring back a slim rim on the
                       // arch edge)
vane_swing_deg  = 90;  // free swing between the driven stop and the
                       // notch's far wall. Field feel at 120 was a
                       // flag that re-armed late: the swing-back
                       // transit eats rotor travel that scales with
                       // the swing while the driven-stop window is
                       // 180 minus the swing (performance_check
                       // prints the re-arm numbers). Tuned via the
                       // cap's wedge width ONLY: keep swing +
                       // stop_wedge_deg at 150 and the sleeve notch
                       // and the vanes stay exactly as printed -- a
                       // different swing is a reprint of two small
                       // caps, nothing else
vane_shoulder_w = 20;  // the flat shoulder at the sleeve top before
                       // the arch springs: everything above the
                       // sleeve top sits at least this far out, so
                       // the cap's bolt hardware clears the flag at
                       // ANY cap angle (geometry_check gates the
                       // radius). The arch trades outboard area for
                       // a low-inertia return swing: the re-arm,
                       // not the catch, is the fight
vane_arch_h     = 30;  // the arch peak above the sleeve top: a
                       // quarter-circle rise of this radius off the
                       // shoulder, then the ellipse sweep down to
                       // the tip. Height is free area for the swing
                       // mechanics (only the spread over REACH
                       // enters the hinge integrals), so the raised
                       // arch buys back fold moment near the hinge
                       // without buying back tip inertia

// --- Stop cap (stub tip: retains the vane and carries THE stop
//     wedge, the vane's only stop; a wide dual-bolt slit clamp on
//     the rod end, so the driven-stop angle is set by rotating the
//     cap and re-set for testing by loosening two bolts) ---
cap_d          = 22;   // matches the sleeve OD; big enough to carry
                       // the wedge (stop_wedge_ro) and a real clamp,
                       // and the flag's cut-away corner keeps all of
                       // it clear of the fold at any angle
                       // (geometry_check gates the air)
cap_t          = 20;
cap_bore_depth = 18;
cap_slit_deg   = -90;  // slit and clamp bolt direction, degrees around
                       // the cap axis from the wedge center: off the
                       // wedge base so it stays solid. Since the flag's
                       // top inner corner was cut away (vane_shoulder_w)
                       // the folding flag never enters the cap's
                       // airspace at all, so the bolt hardware is safe
                       // at ANY cap angle and the slit direction is
                       // free (geometry_check gates the shoulder
                       // radius, not a slit band)

// --- Tip bracket (the clamshell knuckle at each arm tip that turns
//     the hinge vertical; TWO half designs, print two of each: the
//     PEG half and the PLAIN half with the sockets. The assembled
//     bracket rotated 180 about the stub serves the other arm). Both
//     rod axes lie in the split plane, so the halves close over arm
//     and stub like the hub shells close over the arms, bolted with M3x25s
//     and small washers under the heads; the nylocs sit captive in
//     hex pockets in the plain half, so tightening is a screwdriver
//     on the head side, no wrench. The stub groove runs through with
//     a funnel mouth at the top face, so the stub feeds in from
//     above once the clamshell has closed on the arm; the top is
//     otherwise FLAT, and the stub stack is just the bought PTFE
//     washer, the sleeve and the end cap. (The keyed stop ring and
//     its pocket survive as the tri variant's bracket option; the
//     dual's stop is the cap wedge alone.) The joint rides 620 mm
//     out on the arm, so it is sized for weight: M3 preload is
//     plenty for a clamp whose only friction duty is gust torsion,
//     and the width stays 24 only because the tri's ring pocket
//     needs side walls; the slimming is in height and length ---
bracket_w        = 24;  // clamshell thickness across the split
bracket_h        = 24;  // height; also the stub clamp's grip length
bracket_len      = 50;  // along the arm
bracket_arm_grip = 22;  // blind arm groove depth
bracket_stub_x   = 36;  // stub axis from the bracket's inboard face
bracket_bolt_dz  = 8;   // arm-clamp M3s at mid-grip, this far above
                        // and below the arm axis
bracket_bolt_dx  = 8;   // stub-clamp M3s at mid-height, this far
                        // inboard and outboard of the stub axis
bracket_peg_x    = 18;  // the two registration pegs (peg half), this
bracket_peg_dz   = 8;   // far above and below the arm axis, inboard
                        // of the tri's ring pocket
bracket_clamp_gap = 0.8; // total gap between the closed halves, hub
                         // rule: bolt preload lands on the rods,
                         // never on face-to-face plastic
stub_lead_in     = 1.5; // funnel mouth at the stub groove's top
                        // entrance, so the rod finds a line-to-line
                        // groove blind; the PTFE washer must seat on
                        // the flat ring OUTSIDE this mouth
                        // (geometry_check gates the annulus)

// --- Stop ring (TRI VARIANT ONLY, cad/tri/tri_stop_ring.scad): a
//     D-footed disc trapped in the bracket's matching pocket when
//     the clamshell closes, carrying the keyed stop fin — in the
//     tri the fin is the only stop and the angle is baked in. The
//     dual deleted it: its stop is the cap wedge alone, and its
//     thrust seat is the bought PTFE washer on the bracket's flat
//     top (lower friction than any printed seat, and one less part
//     to print and wear). The dimensions stay here because the
//     bracket's pocket option and the ring must agree ---
ring_foot_d    = 20;   // the D foot the clamshell traps
ring_foot_t    = 3;    // foot thickness = pocket depth, foot flush
ring_flat_x    = 7;    // the D flat, outboard side, keys the angle
ring_boss_d    = 10;   // the ring's thrust seat, narrowed to the
                       // bore edge: the tri's self-start wind scales
                       // with the sqrt of this contact radius. Only
                       // the ring uses it; collar_boss_d stays the
                       // bearing-race boss

// --- Stop wedge (on the end cap, set at assembly to any angle; it
//     rides the notch in the vane sleeve's top end and its flat
//     radial faces land flush on the notch walls, so the stop is a
//     face contact — lib/stop_wedge.scad. The same profile is the
//     tri variant's ring fin) ---
stop_wedge_deg = 60;   // angular thickness, also the swing tuning
                       // knob (see vane_swing_deg): the notch arc is
                       // swing + this. Sized so ONE wedge takes the
                       // full stop clack in shear with margin now
                       // that the ring fin no longer shares the
                       // impact (performance_check gates it; 40 sat
                       // right on the limit)
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
