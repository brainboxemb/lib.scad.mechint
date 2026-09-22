use <../../../openscad/sliding_dovetail.scad>
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
            -reference.male_block_depth_mm - 1,
            0
        ])
            cube([
                reference.female_block_len_mm + 2,
                reference.female_block_depth_mm
                    + reference.male_block_depth_mm
                    + 2,
                reference.block_width_mm / 2 + 1
            ]);
    }
