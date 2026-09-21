// lib.scad.mechint interactive sliding-dovetail workspace.
//
// Open this file directly in OpenSCAD. The Customizer exposes the complete
// public sliding_dovetail_create() interface plus focused reference views.

use <openscad/sliding-dovetail/sliding_dovetail.scad>
use <openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>
use <openscad/sliding-dovetail/assemblies/sliding_dovetail_test_assembly.scad>
use <ext/lib.scad.util/openscad/inspection.scad>

/* [View] */
c_view = "lock-section"; // [male,female,approach,assembled,assembled-section,lock-section]

/* [Sliding dovetail] */
d_width_mm = 10;              // [4:0.25:30]
d_height_mm = 3;              // [1:0.25:10]
d_angle_deg = 20;              // [5:1:45]
d_clearance_mm = 0.20;        // [0:0.05:1]
d_axial_clearance_mm = 0.25;  // [0:0.05:2]
d_extra_mm = 0.01;            // [0:0.01:0.10]
d_slide_len_mm = 16;              // [6:1:40]

/* [Lock] */
d_is_locking_enabled = true;
d_lock_entry_offset_mm = 0;            // [0:0.25:8]
d_lock_width_mm = 4.0;               // [2:0.25:8]
d_lock_recess_len_mm = 1.0;       // [0.5:0.25:4]
d_lock_recess_depth_mm = 0.6;        // [0.25:0.05:2]
d_lock_threshold_len_mm = 1.5;    // [0.5:0.25:4]
d_lock_threshold_height_mm = 0.5;    // [0.25:0.05:1.5]
d_lock_ramp_len_mm = 1.0;         // [0.25:0.25:3]
d_lock_spring_len_mm = 5.5;       // [3:0.5:14]
d_lock_spring_thickness_mm = 1.2;    // [0.6:0.1:4]
d_lock_spring_relief_mm = 0.8;       // [0.4:0.1:2]
d_lock_spring_hinge_len_mm = 0;   // [0:0.25:6]
d_lock_spring_hinge_thickness_mm = 0.8; // [0.4:0.1:3]
d_lock_has_back_clearance = true;
d_lock_back_clearance_mm = 0.8;      // [0:0.1:3]
d_lock_has_release_access = true;
d_lock_release_depth_mm = 0.6;       // [0.25:0.05:2]

/* [Reference blocks] */
c_female_block_len_mm = 24; // [12:1:50]
c_female_block_depth_mm = 7;   // [4:0.5:20]
c_block_width_mm = 16;         // [12:1:40]
c_male_block_depth_mm = 4;     // [2:0.5:12]
c_approach_gap_mm = 4;         // [0:0.5:15]

/* [Section] */
c_section_depth_mm = 0.20;     // [0.1:0.05:2]

_joint =
    sliding_dovetail_create(
        width_mm = d_width_mm,
        height_mm = d_height_mm,
        angle_deg = d_angle_deg,
        clearance_mm = d_clearance_mm,
        axial_clearance_mm = d_axial_clearance_mm,
        extra_mm = d_extra_mm,
        is_locking_enabled = d_is_locking_enabled,
        lock_entry_offset_mm = d_lock_entry_offset_mm,
        lock_width_mm = d_lock_width_mm,
        lock_recess_len_mm = d_lock_recess_len_mm,
        lock_recess_depth_mm = d_lock_recess_depth_mm,
        lock_threshold_len_mm = d_lock_threshold_len_mm,
        lock_threshold_height_mm = d_lock_threshold_height_mm,
        lock_ramp_len_mm = d_lock_ramp_len_mm,
        lock_spring_len_mm = d_lock_spring_len_mm,
        lock_spring_thickness_mm = d_lock_spring_thickness_mm,
        lock_spring_relief_mm = d_lock_spring_relief_mm,
        lock_spring_hinge_len_mm = d_lock_spring_hinge_len_mm,
        lock_spring_hinge_thickness_mm = d_lock_spring_hinge_thickness_mm,
        lock_has_back_clearance = d_lock_has_back_clearance,
        lock_back_clearance_mm = d_lock_back_clearance_mm,
        lock_has_release_access = d_lock_has_release_access,
        lock_release_depth_mm = d_lock_release_depth_mm
    );

_reference =
    sliding_dovetail_reference_create(
        obj = _joint,
        slide_len_mm = d_slide_len_mm,
        female_block_len_mm = c_female_block_len_mm,
        female_block_depth_mm = c_female_block_depth_mm,
        block_width_mm = c_block_width_mm,
        male_block_depth_mm = c_male_block_depth_mm,
        approach_gap_mm = c_approach_gap_mm
    );

_is_fit_section = c_view == "assembled-section";
_is_lock_section = c_view == "lock-section";
_lock_section_center_x_mm =
    d_lock_entry_offset_mm
    + d_lock_spring_len_mm / 2;

$vpt = _is_fit_section
    ? [d_slide_len_mm / 2, 1.5, 0]
    : _is_lock_section
        ? [_lock_section_center_x_mm, 3.5, 0]
        : [c_female_block_len_mm / 3, 1.5, 0];

$vpr = _is_fit_section
    ? [0, 90, 0]
    : _is_lock_section
        ? [0, 0, 0]
        : [72, 0, 35];

$vpd = _is_fit_section
    ? 55
    : _is_lock_section
        ? 36
        : 90;

if (_is_fit_section) {
    util_section_inspect(
        axis = "X",
        position = d_slide_len_mm / 2 - c_section_depth_mm / 2,
        depth = c_section_depth_mm,
        direction = "Positive"
    )
        sliding_dovetail_test_assembly_build(
            _reference,
            view = "assembled"
        );
} else if (_is_lock_section) {
    util_section_inspect(
        axis = "Z",
        position = -c_section_depth_mm / 2,
        depth = c_section_depth_mm,
        direction = "Positive"
    )
        sliding_dovetail_test_assembly_build(
            _reference,
            view = "assembled"
        );
} else {
    sliding_dovetail_test_assembly_build(
        _reference,
        view = c_view
    );
}
