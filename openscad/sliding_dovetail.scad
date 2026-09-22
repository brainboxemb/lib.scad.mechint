//////////////////////////////////////////////////////////////////////
// LibFile: sliding_dovetail.scad
//   Compact FDM-oriented sliding dovetail mechanical interface.
//////////////////////////////////////////////////////////////////////

use <sliding-dovetail/sliding_dovetail_lock.scad>
use <../ext/lib.scad.forge/openscad/forge.scad>

// Function: sliding_dovetail_create()
// Synopsis: Creates one complete male/female sliding-dovetail interface.
// Description:
//   This is the normal public constructor. Locking options are selected here;
//   the library creates and owns the lower-level lock/spring objects internally.
// Arguments:
//   width_mm = Maximum/root width of the nominal male dovetail.
//   height_mm = Profile depth from mouth plane to root plane.
//   angle_deg = Flank angle in degrees from the Y/profile-depth axis.
//   root_land_depth_mm = Optional straight land at the wide/root end of the profile.
//   mouth_land_depth_mm = Optional straight land at the narrow/mouth end of the profile.
//   clearance_mm = Female fit clearance in mm, applied per side and at the rear.
//   axial_clearance_mm = Additional female travel along the X slide axis.
//   extra_mm = Boolean overlap added at slide ends and the mouth/base plane.
//   entry_slot_len_mm = Female-only straight entry mask before the -X channel entrance.
//   is_locking_enabled = Enable the integral male-recess / female-spring lock.
//   lock_entry_offset_mm = Threshold-ramp start distance from the fixed -X entry side.
//   lock_width_mm = Width of threshold across Z.
//   lock_recess_len_mm = Male recess length along X.
//   lock_recess_depth_mm = Male recess depth below the dovetail root surface.
//   lock_threshold_len_mm = Female threshold length along X.
//   lock_threshold_height_mm = Female threshold protrusion into the channel.
//   lock_ramp_len_mm = Length of the sloped insertion face along X.
//   lock_spring_len_mm = Flexible female tongue length along X.
//   lock_spring_thickness_mm = Material thickness of the flexible tongue.
//   lock_spring_relief_mm = Width of the U-shaped isolation cuts.
//   lock_spring_hinge_len_mm = Root-side chamfer + central-web envelope; 0 disables the relief.
//   lock_spring_hinge_thickness_mm = Total thickness of the centered flex web left between opposing relief pockets.
//   lock_has_back_clearance = Whether to cut a flex cavity behind the tongue.
//   lock_back_clearance_mm = Flex-cavity depth behind the tongue.
//   lock_has_release_access = Whether to add a male release opening from the entry edge.
//   lock_release_depth_mm = Release-opening depth into the male root surface.
//   lock_release_shape = Male release-opening profile: "rectangular" or "trapezoid".
//   lock_release_taper_angle_deg = Symmetric printable side-wall angle in the native X/Z profile; 45 gives 1 mm outward widening per side per 1 mm release-path run.
function sliding_dovetail_create(
    width_mm = 10,
    height_mm = 3,
    angle_deg = 20,
    root_land_depth_mm = 0,
    mouth_land_depth_mm = 0,
    clearance_mm = 0.20,
    axial_clearance_mm = 0.25,
    extra_mm = 0.01,
    entry_slot_len_mm = 0,
    is_locking_enabled = false,
    lock_entry_offset_mm = 0,
    lock_width_mm = 4.0,
    lock_recess_len_mm = 1.0,
    lock_recess_depth_mm = 0.6,
    lock_threshold_len_mm = 1.5,
    lock_threshold_height_mm = 0.5,
    lock_ramp_len_mm = 1.0,
    lock_spring_len_mm = 7.0,
    lock_spring_thickness_mm = 1.2,
    lock_spring_relief_mm = 0.8,
    lock_spring_hinge_len_mm = 0,
    lock_spring_hinge_thickness_mm = 0.8,
    lock_has_back_clearance = true,
    lock_back_clearance_mm = 0.8,
    lock_has_release_access = true,
    lock_release_depth_mm = 0.6,
    lock_release_shape = "rectangular",
    lock_release_taper_angle_deg = 45
) =
    let(
        sloped_depth_mm =
            height_mm
            - root_land_depth_mm
            - mouth_land_depth_mm,
        mouth_width_mm =
            width_mm - 2 * sloped_depth_mm * tan(angle_deg),
        lock = _sliding_dovetail_lock_create(
            is_enabled = is_locking_enabled,
            entry_offset_mm = lock_entry_offset_mm,
            width_mm = lock_width_mm,
            recess_len_mm = lock_recess_len_mm,
            recess_depth_mm = lock_recess_depth_mm,
            threshold_len_mm = lock_threshold_len_mm,
            threshold_height_mm = lock_threshold_height_mm,
            ramp_len_mm = lock_ramp_len_mm,
            spring_len_mm = lock_spring_len_mm,
            spring_thickness_mm = lock_spring_thickness_mm,
            spring_relief_mm = lock_spring_relief_mm,
            spring_hinge_len_mm = lock_spring_hinge_len_mm,
            spring_hinge_thickness_mm = lock_spring_hinge_thickness_mm,
            has_back_clearance = lock_has_back_clearance,
            back_clearance_mm = lock_back_clearance_mm,
            has_release_access = lock_has_release_access,
            release_depth_mm = lock_release_depth_mm,
            release_shape = lock_release_shape,
            release_taper_angle_deg = lock_release_taper_angle_deg
        )
    )
    assert(width_mm > 0,
        "sliding dovetail width must be > 0")
    assert(height_mm > 0,
        "sliding dovetail height must be > 0")
    assert(angle_deg > 0 && angle_deg < 90,
        "sliding dovetail angle must be between 0 and 90 degrees")
    assert(root_land_depth_mm >= 0,
        "sliding dovetail root_land_depth must be >= 0")
    assert(mouth_land_depth_mm >= 0,
        "sliding dovetail mouth_land_depth must be >= 0")
    assert(
        root_land_depth_mm + mouth_land_depth_mm < height_mm,
        "sliding dovetail root/mouth lands must leave positive sloped depth"
    )
    assert(mouth_width_mm > 0,
        "sliding dovetail mouth width must remain positive")
    assert(clearance_mm >= 0,
        "sliding dovetail clearance must be >= 0")
    assert(axial_clearance_mm >= 0,
        "sliding dovetail axial_clearance must be >= 0")
    assert(extra_mm >= 0,
        "sliding dovetail extra must be >= 0")
    assert(entry_slot_len_mm >= 0,
        "sliding dovetail entry_slot_length must be >= 0")
    assert(is_bool(is_locking_enabled),
        "sliding dovetail locking must be boolean")
    object(
        width_mm = width_mm,
        height_mm = height_mm,
        angle_deg = angle_deg,
        root_land_depth_mm = root_land_depth_mm,
        mouth_land_depth_mm = mouth_land_depth_mm,
        clearance_mm = clearance_mm,
        axial_clearance_mm = axial_clearance_mm,
        extra_mm = extra_mm,
        entry_slot_len_mm = entry_slot_len_mm,
        lock = lock
    );

