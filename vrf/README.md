# Sliding dovetail verification

Verification isolates the mechanical interface from any consuming product.

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

The normal fit/approach evidence uses the unlocked default interface. A focused
lock-section render creates the same interface with `locking = true`,
`lock_cut_back_clearance = true` and male screwdriver access enabled.

Printable fixtures include both plain and locking male/female pairs plus a
half-width female cutaway STL. The female threshold starts at the fixed -X
entry edge; the locking male includes the screwdriver-access slot.

For assembled STL inspection, import the locking male and locking female files
together as two separate objects. A combined assembled STL is intentionally not
published because STL does not retain part identity or colour and therefore
makes the interface harder to inspect.

Evidence includes:

- public top-level API construction with locking disabled and enabled;
- female test block with open side entry and a solid end stop;
- assembled male/female fit view;
- side-approach view showing the X slide direction;
- a 0.20 mm YZ section through the normal engaged profile;
- a 0.20 mm XY section through the center of the integral lock.

The lock section is intended to make these relationships visible together:
male recess, male screwdriver slot, ramped female threshold, locking face,
flexible tongue and the optional cavity behind the tongue.

`lib.scad.util` is used only in section/inspection adapters. The core
`sliding_dovetail.scad` source remains independent.
