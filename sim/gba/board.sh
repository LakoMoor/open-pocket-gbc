#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
TOOLS=${TOOLS:-/e/tools/oss-cad-suite}
export PATH="$TOOLS/bin:$TOOLS/lib:/c/Users/lakom/mingw64/bin:$PATH"
export VERILATOR_ROOT=${VERILATOR_ROOT:-$TOOLS/share/verilator}
V=verilator
command -v verilator_bin >/dev/null && V=verilator_bin
MAKE=make
command -v mingw32-make >/dev/null && MAKE=mingw32-make
SRCS=$(sed 's/#.*//' rtl/gba/files.f | grep -v -E 'gowin_prims|pll_gb|pll_hdmi|audio_clock_regeneration|^$' | tr '\n' ' ')
mkdir -p build/gba/board
$V --cc --exe --timing -O2 -Wno-fatal --top-module gba_board_sim \
    --Mdir build/gba/board sim/tang/sim_prims.v sim/tang/sdram_model.v \
    sim/tang/hdmi_audio_stub.sv $SRCS sim/gba/board.sv "$(pwd)/sim/gba/board_tb.cpp" \
    >build/gba/board-verilator.log 2>&1
$MAKE -s -j4 -C build/gba/board -f Vgba_board_sim.mk >build/gba/board-compile.log 2>&1
build/gba/board/Vgba_board_sim | tee build/gba/board-results.txt
