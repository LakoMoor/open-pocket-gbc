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
#include "gbcart.h"
#include "osd.h"
#include "ff.h"
#include "bmp.h"

#define FW_VERSION      "1.9.2"
#define GAMES_BASE      0x200000u
#define SAVE_BASE       0x600000u       // 15 slots of 0x22000: header sector + up to 128 KB
#define SAVE_SLOT       0x22000u
#define SET_MAGIC       0x3453504Fu     // "OPS4"
#define SET_MAGIC_V3    0x3353504Fu     // "OPS3": settings_v3_t, converted on load
#define SET_MAGIC_V2    0x3253504Fu     // "OPS2": older layout, converted on load
#define CART_MAGIC      0x3143504Fu     // "OPC1"
#define CART_ROM        0x10000u        // ROM offset in the cartridge flash

// ================================================================ settings
typedef struct {
    uint32_t magic;
    uint8_t  disp_mode, dmg_pal, gbc_raw, lcd_crop;
    uint8_t  dbg_on, lcd_bri, volume, swap_ab;
    uint8_t  sys_mode, hdmi_off, lcd_off, led_en;      // led_en: 0 off, 1 status, 2 CPU clock, 3 sound, 4 activity
    uint8_t  autosave, toasts, boot_menu, sleep_min;
    uint8_t  last_src, last_flash, speaker, spk_boost;
    uint8_t  spk_mode, theme, sdram_pd, lcd_slow;      // theme: TH_*
    uint8_t  dim_idx, poll_slow, menu_snd, link_en;    // LCD auto-dim: off / 15 / 30 / 60 s; link_en: 0 off, 1 Game Boy, 2 Bluetooth
    char     last_path[216];
    uint8_t  home_scene, vprinter, rsv2[14];
    uint32_t sum;
} settings_t;

typedef struct {                                       // "OPS3" layout: settings_t without the tail
    uint32_t magic;
    uint8_t  b[28];
    char     last_path[216];
    uint32_t sum;
} settings_v3_t;

typedef struct {                                       // "OPS2" layout
    uint32_t magic;
    uint8_t  b[20];                                    // disp_mode .. spk_boost, same order
    char     last_path[224];
    uint8_t  power_mode, spk_mode, rsv[2];
    uint32_t sum;
} settings_v2_t;

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
    set.theme = 1;          // Ozone
    set.menu_snd = 1;
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

static int lcd_dimmed;                  // LCD auto-dim active (no input for a while)
static uint8_t preset_sel;              // Power > Preset: 0 normal, 1 battery, 2 custom
static int preset_now(void);
static void preset_apply(int battery_preset);

static int hdmi_is_off(void) { return set.hdmi_off || (REG_ID & 8); }   // 8: MINIMAL bitstream

