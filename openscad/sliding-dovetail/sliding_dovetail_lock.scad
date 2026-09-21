//////////////////////////////////////////////////////////////////////
// LibFile: sliding_dovetail_lock.scad
//   Internal lock configuration and geometry for a sliding dovetail.
//////////////////////////////////////////////////////////////////////

// Private spring/flex configuration. Normal consumers configure these values
// through sliding_dovetail_create(); they do not need to construct this object.
function _sliding_dovetail_lock_spring_create(
    length = 7.0,
    thickness = 1.2,
    relief = 0.8,
    hinge_length = 0,
    hinge_thickness = 0.8,
    cut_back_clearance = true,
    back_clearance = 0.8
) =
    assert(length > 0,
        "sliding dovetail lock spring length must be > 0")
    assert(thickness > 0,
        "sliding dovetail lock spring thickness must be > 0")
    assert(relief > 0,
        "sliding dovetail lock spring relief must be > 0")
    assert(hinge_length >= 0,
        "sliding dovetail lock spring hinge_length must be >= 0")
    assert(hinge_thickness > 0,
        "sliding dovetail lock spring hinge_thickness must be > 0")
    assert(
        hinge_length == 0 || hinge_length < length,
        "sliding dovetail lock spring hinge_length must be shorter than spring length"
    )
    assert(
        hinge_length == 0 || hinge_thickness < thickness,
        "sliding dovetail lock spring hinge_thickness must be less than spring thickness"
    )
    assert(is_bool(cut_back_clearance),
        "sliding dovetail lock cut_back_clearance must be boolean")
    assert(back_clearance >= 0,
        "sliding dovetail lock back_clearance must be >= 0")
    object(
        length = length,
        thickness = thickness,
        relief = relief,
        hinge_length = hinge_length,
        hinge_thickness = hinge_thickness,
        cut_back_clearance = cut_back_clearance,
        back_clearance = back_clearance
    );

// Private constructor: lower-level lock configuration owned by one dovetail.
// Normal callers configure locking through sliding_dovetail_create().
function _sliding_dovetail_lock_create(
    enabled = false,
    entry_offset = 0,
    width = 4.0,
    recess_length = 1.0,
    recess_depth = 0.6,
    threshold_length = 1.5,
    threshold_height = 0.5,
    ramp_length = 1.0,
    spring_length = 7.0,
    spring_thickness = 1.2,
    spring_relief = 0.8,
    spring_hinge_length = 0,
    spring_hinge_thickness = 0.8,
    cut_back_clearance = true,
    back_clearance = 0.8,
    release_access = true,
    release_depth = 0.6,
    release_shape = "rectangular",
    release_taper_angle_deg = 45
) =
    let(
        spring = _sliding_dovetail_lock_spring_create(
            length = spring_length,
            thickness = spring_thickness,
            relief = spring_relief,
            hinge_length = spring_hinge_length,
            hinge_thickness = spring_hinge_thickness,
            cut_back_clearance = cut_back_clearance,
            back_clearance = back_clearance
        )
    )
    assert(is_bool(enabled),
        "sliding dovetail lock enabled must be boolean")
    assert(entry_offset >= 0,
        "sliding dovetail lock entry_offset must be >= 0")
    assert(width > 0,
        "sliding dovetail lock width must be > 0")
    assert(recess_length > 0,
        "sliding dovetail lock recess_length must be > 0")
    assert(recess_depth > 0,
        "sliding dovetail lock recess_depth must be > 0")
    assert(threshold_length > 0,
        "sliding dovetail lock threshold_length must be > 0")
    assert(threshold_height > 0,
        "sliding dovetail lock threshold_height must be > 0")
    assert(ramp_length > 0 && ramp_length < threshold_length,
        "sliding dovetail lock ramp_length must be > 0 and < threshold_length")
    assert(spring.length > threshold_length,
        "sliding dovetail lock spring length must exceed threshold length")
    assert(is_bool(release_access),
        "sliding dovetail lock release_access must be boolean")
    assert(release_depth > 0,
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
        enabled = enabled,
        entry_offset = entry_offset,
        width = width,
        recess_length = recess_length,
        recess_depth = recess_depth,
        threshold_length = threshold_length,
        threshold_height = threshold_height,
        ramp_length = ramp_length,
        spring = spring,
        release_access = release_access,
        release_depth = release_depth,
        release_shape = release_shape,
        release_taper_angle_deg = release_taper_angle_deg
    );

