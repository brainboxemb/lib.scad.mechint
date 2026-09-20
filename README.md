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
    <th align="center">Flat-back hinge relief</th>
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
        <img src="../../raw/prod/vrf/png/16-sliding-dovetail-lock-hinge-cutaway.png" alt="Flat-back spring hinge relief cutaway" width="100%">
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

female entry side = -X
insertion motion = +X
female end-stop side = +X
```

## Fit versus boolean overlap

`clearance` and `axial_clearance` belong to the mechanical fit contract.

`extra` is different: it is a tiny OpenSCAD boolean overlap used to avoid
coplanar union/difference boundaries. It does **not** change the nominal
10 mm / 3 mm / 20° interface. Default: **0.01 mm**.

## Optional integral locking

Locking is selected on the same top-level interface:

```scad
joint = sliding_dovetail_create(
    locking = true,
    lock_cut_back_clearance = true,
    lock_release_access = true
);
```

The library then creates the matching lower-level lock and spring
configuration internally. Male and female therefore always use one shared
interface definition.

The entry side is fixed by the interface contract: the female opens at -X and
the male inserts toward +X. `lock_entry_offset` measures the start of the
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

`lock_cut_back_clearance = true` also removes a flex cavity behind that
cantilever. With `false`, the tongue may instead keep a flat outer/rear face.
For thick hosts the optional `lock_spring_hinge_length` and
`lock_spring_hinge_thickness` parameters create a compact channel-side hinge
relief while the outer surface stays continuous and flat. From the fixed root
toward the locking lip, the relief uses a short straight wall, a 45-degree
shoulder, a flat minimum-thickness flex land and a calculated return ramp. The
complete threshold/lip region is full-depth again before the lock starts.
A hinge length of 0 preserves the legacy spring geometry exactly.

`lock_release_access = true` extends the male recess all the way to its -X
entry edge. The access path has the same width as the recess, so there is no
narrow-to-wide step. A small flat screwdriver can enter this opening and lift
the female tongue. `lock_release_depth` controls the access depth.

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

For the flat-back hinge-relief variant, verification also publishes deliberately
named inspection STLs: complete female, female center cutaway and assembled
center cutaway. The aggregate API smoke test is not a reference model; it mixes
many unrelated builder calls only to prove that the public API compiles and
renders, so that STL is not published.

## Dependency boundary

The core `sliding_dovetail.scad` source has no dependency on
`lib.scad.util`.

The repository uses `lib.scad.util` only in verification and interactive
inspection views. Consumers therefore do not inherit utility geometry merely by
using the dovetail source.

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
