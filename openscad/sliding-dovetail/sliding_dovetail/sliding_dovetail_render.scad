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

/* [Design view] */
view = "approach"; // [approach,assembled,male,female,female-cutter]

sliding_dovetail_design(view = view);
