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
    cut_back_clearance = true,
    back_clearance = 0.8,
    release_access = false,
    release_length = 3.0,
    release_depth = 5.0
) =
    assert(length > 0,
        "sliding dovetail lock spring length must be > 0")
    assert(thickness > 0,
        "sliding dovetail lock spring thickness must be > 0")
    assert(relief > 0,
        "sliding dovetail lock spring relief must be > 0")
    assert(is_bool(cut_back_clearance),
        "sliding dovetail lock cut_back_clearance must be boolean")
    assert(back_clearance >= 0,
        "sliding dovetail lock back_clearance must be >= 0")
    assert(is_bool(release_access),
        "sliding dovetail lock release_access must be boolean")
    assert(release_length > 0,
        "sliding dovetail lock release_length must be > 0")
    assert(release_depth > thickness,
        "sliding dovetail lock release_depth must exceed spring thickness")
    object(
        length = length,
        thickness = thickness,
        relief = relief,
        cut_back_clearance = cut_back_clearance,
        back_clearance = back_clearance,
        release_access = release_access,
        release_length = release_length,
        release_depth = release_depth
    );

// Function: sliding_dovetail_lock_create()
// Synopsis: Creates the internal lock configuration owned by one dovetail.
// Description:
//   Normal callers use sliding_dovetail_create(). This constructor stays
//   separate so lock geometry remains isolated from the base dovetail source.
function sliding_dovetail_lock_create(
    enabled = false,
    end_offset = 2.0,
    width = 4.0,
    recess_length = 3.0,
    recess_depth = 0.6,
    threshold_length = 1.5,
    threshold_height = 0.5,
    spring_length = 7.0,
    spring_thickness = 1.2,
    spring_relief = 0.8,
    cut_back_clearance = true,
    back_clearance = 0.8,
    release_access = false,
    release_length = 3.0,
    release_depth = 5.0
) =
    let(
        spring = _sliding_dovetail_lock_spring_create(
            length = spring_length,
            thickness = spring_thickness,
            relief = spring_relief,
            cut_back_clearance = cut_back_clearance,
            back_clearance = back_clearance,
            release_access = release_access,
            release_length = release_length,
            release_depth = release_depth
        )
    )
    assert(is_bool(enabled),
        "sliding dovetail lock enabled must be boolean")
    assert(end_offset > 0,
        "sliding dovetail lock end_offset must be > 0")
    assert(width > 0,
        "sliding dovetail lock width must be > 0")
    assert(recess_length > 0,
        "sliding dovetail lock recess_length must be > 0")
    assert(recess_depth > 0,
        "sliding dovetail lock recess_depth must be > 0")
    assert(threshold_length > 0,
        "sliding dovetail lock threshold_length must be > 0")
    assert(threshold_length < recess_length,
        "sliding dovetail lock threshold_length must be smaller than recess_length")
    assert(threshold_height > 0,
        "sliding dovetail lock threshold_height must be > 0")
    assert(spring.length > threshold_length,
        "sliding dovetail lock spring length must exceed threshold length")
    object(
        enabled = enabled,
        end_offset = end_offset,
        width = width,
        recess_length = recess_length,
        recess_depth = recess_depth,
        threshold_length = threshold_length,
        threshold_height = threshold_height,
        spring = spring
    );

// Function: sliding_dovetail_lock_enabled()
// Synopsis: Returns whether the lock geometry is enabled.
function sliding_dovetail_lock_enabled(lock) =
    lock.enabled;

// Function: sliding_dovetail_lock_male_x()
// Synopsis: Returns the male recess center in native centered coordinates.
function sliding_dovetail_lock_male_x(lock, slide) =
    slide / 2 - lock.end_offset;

// Function: sliding_dovetail_lock_female_x()
// Synopsis: Returns the female threshold center for the seated male position.
function sliding_dovetail_lock_female_x(
    lock,
    slide,
    axial_clearance
) =
    -(slide + axial_clearance) / 2
    + slide
    - lock.end_offset;

// Function: sliding_dovetail_lock_spring_width()
// Synopsis: Returns the flexible tongue width across Z.
function sliding_dovetail_lock_spring_width(lock) =
    lock.width + 2 * lock.spring.relief;

