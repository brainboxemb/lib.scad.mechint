use <../../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>
use <00-sliding-dovetail-fixture-orientation.scad>

joint =
    sliding_dovetail_create(
        is_locking_enabled = true,
        lock_spring_len_mm = 5.5,
        lock_has_back_clearance = true,
        lock_has_release_access = true
    );

reference =
    sliding_dovetail_reference_create(
        obj = joint
    );

sliding_dovetail_fixture_female_inspection(reference)
    sliding_dovetail_reference_female_build(reference);