static void apply_settings(void) {
    int minimal = (REG_ID & 8) != 0;   // MINIMAL bitstream: no HDMI, the LCD is the screen (settings kept)
    uint32_t duty = bri_duty[set.lcd_bri & 3];
    if (lcd_dimmed) duty = 1;
    REG_CFG = (set.disp_mode & 3) | ((set.dmg_pal & 7) << 2) | ((set.gbc_raw & 1) << 5) |
              ((set.lcd_crop & 1) << 6) | ((uint32_t)(set.dbg_on & 1) << 7) |
              (duty << 8) | ((uint32_t)(set.volume & 7) << 12) |
              ((uint32_t)(set.swap_ab & 1) << 15) | ((uint32_t)(set.speaker & 1) << 16) |
              ((uint32_t)(set.spk_boost & 3) << 17) | ((uint32_t)(set.spk_mode & 1) << 19);
    ctrl &= ~((3u << C_SYS_SHIFT) | C_HDMI_OFF | C_LCD_OFF | C_LED | (3u << C_LED_SHIFT) | C_SDRAM_PD | C_LCD_SLOW | C_LINK | C_BT | C_PRN_VIRT);
    ctrl |= ((uint32_t)set.sys_mode << C_SYS_SHIFT) | (set.hdmi_off || minimal ? C_HDMI_OFF : 0) |
            (set.lcd_off && !minimal ? C_LCD_OFF : 0) | (set.led_en ? C_LED | (uint32_t)((set.led_en - 1) & 3) << C_LED_SHIFT : 0) |
            (set.sdram_pd ? C_SDRAM_PD : 0) | (set.lcd_slow ? C_LCD_SLOW : 0) | (set.link_en == 1 ? C_LINK : 0) | (set.link_en == 2 ? C_BT : 0) |
            (set.vprinter && !minimal ? C_PRN_VIRT : 0);
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
static int        cart_reader;        // no flash answered, but an original cartridge did (gbcart.c)

static uint32_t cart_save_addr(void) { return cart_size - 0x21000; }
static uint32_t cart_rom_max(void) { return cart_size > 0x41000 ? cart_size - 0x21000 - CART_ROM : 0; }

static void cart_probe(void) {
    flash_select(1);
    flash_init();
    cart_id = flash_id();
    cart_size = flash_size(cart_id);
    cart_valid = 0;
    cart_reader = 0;
    if (cart_size) {
        flash_read(0, &cart, sizeof cart);
        cart.name[47] = 0;
        cart_valid = cart.magic == CART_MAGIC && cart.rom_size >= 0x8000 && cart.rom_size <= cart_rom_max();
        flash_sleep();
    } else {
        // no W25Q: maybe the cartridge reader with an original cartridge in it
        uint8_t h[0x50];
        if (gbcart_probe(h)) {
            cart_reader = 1;
            memset(&cart, 0, sizeof cart);
            cart.rom_size = 0x8000u << h[0x48];
            int n = 0;
            for (int i = 0; i < 16; i++) {
                uint8_t c = h[0x34 + i];
                if (c == 0 || (i >= 11 && (c & 0x80))) break;
                cart.name[n++] = (c >= 32 && c < 127) ? c : ' ';
            }
            while (n && cart.name[n - 1] == ' ') n--;
            if (!n) strcpy(cart.name, "Cartridge");
            cart_valid = cart.rom_size <= ROM_MAX;
        }
    }
    flash_select(0);
    logf("cart: id %06x, %u KB%s, %s\n", cart_id, cart_size >> 10, cart_reader ? " (reader)" : "", cart_valid ? cart.name : "no game");
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

static uint32_t stat_read(void);          // REG_STAT without losing its sticky bits

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
    if (game.src == 3 && cart_reader) {
        gbcart_read_ram(CRAM_BASE, game.save_bytes);
        logf("save read from the cartridge RAM\n");
    } else if (game.src == 2 && sd_mounted) {
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
    if (game.src == 3 && cart_reader) {
        uint32_t n = gbcart_write_ram(CRAM_BASE, game.save_bytes);
        logf("cartridge RAM: %u bytes changed\n", n);
        ok = n ? 0 : 1;
    } else if (game.src == 2 && sd_mounted) {
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
    if (cart_reader) { message_screen("Original cartridge", "it is read-only"); wait_ms(2000); return -1; }
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

// ================================================================ menu sounds
static uint32_t beep_tog;
// half period in 4 us steps, length in ms; the toggle bit makes equal beeps retrigger
static void beep(int hp, int ms) {
    if (!set.menu_snd) return;
    beep_tog ^= 1u << 31;
    REG_BEEP = beep_tog | ((uint32_t)ms << 16) | (uint32_t)hp;
}
static void snd_move(void) { beep(55, 4); }
static void snd_ok(void)   { beep(80, 22); }
static void snd_back(void) { beep(130, 22); }

// ================================================================ extras: recent games, play time, cheats
// One flash sector after the save slots holds the recent games and the Game Genie codes.
#define EXTRA_ADDR   0x7FE000u
#define EXTRA_MAGIC  0x31585045u        // "EPX1"
#define N_RECENT     8
#define N_CHEATGAME  26
#define N_CODES      8
typedef struct { uint8_t src, idx, rsv[2]; uint32_t secs; char name[24]; char path[160]; } recent_t;
typedef struct { uint32_t key; uint8_t on, n, rsv[2]; char code[N_CODES][10]; } cheatset_t;
typedef struct { uint32_t magic; recent_t rec[N_RECENT]; cheatset_t ch[N_CHEATGAME]; uint32_t sum; } extra_t;
static extra_t  ex;
static int      ex_dirty;
static uint32_t play_ms;                // play time of the running game not yet added to its entry

static void extra_load(void) {
    if (set_addr) flash_read(EXTRA_ADDR, &ex, sizeof ex);
    if (!set_addr || ex.magic != EXTRA_MAGIC || ex.sum != sum32(&ex, sizeof ex - 4)) {
        memset(&ex, 0, sizeof ex);
        ex.magic = EXTRA_MAGIC;
    }
}
static void extra_save(void) {
    if (!set_addr || !ex_dirty) return;
    ex.sum = sum32(&ex, sizeof ex - 4);
    flash_write(EXTRA_ADDR, &ex, sizeof ex);
    ex_dirty = 0;
}
static int recent_count(void) {
    int n = 0;
    while (n < N_RECENT && ex.rec[n].src) n++;
    return n;
}
// the running game is entry 0
static void playtime_flush(void) {
    if (play_ms >= 1000 && ex.rec[0].src) {
        ex.rec[0].secs += play_ms / 1000;
        play_ms %= 1000;
        ex_dirty = 1;
    }
}
static int recent_same(const recent_t *r, int src, int idx, const char *path) {
    if (r->src != src) return 0;
    if (src == 2) return !strcmp(r->path, path);
    if (src == 1) return r->idx == idx;
    return 1;
}
static void recent_add(int src, int idx, const char *path, const char *name) {
    if (src == 2 && strlen(path) >= sizeof ex.rec[0].path) return;
    int i = 0;
    while (i < N_RECENT - 1 && ex.rec[i].src && !recent_same(&ex.rec[i], src, idx, path)) i++;
    recent_t e = ex.rec[i];
    if (!recent_same(&e, src, idx, path)) memset(&e, 0, sizeof e);
    memmove(&ex.rec[1], &ex.rec[0], i * sizeof(recent_t));
    e.src = (uint8_t)src;
    e.idx = (uint8_t)idx;
    strncpy(e.name, name, sizeof e.name - 1);
    e.name[sizeof e.name - 1] = 0;
    if (src == 2) strcpy(e.path, path);
    ex.rec[0] = e;
    play_ms = 0;
    ex_dirty = 1;
}
static void fmt_playtime(char *b, int n, uint32_t s) {
    if (s >= 3600) sfmt(b, n, "%uh %02um", s / 3600, s / 60 % 60);
    else if (s >= 60) sfmt(b, n, "%um", s / 60);
    else sfmt(b, n, "%us", s);
}

// ---- Game Genie: ABC-DEF-GHI patches the ROM in SDRAM. AB = data, address = FCDE ^ F000,
// GI = compare value rotated right by 2 and XORed with BA (6-digit codes have no compare).
static uint32_t game_key(void) {
    volatile uint8_t *rom = sdram(ROM_BASE);
    uint32_t h = 0x811C9DC5u;
    for (int i = 0x134; i < 0x150; i++) h = (h ^ rom[i]) * 16777619u;
    return h ? h : 1;
}
static cheatset_t *cheats_for(int create) {
    uint32_t k = game_key();
    for (int i = 0; i < N_CHEATGAME; i++) if (ex.ch[i].key == k) return &ex.ch[i];
    if (!create) return 0;
    int i = 0;
    while (i < N_CHEATGAME && ex.ch[i].key) i++;
    if (i == N_CHEATGAME) {                     // full: drop the oldest
        memmove(&ex.ch[0], &ex.ch[1], (N_CHEATGAME - 1) * sizeof(cheatset_t));
        i = N_CHEATGAME - 1;
    }
    memset(&ex.ch[i], 0, sizeof ex.ch[i]);
    ex.ch[i].key = k;
    ex_dirty = 1;
    return &ex.ch[i];
}
static int hexval(char c) {
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    return -1;
}
// code: 6 or 9 hex digits, no dashes
static int gg_decode(const char *c, uint16_t *addr, uint8_t *val, int *cmp) {
    int d[9], n = 0;
    for (; c[n] && c[n] != ' ' && n < 9; n++) if ((d[n] = hexval(c[n])) < 0) return 0;
    if (n != 6 && n != 9) return 0;
    *val  = (uint8_t)(d[0] << 4 | d[1]);
    *addr = (uint16_t)(((d[5] ^ 0xF) << 12) | (d[2] << 8) | (d[3] << 4) | d[4]);
    if (n == 9) {
        uint8_t x = (uint8_t)(d[6] << 4 | d[8]);
        x = (uint8_t)((x >> 2) | (x << 6));
        *cmp = x ^ 0xBA;
    } else *cmp = -1;
    return 1;
}
static void gg_format(char *b, const char *c) {   // "ABCDEFGHI" -> "ABC-DEF-GHI"
    int n = 0, o = 0;
    for (; c[n] && c[n] != ' ' && n < 9; n++) {
        if (n == 3 || n == 6) b[o++] = '-';
        b[o++] = c[n];
    }
    b[o] = 0;
}

typedef struct { uint32_t a; uint8_t old; } patch_t;
#define MAX_PATCH 512
static patch_t patches[MAX_PATCH];
static int     npatch;

static void cheats_unapply(void) {
    volatile uint8_t *rom = sdram(ROM_BASE);
    while (npatch) { npatch--; rom[patches[npatch].a] = patches[npatch].old; }
}
static int cheats_apply(void) {
    cheats_unapply();
    if (!game.loaded) return 0;
    cheatset_t *cs = cheats_for(0);
    if (!cs) return 0;
    volatile uint8_t *rom = sdram(ROM_BASE);
    for (int i = 0; i < cs->n; i++) {
        if (!(cs->on & (1 << i))) continue;
        uint16_t a; uint8_t v; int cmp;
        if (!gg_decode(cs->code[i], &a, &v, &cmp) || a >= 0x8000) continue;
        uint32_t banks = game.rom_bytes / 0x4000;
        // 0000-3FFF is bank 0; 4000-7FFF can hold any other bank, so patch them all
        for (uint32_t b = (a < 0x4000 ? 0 : 1); b < (a < 0x4000 ? 1 : banks); b++) {
            uint32_t off = a < 0x4000 ? a : b * 0x4000 + (a - 0x4000);
            if (off >= game.rom_bytes) break;
            if (cmp >= 0 && rom[off] != cmp) continue;
            if (npatch >= MAX_PATCH) break;
            patches[npatch].a = off;
            patches[npatch].old = rom[off];
            npatch++;
            rom[off] = v;
        }
    }
    return npatch;
}

// ================================================================ screenshots
static const uint32_t dmg_pals[5][4] = {
    { 0xF8F8F8, 0xA8A8A8, 0x585858, 0x101010 }, { 0x9BBC0F, 0x8BAC0F, 0x306230, 0x0F380F },
    { 0xC4CFA1, 0x8B956D, 0x4D533C, 0x1F1F1F }, { 0x00B581, 0x009A71, 0x00694A, 0x004F3B },
    { 0xFFC060, 0xC88830, 0x784818, 0x301808 },
};
#define FB_BASE  0x700000u
#define TMP_BUF  0x740000u              // free SDRAM between the framebuffers and the firmware
#define TMP_BUF2 0x760000u

static uint32_t pix_rgb(uint16_t p, int gbc) {
    if (!gbc) return dmg_pals[set.dmg_pal % 5][p & 3];
    uint32_t r5 = p & 31, g5 = (p >> 5) & 31, b5 = (p >> 10) & 31;
    if (set.gbc_raw) return (r5 << 19 | (r5 >> 2) << 16) | (g5 << 11 | (g5 >> 2) << 8) | (b5 << 3 | b5 >> 2);
    uint32_t r = (r5 * 26 + g5 * 4 + b5 * 2) >> 2, g = (g5 * 24 + b5 * 8) >> 2, b = (r5 * 6 + g5 * 4 + b5 * 22) >> 2;
    return r << 16 | g << 8 | b;
}

static uint16_t rgb15(uint32_t rgb) {
    return (uint16_t)(((rgb >> 19) & 31) | ((rgb >> 11) & 31) << 5 | ((rgb >> 3) & 31) << 10);
}

// the newest complete frame to /Screenshots/<game>_NNN.bmp; returns 0 when saved
static int screenshot(char *saved_as, int n) {
    if (!sd_mounted) sd_mount();
    if (!sd_mounted || !game.loaded) return -1;
    if (hdmi_is_off()) {                // no framebuffer writes while HDMI is off: run 3 frames with them
        uint32_t keep = ctrl;
        ctrl = (ctrl | C_FB_FORCE) & ~C_PAUSE;
        ctrl_write();
        uint16_t f0 = (uint16_t)(stat_read() >> 16);
        uint32_t t0 = ms_now();
        while ((uint16_t)((stat_read() >> 16) - f0) < 3 && ms_now() - t0 < 300) ;
        ctrl = keep | C_FB_FORCE;
        ctrl_write();
        wait_ms(20);
        ctrl = keep;
        ctrl_write();
    }
    uint32_t st = stat_read();
    int gbc = st & 1, buf = (st >> 3) & 3;
    char nm[28], path[80];
    int k = 0;
    for (const char *s = game.name; *s && k < 24; s++)
        nm[k++] = ((*s >= 'A' && *s <= 'Z') || (*s >= 'a' && *s <= 'z') || (*s >= '0' && *s <= '9') || *s == '-') ? *s : '_';
    nm[k] = 0;
    if (!k) strcpy(nm, "game");
    f_mkdir("/Screenshots");
    int i = 0;
    for (; i < 1000; i++) {
        sfmt(path, sizeof path, "/Screenshots/%s_%03d.bmp", nm, i);
        if (f_stat(path, 0) != FR_OK) break;
    }
    FIL f;
    if (i == 1000 || f_open(&f, path, FA_WRITE | FA_CREATE_NEW) != FR_OK) return -1;
    static uint8_t row[160 * 3];
    static const uint8_t hdr[54] = {
        'B', 'M', 0x36, 0x0E, 0x01, 0, 0, 0, 0, 0, 54, 0, 0, 0, 40, 0, 0, 0,
        160, 0, 0, 0, 144, 0, 0, 0, 1, 0, 24, 0, 0, 0, 0, 0, 0, 0x8C, 0x01, 0,
        0x13, 0x0B, 0, 0, 0x13, 0x0B, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    UINT bw;
    int ok = f_write(&f, hdr, sizeof hdr, &bw) == FR_OK;
    volatile uint32_t *fb = (volatile uint32_t *)sdram(FB_BASE + (uint32_t)buf * 0x10000);
    for (int y = 143; y >= 0 && ok; y--) {
        for (int x = 0; x < 160; x++) {
            uint32_t idx = (uint32_t)y * 160 + x, w = fb[idx >> 1];
            uint32_t c = pix_rgb((idx & 1) ? (w >> 16) & 0x7FFF : w & 0x7FFF, gbc);
            row[x * 3] = c; row[x * 3 + 1] = c >> 8; row[x * 3 + 2] = c >> 16;
        }
        ok = f_write(&f, row, sizeof row, &bw) == FR_OK;
    }
    f_close(&f);
    if (!ok) return -1;
    if (saved_as) strncpy(saved_as, path + 13, n);
    logf("screenshot %s\n", path);
    return 0;
}

// ================================================================ internal flash library
static void flash_dir_write(void) {
    static uint8_t blk[16 + 15 * sizeof(fl_entry_t)];
    memset(blk, 0, sizeof blk);
    memcpy(blk, "GBCP", 4);
    blk[4] = (uint8_t)fl_count;
    memcpy(blk + 16, fl_dir, fl_count * sizeof(fl_entry_t));
    flash_write(GAMES_BASE, blk, sizeof blk);
}

// copies an SD ROM after the last game in the internal flash
static int flash_add_game(const char *path) {
    if (fl_count >= 15) { message_screen("Flash list is full", "15 games at most"); wait_ms(1500); return -1; }
    uint32_t end = 0x1000;
    for (int i = 0; i < fl_count; i++) {
        uint32_t e = (fl_dir[i].ofs + fl_dir[i].size + 0xFFF) & ~0xFFFu;
        if (e > end) end = e;
    }
    FIL f;
    if (!sd_mounted || f_open(&f, path, FA_READ) != FR_OK) { message_screen("Can't open file", ""); wait_ms(1500); return -1; }
    uint32_t size = f_size(&f);
    if (size < 0x8000 || GAMES_BASE + end + size > SAVE_BASE) {
        f_close(&f);
        message_screen(size < 0x8000 ? "File too small" : "Not enough room", "in the internal flash");
        wait_ms(1500);
        return -1;
    }
    const char *b = strrchr(path, '/');
    b = b ? b + 1 : path;
    fl_entry_t e;
    memset(&e, 0, sizeof e);
    int k = 0;
    while (b[k] && b[k] != '.' && k < 23) { e.name[k] = b[k]; k++; }
    e.ofs = end;
    e.size = size;
    for (uint32_t o = 0; o < size; o += 0x10000) {
        progress_screen("Copying to flash", e.name, o, size);
        uint32_t n = size - o < 0x10000 ? size - o : 0x10000;
        UINT br;
        if (f_read(&f, (void *)sdram(TMP_BUF), n, &br) != FR_OK || br != n) {
            f_close(&f);
            message_screen("Read error", e.name);
            wait_ms(1500);
            return -1;
        }
        flash_write_sdram(GAMES_BASE + end + o, TMP_BUF, (n + 0xFFF) & ~0xFFFu);
    }
    f_close(&f);
    progress_screen("Copying to flash", e.name, size, size);
    fl_dir[fl_count++] = e;
    flash_dir_write();
    logf("flash: added %s at %x, %u bytes\n", e.name, e.ofs, size);
    return 0;
}

// removes a game from the list; the save slots of the following games move down with them
static void flash_del_game(int idx) {
    if (idx < 0 || idx >= fl_count) return;
    if (game.loaded && game.src == 1) {
        if (game.flash_idx == idx) game.loaded = 0;
        else if (game.flash_idx > idx) game.flash_idx--;
    }
    if (flash_saves) {
        for (int s = idx; s < fl_count - 1; s++) {
            progress_screen("Moving saves", fl_dir[s + 1].name, s - idx, fl_count - 1 - idx);
            flash_read_sdram(slot_addr(s + 1), TMP_BUF, SAVE_SLOT);
            flash_update_sdram(slot_addr(s), TMP_BUF, SAVE_SLOT);
        }
        flash_erase_range(slot_addr(fl_count - 1), 0x1000);     // the header sector marks it empty
    }
    memmove(&fl_dir[idx], &fl_dir[idx + 1], (fl_count - 1 - idx) * sizeof(fl_entry_t));
    fl_count--;
    flash_dir_write();
    for (int i = 0; i < N_RECENT; i++) {        // recent entries point at flash indices too
        recent_t *r = &ex.rec[i];
        if (r->src != 1) continue;
        if (r->idx == idx) { memmove(r, r + 1, (N_RECENT - 1 - i) * sizeof *r); memset(&ex.rec[N_RECENT - 1], 0, sizeof *r); i--; }
        else if (r->idx > idx) r->idx--;
        ex_dirty = 1;
    }
}

// ================================================================ system update from the SD card
#define UPD_FW    "/opgbc_fw.bin"
#define UPD_FPGA  "/opgbc_fpga.bin"
#define FW_ADDR   0x100000u
#define FPGA_MAX  0x100000u
#define UPD_BUF   0x100000u            // the file while it is installed: in the game ROM area (1 MB), so
                                       // the firmware restarts afterwards (TMP_BUF is only 128 KB)

typedef struct { int present; uint32_t size; char ver[16]; int valid; } updfile_t;
static updfile_t upd_fw, upd_fpga;

// big, calm progress screen for updates: title, file, step list, bar, warning
static void upd_screen(const char *what, const char *file, int step, uint32_t done, uint32_t total) {
    static const char *const steps[3] = { "Reading", "Writing", "Verifying" };
    uint8_t bg = CL_NAVY;
    osd_clear(AT(CL_WHITE, bg));
    osd_put(5, 3, G_FLASH, AT(CL_BLUE, bg));
    osd_text(7, 3, "System Update", AT(CL_WHITE, bg));
    osd_text(7, 5, what, AT(CL_LIGHT, bg));
    osd_textn(7, 6, file, 30, AT(CL_GREY, bg));
    for (int i = 0; i < 3; i++) {
        uint8_t c = i < step ? CL_GB3 : i == step ? CL_WHITE : CL_LINE;
        osd_put(7, 9 + i * 2, i < step ? G_CHECK : i == step ? G_CHEV_R : G_BULLET, AT(c, bg));
        osd_text(9, 9 + i * 2, steps[i], AT(c, bg));
    }
    int w = 30, f = total ? (int)((uint64_t)done * (w - 2) / total) : 0;
    osd_pill(6, 17, w, CL_LINE, bg);
    if (f > 0) { osd_put(6, 17, G_PILL_L | EXT, AT(CL_BLUE, bg)); osd_fill(7, 17, f, ' ', AT(CL_WHITE, CL_BLUE)); }
    if (f >= w - 2) osd_put(6 + w - 1, 17, G_PILL_R | EXT, AT(CL_BLUE, bg));
    char pc[8];
    sfmt(pc, sizeof pc, "%u%%", total ? (unsigned)((uint64_t)done * 100 / total) : 0);
    osd_text(37, 17, pc, AT(CL_WHITE, bg));
    osd_put(6, 20, G_POWER, AT(CL_YELLOW, bg));
    osd_text(8, 20, "Do not switch off", AT(CL_YELLOW, bg));
    osd_present();

    lcd_clear(AT(CL_WHITE, bg));
    lcd_put(0, 0, G_FLASH, AT(CL_BLUE, bg));
    lcd_text(2, 0, "Update", AT(CL_WHITE, bg));
    lcd_textn(0, 2, what, 16, AT(CL_LIGHT, bg));
    for (int i = 0; i < 3; i++) {
        uint8_t c = i < step ? CL_GB3 : i == step ? CL_WHITE : CL_LINE;
        lcd_put(1, 4 + i, i < step ? G_CHECK : i == step ? G_CHEV_R : G_BULLET, AT(c, bg));
        lcd_text(3, 4 + i, steps[i], AT(c, bg));
    }
    int lf = total ? (int)((uint64_t)done * 14 / total) : 0;
    lcd_pillx(1, 8, 14, CL_LINE, bg);
    for (int x = 0; x < lf; x++) lcd_put(1 + x, 8, x == 0 ? (G_PILL_L | EXT) : x == 13 ? (G_PILL_R | EXT) : ' ', x == 0 || x == 13 ? AT(CL_BLUE, bg) : AT(CL_WHITE, CL_BLUE));
    lcd_text(8 - (int)strlen(pc) / 2, 9, pc, AT(CL_WHITE, bg));
    lcd_put(1, 11, G_POWER, AT(CL_YELLOW, bg));
    lcd_text(3, 11, "Keep power", AT(CL_YELLOW, bg));
    lcd_present();
}

// reads a whole update file into SDRAM at UPD_BUF; returns its size or 0
static uint32_t upd_read(const char *path, uint32_t max, const char *what) {
    FIL f;
    if (!sd_mounted || f_open(&f, path, FA_READ) != FR_OK) return 0;
    uint32_t size = f_size(&f);
    if (size == 0 || size > max) { f_close(&f); return 0; }
    for (uint32_t o = 0; o < size; o += 0x8000) {
        upd_screen(what, path + 1, 0, o, size);
        UINT br;
        uint32_t n = size - o < 0x8000 ? size - o : 0x8000;
        if (f_read(&f, (void *)sdram(UPD_BUF + o), n, &br) != FR_OK || br != n) { f_close(&f); return 0; }
    }
    f_close(&f);
    return size;
}

static void upd_probe(void) {
    memset(&upd_fw, 0, sizeof upd_fw);
    memset(&upd_fpga, 0, sizeof upd_fpga);
    if (!sd_mounted) sd_mount();
    if (!sd_mounted) return;
    FILINFO fi;
    if (f_stat(UPD_FW, &fi) == FR_OK) {
        upd_fw.present = 1;
        upd_fw.size = (uint32_t)fi.fsize;
        // fw.bin: u32 length + code; the version follows "GBC firmware " in the code
        FIL f;
        static char buf[512];
        if (f_open(&f, UPD_FW, FA_READ) == FR_OK) {
            UINT br;
            uint32_t len = 0;
            f_read(&f, &len, 4, &br);
            upd_fw.valid = br == 4 && len + 4 == upd_fw.size && len < 0x70000;
            strcpy(upd_fw.ver, "?");
            static const char key[] = "GBC firmware ";
            while (f_read(&f, buf, sizeof buf, &br) == FR_OK && br > 0) {
                for (UINT i = 0; i + sizeof key + 8 < br; i++)
                    if (!memcmp(buf + i, key, sizeof key - 1)) {
                        int k = 0;
                        const char *v = buf + i + sizeof key - 1;
                        while (k < 15 && v[k] > ' ' && v[k] < 127) { upd_fw.ver[k] = v[k]; k++; }
                        upd_fw.ver[k] = 0;
                        goto found;
                    }
                if (br == sizeof buf) f_lseek(&f, f_tell(&f) - 32);   // a key may span two blocks
                else break;
            }
        found:
            f_close(&f);
        }
    }
    if (f_stat(UPD_FPGA, &fi) == FR_OK) {
        upd_fpga.present = 1;
        upd_fpga.size = (uint32_t)fi.fsize;
        upd_fpga.valid = upd_fpga.size >= 0x10000 && upd_fpga.size <= FPGA_MAX;
    }
}

// writes the file to flash and checks it; 0 when the flash holds it
static int upd_flash(int fpga, uint32_t size, const char *file);
static int upd_install(int fpga) {
    const char *path = fpga ? UPD_FPGA : UPD_FW;
    uint32_t size = upd_read(path, fpga ? FPGA_MAX : 0x70004, fpga ? "FPGA bitstream" : "Firmware");
    if (!size) { message_screen("Can't read the file", path + 1); wait_ms(2000); return -1; }
    return upd_flash(fpga, size, path + 1);
}

// the update in SDRAM at UPD_BUF goes to flash and is read back
static int upd_flash(int fpga, uint32_t size, const char *file) {
    const char *what = fpga ? "FPGA bitstream" : "Firmware";
    uint32_t addr = fpga ? 0 : FW_ADDR;
    uint32_t len = (size + 0xFFF) & ~0xFFFu;
    for (uint32_t o = size; o < len; o++) sdram(UPD_BUF)[o] = 0xFF;
    for (uint32_t o = 0; o < len; o += 0x10000) {
        upd_screen(what, file, 1, o, len);
        uint32_t n = len - o < 0x10000 ? len - o : 0x10000;
        flash_write_sdram(addr + o, UPD_BUF + o, n);
    }
    // verify in 32 KB pieces
    int bad = 0;
    for (uint32_t o = 0; o < size && !bad; o += 0x8000) {
        upd_screen(what, file, 2, o, size);
        uint32_t n = size - o < 0x8000 ? size - o : 0x8000;
        flash_read_sdram(addr + o, TMP_BUF2, n);
        volatile uint8_t *a = sdram(UPD_BUF + o), *b = sdram(TMP_BUF2);
        for (uint32_t i = 0; i < n; i++) if (a[i] != b[i]) { bad = 1; break; }
    }
    upd_screen(what, file, bad ? 2 : 3, size, size);
    logf("update %s: %u bytes, %s\n", what, size, bad ? "VERIFY FAILED" : "ok");
    return bad ? -1 : 0;
}

// restarts the menu CPU through the boot ROM, which loads the firmware from flash again
static void reboot_firmware(void) {
    settings_save();
    extra_save();
    ctrl = C_CORE_RST;
    ctrl_write();
    __asm__ volatile("li t0, 0x01000000\n jr t0" ::: "t0", "memory");
}

// ---------------------------------------------------------------- home screen
extern const uint8_t home_rom[], home_rom_end[];
static int home_running;                // the home screen ROM runs in the core (no game loaded)

static void start_home(void) {
    uint32_t n = (uint32_t)(home_rom_end - home_rom);
    ctrl = (ctrl | C_CORE_RST | C_DOWNLOAD) & ~C_PAUSE;
    ctrl_write();
    memset(&game, 0, sizeof game);
    volatile uint8_t *rom = sdram(ROM_BASE);
    for (uint32_t i = 0; i < n; i++) rom[i] = home_rom[i];
    rom[0x150] = set.home_scene < 3 ? set.home_scene : (uint8_t)(ms_now() % 3);   // scene for the ROM
    feed_header(n);
    ctrl_bits(C_DOWNLOAD, 0);
    wait_ms(2);
    ctrl_bits(C_CORE_RST, 0);
    home_running = 1;
    logf("home screen: %u bytes\n", n);
}

static void wait_release(void);
static uint32_t poll_keys(uint32_t timeout);

// ================================================================ Game Boy Printer
// The board is the printer on the link port: the Game Boy clocks the bytes, the RTL shifter
// (REG_PRN) hands each one over and sends the answer that was written two bytes earlier.
// Packets: 88 33 cmd comp lenL lenH data.. sumL sumH, then the printer answers 81 and its
// status in the last two bytes. DATA carries 640 bytes (2 tile rows of 20 tiles, RLE when
// comp = 1); PRINT (palette, margins) prints and empties the buffer.
extern const uint8_t printer_rom[], printer_rom_end[];
#define PRN_DATA   TMP_BUF                // tile data received since the last PRINT
#define PRN_PAGE   TMP_BUF2               // the page: printed parts joined (margins 0)
#define PRN_MAX    0x18000u
#define ROW_BYTES  320u                   // 20 tiles x 16 bytes = 8 lines

static struct {
    int pos, cmd, comp, len, run, lit, printing, polls, packets, pages;
    uint32_t sum, chk, data_len, page_len, last_ms;
    uint8_t pdata[4], pal, page_ready;
} pr;

static void prn_store(uint8_t b) {
    if (pr.data_len < PRN_MAX) sdram(PRN_DATA)[pr.data_len++] = b;
}

static void prn_data_byte(uint8_t b) {
    if (!pr.comp) { prn_store(b); return; }
    if (pr.run) { while (pr.run) { prn_store(b); pr.run--; } return; }   // the repeated byte
    if (pr.lit) { prn_store(b); pr.lit--; return; }
    if (b & 0x80) pr.run = (b & 0x7F) + 2;                              // control byte
    else pr.lit = b + 1;
}

static uint8_t prn_status(void) {
    uint8_t st = 0;
    switch (pr.cmd) {
    case 0x01: pr.data_len = 0; pr.printing = 0; break;                  // INIT
    case 0x04: st = pr.data_len ? 0x08 : 0x00; break;                    // DATA
    case 0x02: {                                                         // PRINT
        uint32_t n = pr.data_len - pr.data_len % ROW_BYTES;
        if (pr.page_len + n > PRN_MAX) n = PRN_MAX - pr.page_len;
        volatile uint8_t *s = sdram(PRN_DATA), *d = sdram(PRN_PAGE + pr.page_len);
        for (uint32_t i = 0; i < n; i++) d[i] = s[i];
        pr.page_len += n;
        pr.data_len = 0;
        pr.pal = pr.pdata[2] ? pr.pdata[2] : 0xE4;
        pr.printing = 1;
        pr.polls = 0;
        if (pr.pdata[1] & 0x0F) pr.page_ready = 1;                       // a margin after: the sheet ends
        st = 0x08;
        break;
    }
    case 0x08: pr.printing = 0; break;                                   // BREAK
    case 0x0F:                                                           // INQUIRY
        if (pr.printing) {
            pr.polls++;
            st = pr.polls <= 6 ? 0x06 : pr.polls <= 8 ? 0x04 : 0x00;
            if (!st) pr.printing = 0;
        } else st = pr.data_len ? 0x08 : 0x00;
        break;
    }
    if ((pr.sum & 0xFFFF) != pr.chk) st |= 0x01;
    return st;
}

// one received byte; returns 1 when a packet is complete
static int prn_byte(uint8_t b) {
    int i = pr.pos++;
    switch (i) {
    case 0: if (b != 0x88) pr.pos = 0; return 0;
    case 1: if (b != 0x33) pr.pos = b == 0x88; return 0;
    case 2: pr.cmd = b; pr.sum = b; return 0;
    case 3: pr.comp = b; pr.sum += b; pr.run = pr.lit = 0; return 0;
    case 4: pr.len = b; pr.sum += b; return 0;
    case 5: pr.len |= b << 8; pr.sum += b; if (pr.len > 0x400) pr.pos = 0; return 0;
    }
    int k = i - 6;
    if (k < pr.len) {
        pr.sum += b;
        if (pr.cmd == 0x04) prn_data_byte(b);
        else if (pr.cmd == 0x02 && k < 4) pr.pdata[k] = b;
        return 0;
    }
    k -= pr.len;
    // the shifter sends what was written two bytes earlier
    if (k == 0) { pr.chk = b; REG_PRN = 0x81; return 0; }               // -> device ID byte
    if (k == 1) { pr.chk |= (uint32_t)b << 8; REG_PRN = prn_status(); return 0; }  // -> status byte
    if (k == 2) { REG_PRN = 0x00; return 0; }                            // -> next packet
    pr.pos = 0;
    pr.packets++;
    return 1;
}

// the page as a BMP in /Prints; shades by the printer palette
static void prn_save_bmp(uint32_t rows) {
    if (!sd_mounted) sd_mount();
    if (!sd_mounted) return;
    static const uint8_t shade[4] = { 0xF4, 0xAA, 0x55, 0x10 };
    char path[40];
    f_mkdir("/Prints");
    int i = 0;
    for (; i < 1000; i++) { sfmt(path, sizeof path, "/Prints/print_%03d.bmp", i); if (f_stat(path, 0) != FR_OK) break; }
    FIL f;
    if (i == 1000 || f_open(&f, path, FA_WRITE | FA_CREATE_NEW) != FR_OK) return;
    uint32_t h = rows * 8, size = 54 + 160 * 3 * h;
    uint8_t hdr[54] = { 'B', 'M' };
    hdr[2] = size; hdr[3] = size >> 8; hdr[4] = size >> 16;
    hdr[10] = 54; hdr[14] = 40; hdr[18] = 160; hdr[22] = h; hdr[23] = h >> 8; hdr[26] = 1; hdr[28] = 24;
    UINT bw;
    f_write(&f, hdr, 54, &bw);
    static uint8_t row[160 * 3];
    volatile uint8_t *t = sdram(PRN_PAGE);
    for (int y = (int)h - 1; y >= 0; y--) {
        for (int x = 0; x < 160; x++) {
            uint32_t o = (uint32_t)(y / 8) * ROW_BYTES + (x / 8) * 16 + (y % 8) * 2;
            int c = ((t[o] >> (7 - x % 8)) & 1) | (((t[o + 1] >> (7 - x % 8)) & 1) << 1);
            uint8_t v = shade[(pr.pal >> (2 * c)) & 3];
            row[x * 3] = row[x * 3 + 1] = row[x * 3 + 2] = v;
        }
        f_write(&f, row, sizeof row, &bw);
    }
    f_close(&f);
    logf("printer: %s, %u lines\n", path, h);
}

// the viewer ROM with the page shows it on HDMI and the LCD
static void prn_show_page(void) {
    uint32_t rows = pr.page_len / ROW_BYTES;
    pr.page_ready = 0;
    if (!rows) return;
    pr.pages++;
    prn_save_bmp(rows);
    uint32_t show = rows > 25 ? 25 : rows;
    uint32_t n = (uint32_t)(printer_rom_end - printer_rom);
    ctrl = (ctrl | C_CORE_RST | C_DOWNLOAD) & ~C_PAUSE;
    ctrl_write();
    volatile uint8_t *rom = sdram(ROM_BASE), *pg = sdram(PRN_PAGE);
    for (uint32_t i = 0; i < n; i++) rom[i] = printer_rom[i];
    for (uint32_t i = 0; i < show * ROW_BYTES; i++) rom[0x4000 + i] = pg[i];
    rom[0x150] = (uint8_t)show;
    rom[0x151] = pr.pal;
    rom[0x152] = 1;
    feed_header(n);
    ctrl_bits(C_DOWNLOAD, 0);
    wait_ms(2);
    ctrl &= ~(C_CORE_RST | C_OSD | C_DIM);      // the picture full screen, the pad to the viewer
    ctrl_write();
    pr.page_len = 0;
}

static void prn_screen(const char *state) {
    uint8_t bg = CL_SHADE;
    char b[48];
    osd_clear(AT(CL_WHITE, bg));
    osd_put(5, 4, G_DISPLAY, AT(CL_WHITE, bg));
    osd_text(7, 4, "Game Boy Printer", AT(CL_WHITE, bg));
    osd_text(7, 6, state, AT(CL_LIGHT, bg));
    sfmt(b, sizeof b, "%d packets, %u KB, %d printed", pr.packets, (pr.data_len + pr.page_len) >> 10, pr.pages);
    osd_text(7, 8, b, AT(CL_GREY, bg));
    osd_text(7, 12, "Link cable from the Game Boy", AT(CL_GREY, bg));
    osd_text(7, 13, "to pins 41 SC, 42 SI, 56 SO", AT(CL_GREY, bg));
    osd_text(7, 14, "(5 V level shifter), then", AT(CL_GREY, bg));
    osd_text(7, 15, "print from the game.", AT(CL_GREY, bg));
    osd_text(7, 17, "Prints go to /Prints on SD.", AT(CL_GREY, bg));
    hint(7, 20, "B", "Exit", bg);
    osd_present();
    lcd_clear(AT(CL_WHITE, bg));
    lcd_put(0, 0, G_DISPLAY, AT(CL_WHITE, bg));
    lcd_text(2, 0, "GB Printer", AT(CL_WHITE, bg));
    lcd_textn(0, 2, state, 16, AT(CL_LIGHT, bg));
    sfmt(b, sizeof b, "%d pkt %d prn", pr.packets, pr.pages);
    lcd_text(0, 4, b, AT(CL_GREY, bg));
    lcd_text(0, 7, "Link: 41 42 56", AT(CL_GREY, bg));
    lcd_text(0, 11, "B exit", AT(CL_GREY, bg));
    lcd_present();
}


// ---- virtual printer: the game prints to the shifter inside the FPGA while it runs
static int prn_last_rows;                 // the last finished page, kept in PRN_PAGE for viewing

static void vprn_reset(void) {
    memset(&pr, 0, sizeof pr);
    REG_PRN = 0x100;                 // flush the byte/bit shifter as well as the software parser
}

// called from the main loop: answer the bytes, finish a page when the game is done printing
static void vprn_poll(uint32_t now) {
    uint32_t v;
    int got = 0;
    while ((v = REG_PRN) & 0x100) {
        // PRINT copies tile data and RLE can expand a single byte into 129 bytes.
        // Hold the virtual Game Boy's serial clock until its reply has been queued.
        int was_paused = (ctrl & C_PAUSE) != 0;
        ctrl_bits(C_PAUSE, 1);
        prn_byte((uint8_t)v);
        ctrl_bits(C_PAUSE, was_paused);
        got = 1;
    }
    if (got) { pr.last_ms = now; return; }
    if (pr.pos && now - pr.last_ms > 1000) pr.pos = pr.run = pr.lit = 0;
    if (now - pr.last_ms < 500) return;               // a transfer is going on
    if (pr.page_ready || (pr.page_len && !pr.printing && now - pr.last_ms > 1500)) {
        uint32_t rows = pr.page_len / ROW_BYTES;
        pr.page_ready = 0;
        if (!rows) return;
        int was_paused = (ctrl & C_PAUSE) != 0;
        ctrl_bits(C_PAUSE, 1);
        prn_save_bmp(rows);
        ctrl_bits(C_PAUSE, was_paused);
        prn_last_rows = (int)rows;
        pr.page_len = 0;
        pr.pages++;
        toast("Printed: Tools > Last Print", G_DISPLAY, CL_GB3);
    }
}

// The last page on HDMI and LCD; preserve the game frame without replacing its ROM.
static void vprn_view(void) {
    if (!(REG_ID & 16)) { message_screen("Update the bitstream", "LCD photos need bitstream 1.9.2+"); wait_ms(1800); return; }
    if (!prn_last_rows) { message_screen("Nothing printed yet", "print from a game first"); wait_ms(1500); osd_invalidate(); return; }
    uint32_t st = stat_read();
    int buf = (st >> 3) & 3;
    uint32_t fb = 0x700000u + (uint32_t)buf * 0x10000, keep = 0x730000u;
    volatile uint32_t *f = (volatile uint32_t *)sdram(fb), *k = (volatile uint32_t *)sdram(keep);
    for (int i = 0; i < 160 * 144 / 2; i++) k[i] = f[i];
    static const uint8_t g5[4] = { 30, 21, 11, 2 };
    int lines = prn_last_rows * 8, scroll = 0, maxs = lines > 144 ? lines - 144 : 0;
    uint32_t saved = ctrl, saved_cfg = REG_CFG;
    REG_CFG = saved_cfg & ~(1u << 6);
    ctrl = (ctrl | C_IMAGE) & ~C_DIM;
    ctrl_write();
    osd_clear(AT(CL_WHITE, CL_GAME));
    osd_present();
    lcd_clear(AT(CL_WHITE, CL_SHADE));
    lcd_text(0, 4, "Last print", AT(CL_WHITE, CL_SHADE));
    lcd_text(0, 6, "on the HDMI", AT(CL_LIGHT, CL_SHADE));
    lcd_text(0, 8, "\x1a\x1b scroll", AT(CL_GREY, CL_SHADE));
    lcd_text(0, 9, "B back", AT(CL_GREY, CL_SHADE));
    lcd_present();
    volatile uint8_t *t = sdram(PRN_PAGE);
    wait_release();
    for (int redraw = 1;;) {
        if (redraw) {
            for (int y = 0; y < 144; y++) {
                int sy = y + scroll;
                for (int x = 0; x < 160; x += 2) {
                    uint32_t w = 0;
                    for (int h = 0; h < 2; h++) {
                        int c = 0;
                        if (sy < lines) {
                            uint32_t o = (uint32_t)(sy / 8) * ROW_BYTES + ((x + h) / 8) * 16 + (sy % 8) * 2;
                            int b = 7 - (x + h) % 8;
                            c = ((t[o] >> b) & 1) | (((t[o + 1] >> b) & 1) << 1);
                        }
                        int sh = (pr.pal >> (2 * c)) & 3;
                        uint32_t px = (uint32_t)(g5[sh] | g5[sh] << 5 | g5[sh] << 10);
                        REG_IMAGE = px | ((x + h == 0 && y == 0) ? 0x8000u : 0);
                        w |= px << (16 * h);
                    }
                    f[(y * 160 + x) >> 1] = w;
                }
            }
            redraw = 0;
        }
        uint32_t kk = poll_keys(1000);
        if (kk & (K_B | K_Y | K_A | K_START)) break;
        if ((kk & K_DOWN) && scroll < maxs) { scroll = scroll + 8 > maxs ? maxs : scroll + 8; redraw = 1; }
        if ((kk & K_UP) && scroll > 0) { scroll = scroll < 8 ? 0 : scroll - 8; redraw = 1; }
    }
    REG_CFG = saved_cfg;
    for (int i = 0; i < 160 * 144 / 2; i++) {
        uint32_t pair = k[i]; f[i] = pair;
        REG_IMAGE = rgb15(pix_rgb(pair & 0x7FFF, st & 1)) | (i == 0 ? 0x8000u : 0);
        REG_IMAGE = rgb15(pix_rgb((pair >> 16) & 0x7FFF, st & 1));
    }
    ctrl = saved;
    ctrl_write();
    osd_invalidate();
    wait_release();
}

// printer mode until B: the running game or home screen makes room for the viewer
static void printer_run(void) {
    if (game.loaded && game.save_pending) save_write();
    playtime_flush();
    extra_save();
    game.loaded = 0;
    home_running = 0;
    memset(&pr, 0, sizeof pr);
    REG_PRN = 0;
    ctrl = (ctrl | C_PRINTER | C_OSD | C_DIM | C_CORE_RST) & ~(C_PAUSE | C_PRN_VIRT);   // core stopped until a page arrives
    ctrl_write();
    osd_invalidate();
    prn_screen("Waiting for a print");
    logf("printer: on\n");
    uint32_t held_k = REG_IN & 0xFFFF, drawn = 0, shown = 0;
    for (;;) {
        REG_WAIT = 40;                                // clears the event: check the shifter after it
        if (!(REG_PRN & 0x100)) (void)REG_WAIT;
        uint32_t v, now = ms_now();
        int got = 0;
        while ((v = REG_PRN) & 0x100) { prn_byte((uint8_t)v); got = 1; }
        if (got) pr.last_ms = now = ms_now();
        uint32_t in = REG_IN & 0xFFFF, press = in & ~held_k;
        held_k = in;
        if (press & (K_B | K_Y | K_S1 | K_UMENU)) break;
        if (press & K_SEL) lcd_dump();               // screenshots (tools/lcd_shot.py)
        int idle = now - pr.last_ms > 60;             // no transfer going on: time for slower work
        if (!idle) continue;
        if (pr.page_ready || (pr.page_len && !pr.printing && now - pr.last_ms > 1500)) {
            prn_screen("Printing");
            prn_show_page();
            shown = 1;
            continue;
        }
        if (!shown && now - drawn > 300) {
            prn_screen(pr.packets ? (pr.printing ? "Printing" : "Receiving") : "Waiting for a print");
            drawn = now;
        }
    }
    ctrl &= ~C_PRINTER;
    ctrl_write();
    REG_PRN = 0;
    logf("printer: off, %d pages\n", pr.pages);
    start_home();
    ctrl |= C_OSD | C_DIM;
    ctrl_write();
    osd_invalidate();
    wait_release();
}

static const char *cart_shown;
static void cart_load_progress(uint32_t done, uint32_t total) { progress_screen("Reading cartridge", cart_shown, done, total); }

// src 1: flash index, src 2: SD path, src 3: cartridge
static int load_game_rom(int src, int idx, const char *path) {
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
        if (cart_reader) {
            cart_shown = shown;
            uint32_t t0 = ms_now();
            int ok = gbcart_read_rom(ROM_BASE, size, cart_load_progress);
            logf("cartridge read: %u KB in %u ms, checksum %s\n", size >> 10, ms_now() - t0, ok ? "ok" : "MISMATCH");
            if (!ok) { message_screen("Cartridge checksum mismatch", "check the reader wiring"); wait_ms(1500); }
        } else {
        flash_select(1);
        for (uint32_t o = 0; o < size; o += 0x10000) {
            progress_screen("Loading cartridge", shown, o, size);
            uint32_t n = size - o < 0x10000 ? size - o : 0x10000;
            flash_read_sdram(CART_ROM + o, ROM_BASE + o, n);
        }
        flash_sleep();
        flash_select(0);
        }
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
    vprn_reset();
    if (copy_save && game.battery && game.save_bytes) save_write();    // the SD save goes along

    set.last_src = src;
    set.last_flash = idx;
    if (src == 2) { strncpy(set.last_path, path, sizeof set.last_path - 1); }
    settings_save();
    logf("loaded %s: %u bytes, type %x, save %u\n", game.name, size, game.cart_type, game.save_bytes);
    return 0;
}

static int load_game(int src, int idx, const char *path) {
    playtime_flush();
    home_running = 0;
    npatch = 0;                         // the ROM in SDRAM is replaced
    int r = load_game_rom(src, idx, path);
    if (r) start_home();                // nothing runs after a failed load: back to the home screen
    else {
        recent_add(src, idx, path, game.name);
        if (cheats_apply()) logf("cheats: %d patches\n", npatch);
    }
    extra_save();
    return r;
}

static void reset_game(void) {
    vprn_reset();
    if (!game.loaded) return;
    if (game.save_pending) save_write();
    uint32_t paused = ctrl & C_PAUSE;
    ctrl = (ctrl | C_CORE_RST) & ~C_PAUSE;
    ctrl_write();
    wait_ms(10);
    ctrl = (ctrl & ~C_CORE_RST) | paused;
    ctrl_write();
}

// ================================================================ screen stream over the USB-UART
// The app sends 'V' (at 115200): the firmware answers "#SCR <baud>", switches the UART (TX and
// the remote's RX) to ~2 Mbaud and streams the picture until 'v' or 2 s without a byte (the app
// sends '.' every half second). Packets: 0x00, type, u16 length, payload; log text goes between them.
// A byte 0x88..0x9F while streaming sets the bit time to (byte - 0x80) clocks (33.75 MHz / 8 =
// 4.2 Mbaud ... / 31): the firmware goes quiet until a byte arrives at the new rate.
//   'P' mode: gbc, gbc_raw, dmg palette (4 x RGB)       'O' OSD: flags (1 shown, 2 dim), 42x24 cells
//   'L' LCD text: flags, 16x12 cells                   'G' a changed row: y, PackBits of 160 x u16
//   'F' end of frame: u16 frame counter
//   'A' (after 'W', bitstream 1.7): audio, 16 kHz mono unsigned 8-bit samples
//   'R' (after 'W' instead of 'V'): 0x00 'R' y, then PackBits over the row's 80 words (pixel
//       pairs) without a length: c < 128: c + 1 literal words, else c - 126 copies of one word
//   'M' (after 'W', bitstream 1.5: rtl/sys/scr_engine.sv encodes the rows): 0x00 'M' y, then 10
//       groups of 8 words: a mask byte (bit n: word n repeats the word before it), the other words
#define UDIV_SLOW (33750000 / 115200)
#define UDIV_FAST 17                   // 1.985 Mbaud
static int      scr_on, scr_buf = -1, scr_mode = -1, scr_osd_flags = -1;
static uint32_t scr_rx_ms, scr_osd_ver, scr_lcd_ver, scr_keep_ctrl;
static uint16_t scr_frame;
static uint32_t scr_hash[144];        // per row, of the frame as last sent
#define SCR_HTAB  0x770000u            // the stream engine's hash table (144 words)
static int      scr_fix, scr_rows;     // scr_rows: 'R' rows (no length) instead of 'G'
static int      scr_aud;               // 'A' packets: 16 kHz mono 8-bit audio (bitstream 1.7)

static inline void scr_put(uint32_t b) { UART_TX = b; }          // the UART takes bits 7:0
static void scr_hdr(char t, uint32_t len) { scr_put(0); scr_put(t); scr_put(len); scr_put(len >> 8); }

// rows: 0 'G' rows ('V'), 1 'R' rows ('W'), 2 'R' rows at 115200 without audio ('Q': web / Bluetooth)
static void scr_start(int rows) {
    int slow = rows == 2;
    logf("#SCR %u\n", slow ? 115200u : 33750000u / UDIV_FAST);
    if (!slow) {
        wait_ms(40);                   // the app reopens the port at the new rate
        REG_UART = UDIV_FAST;
    }
    scr_on = slow ? 1 : 2;             // quiet until a byte arrives at the new rate
    scr_rows = rows != 0;
    // the apps that ask with 'W' understand 'A' packets; with the stream engine (lite bitstream) the
    // CPU waits while a frame is encoded, longer than the 4 ms audio FIFO: no audio there
    scr_aud = rows == 1 && (REG_ID & 4) && !(REG_ID & 2);
    if (scr_aud) REG_AUD = 1;
    scr_rx_ms = ms_now();
    scr_buf = scr_mode = scr_osd_flags = -1;
    scr_osd_ver = scr_lcd_ver = ~0u;
    for (int i = 0; i < 144; i++) scr_hash[i] = 0x5A5A5A5Au;           // every row counts as changed
    volatile uint32_t *ht = (volatile uint32_t *)sdram(SCR_HTAB);
    for (int i = 0; i < 144; i++) ht[i] = 0x5A5A5A5Au;
    scr_keep_ctrl = ctrl & C_FB_FORCE;
}
// 'A': the audio samples waiting in the FIFO (4 ms deep), sent between rows and at every poll
static void scr_audio(void) {
    if (!scr_aud) return;
    uint32_t r = REG_AUD;                  // the read takes the oldest sample
    uint32_t n = (r >> 8) & 127;
    if (!n) return;
    scr_hdr('A', n);
    scr_put(r);
    while (--n) scr_put(REG_AUD);
}

static void scr_stop(void) {
    if (scr_aud) { REG_AUD = 0; scr_aud = 0; }
    wait_ms(5);
    REG_UART = UDIV_SLOW;
    scr_on = 0;
    ctrl = (ctrl & ~C_FB_FORCE) | scr_keep_ctrl;
    ctrl_write();
}

// Rows are compared by a hash (Fletcher-like sums); one row per frame is sent anyway, so a collision
// heals within 144 frames. The CPU runs from SDRAM at about 1 us per access: these loops are
// written for few instructions per word.
__attribute__((optimize("O2", "unroll-loops"))) static uint32_t scr_row_hash(const volatile uint32_t *f) {
    uint32_t a = 0, b = 0;
    for (int i = 0; i < 80; i++) { a += f[i]; b += a; }     // b weighs each word by its position
    return a ^ (b << 13 | b >> 19);
}

// PackBits over whole words (pixel pairs; bit 15 of a pixel is always 0): a run is two or more
// equal words whose pixels match (c = pixels + 126), a literal is up to 64 words (c = pixels - 1).
#define SCR_RUN(f, i, w) (!(((w) ^ ((w) >> 16)) & 0xFFFF) && (i) < 79 && (f)[(i) + 1] == (w))
__attribute__((always_inline)) static inline int scr_enc(const volatile uint32_t *f, const int emit) {
    int i = 0, n = 0;
    while (i < 80) {
        uint32_t w = f[i];
        int j;
        if (SCR_RUN(f, i, w)) {
            j = i + 2;
            while (j < 80 && j - i < 64 && f[j] == w) j++;
            n += 3;
            if (emit) { scr_put(2 * (j - i) + 126); scr_put(w); scr_put(w >> 8); }
        } else {
            j = i + 1;
            while (j < 80 && j - i < 64) { uint32_t v = f[j]; if (SCR_RUN(f, j, v)) break; j++; }
            n += 1 + 4 * (j - i);
            if (emit) {
                scr_put(2 * (j - i) - 1);
                for (int k = i; k < j; k++) { uint32_t v = f[k]; scr_put(v); scr_put(v >> 8); scr_put(v >> 16); scr_put(v >> 24); }
            }
        }
        i = j;
    }
    return n;
}
__attribute__((noinline, optimize("O2"))) static int  scr_enc_len(const volatile uint32_t *f)  { return scr_enc(f, 0); }
__attribute__((noinline, optimize("O2"))) static void scr_enc_send(const volatile uint32_t *f) { scr_enc(f, 1); }

// 'R' rows: PackBits over the 80 words (pixel pairs) of a row, c < 128: c + 1 literal words,
// c >= 128: c - 126 copies of one word. One compare per word and no length pass.
__attribute__((noinline, optimize("O2"))) static void scr_enc_words(const volatile uint32_t *f) {
    int i = 0;
    while (i < 80) {
        uint32_t w = f[i];
        int j = i + 1;
        if (j < 80 && f[j] == w) {
            j++;
            while (j < 80 && f[j] == w) j++;
            scr_put(j - i + 126); scr_put(w); scr_put(w >> 8); scr_put(w >> 16); scr_put(w >> 24);
        } else {
            uint32_t v = f[j < 80 ? j : 79];
            while (j < 80) { uint32_t nv = j < 79 ? f[j + 1] : ~v; if (nv == v) break; v = nv; j++; }
            scr_put(j - i - 1);
            for (int k = i; k < j; k++) { uint32_t x = f[k]; scr_put(x); scr_put(x >> 8); scr_put(x >> 16); scr_put(x >> 24); }
        }
        i = j;
    }
}

static void scr_cells(char t, const uint16_t *c, int n, int flags) {
    scr_hdr(t, 1 + (flags & 1 ? n * 2 : 0));
    scr_put(flags);
    if (flags & 1) for (int i = 0; i < n; i++) { scr_put(c[i]); scr_put(c[i] >> 8); }
}

// ---------------------------------------------------------------- update over the USB-UART
// 'Y' (at 115200): the firmware answers "#UPD <baud>" and switches to ~500 kbaud. The host sends
// "OPUP", the target (0 firmware, 1 bitstream) and the u32 size, then the file in 4 KB blocks,
// each followed by its u16 byte sum. Every step is answered: 'K' accepted, 'R' send that block
// again, 'E' given up. The UART keeps one received byte, so the CPU polls in a tight loop
// (about 20 us per byte at this rate) with the core paused. Then the firmware goes back to
// 115200, writes and verifies the flash like System Update and logs "#UPD ok" or "#UPD fail".
#define UDIV_UPD 67                    // 503.7 kbaud

__attribute__((noinline, optimize("O2"))) static int upd_rx(volatile uint8_t *dst, uint32_t n, uint32_t *sum) {
    uint32_t s = 0, t0 = ms_now(), limit = 400 + n / 16;          // ms; a block takes ~170 ms
    for (uint32_t i = 0; i < n; i++) {
        uint32_t r, spin = 0;
        while (!((r = REG_UART) & 0x800)) if (!(++spin & 255) && ms_now() - t0 > limit) return -1;
        dst[i] = (uint8_t)r;
        s += r & 255;
    }
    *sum = s;
    return 0;
}

static void upd_drain(void) {          // until 30 ms of silence
    uint32_t t = ms_now();
    while (ms_now() - t < 30) if (REG_UART & 0x800) t = ms_now();
}

static void upd_uart(void) {
    logf("#UPD %u\n", 33750000u / UDIV_UPD);
    wait_ms(40);
    uint32_t keep = ctrl;
    ctrl |= C_PAUSE | C_OSD;
    ctrl_write();
    REG_UART = UDIV_UPD;
    uint8_t h[9];
    uint32_t sum, size = 0;
    int fpga = 0, ok = 0, r = -1;
    for (int t = 0; t < 10 && !ok; t++) {               // the host repeats the header until 'K'
        if (upd_rx(h, 9, &sum)) { upd_drain(); continue; }
        fpga = h[4];
        size = h[5] | h[6] << 8 | h[7] << 16 | (uint32_t)h[8] << 24;
        ok = !memcmp(h, "OPUP", 4) && fpga < 2 && size >= 16 && size <= (fpga ? FPGA_MAX : 0x70004);
        if (!ok) { upd_drain(); scr_put('R'); }
    }
    if (!ok) { scr_put('E'); goto out; }
    const char *what = fpga ? "FPGA bitstream" : "Firmware";
    upd_screen(what, "over USB", 0, 0, size);
    scr_put('K');
    for (uint32_t o = 0; o < size; o += 0x1000) {
        uint32_t n = size - o < 0x1000 ? size - o : 0x1000;
        int tries = 0;
        for (;;) {
            uint8_t ck[2];
            uint32_t s2;
            if (!upd_rx(sdram(UPD_BUF + o), n, &sum) && !upd_rx(ck, 2, &s2) && (uint16_t)sum == (ck[0] | ck[1] << 8)) break;
            if (++tries > 8) { upd_drain(); scr_put('E'); goto out; }
            upd_drain();
            scr_put('R');
        }
        if (!(o & 0xFFFF)) upd_screen(what, "over USB", 0, o, size);
        scr_put('K');
    }
    if (!fpga) {                                         // fw.bin: u32 length, then the code
        uint32_t l = 0;
        for (int i = 3; i >= 0; i--) l = l << 8 | sdram(UPD_BUF)[i];
        if (l + 4 != size) { wait_ms(50); REG_UART = UDIV_SLOW; logf("#UPD fail: not a firmware file\n"); goto out; }
    }
    wait_ms(50);                                         // the host is back at 115200
    REG_UART = UDIV_SLOW;
    r = upd_flash(fpga, size, "over USB");
    logf("#UPD %s\n", r ? "fail" : "ok");
    wait_ms(600);
    if (r) message_screen("Verify failed", "send the file again");
    else if (fpga) message_screen("Bitstream installed", "switch the power off and on");
    else message_screen("Firmware installed", "restarting");
    wait_ms(r || fpga ? 3000 : 1200);
    reboot_firmware();
out:
    REG_UART = UDIV_SLOW;
    if (size && ok) { wait_ms(1500); reboot_firmware(); }   // the game ROM area held the file
    ctrl = keep;
    ctrl_write();
    osd_invalidate();
}

static void cfg_uart(void);            // settings over the UART, with the menu code
static uint32_t scr_pend;              // a byte read between rows, handled at the next poll

static void scr_poll(void) {
    uint32_t r = REG_UART;
    if (scr_pend) { if (!(r & 0x800)) r = scr_pend; scr_pend = 0; }
    if (r & 0x800) {
        uint8_t c = (uint8_t)r;
        scr_rx_ms = ms_now();
        // Harmless discovery for web clients; old firmware ignores '?'. Never inject text into a stream.
        if (c == '?' && !scr_on) { logf("#HELLO " FW_VERSION " %08x\n", (unsigned)REG_ID); return; }
        if ((c == 'V' || c == 'W') && !scr_on) { scr_start(c == 'W'); return; }
        if (c == 'Q' && !scr_on) { scr_start(2); return; }
        if (c == 'Y' && !scr_on) { upd_uart(); return; }
        if (c == 'Z' && !scr_on) { cfg_uart(); return; }
        else if (c == 'v' && scr_on) { scr_stop(); return; }
        else if (scr_on && c >= 0x88 && c < 0xA0) {   // 0x80 + divider: go quiet, then switch the rate
            wait_ms(2);                                   // the host resumes with a byte at the new rate
            REG_UART = c - 0x80u;
            scr_on = 2;
            return;
        }
        else if (scr_on == 2) scr_on = 1;
    }
    if (!scr_on) return;
    if (ms_now() - scr_rx_ms > 2000) { scr_stop(); return; }
    if (scr_on == 2) return;
    scr_audio();
    if (hdmi_is_off() && !(ctrl & C_FB_FORCE)) { ctrl |= C_FB_FORCE; ctrl_write(); }   // keep the frames coming
    uint32_t st = stat_read();
    int gbc = st & 1, buf = (st >> 3) & 3;
    uint16_t fr = (uint16_t)(st >> 16);
    int raw = set.gbc_raw;
    if (ctrl & C_IMAGE) { gbc = 1; raw = 1; }
    int mode = gbc | (raw ? 2 : 0) | (set.dmg_pal << 2);
    if (mode != scr_mode) {
        scr_mode = mode;
        scr_hdr('P', 14);
        scr_put(gbc); scr_put(raw);
        for (int i = 0; i < 4; i++) { uint32_t v = dmg_pals[set.dmg_pal % 5][i]; scr_put(v >> 16); scr_put(v >> 8); scr_put(v); }
    }
    int of = ((ctrl & C_OSD) ? 1 : 0) | ((ctrl & C_DIM) ? 2 : 0);
    if (of != scr_osd_flags || ((of & 1) && osd_version != scr_osd_ver)) {
        scr_osd_flags = of; scr_osd_ver = osd_version;
        scr_cells('O', osd_cells(), OSD_W * OSD_H, of);
    }
    if (lcd_version != scr_lcd_ver) {
        scr_lcd_ver = lcd_version;
        scr_cells('L', lcd_cells(), LCD_W * LCD_H, of | 1);
    }
    if (buf == scr_buf && fr == scr_frame) return;
    scr_buf = buf; scr_frame = fr;
    const volatile uint32_t *fb = (const volatile uint32_t *)sdram(FB_BASE + (uint32_t)buf * 0x10000);
    scr_fix = scr_fix < 143 ? scr_fix + 1 : 0;
    if (scr_rows && (REG_ID & 2)) {                    // the bitstream encodes the rows itself
        REG_SE_HTAB = SCR_HTAB >> 2;
        REG_SE = (uint32_t)scr_fix << 24 | (FB_BASE + (uint32_t)buf * 0x10000) >> 2;
        (void)REG_SE;
    } else
    for (int y = 0; y < 144; y++) {
        const volatile uint32_t *f = fb + y * 80;
        scr_audio();
        uint32_t h = scr_row_hash(f);
        if (h == scr_hash[y] && y != scr_fix) continue;
        uint32_t r = REG_UART;                 // stop at once: the BL616 can hang on data nobody reads
        if (r & 0x800) { scr_rx_ms = ms_now(); if ((uint8_t)r == 'v') { scr_stop(); return; } scr_pend = r; }
        scr_hash[y] = h;
        if (scr_rows) { scr_put(0); scr_put('R'); }
        else { scr_hdr('G', 1 + scr_enc_len(f)); }
        scr_put(y);
        if (scr_rows) scr_enc_words(f); else scr_enc_send(f);
    }
    scr_hdr('F', 2);
    scr_put(fr); scr_put(fr >> 8);
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
        scr_poll();
        if (scr_on && t > (scr_aud ? 2u : 8u)) t = scr_aud ? 2 : 8;   // the audio FIFO holds 4 ms
        else if (t > 250) t = 250;             // a stream request ('V') is only seen when polled
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
        REG_DEEPWAIT = 60000;               // SDRAM in self refresh while waiting
        (void)REG_DEEPWAIT;
        if (REG_IN & (K_PAD | K_S1 | K_S2 | K_UMENU)) break;
    }
    wait_release();
    ctrl = saved;
    ctrl_write();
    last_input_ms = ms_now();
    logf("wake\n");
}

static const uint16_t sleep_minutes[4] = { 0, 5, 15, 30 };
static uint32_t sleep_after_ms(void) { return sleep_minutes[set.sleep_min & 3] * 60000u; }
static const uint8_t dim_seconds[4] = { 0, 15, 30, 60 };


// ================================================================ status icons: battery, USB power, PC remote
// The carrier board has an IP5306-I2C (address 0x75) on pins 15 (SCL) and 16 (SDA) and a
// VBUS divider on pin 86. On the bare Tang Nano nothing answers: no battery icon.
static int bat_level = -1;                // 0..3, -1: no gauge
static int bat_charging, usb_power;
static uint32_t bat_ms, remote_ms;

// REG_STAT clears its sticky bits when read: every read goes through here so none is lost
static uint32_t stat_read(void) {
    uint32_t st = REG_STAT, now = ms_now();
    if (st & 4) { game.save_pending = 1; game.dirty_ms = now; }
    if (st & 0x20) remote_ms = now ? now : 1;
    return st;
}

static void i2c_set(int scl, int sda) {   // 1 = released (pulled up), 0 = driven low
    REG_GPIO = 4 | (scl ? 0 : 1) | (sda ? 0 : 2);
    for (volatile int i = 0; i < 40; i++) ;
}
static int i2c_sda(void) { return (REG_GPIO >> 1) & 1; }
static void i2c_start(void) { i2c_set(1, 1); i2c_set(1, 0); i2c_set(0, 0); }
static void i2c_stop(void) { i2c_set(0, 0); i2c_set(1, 0); i2c_set(1, 1); }
static int i2c_wr(uint8_t b) {             // 1 = ACK
    for (int i = 7; i >= 0; i--) { int v = (b >> i) & 1; i2c_set(0, v); i2c_set(1, v); i2c_set(0, v); }
    i2c_set(0, 1); i2c_set(1, 1);
    int ack = !i2c_sda();
    i2c_set(0, 1);
    return ack;
}
static uint8_t i2c_rd(int ack) {
    uint8_t b = 0;
    for (int i = 0; i < 8; i++) { i2c_set(0, 1); i2c_set(1, 1); b = (uint8_t)(b << 1 | i2c_sda()); }
    i2c_set(0, !ack); i2c_set(1, !ack); i2c_set(0, 1);
    return b;
}
static int ip5306_read(uint8_t reg) {     // -1 when nothing answers
    // a real bus idles high through its pull-ups; the bare board's LED pins may float low and
    // would read as an ACK
    i2c_set(1, 1);
    if ((REG_GPIO & 3) != 3) return -1;
    i2c_start();
    if (!i2c_wr(0x75 << 1)) { i2c_stop(); return -1; }
    i2c_wr(reg);
    i2c_start();
    if (!i2c_wr(0x75 << 1 | 1)) { i2c_stop(); return -1; }
    int v = i2c_rd(0);
    i2c_stop();
    return v;
}

// every 5 s: battery level and charging from the IP5306, USB power from pin 86
static void status_poll(void) {
    uint32_t now = ms_now();
    stat_read();
    if (bat_ms && now - bat_ms < 5000) return;
    bat_ms = now ? now : 1;
    usb_power = (REG_GPIO >> 2) & 1;
    int lv = ip5306_read(0x78);
    REG_GPIO = 0;                              // the pins go back to the board LEDs
    if (lv < 0) { bat_level = -1; return; }
    switch (lv & 0xF0) {
    case 0x00: bat_level = 3; break;
    case 0x80: bat_level = 2; break;
    case 0xC0: bat_level = 1; break;
    default:   bat_level = 0; break;
    }
    int c = ip5306_read(0x70);
    REG_GPIO = 0;
    bat_charging = c >= 0 && (c & 0x08);
}

// the icons, left to right: PC remote, USB power, battery
static int status_glyphs(uint8_t *g) {
    int n = 0;
    if (remote_ms && ms_now() - remote_ms < 15000) g[n++] = G_PC;
    if (usb_power || bat_charging) g[n++] = G_PLUG;
    if (bat_level >= 0) g[n++] = (uint8_t)(G_BAT0 + bat_level);
    return n;
}

// ================================================================ menu model
enum {
    P_MAIN, P_LIBRARY, P_BROWSER, P_DISPLAY, P_AUDIO, P_CONTROLS, P_SYSTEM, P_INFO,
    P_CART, P_FILEACT, P_GAME, P_POWER, P_SLEEP, P_CHOICE,
    P_RECENT, P_CHEATS, P_CHEATACT, P_CODE, P_FLACT, P_UPDATE, P_UPDCONFIRM, P_TOOLS, P_GALLERY
};
enum {
    I_NONE, I_RESUME, I_LIBRARY, I_SAVE, I_RESET, I_PG_DISPLAY, I_PG_AUDIO, I_PG_CONTROLS,
    I_PG_SYSTEM, I_PG_INFO, I_SLEEP_NOW,
    I_SRC_SD, I_SRC_FLASH, I_FLASH_GAME, I_FILE, I_DIR, I_UP,
    I_OPT, I_DEFAULTS, I_INFO,
    I_SRC_CART, I_PLAY_CART, I_ERASE_CART, I_PLAY_SD, I_WRITE_CART, I_PG_POWER, I_CHOICE,
    I_PG_RECENT, I_RECENT, I_SHOT, I_PG_CHEATS, I_CHEAT, I_CHEAT_ADD, I_CHEAT_TOGGLE, I_CHEAT_EDIT,
    I_CHEAT_DEL, I_COPY_FLASH, I_FL_PLAY, I_FL_DEL, I_PG_UPDATE, I_UPD_FW, I_UPD_FPGA, I_UPD_GO,
    I_PG_TOOLS, I_PRINTER, I_LASTPRINT, I_GALLERY, I_GDIR, I_GPHOTO, I_GUP
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
static const char *const o_preset[] = { "Normal", "Battery", "Custom" };
static const char *const o_theme[] = { "Pocket", "Ozone (Switch)", "XMB (PS3)", "Game Boy", "iPod", "BIOS", "Terminal", "Analogue OS" };
static const char *const o_fps[]   = { "60 fps", "30 fps" };
static const char *const o_dim[]   = { "Off", "15 s", "30 s", "60 s" };
static const char *const o_poll[]  = { "200 ms", "500 ms" };
static const char *const o_spkmode[] = { "PWM 66 kHz", "Sigma-delta" };
static const char *const o_link[]  = { "Off", "Game Boy", "Bluetooth" };
static const char *const o_leds[]  = { "Off", "Status", "CPU Clock", "Sound", "Activity" };
static const char *const o_scene[] = { "Synthwave", "Space", "City", "Random" };
static uint8_t ff_on;                   // fast forward toggled in the menu
static int ch_sel, fl_sel, upd_sel;     // selected cheat, flash game, update file
static uint8_t ed_dig[9];               // code editor: 0..15, 16 = blank
static int ed_pos, ed_slot;             // cursor, cheat slot (-1: new code)
static char shot_msg[40];

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
#include "gallery.inc"
// choices of one setting as their own page (Analogue OS theme)
static item_t ch_item;                  // copy of the setting's item
static int    ch_ret_page, ch_ret_cursor;
static char   ch_parent[48];

// game items shared by the main page and the Game page
static void add_game_extras(void) {
    add_opt(G_PLAY, "Fast Forward", "Double speed while on. Holding R on a DualShock does the same.", &ff_on, 2, o_offon);
    item_t *it = add(I_SHOT, G_DISPLAY, "Screenshot", "Save the picture as a BMP in /Screenshots on the SD card.");
    if (shot_msg[0]) strncpy(it->value, shot_msg, sizeof it->value - 1);
    it = add(I_PG_CHEATS, G_STAR, "Cheats", "Game Genie codes for this game.");
    cheatset_t *cs = cheats_for(0);
    if (cs && cs->n) {
        int on = 0;
        for (int i = 0; i < cs->n; i++) on += (cs->on >> i) & 1;
        sfmt(it->value, sizeof it->value, "%d on", on);
    }
}

static void build_page(void) {
    nitems = 0;
    switch (page) {
    case P_CHOICE:
        strncpy(page_title, ch_item.label, sizeof page_title - 1);
        for (int i = 0; i < ch_item.nopt; i++) add(I_CHOICE, 0, ch_item.opts[i], ch_item.desc)->arg = i;
        break;
    case P_MAIN: {
        strcpy(page_title, "Menu");
        if (game.loaded) {
            item_t *it = add(I_RESUME, G_PLAY, "Resume", "Return to the game.");
            strncpy(it->value, game.name, 30);
        }
        add(I_LIBRARY, G_LIBRARY, "Library", "Choose a game from the SD card or the internal flash.");
        if (recent_count()) {
            item_t *r = add(I_PG_RECENT, G_PLAY, "Recent", "The last games you played, with the time spent in each.");
            sfmt(r->value, sizeof r->value, "%d", recent_count());
        }
        if (game.loaded && game.battery && game.save_bytes) {
            item_t *it = add(I_SAVE, G_SAVE, "Save Game", "Write the cartridge save now. Autosave also does this on its own.");
            if (game.save_pending) strcpy(it->value, "Unsaved changes");
            else if (game.saved_once) sfmt(it->value, sizeof it->value, "Saved %us ago", (ms_now() - game.saved_ms) / 1000);
            else strcpy(it->value, game.src == 2 ? "SD card" : "Internal flash");
        }
        if (game.loaded) add(I_RESET, G_RESET, "Reset Game", "Restart the game. The save is written first.");
        if (game.loaded) add_game_extras();
        add(I_PG_DISPLAY, G_DISPLAY, "Display", "Display mode, palettes, HDMI and LCD.");
        add(I_PG_AUDIO, G_AUDIO, "Audio", "Volume and the buzzer / speaker output.");
        add(I_PG_CONTROLS, G_PAD, "Controls", "Button layout and shortcuts.");
        add(I_PG_SYSTEM, G_GEAR, "System", "Theme, model, saves, start-up.");
        add(I_PG_POWER, G_POWER, "Power", "Battery preset and every power saving setting.");
        add(I_PG_TOOLS, G_GEAR, "Tools", "Game Boy Printer and other tools.");
        add(I_PG_INFO, G_INFO, "Info", "Game, storage and system information.");
        add(I_SLEEP_NOW, G_MOON, "Sleep", "Pause and switch off HDMI and the LCD. Press any button to wake up.");
        break;
    }
    case P_GAME: {
        strcpy(page_title, game.name);
        item_t *it = add(I_RESUME, G_PLAY, "Resume", "Return to the game.");
        (void)it;
        if (game.battery && game.save_bytes) {
            it = add(I_SAVE, G_SAVE, "Save Game", "Write the cartridge save now. Autosave also does this on its own.");
            if (game.save_pending) strcpy(it->value, "Unsaved");
            else if (game.saved_once) sfmt(it->value, sizeof it->value, "%us ago", (ms_now() - game.saved_ms) / 1000);
        }
        add(I_RESET, G_RESET, "Reset Game", "Restart the game. The save is written first.");
        add_game_extras();
        break;
    }
    case P_RECENT:
        strcpy(page_title, "Recent");
        for (int i = 0; i < recent_count(); i++) {
            recent_t *r = &ex.rec[i];
            item_t *it = add(I_RECENT, r->src == 2 ? G_SDCARD : r->src == 3 ? G_CART : G_FLASH, r->name,
                             r->src == 2 ? "From the SD card." : r->src == 3 ? "From the cartridge." : "From the internal flash.");
            it->arg = i;
            uint32_t secs = r->secs + (i == 0 && game.loaded ? play_ms / 1000 : 0);
            fmt_playtime(it->value, sizeof it->value, secs);
        }
        break;
    case P_CHEATS: {
        strcpy(page_title, "Cheats");
        cheatset_t *cs = cheats_for(0);
        for (int i = 0; cs && i < cs->n; i++) {
            item_t *it = add(I_CHEAT, G_STAR, "", "Game Genie code. A: switch on or off, edit, delete.");
            gg_format(it->value + 20, cs->code[i]);            // label text lives in the value buffer tail
            it->label = it->value + 20;
            it->arg = i;
            strcpy(it->value, (cs->on >> i) & 1 ? "On" : "Off");
        }
        if (!cs || cs->n < N_CODES) add(I_CHEAT_ADD, G_CHEV_R, "Add Code", "Enter a 6 or 9 digit Game Genie code (ABC-DEF or ABC-DEF-GHI).");
        add_info("Active patches", "%d", npatch);
        break;
    }
    case P_CHEATACT: {
        cheatset_t *cs = cheats_for(0);
        char b[16];
        gg_format(b, cs ? cs->code[ch_sel] : "");
        strncpy(page_title, b, sizeof page_title - 1);
        item_t *it = add(I_CHEAT_TOGGLE, G_CHECK, "Enabled", "Patch the ROM with this code.");
        strcpy(it->value, cs && ((cs->on >> ch_sel) & 1) ? "On" : "Off");
        add(I_CHEAT_EDIT, G_GEAR, "Edit Code", "Change the digits.");
        add(I_CHEAT_DEL, G_RESET, "Delete Code", "Remove the code from this game.");
        break;
    }
    case P_GALLERY:
        strcpy(page_title, "Photo Gallery"); build_gallery(); break;
    case P_CODE:
        strcpy(page_title, "Game Genie Code");
        break;
    case P_TOOLS: {
        strcpy(page_title, "Tools");
        add(I_GALLERY, G_DISPLAY, "Screenshots", "Browse screenshots on SD. HDMI and LCD.")->arg = 0;
        add(I_GALLERY, G_DISPLAY, "Print Album", "Browse saved Game Boy Printer pages on SD.")->arg = 1;
        add(I_GALLERY, G_FOLDER, "Photos on SD", "Browse folders for 24 / 32-bit RGB BMP photos.")->arg = 2;
        if (REG_ID & 8) { add_info("Printer unavailable", "Install the Full bitstream to use a Game Boy Printer."); break; }
        item_t *it = add(I_PRINTER, G_DISPLAY, "Game Boy Printer", "Be a printer for a real Game Boy on the link port. The running game is closed first.");
        strcpy(it->value, "link port");
        add_info("Link pins", "41 SC  42 SI  56 SO");
        add_opt(G_DISPLAY, "Virtual Printer", "Games print to a Game Boy Printer inside the FPGA. Pages go to /Prints on the SD card.", &set.vprinter, 2, o_offon);
        it = add(I_LASTPRINT, G_DISPLAY, "Last Print", "Show the last page on the HDMI screen.");
        if (prn_last_rows) sfmt(it->value, sizeof it->value, "%d lines", prn_last_rows * 8);
        else strcpy(it->value, "none");
        break;
    }
    case P_FLACT:
        strncpy(page_title, fl_dir[fl_sel].name, sizeof page_title - 1);
        add(I_FL_PLAY, G_PLAY, "Play", "Load the game from the internal flash.");
        add(I_FL_DEL, G_RESET, "Delete from Flash", "Remove the game; its save goes with it.");
        add_info("Size", "%u KB", fl_dir[fl_sel].size >> 10);
        break;
    case P_UPDATE: {
        strcpy(page_title, "System Update");
        add_info("Installed", "firmware " FW_VERSION);
        item_t *it = add(I_UPD_FW, G_FLASH, "Install Firmware", "opgbc_fw.bin in the SD root: the menu firmware.");
        if (!upd_fw.present) strcpy(it->value, "not on SD");
        else if (!upd_fw.valid) strcpy(it->value, "invalid");
        else sfmt(it->value, sizeof it->value, "v%s", upd_fw.ver);
        it = add(I_UPD_FPGA, G_FLASH, "Install Bitstream", "opgbc_fpga.bin in the SD root: the FPGA design (tools/make_update.py).");
        if (!upd_fpga.present) strcpy(it->value, "not on SD");
        else if (!upd_fpga.valid) strcpy(it->value, "invalid");
        else sfmt(it->value, sizeof it->value, "%u KB", upd_fpga.size >> 10);
        add_info("SD files", "opgbc_fw.bin");
        add_info("", "opgbc_fpga.bin");
        break;
    }
    case P_UPDCONFIRM: {
        updfile_t *u = upd_sel ? &upd_fpga : &upd_fw;
        strcpy(page_title, upd_sel ? "FPGA Bitstream" : "Firmware");
        if (upd_sel) add_info("File", "opgbc_fpga.bin, %u KB", u->size >> 10);
        else add_info("File", "opgbc_fw.bin, v%s", u->ver);
        add(I_UPD_GO, G_CHECK, "Install Now", upd_sel ? "Writes the bitstream to flash. Power off and on afterwards." :
                                                       "Writes the firmware to flash and restarts the menu.");
        add_info("Takes", upd_sel ? "about 30 s" : "about 5 s");
        add_info("Keep", "the power on");
        break;
    }
    case P_SLEEP:
        strcpy(page_title, "Sleep");
        add(I_SLEEP_NOW, G_MOON, "Sleep Now", "Pause, switch off HDMI and the LCD, SDRAM in self refresh. Any button wakes up.");
        break;
    case P_POWER:
        strcpy(page_title, "Power");
        preset_sel = preset_now();
        add_opt(G_POWER, "Preset", "Normal or Battery sets everything below. Hold S2 to switch.", &preset_sel, 3, o_preset);
        add_opt(G_DISPLAY, "HDMI Output", "Off: PLL powered down, outputs tri-stated, no framebuffer traffic.", &set.hdmi_off, 2, o_onoff);
        add_opt(G_FLASH, "SDRAM Power-Down", "SDRAM sleeps between accesses (2 cycles more latency).", &set.sdram_pd, 2, o_offon);
        add_opt(G_DISPLAY, "LCD Frame Rate", "30 fps halves the SPI traffic to the LCD.", &set.lcd_slow, 2, o_fps);
        add_opt(G_POWER, "LCD Backlight", "The backlight is the largest consumer on the LCD.", &set.lcd_bri, 4, o_bri);
        add_opt(G_MOON, "LCD Auto-Dim", "Backlight almost off after this long without input.", &set.dim_idx, 4, o_dim);
        add_opt(G_POWER, "Board LEDs", "Status: loading and menu. CPU Clock: blinks with the Game Boy CPU clock. Sound: left / right level. Activity: saves and USB.", &set.led_en, 5, o_leds);
        add_opt(G_MOON, "Sleep Timer", "Sleep after this long without a button press.", &set.sleep_min, 4, o_sleep);
        add_opt(G_GEAR, "Menu CPU Polling", "How often the menu CPU wakes up while a game runs.", &set.poll_slow, 2, o_poll);
        break;
    case P_LIBRARY: {
        strcpy(page_title, "Library");
        item_t *it = add(I_SRC_SD, G_SDCARD, "SD Card", ".gb / .gbc files on a FAT32 or exFAT card. Saves go next to the ROM.");
        strcpy(it->value, sd_mounted ? "Ready" : "No card");
        it = add(I_SRC_FLASH, G_FLASH, "Internal Flash", "Games written with make_games.py. Saves stay in the flash.");
        sfmt(it->value, sizeof it->value, "%d games", fl_count);
        it = add(I_SRC_CART, G_CART, "Cartridge", "External W25Q flash with a game written from the SD card, or an original cartridge in the cartridge reader.");
        strncpy(it->value, cart_valid ? cart.name : cart_size ? "Empty" : "Not found", 22);
        break;
    }
    case P_CART: {
        strcpy(page_title, "Cartridge");
        if (cart_valid) {
            item_t *it = add(I_PLAY_CART, G_PLAY, "Play", "Load the game from the cartridge. Saves are kept on it.");
            strncpy(it->value, cart.name, 24);
        }
        if (cart_reader) {
            add_info("Source", "original cartridge");
            if (cart_valid) {
                add_info("ROM", "%u KB", cart.rom_size >> 10);
                add_info("Saves", "on the cartridge");
            } else add_info("Game", "none: insert a cartridge");
        } else if (cart_size) {
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
        it = add(I_COPY_FLASH, G_FLASH, "Copy to Internal Flash", "Add the game to the internal flash, so it plays without the card.");
        sfmt(it->value, sizeof it->value, "%d / 15", fl_count);
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
        add_opt(G_AUDIO, "Speaker Signal", "PWM suits buzzers and transistors; sigma-delta needs an RC filter or amp.", &set.spk_mode, 2, o_spkmode);
        add_opt(G_AUDIO, "Speaker Boost", "Extra gain for the speaker. Too high clips loud sounds.", &set.spk_boost, 4, o_boost);
        add_opt(G_AUDIO, "Menu Sounds", "Short clicks when moving and selecting in the menu.", &set.menu_snd, 2, o_offon);
        break;
    case P_CONTROLS:
        strcpy(page_title, "Controls");
        add_opt(G_PAD, "Swap A / B", "Exchange the A and B buttons.", &set.swap_ab, 2, o_offon);
        add_opt(G_PAD, "Link Port", "Game Boy: link cable on pins 41 SC, 42 SI, 56 SO (level shifter). Bluetooth: a ZS-040 / HC-05 at 115200, its TX on 42, RX on 56.", &set.link_en, 3, o_link);
        add_info("Fast forward", "Hold R (DualShock)");
        add_info("Screenshot", "L (DualShock)");
        add_info("Open menu", "SELECT + START, S1");
        add_info("HDMI on / off", "Hold S1");
        add_info("Reset game", "S2");
        add_info("Battery preset", "Hold S2");
        add_info("Navigate", "D-pad, A, B");
        break;
    case P_SYSTEM:
        strcpy(page_title, "System");
        add_opt(G_STAR, "Theme", "Look of the menu on HDMI and on the LCD.", &set.theme, 8, o_theme);
        add_opt(G_CART, "Model", "Auto follows the cartridge header. Applies when the game is reset.", &set.sys_mode, 3, o_sys);
        add_opt(G_SAVE, "Autosave", "Write the save 2 s after the game changes it, and when the menu opens.", &set.autosave, 2, o_offon);
        add_opt(G_CHECK, "Save Notifications", "Show a short message when the save was written.", &set.toasts, 2, o_offon);
        add_opt(G_PLAY, "Start-up", "Start the last game or open the menu at power-up.", &set.boot_menu, 2, o_boot);
        add_opt(G_STAR, "Home Screen", "The animated scene behind the menu while no game is loaded.", &set.home_scene, 4, o_scene);
        add(I_DEFAULTS, G_RESET, "Reset Settings", "Restore all settings to their defaults.");
        add(I_PG_UPDATE, G_FLASH, "System Update", "Install new firmware or FPGA bitstream from the SD card.");
        break;
    case P_INFO: {
        strcpy(page_title, "Info");
        uint32_t st = stat_read();
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
        if (cart_reader) add_info("Cartridge", "original%s%s", cart_valid ? ", " : "", cart_valid ? cart.name : "");
        else if (cart_size) add_info("Cartridge", "%u MB%s%s", cart_size >> 20 ? cart_size >> 20 : 1, cart_valid ? ", " : "", cart_valid ? cart.name : "");
        else add_info("Cartridge", "not connected");
        uint32_t s = ms_now() / 1000;
        add_info("Uptime", "%u:%02u:%02u", s / 3600, (s / 60) % 60, s % 60);
        add_info("Firmware", "Open Pocket GBC " FW_VERSION);
        add_info("Menu CPU", "FemtoRV32 RV32E");
        break;
    }
    }
}

// ---------------------------------------------------------------- themes
// Pocket and Game Boy: one list per page. Ozone (sidebar) and XMB (category bar): the
// categories are a second level; focus 0 = categories, 1 = the page of the category.
enum { TH_POCKET, TH_OZONE, TH_XMB, TH_GAMEBOY, TH_IPOD, TH_BIOS, TH_TERM, TH_AOS, TH_COUNT };
static int two_level(void) { return set.theme == TH_OZONE || set.theme == TH_XMB; }

typedef struct { uint8_t icon; const char *name; uint8_t page; } cat_t;
static cat_t cats[12];
static int ncats, cat, focus;

static void build_cats(void) {
    ncats = 0;
    if (game.loaded) cats[ncats++] = (cat_t){ G_PLAY, "Game", P_GAME };
    cats[ncats++] = (cat_t){ G_LIBRARY, "Library", P_LIBRARY };
    if (recent_count()) cats[ncats++] = (cat_t){ G_PLAY, "Recent", P_RECENT };
    cats[ncats++] = (cat_t){ G_DISPLAY, "Display", P_DISPLAY };
    cats[ncats++] = (cat_t){ G_AUDIO, "Audio", P_AUDIO };
    cats[ncats++] = (cat_t){ G_PAD, "Controls", P_CONTROLS };
    cats[ncats++] = (cat_t){ G_GEAR, "System", P_SYSTEM };
    cats[ncats++] = (cat_t){ G_POWER, "Power", P_POWER };
    cats[ncats++] = (cat_t){ G_GEAR, "Tools", P_TOOLS };
    cats[ncats++] = (cat_t){ G_INFO, "Info", P_INFO };
    cats[ncats++] = (cat_t){ G_MOON, "Sleep", P_SLEEP };
    if (cat >= ncats) cat = 0;
}

static int selectable(int i) { return items[i].id != I_INFO; }

// value text of an item (options: the current choice)
static const char *item_value(item_t *it, int sel, char *buf, int n) {
    if (it->id == I_OPT) {
        if (sel) { sfmt(buf, n, "%c %s %c", G_CHEV_L, it->opts[*it->val], G_CHEV_R); return buf; }
        return it->opts[*it->val];
    }
    if (it->id == I_DIR || (it->id >= I_PG_DISPLAY && it->id <= I_PG_INFO) || it->id == I_PG_POWER ||
        it->id == I_LIBRARY || it->id == I_SRC_SD || it->id == I_SRC_FLASH) {
        if (!it->value[0] || it->id == I_DIR) { buf[0] = G_CHEV_R; buf[1] = 0; return buf; }
    }
    return it->value;
}

// word-wrapped description, up to `lines` lines of width w
static void draw_desc(int x, int y, int w, int lines, uint8_t attr) {
    if (cursor >= nitems || !items[cursor].desc) return;
    const char *d = items[cursor].desc;
    for (int line = 0; *d && line < lines; line++) {
        int n = (int)strlen(d), cut = n;
        if (n > w) { cut = w; while (cut > 0 && d[cut] != ' ') cut--; if (!cut) cut = w; }
        osd_textn(x, y + line, d, cut, attr);
        d += cut;
        while (*d == ' ') d++;
    }
}

static void upcase(char *d, const char *s, int n) {
    int i = 0;
    for (; s[i] && i < n - 1; i++) d[i] = (s[i] >= 'a' && s[i] <= 'z') ? s[i] - 32 : s[i];
    d[i] = 0;
}
static void lowcase(char *d, const char *s, int n) {
    int i = 0;
    for (; s[i] && i < n - 1; i++) d[i] = (s[i] >= 'A' && s[i] <= 'Z') ? s[i] + 32 : s[i];
    d[i] = 0;
}
static int is_file(const item_t *it) { return it->id == I_FILE || it->id == I_DIR || it->id == I_FLASH_GAME; }

// label in the theme's letter case: 1 upper, 2 lower (file names keep their case)
static const char *label_case(const item_t *it, int caps, char *buf, int n) {
    if (caps == 1) { upcase(buf, it->label, n); return buf; }
    if (caps == 2 && !is_file(it)) { lowcase(buf, it->label, n); return buf; }
    return it->label;
}

// Marquee: the selected text scrolls when it does not fit (pause, scroll, pause, again).
static uint32_t mq_t0;
static int mq_cursor = -1, mq_page = -1, mq_on;
static const char *marquee(const char *s, int w) {
    int n = (int)strlen(s);
    if (w <= 0 || n <= w) return s;
    mq_on = 1;
    int steps = n - w, p = (int)((ms_now() - mq_t0) / 250) % (steps + 8);
    return s + (p < 4 ? 0 : p - 4 > steps ? steps : p - 4);
}

// List drawing shared by the themes.
typedef struct {
    uint8_t bg, fg, label_sel, icon, icon_sel, val, val_sel, info_label, sel_fill;
    uint8_t pill, bar, caps;     // rounded selection, Ozone-style bar, 1 upper / 2 lower case labels
    uint8_t cursor;              // cursor glyph left of the selected row instead of a filled bar
    uint8_t noicon, brackets;    // no item icons; values as [value]
    uint8_t chev;                // replaces the page chevron (e.g. '/')
} lstyle_t;

static void draw_list(int x0, int y0, int w, int rows, const lstyle_t *st, int show_sel) {
    if (cursor < scroll) scroll = cursor;
    if (cursor >= scroll + rows) scroll = cursor - rows + 1;
    for (int r = 0; r < rows; r++) {
        int i = scroll + r;
        if (i >= nitems) break;
        item_t *it = &items[i];
        int y = y0 + r;
        int sel = show_sel && i == cursor && selectable(i);
        uint8_t tb = sel && !st->cursor ? st->sel_fill : st->bg;
        if (sel && st->cursor) osd_put(x0, y, st->cursor, AT(st->icon_sel, st->bg));
        else if (sel) {
            if (st->pill) osd_pill(x0, y, w, st->sel_fill, st->bg);
            else osd_fill(x0, y, w, ' ', AT(st->fg, st->sel_fill));
            if (st->bar) osd_put(x0, y, G_THUMB | EXT, AT(CL_BLUE, st->sel_fill));
        }
        int lx = x0 + 2;
        if (it->icon && !st->noicon) { osd_put(lx, y, it->icon, AT(sel ? st->icon_sel : st->icon, tb)); lx += 2; }
        char vb[44], lb[44];
        const char *val = item_value(it, sel, vb, sizeof vb);
        if (val[0] == G_CHEV_R && !val[1] && st->chev) { vb[0] = st->chev; vb[1] = 0; val = vb; }
        else if (st->brackets && it->id == I_OPT) { char t[44]; sfmt(t, sizeof t, "[%s]", it->opts[*it->val]); strcpy(vb, t); val = vb; }
        int vlen = (int)strlen(val);
        if (it->id == I_INFO) {
            osd_textn(lx, y, label_case(it, st->caps, lb, sizeof lb), 13, AT(st->info_label, tb));
            osd_textn(x0 + 15, y, val, w - 16, AT(sel ? st->val_sel : st->fg, tb));
            continue;
        }
        if (vlen > w - 12 && it->id == I_OPT) { val = it->opts[*it->val]; vlen = (int)strlen(val); }   // drop the arrows
        if (vlen > w - 12) vlen = w - 12;
        if (it->id == I_OPT && it->val == &set.volume)
            for (int k = 0; k < 4; k++)
                osd_put(x0 + w - 2 - vlen - 6 + k, y, k < set.volume ? G_SQ_FULL : G_SQ_EMPTY, AT(sel ? st->icon_sel : st->icon, tb));
        int maxl = x0 + w - 2 - lx - (vlen ? vlen + 2 : 0);
        const char *lab = label_case(it, st->caps, lb, sizeof lb);
        osd_textn(lx, y, sel ? marquee(lab, maxl) : lab, maxl, AT(sel ? st->label_sel : st->fg, tb));
        if (vlen) osd_textn(x0 + w - 2 - vlen, y, val, vlen, AT(sel ? st->val_sel : st->val, tb));
    }
    if (nitems > rows) {                         // scroll bar
        int th = rows * rows / nitems;
        if (th < 1) th = 1;
        int ty = (rows - th) * scroll / (nitems - rows);
        for (int r = 0; r < rows; r++)
            osd_put(x0 + w, y0 + r, (r >= ty && r < ty + th ? G_THUMB : G_TRACK) | EXT,
                    AT(r >= ty && r < ty + th ? st->val : st->info_label, st->bg));
    }
    if (nitems == 0) osd_text(x0 + 2, y0, page == P_BROWSER ? "No games in this folder" : "Empty", AT(st->val, st->bg));
}

static const char *title_now(char *buf, int n) {
    if (page == P_BROWSER && page_title[0] != 'I') {
        int l = (int)strlen(cur_dir);
        sfmt(buf, n, "SD %s", l > 20 ? cur_dir + l - 20 : cur_dir);
        return buf;
    }
    return page_title;
}

static void status_icons(int x, int y, uint8_t bg, uint8_t on, uint8_t off) {
    uint8_t g[4];
    int n = status_glyphs(g);
    for (int i = 0; i < n; i++) osd_put(x - 2 * (n - i), y, g[i], AT(on, bg));
    osd_put(x, y, G_SDCARD, AT(sd_mounted ? on : off, bg));
    osd_put(x + 2, y, G_DISPLAY, AT(set.hdmi_off ? off : on, bg));
}

// the same icons on the LCD, right aligned to column xr (exclusive)
static int lcd_status(int xr, int y, uint8_t fg, uint8_t bg) {
    uint8_t g[4];
    int n = status_glyphs(g);
    for (int i = 0; i < n; i++) lcd_put(xr - n + i, y, g[i], AT(fg, bg));
    return xr - n;
}

// ---- Pocket
static void draw_pocket(void) {
    uint8_t bg = CL_SHADE;
    char tb[48];
    osd_clear(AT(CL_WHITE, bg));
    osd_put(2, 1, G_STAR, AT(CL_BLUE, bg));
    osd_text(4, 1, "Open Pocket", AT(CL_WHITE, bg));
    osd_rtext(36, 1, title_now(tb, sizeof tb), AT(CL_GREY, bg));
    status_icons(37, 1, bg, CL_GB3, CL_LINE);
    osd_fill(2, 2, 38, G_HLINE, AT(CL_LINE, bg));
    static const lstyle_t st = { CL_SHADE, CL_WHITE, CL_BLACK, CL_LIGHT, CL_BLUE, CL_LIGHT, CL_BLACK, CL_GREY, CL_WHITE, 1, 0, 0 };
    draw_list(2, 4, 38, 14, &st, 1);
    osd_fill(2, 19, 38, G_HLINE, AT(CL_LINE, bg));
    draw_desc(2, 20, 38, 2, AT(CL_LIGHT, bg));
    hint(2, 22, "A", "Select", bg);
    hint(13, 22, "B", page == P_MAIN ? "Close" : "Back", bg);
    if (page == P_MAIN && game.loaded) hint(23, 22, "START", "Resume", bg);
}

// ---- Game Boy (DMG greens, framed, upper case)
static void draw_gameboy(void) {
    uint8_t in = CL_GB3, fr = CL_GB0;
    char tb[48], up[48];
    osd_clear(AT(fr, fr));
    for (int y = 2; y < 21; y++) osd_fill(2, y, 38, ' ', AT(fr, in));
    upcase(up, page == P_MAIN ? "Open Pocket" : title_now(tb, sizeof tb), sizeof up);
    osd_text(21 - (int)strlen(up) / 2, 1, up, AT(in, fr));
    static const lstyle_t st = { CL_GB3, CL_GB0, CL_GB3, CL_GB1, CL_GB3, CL_GB1, CL_GB2, CL_GB1, CL_GB0, 0, 0, 1 };
    draw_list(2, 3, 38, 13, &st, 1);
    osd_fill(3, 17, 36, G_HLINE, AT(CL_GB1, in));
    draw_desc(3, 18, 36, 2, AT(CL_GB1, in));
    osd_text(3, 22, "A SELECT", AT(in, fr));
    osd_text(14, 22, page == P_MAIN ? "B CLOSE" : "B BACK", AT(in, fr));
    osd_text(28, 22, "OPEN POCKET", AT(CL_GB2, fr));
}

// ---- Ozone (Switch): sidebar with categories, page on the right
static void draw_ozone(void) {
    uint8_t sb = CL_PANEL, bg = CL_SHADE;
    char tb[48];
    osd_clear(AT(CL_WHITE, bg));
    for (int y = 0; y < OSD_H; y++) osd_fill(0, y, 11, ' ', AT(CL_WHITE, sb));
    for (int y = 0; y < OSD_H; y++) osd_put(11, y, G_TRACK | EXT, AT(CL_LINE, bg));
    osd_put(1, 1, G_STAR, AT(CL_BLUE, sb));
    osd_text(3, 1, "Pocket", AT(CL_WHITE, sb));
    for (int i = 0; i < ncats; i++) {
        int y = 4 + i * 2, s = (i == cat);
        uint8_t b = (s && focus == 0) ? CL_LINE : sb;
        if (s && focus == 0) osd_fill(0, y, 11, ' ', AT(CL_WHITE, b));
        if (s) osd_put(0, y, G_THUMB | EXT, AT(CL_BLUE, b));
        osd_put(2, y, cats[i].icon, AT(s ? CL_BLUE : CL_GREY, b));
        osd_text(4, y, cats[i].name, AT(s ? CL_BLUE : CL_LIGHT, b));
    }
    osd_textn(13, 1, title_now(tb, sizeof tb), 23, AT(CL_WHITE, bg));
    status_icons(37, 1, bg, CL_GB3, CL_LINE);
    osd_fill(13, 2, 28, G_HLINE, AT(CL_LINE, bg));
    static const lstyle_t st = { CL_SHADE, CL_WHITE, CL_WHITE, CL_GREY, CL_BLUE, CL_GREY, CL_BLUE, CL_GREY, CL_LINE, 0, 1, 0 };
    draw_list(13, 4, 27, 14, &st, focus == 1);
    osd_fill(13, 18, 28, G_HLINE, AT(CL_LINE, bg));
    if (focus == 1) draw_desc(13, 19, 28, 3, AT(CL_LIGHT, bg));
    else osd_text(13, 19, "Right / A: open", AT(CL_GREY, bg));
    hint(13, 22, "A", focus ? "OK" : "Open", bg);
    hint(23, 22, "B", focus ? "Back" : "Close", bg);
}

// ---- XMB (PS3 / PSP): category icons in a row, the page below the selected one
static void draw_xmb(void) {
    uint8_t bg = CL_NAVY;
    char tb[48];
    osd_clear(AT(CL_WHITE, bg));
    // a calm "wave" across the bottom
    for (int x = 0; x < OSD_W; x++) {
        osd_put(x, 20 + ((x / 7) & 1), G_HLINE, AT(CL_BLUE, bg));
        osd_put(x, 21 - ((x / 9) & 1), G_HLINE, AT(CL_LINE, bg));
    }
    osd_rtext(40, 1, game.loaded ? game.name : "Open Pocket", AT(CL_GREY, bg));
    const int cx = 8;                            // column of the selected category
    for (int i = 0; i < ncats; i++) {
        int x = cx + (i - cat) * 6;
        if (x < 1 || x > 39) continue;
        int s = (i == cat);
        osd_put(x, 3, cats[i].icon, AT(s ? CL_WHITE : CL_GREY, bg));
        if (s) osd_text(x - (int)strlen(cats[i].name) / 2 + 1 > 0 ? x - (int)strlen(cats[i].name) / 2 : 0, 4,
                        cats[i].name, AT(focus == 0 ? CL_WHITE : CL_LIGHT, bg));
    }
    if (page != cats[cat].page) osd_text(cx + 2, 6, title_now(tb, sizeof tb), AT(CL_LIGHT, bg));
    static const lstyle_t st = { CL_NAVY, CL_GREY, CL_WHITE, CL_GREY, CL_WHITE, CL_GREY, CL_WHITE, CL_GREY, CL_BLUE, 1, 0, 0 };
    draw_list(cx - 2, 7, 34, 11, &st, focus == 1);
    if (focus == 1) draw_desc(cx, 18, 32, 2, AT(CL_LIGHT, bg));
    osd_text(2, 22, focus ? "A ok   B back" : "\x05 \x04 category   A open", AT(CL_GREY, bg));
}

// ---- iPod (classic): grey title bar, white list, square blue selection, chevrons
static void draw_ipod(void) {
    uint8_t bg = CL_WHITE, hb = CL_LIGHT;
    char tb[48];
    osd_clear(AT(CL_BLACK, bg));
    for (int y = 0; y < 3; y++) osd_fill(0, y, OSD_W, ' ', AT(CL_BLACK, hb));
    osd_fill(0, 2, OSD_W, G_HLINE, AT(CL_GREY, hb));
    const char *t = page == P_MAIN ? "Open Pocket" : title_now(tb, sizeof tb);
    osd_text(21 - (int)strlen(t) / 2, 1, t, AT(CL_BLACK, hb));
    if (game.loaded) osd_put(2, 1, G_PLAY, AT(CL_BLUE, hb));
    status_icons(37, 1, hb, CL_BLUE, CL_GREY);
    static const lstyle_t st = { CL_WHITE, CL_BLACK, CL_WHITE, CL_GREY, CL_WHITE, CL_GREY, CL_WHITE, CL_GREY, CL_BLUE, 0, 0, 0 };
    draw_list(0, 3, 41, 16, &st, 1);
    osd_fill(0, 19, OSD_W, G_HLINE, AT(CL_LIGHT, bg));
    draw_desc(2, 20, 38, 2, AT(CL_GREY, bg));
    osd_text(2, 22, page == P_MAIN ? "A select   B close" : "A select   B back", AT(CL_GREY, bg));
    if (page == P_MAIN && game.loaded) osd_rtext(40, 22, "START resume", AT(CL_GREY, bg));
}

// ---- BIOS setup (Award / Phoenix): blue screen, red selection bar, [values], Item Help
static void draw_bios(void) {
    uint8_t bg = CL_BLUE;
    char tb[48];
    osd_clear(AT(CL_WHITE, bg));
    osd_fill(0, 0, OSD_W, ' ', AT(CL_BLUE, CL_LIGHT));
    static const char head[] = "Open Pocket CMOS Setup Utility";
    osd_text(21 - (int)(sizeof head - 1) / 2, 0, head, AT(CL_BLUE, CL_LIGHT));
    upcase(tb, page == P_MAIN ? "Main" : title_now(tb, sizeof tb), sizeof tb);
    osd_text(2, 1, tb, AT(CL_YELLOW, bg));
    osd_fill(0, 2, OSD_W, G_HLINE, AT(CL_WHITE, bg));
    osd_fill(0, 19, OSD_W, G_HLINE, AT(CL_WHITE, bg));
    for (int y = 3; y < 19; y++) osd_put(29, y, G_TRACK | EXT, AT(CL_WHITE, bg));
    static const lstyle_t st = { CL_BLUE, CL_WHITE, CL_WHITE, CL_LIGHT, CL_WHITE, CL_YELLOW, CL_YELLOW, CL_LIGHT, CL_RED,
                                 0, 0, 0, 0, 1, 1, 0 };
    draw_list(0, 3, 28, 16, &st, 1);
    osd_text(31, 3, "Item Help", AT(CL_YELLOW, bg));
    osd_fill(31, 4, 10, G_HLINE, AT(CL_LIGHT, bg));
    draw_desc(31, 5, 10, 13, AT(CL_WHITE, bg));
    osd_text(1, 20, "\x1a\x1b:Move  A:Select  \x05\x04:Value", AT(CL_WHITE, bg));
    osd_text(1, 21, page == P_MAIN ? "B:Exit" : "B:Back", AT(CL_WHITE, bg));
    if (game.loaded) osd_text(12, 21, "START:Resume", AT(CL_WHITE, bg));
    osd_fill(0, 23, OSD_W, ' ', AT(CL_BLUE, CL_LIGHT));
    osd_text(1, 23, "Open Pocket GBC " FW_VERSION, AT(CL_BLUE, CL_LIGHT));
}

// ---- Terminal: green phosphor shell, `ls` of the page, inverse selection
static const char *term_path(char *buf, int n) {
    char t[48];
    if (page == P_MAIN) sfmt(buf, n, "~");
    else if (page == P_BROWSER && page_title[0] != 'I') sfmt(buf, n, "/sd%s", strcmp(cur_dir, "/") ? cur_dir : "");
    else {
        lowcase(t, page_title, sizeof t);
        for (char *p = t; *p; p++) if (*p == ' ') *p = '-';
        sfmt(buf, n, "~/%s", t);
    }
    return buf;
}

static void draw_term(void) {
    uint8_t bg = CL_BLACK, g = CL_GB3, d = CL_GB1;
    char pb[48], line[64];
    osd_clear(AT(g, bg));
    term_path(pb, sizeof pb);
    int l = (int)strlen(pb);
    sfmt(line, sizeof line, "pocket@gbc:%s$ ls", l > 24 ? pb + l - 24 : pb);
    osd_text(1, 1, line, AT(g, bg));
    static const lstyle_t st = { CL_BLACK, CL_GB3, CL_BLACK, CL_GB1, CL_BLACK, CL_GB1, CL_BLACK, CL_GB1, CL_GB3,
                                 0, 0, 2, 0, 1, 0, '/' };
    draw_list(1, 3, 39, 15, &st, 1);
    if (cursor < nitems && items[cursor].desc) {
        osd_put(1, 19, '#', AT(d, bg));
        draw_desc(3, 19, 37, 2, AT(d, bg));
    }
    osd_text(1, 22, page == P_MAIN ? "# a: run   b: exit" : "# a: run   b: cd ..", AT(d, bg));
    int x = osd_text(1, 23, "pocket@gbc:", AT(g, bg));
    x = osd_text(x, 23, l > 24 ? pb + l - 24 : pb, AT(g, bg));
    x = osd_text(x, 23, "$ ", AT(g, bg));
    osd_put(x, 23, G_BLOCK | EXT, AT(g, bg));
}

// ---- SPI LCD (16 x 12): every theme has its own layout
enum { LS_PILL, LS_BAR, LS_CURSOR, LS_TEXT };
typedef struct {
    uint8_t bg, fg, sel_bg, sel_fg, icon, icon_sel, val, val_sel;
    uint8_t kind;       // LS_PILL rounded bar, LS_BAR square bar, LS_CURSOR glyph at x0, LS_TEXT colour only
    uint8_t cursor;     // LS_CURSOR glyph
    uint8_t caps;       // 1 upper, 2 lower case labels
    uint8_t icons;      // item icons
    uint8_t values;     // values on the row (when they fit)
    uint8_t chev;       // page marker on the right (0: none)
    uint8_t brackets;   // [value]
    uint8_t inline_sel; // no footer: the selected row always shows its value
} lcdst_t;

static int lscroll;

static void lcd_list(int x0, int y0, int w, int rows, const lcdst_t *st, int show_sel) {
    if (cursor < lscroll) lscroll = cursor;
    if (cursor >= lscroll + rows) lscroll = cursor - rows + 1;
    if (lscroll > nitems - rows) lscroll = nitems > rows ? nitems - rows : 0;
    char lb[44], vb[44];
    for (int r = 0; r < rows && lscroll + r < nitems; r++) {
        int i = lscroll + r, y = y0 + r;
        item_t *it = &items[i];
        int s = show_sel && i == cursor && selectable(i);
        int filled = s && (st->kind == LS_PILL || st->kind == LS_BAR);
        uint8_t tb = filled ? st->sel_bg : st->bg;
        if (s) {
            if (st->kind == LS_PILL) lcd_pillx(x0, y, w, st->sel_bg, st->bg);
            else if (st->kind == LS_BAR) lcd_fill(x0, y, w, ' ', AT(st->sel_fg, st->sel_bg));
            else if (st->kind == LS_CURSOR) lcd_put(x0, y, st->cursor, AT(st->icon_sel, st->bg));
        }
        int lx = x0 + 1, xr = x0 + w - (st->kind == LS_PILL ? 1 : 0);    // text ends before xr
        if (it->id == I_INFO) { lcd_textn(lx, y, it->value, xr - lx, AT(st->val, tb)); continue; }
        if (st->icons && it->icon) { lcd_put(lx, y, it->icon, AT(s ? st->icon_sel : st->icon, tb)); lx += 2; }
        const char *v = item_value(it, 0, vb, sizeof vb);
        if (v[0] == G_CHEV_R && !v[1]) { vb[0] = st->chev; vb[1] = 0; v = vb; }
        else if (!st->values) v = "";
        else if (st->brackets && it->id == I_OPT) { sfmt(lb, sizeof lb, "[%s]", v); strcpy(vb, lb); v = vb; }
        if (st->caps && v != vb && v[0]) { strcpy(vb, v); v = vb; }
        if (st->caps == 1 && v == vb) upcase(vb, vb, sizeof vb);
        if (st->caps == 2 && v == vb) lowcase(vb, vb, sizeof vb);
        const char *lab = label_case(it, st->caps, lb, sizeof lb);
        int vl = (int)strlen(v), room = xr - lx, ll = (int)strlen(lab);
        // the value only when the label still fits; with no footer the selected row shortens the label
        if (ll + 1 + vl > room && !(s && st->inline_sel && vl <= room - 4)) vl = 0;
        int lw = room - (vl ? vl + 1 : 0);
        lcd_textn(lx, y, s ? marquee(lab, lw) : lab, lw, AT(s ? st->sel_fg : st->fg, tb));
        if (vl) lcd_text(xr - vl, y, v, AT(s ? st->val_sel : st->val, tb));
    }
    if (!nitems) lcd_text(x0 + 1, y0, page == P_BROWSER ? "No games" : "Empty", AT(st->val, st->bg));
}

// y of the selected row in the last lcd_list
static int lcd_sel_row(int y0) { return y0 + cursor - lscroll; }

// footer: the selected option as < value >, or the item's value, or a key hint
static void lcd_footer(int x0, int w, int y, uint8_t bg, uint8_t vcol, uint8_t hcol, const char *hint, int caps, int show) {
    char b[44];
    int opt = 0;
    lcd_fill(x0, y, w, ' ', AT(hcol, bg));
    if (show && cursor < nitems) {
        item_t *it = &items[cursor];
        opt = it->id == I_OPT;
        if (opt) sfmt(b, sizeof b, "%c %s %c", G_CHEV_L, it->opts[*it->val], G_CHEV_R);
        else if (it->value[0] && it->id != I_INFO && !(it->value[0] == G_CHEV_R && !it->value[1])) sfmt(b, sizeof b, "%s", it->value);
        else sfmt(b, sizeof b, "%s", hint);
    } else sfmt(b, sizeof b, "%s", hint);
    if (caps == 1) upcase(b, b, sizeof b);
    int n = (int)strlen(b);
    if (opt && n > w) { memmove(b, b + 2, n - 4); b[n - 4] = 0; n -= 4; }    // drop the arrows
    if (n > w) { lcd_textn(x0, y, marquee(b, w), w, AT(opt ? vcol : hcol, bg)); return; }
    lcd_text(x0 + (w - n) / 2, y, b, AT(opt ? vcol : hcol, bg));
}

static const char *lcd_title(void) {
    if (page == P_MAIN) return "Open Pocket";
    if (page == P_BROWSER) return page_title[0] == 'I' ? "Flash" : "SD Card";
    return page_title;
}

static void lcd_pocket(void) {
    uint8_t bg = CL_SHADE, hb = CL_NAVY;
    lcd_clear(AT(CL_WHITE, bg));
    lcd_fill(0, 0, LCD_W, ' ', AT(CL_WHITE, hb));
    lcd_put(0, 0, G_STAR, AT(CL_BLUE, hb));
    lcd_textn(2, 0, lcd_title(), 12, AT(CL_WHITE, hb));
    lcd_put(15, 0, G_SDCARD, AT(sd_mounted ? CL_GB3 : CL_LINE, hb));
    lcd_status(15, 0, CL_WHITE, hb);
    static const lcdst_t st = { CL_SHADE, CL_WHITE, CL_WHITE, CL_BLACK, CL_GREY, CL_BLUE, CL_YELLOW, CL_BLUE,
                                LS_PILL, 0, 0, 1, 1, 0, 0 };
    lcd_list(0, 1, LCD_W, 10, &st, 1);
    lcd_footer(0, LCD_W, 11, bg, CL_YELLOW, CL_GREY, page == P_MAIN ? "A ok  B close" : "A ok  B back", 0, 1);
}

// Ozone: icon sidebar with the categories, the page beside it
static void lcd_ozone(void) {
    uint8_t sb = CL_PANEL, bg = CL_SHADE;
    lcd_clear(AT(CL_WHITE, bg));
    for (int y = 0; y < LCD_H; y++) lcd_fill(0, y, 3, ' ', AT(CL_WHITE, sb));
    lcd_put(1, 0, G_STAR, AT(CL_BLUE, sb));
    int top = cat > 10 ? cat - 10 : 0;
    for (int r = 0; r < 11 && top + r < ncats; r++) {
        int i = top + r, y = 1 + r, s = (i == cat);
        uint8_t b = (s && focus == 0) ? CL_LINE : sb;
        if (s && focus == 0) lcd_fill(0, y, 3, ' ', AT(CL_WHITE, b));
        if (s) lcd_put(0, y, G_THUMB | EXT, AT(CL_BLUE, b));
        lcd_put(1, y, cats[i].icon, AT(s ? CL_BLUE : CL_GREY, b));
    }
    lcd_textn(4, 0, focus == 0 ? cats[cat].name : lcd_title(), 12, AT(focus == 0 ? CL_BLUE : CL_WHITE, bg));
    static const lcdst_t st = { CL_SHADE, CL_WHITE, CL_LINE, CL_WHITE, CL_GREY, CL_BLUE, CL_BLUE, CL_BLUE,
                                LS_BAR, 0, 0, 0, 1, G_CHEV_R, 0 };
    lcd_list(3, 1, 13, 10, &st, focus == 1);
    if (focus == 1 && nitems) lcd_put(3, lcd_sel_row(1), G_THUMB | EXT, AT(CL_BLUE, CL_LINE));
    lcd_footer(3, 13, 11, bg, CL_BLUE, CL_GREY, focus ? "A ok  B back" : "\x04 open", 0, focus == 1);
}

// XMB: category icons in a row, the selected one at the left, its page underneath
static void lcd_xmb(void) {
    uint8_t bg = CL_NAVY;
    lcd_clear(AT(CL_WHITE, bg));
    lcd_textn(0, 0, game.loaded ? game.name : "Open Pocket", 16, AT(CL_GREY, bg));
    // icon row: the selected category at the left, the following ones to its right
    if (cat > 0) lcd_put(0, 2, G_CHEV_L, AT(CL_LINE, bg));
    lcd_put(1, 2, cats[cat].icon, AT(CL_WHITE, bg));
    for (int i = cat + 1, x = 4; i < ncats && x < 16; i++, x += 3) lcd_put(x, 2, cats[i].icon, AT(CL_GREY, bg));
    lcd_textn(1, 3, cats[cat].name, 15, AT(focus == 0 ? CL_WHITE : CL_LIGHT, bg));
    if (page != cats[cat].page) lcd_textn(1, 4, lcd_title(), 15, AT(CL_GREY, bg));
    static const lcdst_t st = { CL_NAVY, CL_GREY, CL_BLUE, CL_WHITE, CL_GREY, CL_WHITE, CL_GREY, CL_WHITE,
                                LS_TEXT, 0, 0, 1, 1, 0, 0 };
    lcd_list(0, 5, LCD_W, 6, &st, focus == 1);
    // the wave, or the value of the selected option on top of it
    for (int x = 0; x < LCD_W; x++) lcd_put(x, 11, G_HLINE, AT(((x / 4) & 1) ? CL_BLUE : CL_LINE, bg));
    if (focus == 1 && cursor < nitems && items[cursor].id == I_OPT) lcd_footer(0, LCD_W, 11, bg, CL_WHITE, CL_GREY, "", 0, 1);
}

// Game Boy: dark bezel bands, light screen with a thin frame, a cursor arrow, upper case
static void lcd_gameboy(void) {
    uint8_t in = CL_GB3, fr = CL_GB0;
    char b[24];
    lcd_clear(AT(CL_GB0, in));
    lcd_fill(0, 0, LCD_W, ' ', AT(in, fr));
    upcase(b, lcd_title(), 15);
    lcd_text(8 - (int)strlen(b) / 2, 0, b, AT(in, fr));
    for (int y = 1; y < 11; y++) {
        lcd_put(0, y, G_TRACK | EXT, AT(CL_GB1, in));
        lcd_put(15, y, G_TRACK | EXT, AT(CL_GB1, in));
    }
    static const lcdst_t st = { CL_GB3, CL_GB0, CL_GB3, CL_GB0, CL_GB1, CL_GB0, CL_GB1, CL_GB0,
                                LS_CURSOR, G_PLAY, 1, 0, 1, 0, 0 };
    lcd_list(1, 1, 14, 10, &st, 1);
    lcd_footer(0, LCD_W, 11, fr, CL_GB3, CL_GB2, page == P_MAIN ? "A OK  B CLOSE" : "A OK  B BACK", 1, 1);
}

// iPod: grey title bar, white list, square blue bar, chevrons, no footer
static void lcd_ipod(void) {
    uint8_t hb = CL_LIGHT;
    char b[24];
    lcd_clear(AT(CL_BLACK, CL_WHITE));
    lcd_fill(0, 0, LCD_W, ' ', AT(CL_BLACK, hb));
    sfmt(b, 13, "%s", lcd_title());
    lcd_text(8 - (int)strlen(b) / 2, 0, b, AT(CL_BLACK, hb));
    if (game.loaded) lcd_put(0, 0, G_PLAY, AT(CL_BLUE, hb));
    lcd_put(15, 0, G_SDCARD, AT(sd_mounted ? CL_BLUE : CL_GREY, hb));
    lcd_status(15, 0, CL_BLACK, hb);
    static const lcdst_t st = { CL_WHITE, CL_BLACK, CL_BLUE, CL_WHITE, CL_GREY, CL_WHITE, CL_GREY, CL_WHITE,
                                LS_BAR, 0, 0, 0, 1, G_CHEV_R, 0, 1 };
    lcd_list(0, 1, LCD_W, 11, &st, 1);
}

// BIOS: blue screen, grey bars, red selection, yellow [values]
static void lcd_bios(void) {
    uint8_t bg = CL_BLUE, hb = CL_LIGHT;
    char b[24];
    lcd_clear(AT(CL_WHITE, bg));
    lcd_fill(0, 0, LCD_W, ' ', AT(CL_BLUE, hb));
    upcase(b, page == P_MAIN ? "CMOS Setup" : lcd_title(), 15);
    lcd_text(8 - (int)strlen(b) / 2, 0, b, AT(CL_BLUE, hb));
    static const lcdst_t st = { CL_BLUE, CL_WHITE, CL_RED, CL_WHITE, CL_LIGHT, CL_WHITE, CL_YELLOW, CL_YELLOW,
                                LS_BAR, 0, 0, 0, 1, 0, 1 };
    lcd_list(0, 1, LCD_W, 10, &st, 1);
    lcd_footer(0, LCD_W, 11, hb, CL_RED, CL_BLUE, "\x1a\x1b Move  A Sel", 0, 1);
}

// Terminal: green on black, the path as a prompt, inverse selection, a block cursor
static void lcd_term(void) {
    uint8_t bg = CL_BLACK, g = CL_GB3;
    char pb[48], b[24];
    lcd_clear(AT(g, bg));
    term_path(pb, sizeof pb);
    int l = (int)strlen(pb);
    sfmt(b, sizeof b, "%s$", l > 14 ? pb + l - 14 : pb);
    lcd_text(0, 0, b, AT(g, bg));
    static const lcdst_t st = { CL_BLACK, CL_GB3, CL_GB3, CL_BLACK, CL_GB1, CL_BLACK, CL_GB1, CL_BLACK,
                                LS_BAR, 0, 2, 0, 1, '/', 0 };
    lcd_list(0, 1, LCD_W, 10, &st, 1);
    if (cursor < nitems && items[cursor].id == I_OPT) {
        lcd_footer(0, LCD_W, 11, bg, g, CL_GB1, "", 0, 1);
    } else {
        int x = lcd_text(0, 11, "$ ", AT(g, bg));
        lcd_put(x, 11, G_BLOCK, AT(g, bg));
    }
}

// ---- Analogue OS (Analogue Pocket). A left-indented column of big labels, the white pill runs
// from the column to the right edge, a thin scroll thumb at the edge, no icons. A on a setting
// opens its choices as a list with radio buttons. Status line: "- " on the top page, otherwise
// "* Parent  Page"; a source badge and the position on the right. Over a running game the menu
// is drawn on the dimmed picture (colour 0), like the Pocket's in-game menu.
static int aos_scroll;

static uint8_t aos_bg(void) { return (game.loaded || home_running) ? CL_GAME : CL_NAVY; }

static int aos_first(int rows) {
    if (cursor < aos_scroll) aos_scroll = cursor;
    if (cursor >= aos_scroll + rows) aos_scroll = cursor - rows + 1;
    if (aos_scroll > nitems - rows) aos_scroll = nitems > rows ? nitems - rows : 0;
    return aos_scroll;
}

static const char *aos_parent(void) {
    switch (page) {
    case P_MAIN: return "";
    case P_CHOICE: return ch_parent;
    case P_BROWSER: case P_CART: case P_FILEACT: case P_FLACT: return "Library";
    default: return "Menu";
    }
}

static const char *aos_badge(void) {
    if (game.loaded) return game.src == 3 ? "CART" : game.src == 2 ? "SD" : "FLASH";
    return sd_mounted ? "SD" : "";
}

// right side of a row: radio for choices, otherwise the value (chevrons only on the selected option)
static const char *aos_value(item_t *it, int s, char *vb, int n, uint8_t *radio) {
    *radio = 0;
    if (it->id == I_CHOICE) { *radio = (*ch_item.val == it->arg) ? G_RING_ON : G_RING; return ""; }
    const char *v = item_value(it, s, vb, n);
    if (v[0] == G_CHEV_R && !v[1]) return "";
    return v;
}

static void draw_aos(void) {
    uint8_t bg = aos_bg();
    char tb[48], vb[48], lb[48];
    osd_clear(AT(CL_WHITE, bg));
    const int x0 = 5, w = 35, rows = 10;               // pill from column 5 to 39, thumb in 40
    int first = aos_first(rows);
    for (int r = 0; r < rows && first + r < nitems; r++) {
        int i = first + r, y = 1 + r * 2;
        item_t *it = &items[i];
        int s = i == cursor && selectable(i);
        uint8_t tbg = s ? CL_WHITE : bg, radio;
        if (s) osd_pill(x0, y, w, CL_WHITE, bg);
        const char *v = aos_value(it, s, vb, sizeof vb, &radio);
        int vl = (int)strlen(v);
        if (vl > 16 && it->id == I_OPT) { v = it->opts[*it->val]; vl = (int)strlen(v); }   // drop the arrows
        if (vl > 16) vl = 16;
        int xr = x0 + w - 2;                               // right end of the text
        if (radio) { osd_put(xr - 1, y, radio, AT(s ? CL_BLACK : CL_WHITE, tbg)); xr -= 3; }
        int lw = xr - (x0 + 2) - (vl ? vl + 1 : 0);
        const char *lab = label_case(it, 0, lb, sizeof lb);
        uint8_t lc = s ? CL_BLACK : it->id == I_INFO ? CL_GREY : CL_WHITE;
        osd_textn(x0 + 2, y, s ? marquee(lab, lw) : lab, lw, AT(lc, tbg));
        if (vl) osd_textn(xr - vl, y, v, vl, AT(s ? CL_LINE : CL_LIGHT, tbg));
    }
    if (nitems > rows) {                               // thin thumb at the edge, no track
        int span = rows * 2 - 1, th = span * rows / nitems, ty = (span - th) * first / (nitems - rows);
        if (th < 1) th = 1;
        for (int k = 0; k < th; k++) osd_put(x0 + w + 1, 1 + ty + k, G_THUMB | EXT, AT(CL_LIGHT, bg));
    }
    if (!nitems) osd_text(x0 + 2, 1, page == P_BROWSER ? "No games in this folder" : "Empty", AT(CL_GREY, bg));
    // status line
    const char *par = aos_parent();
    if (*par) {
        osd_put(x0, 22, G_BULLET, AT(CL_WHITE, bg));
        int x = osd_text(x0 + 2, 22, par, AT(CL_GREY, bg)) + 1;
        osd_textn(x, 22, page == P_CHOICE ? ch_item.label : title_now(tb, sizeof tb), 34 - x, AT(CL_WHITE, bg));
    } else osd_fill(x0, 22, 2, G_HLINE, AT(CL_WHITE, bg));
    int xr = x0 + w + 1;
    if (nitems) { sfmt(tb, sizeof tb, "%c %d/%d", G_BULLET, cursor + 1, nitems); xr -= (int)strlen(tb); osd_text(xr, 22, tb, AT(CL_WHITE, bg)); }
    const char *bd = aos_badge();
    if (*bd) { xr -= (int)strlen(bd) + 1; osd_text(xr, 22, bd, AT(CL_BLACK, CL_LIGHT)); }
    uint8_t g[4];
    int n = status_glyphs(g);
    for (int i = 0; i < n; i++) osd_put(xr - 2 * (n - i), 22, g[i], AT(CL_WHITE, bg));
}

static void lcd_aos(void) {
    uint8_t bg = aos_bg();
    char tb[24], vb[48], lb[48];
    lcd_clear(AT(CL_WHITE, bg));
    const int rows = 10;                               // rows 1..10, pill columns 1..14, thumb in 15
    int first = aos_first(rows);
    for (int r = 0; r < rows && first + r < nitems; r++) {
        int i = first + r, y = 1 + r;
        item_t *it = &items[i];
        int s = i == cursor && selectable(i);
        uint8_t tbg = s ? CL_WHITE : bg, radio;
        if (s) lcd_pillx(1, y, 14, CL_WHITE, bg);
        if (it->id == I_INFO) { lcd_textn(2, y, it->value, 12, AT(CL_LIGHT, tbg)); continue; }
        const char *v = aos_value(it, 0, vb, sizeof vb, &radio);
        int xr = 14;
        if (radio) { lcd_put(13, y, radio, AT(s ? CL_BLACK : CL_WHITE, tbg)); xr = 12; }
        const char *lab = label_case(it, 0, lb, sizeof lb);
        int vl = (int)strlen(v), ll = (int)strlen(lab), room = xr - 2;
        if (ll + 1 + vl > room) vl = 0;                 // the status line shows it
        int lw = room - (vl ? vl + 1 : 0);
        lcd_textn(2, y, s ? marquee(lab, lw) : lab, lw, AT(s ? CL_BLACK : CL_WHITE, tbg));
        if (vl) lcd_text(xr - vl, y, v, AT(s ? CL_LINE : CL_LIGHT, tbg));
    }
    if (nitems > rows) {
        int th = rows * rows / nitems, ty = (rows - th) * first / (nitems - rows);
        if (th < 1) th = 1;
        for (int k = 0; k < th; k++) lcd_put(15, 1 + ty + k, G_THUMB | EXT, AT(CL_LIGHT, bg));
    }
    if (!nitems) lcd_text(2, 1, page == P_BROWSER ? "No games" : "Empty", AT(CL_GREY, bg));
    // status: the selected option's value, or where we are; position on the right
    if (nitems) sfmt(tb, sizeof tb, "%d/%d", cursor + 1, nitems); else tb[0] = 0;
    int rw = (int)strlen(tb), lw = 15 - rw;
    if (cursor < nitems && items[cursor].id == I_OPT) {
        char ob[44];
        sfmt(ob, sizeof ob, "%c %s %c", G_CHEV_L, items[cursor].opts[*items[cursor].val], G_CHEV_R);
        lcd_textn(1, 11, marquee(ob, lw - 2), lw - 2, AT(CL_WHITE, bg));
    } else if (page == P_MAIN) lcd_fill(1, 11, 2, G_HLINE, AT(CL_WHITE, bg));
    else {
        lcd_put(1, 11, G_BULLET, AT(CL_WHITE, bg));
        const char *t = page == P_CHOICE ? ch_item.label : lcd_title();
        lcd_textn(3, 11, marquee(t, lw - 4), lw - 4, AT(CL_GREY, bg));
    }
    lcd_text(15 - rw, 11, tb, AT(CL_WHITE, bg));
    lcd_status(14 - rw, 11, CL_WHITE, bg);
}

static void draw_lcd(void) {
    switch (set.theme) {
    case TH_OZONE:   lcd_ozone(); break;
    case TH_XMB:     lcd_xmb(); break;
    case TH_GAMEBOY: lcd_gameboy(); break;
    case TH_IPOD:    lcd_ipod(); break;
    case TH_BIOS:    lcd_bios(); break;
    case TH_TERM:    lcd_term(); break;
    case TH_AOS:     lcd_aos(); break;
    default:         lcd_pocket(); break;
    }
    lcd_present();
}

static void go(int p, int keep_cursor);

// ---- Game Genie code editor (all themes)
static int ed_err;

static int ed_code(char *out) {          // digits as a string; 0 unless 6 or 9 digits
    int n = 0;
    while (n < 9 && ed_dig[n] < 16) { out[n] = "0123456789ABCDEF"[ed_dig[n]]; n++; }
    out[n] = 0;
    for (int i = n; i < 9; i++) if (ed_dig[i] < 16) return 0;
    return n == 6 || n == 9;
}

static void draw_code(void) {
    uint8_t bg = CL_NAVY;
    char code[10], b[48];
    int ok = ed_code(code);
    osd_clear(AT(CL_WHITE, bg));
    osd_put(5, 3, G_STAR, AT(CL_YELLOW, bg));
    osd_text(7, 3, ed_slot >= 0 ? "Edit Game Genie Code" : "New Game Genie Code", AT(CL_WHITE, bg));
    osd_textn(7, 4, game.name, 30, AT(CL_GREY, bg));
    for (int i = 0; i < 9; i++) {
        int x = 10 + (i + i / 3) * 2;
        char c = ed_dig[i] < 16 ? "0123456789ABCDEF"[ed_dig[i]] : '_';
        int s = i == ed_pos;
        if (s) { osd_put(x, 9, G_UP, AT(CL_WHITE, bg)); osd_put(x, 11, G_DOWN, AT(CL_WHITE, bg)); }
        osd_put(x, 10, (uint8_t)c, s ? AT(CL_BLACK, CL_WHITE) : AT(ed_dig[i] < 16 ? CL_WHITE : CL_LINE, CL_PANEL));
        if (i == 2 || i == 5) osd_put(x + 2, 10, '-', AT(CL_GREY, bg));
    }
    uint16_t a; uint8_t v; int cmp;
    if (ok && gg_decode(code, &a, &v, &cmp)) {
        if (cmp >= 0) sfmt(b, sizeof b, "Address %04X   Data %02X   If %02X", a, v, cmp);
        else sfmt(b, sizeof b, "Address %04X   Data %02X", a, v);
        osd_text(21 - (int)strlen(b) / 2, 14, b, AT(CL_LIGHT, bg));
    } else osd_text(11, 14, "6 or 9 digits: ABC-DEF-GHI", AT(CL_GREY, bg));
    if (ed_err) osd_text(14, 16, "Not a valid code", AT(CL_RED, bg));
    osd_text(4, 20, "\x1a\x1b digit  \x05\x04 move  A save  B cancel", AT(CL_GREY, bg));
    osd_present();

    lcd_clear(AT(CL_WHITE, bg));
    lcd_put(0, 0, G_STAR, AT(CL_YELLOW, bg));
    lcd_text(2, 0, "Game Genie", AT(CL_WHITE, bg));
    for (int i = 0; i < 9; i++) {
        int x = 2 + i + i / 3;
        char c = ed_dig[i] < 16 ? "0123456789ABCDEF"[ed_dig[i]] : '_';
        int s = i == ed_pos;
        if (s) { lcd_put(x, 3, G_UP, AT(CL_WHITE, bg)); lcd_put(x, 5, G_DOWN, AT(CL_WHITE, bg)); }
        lcd_put(x, 4, (uint8_t)c, s ? AT(CL_BLACK, CL_WHITE) : AT(ed_dig[i] < 16 ? CL_WHITE : CL_LINE, bg));
        if (i == 2 || i == 5) lcd_put(x + 1, 4, '-', AT(CL_GREY, bg));
    }
    if (ok && gg_decode(code, &a, &v, &cmp)) {
        sfmt(b, sizeof b, "%04X=%02X", a, v);
        lcd_text(4, 7, b, AT(CL_LIGHT, bg));
    }
    if (ed_err) lcd_text(2, 8, "Not valid", AT(CL_RED, bg));
    lcd_text(0, 10, "\x1a\x1b digit \x05\x04 move", AT(CL_GREY, bg));
    lcd_text(0, 11, "A save  B cancel", AT(CL_GREY, bg));
    lcd_present();
}

static void code_save(void) {
    char code[10];
    uint16_t a; uint8_t v; int cmp;
    if (!ed_code(code) || !gg_decode(code, &a, &v, &cmp) || a >= 0x8000) { ed_err = 1; beep(220, 80); return; }
    cheatset_t *cs = cheats_for(1);
    int slot = ed_slot;
    if (slot < 0) {
        if (cs->n >= N_CODES) { ed_err = 1; return; }
        slot = cs->n++;
        cs->on |= (uint8_t)(1 << slot);
    }
    memset(cs->code[slot], 0, sizeof cs->code[slot]);
    strcpy(cs->code[slot], code);
    ex_dirty = 1;
    cheats_apply();
    extra_save();
    snd_ok();
    go(P_CHEATS, 0);
    cursor = slot;
}

static void draw_menu(void) {
    if (page == P_CODE) { draw_code(); return; }
    if (cursor != mq_cursor || page != mq_page) { mq_cursor = cursor; mq_page = page; mq_t0 = ms_now(); }
    mq_on = 0;
    switch (set.theme) {
    case TH_OZONE:   draw_ozone(); break;
    case TH_XMB:     draw_xmb(); break;
    case TH_GAMEBOY: draw_gameboy(); break;
    case TH_IPOD:    draw_ipod(); break;
    case TH_BIOS:    draw_bios(); break;
    case TH_TERM:    draw_term(); break;
    case TH_AOS:     draw_aos(); break;
    default:         draw_pocket(); break;
    }
    osd_present();
    draw_lcd();
}

// ---------------------------------------------------------------- navigation
static int sel_first(void) { for (int i = 0; i < nitems; i++) if (selectable(i)) return i; return 0; }

static void go(int p, int keep_cursor) {
    page = p;
    build_page();
    if (!keep_cursor) { cursor = sel_first(); scroll = 0; }
    if (cursor >= nitems) cursor = nitems ? nitems - 1 : 0;
}

// the top page: main list, or the root page of the current category
static void go_home(int keep) {
    if (two_level()) { build_cats(); go(cats[cat].page, keep); }
    else go(P_MAIN, keep);
}

// power presets
static void preset_apply(int battery_preset) {
    if (battery_preset) {
        set.hdmi_off = 1; set.sdram_pd = 1; set.lcd_slow = 1; set.lcd_bri = 0;
        set.dim_idx = 2; set.led_en = 0; set.sleep_min = 1; set.poll_slow = 1; set.dbg_on = 0;
        set.link_en = 0;            // only the LCD, the speaker and the buttons stay on
    } else {
        set.hdmi_off = 0; set.sdram_pd = 0; set.lcd_slow = 0; set.lcd_bri = 3;
        set.dim_idx = 0; set.sleep_min = 0; set.poll_slow = 0;
    }
    lcd_dimmed = 0;
    apply_settings();
}
static int preset_now(void) {
    if (set.hdmi_off && set.sdram_pd && set.lcd_slow && set.lcd_bri == 0 && set.dim_idx == 2 && !set.led_en &&
        set.sleep_min == 1 && set.poll_slow && !set.link_en) return 1;
    if (!set.hdmi_off && !set.sdram_pd && !set.lcd_slow && set.lcd_bri == 3 && !set.dim_idx && !set.sleep_min &&
        !set.poll_slow) return 0;
    return 2;
}

static int opt_changed(item_t *it) {
    if (it->val == &preset_sel) {
        if (preset_sel == 2) preset_sel = (it->nopt == 3) ? 0 : 0;   // "Custom" is not a target
        preset_apply(preset_sel == 1);
        go(P_POWER, 1);
        return 1;
    }
    if (it->val == &set.theme) { osd_invalidate(); build_cats(); }
    if (it->val == &set.home_scene && home_running) start_home();
    if (it->val == &set.vprinter) vprn_reset();
    apply_settings();
    if (page == P_POWER) go(P_POWER, 1);              // refresh the preset value
    return 1;
}

// ---------------------------------------------------------------- settings over the USB-UART
// 'Z' (at 115200): the firmware answers "#CFG" and reads lines; only lower case and digits,
// because upper case letters are remote key presses:
//   list               every setting on the Display, Audio, Controls, System and Power pages:
//                      "opt <page> <item> <value>|<label>|<option>;<option>;...", then "end"
//   set <p> <i> <v>    change one as the menu does (then it is stored): "ok" or "err"
//   bye                done (also after 3 s without a byte); "#CFG end"
static const uint8_t cfg_pages[] = { P_DISPLAY, P_AUDIO, P_CONTROLS, P_SYSTEM, P_POWER };

static int cfg_line(char *buf, int max) {
    int n = 0;
    uint32_t t0 = ms_now();
    for (;;) {
        uint32_t r = REG_UART;
        if (r & 0x800) {
            char c = (char)r;
            t0 = ms_now();
            if (c == '\n' || c == '\r') { if (n) { buf[n] = 0; return n; } }
            else if (n < max - 1) buf[n++] = c;
        } else if (ms_now() - t0 > 3000) return -1;
    }
}

static int cfg_num(const char **p) {
    while (**p == ' ') (*p)++;
    if (**p < '0' || **p > '9') return -1;
    int v = 0;
    while (**p >= '0' && **p <= '9') v = v * 10 + *(*p)++ - '0';
    return v;
}

static void cfg_uart(void) {
    int keep_page = page, keep_cursor = cursor, keep_scroll = scroll, changed = 0;
    char keep_title[sizeof page_title], line[64];
    memcpy(keep_title, page_title, sizeof keep_title);
    logf("#CFG\n");
    while (cfg_line(line, sizeof line) > 0) {
        if (!strcmp(line, "bye")) break;
        if (!strcmp(line, "list")) {
            for (int pi = 0; pi < (int)sizeof cfg_pages; pi++) {
                page = cfg_pages[pi];
                build_page();
                for (int i = 0; i < nitems; i++) {
                    item_t *it = &items[i];
                    if (it->id != I_OPT) continue;
                    logf("opt %d %d %d|%s|", pi, i, *it->val, it->label);
                    for (int k = 0; k < it->nopt; k++) logf("%s%s", k ? ";" : "", it->opts[k]);
                    logf("\n");
                }
            }
            logf("end\n");
        } else if (!strncmp(line, "set ", 4)) {
            const char *q = line + 4;
            int pi = cfg_num(&q), i = cfg_num(&q), v = cfg_num(&q), ok = 0;
            if (pi >= 0 && pi < (int)sizeof cfg_pages && i >= 0 && v >= 0) {
                page = cfg_pages[pi];
                build_page();
                if (i < nitems && items[i].id == I_OPT && v < items[i].nopt) {
                    *items[i].val = (uint8_t)v;
                    opt_changed(&items[i]);
                    changed = ok = 1;
                }
            }
            logf(ok ? "ok\n" : "err\n");
        } else logf("err\n");
    }
    if (changed) settings_save();
    page = keep_page; cursor = keep_cursor; scroll = keep_scroll;
    memcpy(page_title, keep_title, sizeof page_title);
    if (ctrl & C_OSD) { build_page(); osd_invalidate(); }
    logf("#CFG end\n");
}

// returns 1 when the menu should close
static void open_choice(item_t *it) {
    ch_item = *it;
    ch_ret_page = page;
    ch_ret_cursor = cursor;
    strncpy(ch_parent, page_title, sizeof ch_parent - 1);
    go(P_CHOICE, 0);
    cursor = *ch_item.val < nitems ? *ch_item.val : 0;     // `it` pointed into the old page
}

static int activate(item_t *it, int dir) {
    switch (it->id) {
    case I_CHOICE:
        *ch_item.val = (uint8_t)it->arg;
        go(ch_ret_page, 0);
        cursor = ch_ret_cursor;
        opt_changed(&ch_item);
        if (cursor >= nitems) cursor = nitems ? nitems - 1 : 0;
        break;
    case I_RESUME: return 1;
    case I_LIBRARY: go(P_LIBRARY, 0); break;
    case I_SAVE: {
        message_screen("Saving", game.name);
        int r = save_write();
        message_screen(r >= 0 ? "Saved" : "Save failed", game.name);
        wait_ms(700);
        osd_invalidate();
        go(page, 1);
        break;
    }
    case I_RESET: reset_game(); return 1;
    case I_PG_DISPLAY: go(P_DISPLAY, 0); break;
    case I_PG_AUDIO: go(P_AUDIO, 0); break;
    case I_PG_CONTROLS: go(P_CONTROLS, 0); break;
    case I_PG_SYSTEM: go(P_SYSTEM, 0); break;
    case I_PG_INFO: go(P_INFO, 0); break;
    case I_PG_POWER: go(P_POWER, 0); break;
    case I_SLEEP_NOW: do_sleep(); osd_invalidate(); go(page, 1); break;
    case I_SRC_SD:
        if (!sd_mounted) { message_screen("Reading SD card", ""); sd_mount(); }
        if (!sd_mounted) { message_screen("No SD card", "Insert a FAT32 or exFAT card"); wait_ms(1500); osd_invalidate(); go(P_LIBRARY, 1); break; }
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
        osd_invalidate();
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
        osd_invalidate();
        go(P_CART, 0);
        break;
    case I_FLASH_GAME:
        fl_sel = it->arg;
        go(P_FLACT, 0);
        break;
    case I_FL_PLAY:
        if (load_game(1, fl_sel, 0) == 0) return 1;
        osd_invalidate();
        go(P_FLACT, 1);
        break;
    case I_FL_DEL:
        message_screen("Deleting", fl_dir[fl_sel].name);
        flash_del_game(fl_sel);
        extra_save();
        osd_invalidate();
        strcpy(page_title, "Internal Flash");
        go(P_BROWSER, 0);
        break;
    case I_COPY_FLASH:
        if (flash_add_game(act_path) == 0) { message_screen("Copied to flash", page_title); wait_ms(1000); }
        osd_invalidate();
        go(P_FILEACT, 1);
        break;
    case I_PG_RECENT: go(P_RECENT, 0); break;
    case I_PG_TOOLS: go(P_TOOLS, 0); break;
    case I_GALLERY:
        if (!sd_mounted) sd_mount();
        strcpy(gallery_root, gallery_roots[it->arg]); strcpy(gallery_dir, gallery_root);
        go(P_GALLERY, 0); break;
    case I_GUP: gallery_parent(); go(P_GALLERY, 0); break;
    case I_GDIR: {
        char path[256];
        if (strlen(gallery_dir) + strlen(it->label) + 2 > sizeof path) break;
        sfmt(path, sizeof path, "%s%s%s", gallery_dir, !strcmp(gallery_dir, "/") ? "" : "/", it->label);
        strcpy(gallery_dir, path); go(P_GALLERY, 0); break;
    }
    case I_GPHOTO: {
        char path[520]; int keep_cursor = cursor;
        sfmt(path, sizeof path, "%s%s%s", gallery_dir, !strcmp(gallery_dir, "/") ? "" : "/", it->label);
        gallery_view(path); go(P_GALLERY, 0); cursor = keep_cursor; break;
    }
    case I_LASTPRINT:
        vprn_view();
        go(P_TOOLS, 1);
        break;
    case I_PRINTER:
        printer_run();
        build_cats();
        go(P_TOOLS, 0);
        break;
    case I_RECENT: {
        recent_t r = ex.rec[it->arg];
        int ok = -1;
        if (r.src == 2) { if (!sd_mounted) sd_mount(); ok = load_game(2, 0, r.path); }
        else if (r.src == 1 && r.idx < fl_count) ok = load_game(1, r.idx, 0);
        else if (r.src == 3) { cart_probe(); ok = load_game(3, 0, 0); }
        if (ok == 0) return 1;
        osd_invalidate();
        go(P_RECENT, 1);
        break;
    }
    case I_SHOT: {
        char nm[32];
        message_screen("Screenshot", "saving to the SD card");
        if (screenshot(nm, sizeof nm) == 0) sfmt(shot_msg, sizeof shot_msg, "%s", nm);
        else strcpy(shot_msg, "failed");
        osd_invalidate();
        go(page, 1);
        break;
    }
    case I_PG_CHEATS: go(P_CHEATS, 0); break;
    case I_CHEAT: ch_sel = it->arg; go(P_CHEATACT, 0); break;
    case I_CHEAT_TOGGLE: {
        cheatset_t *cs = cheats_for(0);
        if (cs) { cs->on ^= (uint8_t)(1 << ch_sel); ex_dirty = 1; cheats_apply(); extra_save(); }
        go(P_CHEATACT, 1);
        break;
    }
    case I_CHEAT_ADD:
    case I_CHEAT_EDIT: {
        cheatset_t *cs = cheats_for(0);
        ed_slot = it->id == I_CHEAT_EDIT ? ch_sel : -1;
        for (int i = 0; i < 9; i++) ed_dig[i] = i < 6 ? 0 : 16;
        if (ed_slot >= 0 && cs)
            for (int i = 0; i < 9; i++) { int v = hexval(cs->code[ed_slot][i]); ed_dig[i] = v < 0 ? 16 : (uint8_t)v; }
        ed_pos = 0;
        go(P_CODE, 0);
        break;
    }
    case I_CHEAT_DEL: {
        cheatset_t *cs = cheats_for(0);
        if (cs && ch_sel < cs->n) {
            memmove(cs->code[ch_sel], cs->code[ch_sel + 1], (cs->n - 1 - ch_sel) * sizeof cs->code[0]);
            uint8_t lo = cs->on & ((1 << ch_sel) - 1), hi = (uint8_t)((cs->on >> (ch_sel + 1)) << ch_sel);
            cs->on = lo | hi;
            cs->n--;
            ex_dirty = 1;
            cheats_apply();
            extra_save();
        }
        go(P_CHEATS, 0);
        break;
    }
    case I_PG_UPDATE:
        message_screen("System Update", "looking at the SD card");
        upd_probe();
        osd_invalidate();
        go(P_UPDATE, 0);
        break;
    case I_UPD_FW:
    case I_UPD_FPGA: {
        updfile_t *u = it->id == I_UPD_FPGA ? &upd_fpga : &upd_fw;
        if (!u->present || !u->valid) { message_screen(u->present ? "File is not valid" : "File not found", it->id == I_UPD_FPGA ? UPD_FPGA + 1 : UPD_FW + 1); wait_ms(1500); osd_invalidate(); break; }
        upd_sel = it->id == I_UPD_FPGA;
        go(P_UPDCONFIRM, 0);
        cursor = 1;
        break;
    }
    case I_UPD_GO: {
        int r = upd_install(upd_sel);
        wait_ms(600);
        if (r) message_screen("Verify failed", upd_sel ? "write it again or use the PC" : "write it again before restarting");
        else if (upd_sel) message_screen("Bitstream installed", "switch the power off and on");
        else message_screen("Firmware installed", "restarting");
        wait_ms(r || upd_sel ? 3000 : 1200);
        reboot_firmware();                              // the game ROM area held the file
        osd_invalidate();
        go(P_UPDATE, 0);
        break;
    }
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
        osd_invalidate();
        build_cats();
        go(P_SYSTEM, 1);
        break;
    }
    }
    return 0;
}

// B: one level up; returns 1 when the menu should close
static int back(void) {
    if (two_level() && page == cats[cat].page) { focus = 0; return 0; }
    switch (page) {
    case P_GALLERY:
        if (!strcmp(gallery_dir, gallery_root)) go(P_TOOLS, 0);
        else { gallery_parent(); go(P_GALLERY, 0); }
        break;
    case P_CHOICE: go(ch_ret_page, 0); cursor = ch_ret_cursor; break;
    case P_CHEATACT: go(P_CHEATS, 0); cursor = ch_sel; break;
    case P_CODE: go(ed_slot >= 0 ? P_CHEATACT : P_CHEATS, 0); break;
    case P_FLACT: strcpy(page_title, "Internal Flash"); go(P_BROWSER, 0); cursor = fl_sel; break;
    case P_UPDCONFIRM: go(P_UPDATE, 0); cursor = upd_sel ? 2 : 1; break;
    case P_MAIN: return game.loaded || home_running;
    case P_BROWSER:
        if (page_title[0] != 'I' && strcmp(cur_dir, "/")) {
            char *sl = strrchr(cur_dir, '/');
            if (sl == cur_dir) cur_dir[1] = 0; else if (sl) *sl = 0;
            go(P_BROWSER, 0);
        } else { go(P_LIBRARY, 0); cursor = page_title[0] == 'I' ? 1 : 0; }
        break;
    case P_CART: go(P_LIBRARY, 0); cursor = 2; break;
    case P_FILEACT:
        page_title[0] = 'S';
        go(P_BROWSER, 0);
        cursor = br_cursor < nitems ? br_cursor : 0;
        scroll = br_scroll;
        break;
    default: {
        if (two_level()) { go_home(0); break; }
        int from = page;
        go(P_MAIN, 0);
        for (int i = 0; i < nitems; i++)
            if ((from == P_DISPLAY && items[i].id == I_PG_DISPLAY) || (from == P_AUDIO && items[i].id == I_PG_AUDIO) ||
                (from == P_CONTROLS && items[i].id == I_PG_CONTROLS) || (from == P_SYSTEM && items[i].id == I_PG_SYSTEM) ||
                (from == P_INFO && items[i].id == I_PG_INFO) || (from == P_POWER && items[i].id == I_PG_POWER) ||
                (from == P_LIBRARY && items[i].id == I_LIBRARY)) cursor = i;
    }
    }
    return 0;
}

static void menu_run(void) {
    menu_active = 1;
    playtime_flush();
    extra_save();
    shot_msg[0] = 0;
    if (set.autosave && game.save_pending) save_write();
    ctrl_bits(C_OSD | C_DIM, 1);
    if (!home_running) ctrl_bits(C_PAUSE, 1);      // the home screen keeps playing behind the menu
    osd_invalidate();
    wait_release();
    lcd_dimmed = 0;
    apply_settings();
    focus = 0;
    cat = 0;
    go_home(0);
    int quit = 0;
    uint32_t refresh = ms_now();
    while (!quit) {
        draw_menu();
        uint32_t k = poll_keys(mq_on ? 250 : page == P_INFO || page == P_GAME || page == P_MAIN ? 1000 : 5000);
        status_poll();
        uint32_t now = ms_now();
        if (sleep_after_ms() && (now - last_input_ms) > sleep_after_ms()) { do_sleep(); osd_invalidate(); }
        if (!k) {
            if (now - refresh > 900 && (page == P_INFO || page == P_GAME || page == P_MAIN)) { build_page(); refresh = now; }
            continue;
        }
        if (k & K_SEL) { lcd_dump(); continue; }    // LCD screenshot for tools/lcd_shot.py
        if (page == P_CODE) {
            ed_err = 0;
            if (k & (K_UP | K_DOWN)) {
                int mx = ed_pos >= 6 ? 17 : 16, v = ed_dig[ed_pos];
                ed_dig[ed_pos] = (uint8_t)((k & K_UP) ? (v + 1) % mx : (v + mx - 1) % mx);
                snd_move();
            }
            if (k & K_LEFT)  { ed_pos = ed_pos ? ed_pos - 1 : 8; snd_move(); }
            if (k & K_RIGHT) { ed_pos = (ed_pos + 1) % 9; snd_move(); }
            if (k & (K_A | K_X)) code_save();
            else if (k & (K_B | K_Y)) { snd_back(); back(); }
            continue;
        }
        if (k & (K_A | K_X)) snd_ok();
        else if (k & (K_B | K_Y)) snd_back();
        else if (k & (K_UP | K_DOWN | K_LEFT | K_RIGHT | K_L | K_R)) snd_move();
        if ((k & (K_START | K_S1 | K_UMENU)) && (game.loaded || home_running)) break;
        if (k & K_S2 || k & K_URESET) { reset_game(); break; }

        if (two_level() && focus == 0) {
            // category level: Ozone moves up / down, XMB left / right
            int prev = (set.theme == TH_OZONE) ? K_UP : K_LEFT;
            int next = (set.theme == TH_OZONE) ? K_DOWN : K_RIGHT;
            int enter = K_A | K_X | ((set.theme == TH_OZONE) ? K_RIGHT : K_DOWN);
            if (k & prev) { cat = cat ? cat - 1 : ncats - 1; go(cats[cat].page, 0); }
            if (k & next) { cat = (cat + 1) % ncats; go(cats[cat].page, 0); }
            if ((k & enter) && nitems) {
                focus = 1;
                // one-action categories run directly on A
                if ((k & (K_A | K_X)) && nitems == 1 && items[0].id != I_OPT) quit = activate(&items[0], 1);
            }
            if (k & (K_B | K_Y)) { if (game.loaded || home_running) break; }
            continue;
        }

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
        if ((k & K_L) && nitems) { cursor -= 14; if (cursor < 0) cursor = 0; }
        if ((k & K_R) && nitems) { cursor += 14; if (cursor >= nitems) cursor = nitems - 1; }
        if (nitems && cursor < nitems) {
            item_t *it = &items[cursor];
            if ((k & (K_LEFT | K_RIGHT)) && it->id == I_OPT) activate(it, (k & K_LEFT) ? -1 : 1);
            else if ((k & K_LEFT) && set.theme == TH_OZONE && page == cats[cat].page) focus = 0;
            else if ((k & (K_A | K_X)) && it->id == I_OPT && set.theme == TH_AOS) open_choice(it);
            else if (k & (K_A | K_X)) quit = activate(it, 1);
        }
        if (!quit && (k & (K_B | K_Y))) quit = back();
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
        logf("fps %u%s\n", fps, (ctrl & C_FAST) ? " (fast forward)" : "");
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
        settings_v2_t o;
        settings_v3_t o3;
        flash_read(set_addr, &t, sizeof t);
        flash_read(set_addr, &o, sizeof o);
        flash_read(set_addr, &o3, sizeof o3);
        if (t.magic == SET_MAGIC && t.sum == sum32(&t, sizeof t - 4)) set = t;
        else if (o3.magic == SET_MAGIC_V3 && o3.sum == sum32(&o3, sizeof o3 - 4)) {
            memcpy(&set.disp_mode, o3.b, 28);
            memcpy(set.last_path, o3.last_path, sizeof set.last_path);
            set.menu_snd = 1;
            set.link_en = 0;
        }
        else if (o.magic == SET_MAGIC_V2 && o.sum == sum32(&o, sizeof o - 4)) {
            memcpy(&set.disp_mode, o.b, 20);               // fields up to spk_boost
            strncpy(set.last_path, o.last_path, sizeof set.last_path - 1);
            set.spk_mode = o.spk_mode;
            if (o.power_mode) { set.sdram_pd = 1; set.lcd_slow = 1; set.dim_idx = 2; set.poll_slow = 1; set.hdmi_off = 1; }
        }
        if (set.theme >= 8) set.theme = 1;
        if (set.home_scene > 3) set.home_scene = 0;
        if (set.vprinter > 1) set.vprinter = 0;
        set_stored = set;
    }
    apply_settings();
    extra_load();
    flash_dir_read();
    logf("flash games: %d\n", fl_count);
    sd_mount();
    cart_probe();
    lcd_clear(AT(CL_WHITE, CL_SHADE));
    lcd_present();
    osd_invalidate();

    int started = 0;
    logf("start-up: menu %d, last src %d idx %d, theme %d\n", set.boot_menu, set.last_src, set.last_flash, set.theme);
    if (!set.boot_menu) {
        if (set.last_src == 2 && sd_mounted && set.last_path[0]) started = load_game(2, 0, set.last_path) == 0;
        if (!started && set.last_src == 3 && cart_valid) started = load_game(3, 0, 0) == 0;
        if (!started && set.last_src == 1 && set.last_flash < fl_count) started = load_game(1, set.last_flash, 0) == 0;
        if (!started && fl_count) started = load_game(1, 0, 0) == 0;
    }
    ctrl &= ~(C_OSD | C_DIM);
    ctrl_write();
    if (!started) {
        start_home();
        // the intro plays for about 3.5 s, then the menu opens; a button opens it at once
        uint32_t t0 = ms_now();
        wait_release();
        while (ms_now() - t0 < 3500 && !(REG_IN & (K_PAD | K_S1))) { REG_WAIT = 100; (void)REG_WAIT; }
        menu_run();
    }
    flash_sleep();

    uint32_t s1_down = 0, s2_down = 0, pt_last = ms_now();
    int s1_long = 0, s2_long = 0;
    uint32_t dbg_ms = 0;
    last_input_ms = ms_now();
    held = REG_IN & 0xFFFF;
    for (;;) {
        if (!(set.vprinter && game.loaded && (pr.pos || ms_now() - pr.last_ms < 20))) scr_poll();
        REG_WAIT = scr_on ? (scr_aud ? 2 : 8) : (held & (K_S1 | K_S2)) ? 50 : set.poll_slow ? 500 : 200;
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
            set.hdmi_off ^= 1;
            apply_settings();
            settings_save();
            toast(set.hdmi_off ? "HDMI off" : "HDMI on", G_DISPLAY, CL_BLUE);
        }
        // S2: short press = reset game, hold 1 s = battery mode on / off
        if (press & K_S2) { s2_down = now; s2_long = 0; }
        if ((in & K_S2) && !s2_long && now - s2_down >= 1000) {
            s2_long = 1;
            int to_batt = preset_now() != 1;
            preset_apply(to_batt);
            settings_save();
            logf("power preset: %s\n", to_batt ? "battery" : "normal");
            if (!to_batt) toast("Normal power", G_POWER, CL_GB3);
        }
        int open = ((rel & K_S1) && !s1_long && now - s1_down >= 20) || (press & K_UMENU) ||
                   ((in & K_SEL) && (in & K_START) && (press & (K_SEL | K_START)));
        if (home_running && (press & (K_A | K_X | K_START))) open = 1;     // PRESS START
        if (set.vprinter && game.loaded && !(REG_ID & 8)) {
            vprn_poll(now);
            // Keep servicing byte events while a packet is in flight. I2C status,
            // autosave and screen work can otherwise delay the printer's reply.
            if (pr.pos || now - pr.last_ms < 20) continue;
        }
        status_poll();
        // play time (gaps over 5 s are the menu or sleep), fast forward, screenshot on L
        if (game.loaded && !(ctrl & C_PAUSE) && now - pt_last < 5000) play_ms += now - pt_last;
        pt_last = now;
        int ff = game.loaded && (ff_on || (in & K_R));
        if (ff != !!(ctrl & C_FAST)) ctrl_bits(C_FAST, ff);
        if ((press & K_L) && game.loaded) {
            if (screenshot(0, 0) == 0) toast("Screenshot saved", G_CHECK, CL_GB3);
            else toast("Screenshot failed", G_INFO, CL_RED);
        }
        if (((rel & K_S2) && !s2_long && now - s2_down >= 20) || (press & K_URESET)) reset_game();

        uint32_t st = stat_read();
        if (st & 4) { game.save_pending = 1; game.dirty_ms = now; }
        if (open) {
            if (toast_until) { toast_until = 0; ctrl_bits(C_OSD, 0); }
            menu_run();
            continue;
        }
        if (set.autosave && game.save_pending && now - game.dirty_ms > 2000) {
            if (save_write() == 0 && set.toasts) toast("Saved", G_CHECK, CL_GB3);
        }
        if (toast_until && (int32_t)(now - toast_until) > 0) {
            toast_until = 0;
            if (!menu_active) ctrl_bits(C_OSD, 0);
        }
        if (set.dbg_on && now - dbg_ms >= 250) { dbg_ms = now; dbg_update(st); }
        if (sleep_after_ms() && now - last_input_ms > sleep_after_ms()) do_sleep();
        // LCD auto-dim after a while without input, any button brings it back
        int dim = set.dim_idx && now - last_input_ms > dim_seconds[set.dim_idx & 3] * 1000u;
        if (dim != lcd_dimmed) { lcd_dimmed = dim; apply_settings(); }
    }
}
