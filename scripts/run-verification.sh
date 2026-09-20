#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="$root/vrf/out"

rm -rf "$out/fixtures"
mkdir -p "$out/fixtures"

run_openscad_checked() {
  local log
  log="$(mktemp)"

  if ! "$@" 2>"$log"; then
    cat "$log" >&2
    rm -f "$log"
    return 1
  fi

  cat "$log" >&2

  if grep -Eq     'WARNING: (Ignoring unknown (function|module)|undefined operation|Unable to convert|.*parameter could not be converted|Object may not be a valid 2-manifold)'     "$log"; then
    echo "verification: fatal OpenSCAD warning detected" >&2
    rm -f "$log"
    return 1
  fi

  rm -f "$log"
}

render_stl() {
  local output="$1"
  local source="$2"

  run_openscad_checked     xvfb-run -a openscad       --enable=object-function       --render       -o "$output"       "$source"

  test -s "$output"
}

render_stl   "$out/sliding-dovetail-api.stl"   "$root/test/sliding_dovetail_api.scad"

render_stl   "$out/fixtures/01-sliding-dovetail-male-test-piece.stl"   "$root/vrf/fixtures/export/01-sliding-dovetail-male-test-piece.scad"

render_stl   "$out/fixtures/02-sliding-dovetail-female-test-block.stl"   "$root/vrf/fixtures/export/02-sliding-dovetail-female-test-block.scad"

render_stl   "$out/fixtures/10-sliding-dovetail-lock-male-test-piece.stl"   "$root/vrf/fixtures/export/10-sliding-dovetail-lock-male-test-piece.scad"

render_stl   "$out/fixtures/11-sliding-dovetail-lock-female-test-block.stl"   "$root/vrf/fixtures/export/11-sliding-dovetail-lock-female-test-block.scad"

render_stl   "$out/fixtures/12-sliding-dovetail-lock-female-cutaway.stl"   "$root/vrf/fixtures/export/12-sliding-dovetail-lock-female-cutaway.scad"

cat > "$out/README.md" <<'EOF'
# Verification

The public object API was compiled and rendered with OpenSCAD object functions
enabled.

Fixture numbering:

- 01–09 — base sliding dovetail;
- 10–19 — locking sliding dovetail.

Printable / inspectable fixtures:

- [01-sliding-dovetail-male-test-piece.stl](fixtures/01-sliding-dovetail-male-test-piece.stl)
- [02-sliding-dovetail-female-test-block.stl](fixtures/02-sliding-dovetail-female-test-block.stl)
- [10-sliding-dovetail-lock-male-test-piece.stl](fixtures/10-sliding-dovetail-lock-male-test-piece.stl)
- [11-sliding-dovetail-lock-female-test-block.stl](fixtures/11-sliding-dovetail-lock-female-test-block.stl)
- [12-sliding-dovetail-lock-female-cutaway.stl](fixtures/12-sliding-dovetail-lock-female-cutaway.stl)

Fixture STLs use a neutral inspection orientation. Each reference block lies
flat with its mechanical interface facing upward. This orientation belongs to
verification only; it does not prescribe a print or consumer-product
orientation.

Male and female fixtures are oriented independently for inspection. Use the
assembly/section PNG evidence for mating inspection, or reposition the two STL
files manually in a viewer.

Configured verification renders show assembled fit, side approach, a YZ
section through the engaged interface, and a rotated XY lock section at the
fixed -X entry side. The locking male uses one continuous release opening from
the entry edge to the locking wall: the access path has the same width as the
recess, so there is no narrow-to-wide step.
EOF
