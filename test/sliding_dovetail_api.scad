use <../openscad/sliding-dovetail/sliding_dovetail.scad>

joint = sliding_dovetail_create();

assert(abs(joint.width - 10) < 0.0001);
assert(abs(joint.height - 3) < 0.0001);
assert(abs(joint.angle - 20) < 0.0001);
assert(abs(sliding_dovetail_root_land_depth(joint)) < 0.0001);
assert(abs(sliding_dovetail_mouth_land_depth(joint)) < 0.0001);
assert(abs(joint.clearance - 0.20) < 0.0001);
assert(abs(joint.axial_clearance - 0.25) < 0.0001);
assert(abs(joint.extra - 0.01) < 0.0001);
assert(abs(sliding_dovetail_entry_slot_length(joint)) < 0.0001);
assert(!sliding_dovetail_locking_enabled(joint));

assert(
    abs(sliding_dovetail_mouth_width(joint) - 7.8161785944)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_mouth_width(joint) - 8.2161785944)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_height(joint) - 3.2)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_root_width(joint) - 10.5455880937)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_slide(joint, 16) - 16.25)
    < 0.0001
);

root_land_joint =
    sliding_dovetail_create(
        width = 12,
        height = 2,
        angle = 30,
        root_land_depth = 0.5
    );

assert(
    abs(sliding_dovetail_root_land_depth(root_land_joint) - 0.5)
    < 0.0001
);
assert(
    abs(sliding_dovetail_mouth_width(root_land_joint) - 10.2679491924)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_root_width(root_land_joint) - 12.6309401077)
    < 0.0001
);

both_land_joint =
    sliding_dovetail_create(
        width = 12,
        height = 2,
        angle = 30,
        root_land_depth = 0.5,
        mouth_land_depth = 0.5
    );

assert(
    abs(sliding_dovetail_mouth_land_depth(both_land_joint) - 0.5)
    < 0.0001
);
assert(
    abs(sliding_dovetail_mouth_width(both_land_joint) - 10.8452994616)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_root_width(both_land_joint) - 12.6309401077)
    < 0.0001
);

entry_joint =
    sliding_dovetail_create(
        entry_slot_length = 16
    );

assert(
    abs(sliding_dovetail_entry_slot_length(entry_joint) - 16)
    < 0.0001
);
assert(
    abs(sliding_dovetail_female_total_length(entry_joint, 16) - 32.25)
    < 0.0001
);

lock_joint =
    sliding_dovetail_create(
        locking = true,
        lock_cut_back_clearance = true,
        lock_release_access = true
    );

assert(sliding_dovetail_locking_enabled(lock_joint));
assert(abs(lock_joint.lock.entry_offset) < 0.0001);
assert(lock_joint.lock.release_access);

host_clearance_joint =
    sliding_dovetail_create(
        locking = true,
        lock_cut_back_clearance = false,
        lock_release_access = true
    );

assert(sliding_dovetail_locking_enabled(host_clearance_joint));

entry_lock_joint =
    sliding_dovetail_create(
        entry_slot_length = 16,
        locking = true,
        lock_spring_length = 5.5,
        lock_cut_back_clearance = true,
        lock_release_access = true
    );

assert(sliding_dovetail_locking_enabled(entry_lock_joint));
assert(
    abs(sliding_dovetail_entry_slot_length(entry_lock_joint) - 16)
    < 0.0001
);

hinge_lock_joint =
    sliding_dovetail_create(
        entry_slot_length = 16,
        locking = true,
        lock_spring_length = 7,
        lock_spring_thickness = 3.3,
        lock_spring_hinge_length = 1.65,
        lock_spring_hinge_thickness = 0.8,
        lock_cut_back_clearance = false
    );

assert(sliding_dovetail_locking_enabled(hinge_lock_joint));
assert(abs(hinge_lock_joint.lock.spring.hinge_length - 1.65) < 0.0001);
assert(abs(hinge_lock_joint.lock.spring.hinge_thickness - 0.8) < 0.0001);
assert(!hinge_lock_joint.lock.spring.cut_back_clearance);

trapezoid_lock_joint =
    sliding_dovetail_create(
        width = 12,
        height = 2.5,
        angle = 30,
        root_land_depth = 0.5,
        mouth_land_depth = 0.5,
        entry_slot_length = 16,
        locking = true,
        lock_spring_thickness = 1.3,
        lock_spring_transverse_relief_shape = "trapezoid",
        lock_spring_transverse_relief_top_length = 0.4,
        lock_cut_back_clearance = false
    );

assert(sliding_dovetail_locking_enabled(trapezoid_lock_joint));
assert(
    trapezoid_lock_joint.lock.spring.transverse_relief_shape
        == "trapezoid"
);
assert(
    abs(
        trapezoid_lock_joint.lock.spring.transverse_relief_top_length
            - 0.4
    ) < 0.0001
);


// Exercise the public builders with plain and locking interfaces.
translate([-36, 0, 0])
    sliding_dovetail_male_build(
        joint,
        slide = 16
    );

translate([-12, 0, 0])
    sliding_dovetail_female_cutter(
        joint,
        slide = 16
    );

translate([12, 0, 0])
    sliding_dovetail_male_build(
        lock_joint,
        slide = 16
    );

translate([36, 0, 0])
    sliding_dovetail_female_cutter(
        lock_joint,
        slide = 16
    );

translate([60, 0, 0])
    sliding_dovetail_female_cutter(
        host_clearance_joint,
        slide = 16
    );

translate([84, 0, 0])
    sliding_dovetail_female_cutter(
        entry_joint,
        slide = 16
    );

translate([108, 0, 0])
    sliding_dovetail_female_cutter(
        entry_lock_joint,
        slide = 16
    );


translate([132, 0, 0])
    sliding_dovetail_male_build(
        root_land_joint,
        slide = 16
    );

translate([156, 0, 0])
    sliding_dovetail_male_relief_cutter(
        root_land_joint,
        slide = 16,
        relief_width = 12
    );


translate([180, 0, 0])
    sliding_dovetail_male_build(
        both_land_joint,
        slide = 16
    );

translate([204, 0, 0])
    sliding_dovetail_female_cutter(
        both_land_joint,
        slide = 16
    );

translate([228, 0, 0])
    sliding_dovetail_female_cutter(
        hinge_lock_joint,
        slide = 16
    );

translate([252, 0, 0])
    sliding_dovetail_female_cutter(
        trapezoid_lock_joint,
        slide = 16
    );
