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

The normal fit/approach evidence uses the unlocked default interface. Locking
examples intentionally use a slightly shorter 5.5 mm spring tongue (about 80%
of the 7.0 mm library default), with back clearance and male screwdriver access
enabled.

Verification files are numbered so they sort by purpose:

- 01–09 — base sliding dovetail;
- 10–19 — locking sliding dovetail.

Printable fixtures include plain and locking male/female pairs, a half-width
female cutaway, a true assembled locking STL and an assembled center cutaway.
The female threshold starts at the fixed -X entry edge. The locking male has
one continuous release opening from its entry edge to the locking wall; its
access path uses the same width as the recess.

Fixture STLs use a neutral inspection orientation: each broad reference block
lies flat and the mechanical interface faces upward. This is not a prescribed
print orientation and does not encode how HUB75 or another consumer should
place the interface.

Male and female fixtures remain available independently. Fixture 13 preserves
the exact assembled position in the same neutral inspection orientation.
Fixture 14 cuts that assembly at the native Z=0 center plane so the threshold,
male recess, spring and release opening can be inspected together.

Evidence includes:

- public top-level API construction with locking disabled and enabled;
- female test block with open side entry and a solid end stop;
- assembled male/female fit view;
- side-approach view showing the X slide direction;
- a 0.20 mm YZ section through the normal engaged profile;
- a 0.20 mm XY section through the center of the integral lock.
- a 0.20 mm XZ section through a locking female with an entry slot, showing
  the transverse relief that keeps the spring tongue U-shaped.

The lock section is intended to make these relationships visible together:
continuous male release/recess opening, ramped female threshold, locking face,
flexible tongue and the optional cavity behind the tongue. The lock-section PNG
is rotated into the same intuitive upright reading direction as the other
inspection views.

lib.scad.util is used only in section/inspection adapters. The core
sliding_dovetail.scad source remains independent.
