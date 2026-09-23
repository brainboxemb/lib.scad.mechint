# Verification

Repository-level strategy/status: [50-00-verification.md](50-00-verification.md).

The public object API was compiled and rendered with OpenSCAD object functions
enabled.

Fixture numbering:

- 01–09 — base sliding dovetail;
- 10–19 — locking sliding dovetail.

Printable / inspectable fixtures:

- [01-sliding-dovetail-male-test-piece.stl](fixtures/01-sliding-dovetail-male-test-piece.stl)
- [02-sliding-dovetail-female-test-block.stl](fixtures/02-sliding-dovetail-female-test-block.stl)
- [10-sliding-dovetail-lock-male-test-piece.stl](fixtures/10-sliding-dovetail-lock-male-test-piece.stl)
- [11-sliding-dovetail-lock-female-test-block.stl](fixtures/11-sliding-dovetail-lock-female-test-block.stl)
- [12-sliding-dovetail-lock-female-cutaway.stl](fixtures/12-sliding-dovetail-lock-female-cutaway.stl)
- [13-sliding-dovetail-lock-assembled.stl](fixtures/13-sliding-dovetail-lock-assembled.stl)
- [14-sliding-dovetail-lock-assembled-cutaway.stl](fixtures/14-sliding-dovetail-lock-assembled-cutaway.stl)
- [15-sliding-dovetail-lock-hinge-female.stl](fixtures/15-sliding-dovetail-lock-hinge-female.stl)
- [16-sliding-dovetail-lock-hinge-female-cutaway.stl](fixtures/16-sliding-dovetail-lock-hinge-female-cutaway.stl)
- [17-sliding-dovetail-lock-hinge-assembled-cutaway.stl](fixtures/17-sliding-dovetail-lock-hinge-assembled-cutaway.stl)

The aggregate API exercise is still compiled and rendered during verification,
but its mixed test geometry is temporary and deliberately not published as a
fixture STL.

Fixture STLs use a neutral inspection orientation. Each reference block lies
flat with its mechanical interface facing upward. This orientation belongs to
verification only; it does not prescribe a print or consumer-product
orientation.

Male and female fixtures remain available independently. The 13 assembled STL
keeps the exact mating position, while 14 cuts that assembly on the center
plane so the internal lock relationship is visible. Fixtures 15–17 focus on
the flat-back hinge-relief variant: complete female, female center cutaway and
assembled center cutaway.

Configured verification renders show assembled fit, side approach, a YZ
section through the engaged interface, and a rotated XY lock section at the
fixed -X entry side. The locking male uses one continuous release opening from
the entry edge to the locking wall: the access path has the same width as the
recess, so there is no narrow-to-wide step.

<!-- scad-project-evidence-navigation -->
## Producer execution evidence

These files describe the SCAD producer executions that actually created the retained output.
They remain unchanged when equivalent output is later hydrated from cache.

- [scad-verify execution](evidence/executions/scad-verify/execution.json) — capability, producer source revision, exact owner revision, result and producer timing when available.
  - [scad-verify log](evidence/executions/scad-verify/execution.log) — concise human-readable producer summary.

## Domain evidence

Structured SCAD/SCons reports contain the detailed target-level build and cache decisions.
They are richer domain evidence, not alternate producer logs.

- [last-verification-build.json](evidence/domain/last-verification-build.json)

## Orchestration/materialization evidence

Current-run orchestration evidence explains why capabilities were selected, whether Moon executed or hydrated them, and how long current materialization and snapshot preparation took.
Producer execution evidence above remains the authority for the work that originally created cached output.

- Current orchestration evidence is attached by the publication layer.
- A later cache hydration may therefore have a current materialization revision that differs from the retained producer `source_revision`.

## Publication context

`publication-info.txt` records generated-branch context plus source, tooling and runtime provenance.
Publication/finalization consumes prepared output and must not rewrite producer execution evidence.
