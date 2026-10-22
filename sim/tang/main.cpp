// Tang Nano 20K simulator: the whole gbc_top (Game Boy core, menu CPU, video, LCD) in
// Verilator, with models of what sits on the board: the SPI flash (firmware, games,
// settings), an SD card image, the ST7735 LCD, the buttons and the USB-UART.
//
//   tang_sim [--flash flash.bin] [--sd sd.img] [--cart rom.gb] [--no-hdmi] [--ms N] [--stdout-text]
//   --cart puts an original cartridge (MBC1/2/3/5) in the shift-register cartridge reader
//
// stdout carries binary messages for Open Pocket Studio: one type byte, a u32 length, data:
//   'L' UART log text   'C' LCD frame 128x128 RGB565   'T' sim ms (u32)
//   'B' HDMI band: u16 first row, u16 rows, rows x 720 RGB. A band goes out as soon as its
//       scanlines are drawn and only when it changed, so the picture builds up line by line
//       and a still menu costs nothing.
// stdin takes lines: "K <hex>" buttons (bit 0..7 up down left right a b select start, 8 S1, 9 S2),
//   "R <char>" a byte for the remote (USB-UART rx), "Q" quit. Without Studio: --stdout-text
//   prints the log only.
#include "Vsim_top.h"
#include "verilated.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <string>
#include <vector>
#include <deque>
#include <mutex>
#include <thread>
#include <atomic>
#ifdef _WIN32
#include <io.h>
#include <fcntl.h>
#endif

double sc_time_stamp() { return 0; }

static std::vector<uint8_t> flash(8 << 20, 0xFF), sdimg;
static bool text_only = false;
static std::mutex out_mu;

static void msg(char type, const void *data, uint32_t n) {
    std::lock_guard<std::mutex> g(out_mu);
    if (text_only) { if (type == 'L') fwrite(data, 1, n, stdout), fflush(stdout); return; }
    fputc(type, stdout);
    fwrite(&n, 4, 1, stdout);
    fwrite(data, 1, n, stdout);
    fflush(stdout);
}

// ---------------------------------------------------------------- SPI slave around a byte device
template <class Dev> struct SpiSlave {
    Dev dev;
    int bit = 0, last_sck = 0, last_cs = 1, miso = 1;
    uint8_t in = 0, out = 0xFF;
    void step(int cs_n, int sck, int mosi) {
        if (cs_n) { if (!last_cs) dev.deselect(); bit = 0; last_cs = 1; last_sck = sck; miso = 1; return; }
        if (last_cs) { dev.select(); bit = 0; out = dev.first(); miso = (out >> 7) & 1; }
        last_cs = 0;
        if (sck && !last_sck) {                       // rising edge: sample
            in = (uint8_t)((in << 1) | (mosi & 1));
            if (++bit == 8) { bit = 0; out = dev.next(in); }
        }
        if (!sck && last_sck) {                       // falling edge: next bit out
            miso = (out >> 7) & 1;
            out <<= 1;
            if (bit == 0) out = out;                  // the new byte starts at its MSB (set in next())
        }
        last_sck = sck;
    }
};

// W25Q128-like flash: JEDEC ID ef4017, read 03, page program 02, erase 20 / d8
struct FlashDev {
    std::vector<uint8_t> *mem = &flash;
    uint32_t id = 0xEF4017;
    std::vector<uint8_t> cmd;
    bool wel = false, dirty = false;
    void select() { cmd.clear(); }
    uint8_t first() { return 0xFF; }
    uint32_t a24() const { return ((cmd[1] << 16) | (cmd[2] << 8) | cmd[3]) & (uint32_t)(mem->size() - 1); }
    uint8_t next(uint8_t b) {
        cmd.push_back(b);
        size_t n = cmd.size();
        switch (cmd[0]) {
            case 0x9F: return n == 1 ? (id >> 16) & 255 : n == 2 ? (id >> 8) & 255 : id & 255;
            case 0x05: return 0x00;
            case 0x06: wel = true; return 0xFF;
            case 0x04: wel = false; return 0xFF;
            case 0x03: return n >= 4 ? (*mem)[(a24() + n - 4) & (mem->size() - 1)] : 0xFF;
            case 0x02: if (n > 4 && wel) { uint32_t a = (a24() & ~0xFFu) | ((cmd[3] + n - 5) & 0xFF); (*mem)[a] &= b; } return 0xFF;
            case 0xAB: return 0xFF;
            default: return 0xFF;
        }
    }
    void deselect() {
        if (cmd.empty()) return;
        if (getenv("SIM_DEBUG")) { static int n = 0; if (n++ < 40) fprintf(stderr, "flash cmd %02x len %zu\n", cmd[0], cmd.size()); }
        if (cmd[0] == 0x20 && wel && cmd.size() >= 4) { std::fill(mem->begin() + (a24() & ~0xFFFu), mem->begin() + (a24() & ~0xFFFu) + 0x1000, 0xFF); wel = false; dirty = true; }
        if (cmd[0] == 0xD8 && wel && cmd.size() >= 4) { std::fill(mem->begin() + (a24() & ~0xFFFFu), mem->begin() + (a24() & ~0xFFFFu) + 0x10000, 0xFF); wel = false; dirty = true; }
        if (cmd[0] == 0x02) { wel = false; dirty = true; }
    }
};

