use <../../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>
use <00-sliding-dovetail-fixture-orientation.scad>

joint =
    sliding_dovetail_create(
        is_locking_enabled = true,
        lock_spring_len_mm = 5.5
    );

reference =
    sliding_dovetail_reference_create(
        joint = joint
    );

sliding_dovetail_fixture_male_inspection(reference)
    sliding_dovetail_reference_male_build(reference);
