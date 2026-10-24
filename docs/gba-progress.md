# Open Pocket GBA progress

Date: 2026-10-21. Branch: `feature/open-pocket-gba`.

This is a tested, limited bring-up configuration. The full requested console is
**not finished**, and no resource-based impossibility claim is made for 20K.

| Phase | Confirmed result / remaining work |
|---|---|
| 1 audit/budget | Reviewed requested GBC modules, firmware, board, HDMI, build and flash flow; downloaded all three references; CPU selected; independent target and memory budget added. |
| 2 CPU/memory | Executable ARM/Thumb RTL, memory bridge, address decode, EWRAM/IWRAM/VRAM backing, original diagnostic vectors and ROM. Six randomized-delay/reboot CPU runs pass. Compatible BIOS, cache, full instruction-suite and waitstates remain. |
| 3 video | Existing HDMI encoder reused, 240x160 Mode 3 scanout, RGB555 and exact 3x scaling. Component and full-board pin-model tests pass. Full PPU and externally loaded homebrew remain. |
| 4 timing/peripherals | Four timers, cascade, IRQ controller, keypad and actual CPU timer IRQ/return implemented/tested. DMA, video IRQ sources and accurate bus timing remain. |
| 5 APU/cart | Not implemented. |
| 6 menu/SD/saves | Existing GBC infrastructure preserved, GBA integration not implemented. |
| 7 implementation | Synthesis/P&R results recorded separately below. Hardware demonstration not performed. |

## Simulation

`bash sim/gba/run.sh`:

* Six CPU runs (three latency seeds, two boots each), roughly 4.11 million system
  clocks per run. Checks ARM/Thumb, conditions, SWI, timer IRQ and SPSR return,
  odd-address LDRH, IWRAM and EWRAM values, exactly 38400 halfword stores and all
  VRAM pixels. Corrected an imported CPU LDRH bit-slice bug exposed by this check.
  As a negative control, the same bench was built/run against the unchanged
  upstream CPU; it fails the result check. The imported CPU with the one-line
  LDRH fix passes all six runs.
* 18 decode boundary/mirror/ROM overflow cases.
* Two component boots; 691200 output pixels per boot checked against an independent
  RGB555 oracle, continuous competing CPU reads, 33.75/27 MHz clock ratio,
  two-line CDC handoff, no scanout underrun or CPU starvation.
* Four timer prescalers, four-way cascade, counter reload and restart, byte
  enables, IE/IF/IME, W1C interrupt flags and keypad OR/AND/retrigger tests.

`bash sim/gba/board.sh`: full `gba_top` with existing behavioral board primitives
and SDRAM pin model. Loader -> SDRAM -> CPU -> VRAM -> HDMI RGB verified for a
691200 pixels across two board boots, including a button reset and repeat ROM
load, approximately 266.96 ms simulated. Serializer electrical
behavior and audio regeneration are not covered by that model.

Raw results: `build/gba/*-results.txt`; compile/lint output stays in the matching
logs. Nothing in the test runner suppresses tool failure with `|| true`.

GBC regression checks: the original `gbc_top` and generated CPU/APU netlists
pass Verilator elaboration/lint with the existing board simulation models;
`fw/build.sh` completes (159668-byte firmware). These checks do not establish
physical GBC compatibility or replace a full GBC gameplay regression run.

## Synthesis / place-and-route / physical testing

Final build measurements are recorded in `gba-measurements.txt` when available.
`./build.sh gba_top` produces `gba_top.fs`, `yosys.log`, `nextpnr.log` and
`stat.txt` under `build/gba_top/`. GBA uses `gba_clocks.sdc` and does not pass
`--timing-allow-fail`. GBC retains the original build defaults.

Physical testing: **not performed**. No persistent flash changes were made.
The diagnostic's successful fit would not establish full GBA fit or compatibility.

## Remaining concrete architecture gates

1. Fast IWRAM plus bounded ROM instruction/data cache; current uncached execution
   is too slow to claim native CPU performance.
2. Integrate the reviewed open BIOS, implement required I/O and verify ARM/Thumb
   instruction/exception suites against hardware/mGBA references.
3. Implement a bandwidth-budgeted PPU, beginning with GBA-timed modes 3/4/5, then
   tile/affine/OBJ/merge, windows, mosaic and blend behavior; retain measured fit.
4. Add DMA and WAITCNT/prefetch with timing tests before claiming audio/graphics DMA.
5. APU and sound FIFOs; real HDMI audio with CDC tests.
6. Separate GBA firmware/storage configuration, SD header validation/loading,
   save protocols and persistence, cached external cartridge storage.
7. Run integration suites, strict routed timing and physical capture/button/audio
   validation. Re-synthesize each addition instead of extrapolating this small demo.
