// OSD drawing into shadow buffers; osd_present copies only the changed cells.
#include "osd.h"

static uint16_t back[OSD_W * OSD_H];
static uint16_t front[OSD_W * OSD_H];
static uint16_t lback[LCD_W * LCD_H], lfront[LCD_W * LCD_H];
static int      front_valid, lfront_valid;

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

int lcd_text(int x, int y, const char *s, uint8_t attr) {
    while (*s && x < LCD_W) {
        uint8_t c = (uint8_t)*s++;
        lcd_put(x++, y, c >= 0x80 ? '?' : c, attr);
    }
    return x;
}

// full-width rounded bar
void lcd_pill(int y, uint8_t fill, uint8_t outside) {
    lcd_put(0, y, G_PILL_L | EXT, AT(fill, outside));
    for (int x = 1; x < LCD_W - 1; x++) lcd_put(x, y, ' ', AT(CL_BLACK, fill));
    lcd_put(LCD_W - 1, y, G_PILL_R | EXT, AT(fill, outside));
}

void lcd_present(void) {
    for (int i = 0; i < LCD_W * LCD_H; i++) {
        if (!lfront_valid || lfront[i] != lback[i]) {
            lfront[i] = lback[i];
            LCD_TXT[i] = lback[i];
        }
    }
    lfront_valid = 1;
}
