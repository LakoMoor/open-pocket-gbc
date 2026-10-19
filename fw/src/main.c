// Open Pocket GBC menu firmware (FemtoRV32, runs from SDRAM).
//
// - Pocket-style menu on the HDMI OSD (42 x 24 cells) and the SPI LCD (16 x 16 cells)
// - games from the SD card (FAT32/exFAT, folders, long names) or the internal flash
// - cartridge saves: <rom>.sav on the SD card, or a slot in the SPI flash
// - settings stored in the SPI flash, so everything works without an SD card
// - power: the CPU sleeps in REG_WAIT, HDMI / LCD can be switched off, sleep timer
#include <string.h>
#include <strings.h>
#include "util.h"
#include "osd.h"
#include "ff.h"

#define FW_VERSION      "1.0"
#define GAMES_BASE      0x200000u
#define SAVE_BASE       0x600000u       // 15 slots of 0x22000: header sector + up to 128 KB
#define SAVE_SLOT       0x22000u
#define SET_MAGIC       0x3253504Fu     // "OPS2"
#define SET_MAGIC_V1    0x3153504Fu     // "OPS1": no speaker boost yet
#define CART_MAGIC      0x3143504Fu     // "OPC1"
#define CART_ROM        0x10000u        // ROM offset in the cartridge flash

// ================================================================ settings
typedef struct {
    uint32_t magic;
    uint8_t  disp_mode, dmg_pal, gbc_raw, lcd_crop;
    uint8_t  dbg_on, lcd_bri, volume, swap_ab;
    uint8_t  sys_mode, hdmi_off, lcd_off, led_en;
    uint8_t  autosave, toasts, boot_menu, sleep_min;
    uint8_t  last_src, last_flash, speaker, spk_boost;
    char     last_path[224];
    uint8_t  power_mode, rsv3[3];        // 0 normal, 1 battery
    uint32_t sum;
} settings_t;

static settings_t set, set_stored;
static uint32_t set_addr;               // 0: flash has no room for settings / saves
static int      flash_saves;

static uint32_t sum32(const void *p, int n) {
    const uint8_t *b = p;
    uint32_t s = 0x1234;
    for (int i = 0; i < n; i++) s = s * 31 + b[i];
    return s;
}

static void set_defaults(void) {
    memset(&set, 0, sizeof set);
    set.magic = SET_MAGIC;
    set.disp_mode = 1;      // pixel grid, like the Pocket's original display mode
    set.dmg_pal = 2;        // Pocket
    set.lcd_bri = 3;
    set.volume = 4;
    set.autosave = 1;
    set.toasts = 1;
    set.spk_boost = 2;      // x4
}

static void settings_save(void) {
    set.sum = sum32(&set, sizeof set - 4);
    if (!set_addr || !memcmp(&set, &set_stored, sizeof set)) return;
    flash_write(set_addr, &set, sizeof set);
    set_stored = set;
    logf("settings saved\n");
}

// ================================================================ control registers
static uint32_t ctrl;

static void ctrl_write(void) { REG_CTRL = ctrl; }
static void ctrl_bits(uint32_t mask, int on) {
    if (on) ctrl |= mask; else ctrl &= ~mask;
    ctrl_write();
}

static const uint8_t bri_duty[4] = { 3, 7, 11, 15 };

// Battery mode: HDMI off (PLL down, outputs tri-stated, no framebuffer writes), LCD at
// 25 % and nearly dark after 30 s without input, no LEDs or debug lines, sleep after 5 min.
static int lcd_dimmed;
static int battery(void) { return set.power_mode == 1; }

static void apply_settings(void) {
    int batt = battery();
    uint32_t duty = bri_duty[set.lcd_bri & 3];
    if (batt && duty > 3) duty = 3;
    if (lcd_dimmed) duty = 1;
    REG_CFG = (set.disp_mode & 3) | ((set.dmg_pal & 7) << 2) | ((set.gbc_raw & 1) << 5) |
              ((set.lcd_crop & 1) << 6) | ((uint32_t)(set.dbg_on && !batt) << 7) |
              (duty << 8) | ((uint32_t)(set.volume & 7) << 12) |
              ((uint32_t)(set.swap_ab & 1) << 15) | ((uint32_t)(set.speaker & 1) << 16) | ((uint32_t)(set.spk_boost & 3) << 17);
    ctrl &= ~((3u << C_SYS_SHIFT) | C_HDMI_OFF | C_LCD_OFF | C_LED);
    ctrl |= ((uint32_t)set.sys_mode << C_SYS_SHIFT) | ((set.hdmi_off || batt) ? C_HDMI_OFF : 0) |
            (set.lcd_off ? C_LCD_OFF : 0) | ((set.led_en && !batt) ? C_LED : 0);
    ctrl_write();
}

// ================================================================ storage
static FATFS fs;
static int   sd_mounted;

static void sd_mount(void) {
    sd_mounted = 0;
    if (sd_init() != 0) { logf("sd: no card\n"); return; }
    FRESULT r = f_mount(&fs, "", 1);
    sd_mounted = (r == FR_OK);
    logf("sd: %u MB, mount %d\n", sd_sectors() / 2048, r);
}

typedef struct { char name[24]; uint32_t ofs, size; } fl_entry_t;
static fl_entry_t fl_dir[15];
static int fl_count;

static void flash_dir_read(void) {
    uint32_t hdr[4];
    flash_read(GAMES_BASE, hdr, 16);
    fl_count = 0;
    if (hdr[0] != 0x50434247u) return;          // "GBCP"
    fl_count = hdr[1] > 15 ? 15 : hdr[1];
    flash_read(GAMES_BASE + 16, fl_dir, fl_count * sizeof(fl_entry_t));
    for (int i = 0; i < fl_count; i++) fl_dir[i].name[23] = 0;
}

// ================================================================ cartridge (external W25Qxx)
// layout: 0x000000 header sector, 0x010000 ROM, size - 0x21000 save header sector,
// size - 0x20000 save data (up to 128 KB)
typedef struct { uint32_t magic, rom_size, rsv[2]; char name[48]; } cart_hdr_t;
static uint32_t   cart_id, cart_size;
static cart_hdr_t cart;
static int        cart_valid;

static uint32_t cart_save_addr(void) { return cart_size - 0x21000; }
static uint32_t cart_rom_max(void) { return cart_size > 0x41000 ? cart_size - 0x21000 - CART_ROM : 0; }

static void cart_probe(void) {
    flash_select(1);
    flash_init();
    cart_id = flash_id();
    cart_size = flash_size(cart_id);
    cart_valid = 0;
    if (cart_size) {
        flash_read(0, &cart, sizeof cart);
        cart.name[47] = 0;
        cart_valid = cart.magic == CART_MAGIC && cart.rom_size >= 0x8000 && cart.rom_size <= cart_rom_max();
        flash_sleep();
    }
    flash_select(0);
    logf("cart: id %06x, %u KB, %s\n", cart_id, cart_size >> 10, cart_valid ? cart.name : "no game");
}

// ================================================================ game state
static struct {
    int      loaded, src, flash_idx;
    char     path[256];
    char     name[48];
    uint8_t  cart_type, rom_code, ram_code, cgb;
    uint32_t rom_bytes, save_bytes;
    int      battery;
    int      save_pending;
    uint32_t dirty_ms, saved_ms;
    int      saved_once;
} game;

static const char *mapper_name(uint8_t t) {
    switch (t) {
    case 0x00: case 0x08: case 0x09: return "ROM only";
    case 0x01: case 0x02: case 0x03: return "MBC1";
    case 0x05: case 0x06: return "MBC2";
    case 0x0F: case 0x10: case 0x11: case 0x12: case 0x13: return "MBC3";
    case 0x19: case 0x1A: case 0x1B: case 0x1C: case 0x1D: case 0x1E: return "MBC5";
    case 0x20: return "MBC6";
    case 0x22: return "MBC7";
    case 0xFC: return "Camera";
    case 0xFE: return "HuC3";
    case 0xFF: return "HuC1";
    }
    return "Unknown";
}

