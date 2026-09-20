//////////////////////////////////////////////////////////////////////
// LibFile: sliding_dovetail_lock.scad
//   Optional integral locking geometry for a sliding-dovetail interface.
//////////////////////////////////////////////////////////////////////

// Function: sliding_dovetail_lock_create()
// Synopsis: Creates optional locking configuration for a sliding dovetail.
// Arguments:
//   enabled = Whether locking geometry is enabled.
//   end_offset = Recess center distance from the male +X / leading end.
//   width = Width of the locking threshold across Z.
//   recess_length = Male recess length along X.
//   recess_depth = Male recess depth below the root surface.
//   threshold_length = Female locking threshold length along X.
//   threshold_height = Threshold protrusion from the female channel roof.
//   spring_length = Female cantilever length from free end to anchor.
//   spring_thickness = Remaining cantilever thickness above the channel.
//   flex_clearance = Cavity height above the cantilever.
//   relief = Width of spring isolation slots.
//   release_length = Screwdriver access opening length along X.
//   release_depth = Access depth measured outward from the channel roof.
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
    flex_clearance = 0.8,
    relief = 0.8,
    release_length = 3.0,
    release_depth = 5.0
) =
    assert(
        is_bool(enabled),
        "sliding dovetail lock enabled must be boolean"
    )
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
    assert(spring_length > threshold_length,
        "sliding dovetail lock spring_length must exceed threshold_length")
    assert(spring_thickness > 0,
        "sliding dovetail lock spring_thickness must be > 0")
    assert(flex_clearance > 0,
        "sliding dovetail lock flex_clearance must be > 0")
    assert(relief > 0,
        "sliding dovetail lock relief must be > 0")
    assert(release_length > 0,
        "sliding dovetail lock release_length must be > 0")
    assert(release_depth > spring_thickness,
        "sliding dovetail lock release_depth must exceed spring_thickness")
    object(
        enabled = enabled,
        end_offset = end_offset,
        width = width,
        recess_length = recess_length,
        recess_depth = recess_depth,
        threshold_length = threshold_length,
        threshold_height = threshold_height,
        spring_length = spring_length,
        spring_thickness = spring_thickness,
        flex_clearance = flex_clearance,
        relief = relief,
        release_length = release_length,
        release_depth = release_depth
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
// Synopsis: Returns the female threshold center for the seated reference position.
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
    lock.width + 2 * lock.relief;

// Function: sliding_dovetail_lock_release_width()
// Synopsis: Returns the screwdriver access width across Z.
function sliding_dovetail_lock_release_width(lock) =
    sliding_dovetail_lock_spring_width(lock)
    + 2 * lock.relief;

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
// channel. The -X face is a ramp for insertion; the +X face is the stop.
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

// Female subtraction volumes around the threshold. These isolate a thin
// cantilever tongue in the channel roof and add a larger screwdriver access
// opening above its free end.
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
    release_width =
        sliding_dovetail_lock_release_width(lock);

    free_x =
        center_x
        - lock.threshold_length / 2
        - lock.relief;
    relief_height =
        lock.spring_thickness
        + lock.flex_clearance;

    union() {
        // Side isolation slots.
        translate([
            free_x,
            female_height,
            -spring_width / 2 - lock.relief
        ])
            cube([
                lock.spring_length,
                relief_height,
                lock.relief
            ]);

        translate([
            free_x,
            female_height,
            spring_width / 2
        ])
            cube([
                lock.spring_length,
                relief_height,
                lock.relief
            ]);

        // Free-end isolation slot.
        translate([
            free_x - lock.relief,
            female_height,
            -spring_width / 2 - lock.relief
        ])
            cube([
                lock.relief,
                relief_height,
                spring_width + 2 * lock.relief
            ]);

        // Flex cavity above the tongue.
        translate([
            free_x,
            female_height + lock.spring_thickness,
            -spring_width / 2
        ])
            cube([
                lock.spring_length,
                lock.flex_clearance,
                spring_width
            ]);

        // Larger access opening above the threshold/free end.
        translate([
            center_x - lock.release_length / 2,
            female_height + lock.spring_thickness,
            -release_width / 2
        ])
            cube([
                lock.release_length,
                lock.release_depth - lock.spring_thickness + extra,
                release_width
            ]);
    }
}
