# GBA compatibility

**Open Pocket GBA is incomplete.** `gba_top` is an independently synthesizable
ARM/Thumb + SDRAM + Mode 3 diagnostic, not a replacement for a complete GBA.

| Requirement | Implemented / verified state |
|---|---|
| ARM/Thumb execution | GBATang-derived RTL; original mixed-mode ROM executed in Verilator. Arithmetic/conditional execution, SWI and timer IRQ return, SPSR and odd LDRH exercised; not exhaustive ARMv4T verification. |
| BIOS | Original diagnostic vectors only. No compatible BIOS integration. |
| Memory map | Physical backing, region bounds, mirrors and byte masks; CPU VRAM/IWRAM/EWRAM traffic tested. Hardware bus-width/open-bus/BIOS protection behavior incomplete. |
| GBA clock / waitstates | Timers use fractional 16.777216 MHz enables; CPU pipeline advances on memory completion. WAITCNT, prefetch and cycle accuracy absent. |
| Video | Static Mode 3 VRAM scanout with pixel-perfect 3x, RGB555 to 720x480 HDMI. CPU-generated homebrew frame checked pixel by pixel. |
| PPU modes 0–5 | Full PPU absent, including GBA scanline timing, modes 0/1/2/4/5, text/affine, sprites/priority, windows, mosaic, alpha/brightness. HDMI scanout is not evidence of a full Mode 3 PPU. |
| Display settings / OSD / FPS | Not integrated. Existing GBC implementation preserved. |
| DMA0–3 | Absent; no dummy registers acknowledge access. |
| Timers / IRQ | Four prescaled/cascaded timers, reload/start, IE/IF/IME, timer IRQ and keypad IRQ tested. Video/DMA/audio IRQ sources absent. Edge-cycle hardware accuracy unverified. |
| Keypad | KEYINPUT/KEYCNT with GPIO inputs and OR/AND edge-trigger IRQ logic; simulation tests pass. Physical buttons untested; L/R not wired. |
| PSG / Direct Sound / FIFO | Absent; HDMI emits no GBA audio. |
| Cartridge ROM | Boot-time embedded 1 KiB original diagnostic copied to SDRAM. General SD/flash ROM loader, caching and 32 MiB cartridge backing absent. |
| SRAM / Flash / EEPROM / RTC | Raw save backing only. Protocols, persistence and RTC absent. |
| Menu / FatFs | GBC menu remains unchanged; no GBA menu firmware. |
| Reset | CPU and scanout reboot unit tests pass. Full-board pin-model test verifies two boots including a button reset, ROM reload and repeated pixel checks. |
| FPGA / hardware | See measured results in `gba-progress.md`; physical board not programmed or tested by this task. |

No commercial game or third-party homebrew compatibility is claimed. The only
executed ROM is the original `fw/gba/make_diagnostic.py` program. Its header omits
the Nintendo logo and is deliberately for direct cartridge-entry bring-up, not
retail BIOS boot validation. ROM bytes are reproducibly generated without an ARM
assembler; instruction encodings and branch/literal relocations are explicit.

## Open test suites and BIOS review

These repositories were downloaded and their license files inspected. None of
their binaries or source is imported into the tracked tree or reported as passed.

| Source | Reviewed revision | License / remaining dependency |
|---|---|---|
| [mGBA suite](https://github.com/mgba-emu/suite) | `e6942030d25ffe3ba76c72b73a86da073ec857cc` | MIT, Jeffrey Pfau. Makefile requires devkitARM and GBA build rules. Not built/run. |
| [gba-tests](https://github.com/jsmolka/gba-tests) (old gba-suite URL redirects here) | `a7113b67e63f83a9b321696ddd7042ccfad6c881` | MIT, Julian Smolka. FASMARM build; its result display requires Mode 4. Not run. |
| [Cult-of-GBA BIOS](https://github.com/Cult-of-GBA/BIOS) | `a30e9a96df083628b650724b7d4d7112b4070b98` | MIT, DenSinH and fleroviux. ARM assembler build, 16 KiB replacement BIOS. Reviewed, not integrated/tested. |

The next compatibility gate is a real open BIOS plus instruction-suite execution,
followed by independently verified PPU, DMA, audio and save behavior. Comparison
against mGBA has not run. Existing suite result screens cannot be used until the
corresponding graphics/I/O/BIOS functions actually exist.
