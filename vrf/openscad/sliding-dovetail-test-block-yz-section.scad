use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../fixtures/sliding_dovetail_test_block.scad>

fixture =
    sliding_dovetail_test_block_create();

$vpt = [8, 1.6, 0];
$vpr = [0, 90, 0];
$vpd = 55;

util_section_inspect(
    axis = "X",
    position = 7.9,
    depth = 0.2,
    direction = "Positive"
)
    sliding_dovetail_test_pair_build(
        fixture,
        male_position = "inserted"
    );