// Function: sliding_dovetail_root_land_depth()
// Synopsis: Returns the optional straight depth at the wide/root end.
function sliding_dovetail_root_land_depth_mm(obj) =
    obj.root_land_depth_mm;

// Function: sliding_dovetail_mouth_land_depth()
// Synopsis: Returns the optional straight depth at the narrow/mouth end.
function sliding_dovetail_mouth_land_depth_mm(obj) =
    obj.mouth_land_depth_mm;

// Function: sliding_dovetail_mouth_width()
// Synopsis: Returns the nominal male mouth width.
function sliding_dovetail_mouth_width_mm(obj) =
    obj.width_mm
    - 2
        * (
            obj.height_mm
            - sliding_dovetail_root_land_depth_mm(obj)
            - sliding_dovetail_mouth_land_depth_mm(obj)
        )
        * tan(obj.angle_deg);

// Function: sliding_dovetail_female_mouth_width()
// Synopsis: Returns the female mouth width including lateral fit clearance.
function sliding_dovetail_female_mouth_width_mm(obj) =
    sliding_dovetail_mouth_width_mm(obj)
    + 2 * obj.clearance_mm;

// Function: sliding_dovetail_female_height()
// Synopsis: Returns female profile depth including rear fit clearance.
function sliding_dovetail_female_height_mm(obj) =
    obj.height_mm + obj.clearance_mm;

