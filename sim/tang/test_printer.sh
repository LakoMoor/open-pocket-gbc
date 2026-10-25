#!/usr/bin/env bash
# Exercise the actual iosys registers/shifter with a Game Boy INIT packet.
# Slang lowers declaration-before-use constructs for the Icarus testbench.
set -euo pipefail
cd "$(dirname "$0")/../.."
TOOLS=${TOOLS:-/e/tools/oss-cad-suite}
if [ -d "$TOOLS/bin" ]; then export PATH="$TOOLS/bin:$TOOLS/lib:$PATH"; fi
mkdir -p build/printer_test
yosys -Q -m slang -p '
  read_slang --top iosys --compat vcs --allow-use-before-declare -I rtl/sys rtl/rv/femtorv32_quark.v rtl/sys/spi_byte.sv rtl/sys/spi_port.sv rtl/sys/iosys.sv;
  proc;
  write_verilog -noattr build/printer_test/iosys.v
' > build/printer_test/lower.log 2>&1
iverilog -g2012 -s tb_printer -o build/printer_test/test.vvp build/printer_test/iosys.v sim/tang/tb_printer.sv
vvp build/printer_test/test.vvp
