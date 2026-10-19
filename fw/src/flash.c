// On-board SPI flash: read, 4 KB erase, page program, deep power-down.
#include "util.h"

static int fl_asleep;

static inline void cs(int on) { FL_CTRL = on ? 1 : 0; }
static inline uint8_t x(uint8_t b) { FL_DATA = b; return (uint8_t)FL_DATA; }

static void wake(void) {
    if (!fl_asleep) return;
    cs(1); x(0xAB); cs(0);
    wait_ms(1);
    fl_asleep = 0;
}

void flash_sleep(void) {
    wake();
    cs(1); x(0xB9); cs(0);
    fl_asleep = 1;
}

void flash_init(void) { fl_asleep = 1; wake(); }

uint32_t flash_id(void) {
    wake();
    cs(1); x(0x9F);
    uint32_t id = (uint32_t)x(0xFF) << 16;
    id |= (uint32_t)x(0xFF) << 8;
    id |= x(0xFF);
    cs(0);
    return id;
}

static void cmd_addr(uint8_t c, uint32_t a) {
    cs(1); x(c); x(a >> 16); x(a >> 8); x(a);
}

void flash_read(uint32_t a, void *dst, uint32_t n) {
    wake();
    uint8_t *d = dst;
    cmd_addr(0x03, a);
    while (n >= 4 && !((uintptr_t)d & 3)) { *(uint32_t *)d = FL_WORD; d += 4; n -= 4; }
    while (n--) *d++ = x(0xFF);
    cs(0);
}

void flash_read_sdram(uint32_t a, uint32_t dst, uint32_t n) {
    wake();
    cmd_addr(0x03, a);
    volatile uint32_t *d = (volatile uint32_t *)sdram(dst);
    for (uint32_t i = 0; i < (n + 3) / 4; i++) d[i] = FL_WORD;
    cs(0);
}

static void wait_busy(void) {
    cs(1); x(0x05);
    while (x(0xFF) & 1) ;
    cs(0);
}
static void wren(void) { cs(1); x(0x06); cs(0); }

static void erase4k(uint32_t a) {
    wren(); cmd_addr(0x20, a); cs(0); wait_busy();
}

static void program(uint32_t a, const volatile uint8_t *s, uint32_t n) {
    wren(); cmd_addr(0x02, a);
    while (n--) x(*s++);
    cs(0); wait_busy();
}

// addr must be 4 KB aligned; the rest of the last sector is erased
static int write_any(uint32_t a, const volatile uint8_t *s, uint32_t n) {
    if (a & 0xFFF) return -1;
    wake();
    for (uint32_t o = 0; o < n; o += 4096) erase4k(a + o);
    for (uint32_t o = 0; o < n; o += 256) program(a + o, s + o, n - o < 256 ? n - o : 256);
    return 0;
}
int flash_write(uint32_t a, const void *s, uint32_t n) { return write_any(a, s, n); }
int flash_write_sdram(uint32_t a, uint32_t s, uint32_t n) { return write_any(a, sdram(s), n); }

// Rewrites only the 4 KB sectors whose contents differ (saves flash wear and time).
// Returns the number of sectors written.
int flash_update_sdram(uint32_t a, uint32_t src, uint32_t n) {
    static uint32_t buf[1024];
    int written = 0;
    wake();
    for (uint32_t o = 0; o < n; o += 4096) {
        uint32_t len = n - o < 4096 ? n - o : 4096;
        flash_read(a + o, buf, len);
        const volatile uint8_t *s = sdram(src + o);
        const uint8_t *b = (const uint8_t *)buf;
        uint32_t i = 0;
        while (i < len && b[i] == s[i]) i++;
        if (i == len) continue;
        erase4k(a + o);
        for (uint32_t p = 0; p < len; p += 256) program(a + o + p, s + p, len - p < 256 ? len - p : 256);
        written++;
    }
    return written;
}
