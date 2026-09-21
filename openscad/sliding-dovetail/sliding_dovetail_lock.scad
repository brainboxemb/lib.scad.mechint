//////////////////////////////////////////////////////////////////////
// LibFile: sliding_dovetail_lock.scad
//   Internal lock configuration and geometry for a sliding dovetail.
//////////////////////////////////////////////////////////////////////

// Private spring/flex configuration. Normal consumers configure these values
// through sliding_dovetail_create(); they do not need to construct this object.
use <../../ext/lib.scad.util/openscad/forge.scad>
use <../../ext/lib.scad.util/openscad/transform.scad>

function _sliding_dovetail_lock_spring_create(
    len_mm = 7.0,
    thickness_mm = 1.2,
    relief_mm = 0.8,
    hinge_len_mm = 0,
    hinge_thickness_mm = 0.8,
    has_back_clearance = true,
    back_clearance_mm = 0.8
) =
    assert(len_mm > 0,
        "sliding dovetail lock spring length must be > 0")
    assert(thickness_mm > 0,
        "sliding dovetail lock spring thickness must be > 0")
    assert(relief_mm > 0,
        "sliding dovetail lock spring relief must be > 0")
    assert(hinge_len_mm >= 0,
        "sliding dovetail lock spring hinge_length must be >= 0")
    assert(hinge_thickness_mm > 0,
        "sliding dovetail lock spring hinge_thickness must be > 0")
    assert(
        hinge_len_mm == 0 || hinge_len_mm < len_mm,
        "sliding dovetail lock spring hinge_length must be shorter than spring length"
    )
    assert(
        hinge_len_mm == 0 || hinge_thickness_mm < thickness_mm,
        "sliding dovetail lock spring hinge_thickness must be less than spring thickness"
    )
    assert(is_bool(has_back_clearance),
        "sliding dovetail lock cut_back_clearance must be boolean")
    assert(back_clearance_mm >= 0,
        "sliding dovetail lock back_clearance must be >= 0")
    object(
        len_mm = len_mm,
        thickness_mm = thickness_mm,
        relief_mm = relief_mm,
        hinge_len_mm = hinge_len_mm,
        hinge_thickness_mm = hinge_thickness_mm,
        has_back_clearance = has_back_clearance,
        back_clearance_mm = back_clearance_mm
    );

// Private constructor: lower-level lock configuration owned by one dovetail.
// Normal callers configure locking through sliding_dovetail_create().
function _sliding_dovetail_lock_create(
    is_enabled = false,
    entry_offset_mm = 0,
    width_mm = 4.0,
    recess_len_mm = 1.0,
    recess_depth_mm = 0.6,
    threshold_len_mm = 1.5,
    threshold_height_mm = 0.5,
    ramp_len_mm = 1.0,
    spring_len_mm = 7.0,
    spring_thickness_mm = 1.2,
    spring_relief_mm = 0.8,
    spring_hinge_len_mm = 0,
    spring_hinge_thickness_mm = 0.8,
    has_back_clearance = true,
    back_clearance_mm = 0.8,
    has_release_access = true,
    release_depth_mm = 0.6,
    release_shape = "rectangular",
    release_taper_angle_deg = 45
) =
    let(
        spring = _sliding_dovetail_lock_spring_create(
            len_mm = spring_len_mm,
            thickness_mm = spring_thickness_mm,
            relief_mm = spring_relief_mm,
            hinge_len_mm = spring_hinge_len_mm,
            hinge_thickness_mm = spring_hinge_thickness_mm,
            has_back_clearance = has_back_clearance,
            back_clearance_mm = back_clearance_mm
        )
    )
    assert(is_bool(is_enabled),
        "sliding dovetail lock enabled must be boolean")
    assert(entry_offset_mm >= 0,
        "sliding dovetail lock entry_offset must be >= 0")
    assert(width_mm > 0,
        "sliding dovetail lock width must be > 0")
    assert(recess_len_mm > 0,
        "sliding dovetail lock recess_length must be > 0")
    assert(recess_depth_mm > 0,
        "sliding dovetail lock recess_depth must be > 0")
    assert(threshold_len_mm > 0,
        "sliding dovetail lock threshold_length must be > 0")
    assert(threshold_height_mm > 0,
        "sliding dovetail lock threshold_height must be > 0")
    assert(ramp_len_mm > 0 && ramp_len_mm < threshold_len_mm,
        "sliding dovetail lock ramp_length must be > 0 and < threshold_length")
    assert(spring.len_mm > threshold_len_mm,
        "sliding dovetail lock spring length must exceed threshold length")
    assert(is_bool(has_release_access),
        "sliding dovetail lock release_access must be boolean")
    assert(release_depth_mm > 0,
        "sliding dovetail lock release_depth must be > 0")
    assert(
        release_shape == "rectangular"
            || release_shape == "trapezoid",
        "sliding dovetail lock release_shape must be rectangular or trapezoid"
    )
    assert(
        release_taper_angle_deg > 0
            && release_taper_angle_deg < 90,
        "sliding dovetail lock release_taper_angle_deg must be between 0 and 90 degrees"
    )
    object(
        is_enabled = is_enabled,
        entry_offset_mm = entry_offset_mm,
        width_mm = width_mm,
        recess_len_mm = recess_len_mm,
        recess_depth_mm = recess_depth_mm,
        threshold_len_mm = threshold_len_mm,
        threshold_height_mm = threshold_height_mm,
        ramp_len_mm = ramp_len_mm,
        spring = spring,
        has_release_access = has_release_access,
        release_depth_mm = release_depth_mm,
        release_shape = release_shape,
        release_taper_angle_deg = release_taper_angle_deg
    );

