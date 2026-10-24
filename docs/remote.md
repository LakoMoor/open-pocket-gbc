# USB remote control

The Tang Nano 20K's USB-C port also carries a serial port from the on-board BL616 (FTDI-compatible, 0403:6010, interface 1). The FPGA listens on it (`rtl/io/uart_pad.sv`), so the PC can press buttons. You can play from the keyboard, script tests, or record demos. Every GIF in this repository was made this way.

## Protocol

115200 baud, 8N1. One ASCII character per event:

| Press | Release | Button |
|---|---|---|
| `U` | `u` | Up |
| `D` | `d` | Down |
| `L` | `l` | Left |
| `R` | `r` | Right |
| `A` | `a` | A |
| `B` | `b` | B |
| `S` | `s` | Select |
| `T` | `t` | Start |
| `M` | `m` | menu key (like S1) |
| `X` | `x` | reset key (like S2) |
| `0` | | release everything |

The remote is OR-ed with the DualShock and the GPIO buttons. The menu and reset keys go through the same 2 ms debounce as S1/S2, so hold them for at least ~10 ms.

## Live screen

Studio (Remote → live picture) and the Android app (Remote → live) show the board's real picture, and **Screenshot** saves it as PNG (the game 3× and the HDMI view with the menu): the running game and the menu, composed like the HDMI output and the LCD. This needs firmware and bitstream 1.3. The UART bit time became a register (`REG_UART`, 0x68), so the link can run faster than 115200.

**Handshake:**
1. The app sends `W` at 115200 (firmware 1.3 knows only `V`: the apps fall back to it after ~2 s).
2. The firmware answers `#SCR 1985294`, then switches TX and the remote's RX to 1.985 Mbaud (33.75 MHz / 17).
3. The app reopens the port at 2 Mbaud and sends `.`. The firmware stays quiet until a byte arrives at the new rate: data sent while the BL616 still runs at 115200 can hang the bridge until the cable is replugged. Button characters keep working at that rate.
4. The app sends `.` every half second. After 2 s without a byte, or after `v` (checked between rows), the firmware goes back to 115200. Stop the stream before closing the port.

**Packets:** `0x00`, type, u16 length (little endian), payload. Log text still arrives between packets.

| Type | Payload |
|---|---|
| `P` | gbc, gbc_raw, DMG palette (4 × RGB): how to turn pixels into colours |
| `O` | flags (1 = OSD shown, 2 = dimmed), then 42 × 24 OSD cells (u16: attr, char) when shown |
| `L` | flags, then the 16 × 12 LCD text cells |
| `G` | a changed row: y, then PackBits over 160 u16 pixels. A control byte c < 128 means c + 1 literal pixels follow; c ≥ 128 means c − 126 copies of the next pixel. |
| `R` | (after `W`) a changed row without a length: `0x00`, `R`, y, then the PackBits of `G`; it ends after 160 pixels. The firmware saves a pass over the row. |
| `M` | (after `W`, only with the optional hardware engine) a changed row: `0x00`, `M`, y, then 10 groups of 8 words: a mask byte (bit n set: word n repeats the word before it; before the first word of the row comes 0), then the other words of the group, 4 bytes each. |
| `F` | end of frame: u16 frame counter |

**Pixels and speed:**
- Pixels come straight from the framebuffer: GBC 15-bit colour, or a DMG shade in bits 1:0.
- Only rows that changed since the last frame are sent. A still screen costs nothing, and a typical game sends a few rows per frame.
- A full redraw (scrolling, a scene change) is about 20–45 KB, roughly 0.1–0.25 s at 2 Mbaud. That is the floor on latency: USB-UART is the only data path to the PC.
- A hardware engine for the rows is in the sources (`rtl/sys/scr_engine.sv`, `DEFS="-D SCR_ENGINE"`): it hashes each row, compares it with a table in SDRAM and sends `M` rows while the menu CPU waits, so the link instead of the CPU would set the frame rate. It does not fit next to the core on the GW2AR-18 (88% LUT, no placement with 24 seeds), so the released bitstream leaves it out and firmware 1.5 encodes the rows in software (about 6 fps). The firmware and the apps already handle it for a larger FPGA.

## Update over USB

