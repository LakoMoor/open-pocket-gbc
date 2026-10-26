// Included after the menu model and SD browser in main.c; no extra heap or ROM swap.
static char gallery_dir[256] = "/", gallery_root[32] = "/";
static const char *const gallery_roots[] = { "/Screenshots", "/Prints", "/" };

static void gallery_parent(void) {
    char *slash = strrchr(gallery_dir, '/');
    if (slash == gallery_dir) gallery_dir[1] = 0;
    else if (slash) *slash = 0;
}

static void build_gallery(void) {
    nitems = pool_used = 0;
    if (strcmp(gallery_dir, gallery_root)) add(I_GUP, G_CHEV_L, "..", "Parent folder");
    DIR d; FILINFO fi;
    if (!sd_mounted || f_opendir(&d, gallery_dir) != FR_OK) {
        add_info("No pictures", "Insert SD / folder not found"); return;
    }
    int first = nitems;
    while (f_readdir(&d, &fi) == FR_OK && fi.fname[0]) {
        if (fi.fname[0] == '.' || (fi.fattrib & (AM_HID | AM_SYS))) continue;
        int dir = !!(fi.fattrib & AM_DIR);
        const char *ext = strrchr(fi.fname, '.');
        if (!dir && (!ext || strcasecmp(ext, ".bmp"))) continue;
        int bytes = (int)strlen(fi.fname) + 1;
        if (pool_used + bytes > (int)sizeof name_pool || nitems >= MAX_ITEMS) break;
        char *name = name_pool + pool_used; memcpy(name, fi.fname, bytes); pool_used += bytes;
        item_t *it = add(dir ? I_GDIR : I_GPHOTO, dir ? G_FOLDER : G_DISPLAY, name,
                        dir ? "Open folder" : "BMP: A fit / actual size, arrows pan, B back. HDMI and LCD.");
        if (!dir) sfmt(it->value, sizeof it->value, "%u KB", (unsigned)(fi.fsize / 1024));
    }
    f_closedir(&d);
    for (int i = first + 1; i < nitems; i++) {
        item_t item = items[i]; int j = i - 1;
        while (j >= first && ((item.id == I_GDIR && items[j].id != I_GDIR) ||
               (item.id == items[j].id && strcasecmp(item.label, items[j].label) < 0))) {
            items[j + 1] = items[j]; j--;
        }
        items[j + 1] = item;
    }
    if (!nitems) add_info("No BMP pictures", "Screenshots and prints save here");
}

