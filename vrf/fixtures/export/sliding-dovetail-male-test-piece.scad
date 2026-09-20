use <../../../openscad/sliding-dovetail/sliding_dovetail.scad>

joint =
    sliding_dovetail_create();

sliding_dovetail_male_build(
    joint,
    slide = 16
);
