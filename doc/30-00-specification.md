# lib.scad.mechint specification

## Purpose

The library owns reusable mechanical interfaces between separately modeled or
printed parts. It provides mating geometry, controlled fit and optional
retention/release behavior without owning a consumer's placement or load path.

## Sliding-dovetail contract

The public sliding-dovetail interface:

- uses one shared object to define male and female geometry;
- derives profile dimensions consistently from root width, profile height,
  flank angle and optional straight lands;
- distinguishes mechanical fit clearance from tiny Boolean overlap;
- supports independent axial clearance;
- fixes the female entry side at native -X with insertion toward +X;
- may add an optional straight entry slot;
- keeps optional locking/release behavior explicitly enabled;
- may provide consumer body relief through the same interface object.

## Dependency boundary

`lib.scad.forge` may provide generic transforms, tagged CSG and cutter
mechanics. Those helpers do not own dovetail dimensions, fit, locking or release
semantics.

`lib.scad.util` is a development/verification dependency for inspection views,
not the owner of the core mechanical interface.

## Non-goals

This library does not own product-specific interface placement, structural
load-path decisions, universal print settings, or consumer assembly orientation.
