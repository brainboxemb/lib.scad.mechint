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
    release_depth = 0.6
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
        release_depth = release_depth
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
// It uses the same Z width as the recess, so the release feature is one
// continuous straight opening rather than a narrow slot widening into a pocket.
module _sliding_dovetail_lock_male_release_cutter(
    lock,
    slide,
    axial_clearance,
    male_height,
    clearance,
    extra = 0
) {
    recess_x0 =
        _sliding_dovetail_lock_male_recess_start_x(
            lock,
            slide,
            axial_clearance
        );
    entry_x =
        -slide / 2 - extra;
    slot_length =
        recess_x0 - entry_x + extra;

    release_width =
        lock.width + 2 * clearance;

    if (lock.release_access && slot_length > 0)
        translate([
            entry_x,
            male_height - lock.release_depth,
            -release_width / 2
        ])
            cube([
                slot_length,
                lock.release_depth + extra,
                release_width
            ]);
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

        // Optional print-friendly hinge relief. The tongue keeps its full
        // outer/rear face, while a triangular cut from the channel side tapers
        // the last part of the spring down to hinge_thickness at its fixed end.
        // hinge_length = 0 preserves the legacy spring geometry exactly.
        if (spring.hinge_length > 0) {
            spring_x1 = spring_x0 + spring.length;
            hinge_x0 = spring_x1 - spring.hinge_length;
            hinge_relief_depth =
                spring.thickness - spring.hinge_thickness;

            translate([0, 0, -spring_width / 2])
                linear_extrude(height = spring_width)
                    polygon(points = [
                        [hinge_x0, female_height],
                        [spring_x1 + extra, female_height],
                        [
                            spring_x1 + extra,
                            female_height + hinge_relief_depth
                        ]
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
