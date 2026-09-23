# lib.scad.mechint development manual

## Start

1. read [../AGENTS.md](../AGENTS.md);
2. read [10-00-plan.md](10-00-plan.md);
3. use [README.md](README.md) for the local documentation map;
4. read the sliding-dovetail design/manual before changing interface semantics.

## Repository entrypoints

Managed root repository entrypoints are:

```text
bootstrap.ps1 / bootstrap.sh
update.ps1 / update.sh
```

`project.yml` selects the released tooling and external-library refs. Committed
gitlinks record the exact revisions used by CI and local bootstrap.

Repository-owned workflows are:

```text
.github/workflows/self-ci.yml
.github/workflows/self-release.yml
.github/workflows/self-pr-cleanup.yml
```

They are thin self-entry callers. Shared orchestration remains in the released
reusable workflows owned by `tool.scad-project` / `tool.git-project`.

## Dependencies

Mechint directly consumes:

- `lib.scad.forge` for generic transforms, tagged CSG and cutter mechanics;
- `lib.scad.util` only for section-inspection views;
- `tool.scad-project` for build/verification/release orchestration.

The verification runner asserts both declared refs and exact gitlinks so a
consumer rollout cannot silently drift.

## Edit and verify

Normal implementation work stays under `openscad/`; the public entrypoint is
`openscad/sliding_dovetail.scad`.

Run through the shared SCAD workflow or `scripts/run-verification.sh`.
Generated Build output belongs under `bld/`; generated verification evidence
belongs under `vrf/out`.

## Release

Create releases only from an exact qualified main commit through
`self-release.yml`. Verify exact-main CI and publication provenance before
starting the release-request lifecycle.