// Private accessor: whether the lock geometry is enabled.
function _sliding_dovetail_lock_is_enabled(obj) =
    obj.is_enabled;

// Private helper: female threshold starts at entry_offset from the fixed -X
// channel entry. With the default entry_offset=0, the ramp begins at the edge.
function _sliding_dovetail_lock_female_threshold_start_x_mm(
    obj,
    slide_len_mm,
    axial_clearance_mm
) =
    -(slide_len_mm + axial_clearance_mm) / 2
    + obj.entry_offset_mm;

function _sliding_dovetail_lock_female_threshold_end_x_mm(
    obj,
    slide_len_mm,
    axial_clearance_mm
) =
    _sliding_dovetail_lock_female_threshold_start_x_mm(
        obj,
        slide_len_mm,
        axial_clearance_mm
    )
    + obj.threshold_len_mm;

// Private helper: in assembled coordinates the male -X/trailing end coincides
// with the female entry. The +X recess wall sits just behind the female locking
// face by axial_clearance.
function _sliding_dovetail_lock_male_recess_end_x_mm(
    obj,
    slide_len_mm,
    axial_clearance_mm
) =
    -slide_len_mm / 2
    + obj.entry_offset_mm
    + obj.threshold_len_mm
    + axial_clearance_mm;

function _sliding_dovetail_lock_male_recess_start_x_mm(
    obj,
    slide_len_mm,
    axial_clearance_mm
) =
    _sliding_dovetail_lock_male_recess_end_x_mm(
        obj,
        slide_len_mm,
        axial_clearance_mm
    )
    - obj.recess_len_mm;

// Private helper: flexible tongue width across Z.
function _sliding_dovetail_lock_spring_width_mm(obj) =
    obj.width_mm + 2 * obj.spring.relief_mm;

// Internal validation that depends on the parent dovetail.
module _sliding_dovetail_lock_assert_valid(
    obj,
    slide_len_mm,
    male_width_mm,
    male_height_mm,
    clearance_mm,
    axial_clearance_mm
) {
    assert(
        obj.entry_offset_mm + obj.spring.len_mm
            <= slide_len_mm + axial_clearance_mm,
        "sliding dovetail lock spring must fit inside the female channel"
    );
    assert(
        obj.spring.hinge_len_mm == 0
            || obj.spring.hinge_len_mm
                <= obj.spring.len_mm - obj.threshold_len_mm,
        "sliding dovetail lock spring hinge relief must not overlap the threshold"
    );
    assert(
        obj.spring.hinge_len_mm == 0
            || obj.spring.len_mm
                - obj.threshold_len_mm
                - obj.spring.hinge_len_mm
                >= (
                    obj.spring.thickness_mm
                    - obj.spring.hinge_thickness_mm
                ) / 2,
        "sliding dovetail lock hinge return ramp must not exceed 45 degrees"
    );
    assert(
        obj.entry_offset_mm
            + obj.threshold_len_mm
            + axial_clearance_mm
            < slide_len_mm,
        "sliding dovetail lock recess must stay inside the male slide length"
    );
    assert(
        obj.recess_len_mm
            >= obj.threshold_len_mm
                - obj.ramp_len_mm
                + axial_clearance_mm,
        "sliding dovetail lock recess is too short for the locking face and axial clearance"
    );
    assert(
        obj.width_mm + 2 * clearance_mm < male_width_mm,
        "sliding dovetail lock recess must fit inside the male root width"
    );
    assert(
        obj.threshold_height_mm > clearance_mm,
        "sliding dovetail lock threshold must protrude beyond fit clearance"
    );
    assert(
        obj.recess_depth_mm + clearance_mm > obj.threshold_height_mm,
        "sliding dovetail lock recess is too shallow for the threshold"
    );
    assert(
        obj.recess_depth_mm < male_height_mm,
        "sliding dovetail lock recess_depth must remain below male profile height"
    );
    assert(
        !obj.spring.has_back_clearance
            || obj.spring.back_clearance_mm >= obj.threshold_height_mm,
        "sliding dovetail lock back clearance must allow the threshold to deflect"
    );
    assert(
        !obj.has_release_access
            || obj.release_depth_mm < male_height_mm,
        "sliding dovetail lock release_depth must remain below male profile height"
    );

    children();
}

