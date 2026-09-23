# lib.scad.mechint verification

## Strategy

Verification isolates the mechanical interface from any consuming product and
uses the public top-level API.

The evidence set covers the base interface and optional locking behavior through
focused fit, approach and section views plus inspectable STL fixtures.

## Base interface

Verification checks:

- public object creation and male/female builders;
- assembled fit and insertion direction;
- clearanced female geometry and optional entry slot;
- YZ profile/fit sections;
- optional root and mouth lands;
- public male mating-relief behavior.

## Locking interface

Focused evidence checks the male recess/release opening, female threshold,
spring isolation, optional back clearance, entry-slot interaction and centered
two-sided hinge relief.

Fixture STL orientation is a neutral inspection orientation only. It is not a
prescribed consumer or print orientation.

## Acceptance boundary

Verification proves reusable interface geometry/API behavior. It does not prove
a particular product's placement, load path, printer/material fit or assembly
force.

## Evidence and publication

Executable sources and fixtures remain under `vrf/`. Generated verification
is published under the technical `vrf` namespace and includes a copy of this
strategy document.

For current automation/tool/runtime health, inspect live Actions and
`publication-info.txt` rather than freezing version text here.