Firmware 1.5 or newer installs a new firmware or bitstream over the same USB-UART: no JTAG and no WinUSB driver. Bitstream 1.5 is needed for reliable transfers, because older bitstreams lose about one received byte in 160. Studio falls back to it when openFPGALoader can't reach the board.

```sh
python tools/uart_update.py opgbc_fw.bin            # firmware
python tools/uart_update.py opgbc_fpga.bin --fpga   # bitstream, then switch the power off and on
```

**Protocol:**
1. The host sends `Y` at 115200. The firmware answers `#UPD 503676`, pauses the core and switches to that rate (the host opens the nearest round value, 500000). The UART keeps a single received byte, so the CPU polls it in a tight loop.
2. The host sends `OPUP`, the target (0 firmware, 1 bitstream) and the u32 size. Then it sends the file in 4 KB blocks, each followed by its u16 byte sum. Each step gets one answer: `K` (accepted), `R` (send that block again) or `E` (given up).
3. After the last `K` both sides go back to 115200. The firmware writes and verifies the flash like System Update and logs `#UPD ok` or `#UPD fail`.

## Board settings over USB

Studio (Settings) and the Android app (Settings) read and change the settings of the board's menu: the Display, Audio, Controls, System and Power pages, with the same names and choices as on the board. A change is applied and stored at once. Firmware 1.6 or newer.

**Protocol (115200):**
1. The host sends `Z` until the firmware answers `#CFG`.
2. Then it sends lines, lower case and digits only, because upper-case letters are remote key presses:
   - `list` returns one line per setting, then `end`. Each line is `opt <page> <item> <value>|<label>|<choice>;<choice>;...`.
   - `set <page> <item> <value>` changes a setting the way the menu does, then stores it. The answer is `ok` or `err`.
   - `bye` closes the session. It also closes after 3 s without a byte. The firmware answers `#CFG end`.

**Board LEDs** (Power › Board LEDs, bitstream 1.6):
- Off.
- Status: menu open and loading.
- CPU Clock: a binary counter driven by the Game Boy CPU's clock. It blinks at about 1 and 0.5 Hz, stops while paused and runs faster in double speed and fast forward.
- Sound: left and right channel level.
- Activity: save writes and USB remote bytes.

## tools/remote.py

Requires `pip install pyserial`. The port is found automatically (VID 0403, PID 6010); use `--port COM6` to override.

```sh
python tools/remote.py                     # interactive (Windows console)
python tools/remote.py "M . D D A"         # run a sequence
```

**Interactive keys:** arrows = d-pad, `x` = A, `z` = B, Enter = Start, Backspace = Select, `m` = menu, `r` = reset, `q` = quit.

**Sequence tokens:**

| Token | Meaning |
|---|---|
| `U D L R A B S T M X` | tap: press for `--hold` (0.12 s), release, wait `--gap` (0.35 s) |
| `+R` / `-R` | press / release and keep that state |
| `.` | wait `--gap` |
| `1.5` | wait 1.5 s |

Examples:

```sh
python tools/remote.py "M U A B"                  # menu -> Debug (last item) -> toggle -> close
python tools/remote.py "M D D A . D A"            # load the second game
python tools/remote.py "T 1 +R 0.6 -R +A +U 0.3 -U -A"   # Libbet: start, roll right, jump up
```

## tools/record.py: GIFs from the capture card

```sh
python tools/record.py docs/img/menu.gif "M . D D D . R . R . U U U A" --secs 12 --width 400 --fps 15
python tools/record.py docs/img/debug_play.gif "T 1.5 +R 0.6 -R" --secs 9 --full --width 560
python tools/record.py clip.mp4 "A 2 +R 1.5 -R" --secs 6
```

The script:
1. Starts ffmpeg on the capture card (`USB2.0 HD` / `USB3.0 UHD`, 1280×720).
2. Runs the button sequence after `--start` seconds.
3. Encodes the result: GIF with a generated palette, or H.264 MP4.

By default the frame is cropped to the 4:3 game area; `--full` keeps the border, where the debug lines are. `grab.sh out.png` takes a single screenshot.

Close OBS or anything else that uses the capture card first: DirectShow devices can only be opened once.
