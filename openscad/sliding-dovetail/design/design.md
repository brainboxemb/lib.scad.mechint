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
X = slide_len_mm direction
Y = profile depth
Z = profile width_mm

female entry = -X
insertion = +X
end stop = +X
```

## One object owns the complete interface

Normal consumers configure the male/female interface once:

```scad
joint = sliding_dovetail_create(
    width_mm = 10,
    height_mm = 3,
    angle_deg = 20,
    clearance_mm = 0.20,
    axial_clearance_mm = 0.25,
    extra_mm = 0.01,
    is_locking_enabled = false
);
```

When locking is enabled, this same constructor also initializes the lower-level
lock and spring configuration. Consumers do not need to construct those objects
separately.

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
sliding_dovetail_female_cutter(joint, slide_len_mm = 16);
```

That cutter remains available as a technical debug view, but it is not the
normal design representation of the female side.

## Boolean overlap is not fit clearance

`extra_mm=0.01` extends geometry only across union/difference boundaries and
slightly beyond the slide ends. It does not change the nominal profile.

## Optional lock

```scad
joint = sliding_dovetail_create(
    is_locking_enabled = true,
    lock_has_back_clearance = true,
    lock_has_release_access = true
);
```

`lock_entry_offset_mm` measures the start of the threshold ramp from the fixed
-X female entry side. At the default 0 mm the ramp starts directly at the edge.
The assembled male receives the matching recess from the same entry-side
definition. The threshold's -X face is ramped; the opposite face forms the
locking stop.

Two longitudinal relief cuts run from the entry edge toward +X. Because the
threshold starts at the edge, no transverse free-end cut is needed; the tongue
remains anchored toward +X.

When `lock_has_back_clearance` is enabled, the female cutter also removes a
cavity behind the tongue so it can deflect by at least the threshold height.
When it is disabled, the tongue can remain full-depth to a flat outer face.

An optional two-sided hinge relief handles thick hosts by moving the flex web
toward the middle of the tongue instead of thinning from only one face.
`lock_spring_hinge_len_mm` controls the local chamfer + flat-web envelope and
`lock_spring_hinge_thickness_mm` controls the total thickness of the centered
web left between the opposing pockets.

The locking threshold and fixed root remain full-depth. Each face uses a mostly
straight root wall, a local 45-degree chamfer, a short flat land and a calculated
return ramp. The two flat lands face each other and leave the flex web centered
through the material. The return ramps are constrained to 45 degrees maximum.
A hinge length of 0 keeps the previous geometry exactly.

### Centered hinge-relief example

The example below deliberately uses a **3.3 mm** thick female spring, a
**1.65 mm** chamfer/flat envelope and a **0.8 mm centered flex web**. The
locking threshold is **1.5 mm** long and remains full-depth. Back clearance is
disabled. Each face therefore approaches the central web from its own side,
while the root and threshold remain substantial. For a 4 mm host, a 2 mm envelope yields the
same proportion: **1 x 1 mm chamfer + 1 mm flat**.

<!-- scad-render
module: sliding_dovetail_hinge_design
view: overview
-->

The overview shows the two local surface openings. They are intentional: the
relief now approaches the hinge from both faces so the remaining flex web can
sit near the middle of the tongue.

<!-- scad-render
module: sliding_dovetail_hinge_design
view: cutaway
-->

The center cutaway should show the full sequence clearly on **both faces**:
mostly straight root wall, local 45-degree chamfer, short flat land and shallow
return ramp, leaving a centered web before the geometry returns to full
thickness under the locking threshold.

<!-- scad-render
module: sliding_dovetail_hinge_design
view: assembled-cutaway
-->

The assembled cutaway shows the same female together with the locking male, so
the hinge relief can be read in relation to the threshold and male recess.

Matching inspectable STL fixtures are published as verification fixtures
15–17: full female, female cutaway and assembled cutaway.

`lock_has_release_access` extends the male recess to the -X entry edge using the
same width as the recess. This gives a small flat screwdriver a straight path
to lift the female tongue without a narrow/wide transition. It remains
independent from the female spring cavity.

## Locking female

<!-- scad-render
module: sliding_dovetail_lock_design
view: female
-->

This view shows the female reference block with the ramped threshold, spring
isolation cuts and optional cavity produced by the same top-level interface.

## Lock assembled

<!-- scad-render
module: sliding_dovetail_lock_design
view: assembled
-->

The assembled view checks the overall relationship between the locking male and
female. The verification output adds a thin XY section through the centerline
for inspecting the recess, threshold and spring cavity in detail.
