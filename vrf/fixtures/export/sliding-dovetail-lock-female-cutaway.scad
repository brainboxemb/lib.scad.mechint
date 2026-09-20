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

// Keep the +Z half so the center plane exposes the threshold and spring cavity.
intersection() {
    sliding_dovetail_reference_female_build(reference);

    translate([-1, -1, 0])
        cube([
            reference.female_block_length + 2,
            reference.female_block_depth + 2,
            reference.block_width / 2 + 1
        ]);
}
