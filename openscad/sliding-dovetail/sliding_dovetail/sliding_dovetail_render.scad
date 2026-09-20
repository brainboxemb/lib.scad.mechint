// Render/design adapter for the public sliding-dovetail API.

use <../sliding_dovetail.scad>
use <../reference/sliding_dovetail_reference.scad>

module sliding_dovetail_render(
    joint = sliding_dovetail_create(),
    view = "approach",
    slide = 16
) {
    reference =
        sliding_dovetail_reference_create(
            joint = joint,
            slide = slide
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
                joint,
                slide = slide
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
        joint = sliding_dovetail_create(),
        view = view,
        slide = 16
    );
}



module sliding_dovetail_lock_design(view = "female") {
    sliding_dovetail_render(
        joint = sliding_dovetail_create(
            locking = true,
            lock_spring_length = 5.5,
            lock_cut_back_clearance = true,
            lock_release_access = true
        ),
        view = view,
        slide = 16
    );
}


module _sliding_dovetail_hinge_female_cutaway(reference) {
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


module _sliding_dovetail_hinge_male_cutaway(reference, position = "assembled") {
    male_x =
        sliding_dovetail_reference_male_x(
            reference,
            position
        );

    intersection() {
        translate([male_x, 0, 0])
            sliding_dovetail_reference_male_build(reference);

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


module sliding_dovetail_hinge_design(view = "overview") {
    spring_thickness = 3.3;

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
            lock_spring_hinge_length = 2.5,
            lock_spring_hinge_thickness = 0.8,
            lock_cut_back_clearance = false,
            lock_release_access = true
        );

    reference =
        sliding_dovetail_reference_create(
            joint = joint,
            slide = 16,
            female_block_length = 42,
            female_block_depth =
                sliding_dovetail_female_height(joint)
                + spring_thickness,
            block_width = 16
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
