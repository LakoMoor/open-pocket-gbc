// OSD drawing into shadow buffers; osd_present copies only the changed cells.
#include "osd.h"
#include "util.h"

static uint16_t back[OSD_W * OSD_H];
static uint16_t front[OSD_W * OSD_H];
static uint16_t lback[LCD_W * LCD_H], lfront[LCD_W * LCD_H];
static int      front_valid, lfront_valid;
uint32_t        osd_version, lcd_version;     // bumped when the shown cells change (screen stream)

void osd_clear(uint8_t attr) {
    uint16_t v = ((uint16_t)attr << 8) | ' ';
    for (int i = 0; i < OSD_W * OSD_H; i++) back[i] = v;
}

void osd_put(int x, int y, uint8_t ch, uint8_t attr) {
    if (x < 0 || y < 0 || x >= OSD_W || y >= OSD_H) return;
    back[y * OSD_W + x] = ((uint16_t)attr << 8) | ch;
}

int osd_textn(int x, int y, const char *s, int maxw, uint8_t attr) {
    while (*s && maxw-- > 0) {
        uint8_t c = (uint8_t)*s++;
        if (c >= 0x80) c = '?';
        osd_put(x++, y, c, attr);
    }
    return x;
}
int osd_text(int x, int y, const char *s, uint8_t attr) { return osd_textn(x, y, s, OSD_W, attr); }

void osd_fill(int x, int y, int w, uint8_t ch, uint8_t attr) {
    while (w-- > 0) osd_put(x++, y, ch, attr);
}

void osd_rtext(int xr, int y, const char *s, uint8_t attr) {
    int n = 0;
    while (s[n]) n++;
    osd_text(xr - n, y, s, attr);
}

// rounded bar: ends drawn in the fill colour over the outside colour
void osd_pill(int x, int y, int w, uint8_t fill, uint8_t outside) {
    osd_put(x, y, G_PILL_L | EXT, AT(fill, outside));
    osd_fill(x + 1, y, w - 2, ' ', AT(CL_BLACK, fill));
    osd_put(x + w - 1, y, G_PILL_R | EXT, AT(fill, outside));
}

void osd_invalidate(void) { front_valid = 0; lfront_valid = 0; }

void osd_present(void) {
    for (int i = 0; i < OSD_W * OSD_H; i++) {
        if (!front_valid || front[i] != back[i]) {
            front[i] = back[i];
            OSD_RAM[i] = back[i];
            osd_version++;
        }
    }
    front_valid = 1;
}

void lcd_clear(uint8_t attr) {
    for (int i = 0; i < LCD_W * LCD_H; i++) lback[i] = ((uint16_t)attr << 8) | ' ';
}

void lcd_put(int x, int y, uint8_t ch, uint8_t attr) {
    if (x < 0 || y < 0 || x >= LCD_W || y >= LCD_H) return;
    lback[y * LCD_W + x] = ((uint16_t)attr << 8) | ch;
}

int lcd_textn(int x, int y, const char *s, int maxw, uint8_t attr) {
    while (*s && x < LCD_W && maxw-- > 0) {
        uint8_t c = (uint8_t)*s++;
        lcd_put(x++, y, c >= 0x80 ? '?' : c, attr);
    }
    return x;
}

int lcd_text(int x, int y, const char *s, uint8_t attr) { return lcd_textn(x, y, s, LCD_W, attr); }

void lcd_fill(int x, int y, int w, uint8_t ch, uint8_t attr) {
    while (w-- > 0) lcd_put(x++, y, ch, attr);
}

// rounded bar from x, w cells wide
void lcd_pillx(int x, int y, int w, uint8_t fill, uint8_t outside) {
    lcd_put(x, y, G_PILL_L | EXT, AT(fill, outside));
    lcd_fill(x + 1, y, w - 2, ' ', AT(CL_BLACK, fill));
    lcd_put(x + w - 1, y, G_PILL_R | EXT, AT(fill, outside));
}
void lcd_pill(int y, uint8_t fill, uint8_t outside) { lcd_pillx(0, y, LCD_W, fill, outside); }

// the LCD and HDMI menu text buffers as hex lines on the log (tools/lcd_shot.py renders them)
void lcd_dump(void) {
    static const char hx[] = "0123456789abcdef";
    logf("LCD-BEGIN\n");
    for (int y = 0; y < LCD_H; y++) {
        char b[LCD_W * 4 + 2];
        for (int x = 0; x < LCD_W; x++) {
            uint16_t v = lback[y * LCD_W + x];
            for (int k = 0; k < 4; k++) b[x * 4 + k] = hx[(v >> (12 - 4 * k)) & 15];
        }
        b[LCD_W * 4] = '\n'; b[LCD_W * 4 + 1] = 0;
        logf("%s", b);
    }
    logf("LCD-END\nOSD-BEGIN\n");
    for (int y = 0; y < OSD_H; y++) {
        for (int h = 0; h < 2; h++) {                    // two halves: logf has a 160 byte buffer
            char b[OSD_W / 2 * 4 + 2];
            for (int x = 0; x < OSD_W / 2; x++) {
                uint16_t v = back[y * OSD_W + h * (OSD_W / 2) + x];
                for (int k = 0; k < 4; k++) b[x * 4 + k] = hx[(v >> (12 - 4 * k)) & 15];
            }
            b[OSD_W / 2 * 4] = h ? '\n' : 0; b[OSD_W / 2 * 4 + 1] = 0;
            logf("%s", b);
        }
    }
    logf("OSD-END\n");
}

const uint16_t *osd_cells(void) { return front; }
const uint16_t *lcd_cells(void) { return lfront; }

void lcd_present(void) {
    for (int i = 0; i < LCD_W * LCD_H; i++) {
        if (!lfront_valid || lfront[i] != lback[i]) {
            lfront[i] = lback[i];
            LCD_TXT[i] = lback[i];
            lcd_version++;
        }
    }
    lfront_valid = 1;
}
