// Shared centered two-sided hinge-relief verification geometry.

use <../../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../../openscad/sliding-dovetail/reference/sliding_dovetail_obj.scad>

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
        obj = joint,
        slide_len_mm = 16,
        female_block_len_mm = 42,
        female_block_depth_mm_mm =
            sliding_dovetail_female_height_mm(joint)
            + spring_thickness_mm,
        block_width_mm = 16
    );


module sliding_dovetail_hinge_fixture_female(obj) {
    sliding_dovetail_reference_female_build(obj);
}


module sliding_dovetail_hinge_fixture_female_cutaway(obj) {
    intersection() {
        sliding_dovetail_reference_female_build(obj);

        translate([-1, -1, 0])
            cube([
                obj.female_block_len_mm + 2,
                obj.female_block_depth_mm_mm + 2,
                obj.block_width_mm / 2 + 1
            ]);
    }
}


module sliding_dovetail_hinge_fixture_assembled_cutaway(obj) {
    male_x_mm =
        sliding_dovetail_reference_male_x_mm(
            obj,
            "assembled"
        );

    intersection() {
        union() {
            sliding_dovetail_reference_female_build(obj);

            translate([male_x_mm, 0, 0])
                sliding_dovetail_reference_male_build(obj);
        }

        translate([
            -obj.slide_len_mm - 2,
            -obj.male_block_depth_mm - 1,
            0
        ])
            cube([
                obj.female_block_len_mm
                    + 2 * obj.slide_len_mm
                    + 4,
                obj.female_block_depth_mm_mm
                    + obj.male_block_depth_mm
                    + 2,
                obj.block_width_mm / 2 + 1
            ]);
    }
}
