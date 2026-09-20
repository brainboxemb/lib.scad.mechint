use <../../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>
use <00-sliding-dovetail-fixture-orientation.scad>

reference =
    sliding_dovetail_reference_create();

sliding_dovetail_fixture_male_inspection(reference)
    sliding_dovetail_reference_male_build(reference);
