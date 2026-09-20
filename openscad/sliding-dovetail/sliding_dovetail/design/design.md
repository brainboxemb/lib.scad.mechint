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

female entry = -X
insertion = +X
end stop = +X
```

## One object owns the complete interface

Normal consumers configure the male/female interface once:

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
sliding_dovetail_female_cutter(joint, slide = 16);
```

That cutter remains available as a technical debug view, but it is not the
normal design representation of the female side.

## Boolean overlap is not fit clearance

`extra=0.01` extends geometry only across union/difference boundaries and
slightly beyond the slide ends. It does not change the nominal profile.

## Optional lock

```scad
joint = sliding_dovetail_create(
    locking = true,
    lock_cut_back_clearance = true,
    lock_release_access = true
);
```

`lock_entry_offset` measures the start of the threshold ramp from the fixed
-X female entry side. At the default 0 mm the ramp starts directly at the edge.
The assembled male receives the matching recess from the same entry-side
definition. The threshold's -X face is ramped; the opposite face forms the
locking stop.

Two longitudinal relief cuts run from the entry edge toward +X. Because the
threshold starts at the edge, no transverse free-end cut is needed; the tongue
remains anchored toward +X.

When `lock_cut_back_clearance` is enabled, the female cutter also removes a
cavity behind the tongue so it can deflect by at least the threshold height.
When it is disabled, the tongue can remain full-depth to a flat outer face.

An optional hinge relief handles thick hosts without adding a rear cavity.
`lock_spring_hinge_length` controls the root-side transition envelope and
`lock_spring_hinge_thickness` controls the minimum flex-land thickness.

The threshold/lip end deliberately returns to **full host thickness** before the
locking feature. From the fixed root toward the lip, the relief has a short
straight root wall, a 45-degree shoulder, a flat minimum-thickness flex land,
a calculated return ramp and finally a full-depth threshold land. The return
angle is derived from the available spring length; it is 45 degrees in the
3.3 / 0.8 / 3.0 mm verification example. This keeps the outer face flat and
avoids both a sharp V notch and a thin strip apparently floating under the lip.
A hinge length of 0 keeps the previous geometry exactly.

### Flat-back hinge-relief example

The example below deliberately uses a **3.3 mm** thick female spring, a
**3.0 mm** root-transition envelope and a **0.8 mm** minimum flex thickness.
The locking threshold is **1.5 mm** long and remains full-depth. Back clearance
is disabled. These dimensions make both transition ramps 45 degrees while still
leaving a short flat flex land between them.

<!-- scad-render
module: sliding_dovetail_hinge_design
view: overview
-->

The outside/back face remains one flat supported surface. There is no horizontal
cavity under it.

<!-- scad-render
module: sliding_dovetail_hinge_design
view: cutaway
-->

The center cutaway should show the full sequence clearly: straight root wall,
45-degree root shoulder, short flat flex land, return ramp, then a full-depth
flat land immediately before and underneath the locking threshold.

<!-- scad-render
module: sliding_dovetail_hinge_design
view: assembled-cutaway
-->

The assembled cutaway shows the same female together with the locking male, so
the hinge relief can be read in relation to the threshold and male recess.

Matching inspectable STL fixtures are published as verification fixtures
15–17: full female, female cutaway and assembled cutaway.

`lock_release_access` extends the male recess to the -X entry edge using the
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
