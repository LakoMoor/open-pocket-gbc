#!/usr/bin/env bash
# Builds the Tang Nano 20K simulator (build/tang_sim/tang_sim[.exe]) with Verilator: the real
# gbc_top RTL, the GHDL netlists of the CPU and APU, models of the Gowin parts and the SDRAM.
# Windows: OSS CAD Suite + MinGW from E:\tools. macOS / Linux: verilator (5.x), make and a C++
# compiler from PATH (brew install verilator / apt install verilator), or OSS CAD Suite via $TOOLS.
set -euo pipefail
cd "$(dirname "$0")/../.."
OUT=build/tang_sim
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    TOOLS=${TOOLS:-/e/tools/oss-cad-suite}
    export VERILATOR_ROOT=${VERILATOR_ROOT:-$TOOLS/share/verilator}
    export PATH=$TOOLS/bin:$TOOLS/lib:/c/Users/$USERNAME/mingw64/bin:$PATH
    VERILATOR=verilator_bin MAKE=mingw32-make LDFLAGS="-static" ;;
  *)
    if [ -n "${TOOLS:-}" ]; then export PATH=$TOOLS/bin:$PATH; fi
    VERILATOR=verilator MAKE=make LDFLAGS=""
    if [ "$(uname -s)" = Linux ]; then LDFLAGS="-pthread"; fi ;;
esac
JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
SRCS=$(sed 's/#.*//' rtl/files.f | tr ' ' '\n' | grep -v -E 'gowin_prims|pll_gb|pll_hdmi|ghdl_stubs|audio_clock_regeneration|^$')
mkdir -p "$OUT"
$VERILATOR --cc --exe --timing -O3 --x-assign fast --x-initial fast \
    -Wno-fatal -Wno-lint -Wno-style -Wno-MULTIDRIVEN -Wno-UNOPTFLAT -Wno-TIMESCALEMOD -Wno-INITIALDLY \
    +1364-2005ext+v --top-module sim_top -Irtl/gb -Irtl/sys -Irtl/gb_port \
    -Mdir "$OUT" -o tang_sim \
    sim/tang/sim_prims.v sim/tang/sdram_model.v sim/tang/hdmi_audio_stub.sv rtl/gen/GBse.v rtl/gen/gbc_snd.v $SRCS sim/tang/sim_top.sv sim/tang/main.cpp \
    -CFLAGS "-O2 -std=c++17" ${LDFLAGS:+-LDFLAGS "$LDFLAGS"} 2>&1 | grep -E "%Error|error:" | head -30 || true
$MAKE -j"$JOBS" -C "$OUT" -f Vsim_top.mk > "$OUT/make.log" 2>&1 || { grep -E "error" "$OUT/make.log" | head -20; exit 1; }
ls -la "$OUT"/tang_sim*