static int has_battery(uint8_t t) {
    switch (t) {
    case 0x03: case 0x06: case 0x09: case 0x0D: case 0x0F: case 0x10: case 0x13:
    case 0x1B: case 0x1E: case 0x22: case 0xFC: case 0xFD: case 0xFE: case 0xFF: return 1;
    }
    return 0;
}

static uint32_t ram_bytes(uint8_t type, uint8_t code) {
    if (type == 0x05 || type == 0x06) return 512;           // MBC2 internal RAM
    switch (code) {
    case 1: return 2048;
    case 2: return 8192;
    case 3: return 32768;
    case 4: return 131072;
    case 5: return 65536;
    }
    return 0;
}

// ================================================================ toasts and screens
static uint32_t toast_until;
static int menu_active;

static void hint(int x, int y, const char *key, const char *text, uint8_t bg) {
    osd_put(x, y, G_PILL_L | EXT, AT(CL_LINE, bg));
    x = osd_text(x + 1, y, key, AT(CL_WHITE, CL_LINE));
    osd_put(x, y, G_PILL_R | EXT, AT(CL_LINE, bg));
    osd_text(x + 2, y, text, AT(CL_LIGHT, bg));
}

static void toast(const char *msg, uint8_t icon, uint8_t colour) {
    if (menu_active) return;
    osd_clear(AT(CL_WHITE, CL_GAME));
    int w = (int)strlen(msg) + 6;
    int x = OSD_W - 2 - w;
    osd_pill(x, 1, w, CL_PANEL, CL_GAME);
    osd_put(x + 2, 1, icon, AT(colour, CL_PANEL));
    osd_text(x + 4, 1, msg, AT(CL_WHITE, CL_PANEL));
    osd_present();
    ctrl &= ~C_DIM;
    ctrl_bits(C_OSD, 1);
    toast_until = ms_now() + 1600;
}

// LCD: navy title bar on the top row, the rest cleared
static void lcd_header(const char *title) {
    lcd_clear(AT(CL_WHITE, CL_SHADE));
    for (int x = 0; x < LCD_W; x++) lcd_put(x, 0, ' ', AT(CL_WHITE, CL_NAVY));
    lcd_put(0, 0, G_STAR, AT(CL_BLUE, CL_NAVY));
    lcd_text(2, 0, title, AT(CL_WHITE, CL_NAVY));
}

static void progress_screen(const char *title, const char *name, uint32_t done, uint32_t total) {
    osd_clear(AT(CL_WHITE, CL_SHADE));
    osd_text(15, 9, title, AT(CL_GREY, CL_SHADE));
    int n = (int)strlen(name);
    if (n > 36) n = 36;
    osd_textn(21 - n / 2, 11, name, 36, AT(CL_WHITE, CL_SHADE));
    int w = 30, f = total ? (int)((uint64_t)done * (w - 2) / total) : 0;
    osd_put(6, 13, G_PILL_L | EXT, AT(CL_PANEL, CL_SHADE));
    osd_fill(7, 13, w - 2, ' ', AT(CL_WHITE, CL_PANEL));
    osd_put(6 + w - 1, 13, G_PILL_R | EXT, AT(CL_PANEL, CL_SHADE));
    if (f > 0) {
        osd_put(6, 13, G_PILL_L | EXT, AT(CL_BLUE, CL_SHADE));
        osd_fill(7, 13, f, ' ', AT(CL_WHITE, CL_BLUE));
    }
    osd_present();
    lcd_header(title);
    lcd_text(0, 4, name, AT(CL_WHITE, CL_SHADE));
    int lf = total ? (int)((uint64_t)done * 16 / total) : 0;
    lcd_pill(6, CL_PANEL, CL_SHADE);
    for (int x = 0; x < lf; x++)
        lcd_put(x, 6, x == 0 ? (G_PILL_L | EXT) : x == 15 ? (G_PILL_R | EXT) : ' ',
                x == 0 || x == 15 ? AT(CL_BLUE, CL_SHADE) : AT(CL_WHITE, CL_BLUE));
    char b[17];
    sfmt(b, sizeof b, "%u%%", total ? (unsigned)((uint64_t)done * 100 / total) : 0);
    lcd_text(8 - (int)strlen(b) / 2, 8, b, AT(CL_LIGHT, CL_SHADE));
    lcd_present();
}

static void message_screen(const char *title, const char *line) {
    osd_clear(AT(CL_WHITE, CL_SHADE));
    osd_text(21 - (int)strlen(title) / 2, 10, title, AT(CL_WHITE, CL_SHADE));
    osd_text(21 - (int)strlen(line) / 2, 12, line, AT(CL_GREY, CL_SHADE));
    osd_present();
    lcd_header(title);
    lcd_text(0, 5, line, AT(CL_LIGHT, CL_SHADE));
    if (strlen(line) > 16) lcd_text(0, 6, line + 16, AT(CL_LIGHT, CL_SHADE));
    lcd_present();
}

// ================================================================ saves
static void sav_path(char *out, const char *rom) {
    strcpy(out, rom);
    char *dot = strrchr(out, '.');
    char *sl = strrchr(out, '/');
    if (!dot || (sl && dot < sl)) dot = out + strlen(out);
    strcpy(dot, ".sav");
}

static uint32_t slot_addr(int idx) { return SAVE_BASE + (uint32_t)idx * SAVE_SLOT; }

// flash chip and header address of the save of a flash (1) or cartridge (3) game
static int save_slot(uint32_t *a) {
    if (game.src == 1 && flash_saves) { *a = slot_addr(game.flash_idx); return 0; }
    if (game.src == 3 && cart_size)   { *a = cart_save_addr(); return 1; }
    return -1;
}

static void save_load(void) {
    volatile uint8_t *cram = sdram(CRAM_BASE);
    for (uint32_t i = 0; i < 131072; i += 4) *(volatile uint32_t *)(cram + i) = 0xFFFFFFFFu;
    if (!game.battery || !game.save_bytes) return;
    if (game.src == 2 && sd_mounted) {
        char p[260];
        FIL f;
        sav_path(p, game.path);
        if (f_open(&f, p, FA_READ) == FR_OK) {
            UINT br;
            f_read(&f, (void *)cram, game.save_bytes, &br);
            f_close(&f);
            logf("save loaded: %s (%u)\n", p, br);
        }
    } else {
        uint32_t a, h[4];
        int chip = save_slot(&a);
        if (chip < 0) return;
        flash_select(chip);
        flash_read(a, h, 16);
        if (h[0] == 0x31564153u && h[1] == game.save_bytes && h[2] == sum32(game.name, 16)) {
            flash_read_sdram(a + 0x1000, CRAM_BASE, game.save_bytes);
            logf("save loaded from %s\n", chip ? "the cartridge" : "the flash");
        }
        flash_sleep();
        flash_select(0);
    }
}

static int save_write(void) {
    if (!game.loaded || !game.battery || !game.save_bytes) return -1;
    int ok = -1;
    if (game.src == 2 && sd_mounted) {
        char p[260];
        FIL f;
        sav_path(p, game.path);
        if (f_open(&f, p, FA_WRITE | FA_CREATE_ALWAYS) == FR_OK) {
            UINT bw;
            f_write(&f, (const void *)sdram(CRAM_BASE), game.save_bytes, &bw);
            f_close(&f);
            ok = (bw == game.save_bytes) ? 0 : -1;
        }
    } else {
        uint32_t a, h[4] = { 0x31564153u, game.save_bytes, sum32(game.name, 16), 0 }, old[4];
        int chip = save_slot(&a);
        if (chip >= 0) {
            flash_select(chip);
            int n = flash_update_sdram(a + 0x1000, CRAM_BASE, game.save_bytes);
            flash_read(a, old, 16);
            if (memcmp(old, h, 16)) { flash_write(a, h, 16); n++; }
            flash_sleep();
            flash_select(0);
            logf("flash save: %d sectors\n", n);
            ok = n ? 0 : 1;                     // 1: nothing changed
        }
    }
    game.save_pending = 0;
    if (ok >= 0) { game.saved_ms = ms_now(); game.saved_once = 1; }
    logf("save written: %d\n", ok);
    return ok;
}

