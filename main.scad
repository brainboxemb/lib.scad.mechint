// lib.scad.mechint interactive sliding-dovetail workspace.
//
// Open this file directly in OpenSCAD. Use the Customizer to inspect the
// reference male/female blocks, insertion direction and assembled fit.

use <openscad/sliding-dovetail/sliding_dovetail_lock.scad>
use <openscad/sliding-dovetail/sliding_dovetail.scad>
use <openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>
use <openscad/sliding-dovetail/assemblies/sliding_dovetail_test_assembly.scad>
use <ext/lib.scad.util/openscad/inspection.scad>

/* [View] */
view = "approach"; // [male,female,approach,assembled,assembled-section]

/* [Sliding dovetail] */
width = 10;              // [4:0.25:30]
height = 3;              // [1:0.25:10]
angle = 20;              // [5:1:45]
clearance = 0.20;        // [0:0.05:1]
axial_clearance = 0.25;  // [0:0.05:2]
extra = 0.01;            // [0:0.01:0.10]
slide = 16;              // [6:1:40]

/* [Lock] */
lock_enabled = false;

/* [Reference blocks] */
female_block_length = 24; // [12:1:50]
female_block_depth = 7;   // [4:0.5:20]
block_width = 16;         // [12:1:40]
male_block_depth = 4;     // [2:0.5:12]
approach_gap = 4;         // [0:0.5:15]

/* [Section] */
section_depth = 0.20;     // [0.05:0.05:2]

lock =
    sliding_dovetail_lock_create(
        enabled = lock_enabled
    );

joint =
    sliding_dovetail_create(
        width = width,
        height = height,
        angle = angle,
        clearance = clearance,
        axial_clearance = axial_clearance,
        extra = extra,
        lock = lock
    );

reference =
    sliding_dovetail_reference_create(
        joint = joint,
        slide = slide,
        female_block_length = female_block_length,
        female_block_depth = female_block_depth,
        block_width = block_width,
        male_block_depth = male_block_depth,
        approach_gap = approach_gap
    );

$vpt = view == "assembled-section"
    ? [slide / 2, 1.5, 0]
    : [female_block_length / 3, 1.5, 0];

$vpr = view == "assembled-section"
    ? [0, 90, 0]
    : [72, 0, 35];

$vpd = view == "assembled-section"
    ? 55
    : 90;

if (view == "assembled-section") {
    util_section_inspect(
        axis = "X",
        position = slide / 2 - section_depth / 2,
        depth = section_depth,
        direction = "Positive"
    )
        sliding_dovetail_test_assembly_build(
            reference,
            view = "assembled"
        );
} else {
    sliding_dovetail_test_assembly_build(
        reference,
        view = view
    );
}
