// On-screen display: 42 x 24 cells on HDMI, 16 x 16 cells on the SPI LCD.
#pragma once
#include "hw.h"
#include "glyphs.h"

#define OSD_W 42
#define OSD_H 24
#define LCD_W 16
#define LCD_H 12

// colours (rtl/video/video_out.sv pal16)
enum {
    CL_GAME = 0, CL_BLACK, CL_BG, CL_PANEL, CL_LINE, CL_GREY, CL_LIGHT, CL_WHITE,
    CL_BLUE, CL_GREEN, CL_YELLOW, CL_RED, CL_PURPLE, CL_NAVY, CL_TEAL, CL_SHADE
};
#define AT(fg, bg) ((uint8_t)(((bg) << 4) | (fg)))
#define EXT 0x80            // repeat top / bottom glyph rows into the cell padding

void osd_clear(uint8_t attr);
void osd_put(int x, int y, uint8_t ch, uint8_t attr);
int  osd_text(int x, int y, const char *s, uint8_t attr);         // returns the next x
int  osd_textn(int x, int y, const char *s, int maxw, uint8_t attr);
void osd_fill(int x, int y, int w, uint8_t ch, uint8_t attr);
void osd_rtext(int xr, int y, const char *s, uint8_t attr);        // right aligned, ends before xr
void osd_pill(int x, int y, int w, uint8_t fill, uint8_t outside);  // rounded bar
void osd_present(void);
void osd_invalidate(void);

void lcd_clear(uint8_t attr);
void lcd_put(int x, int y, uint8_t ch, uint8_t attr);
int  lcd_text(int x, int y, const char *s, uint8_t attr);   // returns the next x
void lcd_pill(int y, uint8_t fill, uint8_t outside);
void lcd_present(void);
