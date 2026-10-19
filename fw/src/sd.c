// SD card in SPI mode (SDSC / SDHC / SDXC) and the FatFs disk interface.
#include "util.h"
#include "ff.h"
#include "diskio.h"

int sd_ok;
static int sd_hc;          // block addressing
static uint32_t sd_nsec;
static uint8_t cur_div = 63;

static inline uint8_t x(uint8_t b) { SD_DATA = b; return (uint8_t)SD_DATA; }
static inline void sel(int on) { SD_CTRL = ((uint32_t)cur_div << 8) | (on ? 1 : 0); }

static int wait_ready(uint32_t t) {
    uint32_t end = ms_now() + t;
    while (x(0xFF) != 0xFF) if ((int32_t)(ms_now() - end) > 0) return -1;
    return 0;
}

static void deselect(void) { sel(0); x(0xFF); }
static int select(void) {
    sel(1); x(0xFF);
    if (wait_ready(500) == 0) return 0;
    deselect();
    return -1;
}

static uint8_t cmd(uint8_t c, uint32_t arg) {
    if (c & 0x80) {                 // ACMD
        c &= 0x7F;
        uint8_t r = cmd(55, 0);
        if (r > 1) return r;
    }
    if (c != 12) { deselect(); if (select()) return 0xFF; }
    x(0x40 | c); x(arg >> 24); x(arg >> 16); x(arg >> 8); x(arg);
    x(c == 0 ? 0x95 : c == 8 ? 0x87 : 0x01);
    if (c == 12) x(0xFF);
    uint8_t r;
    int n = 10;
    do r = x(0xFF); while ((r & 0x80) && --n);
    return r;
}

int sd_init(void) {
    sd_ok = 0;
    cur_div = 63;                   // ~260 kHz during init
    sel(0);
    for (int i = 0; i < 10; i++) x(0xFF);
    uint8_t r = 0xFF;
    for (int i = 0; i < 10 && r != 1; i++) r = cmd(0, 0);
    if (r != 1) { deselect(); return -1; }
    int v2 = 0;
    if (cmd(8, 0x1AA) == 1) {
        uint8_t o[4];
        for (int i = 0; i < 4; i++) o[i] = x(0xFF);
        if (o[2] != 0x01 || o[3] != 0xAA) { deselect(); return -2; }
        v2 = 1;
    }
    uint32_t end = ms_now() + 1000;
    do r = cmd(0x80 | 41, v2 ? 1u << 30 : 0);
    while (r != 0 && (int32_t)(ms_now() - end) < 0);
    if (r != 0) { deselect(); return -3; }
    sd_hc = 0;
    if (v2 && cmd(58, 0) == 0) {
        uint8_t o[4];
        for (int i = 0; i < 4; i++) o[i] = x(0xFF);
        sd_hc = (o[0] & 0x40) != 0;
    }
    if (!sd_hc) cmd(16, 512);
    sd_nsec = 0;
    if (cmd(9, 0) == 0) {           // capacity from the CSD
        uint8_t csd[16];
        uint32_t t = ms_now() + 200;
        while (x(0xFF) != 0xFE) if ((int32_t)(ms_now() - t) > 0) break;
        for (int i = 0; i < 16; i++) csd[i] = x(0xFF);
        x(0xFF); x(0xFF);
        if ((csd[0] >> 6) == 1) {
            uint32_t cs = ((uint32_t)(csd[7] & 0x3F) << 16) | ((uint32_t)csd[8] << 8) | csd[9];
            sd_nsec = (cs + 1) << 10;
        } else {
            uint32_t n = (csd[5] & 15) + ((csd[10] & 128) >> 7) + ((csd[9] & 3) << 1) + 2;
            uint32_t cs = (csd[8] >> 6) + ((uint32_t)csd[7] << 2) + ((uint32_t)(csd[6] & 3) << 10) + 1;
            sd_nsec = cs << (n - 9);
        }
    }
    deselect();
    cur_div = 0;                    // 16.9 MHz
    sd_ok = 1;
    return 0;
}

uint32_t sd_sectors(void) { return sd_nsec; }

static int rx_block(uint8_t *d, uint32_t n) {
    uint32_t end = ms_now() + 200;
    uint8_t t;
    while ((t = x(0xFF)) == 0xFF) if ((int32_t)(ms_now() - end) > 0) return -1;
    if (t != 0xFE) return -1;
    if (!((uintptr_t)d & 3)) {
        volatile uint32_t *w = (volatile uint32_t *)d;
        for (uint32_t i = 0; i < n / 4; i++) w[i] = SD_WORD;
    } else {
        volatile uint8_t *b = d;
        for (uint32_t i = 0; i < n; i++) b[i] = x(0xFF);
    }
    x(0xFF); x(0xFF);
    return 0;
}

static int tx_block(const uint8_t *s, uint8_t token) {
    if (wait_ready(500)) return -1;
    x(token);
    if (token == 0xFD) return 0;
    const volatile uint8_t *b = s;
    for (int i = 0; i < 512; i++) x(b[i]);
    x(0xFF); x(0xFF);
    if ((x(0xFF) & 0x1F) != 0x05) return -1;
    return 0;
}

int sd_read(uint32_t lba, void *dst, uint32_t count) {
    if (!sd_ok) return -1;
    uint8_t *d = dst;
    if (!sd_hc) lba *= 512;
    int err = 0;
    if (count == 1) {
        if (cmd(17, lba) != 0 || rx_block(d, 512)) err = -1;
    } else if (cmd(18, lba) != 0) err = -1;
    else {
        while (count) { if (rx_block(d, 512)) { err = -1; break; } d += 512; count--; }
        cmd(12, 0);
    }
    deselect();
    return err;
}

int sd_write(uint32_t lba, const void *src, uint32_t count) {
    if (!sd_ok) return -1;
    const uint8_t *s = src;
    if (!sd_hc) lba *= 512;
    int err = 0;
    if (count == 1) {
        if (cmd(24, lba) != 0 || tx_block(s, 0xFE)) err = -1;
    } else {
        cmd(0x80 | 23, count);
        if (cmd(25, lba) != 0) err = -1;
        else {
            while (count) { if (tx_block(s, 0xFC)) { err = -1; break; } s += 512; count--; }
            if (tx_block(0, 0xFD)) err = -1;
        }
    }
    wait_ready(500);
    deselect();
    return err;
}

// ---------------------------------------------------------------- FatFs glue
DSTATUS disk_status(BYTE pdrv) { return (pdrv == 0 && sd_ok) ? 0 : STA_NOINIT; }
DSTATUS disk_initialize(BYTE pdrv) {
    if (pdrv) return STA_NOINIT;
    if (!sd_ok) sd_init();
    return sd_ok ? 0 : STA_NOINIT;
}
DRESULT disk_read(BYTE pdrv, BYTE *buff, LBA_t sector, UINT count) {
    return sd_read(sector, buff, count) ? RES_ERROR : RES_OK;
}
DRESULT disk_write(BYTE pdrv, const BYTE *buff, LBA_t sector, UINT count) {
    return sd_write(sector, buff, count) ? RES_ERROR : RES_OK;
}
DRESULT disk_ioctl(BYTE pdrv, BYTE c, void *buff) {
    switch (c) {
    case CTRL_SYNC: return RES_OK;
    case GET_SECTOR_COUNT: *(LBA_t *)buff = sd_nsec; return RES_OK;
    case GET_SECTOR_SIZE: *(WORD *)buff = 512; return RES_OK;
    case GET_BLOCK_SIZE: *(DWORD *)buff = 1; return RES_OK;
    }
    return RES_PARERR;
}
