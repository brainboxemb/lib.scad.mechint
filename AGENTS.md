# Repository agent guidance

Persistent guidance for work in `lib.scad.mechint`.

## Repository role

This repository owns reusable mechanical interfaces between separately modelled
or separately printed parts. Interfaces may include mating geometry, controlled
clearance and optional retention/release features.

Product-specific placement and load-path decisions stay in consuming projects.

## Cross-project and workflow policy

Before repository work, read `brainboxemb/brainboxemb.meta/AGENTS.md` as the
cross-project coordination policy. In particular, follow its repository/CI
discipline: group related edits into coherent commits and branch updates, do
not create per-file micro-commits merely because a Git API makes that
convenient, and inspect the resulting CI/evidence before the next corrective
push.

For SCAD branch, pull-request, publication or release work, also read the pinned
`tools/tool.scad-project/AGENTS.md`. Generic repository bootstrap and dependency
handling belong to the pinned `tools/tool.git-project`.

Repository-specific guidance in this file supplements those shared policies; it
does not replace them.

Shared SCAD naming conventions are owned by
[brainboxemb.meta/domains/scad/coding-conventions.md](https://github.com/brainboxemb/brainboxemb.meta/blob/main/domains/scad/coding-conventions.md).
Follow that page for `d_` / `c_` top-level controls, explicit unit suffixes,
constants and leading-underscore private variables/functions/modules. Keep only
mechanical-interface-specific naming/API guidance here.

## OpenSCAD API

OpenSCAD is the primary implementation direction. Public interface state uses
`object()`:

```scad
joint = sliding_dovetail_create(...);
sliding_dovetail_male_build(joint, slide = 16);
sliding_dovetail_female_cutter(joint, slide = 16);
```

Derived dimensions come from the object through public accessors. The public
design language is aimed at FDM printing; prefer direct geometric parameters
such as an angle in degrees over woodworking conventions.

## Optional features

Extra behaviours such as locking/detents are optional interface features and
must be explicitly enabled on the interface object. The basic mating geometry
must remain usable without them.

Do not silently emit partly implemented feature geometry. If a feature is
represented in the API before its geometry is qualified, builders must reject
the enabled state explicitly.

## Boolean overlap

`extra` is a modeling/boolean overlap parameter, not a fit parameter. It may
extend geometry beyond union/difference boundaries, but must not alter the
nominal dovetail width, height, angle or clearance contract.

## Dependency boundary

Core mechanical-interface source uses plain OpenSCAD.

`lib.scad.util` is allowed as a development/verification dependency for
presentation, section views and evidence, but must not be imported by the core
`sliding_dovetail.scad` source merely to construct the interface.

BOSL2 may be consulted for general API ideas, but this library does not inherit
woodworking-oriented defaults or require BOSL2.

## Units and native coordinates

Public dimensional parameters are millimetres.

Sliding dovetail native coordinates:

```text
X = slide direction
Y = profile depth, mouth at Y=0 and root toward +Y
Z = profile width
```

## Verification

Verification exercises the public API as a consumer and includes a small female
test block plus assembled and approach views. Use section views where they make
fit/clearance readable.

Generated output belongs under configured Build/Verification output, not on
`main`.
