// Neutral STL inspection orientation for verification fixtures.
//
// Core library coordinates remain unchanged. These transforms only make the
// standalone STL fixtures easier to inspect in generic CAD/STL viewers.

module sliding_dovetail_fixture_female_inspection(obj) {
    // Female host body lies flat; channel/interface opens upward.
    translate([0, 0, obj.female_block_depth_mm_mm])
        rotate([-90, 0, 0])
            children();
}

module sliding_dovetail_fixture_male_inspection(obj) {
    // Male host body lies flat; dovetail protrudes upward.
    translate([0, 0, obj.male_block_depth_mm])
        rotate([90, 0, 0])
            children();
}

module sliding_dovetail_fixture_assembly_inspection(obj) {
    // Preserve true assembled coordinates and lay the female host flat.
    sliding_dovetail_fixture_female_inspection(obj)
        children();
}
