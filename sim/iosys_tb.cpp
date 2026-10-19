// Verilator bench for the I/O system: FemtoRV32 + boot ROM + firmware, with models of the
// SPI flash (image: firmware at 0x100000, games at 0x200000), the SDRAM port and the UART.
// Prints the firmware log and dumps the OSD as text.
//   iosys_tb <ms> [script]    script: lines "<ms> <inputs hex>"
#include "Viosys.h"
#include "verilated.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <string>

double sc_time_stamp() { return 0; }

static std::vector<uint8_t> flash(8 << 20, 0xFF);
static std::vector<uint8_t> sdram(8 << 20, 0);
static uint16_t osd[1024];
static uint8_t txt[512];

static void load(const char *path, uint32_t at) {
    FILE *f = fopen(path, "rb");
    if (!f) { fprintf(stderr, "no %s\n", path); return; }
    size_t n = fread(&flash[at], 1, flash.size() - at, f);
    fclose(f);
    fprintf(stderr, "flash: %s at %06x (%zu bytes)\n", path, at, n);
}

// SPI flash slave, mode 0
struct Flash {
    int bit = 0, nbytes = 0;
    uint8_t in = 0, out = 0xFF, cmd = 0;
    uint32_t addr = 0;
    int last_sck = 0, last_cs = 1;
    int miso = 1;
    bool wel = false;
    std::vector<uint8_t> page;
    void step(int cs_n, int sck, int mosi) {
        if (cs_n) {
            if (!last_cs) end();
            bit = 0; nbytes = 0; last_cs = 1; last_sck = sck; return;
        }
        if (last_cs) { bit = 0; nbytes = 0; out = 0xFF; miso = 1; }
        last_cs = 0;
        if (sck && !last_sck) {                // rising: sample
            in = (in << 1) | (mosi & 1);
            bit++;
            if (bit == 8) { byte(in); bit = 0; }
        }
        if (!sck && last_sck) {                // falling: shift out
            miso = (out >> 7) & 1;
            out <<= 1;
            if (bit == 0) { }                  // next byte loaded in byte()
        }
        if (bit == 0 && !sck && last_sck) {}
        last_sck = sck;
    }
    void byte(uint8_t b) {
        if (nbytes == 0) cmd = b;
        else if (nbytes <= 3 && (cmd == 0x03 || cmd == 0x02 || cmd == 0x20)) addr = (addr << 8) | b;
        else if (cmd == 0x02) page.push_back(b);
        nbytes++;
        uint8_t nx = 0xFF;
        if (cmd == 0x03 && nbytes >= 4) nx = flash[(addr + (nbytes - 4)) & 0x7FFFFF];
        if (cmd == 0x9F) nx = nbytes == 1 ? 0x85 : nbytes == 2 ? 0x60 : 0x17;
        if (cmd == 0x05) nx = 0x00;
        if (cmd == 0x06) wel = true;
        out = nx;                              // presented from the next falling edge
    }
    void end() {
        if (cmd == 0x20 && wel) { for (int i = 0; i < 4096; i++) flash[(addr & ~0xFFF) + i] = 0xFF; wel = false; }
        if (cmd == 0x02 && wel) { for (size_t i = 0; i < page.size(); i++) flash[addr + i] &= page[i]; wel = false; }
        page.clear();
    }
};

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    long ms = argc > 1 ? atol(argv[1]) : 300;
    std::vector<std::pair<long, unsigned>> script;
    if (argc > 2) {
        FILE *f = fopen(argv[2], "r");
        long t; unsigned v;
        while (f && fscanf(f, "%ld %x", &t, &v) == 2) script.push_back({t, v});
        if (f) fclose(f);
    }
    load("fw/build/fw.bin", 0x100000);
    load("build/games.bin", 0x200000);

    Viosys *m = new Viosys;
    Flash fl;
    m->reset = 1; m->sdram_ready = 0; m->inputs = 0; m->flash_miso = 1; m->sd_miso = 1;
    // SDRAM port model: ack one cycle after req, read data 4 cycles later
    int busy = 0, rd_delay = 0;
    uint32_t rd_data = 0;
    // UART decoder
    const int UDIV = 33750000 / 115200;
    int u_cnt = -1, u_bit = 0; unsigned u_byte = 0;
    long cyc = 0, end_cyc = ms * 33750L;
    size_t si = 0;
    for (; cyc < end_cyc; cyc++) {
        if (cyc == 100) m->reset = 0;
        if (cyc == 300) m->sdram_ready = 1;
        long now_ms = cyc / 33750;
        while (si < script.size() && script[si].first <= now_ms) { m->inputs = script[si].second; si++; }
        m->clk = 0; m->eval();
        // inputs sampled before the rising edge
        m->rv_ack = 0; m->rv_rvalid = 0;
        if (rd_delay > 0 && --rd_delay == 0) { m->rv_rvalid = 1; m->rv_rdata = rd_data; }
        static int ack_next = 0;
        if (ack_next) { m->rv_ack = 1; ack_next = 0; }
        if (busy > 0) busy--;
        else if (m->rv_req) {
            uint32_t a = (m->rv_addr & 0x1FFFFF) * 4;
            if (m->rv_we) {
                for (int i = 0; i < 4; i++) if (m->rv_be & (1 << i)) sdram[a + i] = (m->rv_wdata >> (8 * i)) & 0xFF;
            } else {
                memcpy(&rd_data, &sdram[a], 4);
                rd_delay = 5;
            }
            ack_next = 1;
            busy = 5;
        }
        m->clk = 1; m->eval();
        fl.step(m->flash_cs_n, m->flash_clk, m->flash_mosi);
        m->flash_miso = fl.miso;
        if (m->osd_we) osd[m->osd_addr & 1023] = m->osd_data;
        if (m->txt_we) txt[m->txt_addr & 511] = m->txt_data;
        // UART
        if (u_cnt < 0) { if (!m->uart_tx) { u_cnt = UDIV + UDIV / 2; u_bit = 0; u_byte = 0; } }
        else if (--u_cnt == 0) {
            if (u_bit < 8) { u_byte |= (m->uart_tx & 1) << u_bit; u_bit++; u_cnt = UDIV; }
            else { if (u_byte != '\r') putchar(u_byte); fflush(stdout); u_cnt = -1; }
        }
    }
    printf("\n---- ctrl %08x cfg %08x ----\n", m->ctrl, m->cfg);
    for (int y = 0; y < 24; y++) {
        for (int x = 0; x < 42; x++) {
            uint8_t c = osd[y * 42 + x] & 0x7F;
            putchar(c >= 32 && c < 127 ? c : (c == 0 ? ' ' : '#'));
        }
        putchar('\n');
    }
    printf("---- LCD ----\n");
    for (int y = 0; y < 16; y++) {
        for (int x = 0; x < 16; x++) { uint8_t c = txt[y * 16 + x] & 0x7F; putchar(c >= 32 && c < 127 ? c : '#'); }
        putchar('\n');
    }
    delete m;
    return 0;
}
