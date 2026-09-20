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

The angle is deliberately moderate: enough undercut for mechanical retention,
without turning a shallow 3 mm printed interface into a 45° wedge.

## Male profile

<!-- scad-render
view: male
-->

The example slide is 16 mm long along X.

## Actual male and female parts

<!-- scad-render
view: pair
-->

The blue part is now an **actual female example block**: solid material with the
female dovetail subtracted from it, open at the X entry side and with a solid
end stop. The red male is shown approaching along the same X slide axis.

The public library still exposes the female side as a cutter because consumers
subtract it from their own geometry. The cutter itself is only a debug view:

```scad
sliding_dovetail_female_cutter(joint, slide = 16);
```

## Female example block

<!-- scad-render
view: female
-->

This view shows the female geometry by itself without the male in front of it.

## Boolean overlap is not fit clearance

`extra=0.01` extends geometry only across union/difference boundaries and
slightly beyond the slide ends. It does not change the nominal profile.

## Locking is optional

The base interface uses `locking=false`. A future locking mode can add the
male recess, a flexible female threshold and screwdriver-release access without
changing the base interface API.
