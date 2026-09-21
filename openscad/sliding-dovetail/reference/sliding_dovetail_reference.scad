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
    obj = sliding_dovetail_create(),
    slide_len_mm = 16,
    female_block_len_mm = 24,
    female_block_depth_mm = 7,
    block_width_mm = 16,
    male_block_depth_mm = 4,
    approach_gap_mm = 4
) =
    assert(
        female_block_len_mm
            > sliding_dovetail_female_total_len_mm(obj, slide_len_mm),
        "female reference block must contain entry slot, channel and end stop"
    )
    assert(
        female_block_depth_mm
            > sliding_dovetail_female_height_mm(obj),
        "female reference block must leave a rear wall"
    )
    assert(
        block_width_mm
            > sliding_dovetail_female_root_width_mm(obj),
        "reference blocks must leave side walls around the interface"
    )
    assert(
        male_block_depth_mm > 0,
        "male reference block depth must be > 0"
    )
    assert(
        approach_gap_mm >= 0,
        "reference approach gap must be >= 0"
    )
    object(
        joint = obj,
        slide_len_mm = slide_len_mm,
        female_block_len_mm = female_block_len_mm,
        female_block_depth_mm = female_block_depth_mm,
        block_width_mm = block_width_mm,
        male_block_depth_mm = male_block_depth_mm,
        approach_gap_mm = approach_gap_mm
    );

function sliding_dovetail_reference_female_channel_len_mm(obj) =
    sliding_dovetail_female_slide_len_mm(
        obj.joint,
        obj.slide_len_mm
    );

function sliding_dovetail_reference_entry_slot_len_mm(obj) =
    sliding_dovetail_entry_slot_len_mm(obj.joint);

function sliding_dovetail_reference_female_total_len_mm(obj) =
    sliding_dovetail_female_total_len_mm(
        obj.joint,
        obj.slide_len_mm
    );

function sliding_dovetail_reference_male_x_mm(
    obj,
    position = "assembled"
) =
    position == "assembled"
        ? sliding_dovetail_reference_entry_slot_len_mm(obj)
            + obj.slide_len_mm / 2
        : position == "entry"
            ? sliding_dovetail_reference_entry_slot_len_mm(obj)
                - obj.slide_len_mm / 2
            : position == "approach"
                ? -obj.slide_len_mm / 2 - obj.approach_gap_mm
                : assert(
                false,
                str(
                    "Unknown sliding-dovetail reference position: ",
                    position
                )
            ) 0;

module sliding_dovetail_reference_female_build(obj) {
    channel_len_mm =
        sliding_dovetail_reference_female_channel_len_mm(obj);
    entry_slot_len_mm =
        sliding_dovetail_reference_entry_slot_len_mm(obj);

    difference() {
        translate([
            0,
            0,
            -obj.block_width_mm / 2
        ])
            cube([
                obj.female_block_len_mm,
                obj.female_block_depth_mm,
                obj.block_width_mm
            ]);

        // The public cutter is centered on X. Shift it so the female channel
        // opens through the block's X=0 side and leaves a solid +X end stop.
        translate([
            channel_len_mm / 2 + entry_slot_len_mm,
            0,
            0
        ])
            sliding_dovetail_female_cutter(
                obj.joint,
                slide_len_mm = obj.slide_len_mm
            );
    }
}

module sliding_dovetail_reference_male_build(obj) {
    union() {
        translate([
            -obj.slide_len_mm / 2,
            -obj.male_block_depth_mm,
            -obj.block_width_mm / 2
        ])
            cube([
                obj.slide_len_mm,
                obj.male_block_depth_mm,
                obj.block_width_mm
            ]);

        sliding_dovetail_male_build(
            obj.joint,
            slide_len_mm = obj.slide_len_mm
        );
    }
}

module sliding_dovetail_reference_pair_build(
    obj,
    position = "assembled",
    male_color = [0.88, 0.10, 0.06, 1],
    female_color = [0.28, 0.50, 0.82, 1]
) {
    color(female_color)
        sliding_dovetail_reference_female_build(obj);

    translate([
        sliding_dovetail_reference_male_x_mm(
            obj,
            position
        ),
        0,
        0
    ])
        color(male_color)
            sliding_dovetail_reference_male_build(obj);
}
