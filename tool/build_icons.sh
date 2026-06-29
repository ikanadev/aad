#!/usr/bin/env bash
set -euo pipefail
mkdir -p assets/icons/vec
for f in design/icons/*.svg; do
  name="$(basename "$f" .svg)"
  echo "compiling $name"
  dart run vector_graphics_compiler -i "$f" -o "assets/icons/vec/$name.vec"
done
