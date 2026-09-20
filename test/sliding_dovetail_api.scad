use <../openscad/sliding-dovetail/sliding_dovetail_lock.scad>
use <../openscad/sliding-dovetail/sliding_dovetail.scad>

lock = sliding_dovetail_lock_create();

joint = sliding_dovetail_create(
    lock = lock
);

assert(abs(joint.width - 10) < 0.0001);
assert(abs(joint.height - 3) < 0.0001);
assert(abs(joint.angle - 20) < 0.0001);
assert(abs(joint.clearance - 0.20) < 0.0001);
assert(abs(joint.axial_clearance - 0.25) < 0.0001);
assert(abs(joint.extra - 0.01) < 0.0001);
assert(!sliding_dovetail_lock_enabled(lock));
assert(sliding_dovetail_lock(joint) == lock);
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

translate([-12, 0, 0])
    sliding_dovetail_male_build(joint, slide = 16);

translate([12, 0, 0])
    sliding_dovetail_female_cutter(joint, slide = 16);