// ================================================================ loading
static void feed_header(uint32_t rom_bytes) {
    volatile uint8_t *rom = sdram(ROM_BASE);
    for (uint32_t bank = 0; bank < rom_bytes; bank += 0x4000) {
        for (uint32_t i = 0; i < 0x150; i += 2) {
            IOCTL_ADDR = bank + i;
            IOCTL_DATA = rom[bank + i] | (rom[bank + i + 1] << 8);
        }
    }
}

static void title_from_header(void) {
    volatile uint8_t *rom = sdram(ROM_BASE);
    int n = 0;
    for (int i = 0; i < 16; i++) {
        uint8_t c = rom[0x134 + i];
        if (c == 0 || (i >= 11 && (c & 0x80))) break;
        game.name[n++] = (c >= 32 && c < 127) ? c : ' ';
    }
    while (n && game.name[n - 1] == ' ') n--;
    game.name[n] = 0;
}

static void name_from_path(const char *p) {
    const char *b = strrchr(p, '/');
    b = b ? b + 1 : p;
    int n = 0;
    while (b[n] && n < 47) { game.name[n] = b[n]; n++; }
    game.name[n] = 0;
    char *dot = strrchr(game.name, '.');
    if (dot && dot != game.name) *dot = 0;
}

static int cart_write_pending;           // write the loaded SD game to the cartridge

static void cart_progress(uint32_t done, uint32_t total) {
    progress_screen("Writing cartridge", game.name, done, total);
}

// writes the ROM in SDRAM to the cartridge flash
static int cart_write_rom(void) {
    if (!cart_size) { message_screen("No cartridge flash", "CS 51 CLK 48 DI 55 DO 49"); wait_ms(2000); return -1; }
    if (game.rom_bytes > cart_rom_max()) { message_screen("Cartridge too small", game.name); wait_ms(2000); return -1; }
    cart_hdr_t h;
    memset(&h, 0, sizeof h);
    flash_select(1);
    flash_init();
    flash_erase_range(0, 4096);                         // invalid until the ROM is complete
    flash_write_big(CART_ROM, ROM_BASE, game.rom_bytes, cart_progress);
    flash_erase_range(cart_save_addr(), 4096);          // drop the previous game's save
    h.magic = CART_MAGIC;
    h.rom_size = game.rom_bytes;
    strncpy(h.name, game.name, 47);
    flash_write(0, &h, sizeof h);
    // spot check: first and last 4 bytes of every 64 KB block
    int bad = 0;
    for (uint32_t o = 0; o < game.rom_bytes && !bad; o += 0x10000) {
        uint32_t v;
        flash_read(CART_ROM + o, &v, 4);
        if (v != *(volatile uint32_t *)sdram(ROM_BASE + o)) bad = 1;
    }
    flash_sleep();
    flash_select(0);
    if (bad) { message_screen("Cartridge write failed", "check the wiring"); wait_ms(2000); return -1; }
    cart = h;
    cart_valid = 1;
    logf("cartridge written: %s, %u bytes\n", h.name, h.rom_size);
    return 0;
}

// src 1: flash index, src 2: SD path, src 3: cartridge
static int load_game(int src, int idx, const char *path) {
    if (game.loaded && game.save_pending) save_write();
    // the core only resets while its clock enables run, so no pause during reset
    ctrl = (ctrl | C_CORE_RST | C_DOWNLOAD | C_OSD | C_DIM) & ~C_PAUSE;
    ctrl_write();
    game.loaded = 0;
    uint32_t size = 0;
    const char *nm = src == 1 ? fl_dir[idx].name : path;
    char shown[48];
    if (src == 1) strcpy(shown, fl_dir[idx].name);
    else if (src == 3) strcpy(shown, cart.name);
    else { const char *b = strrchr(path, '/'); strncpy(shown, b ? b + 1 : path, 47); shown[47] = 0; }
    (void)nm;

    if (src == 1) {
        size = fl_dir[idx].size;
        if (size > ROM_MAX) size = ROM_MAX;
        for (uint32_t o = 0; o < size; o += 0x10000) {
            progress_screen("Loading", shown, o, size);
            uint32_t n = size - o < 0x10000 ? size - o : 0x10000;
            flash_read_sdram(GAMES_BASE + fl_dir[idx].ofs + o, ROM_BASE + o, n);
        }
    } else if (src == 3) {
        if (!cart_valid) { message_screen("No game on the cartridge", ""); ctrl_bits(C_DOWNLOAD, 0); wait_ms(1500); return -1; }
        size = cart.rom_size;
        flash_select(1);
        for (uint32_t o = 0; o < size; o += 0x10000) {
            progress_screen("Loading cartridge", shown, o, size);
            uint32_t n = size - o < 0x10000 ? size - o : 0x10000;
            flash_read_sdram(CART_ROM + o, ROM_BASE + o, n);
        }
        flash_sleep();
        flash_select(0);
    } else {
        FIL f;
        if (!sd_mounted || f_open(&f, path, FA_READ) != FR_OK) {
            message_screen("Can't open file", shown);
            ctrl_bits(C_DOWNLOAD, 0);
            wait_ms(1500);
            return -1;
        }
        size = f_size(&f);
        if (size > ROM_MAX || size < 0x8000) {
            f_close(&f);
            message_screen(size < 0x8000 ? "File too small" : "ROM too large (6 MB max)", shown);
            ctrl_bits(C_DOWNLOAD, 0);
            wait_ms(1500);
            return -1;
        }
        for (uint32_t o = 0; o < size; o += 0x10000) {
            progress_screen("Loading", shown, o, size);
            UINT br;
            uint32_t n = size - o < 0x10000 ? size - o : 0x10000;
            if (f_read(&f, (void *)sdram(ROM_BASE + o), n, &br) != FR_OK || br != n) {
                f_close(&f);
                message_screen("Read error", shown);
            ctrl_bits(C_DOWNLOAD, 0);
                wait_ms(1500);
                return -1;
            }
        }
        f_close(&f);
    }
    progress_screen("Loading", shown, size, size);

    volatile uint8_t *rom = sdram(ROM_BASE);
    memset(&game, 0, sizeof game);
    game.src = src;
    game.flash_idx = idx;
    if (src == 2) { strncpy(game.path, path, 255); name_from_path(path); }
    else if (src == 3) strcpy(game.name, cart.name);
    else strcpy(game.name, fl_dir[idx].name);
    if (!game.name[0]) title_from_header();
    game.rom_bytes = size;
    game.cart_type = rom[0x147];
    game.rom_code  = rom[0x148];
    game.ram_code  = rom[0x149];
    game.cgb       = rom[0x143];
    game.battery   = has_battery(game.cart_type);
    game.save_bytes = ram_bytes(game.cart_type, game.ram_code);
    if (game.cart_type == 0x22) game.save_bytes = 256;      // MBC7 EEPROM (not kept)

    feed_header(size);
    save_load();
    int copy_save = 0;
    if (cart_write_pending) {
        cart_write_pending = 0;
        if (cart_write_rom() == 0) { game.src = src = 3; copy_save = 1; }
    }
    ctrl_bits(C_DOWNLOAD, 0);
    wait_ms(2);
    ctrl_bits(C_CORE_RST, 0);
    game.loaded = 1;
    if (copy_save && game.battery && game.save_bytes) save_write();    // the SD save goes along

    set.last_src = src;
    set.last_flash = idx;
    if (src == 2) { strncpy(set.last_path, path, sizeof set.last_path - 1); }
    settings_save();
    logf("loaded %s: %u bytes, type %x, save %u\n", game.name, size, game.cart_type, game.save_bytes);
    return 0;
}

static void reset_game(void) {
    if (!game.loaded) return;
    if (game.save_pending) save_write();
    uint32_t paused = ctrl & C_PAUSE;
    ctrl = (ctrl | C_CORE_RST) & ~C_PAUSE;
    ctrl_write();
    wait_ms(10);
    ctrl = (ctrl & ~C_CORE_RST) | paused;
    ctrl_write();
}

// ================================================================ input
static uint32_t held, rep_t;
static uint32_t last_input_ms;

