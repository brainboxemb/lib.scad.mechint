use <../../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>

joint =
    sliding_dovetail_create(
        locking = true
    );

reference =
    sliding_dovetail_reference_create(
        joint = joint
    );

sliding_dovetail_reference_male_build(reference);