// SD card in SPI mode (SDHC), the image in memory
struct SdDev {
    std::deque<uint8_t> q;
    std::vector<uint8_t> cmd, buf;
    int state = 0;                                    // 0 idle, 1 multi read, 2 wait token, 3 data
    bool multi = false, dirty = false;
    uint32_t rlba = 0, wlba = 0;
    void select() {}
    void deselect() {}
    uint8_t first() { return 0xFF; }
    void block(uint32_t lba) {
        q.push_back(0xFE);
        for (int i = 0; i < 512; i++) { size_t o = (size_t)lba * 512 + i; q.push_back(o < sdimg.size() ? sdimg[o] : 0); }
        q.push_back(0xFF); q.push_back(0xFF);
    }
    void command(int c, uint32_t arg) {
        q.clear();
        q.push_back(0xFF);
        switch (c) {
            case 0: q.push_back(0x01); break;
            case 8: for (uint8_t v : {0x01, 0x00, 0x00, 0x01}) q.push_back(v); q.push_back(arg & 0xFF); break;
            case 55: q.push_back(0x01); break;
            case 41: case 16: case 23: q.push_back(0x00); break;
            case 58: for (uint8_t v : {0x00, 0xC0, 0xFF, 0x80, 0x00}) q.push_back(v); break;
            case 9: {
                uint32_t cs = (uint32_t)(sdimg.size() / 512 >> 10) - 1;
                uint8_t csd[16] = {0x40};
                csd[7] = (cs >> 16) & 0x3F; csd[8] = (cs >> 8) & 0xFF; csd[9] = cs & 0xFF;
                q.push_back(0x00); q.push_back(0xFE);
                for (uint8_t v : csd) q.push_back(v);
                q.push_back(0xFF); q.push_back(0xFF);
                break;
            }
            case 17: q.push_back(0x00); block(arg); break;
            case 18: q.push_back(0x00); state = 1; rlba = arg; break;
            case 12: q.clear(); q.push_back(0xFF); q.push_back(0x00); state = 0; break;
            case 24: q.push_back(0x00); state = 2; multi = false; wlba = arg; break;
            case 25: q.push_back(0x00); state = 2; multi = true; wlba = arg; break;
            default: q.push_back(0x04); break;
        }
    }
    uint8_t pop() {
        if (q.empty() && state == 1) block(rlba++);
        if (q.empty()) return 0xFF;
        uint8_t v = q.front(); q.pop_front(); return v;
    }
    uint8_t next(uint8_t b) {
        if (sdimg.empty()) return 0xFF;
        if (state == 2) {
            if (b == 0xFE || b == 0xFC) { state = 3; buf.clear(); }
            else if (b == 0xFD) { state = 0; q.push_back(0x00); }
            return pop();
        }
        if (state == 3) {
            buf.push_back(b);
            if (buf.size() == 514) {
                size_t o = (size_t)wlba * 512;
                if (o + 512 <= sdimg.size()) memcpy(&sdimg[o], buf.data(), 512);
                dirty = true; wlba++;
                q.push_back(0x05); q.push_back(0x00); q.push_back(0xFF);
                state = multi ? 2 : 0;
            }
            return 0xFF;
        }
        if (cmd.empty() && (b & 0xC0) == 0x40) { cmd.push_back(b); if (b == 0x4C) { q.clear(); state = 0; } return 0xFF; }
        if (!cmd.empty()) {
            cmd.push_back(b);
            if (cmd.size() == 6) {
                command(cmd[0] & 0x3F, ((uint32_t)cmd[1] << 24) | (cmd[2] << 16) | (cmd[3] << 8) | cmd[4]);
                cmd.clear();
                return pop();
            }
            return 0xFF;
        }
        return pop();
    }
};

