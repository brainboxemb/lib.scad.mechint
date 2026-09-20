//////////////////////////////////////////////////////////////////////
// LibFile: sliding_dovetail.scad
//   Compact FDM-oriented sliding dovetail mechanical interface.
//////////////////////////////////////////////////////////////////////

use <sliding_dovetail_lock.scad>

// Function: sliding_dovetail_create()
// Synopsis: Creates one complete male/female sliding-dovetail interface.
// Description:
//   This is the normal public constructor. Locking options are selected here;
//   the library creates and owns the lower-level lock/spring objects internally.
// Arguments:
//   width = Maximum/root width of the nominal male dovetail.
//   height = Profile depth from mouth plane to root plane.
//   angle = Flank angle in degrees from the Y/profile-depth axis.
//   clearance = Female fit clearance in mm, applied per side and at the rear.
//   axial_clearance = Additional female travel along the X slide axis.
//   extra = Boolean overlap added at slide ends and the mouth/base plane.
//   entry_slot_length = Female-only straight entry mask before the -X channel entrance.
//   locking = Enable the integral male-recess / female-spring lock.
//   lock_entry_offset = Threshold-ramp start distance from the fixed -X entry side.
//   lock_width = Width of threshold across Z.
//   lock_recess_length = Male recess length along X.
//   lock_recess_depth = Male recess depth below the dovetail root surface.
//   lock_threshold_length = Female threshold length along X.
//   lock_threshold_height = Female threshold protrusion into the channel.
//   lock_ramp_length = Length of the sloped insertion face along X.
//   lock_spring_length = Flexible female tongue length along X.
//   lock_spring_thickness = Material thickness of the flexible tongue.
//   lock_spring_relief = Width of the U-shaped isolation cuts.
//   lock_cut_back_clearance = Whether to cut a flex cavity behind the tongue.
//   lock_back_clearance = Flex-cavity depth behind the tongue.
//   lock_release_access = Whether to add a male screwdriver slot from the entry edge.
//   lock_release_depth = Screwdriver slot depth into the male root surface.
function sliding_dovetail_create(
    width = 10,
    height = 3,
    angle = 20,
    clearance = 0.20,
    axial_clearance = 0.25,
    extra = 0.01,
    entry_slot_length = 0,
    locking = false,
    lock_entry_offset = 0,
    lock_width = 4.0,
    lock_recess_length = 1.0,
    lock_recess_depth = 0.6,
    lock_threshold_length = 1.5,
    lock_threshold_height = 0.5,
    lock_ramp_length = 1.0,
    lock_spring_length = 7.0,
    lock_spring_thickness = 1.2,
    lock_spring_relief = 0.8,
    lock_cut_back_clearance = true,
    lock_back_clearance = 0.8,
    lock_release_access = true,
    lock_release_depth = 0.6
) =
    let(
        mouth_width =
            width - 2 * height * tan(angle),
        lock = _sliding_dovetail_lock_create(
            enabled = locking,
            entry_offset = lock_entry_offset,
            width = lock_width,
            recess_length = lock_recess_length,
            recess_depth = lock_recess_depth,
            threshold_length = lock_threshold_length,
            threshold_height = lock_threshold_height,
            ramp_length = lock_ramp_length,
            spring_length = lock_spring_length,
            spring_thickness = lock_spring_thickness,
            spring_relief = lock_spring_relief,
            cut_back_clearance = lock_cut_back_clearance,
            back_clearance = lock_back_clearance,
            release_access = lock_release_access,
            release_depth = lock_release_depth
        )
    )
    assert(width > 0,
        "sliding dovetail width must be > 0")
    assert(height > 0,
        "sliding dovetail height must be > 0")
    assert(angle > 0 && angle < 90,
        "sliding dovetail angle must be between 0 and 90 degrees")
    assert(mouth_width > 0,
        "sliding dovetail mouth width must remain positive")
    assert(clearance >= 0,
        "sliding dovetail clearance must be >= 0")
    assert(axial_clearance >= 0,
        "sliding dovetail axial_clearance must be >= 0")
    assert(extra >= 0,
        "sliding dovetail extra must be >= 0")
    assert(entry_slot_length >= 0,
        "sliding dovetail entry_slot_length must be >= 0")
    assert(is_bool(locking),
        "sliding dovetail locking must be boolean")
    object(
        width = width,
        height = height,
        angle = angle,
        clearance = clearance,
        axial_clearance = axial_clearance,
        extra = extra,
        entry_slot_length = entry_slot_length,
        lock = lock
    );