// Male recess: its +X wall is the actual locking wall.
module _sliding_dovetail_lock_male_recess_cutter(
    obj,
    slide_len_mm,
    axial_clearance_mm,
    male_height_mm,
    clearance_mm,
    extra_mm = 0
) {
    x0_mm =
        _sliding_dovetail_lock_male_recess_start_x_mm(
            obj,
            slide_len_mm,
            axial_clearance_mm
        );
    recess_width_mm =
        obj.width_mm + 2 * clearance_mm;

    _recess_cutter =
        fg_box_cutter_create(
            size_mm = [
                obj.recess_len_mm,
                obj.recess_depth_mm,
                recess_width_mm
            ],
            pos_mm = [
                x0_mm,
                male_height_mm - obj.recess_depth_mm,
                -recess_width_mm / 2
            ],
            overlap_min = [false, false, false],
            overlap_max = [true, true, false],
            overlap_mm = max(extra_mm, fg_overlap_mm())
        );

    fg_cutter_build(_recess_cutter);
}

// Optional path from the male -X/trailing edge to the lock recess.
//
// Rectangular preserves the released geometry exactly.
//
// Trapezoid changes only the Y/Z opening profile and stays symmetric around
// native Z=0:
//
//   Y = male root face       -> full release width
//   Y = release-depth floor  -> narrower centered width
//
// Native X remains the straight path to the lock recess. In the HUB75 project
// mapping this means the taper runs in project Y and is symmetric on both
// project-X sides; project Z remains the straight release path.
module _sliding_dovetail_lock_male_release_print_wedges(
    obj,
    slide_len_mm,
    axial_clearance_mm,
    male_height_mm,
    release_width_mm,
    extra_mm = 0
) {
    // The printable wedge covers the complete visible release zone:
    // male trailing edge -> far end of the lock recess.
    //
    // This is deliberately longer than the screwdriver access path alone.
    _entry_x_mm =
        -slide_len_mm / 2;
    _male_outer_x_mm =
        _entry_x_mm - extra_mm;
    _release_end_x_mm =
        _sliding_dovetail_lock_male_recess_end_x_mm(
            obj,
            slide_len_mm,
            axial_clearance_mm
        );
    _release_length_mm =
        _release_end_x_mm - _entry_x_mm;

    _half_width_mm =
        release_width_mm / 2;
    _outer_extension_mm =
        _release_length_mm
        * tan(obj.release_taper_angle_deg);

    // Boolean overlap only. It must not participate in the nominal taper
    // calculation.
    _overlap_mm =
        max(extra_mm, fg_overlap_mm());

    assert(
        _release_length_mm > 0,
        "sliding dovetail lock printable release length must be > 0"
    )
    assert(
        _outer_extension_mm >= 0,
        "sliding dovetail lock print wedge extension must be >= 0"
    )

    // The baseline rectangular release and recess cutters remain intact.
    // Each triangle overlaps the baseline width and extends past the actual
    // male outer X face (-slide/2-extra), avoiding a coplanar/sliver wall at
    // the exposed end.
    for (side = [-1, 1])
        xf_ymove(
            male_height_mm
            - obj.release_depth_mm
            - _overlap_mm
        )
            multmatrix([
                [1, 0, 0, 0],
                [0, 0, 1, 0],
                [0, 1, 0, 0],
                [0, 0, 0, 1]
            ])
                linear_extrude(
                    height =
                        obj.release_depth_mm
                        + 2 * _overlap_mm
                )
                    polygon(points = [
                        [
                            _male_outer_x_mm
                                - _overlap_mm,
                            side * (
                                _half_width_mm
                                - _overlap_mm
                            )
                        ],
                        [
                            _male_outer_x_mm
                                - _overlap_mm,
                            side * (
                                _half_width_mm
                                + _outer_extension_mm
                                + _overlap_mm
                            )
                        ],
                        [
                            _release_end_x_mm
                                + _overlap_mm,
                            side * (
                                _half_width_mm
                                - _overlap_mm
                            )
                        ]
                    ]);
}