// ---------------------------------------------------------------- ST7735 LCD (writes only)
struct Lcd {
    uint16_t fb[128 * 128] = {};
    int bit = 0, last_scl = 0, ncmd = 0, cmd = 0;
    uint8_t in = 0, args[4] = {};
    int xs = 0, xe = 127, ys = 0, ye = 127, x = 0, y = 0, hi = -1;
    bool fresh = false;
    void step(int cs, int scl, int sda, int dc) {
        if (cs) { bit = 0; last_scl = scl; return; }
        if (scl && !last_scl) {
            in = (uint8_t)((in << 1) | (sda & 1));
            if (++bit == 8) { bit = 0; byte(in, dc); }
        }
        last_scl = scl;
    }
    void byte(uint8_t b, int dc) {
        if (!dc) { cmd = b; ncmd = 0; hi = -1; if (b == 0x2C) { x = xs; y = ys; } return; }
        if (cmd == 0x2A || cmd == 0x2B) {
            if (ncmd < 4) args[ncmd++] = b;
            if (ncmd == 4) {
                int a = (args[0] << 8 | args[1]), e = (args[2] << 8 | args[3]);
                if (cmd == 0x2A) { xs = a - 2; xe = e - 2; } else { ys = a - 3; ye = e - 3; }   // the module's window offsets
            }
            return;
        }
        if (cmd == 0x2C) {
            if (hi < 0) { hi = b; return; }
            uint16_t px = (uint16_t)(hi << 8 | b);
            hi = -1;
            if (x >= 0 && x < 128 && y >= 0 && y < 128) fb[y * 128 + x] = px;
            if (++x > xe) { x = xs; if (++y > ye) { y = ys; fresh = true; } }
        }
    }
};

// ---------------------------------------------------------------- stdin commands
static std::mutex in_mu;
static std::deque<std::string> in_lines;
static void reader() {
    char line[256];
    while (fgets(line, sizeof line, stdin)) { std::lock_guard<std::mutex> g(in_mu); in_lines.push_back(line); }
}

static bool load(const char *path, std::vector<uint8_t> &v, size_t at) {
    FILE *f = fopen(path, "rb");
    if (!f) return false;
    if (v.empty()) { fseek(f, 0, SEEK_END); v.resize(ftell(f)); fseek(f, 0, SEEK_SET); at = 0; }
    size_t n = fread(&v[at], 1, v.size() - at, f);
    fclose(f);
    return n > 0;
}
static void save(const char *path, const std::vector<uint8_t> &v) {
    FILE *f = fopen(path, "wb");
    if (f) { fwrite(v.data(), 1, v.size(), f); fclose(f); }
}

