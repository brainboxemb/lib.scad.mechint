// Mouth-land + root-land profile verification.
// The section must show straight lands at both ends of the angled flank.

use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../../openscad/sliding_dovetail.scad>

joint =
    sliding_dovetail_create(
        width_mm = 12,
        height_mm = 2,
        angle_deg = 30,
        root_land_depth_mm = 0.5,
        mouth_land_depth_mm = 0.5,
        clearance_mm = 0.20,
        axial_clearance_mm = 0.25
    );

slide_len_mm = 16;

module profile_pair() {
    translate([0, 0, -8])
        sliding_dovetail_male_build(
            joint,
            slide_len_mm = slide_len_mm
        );

    translate([0, 0, 8])
        difference() {
            translate([
                -slide_len_mm / 2 - 1,
                -0.8,
                -7.5
            ])
                cube([
                    slide_len_mm + 2,
                    4.2,
                    15
                ]);

            sliding_dovetail_female_cutter(
                joint,
                slide_len_mm = slide_len_mm
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
