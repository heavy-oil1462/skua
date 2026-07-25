#!/usr/bin/env python3
"""Performance and loads gate for Skua, from the shared parameters
(cad/design_params.scad) and the committed STLs (part masses).

Answers the two product questions with numbers, and fails the build
when a change regresses them:

  1. At what wind does it spin?  The rotor self-starts when the free
     vane can weathervane (aero moment about the hinge beats the
     sleeve's thrust-face friction) and the driven vane's torque beats
     the parasitic drags.  Both are computed; the gate keeps the
     spin-up wind in light air and the parasitic-to-driving torque
     ratio low, so a change that adds drag or hinge load cannot merge
     silently.

  2. Does it survive a storm?  The worst credible load case is a
     LOCKED rotor (fouled line, ice) holding a vane face-on to the
     survival wind: a spinning rotor unloads itself by accelerating,
     a locked one cannot.  Every load path from the panel to the
     plank is checked at that case with a safety factor.

The model is deliberately quasi-static and order-of-magnitude honest:
flat-plate drag coefficients, friction clamp capacities from
hand-torque bolt preloads, a lumped dynamic factor for the stop
clack.  Constants below carry their rationale; they are analysis
assumptions, not shared CAD dimensions, so they live here and not in
design_params.scad.

Masses come from the committed stl/ files (ASCII STL, signed-volume
sum) at solid density.  Printed parts are lighter than solid, but
heavier is conservative in every check here (more hinge friction,
more bearing drag, more droop), so no infill factor is applied.

regen_all.py runs this as a gate after the STL stage, so CI holds the
line.  Exit 1 on any failure.
"""

import math
import re
import sys
from pathlib import Path

from design_params import PARAMS as P

STL_DIR = Path(__file__).resolve().parent.parent / "stl"

# --- air and materials -------------------------------------------------
RHO_AIR = 1.225        # kg/m3, sea level
RHO_ALU = 2700         # kg/m3
RHO_ASA = 1070         # kg/m3, solid (conservative for printed parts)
ALU_YIELD = 160e6      # Pa; hardware-store rod is 6060/6063-T5 class,
                       # not T6 — never assume the good alloy
ASA_YIELD = 40e6       # Pa tensile, conservative printed value
ASA_SHEAR = 24e6       # Pa, ~0.6 x tensile
E_ALU = 69e9           # Pa

# --- aerodynamics ------------------------------------------------------
CD_PLATE = 1.17        # finite flat plate, face-on
CD_EDGE = 1.2          # folded vane seen edge-on: panel edge plus rim
                       # ends, bluff, taken high (conservative drag)
V_SURVIVAL = 25.0      # m/s design storm at the mooring, rotor locked
V_LIGHT_AIR = 1.5      # m/s spin-up ceiling: the scarer must run in
                       # Beaufort 2, or it is a perch. Ratcheted down
                       # from 1.8 when the ring boss narrowed; never
                       # loosen it back

# --- joints and friction ----------------------------------------------
MU_HINGE = 0.35        # ASA sleeve end on ASA boss ring, dry thrust face
MU_CLAMP = 0.30        # printed clamp bore on aluminum rod
F_M3 = 800             # N preload per M3, hand-tight into printed part
F_M5 = 1200            # N preload per M5; both are limited by the
                       # plastic under the washer, not by the bolt
DYN_STOP = 5           # lumped dynamic factor: the stop clack versus
                       # the steady aero moment at the same wind
HARDWARE_KG = 0.06     # bolts, nuts, washers on the rotor, rough

# rotor parts and their print counts (masses from stl/, solid ASA)
ROTOR_PARTS = {"hub_front": 1, "hub_back": 1, "collar": 1, "retainer": 1,
               "bracket_peg_half": 2, "bracket_plain_half": 2,
               "stop_ring": 2, "end_cap": 2, "vane": 2}


def stl_volume_mm3(path):
    """Signed-volume sum over the facets of an ASCII STL."""
    verts = re.findall(r"vertex\s+(\S+)\s+(\S+)\s+(\S+)", path.read_text())
    tris = [tuple(map(float, v)) for v in verts]
    vol = 0.0
    for i in range(0, len(tris), 3):
        (ax, ay, az), (bx, by, bz), (cx, cy, cz) = tris[i:i + 3]
        vol += (ax * (by * cz - bz * cy) - ay * (bx * cz - bz * cx)
                + az * (bx * cy - by * cx)) / 6.0
    return abs(vol)


def check(ok_list, good, label, detail):
    ok_list.append(good)
    print(f"[{'ok' if good else 'FAIL'}] {label}: {detail}")


