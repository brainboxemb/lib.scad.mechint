# lib.scad.mechint plan

## Purpose

This is the operational source for current/future work in the reusable
mechanical-interface library. Completed functional history belongs in
[../CHANGELOG.md](../CHANGELOG.md).

## Current position

The sliding-dovetail interface is the established reusable component. It
supports base male/female mating geometry plus optional entry-slot, locking,
release-access, printable release-shape and centered hinge-relief features.

There is no open feature issue or pull request at the time of this migration.
New work should start from a concrete reusable mechanical-interface requirement
rather than product-specific placement needs.

## Working method

1. inspect current source, open issues/PRs, live CI and generated evidence;
2. read the component design and manual before changing interface semantics;
3. keep fit dimensions separate from Boolean/modeling overlap;
4. preserve the public top-level API boundary;
5. add product-independent behavior here and product placement in consumers;
6. inspect fit/section evidence when the change is geometric.

## Information sources

| Question | Authority |
| --- | --- |
| Current/future library work | this plan |
| Shared working conventions | `brainboxemb.meta/AGENTS.md` |
| Interface contracts/boundaries | [10-specification.md](10-specification.md) |
| Repository architecture | [20-design.md](20-design.md) |
| Detailed geometry | `openscad/sliding-dovetail/design/design.md` |
| Consumer usage/API reference | `openscad/sliding-dovetail/manual.md` |
| Verification strategy/status | [30-verification.md](30-verification.md) |
| Exact dependency/tool state | config, gitlinks, live Actions and provenance |
| Completed history | [../CHANGELOG.md](../CHANGELOG.md) |
