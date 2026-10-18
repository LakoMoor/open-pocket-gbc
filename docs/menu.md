# Menu

Open the menu with **Select + Start**, board button **S1**, or `m` in the remote. The game pauses, the picture dims and audio is muted.

![menu navigation](img/menu.gif)

| Item | Values | What it does |
|---|---|---|
| Resume | | close the menu |
| Reset game | | restart the running game (same as S2) |
| Load game | list | pick a game from the flash image; `*` marks the running one |
| Display | Sharp / Grid / Lines | HDMI pixel style: plain 3× pixels, Pocket-style LCD grid (darker pixel edges), or scanlines |
| Palette | Pocket / Light / Amber / Gray / Green | colors for DMG games (only in DMG mode) |
| Colors | LCD / Raw | GBC games: LCD color correction like a real GBC screen, or raw RGB555 |
| LCD | Fit / Crop | SPI LCD scaling, see [hardware.md](hardware.md#st7735s-lcd) |
| System | Auto / GBC / DMG | Auto: GBC mode for GBC-capable carts. GBC: always GBC. DMG: always original Game Boy (lets CGB-compatible games run with DMG palettes). Applies on the next reset or load. |
| Debug | Off / On | status lines, see below |

In the menu: **up/down** moves the cursor, **left/right** (or A) changes the value, **A** selects, **B** goes back or closes the menu.

| Display modes | DMG palettes |
|---|---|
| ![display modes](img/display_modes.png) | ![palettes](img/palettes.png) |

## Debug overlay

![debug overlay](img/debug.png)

With *Debug = On*, the HDMI picture gets two status lines in the black border:

```
FPS 60  GBC 2X  PAD -D-----S  UP 00:05:23
uCity                    MBC5 128K ROM
```

| Field | Meaning |
|---|---|
| `FPS` | frames the Game Boy LCD produced in the last second (0 while paused or with the LCD off) |
| `GBC` / `DMG` | mode the core runs in |
| `1X` / `2X` | CPU speed (GBC double-speed mode) |
| `PAD UDLRABsS` | live button state: Up, Down, Left, Right, A, B, select, Start (`-` = released). Includes all inputs: DualShock, GPIO and USB remote. |
| `UP hh:mm:ss` | time since power-up |
| second line | game name, mapper and ROM size from the cart header (bytes 0x147 / 0x148) |

The SPI LCD shows a compact version in its top text row: `60fps   UDLRABsS`.

![gameplay with the debug overlay](img/debug_play.gif)
