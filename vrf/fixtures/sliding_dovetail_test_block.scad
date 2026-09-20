// Focused verification fixture for the sliding-dovetail interface.

use <../../openscad/sliding-dovetail/sliding_dovetail.scad>

function sliding_dovetail_test_block_create(
    joint = sliding_dovetail_create(),
    slide = 16,
    block_length = 24,
    block_depth = 7,
    block_width = 16
) =
    assert(block_length > sliding_dovetail_female_slide(joint, slide),
        "test block must leave material for an end stop")
    assert(block_depth > sliding_dovetail_female_height(joint),
        "test block must leave a rear wall")
    assert(block_width > sliding_dovetail_female_root_width(joint),
        "test block must leave side walls")
    object(
        joint = joint,
        slide = slide,
        block_length = block_length,
        block_depth = block_depth,
        block_width = block_width
    );

module sliding_dovetail_test_block_build(fixture) {
    channel_length =
        sliding_dovetail_female_slide(
            fixture.joint,
            fixture.slide
        );

    difference() {
        translate([
            0,
            0,
            -fixture.block_width / 2
        ])
            cube([
                fixture.block_length,
                fixture.block_depth,
                fixture.block_width
            ]);

        // Shift the centered public cutter so its nominal left end starts at
        // X=0. joint.extra then carries the subtraction slightly beyond the
        // block face for a robust open entry.
        translate([
            channel_length / 2,
            0,
            0
        ])
            sliding_dovetail_female_cutter(
                fixture.joint,
                slide = fixture.slide
            );
    }
}

module sliding_dovetail_test_pair_build(
    fixture,
    male_position = "inserted"
) {
    male_x =
        male_position == "inserted"
            ? fixture.slide / 2
            : male_position == "approach"
                ? -fixture.slide / 2 - 4
                : assert(
                    false,
                    str(
                        "Unknown male_position: ",
                        male_position
                    )
                ) 0;

    color([0.72, 0.72, 0.74, 1])
        sliding_dovetail_test_block_build(fixture);

    translate([male_x, 0, 0])
        color([0.88, 0.10, 0.06, 1])
            sliding_dovetail_male_build(
                fixture.joint,
                slide = fixture.slide
            );
}