static uint32_t poll_keys(uint32_t timeout) {
    uint32_t cur = REG_IN & 0xFFFF;
    if (cur == held) {
        uint32_t dp = cur & (K_UP | K_DOWN | K_LEFT | K_RIGHT);
        uint32_t t = timeout;
        if (dp) { int32_t d = (int32_t)(rep_t - ms_now()); t = d > 0 ? (uint32_t)d : 1; if (t > timeout) t = timeout; }
        REG_WAIT = t;
        (void)REG_WAIT;
        cur = REG_IN & 0xFFFF;
    }
    uint32_t now = ms_now();
    uint32_t press = cur & ~held;
    uint32_t dp = cur & (K_UP | K_DOWN | K_LEFT | K_RIGHT);
    if (press & dp) rep_t = now + 380;
    else if (dp && (int32_t)(now - rep_t) >= 0) { press |= dp; rep_t = now + 90; }
    if (cur != held) last_input_ms = now;
    held = cur;
    return press;
}

static void wait_release(void) {
    uint32_t end = ms_now() + 3000;
    while ((REG_IN & (K_PAD | K_S1 | K_S2)) && (int32_t)(ms_now() - end) < 0) { REG_WAIT = 50; (void)REG_WAIT; }
    held = REG_IN & 0xFFFF;
}

// ================================================================ sleep
static void do_sleep(void) {
    if (game.save_pending) save_write();
    settings_save();
    uint32_t saved = ctrl;
    ctrl = (ctrl | C_PAUSE | C_HDMI_OFF | C_LCD_OFF) & ~(C_LED | C_OSD);
    ctrl_write();
    flash_sleep();
    logf("sleep\n");
    wait_release();
    for (;;) {
        REG_WAIT = 60000;
        (void)REG_WAIT;
        if (REG_IN & (K_PAD | K_S1 | K_S2 | K_UMENU)) break;
    }
    wait_release();
    ctrl = saved;
    ctrl_write();
    last_input_ms = ms_now();
    logf("wake\n");
}

static const uint16_t sleep_minutes[4] = { 0, 5, 15, 30 };
static uint32_t sleep_after_ms(void) {
    uint32_t m = sleep_minutes[set.sleep_min & 3];
    if (!m && battery()) m = 5;
    return m * 60000u;
}

// ================================================================ menu model
enum {
    P_MAIN, P_LIBRARY, P_BROWSER, P_DISPLAY, P_AUDIO, P_CONTROLS, P_SYSTEM, P_INFO,
    P_CART, P_FILEACT
};
enum {
    I_NONE, I_RESUME, I_LIBRARY, I_SAVE, I_RESET, I_PG_DISPLAY, I_PG_AUDIO, I_PG_CONTROLS,
    I_PG_SYSTEM, I_PG_INFO, I_SLEEP_NOW,
    I_SRC_SD, I_SRC_FLASH, I_FLASH_GAME, I_FILE, I_DIR, I_UP,
    I_OPT, I_DEFAULTS, I_INFO,
    I_SRC_CART, I_PLAY_CART, I_ERASE_CART, I_PLAY_SD, I_WRITE_CART
};

typedef struct {
    uint8_t  id, icon;
    const char *label;
    const char *desc;
    uint8_t *val;                // option
    uint8_t  nopt;
    const char *const *opts;
    char     value[40];          // shown on the right
    int      arg;
} item_t;

#define MAX_ITEMS 520
static item_t items[MAX_ITEMS];
static int nitems;
static int page, cursor, scroll;
static char page_title[48];

static const char *const o_disp[]  = { "Original", "Pixel Grid", "Scanlines" };
static const char *const o_pal[]   = { "Gray", "Green", "Pocket", "Light", "Amber" };
static const char *const o_col[]   = { "Corrected", "Raw" };
static const char *const o_onoff[] = { "On", "Off" };       // value 0 = on (hdmi_off, lcd_off)
static const char *const o_offon[] = { "Off", "On" };
static const char *const o_crop[]  = { "Fit", "Crop" };
static const char *const o_bri[]   = { "25%", "50%", "75%", "100%" };
static const char *const o_vol[]   = { "Mute", "25%", "50%", "75%", "100%" };
static const char *const o_sys[]   = { "Auto", "Game Boy Color", "Game Boy" };
static const char *const o_boot[]  = { "Last Game", "Menu" };
static const char *const o_sleep[] = { "Off", "5 min", "15 min", "30 min" };
static const char *const o_boost[] = { "x1", "x2", "x4", "x8" };
static const char *const o_power[] = { "Normal", "Battery" };

static item_t *add(uint8_t id, uint8_t icon, const char *label, const char *desc) {
    if (nitems >= MAX_ITEMS) return &items[MAX_ITEMS - 1];
    item_t *it = &items[nitems++];
    memset(it, 0, sizeof *it);
    it->id = id; it->icon = icon; it->label = label; it->desc = desc;
    return it;
}
static void add_opt(uint8_t icon, const char *label, const char *desc, uint8_t *v, uint8_t n, const char *const *o) {
    item_t *it = add(I_OPT, icon, label, desc);
    it->val = v; it->nopt = n; it->opts = o;
}
static void add_info(const char *label, const char *fmt, ...) {
    item_t *it = add(I_INFO, 0, label, 0);
    va_list ap;
    va_start(ap, fmt);
    vsfmt(it->value, sizeof it->value, fmt, ap);
    va_end(ap);
}

// ---------------------------------------------------------------- SD browser
static char cur_dir[256] = "/";
static char act_path[260];              // file chosen in the SD browser
static int  br_cursor, br_scroll;
static char name_pool[48 * 1024];
static int  pool_used;

static int is_rom_name(const char *n) {
    const char *dot = strrchr(n, '.');
    if (!dot) return 0;
    return !strcasecmp(dot, ".gb") || !strcasecmp(dot, ".gbc") || !strcasecmp(dot, ".sgb");
}

static int item_less(const item_t *a, const item_t *b) {
    if (a->id != b->id) return a->id == I_DIR;
    return strcasecmp(a->label, b->label) < 0;
}

static void build_browser(void) {
    nitems = 0;
    pool_used = 0;
    if (strcmp(cur_dir, "/")) add(I_UP, G_CHEV_L, "..", "Back to the parent folder");
    DIR d;
    FILINFO fi;
    if (f_opendir(&d, cur_dir) != FR_OK) return;
    int first = nitems;
    while (f_readdir(&d, &fi) == FR_OK && fi.fname[0]) {
        if (fi.fname[0] == '.' || (fi.fattrib & (AM_HID | AM_SYS))) continue;
        int dir = (fi.fattrib & AM_DIR) != 0;
        if (!dir && !is_rom_name(fi.fname)) continue;
        int n = (int)strlen(fi.fname) + 1;
        if (pool_used + n > (int)sizeof name_pool || nitems >= MAX_ITEMS) break;
        char *s = name_pool + pool_used;
        memcpy(s, fi.fname, n);
        pool_used += n;
        item_t *it = add(dir ? I_DIR : I_FILE, dir ? G_FOLDER : G_CART, s, 0);
        if (!dir) {
            if (fi.fsize >= 1024 * 1024) sfmt(it->value, sizeof it->value, "%u.%u MB", fi.fsize >> 20, ((fi.fsize >> 10) & 1023) * 10 / 1024);
            else sfmt(it->value, sizeof it->value, "%u KB", fi.fsize >> 10);
        }
    }
    f_closedir(&d);
    // insertion sort: folders first, then by name
    for (int i = first + 1; i < nitems; i++) {
        item_t t = items[i];
        int j = i - 1;
        while (j >= first && item_less(&t, &items[j])) { items[j + 1] = items[j]; j--; }
        items[j + 1] = t;
    }
}

