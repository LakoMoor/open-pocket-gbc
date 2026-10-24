#!/usr/bin/env bash
# Open-source build: yosys (+slang SV frontend) -> nextpnr-himbaechel -> gowin_pack (Apicula)
# Usage: ./build.sh <top>        e.g. ./build.sh hdmi_test_top | ./build.sh gbc_top
set -euo pipefail
cd "$(dirname "$0")"
TOOLS=${TOOLS:-/e/tools/oss-cad-suite}
export PATH="$TOOLS/bin:$TOOLS/lib:$PATH"

TOP=${1:-gbc_top}
OUT=build/$TOP
mkdir -p "$OUT"

case "$TOP" in
  hdmi_test_top)
    SRCS="rtl/board/gowin_prims.v rtl/top/hdmi_test_top.sv rtl/board/pll_hdmi.v rtl/board/pll_gb.v rtl/sys/sdram_ctrl.sv rtl/hdmi/*.sv"
    ;;
  gbc_top)
    SRCS="$(cat rtl/files.f | sed 's/#.*//' | tr '\n' ' ')"
    ;;
  gba_top)
    SRCS="$(cat rtl/gba/files.f | sed 's/#.*//' | tr '\n' ' ')"
    # A failed rebuild must never leave an apparently current GBA bitstream.
    rm -f "$OUT/$TOP.fs" "$OUT/pnr.json"
    ;;
  *) echo "unknown top $TOP"; exit 1;;
esac

echo "== yosys ($TOP)"
SL="--compat vcs --allow-use-before-declare --relax-enum-conversions --allow-merging-ansi-ports --allow-dup-initial-drivers --ignore-assertions"
GHDL_NETLISTS=""
[ "$TOP" = gbc_top ] && GHDL_NETLISTS="read_verilog -overwrite rtl/gen/GBse.v rtl/gen/gbc_snd.v;"
yosys -q -l "$OUT/yosys.log" -m slang -p "
  read_slang $SL --top $TOP -D SYNTHESIS ${DEFS:-} -I rtl/gb -I rtl/sys $SRCS;
  $GHDL_NETLISTS
  hierarchy -top $TOP;
  synth_gowin -top $TOP -family gw2a -json $OUT/synth.json;
  tee -o $OUT/stat.txt stat
"

echo "== nextpnr"
TIMING_OPT=--timing-allow-fail
SDC=rtl/board/clocks.sdc
if [ "$TOP" = gba_top ]; then
  TIMING_OPT=""
  SDC=rtl/board/gba_clocks.sdc
fi
# The design is close to full: when placement fails, try other placer seeds.
rm -f "$OUT/pnr.json"                       # never pack a stale placement
PLACED=0
for SEED in ${SEEDS:-1 42 7 21 3 99 1234 5 13 77 256 8}; do
  PNR_LOG="$OUT/nextpnr.log"
  [ "$TOP" = gba_top ] && PNR_LOG="$OUT/nextpnr-seed-$SEED.log"
  if nextpnr-himbaechel -q -l "$PNR_LOG" --json "$OUT/synth.json" --write "$OUT/pnr.json"       --device GW2AR-LV18QN88C8/I7 --vopt family=GW2A-18C --vopt cst=rtl/board/tangnano20k.cst       ${PNR_OPTS---pre-pack rtl/board/place.py --sdc "$SDC" --vopt ioreg_in_iob} ${NEXTPNR_EXTRA:-}       $TIMING_OPT --seed $SEED; then
    [ "$TOP" = gba_top ] && cp "$PNR_LOG" "$OUT/nextpnr.log"
    echo "placed with seed $SEED"; PLACED=1; break
  fi
  [ "$TOP" = gba_top ] && cp "$PNR_LOG" "$OUT/nextpnr.log"
  echo "seed $SEED failed"
done

[ "$PLACED" = 1 ] || { echo "placement failed with every seed"; exit 1; }

echo "== gowin_pack"
gowin_pack -d GW2A-18C ${PACK_EXTRA:---mspi_as_gpio} -o "$OUT/$TOP.fs" "$OUT/pnr.json"
ls -la "$OUT/$TOP.fs"
grep -E "Max frequency|Device utilisation|LUT4|DFF|BSRAM|ALU" "$OUT/nextpnr.log" | head -30 || true
