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

    # --- base tower: two separated bearings, shoulders on the right races ---
    pocket = P["bearing_w"] + P["pocket_recess"]
    spacing = P["tower_h"] - 2 * pocket
    check(ok, spacing >= 20, "bearing spacing",
          f"{spacing:.1f} mm between races (>= 20 to resist rotor wobble)")
    check(ok, P["bearing_inner_shoulder_d"] + 2 <= P["tower_bore_d"] <= P["bearing_od"] - 2,
          "pocket shoulder",
          f"bore {P['tower_bore_d']} presses outer race only "
          f"(inner shoulder {P['bearing_inner_shoulder_d']}, OD {P['bearing_od']})")
    check(ok, P["collar_boss_d"] <= P["bearing_inner_shoulder_d"],
          "thrust collar boss",
          f"boss {P['collar_boss_d']} rides inside the {P['bearing_inner_shoulder_d']} inner shoulder")

    # --- hub walls around the bores ---
    web = (P["hub_arm_z"] - P["rod_snug_d"] / 2) - P["hub_shaft_socket"]
    check(ok, web >= 3, "hub shaft/arm web", f"{web:.1f} mm between the sockets (>= 3)")
    peak = P["hub_arm_z"] + P["rod_snug_d"] / 2 * math.sqrt(2)  # teardrop crown
    check(ok, P["hub_h"] - peak >= 2, "hub top wall",
          f"{P['hub_h'] - peak:.1f} mm above the arm bore crown (>= 2)")
    check(ok, P["hub_len"] - 2 * P["hub_arm_socket"] >= 8, "hub center web",
          f"{P['hub_len'] - 2 * P['hub_arm_socket']:.1f} mm between the arm sockets (>= 8)")
    beam_wall = (P["hub_arm_z"] - P["rod_snug_d"] / 2) - P["hub_beam_z"]
    check(ok, beam_wall >= 3, "hub T beam under the arm bores",
          f"{beam_wall:.1f} mm of beam below the bore (>= 3)")
    stem_wall = (P["hub_stem_w"] - P["rod_snug_d"]) / 2
    check(ok, stem_wall >= 4, "hub T stem around the shaft socket",
          f"{stem_wall:.1f} mm wall each side (>= 4)")

    # --- vertical stack: shaft, collar working room, vane ground clearance ---
    shaft_top = P["shaft_bottom_gap"] + P["shaft_length"]
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
    bolt_edge = P["cap_bore_depth"] / 2 - 2
    check(ok, bolt_edge >= 2.5, "cap through-bolt edge distance",
          f"bolt sits {bolt_edge:.1f} mm from the rod end (>= 2.5)")
    check(ok, collar_start >= P["hub_len"] / 2 + 5, "arm length",
          f"collar starts {collar_start:.0f} mm out, hub face at {P['hub_len'] / 2:.0f}"
          " (5 mm room to slide)")

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
                       ("vane height", P["vane_drop"] + P["vane_sleeve_od"] / 2)):
        check(ok, size <= P["printer_bed"], f"{name} fits the bed",
              f"{size:.0f} mm <= {P['printer_bed']} mm")

    width = P["hub_len"] + 2 * (P["arm_length"] - P["hub_arm_socket"])
    print(f"[info] rotor width across the arms: {width:.0f} mm"
          f" ({width / 10:.0f} cm); vane tips sweep {2 * (arm_tip + 4):.0f} mm")
    print(f"[info] arm axis rides {arm_z:.0f} mm above the plank")

    return 0 if all(ok) else 1


if __name__ == "__main__":
    sys.exit(main())
