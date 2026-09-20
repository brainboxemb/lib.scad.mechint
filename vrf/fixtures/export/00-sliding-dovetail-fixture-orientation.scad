// Neutral STL inspection orientation for verification fixtures.
//
// Core library coordinates remain unchanged. These transforms only make the
// standalone STL fixtures easier to inspect in generic CAD/STL viewers.

module sliding_dovetail_fixture_female_inspection(reference) {
    // Female host body lies flat; channel/interface opens upward.
    translate([0, 0, reference.female_block_depth])
        rotate([-90, 0, 0])
            children();
}

module sliding_dovetail_fixture_male_inspection(reference) {
    // Male host body lies flat; dovetail protrudes upward.
    translate([0, 0, reference.male_block_depth])
        rotate([90, 0, 0])
            children();
}

module sliding_dovetail_fixture_assembly_inspection(reference) {
    // Preserve true assembled coordinates and lay the female host flat.
    sliding_dovetail_fixture_female_inspection(reference)
        children();
}
