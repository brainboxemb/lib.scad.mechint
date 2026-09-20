# Changelog

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
