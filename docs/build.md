# Building and flashing

## Toolchain

Only open-source tools are used. The versions below were tested on Windows 11. Linux works the same way; adjust the paths.

| Tool | Version | Used for |
|---|---|---|
| [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build) | 2026-10-17 | yosys 0.70 + [yosys-slang](https://github.com/povik/yosys-slang), nextpnr-himbaechel 0.11, Apicula `gowin_pack`, openFPGALoader 1.1.1 |
| [GHDL](https://github.com/ghdl/ghdl) | 6.0.0 | only to regenerate `rtl/gen/*.v` from the VHDL parts (T80 CPU, APU) |
| Python 3 + `pyserial` | 3.13 / 3.5 | game image tool, OSD ROM generator, USB remote |
| ffmpeg | any recent | only for `grab.sh` / `tools/record.py` (capture card) |

`build.sh` expects the OSS CAD Suite at `/e/tools/oss-cad-suite`. Override it with `TOOLS=/path/to/oss-cad-suite ./build.sh`.

### Windows: USB driver for openFPGALoader

The on-board debugger ("20K's FRIEND", 0403:6010) needs the WinUSB driver on **interface 0**:

1. Start [Zadig](https://zadig.akeo.ie/), then *Options → List All Devices*.
2. Select **20K's FRIEND (Interface 0)** and install **WinUSB**.

Interface 1 stays a serial port (COM*n*). It is used by the [USB remote](remote.md).

## Build

```sh
./build.sh gbc_top          # ~8 minutes; output: build/gbc_top/gbc_top.fs
```

The flow:

1. `read_slang` reads all SystemVerilog/Verilog sources listed in `rtl/files.f`.
2. The GHDL netlists `rtl/gen/GBse.v` (CPU) and `rtl/gen/gbc_snd.v` (APU) are added with `read_verilog`.
3. `synth_gowin` synthesizes the design.
4. `nextpnr-himbaechel` places and routes it, using the pin file `rtl/board/tangnano20k.cst`, the timing constraints `clocks.sdc` and a pre-pack placement script `place.py`.
5. `gowin_pack` writes the bitstream.

Utilization and Fmax are printed at the end. Logs are in `build/gbc_top/`.

### Build switches

Pass Verilog defines through `DEFS`, e.g. `DEFS="-D MENU_AT_BOOT -D VIDEO_720P" ./build.sh gbc_top`.

| Define | Effect |
|---|---|
| `VIDEO_720P` | 1280×720p60 output (GB 5×), 371.25 MHz TMDS. Noisy on this board while the core runs; 480p is the default. |
| `ALL_MAPPERS` | Enables MBC6/MBC7/MMM01/camera/TAMA5/Rocket/Sachen/MegaDuck. Probably does not fit. |
| `MENU_AT_BOOT` | The menu is open after power-up. Useful without a controller. |
| `BOOT_GAME1` | Boot the second game of the image instead of the first. |
| `DEBUG_SQUARES` | 32 status bits shown as squares at the top left of the HDMI picture. |
| `HDMI_PATTERN` | Test pattern instead of the game picture. |
| `NO_CORE` | Build without the Game Boy core (video/SDRAM bring-up). |

### Regenerating generated files

| File | Command | When |
|---|---|---|
| `rtl/gen/GBse.v`, `rtl/gen/gbc_snd.v`, `rtl/gen/ghdl_stubs.v` | `tools/gen_vhdl.sh` | after changing the VHDL in `rtl/gb/` |
| `rtl/sys/osd_strings.hex`, `rtl/video/font8x8.hex` | `python tools/make_osd_roms.py` | after changing menu strings |
| mapper wired-OR rewrite | `tools/fix_mappers.py` | only when re-importing MiSTer mappers |

## Flashing

```sh
./flash.sh sram             # load into FPGA SRAM: lost on power-off, fastest for testing
./flash.sh flash            # write the bitstream to the SPI flash (offset 0) and verify
./flash.sh games [img]      # write a game image (default build/games.bin) at 0x200000
```

## Game image

```sh
python tools/make_games.py build/games.bin games/ucity.gbc=uCity games/libbet.gb "my game.gb=My Game"
./flash.sh games
```

- **Capacity:** up to 15 ROMs. The name is optional; without one, the title from the ROM header is used (max 24 characters).
- **ROM size:** up to about 6 MB per ROM. The SDRAM holds ROM at 0, cart RAM at 6 MB and the framebuffer at 7 MB.

The first game in the image is started after power-up. Others are picked in *Menu → Load game*.

Flash layout (8 MB on-board flash):

| Offset | Content |
|---|---|
| `0x000000` | bitstream |
| `0x200000` | 4 KB directory: `"GBCP"`, count, then 32-byte entries `{name[24], offset, size}` (little endian) |
| `0x201000` | ROMs, each aligned to 4 KB |
