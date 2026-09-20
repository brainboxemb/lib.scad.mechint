use <../../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>
use <00-sliding-dovetail-fixture-orientation.scad>

joint =
    sliding_dovetail_create(
        locking = true
    );

reference =
    sliding_dovetail_reference_create(
        joint = joint
    );

sliding_dovetail_fixture_male_inspection(reference)
    sliding_dovetail_reference_male_build(reference);