module _sliding_dovetail_lock_male_release_cutter(
    obj,
    slide_len_mm,
    axial_clearance_mm,
    male_height_mm,
    clearance_mm,
    extra_mm = 0
) {
    _recess_x0_mm =
        _sliding_dovetail_lock_male_recess_start_x_mm(
            obj,
            slide_len_mm,
            axial_clearance_mm
        );
    _entry_x_mm =
        -slide_len_mm / 2;
    _access_len_mm =
        _recess_x0_mm - _entry_x_mm;
    _overlap_mm =
        max(extra_mm, fg_overlap_mm());

    // Functional baseline width. This rectangular access opening is always cut
    // in full. The adjacent recess cutter completes the visible release zone.
    _release_width_mm =
        obj.width_mm + 2 * clearance_mm;

    if (obj.has_release_access && _access_len_mm > 0) {
        fg_cut_box(
            size_mm = [
                _access_len_mm,
                obj.release_depth_mm,
                _release_width_mm
            ],
            pos_mm = [
                _entry_x_mm,
                male_height_mm - obj.release_depth_mm,
                -_release_width_mm / 2
            ],
            overlap_min = [true, false, false],
            overlap_max = [true, true, false],
            overlap_mm = _overlap_mm
        );

        if (obj.release_shape == "trapezoid")
            _sliding_dovetail_lock_male_release_print_wedges(
                obj,
                slide_len_mm = slide_len_mm,
                axial_clearance_mm = axial_clearance_mm,
                male_height_mm = male_height_mm,
                release_width_mm = _release_width_mm,
                extra_mm = extra_mm
            );
    }
}

// Female keepout removed from the normal channel cutter. Subtracting this
// volume from the cutter leaves an integral threshold protruding into the
// channel. The -X face is the insertion ramp; the +X face is the locking stop.
module _sliding_dovetail_lock_female_threshold_keepout(
    obj,
    slide_len_mm,
    axial_clearance_mm,
    female_height_mm
) {
    x0_mm =
        _sliding_dovetail_lock_female_threshold_start_x_mm(
            obj,
            slide_len_mm,
            axial_clearance_mm
        );
    x1_mm = x0_mm + obj.ramp_len_mm;
    x2_mm = x0_mm + obj.threshold_len_mm;

    xf_zmove(-obj.width_mm / 2)
        linear_extrude(height = obj.width_mm)
            polygon(points = [
                [x0_mm, female_height_mm],
                [x1_mm, female_height_mm - obj.threshold_height_mm],
                [x2_mm, female_height_mm - obj.threshold_height_mm],
                [x2_mm, female_height_mm]
            ]);
}

