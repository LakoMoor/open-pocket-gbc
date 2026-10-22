#!/usr/bin/env bash
# Builds the home screen ROM: fw/home/home.gb (embedded in the firmware by fw/build.sh).
set -euo pipefail
cd "$(dirname "$0")"
RGBDS=${RGBDS:-/e/tools/rgbds}
# rgbasm & co: from $RGBDS (Windows .exe) or from PATH
rgb() { if [ -x "$RGBDS/$1.exe" ]; then "$RGBDS/$1.exe" "${@:2}"; else "$1" "${@:2}"; fi; }
PY=${PY:-python3}; "$PY" -c '' 2>/dev/null || PY=python
"$PY" gen.py
rgb rgbasm -o build/home.o home.asm
rgb rgblink -t -o home.gb -m build/home.map -n build/home.sym build/home.o
rgb rgbfix -v -c -p 0xFF -t "OPEN POCKET" -m 0 -r 0 home.gb
echo "home.gb $(wc -c < home.gb) bytes"
rgb rgbasm -o build/printer.o printer.asm
rgb rgblink -t -o printer.gb build/printer.o
rgb rgbfix -v -C -p 0xFF -t "OP PRINTER" -m 0 -r 0 printer.gb
echo "printer.gb $(wc -c < printer.gb) bytes"
