use <../fixtures/sliding_dovetail_test_block.scad>

fixture =
    sliding_dovetail_test_block_create();

$vpt = [2, 2.5, 0];
$vpr = [72, 0, 35];
$vpd = 90;

sliding_dovetail_test_pair_build(
    fixture,
    male_position = "approach"
);
