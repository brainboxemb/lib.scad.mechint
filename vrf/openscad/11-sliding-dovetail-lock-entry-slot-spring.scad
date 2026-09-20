// Lock + entry-slot verification.
// A thin XZ section through the female spring thickness must show a real
// U-shaped tongue: two longitudinal side reliefs plus one transverse entry cut.

use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>

joint =
    sliding_dovetail_create(
        entry_slot_length = 16,
        locking = true,
        lock_spring_length = 5.5,
        lock_cut_back_clearance = true,
        lock_release_access = true
    );

reference =
    sliding_dovetail_reference_create(
        joint = joint,
        slide = 16,
        female_block_length = 42
    );

section_y =
    sliding_dovetail_female_height(joint)
    + 0.6;

$vpt = [19, section_y, 0];
$vpr = [90, 0, 0];
$vpd = 58;

util_section_inspect(
    axis = "Y",
    position = section_y - 0.1,
    depth = 0.2,
    direction = "Positive"
)
    sliding_dovetail_reference_female_build(reference);
