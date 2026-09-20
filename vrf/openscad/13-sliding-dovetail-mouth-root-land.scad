// Mouth-land + root-land profile verification.
// The section must show straight lands at both ends of the angled flank.

use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../../openscad/sliding-dovetail/sliding_dovetail.scad>

joint =
    sliding_dovetail_create(
        width = 12,
        height = 2,
        angle = 30,
        root_land_depth = 0.5,
        mouth_land_depth = 0.5,
        clearance = 0.20,
        axial_clearance = 0.25
    );

slide = 16;

module profile_pair() {
    translate([0, 0, -8])
        sliding_dovetail_male_build(
            joint,
            slide = slide
        );

    translate([0, 0, 8])
        difference() {
            translate([
                -slide / 2 - 1,
                -0.8,
                -7.5
            ])
                cube([
                    slide + 2,
                    4.2,
                    15
                ]);

            sliding_dovetail_female_cutter(
                joint,
                slide = slide
            );
        }
}

$vpt = [0, 1, 0];
$vpr = [90, 0, 0];
$vpd = 58;

util_section_inspect(
    axis = "X",
    position = -0.10,
    depth = 0.20,
    direction = "Positive"
)
    profile_pair();
