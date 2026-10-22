# Original cartridges

An original Game Boy / Game Boy Color cartridge plugs into a small reader on the cartridge port: the same four pins as the W25Q flash cartridge (51, 48, 55, 49).

The reader is five logic chips and no microcontroller:
- the FPGA shifts the address and control signals out through 74HCT595 shift registers;
- it reads the data bus back through a 74LV165.

The bitstream does not change, and the menu firmware drives the bus.

**How a game plays:**
- **Library → Cartridge** finds the cartridge. The menu also probes it at power-up.
- **Play** copies the ROM into SDRAM and runs it from there, like a game from the SD card.
- The cartridge's battery RAM is the save: it is read when the game starts and written back (changed bytes only) whenever the menu saves.

## Circuit

| Chip | Supply | Job |
|---|---|---|
| U1 74HCT595 | 5 V | A0–A7 |
| U2 74HCT595 | 5 V | A8–A15 |
| U3 74HCT595 | 5 V | control: /RD, /WR, /CS, /RST, data-out enable |
| U4 74HCT595 | 5 V | D0–D7 out (tri-state, for MBC and RAM writes) |
| U5 74LV165A | 3.3 V | D0–D7 in |

The HCT parts take the FPGA's 3.3 V levels and drive the cartridge at 5 V. U5 runs from 3.3 V, so its output is safe for the FPGA. Its inputs must tolerate 5 V: the 74LV165A does (check your vendor's datasheet). The alternative is a 74HC165 at 5 V with a 1 kΩ / 2 kΩ divider on QH.

### Tang Nano side

| FPGA pin | Goes to |
|---|---|
| 55 (MOSI) | U1 SER (14) |
| 48 (CLK) | SRCLK (11) of U1–U4, CLK (2) of U5 |
| 51 (CS) | RCLK (12) of U1–U4, SH/LD (1) of U5 |
| 49 (MISO) | U5 QH (9) |
| 5V | U1–U4 VCC, cartridge VCC |
| 3V3 | U5 VCC |

### Chain and outputs

- **Chain:** U1 QH' (9) → U2 SER, U2 QH' → U3 SER, U3 QH' → U4 SER.
- **On U1–U4:** /SRCLR (10) to 5 V. /OE (13) to GND on U1–U3; U4's /OE comes from U3 QE.
- **On U5:** CLK INH (15) to GND, SER (10) to GND.
- **Data bus:** a 10 kΩ pull-up to 5 V on each of D0–D7, so an empty slot reads 0xFF.

| Signal | From | Cartridge pin |
|---|---|---|
| A0 … A7 | U1 QA … QH | 6 … 13 |
| A8 … A15 | U2 QA … QH | 14 … 21 |
| /RD | U3 QA | 4 |
| /WR | U3 QB | 3 |
| /CS (RAM select) | U3 QC | 5 |
| /RST | U3 QD | 30 |
| data-out enable | U3 QE | → U4 /OE |
| D0 … D7 | U4 QA … QH, and U5 A … H | 22 … 29 |
| VCC | 5V | 1 |
| GND | GND | 32 |

Pin 2 (PHI clock) and pin 31 (audio in) are left open.

The slot is the 32-pin, 1.5 mm pitch Game Boy connector. Before powering up, check the pin numbering with a multimeter against a cartridge: pin 1 (VCC) and pin 32 (GND) are the two outer contacts, and GND connects to the board's ground fill.

### How the firmware drives it

`fw/src/gbcart.c` runs one bus cycle at a time:
1. The firmware shifts the control byte and the address (24 bits). U4 at the end of the chain gets junk, but its outputs are off.
2. A low pulse on pin 51 makes U5 capture the data bus, which still shows the previous address.
3. The rising edge of the pulse puts the new address and control on the cartridge.

U5 returns the captured byte during the first 8 bits of the next cycle, so reads stream two cycles behind their address. A write shifts 32 bits, with the data byte first.

**Writes:**
- MBC registers and cartridge RAM take three cycles: /WR high, low, high, with U4 enabled.
- The control byte idles at 0xFF (nothing selected). Anything a flash command shifts in by mistake is harmless.

**Mappers:**
- ROM banking for MBC1 (including banks 20/40/60h), MBC2, MBC3 and MBC5.
- Camera, HuC1/HuC3 and MBC6/7 are treated as MBC5 for the ROM.
- RAM banking for MBC1/3/5 and the 512×4-bit RAM of MBC2.

## Speed and checks

- **Speed:** a read cycle shifts 24 bits at 8.4 MHz. The menu CPU runs from SDRAM without a cache, so one byte takes about 9.5 µs: a 1 MB game loads in about 10 s, and the log prints the exact time.
- **Detection:** the header checksum (0x14D) must be right; otherwise the cartridge is not offered.
- **Wiring check:** after loading, the menu checks the global checksum (0x14E). A mismatch shows "Cartridge checksum mismatch / check the reader wiring", and the game is still started.

## Limits

- **Size:** ROMs up to 6 MB (the SDRAM space for games). 8 MB cartridges are refused.
- **Not supported:**
  - the MBC3 real-time clock: the core keeps its own;
  - rumble, the Game Boy Camera sensor, MBC7 tilt and its EEPROM, HuC IR;
  - MBC1 multicarts;
  - GBA cartridges.
- **Saves:** they reach the cartridge only when the menu saves: on opening the menu, on auto-save and on loading another game. Do not pull the cartridge while a game runs; open the menu first.
- **Hot-plugging:** insert or swap cartridges with the power off, or with the menu open, then enter **Library → Cartridge** again to rescan.

## Simulation

The Tang Nano 20K simulator models the reader with a cartridge in it:

```sh
build/tang_sim/tang_sim --flash flash.bin --cart game.gb --no-hdmi --stdout-text
```

`sim/tang/main.cpp` (`CartReader`) implements the 595 chain, the 165 and MBC1/2/3/5 with RAM. On exit it reports how many RAM bytes the firmware changed.
