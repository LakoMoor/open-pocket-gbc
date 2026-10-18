#!/usr/bin/env bash
# Program the Tang Nano 20K with openFPGALoader.
#   ./flash.sh sram          load bitstream into FPGA SRAM (lost on power off)
#   ./flash.sh flash         write bitstream to SPI flash (boots on power up)
#   ./flash.sh games [img]   write the game image (default build/games.bin) at 0x200000
set -euo pipefail
cd "$(dirname "$0")"
TOOLS=${TOOLS:-/e/tools/oss-cad-suite}
export PATH="$TOOLS/bin:$TOOLS/lib:$PATH"
FS=build/gbc_top/gbc_top.fs

case "${1:-sram}" in
  sram)  openFPGALoader -b tangnano20k "$FS" ;;
  flash) openFPGALoader -b tangnano20k -f --verify "$FS" ;;
  games) openFPGALoader -b tangnano20k -f --verify -o 0x200000 --file-type bin "${2:-build/games.bin}" ;;
  *) echo "usage: $0 sram|flash|games [img]"; exit 1 ;;
esac