// Function: sliding_dovetail_female_root_width()
// Synopsis: Returns the clearanced female root width at the same flank angle.
function sliding_dovetail_female_root_width_mm(obj) =
    sliding_dovetail_female_mouth_width_mm(obj)
    + 2
        * (
            sliding_dovetail_female_height_mm(obj)
            - sliding_dovetail_root_land_depth_mm(obj)
            - sliding_dovetail_mouth_land_depth_mm(obj)
        )
        * tan(obj.angle_deg);

// Function: sliding_dovetail_female_slide()
// Synopsis: Returns female channel length including axial clearance.
function sliding_dovetail_female_slide_len_mm(obj, slide_len_mm) =
    slide_len_mm + obj.axial_clearance_mm;

// Function: sliding_dovetail_entry_slot_length()
// Synopsis: Returns the female-only straight entry-slot length.
function sliding_dovetail_entry_slot_len_mm(obj) =
    obj.entry_slot_len_mm;

// Function: sliding_dovetail_female_total_length()
// Synopsis: Returns channel length plus the optional -X entry slot.
function sliding_dovetail_female_total_len_mm(obj, slide_len_mm) =
    sliding_dovetail_female_slide_len_mm(obj, slide_len_mm)
    + sliding_dovetail_entry_slot_len_mm(obj);

function _sliding_dovetail_lock(obj) =
    obj.lock;

// Function: sliding_dovetail_locking_enabled()
// Synopsis: Returns whether optional locking geometry is requested.
function sliding_dovetail_is_locking_enabled(obj) =
    _sliding_dovetail_lock_is_enabled(
        _sliding_dovetail_lock(obj)
    );

// Module: sliding_dovetail_male_build()
// Synopsis: Builds the nominal male dovetail centered on X.
// Arguments:
//   obj = Sliding-dovetail interface object.
//   slide_len_mm = Nominal male length along the X insertion axis.
module sliding_dovetail_male_build(
    obj,
    slide_len_mm = 16
) {
    assert(slide_len_mm > 0,
        "sliding dovetail slide must be > 0");

    if (sliding_dovetail_is_locking_enabled(obj)) {
        _sliding_dovetail_lock_assert_valid(
            _sliding_dovetail_lock(obj),
            slide_len_mm,
            obj.width_mm,
            obj.height_mm,
            obj.clearance_mm,
            obj.axial_clearance_mm
        )
            fg_diff() {
                fg_body()
                    _sliding_dovetail_male_base(
                        obj,
                        slide_len_mm
                    );

                fg_remove() {
                    _sliding_dovetail_lock_male_recess_cutter(
                        _sliding_dovetail_lock(obj),
                        slide_len_mm,
                        obj.axial_clearance_mm,
                        obj.height_mm,
                        obj.clearance_mm,
                        obj.extra_mm
                    );

                    _sliding_dovetail_lock_male_release_cutter(
                        _sliding_dovetail_lock(obj),
                        slide_len_mm,
                        obj.axial_clearance_mm,
                        obj.height_mm,
                        obj.clearance_mm,
                        obj.extra_mm
                    );
                }
            }
    } else {
        _sliding_dovetail_male_base(
            obj,
            slide_len_mm
        );
    }
}

// Module: sliding_dovetail_male_relief_cutter()
// Synopsis: Trims consumer material back from the male dovetail flanks.
// Arguments:
//   obj = Sliding-dovetail interface object.
//   slide_len_mm = Nominal male length along X.
//   relief_width_mm = Total consumer envelope width across Z to trim.
module sliding_dovetail_male_relief_cutter(
    obj,
    slide_len_mm = 16,
    relief_width_mm = undef
) {
    assert(slide_len_mm > 0,
        "sliding dovetail slide must be > 0");
    assert(!is_undef(relief_width_mm) && relief_width_mm > 0,
        "sliding dovetail male relief_width must be > 0");

    fg_diff() {
        fg_body()
            fg_xf_move([
                -slide_len_mm / 2 - obj.extra_mm,
                -obj.extra_mm,
                -relief_width_mm / 2
            ])
                cube([
                    slide_len_mm + 2 * obj.extra_mm,
                    obj.height_mm + 2 * obj.extra_mm,
                    relief_width_mm
                ]);

        fg_remove()
            _sliding_dovetail_male_base(
                obj,
                slide_len_mm
            );
    }
}

