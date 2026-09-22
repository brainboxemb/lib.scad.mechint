// Lock + entry-slot verification.
// A thin XZ section through the female spring thickness must show a real
// U-shaped tongue: two longitudinal side reliefs plus one transverse entry cut.

use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../../openscad/sliding_dovetail.scad>
use <../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>

joint =
    sliding_dovetail_create(
        entry_slot_len_mm = 16,
        is_locking_enabled = true,
        lock_spring_len_mm = 5.5,
        lock_has_back_clearance = true,
        lock_has_release_access = true
    );

reference =
    sliding_dovetail_reference_create(
        obj = joint,
        slide_len_mm = 16,
        female_block_len_mm = 42
    );

section_y_mm =
    sliding_dovetail_female_height_mm(joint)
    + 0.6;

$vpt = [19, section_y_mm, 0];
$vpr = [90, 0, 0];
$vpd = 58;

util_section_inspect(
    axis = "Y",
    position = section_y_mm - 0.1,
    depth = 0.2,
    direction = "Positive"
)
    sliding_dovetail_reference_female_build(reference);
