// Lock hinge-relief verification.
// Opposing local pockets approach the tongue from both faces, leaving a short
// centered flex web. Root and threshold remain full-depth; each pocket uses a
// local 45-degree chamfer, short flat land and calculated return ramp.

use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>

spring_thickness_mm = 3.3;
hinge_thickness = 0.8;
hinge_length = 1.65;

joint =
    sliding_dovetail_create(
        width_mm = 12,
        height_mm = 2,
        angle_deg = 30,
        root_land_depth_mm = 0.5,
        mouth_land_depth_mm = 0.5,
        entry_slot_len_mm = 16,
        is_locking_enabled = true,
        lock_spring_len_mm = 7,
        lock_spring_thickness_mm = spring_thickness_mm,
        lock_spring_hinge_len_mm = hinge_length,
        lock_spring_hinge_thickness_mm = hinge_thickness,
        lock_has_back_clearance = false,
        lock_has_release_access = true
    );

reference =
    sliding_dovetail_reference_create(
        joint = joint,
        slide_len_mm = 16,
        female_block_length = 42,
        female_block_depth =
            sliding_dovetail_female_height_mm(joint)
            + spring_thickness_mm
    );

$vpt = [18.5, 3.8, 0];
$vpr = [0, 0, 0];
$vpd = 46;

util_section_inspect(
    axis = "Z",
    position = -0.1,
    depth = 0.2,
    direction = "Positive"
)
    sliding_dovetail_reference_female_build(reference);
