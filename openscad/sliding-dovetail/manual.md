# Sliding dovetail

The interface is aimed at compact **FDM-printed mechanical parts**.

## Native orientation

```text
X = slide / insertion direction
Y = profile depth
Z = profile width
```

The male mouth lies at `Y=0`; the wider root lies toward `+Y`.

## Default interface

| Parameter | Default |
| --- | ---: |
| Root / maximum male width | 10.0 mm |
| Profile height | 3.0 mm |
| Flank angle | 20° |
| Derived male mouth width | 7.82 mm |
| Female clearance | 0.20 mm |
| Axial clearance | 0.25 mm |
| Boolean overlap (`extra`) | 0.01 mm |

## Parameter meaning

`angle` directly describes the mechanical flank angle. The mouth width is
derived from `width`, `height` and `angle`.

`clearance` and `axial_clearance` are fit dimensions.

`extra` exists only to make OpenSCAD unions and differences robust at shared
boundaries. It is not part of the nominal mating dimensions.

## Locking

Locking configuration is owned by a separate
`sliding_dovetail_lock_create()` object and passed into
`sliding_dovetail_create(lock = lock)`.

The first version intentionally qualifies the plain sliding interface before
adding a spring threshold/detent and screwdriver release. Until that feature is
implemented, an enabled lock object is rejected explicitly.
