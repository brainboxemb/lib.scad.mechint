// Center cutaway exposing the triangular channel-side hinge relief.

use <../../openscad/sliding-dovetail/sliding_dovetail/sliding_dovetail_render.scad>

$vpt = [20, 2.4, 2.5];
$vpr = [72, 0, 35];
$vpd = 62;

sliding_dovetail_hinge_design(view = "cutaway");
