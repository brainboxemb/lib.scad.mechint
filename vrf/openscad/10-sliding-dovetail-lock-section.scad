use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>

joint =
    sliding_dovetail_create(
        is_locking_enabled = true,
        lock_spring_len_mm = 5.5,
        lock_has_back_clearance = true,
        lock_has_release_access = true
    );

reference =
    sliding_dovetail_reference_create(
        joint = joint
    );

$vpt = [3.5, 3.5, 0];
$vpr = [0, 0, 180];
$vpd = 36;

util_section_inspect(
    axis = "Z",
    position = -0.1,
    depth = 0.2,
    direction = "Positive"
)
    sliding_dovetail_reference_pair_build(
        reference,
        position = "assembled"
    );
