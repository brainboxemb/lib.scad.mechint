use <00-sliding-dovetail-fixture-orientation.scad>
use <00-sliding-dovetail-hinge-fixture.scad>

reference = sliding_dovetail_hinge_fixture_reference();

sliding_dovetail_fixture_female_inspection(reference)
    sliding_dovetail_hinge_fixture_female_cutaway(reference);
