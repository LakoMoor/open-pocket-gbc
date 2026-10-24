# GBA memory and bandwidth budget

All addresses below are **SDRAM byte addresses**, not CPU addresses. This layout
is separate from the GBC configuration. SDRAM capacity is 8 MiB. No 32 MiB ROM
support is claimed by translating or wrapping addresses into a smaller array.

| Physical range | Size | CPU use / current status |
|---|---:|---|
| 000000–5fffff | 6 MiB | resident cartridge ROM; diagnostic loader uses first 1 KiB |
| 600000–63ffff | 256 KiB | EWRAM, mapped |
| 640000–647fff | 32 KiB | IWRAM, mapped; slower than hardware |
| 648000–64ffff | 32 KiB | reserved |
| 650000–65ffff | 64 KiB | raw save backing, mapped; **not** complete SRAM protocol |
| 660000–6603ff | 1 KiB | palette backing; no palette PPU path yet |
| 660400–6607ff | 1 KiB | OAM backing; no OBJ renderer yet |
| 680000–697fff | 96 KiB | VRAM; upper 32 KiB of each 128 KiB CPU window mirrors 10000–17fff |
| 700000–75ffff | 384 KiB | proposed three frame slots, 128 KiB stride; not allocated/used by diagnostic |
| 780000–7fffff | 512 KiB | reserved service firmware/data/stack; service CPU not integrated |

CPU EWRAM/IWRAM/palette/OAM mirrors are decoded. ROM windows 08/0a/0c share the
same 25-bit offset; offsets >=6 MiB are rejected, not aliased. Unknown regions,
unsupported I/O and writes to ROM set a sticky diagnostic fault. This is not
GBA open-bus or BIOS-read-protection behavior. Generic byte enables work, but
palette/VRAM byte duplication, ignored OAM byte stores and 8-bit save bus semantics
remain required before calling this a complete GBA memory map.

## BSRAM

46 physical 18 Kibit blocks provide 103.5 KiB raw. In ordinary 512x32 or 1024x16
useful-data configurations the effective capacity is 92 KiB (parity excluded).
BIOS + IWRAM + VRAM + palette + OAM require 146 KiB, already exceeding this before
CPU caches, menu and video buffers. A direct GBATang memory placement is infeasible.

| Allocation | Diagnostic | Candidate full configuration (unmeasured) |
|---|---:|---:|
| Bootstrap | combinational vector table | 16 KiB open BIOS: 8 blocks |
| IWRAM | SDRAM | 32 KiB: 16 blocks for low-latency execution |
| ROM instruction/data cache | none | 4–8 KiB: 2–4 blocks plus tags |
| HDMI two-line storage | 256x32, 1 block | 1 block |
| Embedded diagnostic ROM | 256x32, 1 block | removable after external loader integration |
| PPU line/OBJ/palette/OAM caches | none | reserve 8–12 blocks; needs synthesis |
| Service CPU/OSD/audio FIFOs | none | reserve 3–5 blocks; needs synthesis |

The proposed full configuration uses 38–46 blocks, with VRAM/EWRAM/framebuffers
in SDRAM. This is a planning budget, **not a proven working PPU architecture**.
See `gba-progress.md` for measured diagnostic utilization. No fit/non-fit
conclusion for a full GBA core can be drawn from this diagnostic synthesis.

## Latency and throughput

The reused controller launches a single auto-precharged 32-bit transaction in
five 33.75 MHz clocks: approximately 148 ns and an ideal ceiling of 27 MB/s.
Request/grant states and read acknowledgement add overhead; the GBA bridge
serializes instruction and data requests and has no cache. Real throughput is
lower. Refresh takes priority over the low-priority port; it cannot be blocked
by the disconnected GB cart port in this configuration.

CPU test memory accepts requests after 1–11 injected clocks and returns reads
after another 2–8 clocks. These are handshake stress conditions, **not hardware
waitstate measurements**. The board integration test exercises actual controller
commands, CAS timing and byte masks against the existing SDRAM model. That model
does not enforce every analog SDRAM setup/hold/retention constraint.

Mode 3 scanout consumes 240*160*2*59.94 = approximately 4.60 MB/s. Fetching 120
words over three HDMI scanlines gives about 95.3 us per source row. The line
request starts during the first repetition of the previous row. Alternating
CPU/video grants pass the tested continuous-contention scenario. General PPU,
DMA, menu and audio traffic have **not** been jointly budgeted or validated.

Worst-case uncached ARM fetch alone is 16.777216 million * 4 = 67.1 MB/s,
above even ideal SDRAM throughput. A cache and fast IWRAM are mandatory for
useful compatibility. The current CPU is deliberately stalled by memory and is
not a 16.78 MHz timing-accurate GBA. WAITCNT is rejected rather than faked.

## 32 MiB cartridge strategy (not implemented)

The board's 8 MiB SPI flash cannot hold every 32 MiB ROM. A dedicated 256 Mbit
or larger cartridge flash (e.g. W25Q256-class, with verified voltage/pin/protocol
support) is a concrete capacity extension. At single-bit 33.75 MHz SPI, a 64-byte
line plus a 32-bit command/address takes at least 16.1 us, about 270 GBA clocks,
before controller overhead. Random misses therefore require instruction/data
caches, burst prefetch and measured compatibility; raw SPI is not native GBA ROM
timing. Quad SPI or larger external RAM may be needed for bandwidth.

SD streaming has no demonstrated worst-case service bound here. A resident cache
with pinned hot code and asynchronous refill is a research direction, not support.
Bank-switching a 6 MiB window without address-aware backing cannot run arbitrary
32 MiB ROMs. SD, SPI cache and cartridge prefetch tests are still outstanding.