// Private accessor: whether the lock geometry is enabled.
function _sliding_dovetail_lock_enabled(lock) =
    lock.enabled;

// Private helper: female threshold starts at entry_offset from the fixed -X
// channel entry. With the default entry_offset=0, the ramp begins at the edge.
function _sliding_dovetail_lock_female_threshold_start_x(
    lock,
    slide,
    axial_clearance
) =
    -(slide + axial_clearance) / 2
    + lock.entry_offset;

function _sliding_dovetail_lock_female_threshold_end_x(
    lock,
    slide,
    axial_clearance
) =
    _sliding_dovetail_lock_female_threshold_start_x(
        lock,
        slide,
        axial_clearance
    )
    + lock.threshold_length;

// Private helper: in assembled coordinates the male -X/trailing end coincides
// with the female entry. The +X recess wall sits just behind the female locking
// face by axial_clearance.
function _sliding_dovetail_lock_male_recess_end_x(
    lock,
    slide,
    axial_clearance
) =
    -slide / 2
    + lock.entry_offset
    + lock.threshold_length
    + axial_clearance;

function _sliding_dovetail_lock_male_recess_start_x(
    lock,
    slide,
    axial_clearance
) =
    _sliding_dovetail_lock_male_recess_end_x(
        lock,
        slide,
        axial_clearance
    )
    - lock.recess_length;

// Private helper: flexible tongue width across Z.
function _sliding_dovetail_lock_spring_width(lock) =
    lock.width + 2 * lock.spring.relief;

// Internal validation that depends on the parent dovetail.
module _sliding_dovetail_lock_assert_valid(
    lock,
    slide,
    male_width,
    male_height,
    clearance,
    axial_clearance
) {
    assert(
        lock.entry_offset + lock.spring.length
            <= slide + axial_clearance,
        "sliding dovetail lock spring must fit inside the female channel"
    );
    assert(
        lock.spring.hinge_length == 0
            || lock.spring.hinge_length
                <= lock.spring.length - lock.threshold_length,
        "sliding dovetail lock spring hinge relief must not overlap the threshold"
    );
    assert(
        lock.spring.hinge_length == 0
            || lock.spring.length
                - lock.threshold_length
                - lock.spring.hinge_length
                >= (
                    lock.spring.thickness
                    - lock.spring.hinge_thickness
                ) / 2,
        "sliding dovetail lock hinge return ramp must not exceed 45 degrees"
    );
    assert(
        lock.entry_offset
            + lock.threshold_length
            + axial_clearance
            < slide,
        "sliding dovetail lock recess must stay inside the male slide length"
    );
    assert(
        lock.recess_length
            >= lock.threshold_length
                - lock.ramp_length
                + axial_clearance,
        "sliding dovetail lock recess is too short for the locking face and axial clearance"
    );
    assert(
        lock.width + 2 * clearance < male_width,
        "sliding dovetail lock recess must fit inside the male root width"
    );
    assert(
        lock.threshold_height > clearance,
        "sliding dovetail lock threshold must protrude beyond fit clearance"
    );
    assert(
        lock.recess_depth + clearance > lock.threshold_height,
        "sliding dovetail lock recess is too shallow for the threshold"
    );
    assert(
        lock.recess_depth < male_height,
        "sliding dovetail lock recess_depth must remain below male profile height"
    );
    assert(
        !lock.spring.cut_back_clearance
            || lock.spring.back_clearance >= lock.threshold_height,
        "sliding dovetail lock back clearance must allow the threshold to deflect"
    );
    assert(
        !lock.release_access
            || lock.release_depth < male_height,
        "sliding dovetail lock release_depth must remain below male profile height"
    );

    children();
}

