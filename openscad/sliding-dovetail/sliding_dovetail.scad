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
//   root_land_depth = Optional straight land at the wide/root end of the profile.
//   mouth_land_depth = Optional straight land at the narrow/mouth end of the profile.
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
//   lock_spring_hinge_length = Length of an optional tapered flex zone at the fixed spring end; 0 disables it.
//   lock_spring_hinge_thickness = Minimum tongue thickness left at that fixed end when hinge relief is enabled.
//   lock_cut_back_clearance = Whether to cut a flex cavity behind the tongue.
//   lock_back_clearance = Flex-cavity depth behind the tongue.
//   lock_release_access = Whether to add a male screwdriver slot from the entry edge.
//   lock_release_depth = Screwdriver slot depth into the male root surface.
function sliding_dovetail_create(
    width = 10,
    height = 3,
    angle = 20,
    root_land_depth = 0,
    mouth_land_depth = 0,
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
    lock_spring_hinge_length = 0,
    lock_spring_hinge_thickness = 0.8,
    lock_cut_back_clearance = true,
    lock_back_clearance = 0.8,
    lock_release_access = true,
    lock_release_depth = 0.6
) =
    let(
        sloped_depth =
            height
            - root_land_depth
            - mouth_land_depth,
        mouth_width =
            width - 2 * sloped_depth * tan(angle),
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
            spring_hinge_length = lock_spring_hinge_length,
            spring_hinge_thickness = lock_spring_hinge_thickness,
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
    assert(root_land_depth >= 0,
        "sliding dovetail root_land_depth must be >= 0")
    assert(mouth_land_depth >= 0,
        "sliding dovetail mouth_land_depth must be >= 0")
    assert(
        root_land_depth + mouth_land_depth < height,
        "sliding dovetail root/mouth lands must leave positive sloped depth"
    )
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
        root_land_depth = root_land_depth,
        mouth_land_depth = mouth_land_depth,
        clearance = clearance,
        axial_clearance = axial_clearance,
        extra = extra,
        entry_slot_length = entry_slot_length,
        lock = lock
    );

// Function: sliding_dovetail_root_land_depth()
// Synopsis: Returns the optional straight depth at the wide/root end.
function sliding_dovetail_root_land_depth(joint) =
    joint.root_land_depth;

// Function: sliding_dovetail_mouth_land_depth()
// Synopsis: Returns the optional straight depth at the narrow/mouth end.
function sliding_dovetail_mouth_land_depth(joint) =
    joint.mouth_land_depth;

// Function: sliding_dovetail_mouth_width()
// Synopsis: Returns the nominal male mouth width.
function sliding_dovetail_mouth_width(joint) =
    joint.width
    - 2
        * (
            joint.height
            - sliding_dovetail_root_land_depth(joint)
            - sliding_dovetail_mouth_land_depth(joint)
        )
        * tan(joint.angle);

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
        * (
            sliding_dovetail_female_height(joint)
            - sliding_dovetail_root_land_depth(joint)
            - sliding_dovetail_mouth_land_depth(joint)
        )
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

// Module: sliding_dovetail_male_relief_cutter()
// Synopsis: Trims consumer material back from the male dovetail flanks.
// Arguments:
//   joint = Sliding-dovetail interface object.
//   slide = Nominal male length along X.
//   relief_width = Total consumer envelope width across Z to trim.
module sliding_dovetail_male_relief_cutter(
    joint,
    slide = 16,
    relief_width = undef
) {
    assert(slide > 0,
        "sliding dovetail slide must be > 0");
    assert(!is_undef(relief_width) && relief_width > 0,
        "sliding dovetail male relief_width must be > 0");

    difference() {
        translate([
            -slide / 2 - joint.extra,
            -joint.extra,
            -relief_width / 2
        ])
            cube([
                slide + 2 * joint.extra,
                joint.height + 2 * joint.extra,
                relief_width
            ]);

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
            root_width = joint.width,
            root_land_depth =
                sliding_dovetail_root_land_depth(joint),
            mouth_land_depth =
                sliding_dovetail_mouth_land_depth(joint)
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
                sliding_dovetail_female_root_width(joint),
            root_land_depth =
                sliding_dovetail_root_land_depth(joint),
            mouth_land_depth =
                sliding_dovetail_mouth_land_depth(joint)
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
    root_width,
    root_land_depth = 0,
    mouth_land_depth = 0
) {
    profile_depth = y_max - y_min;
    slope_start_y = y_min + mouth_land_depth;
    land_start_y = y_max - root_land_depth;

    assert(x_max > x_min,
        "sliding dovetail X span must be positive");
    assert(profile_depth > 0,
        "sliding dovetail profile depth must be positive");
    assert(root_land_depth >= 0,
        "sliding dovetail root land must be >= 0");
    assert(mouth_land_depth >= 0,
        "sliding dovetail mouth land must be >= 0");
    assert(
        root_land_depth + mouth_land_depth < profile_depth,
        "sliding dovetail lands must leave positive sloped profile depth"
    );
    assert(root_width > mouth_width,
        "sliding dovetail root width must exceed mouth width");

    multmatrix([
        [0, 0, 1, x_min],
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = x_max - x_min)
            polygon(
                points =
                    mouth_land_depth > 0
                    && root_land_depth > 0
                        ? [
                            [y_min,         -mouth_width / 2],
                            [y_min,          mouth_width / 2],
                            [slope_start_y,  mouth_width / 2],
                            [land_start_y,   root_width / 2],
                            [y_max,          root_width / 2],
                            [y_max,         -root_width / 2],
                            [land_start_y,  -root_width / 2],
                            [slope_start_y, -mouth_width / 2]
                        ]
                        : mouth_land_depth > 0
                            ? [
                                [y_min,         -mouth_width / 2],
                                [y_min,          mouth_width / 2],
                                [slope_start_y,  mouth_width / 2],
                                [y_max,          root_width / 2],
                                [y_max,         -root_width / 2],
                                [slope_start_y, -mouth_width / 2]
                            ]
                            : root_land_depth > 0
                                ? [
                                    [y_min,        -mouth_width / 2],
                                    [y_min,         mouth_width / 2],
                                    [land_start_y,  root_width / 2],
                                    [y_max,         root_width / 2],
                                    [y_max,        -root_width / 2],
                                    [land_start_y, -root_width / 2]
                                ]
                                : [
                                    [y_min, -mouth_width / 2],
                                    [y_min,  mouth_width / 2],
                                    [y_max,  root_width / 2],
                                    [y_max, -root_width / 2]
                                ]
            );
}