// ---------------------------------------------------------------- page builders
static void build_page(void) {
    nitems = 0;
    switch (page) {
    case P_MAIN: {
        strcpy(page_title, "Menu");
        if (game.loaded) {
            item_t *it = add(I_RESUME, G_PLAY, "Resume", "Return to the game.");
            strncpy(it->value, game.name, 30);
        }
        add(I_LIBRARY, G_LIBRARY, "Library", "Choose a game from the SD card or the internal flash.");
        if (game.loaded && game.battery && game.save_bytes) {
            item_t *it = add(I_SAVE, G_SAVE, "Save Game", "Write the cartridge save now. Autosave also does this on its own.");
            if (game.save_pending) strcpy(it->value, "Unsaved changes");
            else if (game.saved_once) sfmt(it->value, sizeof it->value, "Saved %us ago", (ms_now() - game.saved_ms) / 1000);
            else strcpy(it->value, game.src == 2 ? "SD card" : "Internal flash");
        }
        if (game.loaded) add(I_RESET, G_RESET, "Reset Game", "Restart the game. The save is written first.");
        add(I_PG_DISPLAY, G_DISPLAY, "Display", "Display mode, palettes, HDMI and LCD.");
        add(I_PG_AUDIO, G_AUDIO, "Audio", "Volume and the buzzer / speaker output.");
        add(I_PG_CONTROLS, G_PAD, "Controls", "Button layout and shortcuts.");
        add(I_PG_SYSTEM, G_GEAR, "System", "Model, saves, start-up, power.");
        add(I_PG_INFO, G_INFO, "Info", "Game, storage and system information.");
        add(I_SLEEP_NOW, G_MOON, "Sleep", "Pause and switch off HDMI and the LCD. Press any button to wake up.");
        break;
    }
    case P_LIBRARY: {
        strcpy(page_title, "Library");
        item_t *it = add(I_SRC_SD, G_SDCARD, "SD Card", ".gb / .gbc files on a FAT32 or exFAT card. Saves go next to the ROM.");
        strcpy(it->value, sd_mounted ? "Ready" : "No card");
        it = add(I_SRC_FLASH, G_FLASH, "Internal Flash", "Games written with make_games.py. Saves stay in the flash.");
        sfmt(it->value, sizeof it->value, "%d games", fl_count);
        it = add(I_SRC_CART, G_CART, "Cartridge", "External W25Q flash: play the game written to it from the SD card.");
        strncpy(it->value, cart_valid ? cart.name : cart_size ? "Empty" : "Not found", 22);
        break;
    }
    case P_CART: {
        strcpy(page_title, "Cartridge");
        if (cart_valid) {
            item_t *it = add(I_PLAY_CART, G_PLAY, "Play", "Load the game from the cartridge. Saves are kept on it.");
            strncpy(it->value, cart.name, 24);
        }
        if (cart_size) {
            add_info("Chip", "%06x, %u MB", cart_id, cart_size >> 20 ? cart_size >> 20 : 1);
            if (cart_valid) {
                add_info("ROM", "%u KB", cart.rom_size >> 10);
                add_info("Room for", "%u KB ROM", cart_rom_max() >> 10);
            } else add_info("Game", "none (write from SD)");
            add(I_ERASE_CART, G_RESET, "Erase Cartridge", "Remove the game and its save from the cartridge flash.");
        } else {
            add_info("Status", "no chip found");
            add_info("Wiring", "CS51 CLK48 DI55 DO49");
            add_info("", "WP, HOLD, VCC to 3V3");
        }
        break;
    }
    case P_FILEACT: {
        item_t *it = add(I_PLAY_SD, G_PLAY, "Play", "Load the game from the SD card. The save is <name>.sav next to it.");
        (void)it;
        it = add(I_WRITE_CART, G_CART, "Write to Cartridge", "Copy the game and its save to the W25Q flash, then play it from there.");
        strncpy(it->value, cart_size ? (cart_valid ? "replaces game" : "empty") : "no chip", 22);
        break;
    }
    case P_BROWSER:
        if (page_title[0] == 'I') {             // internal flash list
            for (int i = 0; i < fl_count; i++) {
                item_t *f = add(I_FLASH_GAME, G_CART, fl_dir[i].name, 0);
                f->arg = i;
                sfmt(f->value, sizeof f->value, "%u KB", fl_dir[i].size >> 10);
                if (game.loaded && game.src == 1 && game.flash_idx == i) strcpy(f->value, "Playing");
            }
        } else build_browser();
        break;
    case P_DISPLAY:
        strcpy(page_title, "Display");
        add_opt(G_DISPLAY, "Display Mode", "How each Game Boy pixel is drawn on HDMI. Pixel Grid imitates the LCD.", &set.disp_mode, 3, o_disp);
        add_opt(G_STAR, "DMG Palette", "Colours for original Game Boy games.", &set.dmg_pal, 5, o_pal);
        add_opt(G_STAR, "GBC Colors", "Corrected imitates the GBC screen. Raw shows the colours as stored.", &set.gbc_raw, 2, o_col);
        add_opt(G_DISPLAY, "HDMI Output", "Off powers down the HDMI clock to save energy. Hold S1 for 1 s to toggle.", &set.hdmi_off, 2, o_onoff);
        add_opt(G_DISPLAY, "SPI LCD", "The 1.44 inch 128x128 screen. Off stops it and its backlight.", &set.lcd_off, 2, o_onoff);
        add_opt(G_DISPLAY, "LCD Scaling", "Fit scales 160x144 to 128x115. Crop shows the centre 1:1.", &set.lcd_crop, 2, o_crop);
        add_opt(G_POWER, "LCD Backlight", "Lower brightness uses less power.", &set.lcd_bri, 4, o_bri);
        add_opt(G_INFO, "Debug Overlay", "FPS, buttons and cartridge info in the HDMI border.", &set.dbg_on, 2, o_offon);
        break;
    case P_AUDIO:
        strcpy(page_title, "Audio");
        add_opt(G_AUDIO, "Volume", "Volume for HDMI audio and the speaker.", &set.volume, 5, o_vol);
        add_opt(G_AUDIO, "Speaker", "Buzzer or small speaker on pins 76 / 75 (sigma-delta audio).", &set.speaker, 2, o_offon);
        add_opt(G_AUDIO, "Speaker Boost", "Extra gain for the speaker. Too high clips loud sounds.", &set.spk_boost, 4, o_boost);
        break;
    case P_CONTROLS:
        strcpy(page_title, "Controls");
        add_opt(G_PAD, "Swap A / B", "Exchange the A and B buttons.", &set.swap_ab, 2, o_offon);
        add_info("Open menu", "SELECT + START, S1");
        add_info("HDMI on / off", "Hold S1");
        add_info("Reset game", "S2");
        add_info("Navigate", "D-pad, A, B");
        break;
    case P_SYSTEM:
        strcpy(page_title, "System");
        add_opt(G_CART, "Model", "Auto follows the cartridge header. Applies when the game is reset.", &set.sys_mode, 3, o_sys);
        add_opt(G_SAVE, "Autosave", "Write the save 2 s after the game changes it, and when the menu opens.", &set.autosave, 2, o_offon);
        add_opt(G_CHECK, "Save Notifications", "Show a short message when the save was written.", &set.toasts, 2, o_offon);
        add_opt(G_PLAY, "Start-up", "Start the last game or open the menu at power-up.", &set.boot_menu, 2, o_boot);
        add_opt(G_MOON, "Sleep Timer", "Sleep after this long without a button press.", &set.sleep_min, 4, o_sleep);
        add_opt(G_POWER, "Power Mode", "Battery: HDMI off, LCD dimmed, no LEDs, sleep after 5 min. Hold S2 to toggle.", &set.power_mode, 2, o_power);
        add_opt(G_POWER, "Activity LEDs", "Board LEDs while loading and in the menu. Off saves a little power.", &set.led_en, 2, o_offon);
        add(I_DEFAULTS, G_RESET, "Reset Settings", "Restore all settings to their defaults.");
        break;
    case P_INFO: {
        strcpy(page_title, "Info");
        uint32_t st = REG_STAT;
        if (st & 4) { game.save_pending = 1; game.dirty_ms = ms_now(); }
        if (game.loaded) {
            add_info("Game", "%s", game.name);
            add_info("Cartridge", "%s%s", mapper_name(game.cart_type), game.battery ? " + battery" : "");
            add_info("ROM", "%u KB", game.rom_bytes >> 10);
            if (game.save_bytes) add_info("Save RAM", "%u KB%s", game.save_bytes >> 10 ? game.save_bytes >> 10 : 1, game.battery ? "" : " (not kept)");
            add_info("Running as", "%s%s", (st & 1) ? "Game Boy Color" : "Game Boy", (st & 2) ? " 2x" : "");
            add_info("Source", "%s", game.src == 2 ? "SD card" : game.src == 3 ? "Cartridge" : "Internal flash");
        } else add_info("Game", "none loaded");
        if (sd_mounted) add_info("SD card", "%u MB", sd_sectors() / 2048);
        else add_info("SD card", "not found");
        add_info("Flash", "%06x, %d games", flash_id(), fl_count);
        if (cart_size) add_info("Cartridge", "%u MB%s%s", cart_size >> 20 ? cart_size >> 20 : 1, cart_valid ? ", " : "", cart_valid ? cart.name : "");
        else add_info("Cartridge", "not connected");
        uint32_t s = ms_now() / 1000;
        add_info("Uptime", "%u:%02u:%02u", s / 3600, (s / 60) % 60, s % 60);
        add_info("Firmware", "Open Pocket GBC " FW_VERSION);
        add_info("Menu CPU", "FemtoRV32 RV32E");
        break;
    }
    }
}

