#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="$root/vrf/out"
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

render_stl   "$out/fixtures/sliding-dovetail-female-test-block.stl"   "$root/vrf/fixtures/export/sliding-dovetail-female-test-block.scad"

render_stl   "$out/fixtures/sliding-dovetail-male-test-piece.stl"   "$root/vrf/fixtures/export/sliding-dovetail-male-test-piece.scad"

render_stl   "$out/fixtures/sliding-dovetail-lock-female-test-block.stl"   "$root/vrf/fixtures/export/sliding-dovetail-lock-female-test-block.scad"

render_stl   "$out/fixtures/sliding-dovetail-lock-male-test-piece.stl"   "$root/vrf/fixtures/export/sliding-dovetail-lock-male-test-piece.scad"

render_stl   "$out/fixtures/sliding-dovetail-lock-female-cutaway.stl"   "$root/vrf/fixtures/export/sliding-dovetail-lock-female-cutaway.scad"

cat > "$out/README.md" <<'EOF'
# Verification

The public object API was compiled and rendered with OpenSCAD object functions
enabled.

Printable fixtures:

- [sliding-dovetail-female-test-block.stl](fixtures/sliding-dovetail-female-test-block.stl)
- [sliding-dovetail-male-test-piece.stl](fixtures/sliding-dovetail-male-test-piece.stl)
- [sliding-dovetail-lock-female-test-block.stl](fixtures/sliding-dovetail-lock-female-test-block.stl)
- [sliding-dovetail-lock-male-test-piece.stl](fixtures/sliding-dovetail-lock-male-test-piece.stl)
- [sliding-dovetail-lock-female-cutaway.stl](fixtures/sliding-dovetail-lock-female-cutaway.stl)

For assembled STL inspection, load the locking male and locking female files
together as two separate objects in the viewer. A combined assembled STL is
intentionally not generated because STL does not preserve part identity or
colour.

Configured verification renders show assembled fit, side approach, a YZ
section through the engaged interface, and an XY section through the enabled
lock at the fixed -X entry side. The locking fixtures include the male
screwdriver slot and recess, the edge-start ramped female threshold, the two
spring side-relief cuts and the optional back-clearance cavity.
EOF
