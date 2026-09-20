// Render/design adapter for the public sliding-dovetail API.

use <../sliding_dovetail.scad>

module sliding_dovetail_render(
    joint = sliding_dovetail_create(),
    view = "pair",
    slide = 16
) {
    if (view == "male") {
        color([0.88, 0.10, 0.06, 1])
            sliding_dovetail_male_build(
                joint,
                slide = slide
            );
    } else if (view == "female-cutter") {
        color([0.10, 0.35, 0.85, 0.75])
            sliding_dovetail_female_cutter(
                joint,
                slide = slide
            );
    } else if (view == "pair") {
        translate([0, 0, 7])
            color([0.88, 0.10, 0.06, 1])
                sliding_dovetail_male_build(
                    joint,
                    slide = slide
                );

        translate([0, 0, -7])
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

module sliding_dovetail_design(view = "pair") {
    sliding_dovetail_render(
        joint = sliding_dovetail_create(),
        view = view,
        slide = 16
    );
}


/* [Design view] */
view = "pair"; // [pair,male,female-cutter]

sliding_dovetail_design(view = view);
