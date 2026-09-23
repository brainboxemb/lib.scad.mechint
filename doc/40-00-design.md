# lib.scad.mechint design

## Public API and companion workspace

The consumer-facing API is:

```text
openscad/sliding_dovetail.scad
```

The same-purpose companion workspace is:

```text
openscad/sliding-dovetail/
├── sliding_dovetail_lock.scad
├── design/design.md
├── manual.md
├── reference/
├── assemblies/
└── render/
```

Consumers import the top-level entrypoint; they should not need companion
implementation files directly.

## Native coordinate system

```text
X = slide / insertion direction
Y = profile depth, mouth at Y=0 and root toward +Y
Z = profile width
```

The fixed female entry is -X and insertion moves toward +X.

## Interface construction

The top-level object owns both base profile state and optional lock/spring
configuration. Male and female builders derive their geometry from that same
object so fit, lands, entry-slot and lock relationships do not drift.

Generic modeling mechanics come from Forge where they improve readability.
Mechanical semantics stay local to mechint.

## Detailed design

[../openscad/sliding-dovetail/design/design.md](../openscad/sliding-dovetail/design/design.md)
is the detailed visual construction source.

[../openscad/sliding-dovetail/manual.md](../openscad/sliding-dovetail/manual.md)
is the consumer-facing usage and reference document.

Generated renders and design documentation are evidence/output, not a second
source authority.
