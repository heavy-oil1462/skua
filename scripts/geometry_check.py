#!/usr/bin/env python3
"""Geometry sanity gate for Skua, from the shared parameters
(cad/design_params.scad via scripts/design_params.py).

Recomputes the assembly's stack-up — the same relations
cad/main_assembly.scad draws — and fails if any clearance, engagement,
or printable size goes bad. regen_all.py runs this as a gate, so a
parameter edit that silently sinks the vanes into the plank or starves
a socket of engagement cannot merge.

The rotor works by swing asymmetry: each vane swings vane_swing_deg
between the stop wedges and their notches (end cap wedge outboard, arm
collar wedge inboard, sharing the impact on flat faces), folding flat
one way and presenting its full face the other. The checks keep that
mechanism real: the wedges must actually reach the notches, and the
notch must not eat the whole sleeve wall.

Exit 1 on any failure.
"""

import math
import sys

from design_params import PARAMS as P


def check(ok_list, good, label, detail):
    ok_list.append(good)
    print(f"[{'ok' if good else 'FAIL'}] {label}: {detail}")


def main():
    ok = []

    # --- fits are ordered: free spins, snug grips, both over the rod ---
    check(ok, P["rod_d"] <= P["rod_snug_d"] < P["rod_free_d"],
          "rod fits", f"rod {P['rod_d']} <= snug {P['rod_snug_d']} < free {P['rod_free_d']}")
    check(ok, P["bearing_od"] - 0.5 <= P["bearing_press_d"] <= P["bearing_od"] + 0.1,
          "bearing press fit",
          f"pocket {P['bearing_press_d']} within [{P['bearing_od'] - 0.5}, {P['bearing_od'] + 0.1}]")

    # --- base tower: two separated bearings, shoulders on the right races
    #     (the bottom pocket sits base_cavity_h up, above the retainer
    #     cavity) ---
    pocket = P["bearing_w"] + P["pocket_recess"]
    spacing = (P["tower_h"] - pocket) - (P["base_cavity_h"] + pocket)
    check(ok, spacing >= 40, "bearing spacing",
          f"{spacing:.1f} mm between races (>= 40 to resist rotor wobble)")
    check(ok, P["bearing_inner_shoulder_d"] + 2 <= P["tower_bore_d"] <= P["bearing_od"] - 2,
          "pocket shoulder",
          f"bore {P['tower_bore_d']} presses outer race only "
          f"(inner shoulder {P['bearing_inner_shoulder_d']}, OD {P['bearing_od']})")
    check(ok, P["collar_boss_d"] <= P["bearing_inner_shoulder_d"],
          "thrust collar boss",
          f"boss {P['collar_boss_d']} rides inside the {P['bearing_inner_shoulder_d']} inner shoulder")

    # --- uplift retainer: single-bolt collar under the bottom bearing,
    #     boss up with running clearance, inside the base cavity;
    #     loaded only when something unloads the rotor (wave slam,
    #     gust), and then only through the bottom bearing's races.
    #     Clamped at the bench flush with the tip; the gap is gauged
    #     at the thrust collar, so it never depends on cavity access ---
    check(ok, 0.5 <= P["retainer_gap"] <= 2, "retainer running clearance",
          f"{P['retainer_gap']} mm between boss and bottom inner race"
          " (0.5 .. 2: never loaded in normal running, catches early)")
    retainer_bottom = (P["base_cavity_h"] + P["pocket_recess"]
                       - P["retainer_gap"] - P["collar_boss_h"]
                       - P["retainer_w"])
    check(ok, abs(retainer_bottom - P["shaft_tip_h"]) < 1e-9,
          "retainer flush with the tip",
          f"resting height {retainer_bottom:.1f} equals shaft_tip_h"
          f" {P['shaft_tip_h']} (the bench clamps them flush, so the"
          " tip height is set by the cavity stack, not the rod cut)")
    check(ok, P["shaft_tip_h"] >= 2, "shaft tip clears the plank",
          f"tip rides {P['shaft_tip_h']} mm above the plank"
          " (>= 2: nothing rotating touches wood)")
    check(ok, P["base_cavity_d"] >= P["collar_od"] + 4, "cavity width",
          f"cavity {P['base_cavity_d']} around retainer {P['collar_od']}"
          " (>= 4 mm total clearance, nothing rotating touches the base)")
    nut_pocket = P["m3_nut_af"] / math.cos(math.radians(30))
    check(ok, P["retainer_w"] >= nut_pocket + 1, "retainer bolt fits",
          f"{P['retainer_w']} mm of width around the {nut_pocket:.1f} mm"
          " nut pocket (>= 1 mm of wall; the sanctioned narrow clamp)")

    # --- hub walls around the grooves (clamshell: plain round grooves,
    #     printed open-face-up, so no teardrop crown anywhere here) ---
    web = (P["hub_arm_z"] - P["rod_snug_d"] / 2) - P["hub_shaft_socket"]
    check(ok, web >= 3, "hub shaft/arm web", f"{web:.1f} mm between the sockets (>= 3)")
    peak = P["hub_arm_z"] + P["rod_snug_d"] / 2
    check(ok, P["hub_h"] - peak >= 2, "hub top wall",
          f"{P['hub_h'] - peak:.1f} mm above the arm groove (>= 2)")
    check(ok, P["hub_len"] - 2 * P["hub_arm_socket"] >= 8, "hub center web",
          f"{P['hub_len'] - 2 * P['hub_arm_socket']:.1f} mm between the arm sockets (>= 8)")
    beam_wall = (P["hub_arm_z"] - P["rod_snug_d"] / 2) - P["hub_beam_z"]
    check(ok, beam_wall >= 3, "hub T beam under the arm bores",
          f"{beam_wall:.1f} mm of beam below the bore (>= 3)")
    stem_wall = (P["hub_stem_w"] - P["rod_snug_d"]) / 2
    check(ok, stem_wall >= 4, "hub T stem around the shaft socket",
          f"{stem_wall:.1f} mm wall each side (>= 4)")

    # --- hub clamshell: every M5 clamp bolt and peg keeps its walls ---
    r = P["m5_clear_d"] / 2
    center_web = P["hub_len"] / 2 - P["hub_arm_socket"] - r
    check(ok, center_web >= 2, "hub center bolt clears the arm grooves",
          f"{center_web:.1f} mm to each socket end (>= 2)")
    stem_in = P["hub_bolt_stem_x"] - r - P["rod_snug_d"] / 2
    stem_out = P["hub_stem_w"] / 2 - P["hub_bolt_stem_x"] - r
    check(ok, min(stem_in, stem_out) >= 2, "hub stem bolts",
          f"{stem_in:.1f} mm to the shaft groove, {stem_out:.1f} mm to the"
          " stem edge (>= 2)")
    beam_up = (P["hub_arm_z"] - P["rod_snug_d"] / 2) - (P["hub_bolt_beam_z"] + r)
    beam_dn = (P["hub_bolt_beam_z"] - r) - P["hub_beam_z"]
    check(ok, min(beam_up, beam_dn) >= 2, "hub beam bolts",
          f"{beam_up:.1f} mm to the arm groove, {beam_dn:.1f} mm to the"
          " beam underside (>= 2)")
    peg_up = (P["hub_arm_z"] - P["rod_snug_d"] / 2) - (P["hub_peg_z"] + P["hub_peg_d"] / 2)
    peg_out = P["hub_len"] / 2 - P["hub_peg_x"] - P["hub_peg_d"] / 2
    check(ok, min(peg_up, peg_out) >= 1.5, "hub registration pegs",
          f"{peg_up:.1f} mm to the arm groove, {peg_out:.1f} mm to the end"
          " face (>= 1.5)")
    check(ok, 0.4 <= P["hub_clamp_gap"] <= 2, "hub clamp gap",
          f"{P['hub_clamp_gap']} mm total: rods stand proud, bolts clamp"
          " rods not plastic (0.4 .. 2)")

    # --- vertical stack: shaft and collar working room ---
    shaft_top = P["shaft_tip_h"] + P["shaft_length"]
    hub_bottom = shaft_top - P["hub_shaft_socket"]
    arm_z = hub_bottom + P["hub_arm_z"]
    collar_room = hub_bottom - (P["tower_h"] - P["pocket_recess"]
                                + P["collar_w"] + P["collar_boss_h"])
    check(ok, collar_room >= 5, "shaft length",
          f"{collar_room:.1f} mm open shaft between thrust collar and hub (>= 5)")

    # --- along the arm: hub socket, clear span, tip bracket ---
    arm_tip = P["hub_len"] / 2 - P["hub_arm_socket"] + P["arm_length"]
    bracket_x = arm_tip - P["bracket_arm_grip"]  # bracket inboard face
    stub_x = bracket_x + P["bracket_stub_x"]     # hinge axis radius
    check(ok, P["bracket_arm_grip"] >= 14 and P["bracket_h"] >= 14,
          "bracket clamps stay wide",
          f"arm groove {P['bracket_arm_grip']} mm, stub grip"
          f" {P['bracket_h']} mm (>= 14: friction-only joints live on"
          " grip length)")
    arm_wall = ((P["bracket_stub_x"] - P["rod_snug_d"] / 2)
                - P["bracket_arm_grip"])
    stub_wall = P["bracket_len"] - (P["bracket_stub_x"] + P["rod_snug_d"] / 2)
    check(ok, arm_wall >= 4 and stub_wall >= 3, "bracket groove walls",
          f"{arm_wall:.1f} mm between arm groove and stub groove,"
          f" {stub_wall:.1f} mm outboard of the stub (>= 4 / >= 3)")

    # --- bracket clamshell: M3 bolts and the pegs keep their walls,
    #     the halves keep their gap (hub rules) ---
    m3r = P["m3_clear_d"] / 2
    zc = P["bracket_h"] / 2
    bolt_edge = zc - P["bracket_bolt_dz"] - m3r
    bolt_groove = P["bracket_bolt_dz"] - m3r - P["rod_snug_d"] / 2
    check(ok, min(bolt_edge, bolt_groove) >= 2, "bracket arm bolts",
          f"{bolt_edge:.2f} mm to the faces, {bolt_groove:.2f} mm to"
          " the arm groove (>= 2)")
    sb_groove = P["bracket_bolt_dx"] - m3r - P["rod_snug_d"] / 2
    sb_socket = (P["bracket_stub_x"] - P["bracket_bolt_dx"] - m3r
                 - P["bracket_arm_grip"])
    sb_end = (P["bracket_len"] - P["bracket_stub_x"]
              - P["bracket_bolt_dx"] - m3r)
    check(ok, min(sb_groove, sb_socket, sb_end) >= 2, "bracket stub bolts",
          f"{sb_groove:.2f} mm to the stub groove, {sb_socket:.2f} mm to"
          f" the arm groove end, {sb_end:.2f} mm to the end face (>= 2)")
    peg_groove = P["bracket_peg_dz"] - P["rod_snug_d"] / 2 - 2
    peg_edge = zc - P["bracket_peg_dz"] - 2
    check(ok, min(peg_groove, peg_edge) >= 1.5, "bracket pegs",
          f"{peg_groove:.1f} mm to the arm groove, {peg_edge:.1f} mm to"
          " the faces (>= 1.5)")
    check(ok, 0.4 <= P["bracket_clamp_gap"] <= 2, "bracket clamp gap",
          f"{P['bracket_clamp_gap']} mm total: rods stand proud, bolts"
          " clamp rods not plastic (0.4 .. 2)")
    # --- stop ring: D foot trapped in the bracket pocket, keyed by
    #     the flat; the fin and boss print as vertical prisms on the
    #     ring's own back, so nothing here needs support ---
    pocket_r = P["ring_foot_d"] / 2 + P["fit_tol"]
    check(ok, P["bracket_w"] / 2 - pocket_r >= 1.5, "ring pocket side walls",
          f"{P['bracket_w'] / 2 - pocket_r:.1f} mm outside the pocket"
          " (>= 1.5)")
    check(ok, P["bracket_len"] - P["bracket_stub_x"] - pocket_r >= 2,
          "ring pocket end wall",
          f"{P['bracket_len'] - P['bracket_stub_x'] - pocket_r:.1f} mm to"
          " the outboard face (>= 2)")
    pocket_floor = P["bracket_h"] - P["ring_foot_t"]
    groove_top = P["bracket_h"] / 2 + P["rod_snug_d"] / 2
    check(ok, pocket_floor - groove_top >= 3, "ring pocket floor",
          f"{pocket_floor - groove_top:.1f} mm above the arm groove (>= 3)")
    check(ok, P["bracket_stub_x"] - pocket_r
              - (P["bracket_peg_x"] + 2) >= 1.5, "pegs clear the pocket",
          f"{P['bracket_stub_x'] - pocket_r - P['bracket_peg_x'] - 2:.1f}"
          " mm between the pegs and the pocket wall (>= 1.5)")
    check(ok, 2 <= P["ring_flat_x"] <= P["ring_foot_d"] / 2 - 2,
          "ring D flat keys",
          f"flat at {P['ring_flat_x']} mm, foot radius"
          f" {P['ring_foot_d'] / 2} (a real flat, one orientation only)")
    check(ok, P["stop_wedge_ro"] - P["ring_foot_d"] / 2 <= 1,
          "ring fin sits on its foot",
          f"fin overhangs the foot {P['stop_wedge_ro'] - P['ring_foot_d'] / 2:.1f} mm"
          " (<= 1: lands on the bracket top, flush with the foot)")

    # --- up the stub: bracket boss, sleeve, play, cap all fit ---
    boss_top = P["bracket_h"] / 2 + P["collar_boss_h"]
    sleeve_top = boss_top + P["vane_sleeve_len"]    # heights above arm axis
    cap_face_z = sleeve_top + 1                     # 1 mm running play
    stub_tip = P["stub_length"] - P["bracket_h"] / 2
    cap_slack = (cap_face_z + P["cap_bore_depth"]) - stub_tip
    check(ok, 1 <= cap_slack <= 3, "stub length",
          f"tip stops {cap_slack:.1f} mm shy of the cap bore floor"
          " (1 .. 3: no chain depends on the rod cut)")
    cap_engage = stub_tip - cap_face_z
    check(ok, cap_engage >= 14, "cap grip on the stub",
          f"{cap_engage:.1f} mm (>= 14: friction-only joints live on"
          " grip length; the cap also retains the vane)")
    edge = math.hypot(P["vane_sleeve_od"] / 2,
                      P["vane_sleeve_od"] / 2 - P["vane_rim_h"])
    check(ok, edge >= P["cap_d"] / 2 + 1, "flag clears the cap",
          f"rim corner {edge:.1f} mm off the hinge axis, the cap"
          f" reaches {P['cap_d'] / 2} (>= 1 mm air; the near-edge"
          " rim's inner corner, not the panel face, passes closest)")
    check(ok, P["collar_boss_h"] >= 2, "panel clears the bracket",
          f"the boss lifts sleeve and panel {P['collar_boss_h']} mm"
          " above the bracket top (>= 2: the flag swings over it)")
    check(ok, P["vane_width"] > P["vane_sleeve_len"] + P["cap_t"],
          "panel overhangs the cap",
          f"panel {P['vane_width']} mm tall on a {P['vane_sleeve_len']} mm"
          f" sleeve (> {P['vane_sleeve_len'] + P['cap_t']}: the flag, not"
          " the hardware, is the face)")

    # --- the swing stops: wedges inside the sleeve wall, notch leaves a
    #     stop, and both carriers (cap face, collar face) contain them ---
    check(ok, P["stop_wedge_ri"] >= P["rod_d"] / 2 + 0.2,
          "stop wedge clears the rod",
          f"inner radius {P['stop_wedge_ri']} vs rod r {P['rod_d'] / 2} + 0.2")
    overlap = (min(P["vane_sleeve_od"] / 2, P["stop_wedge_ro"])
               - max(P["rod_free_d"] / 2, P["stop_wedge_ri"]))
    check(ok, overlap >= 1.5, "stop wedge meets the sleeve wall",
          f"{overlap:.2f} mm radial overlap with the notch shoulders (>= 1.5)")
    check(ok, P["stop_wedge_ro"] <= P["cap_d"] / 2, "stop wedge fits the cap",
          f"outer radius {P['stop_wedge_ro']} inside cap r {P['cap_d'] / 2}")
    notch = P["vane_swing_deg"] + P["ring_wedge_deg"]
    check(ok, notch <= 200, "stop notch",
          f"{notch:.0f} deg cut from the sleeve end, sized for the"
          " stop ring's fin (<= 200, the rest is the stop); the full"
          f" {P['vane_swing_deg']} deg of swing stays free")
    engage = P["stop_wedge_len"] - 1
    check(ok, engage >= 3, "wedge engagement",
          f"{engage:.1f} mm of wedge inside each notch (>= 3)")

    # --- cap slit placement: the nut corners and bolt tips are the
    #     only things proud of the cap cylinder, and the folding
    #     flag's near edge sweeps a band of the cap's airspace (the
    #     swing arc plus the 45 deg the rim corner trails the panel
    #     direction; 45 exactly, because the panel's outer face is
    #     tangent to the sleeve). Angles are cap-local, wedge center
    #     at 0: at the driven stop the wedge's contact wall (+w/2)
    #     lands on the notch wall, the notch is centered on the panel
    #     normal (vane.scad's pie, panel direction + 90), and folding
    #     carries the panel toward +. The slit hardware must clear
    #     the whole swept band ---
    w = P["stop_wedge_deg"]
    panel0 = w / 2 - notch / 2 + 90    # panel direction at the stop
    forbid = (panel0, panel0 + P["vane_swing_deg"] + 45)
    bolt_x = (P["rod_snug_d"] / 2 + P["cap_d"] / 2) / 2
    nut_x = bolt_x + P["m3_nut_af"] / math.cos(math.radians(30)) / 2
    prot = (P["cap_slit_deg"]
            + math.degrees(math.atan2(P["rod_snug_d"] / 2, nut_x)),
            P["cap_slit_deg"]
            + math.degrees(math.atan2(P["cap_d"] / 2 + 2, bolt_x)))
    gap_after = (prot[0] - forbid[1]) % 360   # flag band up to hardware
    gap_before = (forbid[0] - prot[1]) % 360  # hardware up to flag band
    disjoint = abs(gap_after + gap_before + (forbid[1] - forbid[0])
                   + (prot[1] - prot[0]) - 360) < 1e-6
    check(ok, disjoint and min(gap_after, gap_before) >= 15,
          "cap slit clears the flag",
          f"bolt hardware spans {prot[0]:.0f}..{prot[1]:.0f} deg off the"
          f" wedge, the flag sweeps {forbid[0]:.0f}..{forbid[1]:.0f}"
          f" ({min(gap_after, gap_before):.0f} deg clear, >= 15: the cap"
          " is set by hand, leave the angle slop)")
    face = overlap * engage
    print(f"[info] each stop face contact: {overlap:.1f} x {engage:.1f} mm"
          f" = {face:.0f} mm2, two faces per stop")

    # --- printability ---
    for name, size in (("base", P["base_d"]),
                       ("vane panel", P["vane_width"]),
                       ("vane reach", P["vane_reach"] + P["vane_sleeve_od"] / 2)):
        check(ok, size <= P["printer_bed"], f"{name} fits the bed",
              f"{size:.0f} mm <= {P['printer_bed']} mm")

    width = P["hub_len"] + 2 * (P["arm_length"] - P["hub_arm_socket"])
    sweep = 2 * (stub_x + P["vane_reach"])
    print(f"[info] rotor width across the arms: {width:.0f} mm"
          f" ({width / 10:.0f} cm); flags at the driven stop sweep"
          f" {sweep:.0f} mm")
    print(f"[info] arm axis rides {arm_z:.0f} mm above the plank; flag"
          f" tops reach {arm_z + boss_top + P['vane_width']:.0f} mm")

    return 0 if all(ok) else 1


if __name__ == "__main__":
    sys.exit(main())
