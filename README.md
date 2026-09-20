# lib.scad.mechint

Reusable mechanical interfaces for OpenSCAD: dovetails, mating clearances,
detents and release features.

The library is intentionally about the **interface between parts**. A consuming
project decides where an interface is placed and what it connects.

## Sliding dovetail

The first interface is a compact sliding dovetail aimed at **FDM-printed
mechanical parts**.

```scad
use <openscad/sliding-dovetail/sliding_dovetail.scad>

joint = sliding_dovetail_create(
    width = 10,
    height = 3,
    angle = 20,
    clearance = 0.20,
    axial_clearance = 0.25,
    extra = 0.01,
    locking = false
);

sliding_dovetail_male_build(joint, slide = 16);
sliding_dovetail_female_cutter(joint, slide = 16);
```

The default 10 mm root width, 3 mm profile height and 20° flank angle give a
derived male mouth width of about **7.82 mm**. The mouth is derived rather than
stored independently, so the profile stays internally consistent.

Native coordinates are:

```text
X = slide / insertion direction
Y = profile depth
Z = profile width
```

## Fit versus boolean overlap

`clearance` and `axial_clearance` belong to the mechanical fit contract.

`extra` is different: it is a tiny OpenSCAD boolean overlap used to avoid
coplanar union/difference boundaries. It does **not** change the nominal
10 mm / 3 mm / 20° interface. Default: **0.01 mm**.

## Optional locking

Locking/detent behaviour is optional and defaults to `false`.

The object already records the feature state so a later spring threshold,
detent recess and screwdriver-release feature can be added without inventing a
second incompatible API. Enabling locking is currently rejected explicitly
until that geometry is implemented and verified.

## Female test block

Verification includes a small female block with:

- an open X side for insertion;
- the female dovetail derived from the same object;
- a solid end stop;
- an assembled fit view;
- an approach view showing the slide direction;
- a YZ section through the engaged profile.

This lets the mechanical interface be developed independently from any one
consumer such as the HUB75 frame.

## Dependency boundary

The core `sliding_dovetail.scad` source has no dependency on
`lib.scad.util`.

The repository uses `lib.scad.util` only in verification for section
inspection. Consumers therefore do not inherit utility geometry merely by using
the dovetail source.

## Development

Generated Build and Verification output is published separately from source.
See the PR preview or production `bld` / `vrf` branches for generated
images and evidence.
