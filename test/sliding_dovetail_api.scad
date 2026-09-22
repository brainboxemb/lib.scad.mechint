use <../openscad/sliding_dovetail.scad>

joint = sliding_dovetail_create();

assert(abs(joint.width_mm - 10) < 0.0001);
assert(abs(joint.height_mm - 3) < 0.0001);
assert(abs(joint.angle_deg - 20) < 0.0001);
assert(abs(sliding_dovetail_root_land_depth_mm(joint)) < 0.0001);
assert(abs(sliding_dovetail_mouth_land_depth_mm(joint)) < 0.0001);
assert(abs(joint.clearance_mm - 0.20) < 0.0001);
assert(abs(joint.axial_clearance_mm - 0.25) < 0.0001);
assert(abs(joint.extra_mm - 0.01) < 0.0001);
assert(abs(sliding_dovetail_entry_slot_len_mm(joint)) < 0.0001);
assert(!sliding_dovetail_is_locking_enabled(joint));

assert(
    abs(sliding_dovetail_mouth_width_mm(joint) - 7.8161785944)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_mouth_width_mm(joint) - 8.2161785944)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_height_mm(joint) - 3.2)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_root_width_mm(joint) - 10.5455880937)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_slide_len_mm(joint, 16) - 16.25)
    < 0.0001
);

root_land_joint =
    sliding_dovetail_create(
        width_mm = 12,
        height_mm = 2,
        angle_deg = 30,
        root_land_depth_mm = 0.5
    );

assert(
    abs(sliding_dovetail_root_land_depth_mm(root_land_joint) - 0.5)
    < 0.0001
);
assert(
    abs(sliding_dovetail_mouth_width_mm(root_land_joint) - 10.2679491924)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_root_width_mm(root_land_joint) - 12.6309401077)
    < 0.0001
);

both_land_joint =
    sliding_dovetail_create(
        width_mm = 12,
        height_mm = 2,
        angle_deg = 30,
        root_land_depth_mm = 0.5,
        mouth_land_depth_mm = 0.5
    );

assert(
    abs(sliding_dovetail_mouth_land_depth_mm(both_land_joint) - 0.5)
    < 0.0001
);
assert(
    abs(sliding_dovetail_mouth_width_mm(both_land_joint) - 10.8452994616)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_root_width_mm(both_land_joint) - 12.6309401077)
    < 0.0001
);

entry_joint =
    sliding_dovetail_create(
        entry_slot_len_mm = 16
    );

assert(
    abs(sliding_dovetail_entry_slot_len_mm(entry_joint) - 16)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_total_len_mm(entry_joint, 16) - 32.25)
    < 0.0001
);

lock_joint =
    sliding_dovetail_create(
        is_locking_enabled = true,
        lock_has_back_clearance = true,
        lock_has_release_access = true
    );

assert(sliding_dovetail_is_locking_enabled(lock_joint));
assert(abs(lock_joint.lock.entry_offset_mm) < 0.0001);
assert(lock_joint.lock.has_release_access);
assert(lock_joint.lock.release_shape == "rectangular");

trapezoid_release_joint =
    sliding_dovetail_create(
        width_mm = 12,
        height_mm = 2.5,
        angle_deg = 30,
        root_land_depth_mm = 0.5,
        mouth_land_depth_mm = 0.5,
        is_locking_enabled = true,
        lock_has_release_access = true,
        lock_release_depth_mm = 0.6,
        lock_release_shape = "trapezoid",
        lock_release_taper_angle_deg = 45
    );

assert(sliding_dovetail_is_locking_enabled(trapezoid_release_joint));
assert(trapezoid_release_joint.lock.release_shape == "trapezoid");
assert(
    abs(trapezoid_release_joint.lock.release_taper_angle_deg - 45)
        < 0.0001
);


host_clearance_joint =
    sliding_dovetail_create(
        is_locking_enabled = true,
        lock_has_back_clearance = false,
        lock_has_release_access = true
    );

assert(sliding_dovetail_is_locking_enabled(host_clearance_joint));

entry_lock_joint =
    sliding_dovetail_create(
        entry_slot_len_mm = 16,
        is_locking_enabled = true,
        lock_spring_len_mm = 5.5,
        lock_has_back_clearance = true,
        lock_has_release_access = true
    );

assert(sliding_dovetail_is_locking_enabled(entry_lock_joint));
assert(
    abs(sliding_dovetail_entry_slot_len_mm(entry_lock_joint) - 16)
    < 0.0001
);

hinge_lock_joint =
    sliding_dovetail_create(
        entry_slot_len_mm = 16,
        is_locking_enabled = true,
        lock_spring_len_mm = 7,
        lock_spring_thickness_mm = 3.3,
        lock_spring_hinge_len_mm = 1.65,
        lock_spring_hinge_thickness_mm = 0.8,
        lock_has_back_clearance = false
    );

assert(sliding_dovetail_is_locking_enabled(hinge_lock_joint));
assert(abs(hinge_lock_joint.lock.spring.hinge_len_mm - 1.65) < 0.0001);
assert(abs(hinge_lock_joint.lock.spring.hinge_thickness_mm - 0.8) < 0.0001);
assert(!hinge_lock_joint.lock.spring.has_back_clearance);

// Exercise the public builders with plain and locking interfaces.
translate([-36, 0, 0])
    sliding_dovetail_male_build(
        joint,
        slide_len_mm = 16
    );

translate([-12, 0, 0])
    sliding_dovetail_female_cutter(
        joint,
        slide_len_mm = 16
    );

translate([12, 0, 0])
    sliding_dovetail_male_build(
        lock_joint,
        slide_len_mm = 16
    );

translate([36, 0, 0])
    sliding_dovetail_female_cutter(
        lock_joint,
        slide_len_mm = 16
    );

translate([60, 0, 0])
    sliding_dovetail_female_cutter(
        host_clearance_joint,
        slide_len_mm = 16
    );

translate([84, 0, 0])
    sliding_dovetail_female_cutter(
        entry_joint,
        slide_len_mm = 16
    );

translate([108, 0, 0])
    sliding_dovetail_female_cutter(
        entry_lock_joint,
        slide_len_mm = 16
    );


translate([132, 0, 0])
    sliding_dovetail_male_build(
        root_land_joint,
        slide_len_mm = 16
    );

translate([156, 0, 0])
    sliding_dovetail_male_relief_cutter(
        root_land_joint,
        slide_len_mm = 16,
        relief_width_mm = 12
    );


translate([180, 0, 0])
    sliding_dovetail_male_build(
        both_land_joint,
        slide_len_mm = 16
    );

translate([204, 0, 0])
    sliding_dovetail_female_cutter(
        both_land_joint,
        slide_len_mm = 16
    );

translate([228, 0, 0])
    sliding_dovetail_female_cutter(
        hinge_lock_joint,
        slide_len_mm = 16
    );

translate([252, 0, 0])
    sliding_dovetail_male_build(
        trapezoid_release_joint,
        slide_len_mm = 16
    );