def main():
    ok = []
    mm = 1e-3  # params are mm; the model is SI

    # --- masses from the committed STLs and the rod stock --------------
    part_kg = {}
    for name in ROTOR_PARTS:
        f = STL_DIR / f"{name}.stl"
        if not f.exists():
            print(f"[FAIL] mass model: {f} missing — run regen_all first")
            return 1
        part_kg[name] = stl_volume_mm3(f) * 1e-9 * RHO_ASA
    rod_kg_m = RHO_ALU * math.pi * (P["rod_d"] * mm / 2) ** 2
    rods_kg = rod_kg_m * mm * (P["shaft_length"] + 2 * P["arm_length"]
                               + 2 * P["stub_length"])
    rotor_kg = (sum(part_kg[n] * c for n, c in ROTOR_PARTS.items())
                + rods_kg + HARDWARE_KG)
    vane_kg = part_kg["vane"]
    tip_kg = (vane_kg + part_kg["end_cap"] + part_kg["stop_ring"]
              + part_kg["bracket_peg_half"] + part_kg["bracket_plain_half"]
              + rod_kg_m * P["stub_length"] * mm + 0.01)
    print(f"[info] rotor {rotor_kg * 1000:.0f} g (vane {vane_kg * 1000:.0f} g,"
          f" tip stack {tip_kg * 1000:.0f} g each side, rods"
          f" {rods_kg * 1000:.0f} g)")

    # --- stations (same stack as geometry_check / main_assembly) -------
    sleeve_r = P["vane_sleeve_od"] / 2 * mm
    hinge_r = (P["hub_len"] / 2 - P["hub_arm_socket"] + P["arm_length"]
               - P["bracket_arm_grip"] + P["bracket_stub_x"]) * mm
    panel_w = (P["vane_reach"] * mm - sleeve_r)     # horizontal span
    panel_h = P["vane_width"] * mm                  # vertical span
    area = panel_w * panel_h                        # one flag face
    d_hinge = (P["vane_reach"] * mm + sleeve_r) / 2 # hinge to panel center
    r_drive = hinge_r + d_hinge                     # rotor axis to center
    area_edge = (P["vane_t"] * P["vane_width"]
                 + 3 * P["vane_rim_w"] * (P["vane_rim_h"] - P["vane_t"])) * mm * mm

    def q(v):
        return 0.5 * RHO_AIR * v * v

    # --- spin-up: the free vane must fold in light air ------------------
    # Sleeve weight rests on the stop ring's boss; that thrust face is
    # the hinge's whole friction.  The panel folds when the aero moment
    # about the hinge beats it.  mu times weight times seat radius is
    # the whole game: the seat radius is printed as narrow as it can
    # be, the weight is the vane, and mu is the ring's material.
    r_boss = (P["ring_boss_d"] + P["rod_free_d"]) / 4 * mm
    t_hinge = MU_HINGE * vane_kg * 9.81 * r_boss
    v_fold = math.sqrt(t_hinge / (CD_PLATE * 0.5 * RHO_AIR * area * d_hinge))

    # --- spin-up: net torque on a stationary rotor ----------------------
    # Reference pose, wind square on the driven flag.  Sleeves and
    # brackets sit at the same radius on both arms and cancel; what
    # opposes is the folded flag's edge drag and bearing friction.
    t_bearing = 0.0015 * rotor_kg * 9.81 * (P["rod_d"] / 2) * mm
    drive_coef = CD_PLATE * 0.5 * RHO_AIR * area * r_drive
    resist_coef = CD_EDGE * 0.5 * RHO_AIR * area_edge * hinge_r
    v_net = math.sqrt(t_bearing / (drive_coef - resist_coef))
    v_spin = max(v_fold, v_net)
    check(ok, v_spin <= V_LIGHT_AIR, "spins in light air",
          f"self-start at {v_spin:.2f} m/s (fold {v_fold:.2f}, torque"
          f" {v_net:.2f}; <= {V_LIGHT_AIR}: must run in Beaufort 2)")
    # the gated number is conservative (solid-density vane); the paths
    # below it are material, not geometry, so they are reported, not
    # designed in.  Weigh a printed vane to place the real machine.
    print(f"[info] self-start projections: real printed vane (~65"
          f" percent solid) ~{v_fold * math.sqrt(0.65):.2f} m/s; rings"
          f" in nylon (mu ~0.2) ~{v_fold * math.sqrt(0.2 / MU_HINGE):.2f};"
          " a thin PTFE washer on the boss (mu ~0.12)"
          f" ~{v_fold * math.sqrt(0.12 / MU_HINGE):.2f}")

    # The ratio treats the returning flag as fully trailed; with a
    # finite swing it also rides its trailing stop at some incidence
    # for part of the revolution, which this single-pose model cannot
    # see.  That is the cost side of a smaller swing; the re-arm info
    # below is the benefit side, and the water decides between rings.
    ratio = resist_coef / drive_coef
    check(ok, ratio <= 0.05, "parasitic drag stays small",
          f"parasitic/driving torque ratio {ratio:.3f} (<= 0.05, wind"
          " speed independent — the drag ratchet)")

    # quasi-static speed: relative wind balance between the driven and
    # the folded flag; a single-pose estimate, order of magnitude only
    k = math.sqrt(ratio)
    omega_per_v = (1 - k) / (r_drive + k * hinge_r)
    for v in (3.0, 8.0):
        rpm = omega_per_v * v * 60 / (2 * math.pi)
        print(f"[info] roughly {rpm:.0f} rpm at {v:.0f} m/s"
              f" ({omega_per_v * v * (hinge_r + P['vane_reach'] * mm):.1f}"
              " m/s flag tip speed)")

    # --- re-arm: after the trailing release the flag must swing all
    #     of vane_swing_deg back before the driven stop can drive,
    #     and the driven window is only 180 - swing degrees of rotor
    #     travel.  Transit from the flag's hinge inertia against half
    #     the face moment; the rotor angle it consumes is wind
    #     independent (transit ~ 1/v, rotor speed ~ v).  Rough, so
    #     info not gate: the swing angle is a stop-ring fin reprint,
    #     and the boat decides ---
    m_panel = RHO_ASA * panel_w * panel_h * P["vane_t"] * mm
    i_hinge = (m_panel * ((P["vane_reach"] * mm) ** 3 - sleeve_r ** 3)
               / (3 * panel_w))
    t_per_v = math.sqrt(2 * math.radians(P["vane_swing_deg"]) * i_hinge
                        / (0.5 * CD_PLATE * 0.5 * RHO_AIR * area * d_hinge))
    rearm = math.degrees(omega_per_v * t_per_v)
    window = 180 - P["vane_swing_deg"]
    print(f"[info] re-arm: the swing-back consumes ~{rearm:.0f} deg of"
          f" rotor travel against a {window:.0f} deg driven window"
          " (wind independent; at 120 deg swing this read ~120 vs 60,"
          " the flag chronically arrived late)")

    # --- survival: locked rotor, flag face-on at V_SURVIVAL -------------
    f_panel = CD_PLATE * q(V_SURVIVAL) * area
    print(f"[info] survival case: {f_panel:.1f} N on the flag at"
          f" {V_SURVIVAL:.0f} m/s, rotor locked")

    # arm bending where it leaves the hub (wind horizontal + weight
    # vertical, combined vectorially; the arm is the fuse of the machine)
    arm_free = P["arm_length"] * mm - P["hub_arm_socket"] * mm
    m_wind = f_panel * (r_drive - P["hub_len"] / 2 * mm)
    m_weight = 9.81 * (tip_kg * arm_free
                       + rod_kg_m * arm_free * arm_free / 2)
    m_arm = math.hypot(m_wind, m_weight)
    s_rod = math.pi * (P["rod_d"] * mm) ** 3 / 32
    sf_arm = ALU_YIELD / (m_arm / s_rod)
    check(ok, sf_arm >= 1.3, "arm survives the storm",
          f"{m_arm:.1f} N m at the hub, {m_arm / s_rod / 1e6:.0f} MPa in"
          f" the 8 mm rod, SF {sf_arm:.2f} vs T5 yield (>= 1.3)")

    # stub bending where it leaves the bracket grip
    lever_stub = (P["collar_boss_h"] + P["vane_width"] / 2) * mm
    sf_stub = ALU_YIELD / (f_panel * lever_stub / s_rod)
    check(ok, sf_stub >= 3, "stub survives the storm",
          f"{f_panel * lever_stub:.2f} N m at the bracket, SF"
          f" {sf_stub:.1f} (>= 3)")

    # panel root bending in the printed plastic
    s_panel = panel_h * (P["vane_t"] * mm) ** 2 / 6
    m_panel = f_panel * (d_hinge - sleeve_r - P["vane_rim_w"] * mm)
    sf_panel = ASA_YIELD / (m_panel / s_panel)
    check(ok, sf_panel >= 3, "panel root survives the storm",
          f"{m_panel:.2f} N m at the sleeve web, SF {sf_panel:.1f}"
          " (>= 3; the rod, not the flag, must be the fuse)")

    # the stop faces: steady aero moment about the hinge, times the
    # clack dynamic factor, all on ONE face (a badly set cap can leave
    # the ring's fin alone until the clamps are re-set)
    m_stop = f_panel * d_hinge
    r_c = (P["stop_wedge_ri"] + P["stop_wedge_ro"]) / 2 * mm
    face = ((min(P["vane_sleeve_od"] / 2, P["stop_wedge_ro"])
             - max(P["rod_free_d"] / 2, P["stop_wedge_ri"]))
            * (P["stop_wedge_len"] - 1)) * mm * mm
    f_face = m_stop * DYN_STOP / r_c
    sf_face = ASA_YIELD / (f_face / face)
    fin_base = ((P["stop_wedge_ro"] - P["stop_wedge_ri"])
                * math.radians(P["ring_wedge_deg"]) * r_c / mm) * mm * mm
    sf_fin = ASA_SHEAR / (f_face / fin_base)
    check(ok, min(sf_face, sf_fin) >= 2, "stop faces take the clack",
          f"{f_face:.0f} N on one face (dynamic x{DYN_STOP}): bearing SF"
          f" {sf_face:.1f}, fin shear SF {sf_fin:.1f} (>= 2)")

    # friction clamps against their steady survival moments.  The cap
    # and the bracket both hold angles by friction alone; geometry keys
    # everything else.
    t_cap = MU_CLAMP * 2 * F_M3 * (P["rod_d"] / 2) * mm
    sf_cap = t_cap / (m_stop / 2)     # cap and fin share the steady stop
    check(ok, sf_cap >= 2, "cap holds the stop angle (steady)",
          f"clamp friction {t_cap:.2f} N m vs its half of the stop moment"
          f" {m_stop / 2:.2f}, SF {sf_cap:.1f} (>= 2)")
    v_creep = math.sqrt(t_cap / (DYN_STOP * 0.5 * CD_PLATE * 0.5 * RHO_AIR
                                 * area * d_hinge))
    print(f"[info] stop CLACKS above ~{v_creep:.0f} m/s may creep the cap"
          " angle over time — the known deferred upgrade (knurl, flats);"
          " re-set the cap if the driven stop drifts")

    lever_tors = (P["bracket_h"] / 2 + P["collar_boss_h"]
                  + P["vane_width"] / 2) * mm
    t_bracket = MU_CLAMP * 2 * F_M3 * (P["rod_d"] / 2) * mm
    sf_tors = t_bracket / (f_panel * lever_tors)
    check(ok, sf_tors >= 2, "bracket holds against gust torsion",
          f"arm-clamp friction {t_bracket:.2f} N m vs {f_panel * lever_tors:.2f}"
          f" twisting it about the arm, SF {sf_tors:.1f} (>= 2)")

    t_hub_arm = MU_CLAMP * 3 * F_M5 * (P["rod_d"] / 2) * mm
    sf_hub = t_hub_arm / (f_panel * lever_tors)
    check(ok, sf_hub >= 2, "arm cannot roll in the hub",
          f"hub-clamp friction {t_hub_arm:.2f} N m vs the same torsion,"
          f" SF {sf_hub:.1f} (>= 2)")

    # bearings: the storm couple resolved across the two races
    spacing = (P["tower_h"] - P["bearing_w"] - P["pocket_recess"]
               - P["base_cavity_h"] - P["bearing_w"] - P["pocket_recess"]) * mm
    h_load = (P["shaft_tip_h"] + P["shaft_length"] - P["hub_shaft_socket"]
              + P["hub_arm_z"]) * mm - (P["tower_h"] * mm)
    f_bearing = f_panel * (h_load + spacing) / spacing
    sf_bearing = 1370 / f_bearing   # 608 static rating C0 = 1.37 kN
    print(f"[info] top bearing sees {f_bearing:.0f} N in the storm,"
          f" SF {sf_bearing:.0f} against its static rating")

    # arm droop under its own and the tip's weight (observable: check
    # the real machine against this number)
    i_rod = math.pi * (P["rod_d"] * mm) ** 4 / 64
    droop = (tip_kg * 9.81 * arm_free ** 3 / (3 * E_ALU * i_rod)
             + rod_kg_m * 9.81 * arm_free ** 4 / (8 * E_ALU * i_rod))
    print(f"[info] arm tips droop {droop * 1000:.0f} mm under gravity"
          " (rig check: measure it)")

    return 0 if all(ok) else 1


if __name__ == "__main__":
    sys.exit(main())
