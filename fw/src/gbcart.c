// Original Game Boy / GBC cartridges through the cartridge reader (docs/cart_reader.md):
// shift registers on the four pins of the cartridge port, no microcontroller.
//
//   MOSI (55) -> 74HCT595 x4 chain: D0-7 out | control | A8-15 | A0-7   (5 V outputs)
//   CLK  (48) -> SRCLK of the 595s and CLK of the 74LV165
//   CS   (51) -> RCLK of the 595s and /PL of the 165: low loads D0-7 into the 165,
//               the rising edge puts the shifted address and control on the cartridge
//   MISO (49) <- Q7 of the 165 (D0-7 in, 3.3 V)
//
// A bus cycle shifts the control byte and the address (24 bits; the data-out 595 at the end of
// the chain gets junk, but its outputs are off) or, for a write, the data byte first (32 bits),
// then pulses CS: while it is low the 165 loads the data bus, which still shows the previous
// cycle's address; the rising edge puts the new one out. The byte that comes back during a
// cycle is what the 165 loaded at the end of the cycle before, so reads stream two cycles behind
// their address. The firmware runs from SDRAM, so the read loop is kept tight.
#include "util.h"
#include "gbcart.h"

// control byte, all active low; 0xFF = idle (and what a W25Q command leaves behind)
#define K_RD  0x01      // /RD
#define K_WR  0x02      // /WR
#define K_CS  0x04      // /CS: cartridge RAM (A000-BFFF)
#define K_RST 0x08      // /RST
#define K_DOE 0x10      // /OE of the data-out 595
#define IDLE  0xFF
#define DIV   1         // SCK 8.4 MHz
#define LAT_LO ((DIV << 8) | 1)
#define LAT_HI (DIV << 8)

enum { M_NONE, M_MBC1, M_MBC2, M_MBC3, M_MBC5 };
static int mbc;

// one read-format cycle; returns the byte loaded at the end of the previous cycle
static inline uint8_t cyc(uint8_t ctl, uint16_t a) {
    CT_DATA = ctl;
    uint8_t r = (uint8_t)CT_DATA;       // waits for the byte: Q7 of the 165, D7 first
    CT_DATA = a >> 8;
    CT_DATA = a;
    (void)CT_DATA;                      // the last byte must be out before the latch
    CT_CTRL = LAT_LO;
    CT_CTRL = LAT_HI;
    return r;
}

static void cyc_w(uint8_t d, uint8_t ctl, uint16_t a) {
    CT_DATA = d;
    CT_DATA = ctl;
    CT_DATA = a >> 8;
    CT_DATA = a;
    (void)CT_DATA;
    CT_CTRL = LAT_LO;
    CT_CTRL = LAT_HI;
}

static void bus_write(uint16_t a, uint8_t v, int ram) {
    uint8_t c = (uint8_t)(IDLE & ~K_DOE & (ram ? ~K_CS : 0xFF));
    cyc_w(v, c, a);
    cyc_w(v, (uint8_t)(c & ~K_WR), a);
    cyc_w(v, c, a);
    cyc(IDLE, a);
}

// reads n bytes from a..a+n-1 (one address window, ROM or RAM)
static void bus_read(uint16_t a, uint8_t *dst, uint32_t n, int ram) {
    uint8_t c = (uint8_t)(IDLE & ~K_RD & (ram ? ~K_CS : 0xFF));
    cyc(c, a);
    cyc(n > 1 ? c : IDLE, (uint16_t)(a + 1));
    for (uint32_t i = 0; i < n; i++) dst[i] = cyc(i + 2 < n ? c : IDLE, (uint16_t)(a + i + 2));
}

// a whole ROM window into SDRAM (n a multiple of 4, at least 4). Unrolled: every instruction
// is fetched from SDRAM. The SPI port sends only the low 8 bits of a write and reads back
// zero-extended bytes, so nothing is masked.
#define STEP(ctl, sh)     *D = (ctl); w |= *D << (sh); *D = na >> 8; *D = na; (void)*D; *C = lo; *C = hi; na++;

static void bus_read_sdram(uint16_t a, uint32_t dst, uint32_t n) {
    const uint32_t c = IDLE & ~K_RD, lo = LAT_LO, hi = LAT_HI;
    volatile uint32_t *d = (volatile uint32_t *)sdram(dst);
    volatile uint32_t *D = &CT_DATA, *C = &CT_CTRL;
    uint32_t na = a, w = 0;
    STEP(c, 0) STEP(c, 0)                           // prime the pipeline: two cycles of lag
    for (uint32_t blocks = n / 4 - 1; blocks; blocks--) {
        w = 0;
        STEP(c, 0) STEP(c, 8) STEP(c, 16) STEP(c, 24)
        *d++ = w;
    }
    w = 0;
    STEP(c, 0) STEP(c, 8) STEP(IDLE, 16) STEP(IDLE, 24)   // nothing selected past the window
    *d = w;
}

