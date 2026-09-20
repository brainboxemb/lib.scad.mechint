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
    } else if (view == "female") {
        color([0.28, 0.50, 0.82, 1])
            _sliding_dovetail_example_female_block(
                joint = joint,
                slide = slide
            );
    } else if (view == "female-cutter") {
        color([0.10, 0.35, 0.85, 0.75])
            sliding_dovetail_female_cutter(
                joint,
                slide = slide
            );
    } else if (view == "pair") {
        // Show the real mating parts in their slide relationship:
        // female block at the right, male approaching from the left along X.
        color([0.28, 0.50, 0.82, 1])
            _sliding_dovetail_example_female_block(
                joint = joint,
                slide = slide
            );

        translate([
            -slide / 2 - 6,
            0,
            0
        ])
            color([0.88, 0.10, 0.06, 1])
                sliding_dovetail_male_build(
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

module _sliding_dovetail_example_female_block(
    joint,
    slide,
    block_length = 24,
    block_depth = 7,
    block_width = 16
) {
    channel_length =
        sliding_dovetail_female_slide(
            joint,
            slide
        );

    assert(
        block_length > channel_length,
        "example female block must leave material for an end stop"
    );
    assert(
        block_depth > sliding_dovetail_female_height(joint),
        "example female block must leave a rear wall"
    );
    assert(
        block_width > sliding_dovetail_female_root_width(joint),
        "example female block must leave side walls"
    );

    difference() {
        translate([
            0,
            0,
            -block_width / 2
        ])
            cube([
                block_length,
                block_depth,
                block_width
            ]);

        // Open entry at X=0; solid end stop remains at +X.
        translate([
            channel_length / 2,
            0,
            0
        ])
            sliding_dovetail_female_cutter(
                joint,
                slide = slide
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
view = "pair"; // [pair,male,female,female-cutter]

sliding_dovetail_design(view = view);
