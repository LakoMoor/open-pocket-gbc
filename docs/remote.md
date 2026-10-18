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
