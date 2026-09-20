//////////////////////////////////////////////////////////////////////
// LibFile: sliding_dovetail.scad
//   Compact FDM-oriented sliding dovetail mechanical interface.
//////////////////////////////////////////////////////////////////////

use <sliding_dovetail_lock.scad>

// Function: sliding_dovetail_create()
// Synopsis: Creates one male/female sliding-dovetail interface object.
// Arguments:
//   width = Maximum/root width of the nominal male dovetail.
//   height = Profile depth from mouth plane to root plane.
//   angle = Flank angle in degrees from the Y/profile-depth axis.
//   clearance = Female fit clearance in mm, applied per side and at the rear.
//   axial_clearance = Additional female travel along the X slide axis.
//   extra = Boolean overlap added at slide ends and the mouth/base plane.
//   lock = Optional sliding-dovetail lock object.
function sliding_dovetail_create(
    width = 10,
    height = 3,
    angle = 20,
    clearance = 0.20,
    axial_clearance = 0.25,
    extra = 0.01,
    lock = sliding_dovetail_lock_create()
) =
    let(
        mouth_width =
            width - 2 * height * tan(angle)
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
    object(
        width = width,
        height = height,
        angle = angle,
        clearance = clearance,
        axial_clearance = axial_clearance,
        extra = extra,
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

// Function: sliding_dovetail_lock()
// Synopsis: Returns the lock configuration owned by this interface.
function sliding_dovetail_lock(joint) =
    joint.lock;

// Function: sliding_dovetail_locking_enabled()
// Synopsis: Returns whether optional locking geometry is requested.
function sliding_dovetail_locking_enabled(joint) =
    sliding_dovetail_lock_enabled(
        sliding_dovetail_lock(joint)
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
            sliding_dovetail_lock(joint),
            slide,
            joint.width,
            joint.height,
            joint.clearance
        )
            difference() {
                _sliding_dovetail_male_base(
                    joint,
                    slide
                );

                _sliding_dovetail_lock_male_recess_cutter(
                    sliding_dovetail_lock(joint),
                    slide,
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
            sliding_dovetail_lock(joint),
            slide,
            joint.width,
            joint.height,
            joint.clearance
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
                        sliding_dovetail_lock(joint),
                        slide,
                        joint.axial_clearance,
                        sliding_dovetail_female_height(joint)
                    );
                }

                // Cut around and behind that threshold so the remaining roof
                // material becomes an integral flexible tongue.
                _sliding_dovetail_lock_female_relief_cutter(
                    sliding_dovetail_lock(joint),
                    slide,
                    joint.axial_clearance,
                    sliding_dovetail_female_height(joint),
                    joint.extra
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