// Module: sliding_dovetail_female_cutter()
// Synopsis: Builds a centered female subtraction volume from the same object.
// Arguments:
//   obj = Sliding-dovetail interface object.
//   slide_len_mm = Nominal male length. Axial clearance is added symmetrically.
module sliding_dovetail_female_cutter(
    obj,
    slide_len_mm = 16
) {
    assert(slide_len_mm > 0,
        "sliding dovetail slide must be > 0");

    if (sliding_dovetail_is_locking_enabled(obj)) {
        _sliding_dovetail_lock_assert_valid(
            _sliding_dovetail_lock(obj),
            slide_len_mm,
            obj.width_mm,
            obj.height_mm,
            obj.clearance_mm,
            obj.axial_clearance_mm
        )
            fg_diff() {
                fg_body()
                    _sliding_dovetail_female_base_cutter(
                        obj,
                        slide_len_mm
                    );

                fg_remove()
                    _sliding_dovetail_lock_female_threshold_keepout(
                        _sliding_dovetail_lock(obj),
                        slide_len_mm,
                        obj.axial_clearance_mm,
                        sliding_dovetail_female_height_mm(obj)
                    );

                fg_keep()
                    _sliding_dovetail_lock_female_relief_cutter(
                        _sliding_dovetail_lock(obj),
                        slide_len_mm,
                        obj.axial_clearance_mm,
                        sliding_dovetail_female_height_mm(obj),
                        entry_slot_len_mm = obj.entry_slot_len_mm,
                        extra_mm = obj.extra_mm
                    );
            }
    } else {
        _sliding_dovetail_female_base_cutter(
            obj,
            slide_len_mm
        );
    }
}

module _sliding_dovetail_male_base(
    obj,
    slide_len_mm
) {
    union() {
        _sliding_dovetail_prism(
            x_min_mm = -slide_len_mm / 2 - obj.extra_mm,
            x_max_mm = slide_len_mm / 2 + obj.extra_mm,
            y_min_mm = 0,
            y_max_mm = obj.height_mm,
            mouth_width_mm =
                sliding_dovetail_mouth_width_mm(obj),
            root_width_mm = obj.width_mm,
            root_land_depth_mm =
                sliding_dovetail_root_land_depth_mm(obj),
            mouth_land_depth_mm =
                sliding_dovetail_mouth_land_depth_mm(obj)
        );

        if (obj.extra_mm > 0)
            fg_xf_move([
                -slide_len_mm / 2 - obj.extra_mm,
                -obj.extra_mm,
                -sliding_dovetail_mouth_width_mm(obj) / 2
            ])
                cube([
                    slide_len_mm + 2 * obj.extra_mm,
                    obj.extra_mm,
                    sliding_dovetail_mouth_width_mm(obj)
                ]);
    }
}

module _sliding_dovetail_female_base_cutter(
    obj,
    slide_len_mm
) {
    female_slide_len_mm =
        sliding_dovetail_female_slide_len_mm(obj, slide_len_mm);
    female_mouth_width_mm =
        sliding_dovetail_female_mouth_width_mm(obj);

    union() {
        _sliding_dovetail_prism(
            x_min_mm = -female_slide_len_mm / 2 - obj.extra_mm,
            x_max_mm = female_slide_len_mm / 2 + obj.extra_mm,
            y_min_mm = 0,
            y_max_mm =
                sliding_dovetail_female_height_mm(obj),
            mouth_width_mm = female_mouth_width_mm,
            root_width_mm =
                sliding_dovetail_female_root_width_mm(obj),
            root_land_depth_mm =
                sliding_dovetail_root_land_depth_mm(obj),
            mouth_land_depth_mm =
                sliding_dovetail_mouth_land_depth_mm(obj)
        );

        // Optional straight approach mask ahead of the fixed -X female entry.
        // Its cross-section uses the complete clearanced female root envelope,
        // so a nominal male dovetail can sit in this space before sliding +X.
        if (obj.entry_slot_len_mm > 0)
            fg_xf_move([
                -female_slide_len_mm / 2
                    - obj.entry_slot_len_mm
                    - obj.extra_mm,
                -obj.extra_mm,
                -sliding_dovetail_female_root_width_mm(obj) / 2
            ])
                cube([
                    obj.entry_slot_len_mm
                        + 2 * obj.extra_mm,
                    sliding_dovetail_female_height_mm(obj)
                        + 2 * obj.extra_mm,
                    sliding_dovetail_female_root_width_mm(obj)
                ]);

        if (obj.extra_mm > 0)
            fg_xf_move([
                -female_slide_len_mm / 2 - obj.extra_mm,
                -obj.extra_mm,
                -female_mouth_width_mm / 2
            ])
                cube([
                    female_slide_len_mm + 2 * obj.extra_mm,
                    obj.extra_mm,
                    female_mouth_width_mm
                ]);
    }
}