// ---------------------------------------------------------------- original-cartridge reader
// The shift-register reader on the cartridge port (docs/cart_reader.md) with a cartridge in it:
// 74HCT595 x4 (D out, control, A8-15, A0-7), 74LV165 (D in), and an MBC1/2/3/5 cartridge.
struct CartReader {
    std::vector<uint8_t> rom, ram;
    int mbc = 0;                                     // 0 none, 1 MBC1, 2 MBC2, 3 MBC3, 5 MBC5
    uint32_t sr = 0, out = 0xFFFFFFFF;
    uint8_t q = 0xFF;
    int last_clk = 0, last_cs = 1, miso = 1;
    int rom_bank = 1, ram_bank = 0, ram_en = 0, mode = 0, upper = 0;
    uint32_t writes = 0;
    void init() {
        uint8_t t = rom.size() > 0x147 ? rom[0x147] : 0;
        mbc = (t >= 1 && t <= 3) ? 1 : (t == 5 || t == 6) ? 2 : (t >= 0x0F && t <= 0x13) ? 3 : t == 0 ? 0 : 5;
        static const uint32_t rs[] = {0, 2048, 8192, 32768, 131072, 65536};
        uint8_t rc = rom.size() > 0x149 ? rom[0x149] : 0;
        ram.assign(mbc == 2 ? 512 : rc < 6 ? rs[rc] : 0, 0);
        for (size_t i = 0; i < ram.size(); i++) ram[i] = (uint8_t)(i * 7 + 3);   // a known "save"
    }
    uint8_t rd(uint16_t a, bool cs) {
        if (cs && a >= 0xA000 && a < 0xC000) {
            if (!ram_en || ram.empty()) return 0xFF;
            uint32_t o = mbc == 2 ? (a & 0x1FF) : ((uint32_t)(mbc == 1 && !mode ? 0 : ram_bank) << 13 | (a & 0x1FFF));
            return o < ram.size() ? (mbc == 2 ? (ram[o] | 0xF0) : ram[o]) : 0xFF;
        }
        if (cs || a >= 0x8000) return 0xFF;
        uint32_t bank;
        if (a < 0x4000) bank = (mbc == 1 && mode) ? (upper << 5) : 0;
        else if (mbc == 1) bank = (upper << 5) | (rom_bank ? rom_bank : 1);
        else if (mbc == 0) bank = 1;
        else bank = rom_bank;
        uint32_t o = (bank * 0x4000 + (a & 0x3FFF)) % (rom.empty() ? 1 : rom.size());
        return rom.empty() ? 0xFF : rom[o];
    }
    void wr(uint16_t a, uint8_t v, bool cs) {
        writes++;
        if (cs && a >= 0xA000 && a < 0xC000) {
            if (!ram_en || ram.empty()) return;
            uint32_t o = mbc == 2 ? (a & 0x1FF) : ((uint32_t)(mbc == 1 && !mode ? 0 : ram_bank) << 13 | (a & 0x1FFF));
            if (o < ram.size()) ram[o] = mbc == 2 ? (v & 0x0F) : v;
            return;
        }
        if (a >= 0x8000) return;
        switch (mbc) {
        case 1:
            if (a < 0x2000) ram_en = (v & 0x0F) == 0x0A;
            else if (a < 0x4000) rom_bank = v & 0x1F;
            else if (a < 0x6000) { upper = v & 3; ram_bank = v & 3; }
            else mode = v & 1;
            break;
        case 2:
            if (a < 0x4000) { if (a & 0x100) rom_bank = (v & 0x0F) ? (v & 0x0F) : 1; else ram_en = (v & 0x0F) == 0x0A; }
            break;
        case 3:
            if (a < 0x2000) ram_en = (v & 0x0F) == 0x0A;
            else if (a < 0x4000) rom_bank = (v & 0x7F) ? (v & 0x7F) : 1;
            else if (a < 0x6000) ram_bank = v & 3;
            break;
        case 5:
            if (a < 0x2000) ram_en = (v & 0x0F) == 0x0A;
            else if (a < 0x3000) rom_bank = (rom_bank & 0x100) | v;
            else if (a < 0x4000) rom_bank = (rom_bank & 0xFF) | ((v & 1) << 8);
            else if (a < 0x6000) ram_bank = v & 0x0F;
            break;
        }
    }
    uint8_t bus() {                                  // what the data bus shows now
        uint8_t ctl = out >> 16;
        uint16_t a = out & 0xFFFF;
        if (!(ctl & 0x10)) return out >> 24;         // our data driver is on
        if (!(ctl & 0x01)) return rd(a, !(ctl & 0x04));
        return 0xFF;                                 // pull-ups
    }
    void step(int cs_n, int clk, int mosi) {
        if (!cs_n) q = bus();                        // 165 /PL low: parallel load
        if (clk && !last_clk) {
            if (cs_n) q = (uint8_t)(q << 1);         // 165 shifts (DS = 0)
            sr = (sr << 1) | (mosi & 1);             // 595 chain shifts
        }
        if (cs_n && !last_cs) {                      // RCLK rising: outputs update
            uint32_t old = out;
            out = sr;
            uint8_t oc = old >> 16, nc = out >> 16;
            if ((oc & 0x02) && !(nc & 0x02) && !(nc & 0x10))   // /WR falls with data driven
                wr(out & 0xFFFF, out >> 24, !(nc & 0x04));
        }
        last_clk = clk; last_cs = cs_n;
        miso = (q >> 7) & 1;
    }
};