static int selectable(int i) { return items[i].id != I_INFO; }

// ---------------------------------------------------------------- drawing
#define LIST_Y   4
#define LIST_N   14
#define LIST_X   2
#define LIST_W   38

static void draw_menu(void) {
    uint8_t bg = CL_SHADE;
    osd_clear(AT(CL_WHITE, bg));
    // header
    osd_put(2, 1, G_STAR, AT(CL_BLUE, bg));
    int x = osd_text(4, 1, "Open Pocket", AT(CL_WHITE, bg));
    (void)x;
    char path[48];
    if (page == P_BROWSER && page_title[0] != 'I') {
        int n = (int)strlen(cur_dir);
        const char *p = n > 22 ? cur_dir + n - 22 : cur_dir;
        sfmt(path, sizeof path, "SD %s", p);
        osd_rtext(36, 1, path, AT(CL_GREY, bg));
    } else osd_rtext(36, 1, page_title, AT(CL_GREY, bg));
    osd_put(37, 1, G_SDCARD, AT(sd_mounted ? CL_GREEN : CL_LINE, bg));
    osd_put(39, 1, G_DISPLAY, AT(set.hdmi_off ? CL_LINE : CL_GREEN, bg));
    osd_fill(2, 2, 38, G_HLINE, AT(CL_LINE, bg));

    // list
    if (cursor < scroll) scroll = cursor;
    if (cursor >= scroll + LIST_N) scroll = cursor - LIST_N + 1;
    for (int r = 0; r < LIST_N; r++) {
        int i = scroll + r;
        if (i >= nitems) break;
        item_t *it = &items[i];
        int y = LIST_Y + r;
        int sel = (i == cursor) && selectable(i);
        uint8_t fill = CL_WHITE;
        uint8_t tbg = sel ? fill : bg;
        uint8_t fg = sel ? CL_BLACK : CL_WHITE;
        uint8_t dim = sel ? CL_PANEL : CL_GREY;
        if (sel) osd_pill(LIST_X, y, LIST_W, fill, bg);
        int lx = LIST_X + 2;
        if (it->icon) { osd_put(lx, y, it->icon, AT(sel ? CL_BLUE : CL_LIGHT, tbg)); lx += 2; }
        const char *val = it->value;
        char vb[40];
        if (it->id == I_OPT) {
            if (sel) { sfmt(vb, sizeof vb, "%c %s %c", G_CHEV_L, it->opts[*it->val], G_CHEV_R); val = vb; }
            else val = it->opts[*it->val];
        } else if (it->id == I_DIR || (it->id >= I_PG_DISPLAY && it->id <= I_PG_INFO) || it->id == I_LIBRARY ||
                   it->id == I_SRC_SD || it->id == I_SRC_FLASH) {
            if (!val[0] || it->id == I_DIR) { vb[0] = G_CHEV_R; vb[1] = 0; val = vb; }
        }
        int vlen = (int)strlen(val);
        int maxl = LIST_X + LIST_W - 2 - lx - (vlen ? vlen + 2 : 0);
        if (it->id == I_INFO) {
            osd_textn(lx, y, it->label, 13, AT(CL_GREY, tbg));
            osd_textn(LIST_X + 15, y, val, LIST_W - 16, AT(CL_WHITE, tbg));
            continue;
        }
        if (it->id == I_OPT && it->val == &set.volume) {
            // volume as a row of squares
            for (int k = 0; k < 4; k++) osd_put(LIST_X + LIST_W - 2 - vlen - 6 + k, y, k < set.volume ? G_SQ_FULL : G_SQ_EMPTY, AT(sel ? CL_BLUE : CL_LIGHT, tbg));
        }
        osd_textn(lx, y, it->label, maxl, AT(fg, tbg));
        if (vlen) osd_text(LIST_X + LIST_W - 2 - vlen, y, val, AT(it->id == I_RESUME && !sel ? CL_GREY : (sel ? CL_BLACK : dim == CL_GREY ? CL_LIGHT : dim), tbg));
    }
    // scroll bar
    if (nitems > LIST_N) {
        int th = LIST_N * LIST_N / nitems;
        if (th < 1) th = 1;
        int ty = (LIST_N - th) * scroll / (nitems - LIST_N);
        for (int r = 0; r < LIST_N; r++)
            osd_put(LIST_X + LIST_W, LIST_Y + r, (r >= ty && r < ty + th ? G_THUMB : G_TRACK) | EXT,
                    AT(r >= ty && r < ty + th ? CL_LIGHT : CL_LINE, bg));
    }
    if (nitems == 0) osd_text(LIST_X + 2, LIST_Y, page == P_BROWSER ? "No games in this folder" : "Empty", AT(CL_GREY, bg));

    // description
    osd_fill(2, 19, 38, G_HLINE, AT(CL_LINE, bg));
    if (cursor < nitems && items[cursor].desc) {
        const char *d = items[cursor].desc;
        int line = 0;
        while (*d && line < 2) {
            int n = (int)strlen(d), cut = n;
            if (n > 38) { cut = 38; while (cut > 0 && d[cut] != ' ') cut--; if (!cut) cut = 38; }
            osd_textn(2, 20 + line, d, cut, AT(CL_LIGHT, bg));
            d += cut;
            while (*d == ' ') d++;
            line++;
        }
    }
    // footer
    int fx = 2;
    hint(fx, 22, "A", "Select", bg); fx += 11;
    hint(fx, 22, "B", page == P_MAIN ? "Close" : "Back", bg); fx += 10;
    if (page == P_MAIN && game.loaded) hint(fx, 22, "START", "Resume", bg);
    osd_present();

    // SPI LCD: title bar, 10 list rows, value / hint row
    const char *lt = page == P_MAIN ? "Open Pocket" : page == P_BROWSER ? (page_title[0] == 'I' ? "Flash" : "SD Card") : page_title;
    lcd_header(lt);
    int lrows = 10, ls = 0;
    if (cursor >= lrows) ls = cursor - lrows + 1;
    for (int r = 0; r < lrows && ls + r < nitems; r++) {
        item_t *it = &items[ls + r];
        int y = 1 + r, sel = (ls + r == cursor) && selectable(ls + r);
        uint8_t tb = sel ? CL_WHITE : CL_SHADE;
        char b[17];
        if (sel) lcd_pill(y, CL_WHITE, CL_SHADE);
        if (it->id == I_INFO) {
            sfmt(b, 16, "%s", it->value);
            lcd_text(1, y, b, AT(CL_LIGHT, tb));
            continue;
        }
        if (it->icon) lcd_put(1, y, it->icon, AT(sel ? CL_BLUE : CL_GREY, tb));
        sfmt(b, 13, "%s", it->label);
        lcd_text(3, y, b, AT(sel ? CL_BLACK : CL_WHITE, tb));
    }
    if (nitems > lrows) {                       // scroll position on the right edge
        int ty = 1 + (lrows - 1) * ls / (nitems - lrows);
        if (!(cursor - ls == ty - 1)) lcd_put(15, ty, G_THUMB | EXT, AT(CL_LIGHT, CL_SHADE));
    }
    if (cursor < nitems) {
        item_t *it = &items[cursor];
        char b[24];
        uint8_t at = AT(CL_GREY, CL_SHADE);
        if (it->id == I_OPT) { sfmt(b, sizeof b, "%c %s %c", G_CHEV_L, it->opts[*it->val], G_CHEV_R); at = AT(CL_YELLOW, CL_SHADE); }
        else if (it->value[0] && it->id != I_INFO) sfmt(b, sizeof b, "%s", it->value);
        else sfmt(b, sizeof b, "A ok  B back");
        b[16] = 0;
        lcd_text(8 - (int)strlen(b) / 2, 11, b, at);
    }
    lcd_present();
}