// Function: sliding_dovetail_mouth_width()
// Synopsis: Returns the nominal male mouth width.
function sliding_dovetail_mouth_width(joint) =
    joint.width
    - 2 * joint.height * tan(joint.angle);

// Function: sliding_dovetail_female_mouth_width()
// Synopsis: Returns the female mouth width including lateral fit clearance.
function sliding_dovetail_female_mouth_width(joint) =
    sliding_dovetail_mouth_width(joint)
    + 2 * joint.clearance;

// Function: sliding_dovetail_female_height()
// Synopsis: Returns female profile depth including rear fit clearance.
function sliding_dovetail_female_height(joint) =
    joint.height + joint.clearance;

// Function: sliding_dovetail_female_root_width()
// Synopsis: Returns the clearanced female root width at the same flank angle.
function sliding_dovetail_female_root_width(joint) =
    sliding_dovetail_female_mouth_width(joint)
    + 2
        * sliding_dovetail_female_height(joint)
        * tan(joint.angle);

// Function: sliding_dovetail_female_slide()
// Synopsis: Returns female channel length including axial clearance.
function sliding_dovetail_female_slide(joint, slide) =
    slide + joint.axial_clearance;

// Function: sliding_dovetail_entry_slot_length()
// Synopsis: Returns the female-only straight entry-slot length.
function sliding_dovetail_entry_slot_length(joint) =
    joint.entry_slot_length;

// Function: sliding_dovetail_female_total_length()
// Synopsis: Returns channel length plus the optional -X entry slot.
function sliding_dovetail_female_total_length(joint, slide) =
    sliding_dovetail_female_slide(joint, slide)
    + sliding_dovetail_entry_slot_length(joint);

function _sliding_dovetail_lock(joint) =
    joint.lock;

// Function: sliding_dovetail_locking_enabled()
// Synopsis: Returns whether optional locking geometry is requested.
function sliding_dovetail_locking_enabled(joint) =
    _sliding_dovetail_lock_enabled(
        _sliding_dovetail_lock(joint)
    );

// Module: sliding_dovetail_male_build()
// Synopsis: Builds the nominal male dovetail centered on X.
// Arguments:
//   joint = Sliding-dovetail interface object.
//   slide = Nominal male length along the X insertion axis.
module sliding_dovetail_male_build(
    joint,
    slide = 16
) {
    assert(slide > 0,
        "sliding dovetail slide must be > 0");

    if (sliding_dovetail_locking_enabled(joint)) {
        _sliding_dovetail_lock_assert_valid(
            _sliding_dovetail_lock(joint),
            slide,
            joint.width,
            joint.height,
            joint.clearance,
            joint.axial_clearance
        )
            difference() {
                _sliding_dovetail_male_base(
                    joint,
                    slide
                );

                _sliding_dovetail_lock_male_recess_cutter(
                    _sliding_dovetail_lock(joint),
                    slide,
                    joint.axial_clearance,
                    joint.height,
                    joint.clearance,
                    joint.extra
                );

                _sliding_dovetail_lock_male_release_cutter(
                    _sliding_dovetail_lock(joint),
                    slide,
                    joint.axial_clearance,
                    joint.height,
                    joint.clearance,
                    joint.extra
                );
            }
    } else {
        _sliding_dovetail_male_base(
            joint,
            slide
        );
    }
}

