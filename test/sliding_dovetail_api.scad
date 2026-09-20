use <../openscad/sliding-dovetail/sliding_dovetail.scad>

joint = sliding_dovetail_create();

assert(abs(joint.width - 10) < 0.0001);
assert(abs(joint.height - 3) < 0.0001);
assert(abs(joint.angle - 20) < 0.0001);
assert(abs(joint.clearance - 0.20) < 0.0001);
assert(abs(joint.axial_clearance - 0.25) < 0.0001);
assert(abs(joint.extra - 0.01) < 0.0001);
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

lock_joint =
    sliding_dovetail_create(
        locking = true,
        lock_cut_back_clearance = true,
        lock_release_access = false
    );

assert(sliding_dovetail_locking_enabled(lock_joint));

host_clearance_joint =
    sliding_dovetail_create(
        locking = true,
        lock_cut_back_clearance = false,
        lock_release_access = false
    );

assert(sliding_dovetail_locking_enabled(host_clearance_joint));

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