// ---------------------------------------------------------------- navigation
static int sel_first(void) { for (int i = 0; i < nitems; i++) if (selectable(i)) return i; return 0; }

static void go(int p, int keep_cursor) {
    page = p;
    build_page();
    if (!keep_cursor) { cursor = sel_first(); scroll = 0; }
    if (cursor >= nitems) cursor = nitems ? nitems - 1 : 0;
}

static int opt_changed(item_t *it) {
    apply_settings();
    return it != 0;
}

// returns 1 when the menu should close
static int activate(item_t *it, int dir) {
    switch (it->id) {
    case I_RESUME: return 1;
    case I_LIBRARY: go(P_LIBRARY, 0); break;
    case I_SAVE: {
        message_screen("Saving", game.name);
        int r = save_write();
        message_screen(r >= 0 ? "Saved" : "Save failed", game.name);
        wait_ms(700);
        go(P_MAIN, 1);
        break;
    }
    case I_RESET: reset_game(); return 1;
    case I_PG_DISPLAY: go(P_DISPLAY, 0); break;
    case I_PG_AUDIO: go(P_AUDIO, 0); break;
    case I_PG_CONTROLS: go(P_CONTROLS, 0); break;
    case I_PG_SYSTEM: go(P_SYSTEM, 0); break;
    case I_PG_INFO: go(P_INFO, 0); break;
    case I_SLEEP_NOW: do_sleep(); osd_invalidate(); go(P_MAIN, 1); break;
    case I_SRC_SD:
        if (!sd_mounted) { message_screen("Reading SD card", ""); sd_mount(); }
        if (!sd_mounted) { message_screen("No SD card", "Insert a FAT32 or exFAT card"); wait_ms(1500); go(P_LIBRARY, 1); break; }
        page_title[0] = 'S';
        strcpy(cur_dir, "/");
        go(P_BROWSER, 0);
        break;
    case I_SRC_FLASH:
        strcpy(page_title, "Internal Flash");
        go(P_BROWSER, 0);
        break;
    case I_DIR: {
        int n = (int)strlen(cur_dir);
        if (n + strlen(it->label) + 2 < sizeof cur_dir) {
            if (cur_dir[n - 1] != '/') strcat(cur_dir, "/");
            strcat(cur_dir, it->label);
        }
        go(P_BROWSER, 0);
        break;
    }
    case I_UP: {
        char *sl = strrchr(cur_dir, '/');
        if (sl == cur_dir) cur_dir[1] = 0; else if (sl) *sl = 0;
        go(P_BROWSER, 0);
        break;
    }
    case I_FILE: {
        int n = (int)strlen(cur_dir);
        sfmt(act_path, sizeof act_path, "%s%s%s", cur_dir, cur_dir[n - 1] == '/' ? "" : "/", it->label);
        strncpy(page_title, it->label, sizeof page_title - 1);
        page_title[sizeof page_title - 1] = 0;
        br_cursor = cursor;
        br_scroll = scroll;
        cart_probe();
        go(P_FILEACT, 0);
        break;
    }
    case I_PLAY_SD:
    case I_WRITE_CART:
        cart_write_pending = (it->id == I_WRITE_CART);
        if (load_game(2, 0, act_path) == 0) return 1;
        cart_write_pending = 0;
        osd_invalidate();
        go(P_FILEACT, 1);
        break;
    case I_SRC_CART:
        message_screen("Reading cartridge", "");
        cart_probe();
        go(P_CART, 0);
        break;
    case I_PLAY_CART:
        if (load_game(3, 0, 0) == 0) return 1;
        osd_invalidate();
        go(P_CART, 1);
        break;
    case I_ERASE_CART:
        message_screen("Erasing cartridge", "");
        flash_select(1);
        flash_init();
        flash_erase_range(0, 4096);
        if (cart_size) flash_erase_range(cart_save_addr(), 4096);
        flash_sleep();
        flash_select(0);
        cart_probe();
        if (game.loaded && game.src == 3) game.battery = 0;    // nowhere to save any more
        go(P_CART, 0);
        break;
    case I_FLASH_GAME:
        if (load_game(1, it->arg, 0) == 0) return 1;
        go(P_BROWSER, 1);
        break;
    case I_OPT:
        if (dir < 0) *it->val = *it->val ? *it->val - 1 : it->nopt - 1;
        else *it->val = (*it->val + 1) % it->nopt;
        opt_changed(it);
        break;
    case I_DEFAULTS: {
        char lp[sizeof set.last_path];
        uint8_t ls = set.last_src, lf = set.last_flash;
        memcpy(lp, set.last_path, sizeof lp);
        set_defaults();
        set.last_src = ls; set.last_flash = lf;
        memcpy(set.last_path, lp, sizeof lp);
        apply_settings();
        message_screen("Settings restored", "");
        wait_ms(700);
        go(P_SYSTEM, 1);
        break;
    }
    }
    return 0;
}

static void back(void) {
    switch (page) {
    case P_BROWSER:
        if (page_title[0] != 'I' && strcmp(cur_dir, "/")) {
            char *sl = strrchr(cur_dir, '/');
            if (sl == cur_dir) cur_dir[1] = 0; else if (sl) *sl = 0;
            go(P_BROWSER, 0);
        } else { go(P_LIBRARY, 0); cursor = page_title[0] == 'I' ? 1 : 0; }
        break;
    case P_LIBRARY: go(P_MAIN, 0); cursor = game.loaded ? 1 : 0; break;
    case P_CART: go(P_LIBRARY, 0); cursor = 2; break;
    case P_FILEACT:
        page_title[0] = 'S';
        go(P_BROWSER, 0);
        cursor = br_cursor < nitems ? br_cursor : 0;
        scroll = br_scroll;
        break;
    default: {
        int from = page;
        go(P_MAIN, 0);
        for (int i = 0; i < nitems; i++)
            if ((from == P_DISPLAY && items[i].id == I_PG_DISPLAY) || (from == P_AUDIO && items[i].id == I_PG_AUDIO) ||
                (from == P_CONTROLS && items[i].id == I_PG_CONTROLS) || (from == P_SYSTEM && items[i].id == I_PG_SYSTEM) ||
                (from == P_INFO && items[i].id == I_PG_INFO)) cursor = i;
    }
    }
}

