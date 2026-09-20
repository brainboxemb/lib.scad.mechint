# Sliding dovetail — design

<!-- scad-render-defaults
engine: openscad
source: ../sliding_dovetail_render.scad
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

The angle is deliberately moderate: enough undercut for mechanical retention,
without turning a shallow 3 mm printed interface into a 45° wedge.

## Male profile

<!-- scad-render
view: male
-->

The example slide is 16 mm long along X.

## Female geometry comes from the same object

<!-- scad-render
view: pair
-->

The blue geometry is the female cutter shown separately from the red male.
Clearance expands the female cavity while preserving the same flank angle.

## Boolean overlap is not fit clearance

`extra=0.01` extends geometry only across union/difference boundaries and
slightly beyond the slide ends. It does not change the nominal profile.

## Locking is optional

The base interface uses `locking=false`. A future locking mode can add the
male recess, a flexible female threshold and screwdriver-release access without
changing the base interface API.
