# Changelog

## Unreleased

### Changed

- Move generic modeling ownership from `lib.scad.util` to released
  `lib.scad.forge v0.2.0`. Core sliding-dovetail source now uses the Forge
  umbrella entrypoint, `fg_xf_*` transforms and callable overlap constants
  such as `FG_LEFT()`. Mechanical geometry and public mechint API semantics
  remain unchanged.


## v0.2.1

### Changed

- Upgrade the runtime utility dependency to released `lib.scad.util v0.4.0`.
  Sliding-dovetail lock cutters now use Forge's named overlap token functions
  (`fg_left()`, `fg_right()`, `fg_back()`) instead of the legacy
  `overlap_min` / `overlap_max` boolean vectors. Cutter geometry and
  overlap amounts remain unchanged.


## v0.2.0

### Changed

- Adopt the `lib.scad.util` Forge modeling layer for core sliding-dovetail
  construction. High-level lock booleans now use explicit body/remove/keep
  roles, while lock recess/release box cutters use centralized overlap-aware
  Forge cutters instead of repeated translate/cube overlap arithmetic. Public
  mechint geometry/API semantics remain unchanged. Simple core placement now
  uses the shared `xf_` transform helpers instead of direct `translate()` calls.
  Raw axis-remapping matrices are replaced by `xf_frame()` plus an explicit
  `xf_zflip()` where the printable wedge intentionally uses a reflected frame.

- Breaking OpenSCAD API cleanup to the shared coding standard: physical scalar parameters, object fields and accessors now carry explicit unit suffixes; length names use the shared `len` abbreviation where applicable; object receiver parameters use `obj`; and booleans use positive state names. No compatibility aliases are retained because the current consumer is migrated together.

- Adopt the released Migration 008 dependency stack with `tool.git-project v0.2.9`
  and `tool.scad-project v0.15.2`, and upgrade the runtime utility dependency
  to released `lib.scad.util v0.3.0`. Qualification asserts that the root
  bootstrap initializes that external library without recursively initializing
  the library's own tooling gitlinks.

## v0.1.6

### Added

- Add optional symmetric printable wedges to the male lock-release opening.
  `lock_release_shape="rectangular"` preserves the released cutter exactly;
  `"trapezoid"` keeps that full rectangular cutter and removes two additional
  X/Z wedges across the complete visible release zone toward the male trailing
  edge according to `lock_release_taper_angle_deg`, while release depth stays
  constant. The wedges overlap the baseline cutter slightly to avoid Boolean
  sliver walls.

## v0.1.5

### Added

- Add optional female spring hinge relief for thick hosts. A non-zero
  `lock_spring_hinge_length` creates a compact channel-side pocket near the
  fixed end while `lock_spring_hinge_thickness` sets the remaining local
  flexure thickness. The relief is now approached from **both faces**, leaving
  a short centered flex web instead of thinning the tongue from only one side.
  Each opposing pocket uses a mostly straight root wall, a local 45-degree
  chamfer, a short flat land and a calculated return ramp constrained to a
  maximum of 45 degrees. The fixed root and complete locking-threshold region
  stay full-depth. The default hinge length of 0 preserves existing lock
  geometry.
- Add dedicated full-female, cutaway and assembled-cutaway hinge-relief renders
  plus matching inspectable STL fixtures.

### Changed

- Keep the aggregate API geometry as a temporary verification smoke test instead
  of publishing `sliding-dovetail-api.stl` alongside intentional fixtures.

## v0.1.4

### Added

- Add optional `mouth_land_depth` to create a straight segment at the
  narrow/mouth end before the angled flank. The default remains 0, preserving
  all existing profiles.
- Derive male mouth width, female root width and relief geometry from the
  remaining sloped depth after both mouth and root lands.

## v0.1.3

### Added

- Add optional `root_land_depth` to replace the final part of each dovetail
  flank with a straight root land while preserving the legacy profile exactly
  at the default value of 0.
- Add `sliding_dovetail_male_relief_cutter()` so consumers can trim local body
  overlap away from male flanks using the same interface object instead of
  duplicating profile geometry.

## v0.1.2

### Fixed

- Keep the integral female lock tongue U-shaped when `entry_slot_length > 0`
  by adding the transverse spring relief at the mating-channel entry. The
  existing no-entry-slot lock geometry remains unchanged.

## v0.1.1

### Added

- Add optional female `entry_slot_length` support to the sliding-dovetail
  interface, creating a straight -X approach mask sized from the clearanced
  female root envelope so the male can sit ahead of the channel before insertion.

### Changed

- Add a two-image root README preview backed by generated production output;
  show the separate male/female dovetail pair alongside the integral-lock
  section so the library interface is easier to understand at a glance.

## v0.1.0

### Added

- Initial reusable mechanical-interface library structure.
- Object-based FDM sliding-dovetail interface with derived mouth geometry.
- Independent fit clearance, axial clearance and boolean overlap controls.
- Optional integral locking with a male recess and ramped female spring threshold.
- Top-level `sliding_dovetail_create()` facade that owns lower-level lock/spring configuration.
- Optional automatic flex cavity behind the female spring tongue.
- Entry-edge locking threshold with a straight male screwdriver-release opening.
- Numbered verification renders and STL fixtures in a neutral inspection orientation.
- Plain, locking, cutaway and assembled verification fixtures.
