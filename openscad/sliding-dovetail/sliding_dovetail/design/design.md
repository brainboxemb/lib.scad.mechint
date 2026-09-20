# Sliding dovetail — design

<!-- scad-render-defaults
engine: openscad
source: sliding_dovetail_render.scad
module: sliding_dovetail_design
vpr: [72, 0, 35]
-->

## Purpose

This is a compact sliding interface for **FDM-printed parts**. It is not based
on a woodworking dovetail standard.

Native coordinates are:

```text
X = slide direction
Y = profile depth
Z = profile width
```

## One object owns male and female geometry

```scad
joint = sliding_dovetail_create(
    width = 10,
    height = 3,
    angle = 20,
    clearance = 0.20,
    axial_clearance = 0.25,
    extra = 0.01,
    locking = false
);
```

The nominal male root is 10 mm wide and 3 mm deep. A 20° flank angle gives a
derived mouth width of about 7.82 mm.

## Male reference block

<!-- scad-render
view: male
-->

The red reference block represents a normal printed part with the male
dovetail protruding from its Y=0 face.

## Female reference block

<!-- scad-render
view: female
-->

The blue reference block is real solid geometry with the female channel cut
into it. It has an open X entry and a solid end stop.

## Approach

<!-- scad-render
view: approach
-->

The red male block approaches the blue female block from the side along +X.
There is no tilt or angled presentation motion.

## Assembled

<!-- scad-render
view: assembled
-->

The male is fully slid into the female channel. The two reference blocks meet
at the Y=0 interface plane.

## Female cutter

The public API exposes the female side as a subtraction volume because
consumers cut the interface into their own part:

```scad
sliding_dovetail_female_cutter(joint, slide = 16);
```

That cutter remains available as a technical debug view, but it is not the
normal design representation of the female side.

## Boolean overlap is not fit clearance

`extra=0.01` extends geometry only across union/difference boundaries and
slightly beyond the slide ends. It does not change the nominal profile.

## Locking is optional

The base interface uses `locking=false`. A future locking mode can add the
male recess, a flexible female threshold and screwdriver-release access without
changing the base interface API.
