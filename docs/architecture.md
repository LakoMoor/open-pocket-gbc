# Architecture

```mermaid
flowchart LR
    subgraph inputs
        DS2[DualShock 2] --> PAD
        GPIO[8 GPIO buttons] --> PAD
        UART[USB-UART remote] --> PAD
        PAD((OR))
    end
    FLASH[(SPI flash<br/>firmware, games,<br/>saves, settings)] <--> IOSYS
    SD[(microSD)] <--> IOSYS
    subgraph iosys [iosys: FemtoRV32 RV32E + boot ROM]
        IOSYS[menu firmware<br/>FatFs, loader, saves]
    end
    IOSYS <-->|code, ROM, cart RAM| MEMSYS
    IOSYS -->|header via ioctl| CART
    PAD --> IOSYS
    PAD -->|game buttons| GB
    subgraph core [MiSTer Gameboy core, clk_sys 33.75 MHz]
        GB[gb: T80 CPU, PPU, APU] <--> CART[cart_top + mappers]
    end
    CART <-->|cart ROM/RAM| SDRAMC[sdram_ctrl]
    GB -->|pixels| FBW[fb_writer]
    FBW -->|triple buffer| MEMSYS[memsys arbiter]
    MEMSYS <--> SDRAMC
    SDRAMC <--> SDRAM[(8 MB SDRAM<br/>in package)]
    FBW -->|same pixels| LCD[lcd_st7735<br/>128x128 BSRAM frame]
    MEMSYS -->|line buffer| VIDEO[video_out<br/>scale, palettes, OSD]
    IOSYS -->|OSD RAM 42x24| VIDEO
    IOSYS -->|text RAM 16x16| LCD
    GB -->|audio| SPK[speaker pins<br/>sigma-delta]
    VIDEO --> HDMI[hdmi + OSER10<br/>480p + audio]
    GB -->|audio| HDMI
    LCD --> PANEL[ST7735S]
```

## Clocks

| Clock | Frequency | Source | Domain |
|---|---|---|---|
| `sys_clk` | 27 MHz | crystal | PLL reference |
| `clk_sys` | 33.75 MHz | rPLL (27 × 5/4) | core, SDRAM controller, menu, loader, LCD |
| `clk_sys_p` | 33.75 MHz, 180° | same PLL | SDRAM chip clock |
| `clk_p5` | 135 MHz | rPLL | TMDS serializer (5 × pixel clock, DDR) |
| `clk_p` | 27 MHz | CLKDIV ÷5 | HDMI pixel clock (720×480p59.94) |

The Game Boy runs from clock enables. `ce_gen` produces `ce` (4.19 MHz), `ce_2x` and `ce_n` from `clk_sys`, at 33.75 / 8 ≈ 4.22 MHz, so the game runs 0.6 % fast. Video is decoupled through the framebuffer.

The MiSTer core uses gated clocks (`clk_sys & ce`) for some memories. The port replaces them with `clk_sys` plus a clock enable. This is equivalent because MiSTer's `ce` changes on the falling edge.

## Memory map (SDRAM, 32-bit words)

| Byte address | Content |
|---|---|
| `0x000000` | cartridge ROM (up to 6 MB) |
| `0x600000` | cartridge RAM |
| `0x700000` | framebuffer: 3 × 160×144 × 16 bit (two pixels per word) |
| `0x780000` | menu firmware: code, data, stack (copied from flash 0x100000 by the boot ROM) |

**`sdram_ctrl`:**
- Serves the core's cart accesses first. They are edge-triggered on the core's `sdram_rd` strobe, which leaves enough time inside one CPU cycle.
- Low-priority accesses come from `memsys`: framebuffer writes, line reads for HDMI, and the menu CPU (lowest priority; only one read is in flight, so the read data goes back to whoever issued it). They are blocked while the CPU may start a cart access.
- Each access takes 5 clocks with auto-refresh.

## Video

