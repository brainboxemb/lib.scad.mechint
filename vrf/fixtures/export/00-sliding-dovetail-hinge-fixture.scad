// Shared centered two-sided hinge-relief verification geometry.

use <../../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>

function sliding_dovetail_hinge_fixture_reference() =
    let(
        spring_thickness_mm = 3.3,
        joint =
            sliding_dovetail_create(
                width_mm = 12,
                height_mm = 2,
                angle_deg = 30,
                root_land_depth_mm = 0.5,
                mouth_land_depth_mm = 0.5,
                entry_slot_len_mm = 16,
                is_locking_enabled = true,
                lock_spring_len_mm = 7,
                lock_spring_thickness_mm = spring_thickness_mm,
                lock_spring_hinge_len_mm = 1.65,
                lock_spring_hinge_thickness_mm = 0.8,
                lock_has_back_clearance = false,
                lock_has_release_access = true
            )
    )
    sliding_dovetail_reference_create(
        joint = joint,
        slide_len_mm = 16,
        female_block_length = 42,
        female_block_depth =
            sliding_dovetail_female_height_mm(joint)
            + spring_thickness_mm,
        block_width = 16
    );


module sliding_dovetail_hinge_fixture_female(reference) {
    sliding_dovetail_reference_female_build(reference);
}


module sliding_dovetail_hinge_fixture_female_cutaway(reference) {
    intersection() {
        sliding_dovetail_reference_female_build(reference);

        translate([-1, -1, 0])
            cube([
                reference.female_block_length + 2,
                reference.female_block_depth + 2,
                reference.block_width / 2 + 1
            ]);
    }
}


module sliding_dovetail_hinge_fixture_assembled_cutaway(reference) {
    male_x =
        sliding_dovetail_reference_male_x(
            reference,
            "assembled"
        );

    intersection() {
        union() {
            sliding_dovetail_reference_female_build(reference);

            translate([male_x, 0, 0])
                sliding_dovetail_reference_male_build(reference);
        }

        translate([
            -reference.slide_len_mm - 2,
            -reference.male_block_depth - 1,
            0
        ])
            cube([
                reference.female_block_length
                    + 2 * reference.slide_len_mm
                    + 4,
                reference.female_block_depth
                    + reference.male_block_depth
                    + 2,
                reference.block_width / 2 + 1
            ]);
    }
}
