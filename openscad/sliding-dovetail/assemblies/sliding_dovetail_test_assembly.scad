// Interactive/reference assembly for the sliding-dovetail interface.

use <../reference/sliding_dovetail_reference.scad>

module sliding_dovetail_test_assembly_build(
    reference,
    view = "approach"
) {
    if (view == "male") {
        color([0.88, 0.10, 0.06, 1])
            sliding_dovetail_reference_male_build(reference);
    } else if (view == "female") {
        color([0.28, 0.50, 0.82, 1])
            sliding_dovetail_reference_female_build(reference);
    } else if (view == "approach") {
        sliding_dovetail_reference_pair_build(
            reference,
            position = "approach"
        );
    } else if (view == "assembled") {
        sliding_dovetail_reference_pair_build(
            reference,
            position = "assembled"
        );
    } else {
        assert(
            false,
            str(
                "Unknown sliding-dovetail test assembly view: ",
                view
            )
        );
    }
}
