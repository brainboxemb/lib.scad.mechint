# Sliding dovetail

The interface is aimed at compact **FDM-printed mechanical parts**.

## Native orientation

```text
X = slide / insertion direction
Y = profile depth
Z = profile width

female entry side = -X
insertion motion = +X
female end-stop side = +X
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
| Female entry slot | 0 mm / disabled |
| Locking | disabled |

## Parameter meaning

`angle` directly describes the mechanical flank angle. The mouth width is
derived from `width`, `height` and `angle`.

`clearance` and `axial_clearance` are fit dimensions.

`extra` exists only to make OpenSCAD unions and differences robust at shared
boundaries. It is not part of the nominal mating dimensions.

### Female entry slot

`entry_slot_length` optionally adds a straight rectangular subtraction volume
ahead of the female channel on the fixed `-X` entry side. Its width and depth
come from the complete clearanced female root envelope, so a male dovetail can
sit ahead of the channel before sliding in.

The parameter is a length along X only. A value of `0` preserves the ordinary
female cutter. The male builder ignores this setting.

When locking is enabled, a non-zero entry slot also opens the short transverse
relief at the female spring start. This keeps the lock tongue U-shaped even
though material may continue ahead of the mating channel.

For example, a 16 mm male can be given a 16 mm approach pocket:

```scad
joint = sliding_dovetail_create(
    entry_slot_length = 16
);

sliding_dovetail_female_cutter(
    joint,
    slide = 16
);
```

`sliding_dovetail_female_slide()` continues to return only the mating channel
length. Use `sliding_dovetail_female_total_length()` when host geometry must
include both channel and entry slot.

## Locking

Locking is configured on the same top-level interface object:

```scad
joint = sliding_dovetail_create(
    locking = true,
    lock_cut_back_clearance = true,
    lock_release_access = true
);
```

The library creates the lower-level lock and spring configuration internally.

`lock_entry_offset` measures the start of the female threshold ramp from the
fixed -X entry side. Its default is 0 mm, so the ramp starts directly at the
edge. In the assembled interface the male recess is derived from that same
entry-side definition.

The lock combines a recess in the male with a ramped threshold in the female
channel roof. Two longitudinal relief cuts form the sides of the U-shaped
tongue. When the spring starts at a physical female edge, that edge is already
the open end of the U. If `lock_entry_offset > 0` or
`entry_slot_length > 0`, the library also cuts the short transverse relief
needed to free the tongue at its entry end.

`lock_cut_back_clearance = true` cuts the flex cavity behind the tongue.
With it disabled, the consuming host part must provide that free space itself.

The threshold insertion ramp is independently tunable with
`lock_ramp_length`. With `lock_release_access = true`, the recess continues
to the male -X edge with the same width as the recess itself. A small flat
screwdriver can use that straight opening to lift the female tongue.
`lock_release_depth` controls its depth.