// Male recess: its +X wall is the actual locking wall.
module _sliding_dovetail_lock_male_recess_cutter(
    lock,
    slide,
    axial_clearance,
    male_height,
    clearance,
    extra = 0
) {
    x0 =
        _sliding_dovetail_lock_male_recess_start_x(
            lock,
            slide,
            axial_clearance
        );
    recess_width =
        lock.width + 2 * clearance;

    translate([
        x0,
        male_height - lock.recess_depth,
        -recess_width / 2
    ])
        cube([
            lock.recess_length + extra,
            lock.recess_depth + extra,
            recess_width
        ]);
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
module _sliding_dovetail_lock_male_release_cutter(
    lock,
    slide,
    axial_clearance,
    male_height,
    clearance,
    extra = 0
) {
    _recess_x0_mm =
        _sliding_dovetail_lock_male_recess_start_x(
            lock,
            slide,
            axial_clearance
        );
    _entry_x_mm =
        -slide / 2 - extra;
    _slot_length_mm =
        _recess_x0_mm - _entry_x_mm + extra;

    _release_width_mm =
        lock.width + 2 * clearance;

    if (lock.release_access && _slot_length_mm > 0) {
        if (lock.release_shape == "rectangular") {
            translate([
                _entry_x_mm,
                male_height - lock.release_depth,
                -_release_width_mm / 2
            ])
                cube([
                    _slot_length_mm,
                    lock.release_depth + extra,
                    _release_width_mm
                ]);
        } else {
            _side_inset_mm =
                lock.release_depth
                * tan(lock.release_taper_angle_deg);
            _inner_half_width_mm =
                _release_width_mm / 2
                - _side_inset_mm;

            assert(
                _inner_half_width_mm > 0,
                "sliding dovetail lock trapezoid release closes before reaching release_depth"
            )

            // Native Y/Z profile extruded along native X.
            // Wide at the male root face, narrower at the release-depth floor.
            multmatrix([
                [0, 0, 1, _entry_x_mm],
                [1, 0, 0, 0],
                [0, 1, 0, 0],
                [0, 0, 0, 1]
            ])
                linear_extrude(height = _slot_length_mm)
                    polygon(points = [
                        [
                            male_height - lock.release_depth,
                            -_inner_half_width_mm
                        ],
                        [
                            male_height + extra,
                            -_release_width_mm / 2
                        ],
                        [
                            male_height + extra,
                            _release_width_mm / 2
                        ],
                        [
                            male_height - lock.release_depth,
                            _inner_half_width_mm
                        ]
                    ]);
        }
    }
}

// Female keepout removed from the normal channel cutter. Subtracting this
// volume from the cutter leaves an integral threshold protruding into the
// channel. The -X face is the insertion ramp; the +X face is the locking stop.
module _sliding_dovetail_lock_female_threshold_keepout(
    lock,
    slide,
    axial_clearance,
    female_height
) {
    x0 =
        _sliding_dovetail_lock_female_threshold_start_x(
            lock,
            slide,
            axial_clearance
        );
    x1 = x0 + lock.ramp_length;
    x2 = x0 + lock.threshold_length;

    translate([0, 0, -lock.width / 2])
        linear_extrude(height = lock.width)
            polygon(points = [
                [x0, female_height],
                [x1, female_height - lock.threshold_height],
                [x2, female_height - lock.threshold_height],
                [x2, female_height]
            ]);
}

// Female subtraction volumes around the threshold. The two longitudinal side
// cuts form the sides of the U-shaped tongue. A transverse cut is also needed
// whenever material continues ahead of the spring start: either because the
// threshold has a non-zero entry offset or because the parent female interface
// has a straight entry slot. The back cavity remains optional.
module _sliding_dovetail_lock_female_relief_cutter(
    lock,
    slide,
    axial_clearance,
    female_height,
    entry_slot_length = 0,
    extra = 0
) {
    spring_x0 =
        _sliding_dovetail_lock_female_threshold_start_x(
            lock,
            slide,
            axial_clearance
        );
    spring_width =
        _sliding_dovetail_lock_spring_width(lock);
    spring = lock.spring;

    side_cut_height =
        spring.thickness
        + (spring.cut_back_clearance
            ? spring.back_clearance
            : 0)
        + extra;

    union() {
        translate([
            spring_x0 - extra,
            female_height,
            -spring_width / 2 - spring.relief
        ])
            cube([
                spring.length + extra,
                side_cut_height,
                spring.relief
            ]);

        translate([
            spring_x0 - extra,
            female_height,
            spring_width / 2
        ])
            cube([
                spring.length + extra,
                side_cut_height,
                spring.relief
            ]);

        if (
            lock.entry_offset > 0
            || entry_slot_length > 0
        )
            translate([
                spring_x0 - spring.relief,
                female_height,
                -spring_width / 2 - spring.relief
            ])
                cube([
                    spring.relief + extra,
                    side_cut_height,
                    spring_width + 2 * spring.relief
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
        if (spring.hinge_length > 0) {
            spring_x1 = spring_x0 + spring.length;
            threshold_land_x1 =
                spring_x0 + lock.threshold_length;
            hinge_x0 =
                spring_x1 - spring.hinge_length;
            hinge_relief_depth =
                spring.thickness - spring.hinge_thickness;
            relief_depth_each_side =
                hinge_relief_depth / 2;
            outer_face_y =
                female_height + spring.thickness;

            // The 45-degree feature stays local. The configured hinge_length
            // is split equally between that chamfer and the following flat
            // central-web land. The same profile is mirrored from both faces.
            root_chamfer_run =
                spring.hinge_length / 2;
            flat_flex_length =
                spring.hinge_length / 2;
            root_straight_depth =
                relief_depth_each_side - root_chamfer_run;
            root_shoulder_x0 =
                spring_x1 - root_chamfer_run;
            return_ramp_run =
                hinge_x0 - threshold_land_x1;

            assert(
                root_chamfer_run <= relief_depth_each_side,
                "sliding dovetail lock root chamfer is deeper than one side of the centered hinge relief"
            )
            assert(
                flat_flex_length > 0,
                "sliding dovetail lock flat central-web land must be positive"
            )
            assert(
                return_ramp_run > 0,
                "sliding dovetail lock hinge_length leaves no return ramp before the threshold land"
            )

            // Channel-side pocket.
            translate([0, 0, -spring_width / 2])
                linear_extrude(height = spring_width)
                    polygon(points = [
                        [threshold_land_x1, female_height],
                        [spring_x1 + extra, female_height],
                        [
                            spring_x1 + extra,
                            female_height + root_straight_depth
                        ],
                        [
                            root_shoulder_x0,
                            female_height + relief_depth_each_side
                        ],
                        [
                            hinge_x0,
                            female_height + relief_depth_each_side
                        ],
                        [threshold_land_x1, female_height]
                    ]);

            // Opposing outer-face pocket. This mirrors the same relief profile
            // so the remaining hinge_thickness is centered through the tongue.
            translate([0, 0, -spring_width / 2])
                linear_extrude(height = spring_width)
                    polygon(points = [
                        [threshold_land_x1, outer_face_y],
                        [spring_x1 + extra, outer_face_y],
                        [
                            spring_x1 + extra,
                            outer_face_y - root_straight_depth
                        ],
                        [
                            root_shoulder_x0,
                            outer_face_y - relief_depth_each_side
                        ],
                        [
                            hinge_x0,
                            outer_face_y - relief_depth_each_side
                        ],
                        [threshold_land_x1, outer_face_y]
                    ]);
        }

        if (spring.cut_back_clearance)
            translate([
                spring_x0 - extra,
                female_height + spring.thickness,
                -spring_width / 2
            ])
                cube([
                    spring.length + extra,
                    spring.back_clearance + extra,
                    spring_width
                ]);
    }
}
