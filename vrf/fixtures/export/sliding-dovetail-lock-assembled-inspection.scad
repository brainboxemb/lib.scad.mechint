use <../../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>

joint =
    sliding_dovetail_create(
        locking = true,
        lock_cut_back_clearance = true,
        lock_release_access = true
    );

reference =
    sliding_dovetail_reference_create(
        joint = joint
    );

sliding_dovetail_reference_pair_build(
    reference,
    position = "assembled"
);