// Module: sliding_dovetail_female_cutter()
// Synopsis: Builds a centered female subtraction volume from the same object.
// Arguments:
//   joint = Sliding-dovetail interface object.
//   slide = Nominal male length. Axial clearance is added symmetrically.
module sliding_dovetail_female_cutter(
    joint,
    slide = 16
) {
    assert(slide > 0,
        "sliding dovetail slide must be > 0");

    if (sliding_dovetail_locking_enabled(joint)) {
        _sliding_dovetail_lock_assert_valid(
            _sliding_dovetail_lock(joint),
            slide,
            joint.width,
            joint.height,
            joint.clearance,
            joint.axial_clearance
        )
            union() {
                // Start from the normal female subtraction volume, but keep a
                // small ramped threshold in the channel roof.
                difference() {
                    _sliding_dovetail_female_base_cutter(
                        joint,
                        slide
                    );

                    _sliding_dovetail_lock_female_threshold_keepout(
                        _sliding_dovetail_lock(joint),
                        slide,
                        joint.axial_clearance,
                        sliding_dovetail_female_height(joint)
                    );
                }

                // Cut around and behind that threshold so the remaining roof
                // material becomes an integral flexible tongue.
                _sliding_dovetail_lock_female_relief_cutter(
                    _sliding_dovetail_lock(joint),
                    slide,
                    joint.axial_clearance,
                    sliding_dovetail_female_height(joint),
                    entry_slot_length = joint.entry_slot_length,
                    extra = joint.extra
                );
            }
    } else {
        _sliding_dovetail_female_base_cutter(
            joint,
            slide
        );
    }
}

module _sliding_dovetail_male_base(
    joint,
    slide
) {
    union() {
        _sliding_dovetail_prism(
            x_min = -slide / 2 - joint.extra,
            x_max = slide / 2 + joint.extra,
            y_min = 0,
            y_max = joint.height,
            mouth_width =
                sliding_dovetail_mouth_width(joint),
            root_width = joint.width
        );

        if (joint.extra > 0)
            translate([
                -slide / 2 - joint.extra,
                -joint.extra,
                -sliding_dovetail_mouth_width(joint) / 2
            ])
                cube([
                    slide + 2 * joint.extra,
                    joint.extra,
                    sliding_dovetail_mouth_width(joint)
                ]);
    }
}

module _sliding_dovetail_female_base_cutter(
    joint,
    slide
) {
    female_slide =
        sliding_dovetail_female_slide(joint, slide);
    female_mouth =
        sliding_dovetail_female_mouth_width(joint);

    union() {
        _sliding_dovetail_prism(
            x_min = -female_slide / 2 - joint.extra,
            x_max = female_slide / 2 + joint.extra,
            y_min = 0,
            y_max =
                sliding_dovetail_female_height(joint),
            mouth_width = female_mouth,
            root_width =
                sliding_dovetail_female_root_width(joint)
        );

        // Optional straight approach mask ahead of the fixed -X female entry.
        // Its cross-section uses the complete clearanced female root envelope,
        // so a nominal male dovetail can sit in this space before sliding +X.
        if (joint.entry_slot_length > 0)
            translate([
                -female_slide / 2
                    - joint.entry_slot_length
                    - joint.extra,
                -joint.extra,
                -sliding_dovetail_female_root_width(joint) / 2
            ])
                cube([
                    joint.entry_slot_length
                        + 2 * joint.extra,
                    sliding_dovetail_female_height(joint)
                        + 2 * joint.extra,
                    sliding_dovetail_female_root_width(joint)
                ]);

        if (joint.extra > 0)
            translate([
                -female_slide / 2 - joint.extra,
                -joint.extra,
                -female_mouth / 2
            ])
                cube([
                    female_slide + 2 * joint.extra,
                    joint.extra,
                    female_mouth
                ]);
    }
}

// Native profile is [Y,Z]; extrusion is transformed onto X.
module _sliding_dovetail_prism(
    x_min,
    x_max,
    y_min,
    y_max,
    mouth_width,
    root_width
) {
    assert(x_max > x_min,
        "sliding dovetail X span must be positive");
    assert(y_max > y_min,
        "sliding dovetail profile depth must be positive");
    assert(root_width > mouth_width,
        "sliding dovetail root width must exceed mouth width");

    multmatrix([
        [0, 0, 1, x_min],
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = x_max - x_min)
            polygon(points = [
                [y_min, -mouth_width / 2],
                [y_min,  mouth_width / 2],
                [y_max,  root_width / 2],
                [y_max, -root_width / 2]
            ]);
}
