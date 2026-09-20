# Sliding dovetail verification

The first verification isolates the mechanical interface from any consuming
product.

Default interface:

| Parameter | Value |
| --- | ---: |
| male root width | 10.0 mm |
| profile height | 3.0 mm |
| flank angle | 20° |
| derived male mouth | 7.82 mm |
| female clearance | 0.20 mm |
| axial clearance | 0.25 mm |
| boolean extra | 0.01 mm |
| male slide length | 16.0 mm |

Evidence includes:

- male public-API construction;
- female test block with open side entry and a solid end stop;
- assembled male/female fit view;
- side-approach view showing the X slide direction;
- a 0.20 mm YZ section centered at X=8.0 mm.

`lib.scad.util` is used only in the section-view adapter. The core
`sliding_dovetail.scad` source remains independent.
