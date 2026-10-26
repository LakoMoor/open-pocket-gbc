// I/O system: a FemtoRV32 (RV32E) runs the menu firmware (fw/), loads games from the
// SD card or the SPI flash, writes cartridge saves and controls the core.
//
// Memory map (byte addresses):
//   0x0000_0000  SDRAM, 8 MB (ROM at 0, cart RAM at 0x600000, framebuffers at 0x700000,
//                firmware at 0x780000)
//   0x0100_0000  boot ROM (copies the firmware from flash 0x100000 to SDRAM 0x780000)
//   0x0200_0000  registers, see below
//   0x0300_0000  OSD character RAM: 1024 x 16 bit {attr, char}, halfword writes
//   0x0310_0000  SPI LCD / debug text RAM: 512 x 16 bit {attr, char}, halfword writes
//
// The CPU stalls on a WAIT read until an input changes or the timeout passes, so it does
// not switch while the game runs.
module iosys #(
    parameter CLK_HZ = 33_750_000
) (
    input             clk,
    input             reset,
    input             sdram_ready,

    // SDRAM, through memsys (word addresses)
    output            rv_req,
    input             rv_ack,
    output            rv_we,
    output     [20:0] rv_addr,
    output     [31:0] rv_wdata,
    output      [3:0] rv_be,
    input      [31:0] rv_rdata,
    input             rv_rvalid,

    output            flash_cs_n,
    output            flash_clk,
    output            flash_mosi,
    input             flash_miso,

    output            sd_cs_n,
    output            sd_clk,
    output            sd_mosi,
    input             sd_miso,

    // external W25Qxx flash used as a game cartridge
    output            cart_cs_n,
    output            cart_clk,
    output            cart_mosi,
    input             cart_miso,

    output            uart_tx,
    output reg        image_we,
    output reg        image_first,
    output reg [14:0] image_pixel,

    // link port as a slave (Game Boy Printer): the Game Boy clocks SC, we answer on SO
    input             link_sc,
    input             link_si,
    output            prn_so,

    input      [15:0] inputs,       // {uart reset, uart menu, s2, s1, pad[11:0]}
    input             frame_tick,
    input             stat_gbc,
    input             stat_2x,
    input       [1:0] stat_buf,
    input             uart_seen,    // a byte came over the USB-UART (remote control)
    input       [7:0] uart_byte,    // ... and which one (for the screen stream handshake)
    input             aud_smp,      // 48 kHz strobe
    input       [7:0] aud_mono8,    // mono sample (unsigned) for the USB audio stream
    output reg [11:0] uart_div,     // UART bit time in clocks, TX and RX (115200 by default)
    input       [2:0] gpio_in,      // {charger, sda, scl}
    output reg  [2:0] gpio_out,     // {i2c on, sda low, scl low}     // framebuffer the display reads (the newest complete frame)
    input             cram_wr,      // cartridge RAM write strobe (level)

    output reg [31:0] ctrl,
    output reg [31:0] cfg,
    output reg [31:0] beep,         // menu sound: [11:0] half period in 4 us steps, [27:16] length in ms

    output reg        ioctl_wr,
    output reg [24:0] ioctl_addr,
    output reg [15:0] ioctl_dout,

    output reg        osd_we,
    output reg  [9:0] osd_addr,
    output reg [15:0] osd_data,
    output            sdram_sleep,  // the CPU sleeps in DEEPWAIT: SDRAM may self-refresh
    output reg        txt_we,
    output reg  [8:0] txt_addr,
    output reg [15:0] txt_data
);

// ------------------------------------------------------------ CPU
reg         mem_ready;
reg  [31:0] mem_rdata;

reg rv_resetn;
always @(posedge clk) rv_resetn <= ~reset & sdram_ready;