// maps ROM bank b and returns the CPU address of its window
static uint16_t rom_bank(int b) {
    switch (mbc) {
    case M_MBC1:
        if (b == 0) { bus_write(0x6000, 0, 0); bus_write(0x4000, 0, 0); return 0x0000; }
        bus_write(0x4000, (uint8_t)(b >> 5), 0);
        if (!(b & 0x1F)) { bus_write(0x6000, 1, 0); return 0x0000; }   // banks 20/40/60: mode 1
        bus_write(0x6000, 0, 0);
        bus_write(0x2000, (uint8_t)(b & 0x1F), 0);
        return 0x4000;
    case M_MBC2:
        if (b == 0) return 0x0000;
        bus_write(0x2100, (uint8_t)(b & 0x0F), 0);
        return 0x4000;
    case M_MBC3:
        if (b == 0) return 0x0000;
        bus_write(0x2000, (uint8_t)(b & 0x7F), 0);
        return 0x4000;
    case M_MBC5:
        if (b == 0) return 0x0000;
        bus_write(0x2000, (uint8_t)b, 0);
        bus_write(0x3000, (uint8_t)(b >> 8), 0);
        return 0x4000;
    }
    return b ? 0x4000 : 0x0000;
}

static void ram_on(int bank) {
    if (mbc == M_NONE) return;
    bus_write(0x0000, 0x0A, 0);
    if (mbc == M_MBC1) bus_write(0x6000, 1, 0);
    if (mbc != M_MBC2) bus_write(0x4000, (uint8_t)bank, 0);
}
static void ram_off(void) {
    if (mbc == M_NONE) return;
    bus_write(0x0000, 0x00, 0);
    if (mbc == M_MBC1) bus_write(0x6000, 0, 0);
}

static int mbc_of(uint8_t t) {
    switch (t) {
    case 0x01: case 0x02: case 0x03: return M_MBC1;
    case 0x05: case 0x06: return M_MBC2;
    case 0x0F: case 0x10: case 0x11: case 0x12: case 0x13: return M_MBC3;
    case 0x00: case 0x08: case 0x09: return M_NONE;
    }
    return M_MBC5;              // MBC5, Camera, HuC1/3, MBC6/7: bank number at 0x2000
}

int gbcart_probe(uint8_t hdr[0x50]) {
    for (int i = 0; i < 4; i++) cyc(IDLE, 0);   // flush whatever a flash command left
    mbc = M_NONE;
    bus_read(0x0100, hdr, 0x50, 0);
    uint8_t x = 0;
    for (int i = 0x34; i < 0x4D; i++) x = (uint8_t)(x - hdr[i] - 1);
    int blank = 1;
    for (int i = 0x34; i < 0x44; i++) if (hdr[i] != 0x00 && hdr[i] != 0xFF) blank = 0;
    if (blank || x != hdr[0x4D] || hdr[0x48] > 8) return 0;
    mbc = mbc_of(hdr[0x47]);
    return 1;
}

// returns 1 when the ROM matches the global checksum in its header (0x14E, the 16-bit sum of
// every other byte): a check of the wiring, since nearly every cartridge has it right
int gbcart_read_rom(uint32_t dst, uint32_t size, void (*progress)(uint32_t, uint32_t)) {
    for (uint32_t o = 0; o < size; o += 0x4000) {
        if (progress) progress(o, size);
        uint16_t w = rom_bank((int)(o >> 14));
        bus_read_sdram(w, dst + o, 0x4000);
    }
    rom_bank(0);
    if (progress) progress(size, size);
    volatile uint32_t *r = (volatile uint32_t *)sdram(dst);
    uint32_t sum = 0;
    for (uint32_t i = 0; i < size / 4; i++) {
        uint32_t w = r[i];
        sum += (w & 0xFF) + ((w >> 8) & 0xFF) + ((w >> 16) & 0xFF) + (w >> 24);
    }
    volatile uint8_t *b = sdram(dst);
    uint16_t want = (uint16_t)(b[0x14E] << 8 | b[0x14F]);
    sum -= b[0x14E] + b[0x14F];
    return (uint16_t)sum == want;
}

static uint32_t ram_len(uint32_t n) { return mbc == M_MBC2 ? 512 : n; }

void gbcart_read_ram(uint32_t dst, uint32_t n) {
    n = ram_len(n);
    volatile uint8_t *d = sdram(dst);
    uint8_t buf[256];
    for (uint32_t o = 0; o < n; o += sizeof buf) {
        if ((o & 0x1FFF) == 0) ram_on((int)(o >> 13));
        uint32_t len = n - o < sizeof buf ? n - o : sizeof buf;
        bus_read((uint16_t)(0xA000 + (o & 0x1FFF)), buf, len, 1);
        for (uint32_t i = 0; i < len; i++) d[o + i] = mbc == M_MBC2 ? (buf[i] | 0xF0) : buf[i];
    }
    ram_off();
}

// writes only the bytes that differ; returns how many were written
uint32_t gbcart_write_ram(uint32_t src, uint32_t n) {
    n = ram_len(n);
    volatile uint8_t *s = sdram(src);
    uint8_t buf[256];
    uint32_t written = 0;
    for (uint32_t o = 0; o < n; o += sizeof buf) {
        if ((o & 0x1FFF) == 0) ram_on((int)(o >> 13));
        uint32_t len = n - o < sizeof buf ? n - o : sizeof buf;
        uint16_t a = (uint16_t)(0xA000 + (o & 0x1FFF));
        bus_read(a, buf, len, 1);
        for (uint32_t i = 0; i < len; i++) {
            uint8_t v = s[o + i], old = buf[i];
            if (mbc == M_MBC2) { v |= 0xF0; old |= 0xF0; }
            if (v != old) { bus_write((uint16_t)(a + i), v, 1); written++; }
        }
    }
    ram_off();
    return written;
}