static void gallery_view(const char *path) {
    if (!(REG_ID & 16)) { message_screen("Update the bitstream", "Gallery needs bitstream 1.9.2+"); wait_ms(1800); return; }
    FIL file; UINT count; uint8_t header[54]; bmp_info_t image;
    if (f_open(&file, path, FA_READ) != FR_OK) { message_screen("Can't open photo", "Check the SD card"); wait_ms(1200); return; }
    if (f_size(&file) > 0xFFFFFFFFu || f_read(&file, header, sizeof header, &count) != FR_OK || count != sizeof header ||
        bmp_parse(header, (uint32_t)f_size(&file), &image)) {
        f_close(&file); message_screen("Unsupported photo", "Use 24 / 32-bit RGB BMP"); wait_ms(1800); return;
    }
    uint32_t status = stat_read(), saved = ctrl, saved_cfg = REG_CFG, buffer = (status >> 3) & 3;
    if (buffer > 2) buffer = 0;
    volatile uint32_t *fb = (volatile uint32_t *)sdram(FB_BASE + buffer * 0x10000u);
    volatile uint32_t *backup = (volatile uint32_t *)sdram(0x730000u);
    ctrl = (ctrl | C_PAUSE | C_IMAGE) & ~C_DIM; ctrl_write();
    REG_CFG = saved_cfg & ~(1u << 6); // the complete photo canvas, independent of game crop mode
    for (int i = 0; i < 160 * 144 / 2; i++) backup[i] = fb[i];
    osd_clear(AT(CL_WHITE, CL_GAME)); osd_present();
    static uint8_t row[4096 * 4];
    int fit = !(image.width <= 160 && image.height > 144), pan_x = 0, pan_y = 0, bad = 0;
    wait_release();
    for (int redraw = 1;;) {
        if (redraw) {
            uint32_t w = image.width, h = image.height;
            if (fit && (w > 160 || h > 144)) {
                if (w * 144 > h * 160) { h = h * 160 / w; w = 160; }
                else { w = w * 144 / h; h = 144; }
                if (!w) w = 1;
                if (!h) h = 1;
            }
            uint32_t dw = w > 160 ? 160 : w, dh = h > 144 ? 144 : h;
            int left = (160 - (int)dw) / 2, top = (144 - (int)dh) / 2, cached_y = -1;
            for (int y = 0; y < 144 && !bad; y++) {
                int sy = -1;
                if (y >= top && y < top + (int)dh) sy = fit ? (int)((y - top) * image.height / h) : y - top + pan_y;
                if (sy >= 0 && sy < (int)image.height && sy != cached_y) {
                    uint32_t disk_y = image.top_down ? (uint32_t)sy : image.height - 1 - (uint32_t)sy;
                    if (f_lseek(&file, image.offset + disk_y * image.stride) != FR_OK ||
                        f_read(&file, row, image.stride, &count) != FR_OK || count != image.stride) { bad = 1; break; }
                    cached_y = sy;
                }
                for (int x = 0; x < 160; x += 2) {
                    uint32_t pair = 0;
                    for (int n = 0; n < 2; n++) {
                        int dx = x + n - left; uint16_t pixel = 0;
                        if (sy >= 0 && dx >= 0 && dx < (int)dw) {
                            uint32_t sx = fit ? (uint32_t)dx * image.width / w : (uint32_t)(dx + pan_x);
                            const uint8_t *p = row + sx * image.bytes_per_pixel;
                            pixel = rgb15((uint32_t)p[2] << 16 | (uint32_t)p[1] << 8 | p[0]);
                        }
                        pair |= (uint32_t)pixel << (n * 16);
                        REG_IMAGE = pixel | ((x + n == 0 && y == 0) ? 0x8000u : 0);
                    }
                    fb[(y * 160 + x) / 2] = pair;
                }
            }
            redraw = 0;
        }
        if (bad) break;
        uint32_t key = poll_keys(1000);
        if (key & (K_B | K_Y | K_START | K_S1 | K_UMENU)) break;
        if (key & (K_A | K_X)) { fit ^= 1; pan_x = pan_y = 0; redraw = 1; }
        if (!fit) {
            int max_x = image.width > 160 ? (int)image.width - 160 : 0;
            int max_y = image.height > 144 ? (int)image.height - 144 : 0;
            if (key & K_RIGHT) { pan_x += 8; if (pan_x > max_x) pan_x = max_x; redraw = 1; }
            if (key & K_LEFT) { pan_x -= 8; if (pan_x < 0) pan_x = 0; redraw = 1; }
            if (key & K_DOWN) { pan_y += 8; if (pan_y > max_y) pan_y = max_y; redraw = 1; }
            if (key & K_UP) { pan_y -= 8; if (pan_y < 0) pan_y = 0; redraw = 1; }
        }
    }
    f_close(&file);
    REG_CFG = saved_cfg;
    for (int i = 0; i < 160 * 144 / 2; i++) {
        uint32_t pair = backup[i]; fb[i] = pair;
        REG_IMAGE = rgb15(pix_rgb(pair & 0x7FFF, status & 1)) | (i == 0 ? 0x8000u : 0);
        REG_IMAGE = rgb15(pix_rgb((pair >> 16) & 0x7FFF, status & 1));
    }
    ctrl = saved; ctrl_write(); osd_invalidate(); wait_release();
    if (bad) { message_screen("Photo read failed", "Check the SD card"); wait_ms(1200); }
}