- **`fb_writer`:** takes the PPU pixel stream (with MiSTer's LCD-off blanking behavior) and writes it into one of three framebuffers through a FIFO. A frame becomes visible only when complete (triple buffering, no tearing on HDMI).
- **`video_out`:** runs in the pixel clock domain.
  - Requests one GB line at a time from `memsys`, which copies it into a dual-clock line buffer.
  - Scales it 3×.
  - Applies the DMG palette or GBC color correction (`gb_color`) and the display mode.
  - Draws the OSD (42 × 24 cells of 16 × 20 px, `{bg, fg, char}` per cell, 16-colour palette; colour 0 shows the dimmed game, 15 the game at 1/8) and the debug lines.
- **`hdmi`** (hdl-util): HDMI 1.4 with audio packets and AVI/SPD info frames. The 10:1 serialization uses Gowin `OSER10` and `TLVDS_OBUF` primitives.
- **`lcd_st7735`:** see [hardware.md](hardware.md#st7735s-lcd).

## Menu CPU (`rtl/sys/iosys.sv`, `fw/`)

**CPU:** FemtoRV32 Quark changed to RV32E, with the 16 registers in one block RAM (rs1 is read in an extra state, rs2 straight from the RAM output). About 550 LUTs. It runs at clk_sys from SDRAM through `memsys`.

**Boot:** a 19-word boot ROM (`fw/boot/boot.S`, compiled into `rtl/sys/bootrom.vh`) reads the length word at flash 0x100000, copies the firmware to SDRAM 0x780000 and jumps there.

| Address | Content |
|---|---|
| `0x0000_0000` | SDRAM (8 MB) |
| `0x0100_0000` | boot ROM |
| `0x0200_0000` | registers: inputs, ms timer, status (GBC, 2×, cart RAM written, frame count), SD SPI, flash SPI (byte and 4-byte word reads), UART TX, `WAIT`, `CTRL`, `CFG`, ioctl address / data |
| `0x0300_0000` | OSD RAM, 1024 × 16 bit |
| `0x0310_0000` | LCD / debug text RAM, 512 × 8 bit |

`CTRL` holds the core reset, pause, ROM download, system mode, OSD on / dim, HDMI off, LCD off and LED enable; `CFG` the display, palette, LCD, volume, A/B swap and speaker settings. A read of `WAIT` stalls the bus until an input changes or the written timeout runs out, which is how the firmware idles.

## Game loading

The firmware:
1. Holds the core in reset and raises the ROM download flag.
2. Copies the ROM into SDRAM from the SD card (FatFs, multi-block reads) or the flash.
3. Feeds the first 0x150 bytes of every 16 KB bank to `cart_top` through the MiSTer `ioctl` interface, so the core parses the header (mapper, RAM size, CGB flag) and builds its ROM mask as on MiSTer.
4. Loads the save into the cart RAM area, then releases the reset.

The core's clock enables keep running during the reset; the core only resets on them.

## Open-source flow notes

| Problem | Solution |
|---|---|
| The CPU (T80) and APU are VHDL. yosys-slang only reads SystemVerilog. | `tools/gen_vhdl.sh` converts them with `ghdl synth --out=verilog` into netlists. |
| slang crashes on the GHDL netlists. | slang gets blackbox stubs (`rtl/gen/ghdl_stubs.v`); the netlists are read afterwards with `read_verilog -overwrite`. |
| MiSTer mappers use tri-state buses inside the FPGA, which slang does not support. | `tools/fix_mappers.py` rewrites them to wired-OR (`enable ? value : 0`). |
| Savestates and cheats are not needed. | Stubbed out in `rtl/gb_port/gb_stubs.v`. |
| nextpnr assigns PLL sites in instance order; the HDMI PLL must sit next to the OSER10s. | The HDMI PLL is named `u_pll_a_*` and instantiated first. |
| `CLKDIV` placement varied between runs. | Pinned by `rtl/board/place.py`. |
| Black screen on the capture card. | Caused by a broken SPD info frame. `VENDOR_NAME` must be null-padded: `{"OpenGBC", 8'd0}`. |
| Pins 33–40 are true-LVDS pins. | Use `TLVDS_OBUF`; `gowin_pack` rejects `ELVDS_OBUF` there. |
| Placement fails near 46/46 BSRAM or with many LUT-RAMs. | Each RAM16SDP4 occupies 8 LUT sites. The framebuffer FIFO is 32 deep, the zero-page RAM and the RISC-V registers are in block RAM, and rarely used mappers are compiled out. |

## Source tree

```
rtl/
  top/gbc_top.sv          top level: clocks, resets, inputs, core, SDRAM, video, audio, LCD
  board/                  pins (.cst), PLLs, Gowin primitive stubs, timing, placement script
  gb/                     MiSTer Gameboy core (modified: clock enables, wired-OR mappers)
  gen/                    GHDL output (CPU, APU) + stubs
  gb_port/                RAM wrappers, boot ROM, savestate stubs
  sys/                    sdram_ctrl, memsys, fb_writer, iosys (menu CPU), spi_byte, ce_gen, audio_out
  video/                  video_out, gb_color, lcd_st7735, font
  hdmi/                   hdl-util HDMI (Gowin serializer)
  io/                     DualShock 2, USB-UART remote
tools/                    game image, OSD ROMs, GHDL conversion, remote control, recording
games/                    included homebrew ROMs
docs/                     documentation and media
```
