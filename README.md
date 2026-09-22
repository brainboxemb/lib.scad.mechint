# lib.scad.mechint

Reusable mechanical interfaces for OpenSCAD: dovetails, mating clearances,
detents and release features.

The library is intentionally about the **interface between parts**. A consuming
project decides where an interface is placed and what it connects.

## Preview

<table>
  <tr>
    <th align="center">Dovetail pair</th>
    <th align="center">Integral lock section</th>
    <th align="center">Centered hinge relief</th>
  </tr>
  <tr>
    <td align="center">
      <a href="../../blob/prod/bld/png/sliding-dovetail-pair.png">
        <img src="../../raw/prod/bld/png/sliding-dovetail-pair.png" alt="Sliding dovetail male and female pair" width="100%">
      </a>
    </td>
    <td align="center">
      <a href="../../blob/prod/vrf/png/10-sliding-dovetail-lock-section.png">
        <img src="../../raw/prod/vrf/png/10-sliding-dovetail-lock-section.png" alt="Sliding dovetail integral lock section" width="100%">
      </a>
    </td>
    <td align="center">
      <a href="../../blob/prod/vrf/png/16-sliding-dovetail-lock-hinge-cutaway.png">
        <img src="../../raw/prod/vrf/png/16-sliding-dovetail-lock-hinge-cutaway.png" alt="Centered spring hinge relief cutaway" width="100%">
      </a>
    </td>
  </tr>
</table>

These images are generated from the current `prod/bld` and `prod/vrf`
branches; generated PNGs are not stored on `main`.

## Sliding dovetail

The first interface is a compact sliding dovetail aimed at **FDM-printed
mechanical parts**.

The normal consumer API starts with one top-level interface object:

```scad
use <openscad/sliding-dovetail/sliding_dovetail.scad>

joint = sliding_dovetail_create(
    width_mm = 10,
    height_mm = 3,
    angle_deg = 20,
    clearance_mm = 0.20,
    axial_clearance_mm = 0.25,
    extra_mm = 0.01,
    is_locking_enabled = false
);

sliding_dovetail_male_build(joint, slide_len_mm = 16);
sliding_dovetail_female_cutter(joint, slide_len_mm = 16);
```

The default 10 mm root width, 3 mm profile height and 20° flank angle give a
derived male mouth width of about **7.82 mm**. The mouth is derived rather than
stored independently, so the profile stays internally consistent.

Native coordinates are:

```text
X = slide_len_mm / insertion direction
Y = profile depth
Z = profile width_mm

female entry side = -X
insertion motion = +X
female end-stop side = +X
```

## Fit versus boolean overlap

`clearance_mm` and `axial_clearance_mm` belong to the mechanical fit contract.

`extra_mm` is different: it is a tiny OpenSCAD boolean overlap used to avoid
coplanar union/difference boundaries. It does **not** change the nominal
10 mm / 3 mm / 20° interface. Default: **0.01 mm**.

## Optional integral locking

Locking is selected on the same top-level interface:

```scad
joint = sliding_dovetail_create(
    is_locking_enabled = true,
    lock_has_back_clearance = true,
    lock_has_release_access = true
);
```

The library then creates the matching lower-level lock and spring
configuration internally. Male and female therefore always use one shared
interface definition.

The entry side is fixed by the interface contract: the female opens at -X and
the male inserts toward +X. `lock_entry_offset_mm` measures the start of the
threshold ramp from that -X entry side. The default is 0 mm, so the ramp starts
directly at the edge.

The lock consists of:

- a recess near the male -X / trailing end, aligned with the female threshold when assembled;
- a threshold retained in the roof of the female channel;
- a sloped threshold face toward the female opening so the male can push the
  tongue out of the way while inserting;
- a steeper rear face that engages the male recess;
- two longitudinal isolation cuts from the female entry toward +X, leaving the
  entry edge itself as the free end of the cantilever spring.

`lock_has_back_clearance = true` also removes a flex cavity behind that
cantilever. With `false`, the tongue may instead keep a flat outer/rear face.
For thick hosts the optional `lock_spring_hinge_len_mm` and
`lock_spring_hinge_thickness_mm` parameters create a **two-sided** local hinge
relief. Matching pockets approach from both faces, leaving
`lock_spring_hinge_thickness_mm` as a short centered flex web. Each pocket uses a
mostly straight wall, a local 45-degree chamfer, a short flat land and a
calculated return ramp; the threshold/lip and fixed root remain full-depth.
A hinge length of 0 preserves the legacy spring geometry exactly.

`lock_has_release_access = true` extends the male recess all the way to its -X
entry edge. The access path has the same width as the recess, so there is no
narrow-to-wide step. A small flat screwdriver can enter this opening and lift
the female tongue. `lock_release_depth_mm` controls the access depth.

## Female test block

Verification includes a small female block with:

- an open X side for insertion;
- the female dovetail derived from the same object;
- a solid end stop;
- an assembled fit view;
- an approach view showing the slide direction;
- a YZ section through the normal engaged profile;
- an XY lock section through the center of the threshold and spring.

This lets the mechanical interface be developed independently from any one
consumer such as the HUB75 frame.

For the centered hinge-relief variant, verification also publishes deliberately
named inspection STLs: complete female, female center cutaway and assembled
center cutaway. The aggregate API smoke test is not a reference model; it mixes
many unrelated builder calls only to prove that the public API compiles and
renders, so that STL is not published.

## Dependency boundary

Core sliding-dovetail source uses the owner-local `lib.scad.forge` runtime
dependency for generic transforms, tagged CSG and overlap-aware cutters.

Forge does not own any dovetail dimensions, clearances, locking behavior or fit
semantics; those remain part of `lib.scad.mechint`. Consumers normally use the
mechint public API and do not need to call Forge directly.

## Development

Generated Build and Verification output is published separately from source.
See the PR preview or production `bld` / `vrf` branches for generated
images and evidence.

## Interactive workspace

Open the repository-root `main.scad` directly in OpenSCAD. Its Customizer
exposes the complete top-level dovetail/lock interface and these views:

- male reference block;
- female reference block;
- approach along the X slide axis;
- fully assembled pair;
- assembled YZ fit section;
- XY lock section through the threshold, male recess and spring cavity.
