# Open Pocket GBA architecture audit

Status: a diagnostic FPGA configuration, **not a complete GBA implementation**.
The GBC core and GBA core have independent source lists and bitstreams. Baseline:
Open Pocket GBC `e24e34eceee208c7266d23aad9d12d5ea8997b4e`.

## Existing implementation

| Reviewed component | Reuse / required change |
|---|---|
| `rtl/top/gbc_top.sv` | Keep GBC wiring unchanged. GBA has its own top. Its reset/PLL sequencing and pin names inform the new top. No simultaneous cores. |
| `rtl/sys/sdram_ctrl.sv` | Reused unchanged at 33.75 MHz, 180-degree chip clock. Disable GB byte/cart strobes and use the 32-bit low-priority port. This port has separate request acceptance and read completion. |
| `rtl/sys/memsys.sv` | Not reused: fixed 80 words/line, 160-pixel geometry, 14-bit framebuffer offsets and GBC priorities. Replace with a registered, alternating-grant arbiter plus 120-word GBA line fetches. |
| `rtl/sys/iosys.sv` | Useful future service CPU, SPI, UART, OSD interfaces. Fixed firmware/boot and GBC register semantics prevent connecting unmodified firmware to a GBA core. Currently excluded. |
| `rtl/sys/fb_writer.sv` | Not reusable as-is: GB LCD off/blanking semantics, 23040 pixels, 15-bit input pointer, GB frame events. The diagnostic directly scans Mode 3 VRAM. A real PPU needs its own frame-completion writer. |
| `rtl/video/video_out.sv` | Its font/OSD/effects are reusable concepts, but its 160x144 geometry and pipeline are fixed. The diagnostic uses a tested GBA-specific 240x160, 3x scanout. |
| `rtl/hdmi/` | Reused unchanged: 480p VIC 2, RGB888 into existing encoder/serializer, original differential output buffers. Audio path receives silence until a GBA APU exists. |
| `rtl/board/` | Reuse 135 MHz HDMI PLL, 33.75 MHz system PLL, pin constraints and CLKDIV placement. GBA has separate, correct 27/135 MHz timing constraints. |
| `fw/src/`, `fw/fatfs/` | Preserve existing loader, GBCP flash layout, save formats, menu and FatFs R0.16. A GBA service configuration is still required; simply accepting `.gba` in the GB loader would corrupt its mapper/loading assumptions. |
| `build.sh`, `flash.sh` | Add `gba_top` source list and strict timing; retain existing GBC command behavior. Flash helper remains GBC by default; SRAM-only GBA instructions below. |
| `docs/architecture.md`, `docs/build.md` | Existing architecture confirms GB-priority SDRAM scheduling and separate video clock; GBA cannot inherit the byte-cart timing assumptions. |

## Reference decisions and licenses

Downloaded and inspected upstream sources, not just project descriptions:

* [GBATang](https://github.com/nand2mario/gbatang),
  `a8f9d182053a8108a7859c35613794cae9b72319`: GPL-3.0. Its CPU uses a
  multiplier also for shifts, a pipelined Harvard interface and instruction-to-ARM
  Thumb decoding. The memory mux serializes simultaneous instruction/data accesses.
  Its GPU uses separate tile/affine/bitmap/OBJ renderers and layer merge; its DMA,
  timers, interrupts, PSG and Direct Sound use the common register bus. Its
  SDRAM/DDR3 platform and generated Gowin memories cannot be dropped into GW2AR-18.
  Only `gba_cpu.v` and `gba_cpu_thumbdecoder.v` are imported. Notices remain intact.
* [MiSTer GBA](https://github.com/MiSTer-devel/GBA_MiSTer),
  `93790a023395bbd90e5eaf4dfb2cb5910afd55f5`: repository license GPL-2.0;
  **no source imported**. Its VHDL CPU, GPU, DMA, memory mux, timers, IRQ, PSG,
  Direct Sound, flash/EEPROM and cartridge RTC provide behavioral references.
  Its `clk100`/cycle-counting architecture, cache/DDR interfaces and savestates
  are unsuitable as an unchanged low-resource integration. GPL-2.0-only code
  must not be assumed compatible with this project's GPL-3.0.
* [risclite CPU](https://github.com/risclite/ARM9-compatible-soft-CPU-core),
  `fc17416644f6021e99c41e81faad1135609a3036`: Apache-2.0. GBATang's derivative
  adds required Thumb support. Apache text is preserved in `licenses/` along with
  GBATang's GPL. ThumbDecoder attribution to Ruslan Lepetenok is preserved;
  distribution relies on its inclusion in GBATang's GPL-licensed tree, not an
  invented separate license grant.

The imported CPU is a starting implementation, not proof of complete ARM7TDMI
bus timing or instruction correctness. One odd-address LDRH bug has already been
fixed and is exercised by the diagnostic. Remaining Verilator width warnings
from imported RTL are visible in the logs, not silently treated as compatibility.

## Implemented data path

`gba_cpu` -> `gba_cpu_bridge` -> `gba_memory` -> `gba_sdram_arbiter` -> original
`sdram_ctrl`. The bridge holds old response data through `cpu_en`, publishing the
next response at the end of that edge. Publishing data before advancing the CPU
would mix instructions from different pipeline stages. Stores are issued once.

The arbiter latches its grant and address before asserting the controller request.
This prevents a newly arriving video request from stealing the controller's
one-cycle-delayed acknowledgement. Only one read is outstanding. Alternating
grants prevent starvation under continuous CPU/video traffic.

The boot loader copies an original 1 KiB ARM/Thumb diagnostic from an initialized
ROM into SDRAM. The reset vectors jump to 0x08000000. These diagnostic vectors
are **not a compatible BIOS**: SWI only returns, and IRQ records a test marker,
disables IME and returns. No Nintendo BIOS or commercial ROM is included.

The diagnostic verifies arithmetic/condition execution, SWI, odd LDRH, timer IRQ,
SPSR return and ARM-to-Thumb BX, then writes a full RGB555 ramp to VRAM. Only after
its completion signature does HDMI begin fetching lines. Two 120-word banks are
used across clock domains; row identity is published through a synchronized
completion toggle. One-pixel prefetch aligns the synchronous RAM to HDMI sampling.
The captured frame is generated by CPU stores, not a video test-pattern generator.

`gba_timers_irq` implements four timer counters/reloads, prescalers, cascade,
timer IRQs, IE/IF/IME and keypad interrupt matching. A fractional accumulator
supplies 16.777216 MHz timer enables from 33.75 MHz regardless of CPU stalls.
Key inputs reuse the GBC GPIO mapping (L/R currently unavailable). Prescaler phase
on enable and simultaneous event/write edge cases still need hardware-suite tests.

## Commands

```sh
python fw/gba/make_diagnostic.py
bash sim/gba/run.sh
bash sim/gba/board.sh
./build.sh gba_top
./build.sh gbc_top
```

Logs/results are under `build/gba/`, FPGA artifacts under `build/gba_top/`.
The `board.sh` test uses the existing SDRAM pin model and behavioral PLL/serializer
models. The HDMI audio-clock regeneration packet is the existing simulation stub;
the RGB/frame timing path is real. TMDS electrical behavior is not simulated.

For a deliberate, volatile board test after review:

```sh
openFPGALoader -b tangnano20k build/gba_top/gba_top.fs
```

This task does not automatically flash hardware. `flash.sh` continues to select
GBC and its existing persistent flash layout. GBA menu/saves storage is not active.
