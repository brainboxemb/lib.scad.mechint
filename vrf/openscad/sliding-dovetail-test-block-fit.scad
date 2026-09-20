use <../fixtures/sliding_dovetail_test_block.scad>

fixture =
    sliding_dovetail_test_block_create();

$vpt = [10, 2.5, 0];
$vpr = [72, 0, 35];
$vpd = 70;

sliding_dovetail_test_pair_build(
    fixture,
    male_position = "inserted"
);