int main(int argc, char **argv) {
#ifdef _WIN32
    _setmode(_fileno(stdout), _O_BINARY);
#endif
    const char *flash_path = nullptr, *sd_path = nullptr, *cart_path = nullptr;
    bool hdmi = true;
    long max_ms = 0;
    for (int i = 1; i < argc; i++) {
        if (!strcmp(argv[i], "--flash") && i + 1 < argc) flash_path = argv[++i];
        else if (!strcmp(argv[i], "--sd") && i + 1 < argc) sd_path = argv[++i];
        else if (!strcmp(argv[i], "--cart") && i + 1 < argc) cart_path = argv[++i];
        else if (!strcmp(argv[i], "--no-hdmi")) hdmi = false;
        else if (!strcmp(argv[i], "--ms") && i + 1 < argc) max_ms = atol(argv[++i]);
        else if (!strcmp(argv[i], "--stdout-text")) text_only = true;
    }
    if (flash_path) load(flash_path, flash, 0);
    if (sd_path) load(sd_path, sdimg, 0);

    auto ctx = new VerilatedContext;
    std::vector<const char *> vargs(argv, argv + argc);
    if (!hdmi) vargs.push_back("+no_hdmi");          // stops the pixel clock in sim_prims.v
    ctx->commandArgs((int)vargs.size(), vargs.data());
    auto top = new Vsim_top{ctx};
    SpiSlave<FlashDev> fl;
    SpiSlave<SdDev> sd;
    Lcd lcd;
    CartReader cr;
    bool cart_on = cart_path && load(cart_path, cr.rom, 0);
    if (cart_on) cr.init();
    top->s1 = 0; top->s2 = 0; top->key_n = 0xFF; top->key_menu_n = 1; top->uart_rx = 1;
    top->sd_dat0 = 1; top->flash_miso = 1; top->cart_miso = 1;
    std::thread(reader).detach();

    const int BAND = 24;
    std::vector<uint8_t> frame(720 * 480 * 3), sent(720 * 480 * 3, 1), band(4 + 720 * BAND * 3);
    int last_vclk = 0, last_sclk = 0, last_cy = 0;
    int UDIV = 33750000 / 115200;                    // follows the firmware: 17 after "#SCR"
    bool uart_fast = false;
    int u_cnt = -1, u_bit = 0, u_byte = 0;          // UART tx decoder
    std::deque<uint8_t> rx_q;                        // remote bytes to send
    int rx_cnt = 0, rx_bit = -1, rx_byte = 0;
    std::string logbuf;
    uint64_t clk_sys_cycles = 0;
    uint32_t last_report = 0, last_lcd = 0, last_save = 0;
    unsigned keys = 0;
    bool quit = false;

    while (!quit && !ctx->gotFinish()) {
        top->eval();
        // ---- clk_sys edges: the slow board models
        if (top->clk_sys && !last_sclk) {
            clk_sys_cycles++;
            fl.step(top->flash_cs_n, top->flash_clk, top->flash_mosi);
            top->flash_miso = fl.miso;
            sd.step(top->sd_dat3, top->sd_clk, top->sd_cmd);
            top->sd_dat0 = sd.miso;
            lcd.step(top->lcd_cs, top->lcd_scl, top->lcd_sda, top->lcd_dc);
            if (cart_on) { cr.step(top->cart_cs_n, top->cart_clk, top->cart_mosi); top->cart_miso = cr.miso; }
            // UART tx -> log
            if (u_cnt < 0) { if (!top->uart_tx) { u_cnt = UDIV + UDIV / 2; u_bit = 0; u_byte = 0; } }
            else if (--u_cnt == 0) {
                if (u_bit < 8) { u_byte |= (top->uart_tx & 1) << u_bit; u_bit++; u_cnt = UDIV; }
                else {
                    if (uart_fast || u_byte != '\r') logbuf += (char)u_byte;
                    if (!uart_fast && u_byte == '\n' && logbuf.find("#SCR ") != std::string::npos) { UDIV = 17; uart_fast = true; }
                    u_cnt = -1;
                    if ((!uart_fast && u_byte == '\n') || logbuf.size() > 200) { msg('L', logbuf.data(), (uint32_t)logbuf.size()); logbuf.clear(); }
                }
            }
            // UART rx <- remote bytes
            if (rx_bit < 0 && !rx_q.empty()) { rx_byte = rx_q.front(); rx_q.pop_front(); rx_bit = 0; rx_cnt = UDIV; top->uart_rx = 0; }
            else if (rx_bit >= 0 && --rx_cnt == 0) {
                rx_cnt = UDIV;
                if (rx_bit < 8) { top->uart_rx = (rx_byte >> rx_bit) & 1; rx_bit++; }
                else if (rx_bit == 8) { top->uart_rx = 1; rx_bit++; }
                else rx_bit = -1;
            }
            uint32_t ms = (uint32_t)(clk_sys_cycles / 33750);
            if ((clk_sys_cycles & 0xFFF) == 0) {
                std::lock_guard<std::mutex> g(in_mu);
                while (!in_lines.empty()) {
                    std::string l = in_lines.front(); in_lines.pop_front();
                    if (l[0] == 'Q') quit = true;
                    else if (l[0] == 'K') { keys = (unsigned)strtoul(l.c_str() + 2, nullptr, 16); }
                    else if (l[0] == 'R' && l.size() > 2) rx_q.push_back((uint8_t)l[2]);
                }
                top->key_n = (uint8_t)~keys;
                top->s1 = (keys >> 8) & 1;
                top->s2 = (keys >> 9) & 1;
            }
            if (ms - last_lcd >= 100 && lcd.fresh) { last_lcd = ms; lcd.fresh = false; msg('C', lcd.fb, sizeof lcd.fb); }
            if (ms - last_report >= 50) { last_report = ms; msg('T', &ms, 4); }
            if (ms - last_save >= 2000 && (fl.dev.dirty || sd.dev.dirty)) {
                last_save = ms;
                if (flash_path && fl.dev.dirty) save(flash_path, flash);
                if (sd_path && sd.dev.dirty) save(sd_path, sdimg);
                fl.dev.dirty = sd.dev.dirty = false;
            }
            if (max_ms && ms >= (uint32_t)max_ms) quit = true;
        }
        last_sclk = top->clk_sys;
        // ---- pixel clock edges: the HDMI picture
        if (hdmi && top->vid_clk && !last_vclk) {
            int cx = top->vid_cx, cy = top->vid_cy;
            if (cx < 720 && cy < 480) {
                uint8_t *p = &frame[(cy * 720 + cx) * 3];
                uint32_t c = top->vid_rgb;
                p[0] = c >> 16; p[1] = c >> 8; p[2] = c;
            }
            if (cy != last_cy && last_cy < 480 && (last_cy + 1) % BAND == 0) {
                int y0 = last_cy + 1 - BAND;
                size_t off = (size_t)y0 * 720 * 3, len = (size_t)720 * BAND * 3;
                if (memcmp(&frame[off], &sent[off], len)) {
                    memcpy(&sent[off], &frame[off], len);
                    band[0] = y0 & 0xFF; band[1] = y0 >> 8; band[2] = BAND; band[3] = 0;
                    memcpy(&band[4], &frame[off], len);
                    msg('B', band.data(), (uint32_t)band.size());
                }
            }
            last_cy = cy;
        }
        last_vclk = top->vid_clk;
        if (!top->eventsPending()) break;
        ctx->time(top->nextTimeSlot());
    }
    if (!logbuf.empty()) msg('L', logbuf.data(), (uint32_t)logbuf.size());
    if (flash_path && fl.dev.dirty) save(flash_path, flash);
    if (sd_path && sd.dev.dirty) save(sd_path, sdimg);
    if (cart_on) {
        unsigned diff = 0;
        for (size_t i = 0; i < cr.ram.size(); i++) diff += cr.ram[i] != (uint8_t)(i * 7 + 3);
        fprintf(stderr, "cartridge: %u bus writes, %u RAM bytes changed\n", cr.writes, diff);
    }
    top->final();
    delete top;
    delete ctx;
    return 0;
}
