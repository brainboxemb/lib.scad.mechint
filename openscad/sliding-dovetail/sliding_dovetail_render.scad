// Render/design adapter for the public sliding-dovetail API.

use <../sliding_dovetail.scad>
use <reference/sliding_dovetail_reference.scad>

module sliding_dovetail_render(
    obj = sliding_dovetail_create(),
    view = "approach",
    slide_len_mm = 16
) {
    reference =
        sliding_dovetail_reference_create(
            obj = obj,
            slide_len_mm = slide_len_mm
        );

    if (view == "male") {
        color([0.88, 0.10, 0.06, 1])
            sliding_dovetail_reference_male_build(reference);
    } else if (view == "female") {
        color([0.28, 0.50, 0.82, 1])
            sliding_dovetail_reference_female_build(reference);
    } else if (view == "approach") {
        sliding_dovetail_reference_pair_build(
            reference,
            position = "approach"
        );
    } else if (view == "assembled") {
        sliding_dovetail_reference_pair_build(
            reference,
            position = "assembled"
        );
    } else if (view == "female-cutter") {
        color([0.10, 0.35, 0.85, 0.75])
            sliding_dovetail_female_cutter(
                obj,
                slide_len_mm = slide_len_mm
            );
    } else {
        assert(
            false,
            str(
                "Unknown sliding dovetail render view: ",
                view
            )
        );
    }
}

module sliding_dovetail_design(view = "approach") {
    sliding_dovetail_render(
        obj = sliding_dovetail_create(),
        view = view,
        slide_len_mm = 16
    );
}



module sliding_dovetail_lock_design(view = "female") {
    sliding_dovetail_render(
        obj = sliding_dovetail_create(
            is_locking_enabled = true,
            lock_spring_len_mm = 5.5,
            lock_has_back_clearance = true,
            lock_has_release_access = true
        ),
        view = view,
        slide_len_mm = 16
    );
}


module _sliding_dovetail_hinge_female_cutaway(obj) {
    intersection() {
        sliding_dovetail_reference_female_build(obj);

        translate([-1, -1, 0])
            cube([
                obj.female_block_len_mm + 2,
                obj.female_block_depth_mm + 2,
                obj.block_width_mm / 2 + 1
            ]);
    }
}


module _sliding_dovetail_hinge_male_cutaway(obj, position = "assembled") {
    male_x_mm =
        sliding_dovetail_reference_male_x_mm(
            obj,
            position
        );

    intersection() {
        translate([male_x_mm, 0, 0])
            sliding_dovetail_reference_male_build(obj);

        translate([
            -obj.slide_len_mm - 2,
            -obj.male_block_depth_mm - 1,
            0
        ])
            cube([
                obj.female_block_len_mm
                    + 2 * obj.slide_len_mm
                    + 4,
                obj.female_block_depth_mm
                    + obj.male_block_depth_mm
                    + 2,
                obj.block_width_mm / 2 + 1
            ]);
    }
}


module sliding_dovetail_hinge_design(view = "overview") {
    // 3.3 mm total tongue, 0.8 mm centered flex web.
    spring_thickness_mm = 3.3;

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
        );

    reference =
        sliding_dovetail_reference_create(
            obj = joint,
            slide_len_mm = 16,
            female_block_len_mm = 42,
            female_block_depth_mm =
                sliding_dovetail_female_height_mm(joint)
                + spring_thickness_mm,
            block_width_mm = 16
        );

    if (view == "overview") {
        color([0.28, 0.50, 0.82, 1])
            sliding_dovetail_reference_female_build(reference);

    } else if (view == "cutaway") {
        color([0.28, 0.50, 0.82, 1])
            _sliding_dovetail_hinge_female_cutaway(reference);

    } else if (view == "assembled-cutaway") {
        color([0.28, 0.50, 0.82, 1])
            _sliding_dovetail_hinge_female_cutaway(reference);

        color([0.88, 0.10, 0.06, 1])
            _sliding_dovetail_hinge_male_cutaway(
                reference,
                position = "assembled"
            );

    } else {
        assert(
            false,
            str("Unknown hinge-relief design view: ", view)
        );
    }
}

/* [Design view] */
view = "approach"; // [approach,assembled,male,female,female-cutter]

sliding_dovetail_design(view = view);
