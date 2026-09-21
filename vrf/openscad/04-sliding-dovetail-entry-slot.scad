// Female entry-slot verification: male parked in the straight approach pocket.

use <../../openscad/sliding-dovetail/sliding_dovetail.scad>
use <../../openscad/sliding-dovetail/reference/sliding_dovetail_reference.scad>

joint =
    sliding_dovetail_create(
        entry_slot_len_mm = 16
    );

reference =
    sliding_dovetail_reference_create(
        joint = joint,
        slide_len_mm = 16,
        female_block_length = 42
    );

$vpt = [16, 1.8, 0];
$vpr = [72, 0, 35];
$vpd = 115;

sliding_dovetail_reference_pair_build(
    reference,
    position = "entry"
);
