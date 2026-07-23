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

    # --- vertical stack: shaft, collar working room, vane ground clearance ---
    shaft_top = P["shaft_tip_h"] + P["shaft_length"]
    hub_bottom = shaft_top - P["hub_shaft_socket"]
    arm_z = hub_bottom + P["hub_arm_z"]
    collar_room = hub_bottom - (P["tower_h"] - P["pocket_recess"]
                                + P["collar_w"] + P["collar_boss_h"])
    check(ok, collar_room >= 5, "shaft length",
          f"{collar_room:.1f} mm open shaft between thrust collar and hub (>= 5)")
    ground = arm_z - P["vane_drop"]
    check(ok, ground >= 50, "vane ground clearance",
          f"hanging vane bottom {ground:.1f} mm above the plank (>= 50)")

    # --- along the arm: hub socket, collar, sleeve, gap, cap all fit ---
    arm_tip = P["hub_len"] / 2 - P["hub_arm_socket"] + P["arm_length"]
    cap_face = arm_tip + 4 - P["cap_t"]          # rod 2 mm shy of the bore floor
    cap_engage = P["cap_bore_depth"] - 2
    sleeve_end = cap_face - 1
    sleeve_start = sleeve_end - P["vane_sleeve_len"]
    collar_start = sleeve_start - P["collar_boss_h"] - P["collar_w"]
    check(ok, cap_engage >= 5, "cap grip on the rod", f"{cap_engage:.1f} mm (>= 5)")
    check(ok, P["collar_w"] >= 14 and P["cap_bore_depth"] >= 14,
          "tip clamps stay wide",
          f"collar {P['collar_w']} mm, cap bore {P['cap_bore_depth']} mm of"
          " grip (>= 14: friction-only joints live on grip length)")
    check(ok, collar_start >= P["hub_len"] / 2 + 5, "arm length",
          f"collar starts {collar_start:.0f} mm out, hub face at {P['hub_len'] / 2:.0f}"
          " (5 mm room to slide)")

    # --- low-wind self-start: the balance panel above the arm axis
    #     cancels most of the hanging panel's gravity moment, so light
    #     wind can fold the free vane instead of both vanes hanging
    #     and catching the wind equally. The cancellation must stay
    #     partial: hanging is the stop-setting reference (step 5) ---
    sr = P["vane_sleeve_od"] / 2
    rim_extra = P["vane_rim_w"] * (P["vane_rim_h"] - P["vane_t"])

    def gravity_moment(reach):
        # per-thickness areal moments about the arm axis: the panel
        # sheet, the two side rims, and the edge rim (extra material
        # only; the webs at the sleeve are mirrored and cancel)
        panel = P["vane_width"] * P["vane_t"] * (reach**2 - sr**2) / 2
        sides = 2 * rim_extra * (reach**2 - sr**2) / 2
        edge = rim_extra * P["vane_width"] * (reach - P["vane_rim_w"] / 2)
        return panel + sides + edge

    balance = gravity_moment(P["vane_rise"]) / gravity_moment(P["vane_drop"])
    check(ok, 0.6 <= balance <= 0.85, "vane balance",
          f"rise panel cancels {balance:.0%} of the hanging moment"
          " (0.6 .. 0.85: folds in light wind, hanging still defined)")

    # --- the swing stops: wedges inside the sleeve wall, notch leaves a
    #     stop, and both carriers (cap face, collar face) contain them ---
    check(ok, P["stop_wedge_ri"] >= P["rod_d"] / 2 + 0.2,
          "stop wedge clears the rod",
          f"inner radius {P['stop_wedge_ri']} vs rod r {P['rod_d'] / 2} + 0.2")
    overlap = (min(P["vane_sleeve_od"] / 2, P["stop_wedge_ro"])
               - max(P["rod_free_d"] / 2, P["stop_wedge_ri"]))
    check(ok, overlap >= 1.5, "stop wedge meets the sleeve wall",
          f"{overlap:.2f} mm radial overlap with the notch shoulders (>= 1.5)")
    carrier = min(P["cap_d"], P["collar_od"]) / 2
    check(ok, P["stop_wedge_ro"] <= carrier, "stop wedge fits its carriers",
          f"outer radius {P['stop_wedge_ro']} inside cap r {P['cap_d'] / 2}"
          f" and collar r {P['collar_od'] / 2}")
    notch = P["vane_swing_deg"] + P["stop_wedge_deg"]
    check(ok, notch <= 200, "stop notch",
          f"{notch:.0f} deg cut from the sleeve end (<= 200, the rest is the stop)")
    engage = P["stop_wedge_len"] - 1
    check(ok, engage >= 3, "wedge engagement",
          f"{engage:.1f} mm of wedge inside each notch (>= 3)")
    face = overlap * engage
    print(f"[info] each stop face contact: {overlap:.1f} x {engage:.1f} mm"
          f" = {face:.0f} mm2, two faces per stop")

    # --- printability ---
    for name, size in (("base", P["base_d"]),
                       ("vane width", P["vane_width"]),
                       ("vane height", P["vane_drop"] + P["vane_rise"])):
        check(ok, size <= P["printer_bed"], f"{name} fits the bed",
              f"{size:.0f} mm <= {P['printer_bed']} mm")

    width = P["hub_len"] + 2 * (P["arm_length"] - P["hub_arm_socket"])
    print(f"[info] rotor width across the arms: {width:.0f} mm"
          f" ({width / 10:.0f} cm); vane tips sweep {2 * (arm_tip + 4):.0f} mm")
    print(f"[info] arm axis rides {arm_z:.0f} mm above the plank")

    return 0 if all(ok) else 1


if __name__ == "__main__":
    sys.exit(main())
