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
| Locking | disabled |

## Parameter meaning

`angle` directly describes the mechanical flank angle. The mouth width is
derived from `width`, `height` and `angle`.

`clearance` and `axial_clearance` are fit dimensions.

`extra` exists only to make OpenSCAD unions and differences robust at shared
boundaries. It is not part of the nominal mating dimensions.

## Locking

Locking is configured on the same top-level interface object:

```scad
joint = sliding_dovetail_create(
    locking = true,
    lock_cut_back_clearance = true,
    lock_release_access = false
);
```

The library creates the lower-level lock and spring configuration internally.

The enabled lock combines a recess in the male with a ramped threshold in the
female channel roof. U-shaped relief cuts isolate that threshold as part of an
integral cantilever spring.

`lock_cut_back_clearance = true` cuts the flex cavity behind the tongue.
With it disabled, the consuming host part must provide that free space itself.

The threshold insertion ramp is independently tunable with
`lock_ramp_length`. Screwdriver/service access is independent and opt-in
through `lock_release_access`.
