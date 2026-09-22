// Assembled center cutaway: hinge-relief female plus locking male.

use <../../openscad/sliding-dovetail/sliding_dovetail_render.scad>

$vpt = [20, 0.8, 2.5];
$vpr = [72, 0, 35];
$vpd = 62;

sliding_dovetail_hinge_design(view = "assembled-cutaway");
