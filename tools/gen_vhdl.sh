#!/usr/bin/env bash
# Convert the MiSTer VHDL parts (T80 CPU, APU) to Verilog netlists with GHDL.
set -euo pipefail
cd "$(dirname "$0")/.."
G=${GHDL:-/e/tools/ghdl/bin/ghdl.exe}
W=build/ghdl
rm -rf $W && mkdir -p $W rtl/gen
O="--std=08 -frelaxed -fsynopsys --workdir=$W"
for f in bus_savestates.vhd reg_savestates.vhd T80/T80_Pack.vhd T80/T80_ALU.vhd T80/T80_MCode.vhd \
         T80/T80_Reg.vhd T80/T80.vhd T80/GBse.vhd gbc_snd.vhd; do
  $G -a $O rtl/gb/$f
done
$G synth $O --out=verilog GBse    > rtl/gen/GBse.v
$G synth $O --out=verilog gbc_snd > rtl/gen/gbc_snd.v
python -I tools/mkstub.py rtl/gen/ghdl_stubs.v rtl/gen/GBse.v:GBse rtl/gen/gbc_snd.v:gbc_snd
echo "GHDL netlists regenerated"
