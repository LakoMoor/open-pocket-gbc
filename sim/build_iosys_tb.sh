#!/usr/bin/env bash
# Builds the Verilator bench for the I/O system (build/viosys/Viosys.exe).
set -euo pipefail
cd "$(dirname "$0")/.."
export VERILATOR_ROOT=${VERILATOR_ROOT:-/e/tools/oss-cad-suite/share/verilator}
export PATH=/e/tools/oss-cad-suite/bin:/e/tools/oss-cad-suite/lib:/c/Users/lakom/mingw64/bin:$PATH
rm -rf build/viosys
verilator_bin --cc --exe -O2 -Wno-fatal -Wno-lint -Wno-style --top-module iosys -Irtl/sys \
    -Mdir build/viosys rtl/rv/femtorv32_quark.v rtl/sys/spi_byte.sv rtl/sys/iosys.sv sim/iosys_tb.cpp -CFLAGS -O2 2>&1 | grep "%Error" || true
mingw32-make -s -j8 -C build/viosys -f Viosys.mk > build/viosys.log 2>&1 || { tail -20 build/viosys.log; exit 1; }
echo "built build/viosys/Viosys.exe"
