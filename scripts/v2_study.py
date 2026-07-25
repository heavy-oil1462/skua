#!/usr/bin/env python3
"""What-if study for Skua v2.0 — NOT a gate, prints a comparison table.

v1's performance_check gates the design that exists.  This study asks
where the machine could go if the v1 constraints fall away, holding
one thing fixed: the overall span stays close to today's (the flag
sweep circle, so arm length shrinks when vane reach grows).  Goal:
maximum CONSISTENT spin at low wind.

Two models on top of the v1 constants:

  1. The v1 fold/start model, evaluated per variant (seat friction,
     vane mass, aero area and lever, wind-gradient credit for a
     taller tower).

  2. A torque-vs-rotor-angle model the v1 suite does not have.
     "Consistent" means the worst parking angle still produces
     torque: each vane is quasi-statically free between its stops,
     weathervanes when the trailing direction is reachable, and
     otherwise rides the stop the wind presses it against with
     crossflow (sin^2) plate loading.  Summing N arms gives mean
     torque, worst-angle torque, and the dead angles, which is where
     two arms lose and three win.

Variants are CUMULATIVE, top to bottom.  Assumption constants below
carry their rationale; run this script for current numbers instead of
quoting stale ones.  Nothing here changes v1 parts or gates.
"""

import math

from design_params import PARAMS as P
from performance_check import (CD_PLATE, MU_HINGE, RHO_AIR, RHO_ASA,
                               ALU_YIELD, V_SURVIVAL, VANE_SLICED_KG)

MM = 1e-3

# --- v2 assumption constants -------------------------------------------
MU_PTFE = 0.12         # thin PTFE washer on the thrust seat
R_WASHER = 5.3 * MM    # its effective friction radius (8x14 washer)
FILM_VANE_KG = 0.028   # printed perimeter frame + mylar/ripstop skin,
                       # same face area as the solid panel; weigh a
                       # prototype before believing the third decimal
FILM_VANE_250_KG = 0.035  # the same construction at 250 mm reach
ROD10_S = math.pi * (10 * MM) ** 3 / 32  # 10 mm arm rod section modulus
WIND_SHEAR_EXP = 0.11  # wind profile over open water, v ~ h^0.11
ROTOR_H = 0.7          # m, arm axis above the water today (plank on a
                       # rail); the tall-tower variant adds 1.0

# --- baseline geometry from the shared params --------------------------
sleeve_r = P["vane_sleeve_od"] / 2 * MM
hinge_r = (P["hub_len"] / 2 - P["hub_arm_socket"] + P["arm_length"]
           - P["bracket_arm_grip"] + P["bracket_stub_x"]) * MM
swing = P["vane_swing_deg"]


def aero(reach_mm, arm_mm):
    """area, hinge lever, hinge radius, drive radius for a vane."""
    hr = (P["hub_len"] / 2 - P["hub_arm_socket"] + arm_mm
          - P["bracket_arm_grip"] + P["bracket_stub_x"]) * MM
    area = (reach_mm * MM - sleeve_r) * P["vane_width"] * MM
    d = (reach_mm * MM + sleeve_r) / 2
    return area, d, hr, hr + d


def v_fold(mu, r_seat, vane_kg, area, d, shear=1.0):
    t = mu * vane_kg * 9.81 * r_seat
    v = math.sqrt(t / (CD_PLATE * 0.5 * RHO_AIR * area * d))
    return v / shear


def vane_torque(phi, s, R, d):
    """Quasi-static torque of one vane at rotor angle phi (deg), in
    units of the full-face force F0, wind along +y, drive positive."""
    lo, hi = phi - s, phi
    if (90 - lo) % 360 <= s:      # trailing direction reachable
        return 0.0
    # the wind presses the panel against one stop: hinge moment goes
    # with cos(psi), positive pushes psi upward (toward hi)
    if math.cos(math.radians(hi)) > 0:
        psi = hi
    elif math.cos(math.radians(lo)) < 0:
        psi = lo
    else:
        return 0.0
    pr = math.radians(psi)
    n = (-math.sin(pr), math.cos(pr))          # panel normal
    load = n[1] * abs(n[1])                    # (w.n)|w.n|, w = +y
    f = (n[0] * load, n[1] * load)
    hx = R * math.cos(math.radians(phi))
    hy = R * math.sin(math.radians(phi))
    cx, cy = hx + d * math.cos(pr), hy + d * math.sin(pr)
    return cx * f[1] - cy * f[0]


