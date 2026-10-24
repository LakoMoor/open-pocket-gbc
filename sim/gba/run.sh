#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
TOOLS=${TOOLS:-/e/tools/oss-cad-suite}
export PATH="$TOOLS/bin:$TOOLS/lib:/c/Users/lakom/mingw64/bin:$PATH"
export VERILATOR_ROOT=${VERILATOR_ROOT:-$TOOLS/share/verilator}
python fw/gba/make_diagnostic.py
V=verilator
command -v verilator_bin >/dev/null && V=verilator_bin
MAKE=make
command -v mingw32-make >/dev/null && MAKE=mingw32-make
mkdir -p build/gba/cpu
$V --cc --exe -O2 -Wno-fatal --top-module gba_bringup \
  --Mdir build/gba/cpu rtl/gba/cpu/*.v rtl/gba/memory/*.sv rtl/gba/peripherals/*.sv rtl/gba/gba_bringup.sv \
  "$(pwd)/sim/gba/cpu_tb.cpp" >build/gba/verilator.log 2>&1
$MAKE -s -j4 -C build/gba/cpu -f Vgba_bringup.mk >build/gba/compile.log 2>&1
build/gba/cpu/Vgba_bringup | tee build/gba/cpu-results.txt
mkdir -p build/gba/components
$V --cc --exe -O2 -Wno-fatal --top-module gba_components \
  --Mdir build/gba/components rtl/gba/memory/gba_address_decode.sv \
  rtl/gba/memory/gba_sdram_arbiter.sv rtl/gba/video/gba_mode3_scanout.sv \
  sim/gba/components.sv "$(pwd)/sim/gba/components_tb.cpp" >build/gba/components-verilator.log 2>&1
$MAKE -s -j4 -C build/gba/components -f Vgba_components.mk >build/gba/components-compile.log 2>&1
build/gba/components/Vgba_components | tee build/gba/components-results.txt
mkdir -p build/gba/peripherals
$V --cc --exe -O2 -Wno-fatal --top-module gba_timers_irq \
  --Mdir build/gba/peripherals rtl/gba/peripherals/gba_timers_irq.sv \
  "$(pwd)/sim/gba/peripherals_tb.cpp" >build/gba/peripherals-verilator.log 2>&1
$MAKE -s -j4 -C build/gba/peripherals -f Vgba_timers_irq.mk >build/gba/peripherals-compile.log 2>&1
build/gba/peripherals/Vgba_timers_irq | tee build/gba/peripherals-results.txt
