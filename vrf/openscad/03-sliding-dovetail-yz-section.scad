use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>

reference =
    sliding_dovetail_reference_create();

$vpt = [8, 1.5, 0];
$vpr = [0, 90, 0];
$vpd = 55;

util_section_inspect(
    axis = "X",
    position = 7.9,
    depth = 0.2,
    direction = "Positive"
)
    sliding_dovetail_reference_pair_build(
        reference,
        position = "assembled"
    );
