// Root-land + male-relief verification.
// A thin native-X section shows the side-print-friendly land and the consumer
// body trimmed back to the exact male interface profile.

use <../../ext/lib.scad.util/openscad/inspection.scad>
use <../../openscad/sliding-dovetail/sliding_dovetail.scad>

joint =
    sliding_dovetail_create(
        width_mm = 12,
        height_mm = 2,
        angle_deg = 30,
        root_land_depth_mm = 0.5,
        clearance_mm = 0.20,
        axial_clearance_mm = 0.25
    );

slide_len_mm = 16;
consumer_width = 12;

module trimmed_male_consumer() {
    union() {
        difference() {
            translate([
                -slide_len_mm / 2,
                -1.2,
                -consumer_width / 2
            ])
                cube([
                    slide_len_mm,
                    2.4,
                    consumer_width
                ]);

            sliding_dovetail_male_relief_cutter(
                joint,
                slide_len_mm = slide_len_mm,
                relief_width_mm = consumer_width
            );
        }

        sliding_dovetail_male_build(
            joint,
            slide_len_mm = slide_len_mm
        );
    }
}

$vpt = [0, 0.4, 0];
$vpr = [90, 0, 0];
$vpd = 48;

util_section_inspect(
    axis = "X",
    position = -0.10,
    depth = 0.20,
    direction = "Positive"
)
    trimmed_male_consumer();