// Native profile is [Y,Z]; extrusion is transformed onto X.
module _sliding_dovetail_prism(
    x_min_mm,
    x_max_mm,
    y_min_mm,
    y_max_mm,
    mouth_width_mm,
    root_width_mm,
    root_land_depth_mm = 0,
    mouth_land_depth_mm = 0
) {
    profile_depth_mm = y_max_mm - y_min_mm;
    slope_start_y_mm = y_min_mm + mouth_land_depth_mm;
    land_start_y_mm = y_max_mm - root_land_depth_mm;

    assert(x_max_mm > x_min_mm,
        "sliding dovetail X span must be positive");
    assert(profile_depth_mm > 0,
        "sliding dovetail profile depth must be positive");
    assert(root_land_depth_mm >= 0,
        "sliding dovetail root land must be >= 0");
    assert(mouth_land_depth_mm >= 0,
        "sliding dovetail mouth land must be >= 0");
    assert(
        root_land_depth_mm + mouth_land_depth_mm < profile_depth_mm,
        "sliding dovetail lands must leave positive sloped profile depth"
    );
    assert(root_width_mm > mouth_width_mm,
        "sliding dovetail root width must exceed mouth width");

    fg_xf_frame(
        pos_mm = [x_min_mm, 0, 0],
        x_axis = [0, 1, 0],
        y_axis = [0, 0, 1]
    )
        linear_extrude(height = x_max_mm - x_min_mm)
            polygon(
                points =
                    mouth_land_depth_mm > 0
                    && root_land_depth_mm > 0
                        ? [
                            [y_min_mm,         -mouth_width_mm / 2],
                            [y_min_mm,          mouth_width_mm / 2],
                            [slope_start_y_mm,  mouth_width_mm / 2],
                            [land_start_y_mm,   root_width_mm / 2],
                            [y_max_mm,          root_width_mm / 2],
                            [y_max_mm,         -root_width_mm / 2],
                            [land_start_y_mm,  -root_width_mm / 2],
                            [slope_start_y_mm, -mouth_width_mm / 2]
                        ]
                        : mouth_land_depth_mm > 0
                            ? [
                                [y_min_mm,         -mouth_width_mm / 2],
                                [y_min_mm,          mouth_width_mm / 2],
                                [slope_start_y_mm,  mouth_width_mm / 2],
                                [y_max_mm,          root_width_mm / 2],
                                [y_max_mm,         -root_width_mm / 2],
                                [slope_start_y_mm, -mouth_width_mm / 2]
                            ]
                            : root_land_depth_mm > 0
                                ? [
                                    [y_min_mm,        -mouth_width_mm / 2],
                                    [y_min_mm,         mouth_width_mm / 2],
                                    [land_start_y_mm,  root_width_mm / 2],
                                    [y_max_mm,         root_width_mm / 2],
                                    [y_max_mm,        -root_width_mm / 2],
                                    [land_start_y_mm, -root_width_mm / 2]
                                ]
                                : [
                                    [y_min_mm, -mouth_width_mm / 2],
                                    [y_min_mm,  mouth_width_mm / 2],
                                    [y_max_mm,  root_width_mm / 2],
                                    [y_max_mm, -root_width_mm / 2]
                                ]
            );
}