// FemtoRV32 Quark: a read starts with mem_rstrb, a write with mem_wmask; busy must be
// high from the next cycle until the access is done. The adapter turns that into a
// valid / ready request.
wire [31:0] cpu_addr, cpu_wdata;
wire  [3:0] cpu_wmask;
wire        cpu_rstrb;
reg         mem_valid;
reg  [31:0] mem_addr, mem_wdata;
reg   [3:0] mem_wstrb;
reg  [31:0] cpu_rdata;
FemtoRV32 #(.RESET_ADDR(32'h0100_0000), .ADDR_WIDTH(26)) u_cpu (
    .clk(clk), .reset(rv_resetn),
    .mem_addr(cpu_addr), .mem_wdata(cpu_wdata), .mem_wmask(cpu_wmask), .mem_rdata(cpu_rdata),
    .mem_rstrb(cpu_rstrb), .mem_rbusy(mem_valid), .mem_wbusy(mem_valid)
);
always @(posedge clk) begin
    if (!rv_resetn) mem_valid <= 0;
    else if (cpu_rstrb || cpu_wmask != 0) begin
        mem_valid <= 1;
        mem_addr  <= {6'd0, cpu_addr[25:0]};
        mem_wdata <= cpu_wdata;
        mem_wstrb <= cpu_wmask;
    end else if (mem_ready) begin
        mem_valid <= 0;
        cpu_rdata <= mem_rdata;
    end
end

wire is_ram  = mem_addr[31:24] == 8'h00;
wire is_rom  = mem_addr[31:24] == 8'h01;
wire is_io   = mem_addr[31:24] == 8'h02;
wire is_osd  = mem_addr[31:24] == 8'h03;
wire is_wr   = mem_wstrb != 0;
wire fire    = mem_valid & mem_ready;

// ------------------------------------------------------------ SDRAM
// While the screen stream engine runs (se_own) it has the port; the CPU waits on its next access.
reg ram_wait_rd, ram_done;
reg [31:0] ram_q;
`ifdef SCR_ENGINE
reg         se_own;
`else
wire        se_own = 1'b0;          // no engine: none of its glue logic is built
`endif
wire        se_req, se_we, se_busy, se_tx_valid;
wire [20:0] se_addr;
wire [31:0] se_wdata;
wire  [7:0] se_tx_byte;
assign rv_req   = se_own ? se_req   : mem_valid & is_ram & ~ram_wait_rd & ~ram_done;
assign rv_we    = se_own ? se_we    : is_wr;
assign rv_addr  = se_own ? se_addr  : mem_addr[22:2];
assign rv_wdata = se_own ? se_wdata : mem_wdata;
assign rv_be    = se_own ? 4'hF     : is_wr ? mem_wstrb : 4'hF;
always @(posedge clk) begin
    if (!rv_resetn) begin
        ram_wait_rd <= 0;
        ram_done    <= 0;
    end else begin
        if (fire) ram_done <= 0;
        if (rv_ack && !se_own) begin
            if (rv_we) ram_done    <= 1;
            else       ram_wait_rd <= 1;
        end
        if (rv_rvalid && ram_wait_rd) begin
            ram_q       <= rv_rdata;
            ram_wait_rd <= 0;
            ram_done    <= 1;
        end
    end
end

// ------------------------------------------------------------ screen stream engine
// write 0x6C: {fix row, framebuffer word address} starts it; read 0x6C waits until it is done;
// write 0x70: word address of its hash table (256-word aligned)
wire        se_tx_take = se_own & se_tx_valid & (u_n == 0);
`ifdef SCR_ENGINE
reg  [20:0] se_base, se_htab;
reg   [7:0] se_fix;
reg         se_start;
scr_engine u_se (
    .clk(clk), .reset(reset), .start(se_start), .base(se_base), .htab(se_htab), .fix(se_fix),
    .busy(se_busy),
    .req(se_req), .we(se_we), .addr(se_addr), .wdata(se_wdata),
    .ack(rv_ack & se_own), .rdata(rv_rdata), .rvalid(rv_rvalid & se_own),
    .tx_valid(se_tx_valid), .tx_byte(se_tx_byte), .tx_take(se_tx_take)
);
localparam IO_ENGINE = 16'h0002;
`else
// The engine does not fit next to the core on the GW2AR-18 (88% LUT, no placement): the firmware
// encodes the rows itself. Build with DEFS="-D SCR_ENGINE" to include it.
assign se_req = 1'b0; assign se_we = 1'b0; assign se_addr = 21'd0; assign se_wdata = 32'd0;
assign se_busy = 1'b0; assign se_tx_valid = 1'b0; assign se_tx_byte = 8'd0;
localparam IO_ENGINE = 16'h0000;
`endif
// REG_ID [15:0]: bit 0 base, bit 1 stream engine, bit 2 USB audio, bit 3 MINIMAL (no HDMI, link,
// LEDs, cartridge port or USB audio)
`ifdef MINIMAL
localparam IO_VERSION = 16'h0019 | IO_ENGINE; // bit 4: CPU image stream for gallery / LCD
`else
localparam IO_VERSION = 16'h0015 | IO_ENGINE;
`endif

// ------------------------------------------------------------ USB audio
// 48 kHz -> 16 kHz mono 8-bit samples into a 64-entry FIFO (4 ms) that the firmware empties
// into the screen stream. write 0x74: [0] on (and clear); read 0x74: [14:8] samples waiting,
// [7:0] the oldest one (the read takes it)
reg  [7:0] af_mem [0:63];
reg  [5:0] af_wp, af_rp;
reg  [6:0] af_n;
reg  [1:0] af_div;
reg        af_on;
wire       af_pop = fire && is_io && !is_wr && reg_a == 6'h1D && af_n != 0;
`ifdef MINIMAL
wire       af_push = 1'b0;
`else
wire       af_push = af_on && aud_smp && af_div == 2'd2 && af_n != 7'd64;
`endif
always @(posedge clk) begin
    if (aud_smp) af_div <= af_div == 2'd2 ? 2'd0 : af_div + 1'd1;
    if (af_push) begin af_mem[af_wp] <= aud_mono8; af_wp <= af_wp + 1'd1; end
    if (af_pop) af_rp <= af_rp + 1'd1;
    af_n <= af_n + (af_push ? 7'd1 : 7'd0) - (af_pop ? 7'd1 : 7'd0);
    if (fire && is_io && is_wr && reg_a == 6'h1D) begin af_on <= mem_wdata[0]; af_wp <= 0; af_rp <= 0; af_n <= 0; end
    if (reset) begin af_on <= 0; af_wp <= 0; af_rp <= 0; af_n <= 0; end
end

// ------------------------------------------------------------ boot ROM
`include "bootrom.vh"

// ------------------------------------------------------------ SPI ports
// SD at 0x10, on-board flash at 0x20, cartridge flash at 0x50 (DATA, WORD, CTRL)
wire [5:0] reg_a = mem_addr[7:2];
wire       sel_sd = is_io && reg_a[5:2] == 4'd1 && reg_a[1:0] != 2'd3;
wire       sel_fl = is_io && reg_a[5:2] == 4'd2 && reg_a[1:0] != 2'd3;
wire       sel_ct = is_io && reg_a[5:2] == 4'd5 && reg_a[1:0] != 2'd3;
wire       sd_ready, fl_ready, ct_ready;
wire [31:0] sd_rdata, fl_rdata, ct_rdata;
spi_port #(.DIV0(8'd63)) u_sd (.clk(clk), .reset(reset), .valid(mem_valid & sel_sd), .sel(reg_a[1:0]),
    .wr(is_wr), .fire(fire & sel_sd), .wdata(mem_wdata), .ready(sd_ready), .rdata(sd_rdata),
    .cs_n(sd_cs_n), .sck(sd_clk), .mosi(sd_mosi), .miso(sd_miso));
spi_port #(.DIV0(8'd0)) u_fl (.clk(clk), .reset(reset), .valid(mem_valid & sel_fl), .sel(reg_a[1:0]),
    .wr(is_wr), .fire(fire & sel_fl), .wdata(mem_wdata), .ready(fl_ready), .rdata(fl_rdata),
    .cs_n(flash_cs_n), .sck(flash_clk), .mosi(flash_mosi), .miso(flash_miso));
`ifdef MINIMAL
`define NO_CART_PORT
`endif
`ifndef NO_CART_PORT
spi_port #(.DIV0(8'd1)) u_ct (.clk(clk), .reset(reset), .valid(mem_valid & sel_ct), .sel(reg_a[1:0]),
    .wr(is_wr), .fire(fire & sel_ct), .wdata(mem_wdata), .ready(ct_ready), .rdata(ct_rdata),
    .cs_n(cart_cs_n), .sck(cart_clk), .mosi(cart_mosi), .miso(cart_miso));
`else
// NO_CART_PORT (the lite bitstream): no cartridge flash / original cartridge reader; the
// firmware sees no flash there (reads 0xFF)
assign ct_ready = 1'b1; assign ct_rdata = 32'hFFFF_FFFF;
assign cart_cs_n = 1'b1; assign cart_clk = 1'b0; assign cart_mosi = 1'b0;
`endif

// ------------------------------------------------------------ UART TX (115200 8N1)
localparam UDIV = CLK_HZ / 115200;
reg  [7:0] rx_byte;
reg        rx_new;
reg  [9:0] u_sh = 10'h3FF;
reg  [3:0] u_n;
reg [11:0] u_cnt;
assign uart_tx = u_sh[0];
wire u_busy = (u_n != 0);

// ------------------------------------------------------------ timers, events
localparam MS_DIV = CLK_HZ / 1000;
reg [15:0] ms_div;
reg [31:0] ms;
reg [15:0] wait_cnt;
reg [15:0] in_q, in_prev;
reg        ev;
reg        dirty;
reg        remote;
reg        cram_d;
reg [15:0] frames;
wire       timeout = (wait_cnt == 0);

// ------------------------------------------------------------ link slave (printer)
// SI is sampled on the rising edge of SC, SO changes on the falling edge, MSB first. After
// 8 bits the byte is ready (register 0x60) and the answer for the next byte is loaded.
reg  [1:0] lk_sc = 2'b11, lk_si = 2'b11;
reg  [7:0] prn_rx, prn_tx, prn_sr, prn_byte;
reg  [2:0] prn_n;
reg        prn_valid, prn_q = 1'b1;
reg [15:0] prn_idle;
assign prn_so = prn_q;
wire prn_pending = prn_valid && (ctrl[15] || ctrl[16]);
wire prn_complete = lk_sc == 2'b01 && prn_n == 3'd7;

// ------------------------------------------------------------ register read / ready
always @* begin
    mem_ready = 0;
    mem_rdata = 32'd0;
    if (is_ram) begin
        mem_ready = ram_done;
        mem_rdata = ram_q;
    end else if (is_rom) begin
        mem_ready = 1;
        mem_rdata = bootrom(mem_addr[8:2]);
    end else if (is_osd) begin
        mem_ready = 1;
    end else if (is_io) begin
        mem_ready = 1;
        case (reg_a)
            6'h00: mem_rdata = {16'h4F47, IO_VERSION};             // "OG", version (2: stream engine)
            6'h01: mem_rdata = {16'd0, in_q};
            6'h02: mem_rdata = ms;
            6'h03: mem_rdata = {frames, 10'd0, remote, stat_buf, dirty, stat_2x, stat_gbc};
            6'h19: mem_rdata = {29'd0, gpio_in};
            6'h1A: mem_rdata = {20'd0, rx_new, 3'd0, rx_byte};
            6'h1B: mem_ready = ~se_own;
            6'h1D: mem_rdata = {17'd0, af_n, af_mem[af_rp]};
            6'h0C: mem_ready = ~u_busy;
            6'h0D, 6'h12: begin mem_ready = is_wr | ev | timeout | prn_pending; mem_rdata = {31'd0, ev | prn_pending}; end
            6'h0E: mem_rdata = ctrl;
            6'h0F: mem_rdata = cfg;
            6'h18: mem_rdata = {23'd0, prn_valid, prn_byte};
            default: ;
        endcase
        if (sel_sd) begin mem_ready = sd_ready; mem_rdata = sd_rdata; end
        if (sel_fl) begin mem_ready = fl_ready; mem_rdata = fl_rdata; end
        if (sel_ct) begin mem_ready = ct_ready; mem_rdata = ct_rdata; end
    end else
        mem_ready = mem_valid;                                 // unmapped
end

// DEEPWAIT (0x48) is WAIT that also lets the SDRAM self-refresh: the CPU is stalled on
// this register, so it fetches nothing until it wakes up.
assign sdram_sleep = mem_valid & is_io & ~is_wr & (reg_a == 6'h12) & ~ev & ~timeout & ~prn_pending;

// ------------------------------------------------------------ register writes and side effects
always @(posedge clk) begin
    ioctl_wr <= 0;
    image_we <= 0;
    osd_we   <= 0;
    txt_we   <= 0;

    // ms timer and input events
    if (ms_div == MS_DIV - 1) begin
        ms_div <= 0;
        ms     <= ms + 1'd1;
        if (wait_cnt != 0) wait_cnt <= wait_cnt - 1'd1;
    end else ms_div <= ms_div + 1'd1;
    in_q    <= inputs;
    in_prev <= in_q;
    if (in_q != in_prev) ev <= 1;
    // link slave
    lk_sc <= {lk_sc[0], link_sc};
    lk_si <= {lk_si[0], link_si};
    if (lk_sc == 2'b10) begin                       // falling edge: next bit out
        prn_q  <= prn_sr[7];
        prn_sr <= {prn_sr[6:0], 1'b0};
        prn_idle <= 0;
    end else if (lk_sc == 2'b01) begin              // rising edge: bit in
        prn_rx <= {prn_rx[6:0], lk_si[1]};
        prn_n  <= prn_n + 1'd1;
        prn_idle <= 0;
        if (prn_n == 3'd7) begin
            prn_byte  <= {prn_rx[6:0], lk_si[1]};
            prn_valid <= 1;
            prn_sr    <= prn_tx;
            ev        <= 1;
        end
    end else if (prn_idle != 16'hFFFF && !(ctrl[16] && ctrl[1])) begin
        prn_idle <= prn_idle + 1'd1;
        if (prn_idle == 16'd40000) prn_n <= 0;      // ~1.2 ms without a clock: resynchronise
    end
    if (uart_seen) begin remote <= 1; rx_byte <= uart_byte; rx_new <= 1; end
    cram_d <= cram_wr;
    if (cram_wr & ~cram_d) dirty <= 1;
    if (frame_tick) frames <= frames + 1'd1;

    // UART (the stream engine loads bytes while it runs)
`ifdef SCR_ENGINE
    se_start <= 0;
    if (se_own && !se_busy && !se_start) se_own <= 0;
`endif
    if (se_tx_take) begin u_sh <= {1'b1, se_tx_byte, 1'b0}; u_n <= 4'd10; u_cnt <= uart_div - 1'd1; end
    if (u_n != 0) begin
        if (u_cnt == 0) begin
            u_cnt <= uart_div - 1'd1;
            u_sh  <= {1'b1, u_sh[9:1]};
            u_n   <= u_n - 1'd1;
        end else u_cnt <= u_cnt - 1'd1;
    end


    if (fire && is_io) begin
        if (is_wr) case (reg_a)
            6'h0C: begin u_sh <= {1'b1, mem_wdata[7:0], 1'b0}; u_n <= 4'd10; u_cnt <= uart_div - 1'd1; end
            6'h0D, 6'h12: begin wait_cnt <= mem_wdata[15:0]; ev <= 0; end
            6'h0E: ctrl <= mem_wdata;
            6'h0F: cfg  <= mem_wdata;
            6'h10: ioctl_addr <= mem_wdata[24:0];
            6'h11: begin ioctl_dout <= mem_wdata[15:0]; ioctl_wr <= 1; end
            6'h13: beep <= mem_wdata;
            6'h18: begin
                prn_tx <= mem_wdata[7:0];
                if (mem_wdata[8]) begin
                    prn_n <= 0; prn_valid <= 0; prn_rx <= 0;
                    prn_sr <= 0; prn_q <= 0; prn_idle <= 0;
                end
            end
            6'h1E: begin image_we <= 1; image_first <= mem_wdata[15]; image_pixel <= mem_wdata[14:0]; end
            6'h19: gpio_out <= mem_wdata[2:0];
            6'h1A: uart_div <= mem_wdata[11:0];
`ifdef SCR_ENGINE
            6'h1B: begin se_base <= mem_wdata[20:0]; se_fix <= mem_wdata[31:24]; se_start <= 1; se_own <= 1; end
            6'h1C: se_htab <= mem_wdata[20:0];
`endif
            default: ;
        endcase else case (reg_a)
            6'h03: begin dirty <= 0; remote <= 0; end
            6'h18: if (!prn_complete) prn_valid <= 0;
            6'h1A: if (!uart_seen) rx_new <= 0;          // a byte arriving in this cycle stays flagged
            6'h0D, 6'h12: ev <= 0;
            default: ;
        endcase
    end

    if (fire && is_osd && is_wr) begin
        if (!mem_addr[20]) begin
            osd_we   <= 1;
            osd_addr <= mem_addr[10:1];
            osd_data <= mem_addr[1] ? mem_wdata[31:16] : mem_wdata[15:0];
        end else begin
            txt_we   <= 1;
            txt_addr <= mem_addr[9:1];
            txt_data <= mem_addr[1] ? mem_wdata[31:16] : mem_wdata[15:0];
        end
    end

    if (reset) begin
        ctrl   <= 32'h0000_0001;          // core held in reset until a game is loaded
        cfg    <= 32'h0000_0000;
        u_n    <= 0; u_sh <= 10'h3FF;
        uart_div <= UDIV[11:0]; rx_new <= 0;
`ifdef SCR_ENGINE
        se_own <= 0; se_start <= 0;
`endif
        ev     <= 0; dirty <= 0;
        ms     <= 0; ms_div <= 0; wait_cnt <= 0;
        prn_n <= 0; prn_valid <= 0; prn_rx <= 0; prn_tx <= 0;
        prn_sr <= 0; prn_q <= 0; prn_idle <= 0;
    end
end

endmodule
