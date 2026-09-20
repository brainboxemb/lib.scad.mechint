# Changelog

## Unreleased

### Added

- Add optional female spring hinge relief for thick hosts. A non-zero
  `lock_spring_hinge_length` creates a compact channel-side pocket near the
  fixed end while `lock_spring_hinge_thickness` sets the remaining local
  flexure thickness. From the fixed root toward the lip, the relief now uses a
  mostly straight wall with a local 45-degree lower-corner chamfer, a flat
  minimum-thickness flex land of the same length as that chamfer run, and a
  calculated return ramp constrained to a maximum of 45 degrees.
  The complete locking-threshold region returns
  to full host thickness before the lip, preventing the thin tongue from
  appearing or behaving as a floating strip. The outer/rear host face stays
  flat, and the default hinge length of 0 preserves existing lock geometry.
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