static void menu_run(void) {
    menu_active = 1;
    if (set.autosave && game.save_pending) save_write();
    ctrl_bits(C_PAUSE | C_OSD | C_DIM, 1);
    osd_invalidate();
    wait_release();
    go(P_MAIN, 0);
    int quit = !game.loaded ? 0 : 0;
    uint32_t refresh = ms_now();
    while (!quit) {
        draw_menu();
        uint32_t k = poll_keys(page == P_INFO || page == P_MAIN ? 1000 : 5000);
        uint32_t now = ms_now();
        if (sleep_after_ms() && (now - last_input_ms) > sleep_after_ms()) { do_sleep(); osd_invalidate(); }
        if (!k) {
            if (now - refresh > 900 && (page == P_INFO || page == P_MAIN)) { build_page(); refresh = now; }
            continue;
        }
        if ((k & (K_START | K_S1 | K_UMENU)) && game.loaded) break;
        if (k & K_S2 || k & K_URESET) { reset_game(); break; }
        if (k & K_UP) {
            int c = cursor;
            do c = c ? c - 1 : nitems - 1; while (!selectable(c) && c != cursor);
            cursor = c;
        }
        if (k & K_DOWN) {
            int c = cursor;
            do c = (c + 1) % (nitems ? nitems : 1); while (!selectable(c) && c != cursor);
            cursor = c;
        }
        if ((k & (K_L)) && nitems) { cursor -= LIST_N; if (cursor < 0) cursor = 0; }
        if ((k & (K_R)) && nitems) { cursor += LIST_N; if (cursor >= nitems) cursor = nitems - 1; }
        if (nitems && cursor < nitems) {
            item_t *it = &items[cursor];
            if ((k & (K_LEFT | K_RIGHT)) && it->id == I_OPT) activate(it, (k & K_LEFT) ? -1 : 1);
            else if (k & (K_A | K_X)) quit = activate(it, 1);
        }
        if (k & (K_B | K_Y)) {
            if (page == P_MAIN) { if (game.loaded) break; }
            else back();
        }
    }
    settings_save();
    draw_menu();
    wait_release();
    menu_active = 0;
    ctrl &= ~(C_OSD | C_DIM | C_PAUSE);
    ctrl_write();
    osd_invalidate();
    last_input_ms = ms_now();
}

// ================================================================ debug overlay
static uint16_t fps_frames;
static uint32_t fps_ms;
static unsigned fps;

static void dbg_line(int line, const char *s) {
    for (int i = 0; i < 42; i++) {
        char c = *s ? *s++ : ' ';
        LCD_TXT[256 + 64 * line + i] = ((uint16_t)AT(CL_WHITE, CL_GAME) << 8) | (uint8_t)c;
    }
}

static void dbg_update(uint32_t st) {
    uint32_t now = ms_now();
    uint16_t fr = st >> 16;
    if (now - fps_ms >= 1000) {
        fps = (uint16_t)(fr - fps_frames) * 1000u / (now - fps_ms);
        fps_frames = fr;
        fps_ms = now;
    }
    char b[48], pad[9];
    uint32_t in = REG_IN;
    const char *pk = "UDLRABsS";
    uint32_t bits[8] = { K_UP, K_DOWN, K_LEFT, K_RIGHT, K_A | K_X, K_B | K_Y, K_SEL, K_START };
    for (int i = 0; i < 8; i++) pad[i] = (in & bits[i]) ? pk[i] : '-';
    pad[8] = 0;
    uint32_t s = now / 1000;
    sfmt(b, sizeof b, "FPS %2u  %s %s  PAD %s  UP %02u:%02u:%02u", fps, (st & 1) ? "GBC" : "DMG",
         (st & 2) ? "2X" : "1X", pad, s / 3600, (s / 60) % 60, s % 60);
    dbg_line(0, b);
    sfmt(b, sizeof b, "%-24s %-8s %uK %s", game.name, mapper_name(game.cart_type), game.rom_bytes >> 10,
         game.save_pending ? "*" : "");
    dbg_line(1, b);
    sfmt(b, sizeof b, "%2ufps   %s", fps, pad);
    dbg_line(2, b);
}

// ================================================================ main
int main(void) {
    logf("\nOpen Pocket GBC firmware " FW_VERSION "\n");
    ctrl = C_CORE_RST;
    ctrl_write();
    flash_init();
    uint32_t id = flash_id();
    uint8_t cap = id & 0xFF;
    logf("flash id %06x\n", id);
    if (cap >= 0x17 && cap < 0x20) {         // 8 MB or more
        set_addr = 0x7FF000;
        flash_saves = 1;
    }
    set_defaults();
    if (set_addr) {
        settings_t t;
        flash_read(set_addr, &t, sizeof t);
        if (t.sum == sum32(&t, sizeof t - 4)) {
            if (t.magic == SET_MAGIC) set = t;
            else if (t.magic == SET_MAGIC_V1) { set = t; set.magic = SET_MAGIC; set.spk_boost = 2; }
        }
        set_stored = set;
    }
    apply_settings();
    flash_dir_read();
    logf("flash games: %d\n", fl_count);
    sd_mount();
    cart_probe();
    lcd_clear(AT(CL_WHITE, CL_SHADE));
    lcd_present();
    osd_invalidate();

    int started = 0;
    logf("start-up: menu %d, last src %d idx %d, power %d\n", set.boot_menu, set.last_src, set.last_flash, set.power_mode);
    if (!set.boot_menu) {
        if (set.last_src == 2 && sd_mounted && set.last_path[0]) started = load_game(2, 0, set.last_path) == 0;
        if (!started && set.last_src == 3 && cart_valid) started = load_game(3, 0, 0) == 0;
        if (!started && set.last_src == 1 && set.last_flash < fl_count) started = load_game(1, set.last_flash, 0) == 0;
        if (!started && fl_count) started = load_game(1, 0, 0) == 0;
    }
    ctrl &= ~(C_OSD | C_DIM);
    ctrl_write();
    if (!started) menu_run();
    flash_sleep();

    uint32_t s1_down = 0, s2_down = 0;
    int s1_long = 0, s2_long = 0;
    uint32_t dbg_ms = 0;
    last_input_ms = ms_now();
    held = REG_IN & 0xFFFF;
    for (;;) {
        REG_WAIT = (held & (K_S1 | K_S2)) ? 50 : battery() ? 500 : 200;
        (void)REG_WAIT;
        uint32_t in = REG_IN & 0xFFFF;
        uint32_t now = ms_now();
        uint32_t press = in & ~held;
        uint32_t rel = held & ~in;
        if (in != held) last_input_ms = now;
        held = in;

        // S1: short press = menu, hold 1 s = HDMI on / off
        if (press & K_S1) { s1_down = now; s1_long = 0; }
        if ((in & K_S1) && !s1_long && now - s1_down >= 1000) {
            s1_long = 1;
            if (battery()) { set.power_mode = 0; set.hdmi_off = 0; }   // back to a picture
            else set.hdmi_off ^= 1;
            apply_settings();
            settings_save();
            toast(set.hdmi_off ? "HDMI off" : "HDMI on", G_DISPLAY, CL_BLUE);
        }
        // S2: short press = reset game, hold 1 s = battery mode on / off
        if (press & K_S2) { s2_down = now; s2_long = 0; }
        if ((in & K_S2) && !s2_long && now - s2_down >= 1000) {
            s2_long = 1;
            set.power_mode ^= 1;
            lcd_dimmed = 0;
            apply_settings();
            settings_save();
            logf("power mode: %s\n", battery() ? "battery" : "normal");
            if (!battery()) toast("Normal power", G_POWER, CL_GREEN);
        }
        int open = ((rel & K_S1) && !s1_long && now - s1_down >= 20) || (press & K_UMENU) ||
                   ((in & K_SEL) && (in & K_START) && (press & (K_SEL | K_START)));
        if (((rel & K_S2) && !s2_long && now - s2_down >= 20) || (press & K_URESET)) reset_game();

        uint32_t st = REG_STAT;
        if (st & 4) { game.save_pending = 1; game.dirty_ms = now; }
        if (open) {
            if (toast_until) { toast_until = 0; ctrl_bits(C_OSD, 0); }
            menu_run();
            continue;
        }
        if (set.autosave && game.save_pending && now - game.dirty_ms > 2000) {
            if (save_write() == 0 && set.toasts) toast("Saved", G_CHECK, CL_GREEN);
        }
        if (toast_until && (int32_t)(now - toast_until) > 0) {
            toast_until = 0;
            if (!menu_active) ctrl_bits(C_OSD, 0);
        }
        if (set.dbg_on && now - dbg_ms >= 250) { dbg_ms = now; dbg_update(st); }
        if (sleep_after_ms() && now - last_input_ms > sleep_after_ms()) do_sleep();
        // battery mode: dim the LCD after 30 s without input, any button brings it back
        int dim = battery() && now - last_input_ms > 30000;
        if (dim != lcd_dimmed) { lcd_dimmed = dim; apply_settings(); }
    }
}
