// Lock hinge-relief verification.
// A thick female spring keeps a flat outer face. The root side enters through a
// short straight wall and 45-degree shoulder, a thin flat flex land follows,
// then a calculated ramp returns to full thickness before the locking threshold.

use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>

spring_thickness = 3.3;
hinge_thickness = 0.8;
hinge_length = 1.65;

joint =
    sliding_dovetail_create(
        width = 12,
        height = 2,
        angle = 30,
        root_land_depth = 0.5,
        mouth_land_depth = 0.5,
        entry_slot_length = 16,
        locking = true,
        lock_spring_length = 7,
        lock_spring_thickness = spring_thickness,
        lock_spring_hinge_length = hinge_length,
        lock_spring_hinge_thickness = hinge_thickness,
        lock_cut_back_clearance = false,
        lock_release_access = true
    );

reference =
    sliding_dovetail_reference_create(
        joint = joint,
        slide = 16,
        female_block_length = 42,
        female_block_depth =
            sliding_dovetail_female_height(joint)
            + spring_thickness
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
