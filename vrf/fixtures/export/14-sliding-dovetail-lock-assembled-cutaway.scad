use <../../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>
use <00-sliding-dovetail-fixture-orientation.scad>

joint =
    sliding_dovetail_create(
        locking = true,
        lock_spring_length = 5.5,
        lock_cut_back_clearance = true,
        lock_release_access = true
    );

reference =
    sliding_dovetail_reference_create(
        joint = joint
    );

// Cut in native coordinates first so the Z=0 center plane exposes the complete
// assembled lock relationship, then orient the half-assembly for inspection.
sliding_dovetail_fixture_assembly_inspection(reference)
    intersection() {
        sliding_dovetail_reference_pair_build(
            reference,
            position = "assembled"
        );

        translate([
            -1,
            -reference.male_block_depth - 1,
            0
        ])
            cube([
                reference.female_block_length + 2,
                reference.female_block_depth
                    + reference.male_block_depth
                    + 2,
                reference.block_width / 2 + 1
            ]);
    }
