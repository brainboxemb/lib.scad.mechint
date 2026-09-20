use <../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>

reference =
    sliding_dovetail_reference_create();

$vpt = [10, 1.5, 0];
$vpr = [72, 0, 35];
$vpd = 72;

sliding_dovetail_reference_pair_build(
    reference,
    position = "assembled"
);
