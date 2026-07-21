// Shared bore helpers. Lives under cad/lib/ so regen_all.py does not try
// to export it as a printable part (it scans cad/ and cad/calibration/ only).

// Horizontal rod bore, printable without supports: a cylinder along +X
// with a 45-degree teardrop roof. Every part in this project prints in
// its natural orientation, which leaves the hub arm sockets and the vane
// sleeve bore lying horizontally — a plain circle would sag at the
// crown, so the crown is a peak instead. The peak points to +Z: keep the
// part's print orientation equal to its modeled orientation.
//
// The rod fit gauge prints its holes through this same module, so the
// calibrated rod_snug_d / rod_free_d numbers already contain whatever
// error the teardrop introduces.
//
// Starts at x=0, runs to x=l. Subtract it; the caller adds any overrun.
module rod_bore(d, l) {
    r = d / 2;
    rotate([90, 0, 90])
        linear_extrude(height = l)
            polygon(concat(
                // lower ~3/4 circle from 45 deg past top, going clockwise
                [for (a = [45 : 5 : 315]) [r * cos(a + 90), r * sin(a + 90)]],
                // 45-degree roof peak
                [[0, r * sqrt(2)]]));
}
