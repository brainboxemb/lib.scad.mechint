// Reference geometry for visualising and verifying the sliding-dovetail API.
//
// This file is deliberately outside the core sliding_dovetail.scad API. It
// provides two simple printed-part stand-ins:
//   - a male reference block with the dovetail protruding from its Y=0 face;
//   - a female reference block with the mating channel cut into its Y=0 face.
//
// Native interface coordinates remain:
//   X = slide direction
//   Y = profile depth
//   Z = profile width

use <../sliding_dovetail.scad>

function sliding_dovetail_reference_create(
    joint = sliding_dovetail_create(),
    slide = 16,
    female_block_length = 24,
    female_block_depth = 7,
    block_width = 16,
    male_block_depth = 4,
    approach_gap = 4
) =
    assert(
        female_block_length
            > sliding_dovetail_female_slide(joint, slide),
        "female reference block must leave material for an end stop"
    )
    assert(
        female_block_depth
            > sliding_dovetail_female_height(joint),
        "female reference block must leave a rear wall"
    )
    assert(
        block_width
            > sliding_dovetail_female_root_width(joint),
        "reference blocks must leave side walls around the interface"
    )
    assert(
        male_block_depth > 0,
        "male reference block depth must be > 0"
    )
    assert(
        approach_gap >= 0,
        "reference approach gap must be >= 0"
    )
    object(
        joint = joint,
        slide = slide,
        female_block_length = female_block_length,
        female_block_depth = female_block_depth,
        block_width = block_width,
        male_block_depth = male_block_depth,
        approach_gap = approach_gap
    );

function sliding_dovetail_reference_female_channel_length(reference) =
    sliding_dovetail_female_slide(
        reference.joint,
        reference.slide
    );

function sliding_dovetail_reference_male_x(
    reference,
    position = "assembled"
) =
    position == "assembled"
        ? reference.slide / 2
        : position == "approach"
            ? -reference.slide / 2 - reference.approach_gap
            : assert(
                false,
                str(
                    "Unknown sliding-dovetail reference position: ",
                    position
                )
            ) 0;

module sliding_dovetail_reference_female_build(reference) {
    channel_length =
        sliding_dovetail_reference_female_channel_length(reference);

    difference() {
        translate([
            0,
            0,
            -reference.block_width / 2
        ])
            cube([
                reference.female_block_length,
                reference.female_block_depth,
                reference.block_width
            ]);

        // The public cutter is centered on X. Shift it so the female channel
        // opens through the block's X=0 side and leaves a solid +X end stop.
        translate([
            channel_length / 2,
            0,
            0
        ])
            sliding_dovetail_female_cutter(
                reference.joint,
                slide = reference.slide
            );
    }
}

module sliding_dovetail_reference_male_build(reference) {
    union() {
        translate([
            -reference.slide / 2,
            -reference.male_block_depth,
            -reference.block_width / 2
        ])
            cube([
                reference.slide,
                reference.male_block_depth,
                reference.block_width
            ]);

        sliding_dovetail_male_build(
            reference.joint,
            slide = reference.slide
        );
    }
}

module sliding_dovetail_reference_pair_build(
    reference,
    position = "assembled",
    male_color = [0.88, 0.10, 0.06, 1],
    female_color = [0.28, 0.50, 0.82, 1]
) {
    color(female_color)
        sliding_dovetail_reference_female_build(reference);

    translate([
        sliding_dovetail_reference_male_x(
            reference,
            position
        ),
        0,
        0
    ])
        color(male_color)
            sliding_dovetail_reference_male_build(reference);
}