def curve(arms, s, R, d):
    tot = [sum(vane_torque(phi + k * 360 / arms, s, R, d)
               for k in range(arms)) for phi in range(360)]
    return sum(tot) / len(tot), min(tot)


def storm_sf(area, r_drive, arm_mm, rod_s, tip_kg):
    q = 0.5 * RHO_AIR * V_SURVIVAL ** 2
    f = CD_PLATE * q * area
    free = (arm_mm - P["hub_arm_socket"]) * MM
    rod_kg_m = 2700 * math.pi * (P["rod_d"] * MM / 2) ** 2
    m = math.hypot(f * (r_drive - P["hub_len"] / 2 * MM),
                   9.81 * (tip_kg * free + rod_kg_m * free * free / 2))
    return ALU_YIELD / (m / rod_s)


def main():
    rod8_s = math.pi * (P["rod_d"] * MM) ** 3 / 32
    a0, d0, _, r0 = aero(P["vane_reach"], P["arm_length"])
    a2, d2, _, r2 = aero(250, 500)   # span held: 619+150 ~ 519+250
    seat = (P["ring_boss_d"] + P["rod_free_d"]) / 4 * MM
    shear_tall = ((ROTOR_H + 1.0) / ROTOR_H) ** WIND_SHEAR_EXP

    # cumulative ladder: (label, arms, mu, r_seat, vane_kg,
    #                     (area, d, r_drive, arm_mm, rod_s), shear)
    v1_geom = (a0, d0, r0, P["arm_length"], rod8_s)
    v2_geom = (a2, d2, r2, 500, ROD10_S)
    ladder = [
        ("v1 as built (calibrated 78 g vane)",
         2, MU_HINGE, seat, VANE_SLICED_KG, v1_geom, 1.0),
        ("+ PTFE washer on the thrust seat",
         2, MU_PTFE, R_WASHER, VANE_SLICED_KG, v1_geom, 1.0),
        ("+ three arms",
         3, MU_PTFE, R_WASHER, VANE_SLICED_KG, v1_geom, 1.0),
        ("+ film-and-frame vanes (~28 g)",
         3, MU_PTFE, R_WASHER, FILM_VANE_KG, v1_geom, 1.0),
        ("+ reach 250 on 500 arms, 10 mm rod (span held)",
         3, MU_PTFE, R_WASHER, FILM_VANE_250_KG, v2_geom, 1.0),
        ("+ tower 1 m taller (wind shear credit)",
         3, MU_PTFE, R_WASHER, FILM_VANE_250_KG, v2_geom, shear_tall),
    ]

    print(f"{'variant':<48}{'start':>7}{'worst/mean':>11}{'arm SF':>8}")
    for label, arms, mu, rs, mkg, geom, shear in ladder:
        area, d, r_drive, arm_mm, rod_s = geom
        v = v_fold(mu, rs, mkg, area, d, shear)
        mean, worst = curve(arms, swing, r_drive - d, d)
        sf = storm_sf(area, r_drive, arm_mm, rod_s, 0.16)
        print(f"{label:<48}{v:>6.2f} {worst / mean:>10.2f}{sf:>8.2f}")

    print()
    print("start: self-start wind, m/s (fold-limited, v1 model).")
    print("worst/mean: worst-parking-angle torque over the revolution")
    print("  mean; zero means dead angles exist (the two-arm problem).")
    print("arm SF: locked-rotor storm safety factor at the hub, one")
    print("  flag face-on at 25 m/s; v1 floor is 1.3.")
    print()
    # re-arm, the other consistency term (see performance_check)
    for label, mkg, area, d, reach in (
            ("v1 vane", VANE_SLICED_KG, a0, d0, P["vane_reach"]),
            ("film vane", FILM_VANE_KG, a0, d0, P["vane_reach"]),
            ("film vane, reach 250", FILM_VANE_250_KG, a2, d2, 250)):
        i = mkg * ((reach * MM) ** 3 - sleeve_r ** 3) / (3 * (reach * MM - sleeve_r))
        t = math.sqrt(2 * math.radians(swing) * i
                      / (0.5 * CD_PLATE * 0.5 * RHO_AIR * area * d))
        # rotor-angle cost uses the v1 speed constant, close enough here
        print(f"[info] re-arm with {label}: ~{math.degrees(1.08 * t):.0f} deg"
              f" of rotor travel vs the {180 - swing:.0f} deg window")


if __name__ == "__main__":
    main()
