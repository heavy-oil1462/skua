# Supervisor notes

How the podium team works on this repository. Written and kept by the
supervisor.

## Team

The project may run two workers. Start one per assigned issue and remove
it once its pull request merges and nothing else is queued; the CAD gates
are slow, so two parallel workers only pay off on issues that touch
different parts (or one CAD and one docs/scripts issue).

## Cutting issues

- One part, one gate or one doc section per issue. A parameter change
  that ripples through several parts is still one issue, since
  design_params.scad is shared.
- Acceptance criteria name the gate that proves it: a geometry_check or
  performance_check assertion, a rendered PNG to look at, or
  `regen_all.py --check` green with regenerated STLs committed.
- Name the CLAUDE.md core idea the change touches, if any; changes that
  would bend one are owner decisions, not issues.
- Tri work stays in cad/tri/ unless the issue says otherwise.

## Review

- Look at the rendered PNGs in the diff, not only the source.
- Regenerated artifacts must be in the same commit as their source; no
  hand-edited STL or image.
- No new name in a part that shadows design_params; no third rod stock;
  no clamp gap set to zero; no drilling in the assembly steps.
- BOM changes land in README, CLAUDE.md and docs/assembly.md together.

## Lessons

- 2026-10-27: session started with no DIRECTION.md or SUPERVISOR.md and
  no docs/adr; both drafted from the README, CLAUDE.md and git history.