// Function: sliding_dovetail_lock_release_width()
// Synopsis: Returns the screwdriver access width across Z.
function sliding_dovetail_lock_release_width(lock) =
    sliding_dovetail_lock_spring_width(lock)
    + 2 * lock.spring.relief;

// Internal validation that depends on the parent dovetail.
module _sliding_dovetail_lock_assert_valid(
    lock,
    slide,
    male_width,
    male_height,
    clearance
) {
    assert(
        lock.end_offset >= lock.recess_length / 2,
        "sliding dovetail lock recess must stay inside the male +X end"
    );
    assert(
        lock.end_offset + lock.recess_length / 2 < slide,
        "sliding dovetail lock recess must stay inside the male slide length"
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

    children();
}

// Male subtraction volume. The recess is wider than the female threshold by
// the normal dovetail fit clearance on both Z sides.
module _sliding_dovetail_lock_male_recess_cutter(
    lock,
    slide,
    male_height,
    clearance,
    extra = 0
) {
    center_x =
        sliding_dovetail_lock_male_x(lock, slide);
    recess_width =
        lock.width + 2 * clearance;

    translate([
        center_x - lock.recess_length / 2,
        male_height - lock.recess_depth,
        -recess_width / 2
    ])
        cube([
            lock.recess_length,
            lock.recess_depth + extra,
            recess_width
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
    center_x =
        sliding_dovetail_lock_female_x(
            lock,
            slide,
            axial_clearance
        );
    x0 = center_x - lock.threshold_length / 2;
    x1 = x0 + lock.threshold_length * 0.65;
    x2 = center_x + lock.threshold_length / 2;

    translate([0, 0, -lock.width / 2])
        linear_extrude(height = lock.width)
            polygon(points = [
                [x0, female_height],
                [x1, female_height - lock.threshold_height],
                [x2, female_height - lock.threshold_height],
                [x2, female_height]
            ]);
}

// Female subtraction volumes around the threshold. The U-shaped cuts always
// isolate the tongue. The cavity behind the tongue is optional because a
// consumer may already provide free space in the host part.
module _sliding_dovetail_lock_female_relief_cutter(
    lock,
    slide,
    axial_clearance,
    female_height,
    extra = 0
) {
    center_x =
        sliding_dovetail_lock_female_x(
            lock,
            slide,
            axial_clearance
        );
    spring_width =
        sliding_dovetail_lock_spring_width(lock);
    spring = lock.spring;

    free_x =
        center_x
        - lock.threshold_length / 2
        - spring.relief;

    side_cut_height =
        spring.thickness
        + (spring.cut_back_clearance
            ? spring.back_clearance
            : 0)
        + extra;

    union() {
        // Two longitudinal cuts and one transverse cut create the U-shaped
        // isolation around the free end of the cantilever tongue.
        translate([
            free_x,
            female_height,
            -spring_width / 2 - spring.relief
        ])
            cube([
                spring.length,
                side_cut_height,
                spring.relief
            ]);

        translate([
            free_x,
            female_height,
            spring_width / 2
        ])
            cube([
                spring.length,
                side_cut_height,
                spring.relief
            ]);

        translate([
            free_x - spring.relief,
            female_height,
            -spring_width / 2 - spring.relief
        ])
            cube([
                spring.relief,
                side_cut_height,
                spring_width + 2 * spring.relief
            ]);

        // Optional cavity behind the tongue. When disabled, the consuming part
        // must itself provide free space behind a spring of spring.thickness.
        if (spring.cut_back_clearance)
            translate([
                free_x,
                female_height + spring.thickness,
                -spring_width / 2
            ])
                cube([
                    spring.length,
                    spring.back_clearance + extra,
                    spring_width
                ]);

        // Optional service opening for a small screwdriver. This is separate
        // from the mechanical flex cavity because it may intentionally break
        // through a thin outer wall.
        if (spring.release_access)
            translate([
                center_x - spring.release_length / 2,
                female_height + spring.thickness,
                -sliding_dovetail_lock_release_width(lock) / 2
            ])
                cube([
                    spring.release_length,
                    spring.release_depth - spring.thickness + extra,
                    sliding_dovetail_lock_release_width(lock)
                ]);
    }
}