// Female subtraction volumes around the threshold. The two longitudinal side
// cuts form the sides of the U-shaped tongue. A transverse cut is also needed
// whenever material continues ahead of the spring start: either because the
// threshold has a non-zero entry offset or because the parent female interface
// has a straight entry slot. The back cavity remains optional.
module _sliding_dovetail_lock_female_relief_cutter(
    obj,
    slide_len_mm,
    axial_clearance_mm,
    female_height_mm,
    entry_slot_len_mm = 0,
    extra_mm = 0
) {
    spring_x0_mm =
        _sliding_dovetail_lock_female_threshold_start_x_mm(
            obj,
            slide_len_mm,
            axial_clearance_mm
        );
    spring_width_mm =
        _sliding_dovetail_lock_spring_width_mm(obj);
    spring = obj.spring;

    side_cut_height_mm =
        spring.thickness_mm
        + (spring.has_back_clearance
            ? spring.back_clearance_mm
            : 0)
        + extra_mm;

    union() {
        xf_move([
            spring_x0_mm - extra_mm,
            female_height_mm,
            -spring_width_mm / 2 - spring.relief_mm
        ])
            cube([
                spring.len_mm + extra_mm,
                side_cut_height_mm,
                spring.relief_mm
            ]);

        xf_move([
            spring_x0_mm - extra_mm,
            female_height_mm,
            spring_width_mm / 2
        ])
            cube([
                spring.len_mm + extra_mm,
                side_cut_height_mm,
                spring.relief_mm
            ]);

        if (
            obj.entry_offset_mm > 0
            || entry_slot_len_mm > 0
        )
            xf_move([
                spring_x0_mm - spring.relief_mm,
                female_height_mm,
                -spring_width_mm / 2 - spring.relief_mm
            ])
                cube([
                    spring.relief_mm + extra_mm,
                    side_cut_height_mm,
                    spring_width_mm + 2 * spring.relief_mm
                ]);

        // Optional two-sided hinge relief. Keep the threshold/lip and fixed
        // root full-depth, but approach the flex problem from both faces so the
        // remaining hinge becomes a short web near the middle of the material.
        //
        // Moving from the fixed root toward the lip, both opposing pockets use:
        //   1. a mostly straight root wall;
        //   2. a local 45-degree chamfer;
        //   3. a flat central-web land;
        //   4. a calculated return ramp;
        //   5. a full-depth land under the complete threshold.
        //
        // hinge_length is the combined root-side chamfer + flat-web envelope.
        // Split it equally: half becomes the 45-degree chamfer run/rise and
        // half becomes the flat central-web land. hinge_thickness is the total
        // thickness left between the two opposing pockets. The return ramps use
        // the remaining spring length and must stay at or below 45 degrees.
        // hinge_length = 0 preserves the legacy spring geometry exactly.
        if (spring.hinge_len_mm > 0) {
            spring_x1_mm = spring_x0_mm + spring.len_mm;
            threshold_land_x1_mm =
                spring_x0_mm + obj.threshold_len_mm;
            hinge_x0_mm =
                spring_x1_mm - spring.hinge_len_mm;
            hinge_relief_depth_mm =
                spring.thickness_mm - spring.hinge_thickness_mm;
            relief_depth_each_side_mm =
                hinge_relief_depth_mm / 2;
            outer_face_y_mm =
                female_height_mm + spring.thickness_mm;

            // The 45-degree feature stays local. The configured hinge_length
            // is split equally between that chamfer and the following flat
            // central-web land. The same profile is mirrored from both faces.
            root_chamfer_run_mm =
                spring.hinge_len_mm / 2;
            flat_flex_len_mm =
                spring.hinge_len_mm / 2;
            root_straight_depth_mm =
                relief_depth_each_side_mm - root_chamfer_run_mm;
            root_shoulder_x0_mm =
                spring_x1_mm - root_chamfer_run_mm;
            return_ramp_run_mm =
                hinge_x0_mm - threshold_land_x1_mm;

            assert(
                root_chamfer_run_mm <= relief_depth_each_side_mm,
                "sliding dovetail lock root chamfer is deeper than one side of the centered hinge relief"
            )
            assert(
                flat_flex_len_mm > 0,
                "sliding dovetail lock flat central-web land must be positive"
            )
            assert(
                return_ramp_run_mm > 0,
                "sliding dovetail lock hinge_length leaves no return ramp before the threshold land"
            )

            // Channel-side pocket.
            xf_zmove(-spring_width_mm / 2)
                linear_extrude(height = spring_width_mm)
                    polygon(points = [
                        [threshold_land_x1_mm, female_height_mm],
                        [spring_x1_mm + extra_mm, female_height_mm],
                        [
                            spring_x1_mm + extra_mm,
                            female_height_mm + root_straight_depth_mm
                        ],
                        [
                            root_shoulder_x0_mm,
                            female_height_mm + relief_depth_each_side_mm
                        ],
                        [
                            hinge_x0_mm,
                            female_height_mm + relief_depth_each_side_mm
                        ],
                        [threshold_land_x1_mm, female_height_mm]
                    ]);

            // Opposing outer-face pocket. This mirrors the same relief profile
            // so the remaining hinge_thickness is centered through the tongue.
            xf_zmove(-spring_width_mm / 2)
                linear_extrude(height = spring_width_mm)
                    polygon(points = [
                        [threshold_land_x1_mm, outer_face_y_mm],
                        [spring_x1_mm + extra_mm, outer_face_y_mm],
                        [
                            spring_x1_mm + extra_mm,
                            outer_face_y_mm - root_straight_depth_mm
                        ],
                        [
                            root_shoulder_x0_mm,
                            outer_face_y_mm - relief_depth_each_side_mm
                        ],
                        [
                            hinge_x0_mm,
                            outer_face_y_mm - relief_depth_each_side_mm
                        ],
                        [threshold_land_x1_mm, outer_face_y_mm]
                    ]);
        }

        if (spring.has_back_clearance)
            xf_move([
                spring_x0_mm - extra_mm,
                female_height_mm + spring.thickness_mm,
                -spring_width_mm / 2
            ])
                cube([
                    spring.len_mm + extra_mm,
                    spring.back_clearance_mm + extra_mm,
                    spring_width_mm
                ]);
    }
}
