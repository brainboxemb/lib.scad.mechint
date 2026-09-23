# lib.scad.mechint

Reusable mechanical interfaces for OpenSCAD: mating geometry, controlled
clearance and optional retention/release features. Product-specific placement
and load-path decisions remain with consumers.

## Start here

- [Plan](doc/00-plan.md)
- [Specification](doc/10-specification.md)
- [Design](doc/20-design.md)
- [Verification](doc/30-verification.md)
- [Sliding-dovetail design](openscad/sliding-dovetail/design/design.md)
- [Sliding-dovetail manual](openscad/sliding-dovetail/manual.md)
- [Latest Build](../../tree/prod/bld)
- [Latest Verification](../../tree/prod/vrf)
- [Changelog](CHANGELOG.md)

## Public entrypoint

```scad
use <openscad/sliding_dovetail.scad>

joint = sliding_dovetail_create(...);
sliding_dovetail_male_build(joint, slide_len_mm = 16);
sliding_dovetail_female_cutter(joint, slide_len_mm = 16);
```

The public file is the consumer API. The companion
`openscad/sliding-dovetail/` workspace contains private helpers, design,
reference geometry, assemblies and render adapters.

Current dependency/tool/runtime versions are intentionally not copied here.
Use `project.yml`, gitlinks, live Actions and publication provenance.
