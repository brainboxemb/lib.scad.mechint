# lib.scad.mechint

Reusable mechanical interfaces for OpenSCAD: mating geometry, controlled
clearance and optional retention/release features. Product-specific placement
and load-path decisions remain with consumers.

## Preview

<table>
  <tr>
    <th align="center">Dovetail pair</th>
    <th align="center">Integral lock section</th>
    <th align="center">Centered hinge relief</th>
  </tr>
  <tr>
    <td align="center">
      <a href="../../blob/prod/bld/png/sliding-dovetail-pair.png">
        <img src="../../raw/prod/bld/png/sliding-dovetail-pair.png" alt="Sliding dovetail male and female pair" width="100%">
      </a>
    </td>
    <td align="center">
      <a href="../../blob/prod/vrf/png/10-sliding-dovetail-lock-section.png">
        <img src="../../raw/prod/vrf/png/10-sliding-dovetail-lock-section.png" alt="Sliding dovetail integral lock section" width="100%">
      </a>
    </td>
    <td align="center">
      <a href="../../blob/prod/vrf/png/16-sliding-dovetail-lock-hinge-cutaway.png">
        <img src="../../raw/prod/vrf/png/16-sliding-dovetail-lock-hinge-cutaway.png" alt="Centered spring hinge relief cutaway" width="100%">
      </a>
    </td>
  </tr>
</table>

These images are generated from the current `prod/bld` and `prod/vrf`
branches; generated PNGs are not stored on `main`.

## Start here

- [Documentation index](doc/README.md)
- [Plan](doc/10-00-plan.md)
- [Manuals](doc/20-00-manuals.md)
- [Specification](doc/30-00-specification.md)
- [Design](doc/40-00-design.md)
- [Verification](doc/50-00-verification.md)
- [Sliding-dovetail design](openscad/sliding-dovetail/design/design.md)
- [Sliding-dovetail manual](openscad/sliding-dovetail/manual.md)
- [Latest Build](../../tree/prod/bld)
- [Latest Verification](../../tree/prod/vrf)
- [Changelog](CHANGELOG.md)

## Public entrypoint

```scad
use <openscad/sliding_dovetail.scad>

joint = sliding_dovetail_create(...);
sliding_dovetail_male_build(joint, slide_len_mm = 16);
sliding_dovetail_female_cutter(joint, slide_len_mm = 16);
```

The public file is the consumer API. The companion
`openscad/sliding-dovetail/` workspace contains private helpers, design,
reference geometry, assemblies and render adapters.

Current dependency/tool/runtime versions are intentionally not copied here.
Use `project.yml`, gitlinks, live Actions and publication provenance.
