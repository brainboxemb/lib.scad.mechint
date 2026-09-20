// lib.scad.mechint interactive sliding-dovetail workspace.
//
// Open this file directly in OpenSCAD. The Customizer exposes the complete
// public sliding_dovetail_create() interface plus focused reference views.

use <openscad/sliding-dovetail/sliding_dovetail.scad>
use <openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>
use <openscad/sliding-dovetail/assemblies/sliding_dovetail_test_assembly.scad>
use <ext/lib.scad.util/openscad/inspection.scad>

/* [View] */
view = "lock-section"; // [male,female,approach,assembled,assembled-section,lock-section]

/* [Sliding dovetail] */
width = 10;              // [4:0.25:30]
height = 3;              // [1:0.25:10]
angle = 20;              // [5:1:45]
clearance = 0.20;        // [0:0.05:1]
axial_clearance = 0.25;  // [0:0.05:2]
extra = 0.01;            // [0:0.01:0.10]
slide = 16;              // [6:1:40]

/* [Lock] */
locking = true;
lock_entry_offset = 0;            // [0:0.25:8]
lock_width = 4.0;               // [2:0.25:8]
lock_recess_length = 1.0;       // [0.5:0.25:4]
lock_recess_depth = 0.6;        // [0.25:0.05:2]
lock_threshold_length = 1.5;    // [0.5:0.25:4]
lock_threshold_height = 0.5;    // [0.25:0.05:1.5]
lock_ramp_length = 1.0;         // [0.25:0.25:3]
lock_spring_length = 5.5;       // [3:0.5:14]
lock_spring_thickness = 1.2;    // [0.6:0.1:4]
lock_spring_relief = 0.8;       // [0.4:0.1:2]
lock_spring_hinge_length = 0;   // [0:0.25:6]
lock_spring_hinge_thickness = 0.8; // [0.4:0.1:3]
lock_cut_back_clearance = true;
lock_back_clearance = 0.8;      // [0:0.1:3]
lock_release_access = true;
lock_release_depth = 0.6;       // [0.25:0.05:2]

/* [Reference blocks] */
female_block_length = 24; // [12:1:50]
female_block_depth = 7;   // [4:0.5:20]
block_width = 16;         // [12:1:40]
male_block_depth = 4;     // [2:0.5:12]
approach_gap = 4;         // [0:0.5:15]

/* [Section] */
section_depth = 0.20;     // [0.1:0.05:2]

joint =
    sliding_dovetail_create(
        width = width,
        height = height,
        angle = angle,
        clearance = clearance,
        axial_clearance = axial_clearance,
        extra = extra,
        locking = locking,
        lock_entry_offset = lock_entry_offset,
        lock_width = lock_width,
        lock_recess_length = lock_recess_length,
        lock_recess_depth = lock_recess_depth,
        lock_threshold_length = lock_threshold_length,
        lock_threshold_height = lock_threshold_height,
        lock_ramp_length = lock_ramp_length,
        lock_spring_length = lock_spring_length,
        lock_spring_thickness = lock_spring_thickness,
        lock_spring_relief = lock_spring_relief,
        lock_spring_hinge_length = lock_spring_hinge_length,
        lock_spring_hinge_thickness = lock_spring_hinge_thickness,
        lock_cut_back_clearance = lock_cut_back_clearance,
        lock_back_clearance = lock_back_clearance,
        lock_release_access = lock_release_access,
        lock_release_depth = lock_release_depth
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

is_fit_section = view == "assembled-section";
is_lock_section = view == "lock-section";
lock_section_center_x =
    lock_entry_offset
    + lock_spring_length / 2;

$vpt = is_fit_section
    ? [slide / 2, 1.5, 0]
    : is_lock_section
        ? [lock_section_center_x, 3.5, 0]
        : [female_block_length / 3, 1.5, 0];

$vpr = is_fit_section
    ? [0, 90, 0]
    : is_lock_section
        ? [0, 0, 0]
        : [72, 0, 35];

$vpd = is_fit_section
    ? 55
    : is_lock_section
        ? 36
        : 90;

if (is_fit_section) {
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
} else if (is_lock_section) {
    util_section_inspect(
        axis = "Z",
        position = -section_depth / 2,
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
