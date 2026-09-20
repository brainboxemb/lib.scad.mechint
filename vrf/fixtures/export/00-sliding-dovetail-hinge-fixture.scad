// Shared flat-back hinge-relief verification geometry.

use <../../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>

function sliding_dovetail_hinge_fixture_reference() =
    let(
        spring_thickness = 3.3,
        joint =
            sliding_dovetail_create(
                width = 12,
                height = 2,
                angle = 30,
                root_land_depth = 0.5,
                mouth_land_depth = 0.5,
                entry_slot_length = 16,
                locking = true,
                lock_spring_length = 7,
                lock_spring_thickness = spring_thickness,
                lock_spring_hinge_length = 3.0,
                lock_spring_hinge_thickness = 0.8,
                lock_cut_back_clearance = false,
                lock_release_access = true
            )
    )
    sliding_dovetail_reference_create(
        joint = joint,
        slide = 16,
        female_block_length = 42,
        female_block_depth =
            sliding_dovetail_female_height(joint)
            + spring_thickness,
        block_width = 16
    );


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
            -reference.slide - 2,
            -reference.male_block_depth - 1,
            0
        ])
            cube([
                reference.female_block_length
                    + 2 * reference.slide
                    + 4,
                reference.female_block_depth
                    + reference.male_block_depth
                    + 2,
                reference.block_width / 2 + 1
            ]);
    }
}
