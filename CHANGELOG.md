# Changelog

## Unreleased

- Add repository structure for reusable mechanical interfaces.
- Add object-based FDM sliding-dovetail interface.
- Add independent fit clearance, axial clearance and boolean overlap.
- Add optional integral locking with a male recess and ramped female spring threshold.
- Keep lock/spring implementation objects behind the top-level `sliding_dovetail_create()` interface.
- Allow consumers to choose whether the female cutter creates the flex cavity behind the spring.
- Start the default locking threshold directly at the female entry edge.
- Add an optional straight male screwdriver-release opening from the entry edge to the lock recess, using the recess width throughout.
- Number verification renders and fixtures by base/lock group and export STL fixtures in a neutral inspection orientation.
- Add focused male/female verification fixtures, fit sections and lock-section evidence.
