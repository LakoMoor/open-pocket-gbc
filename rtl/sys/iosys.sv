// I/O system: a FemtoRV32 (RV32E) runs the menu firmware (fw/), loads games from the
// SD card or the SPI flash, writes cartridge saves and controls the core.
//
// Memory map (byte addresses):
//   0x0000_0000  SDRAM, 8 MB (ROM at 0, cart RAM at 0x600000, framebuffers at 0x700000,
//                firmware at 0x780000)
//   0x0100_0000  boot ROM (copies the firmware from flash 0x100000 to SDRAM 0x780000)
//   0x0200_0000  registers, see below
//   0x0300_0000  OSD character RAM: 1024 x 16 bit {attr, char}, halfword writes
//   0x0310_0000  SPI LCD text RAM: 512 x 8 bit, byte writes
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

    output            uart_tx,

    input      [15:0] inputs,       // {uart reset, uart menu, s2, s1, pad[11:0]}
    input             frame_tick,
    input             stat_gbc,
    input             stat_2x,
    input             cram_wr,      // cartridge RAM write strobe (level)

    output reg [31:0] ctrl,
    output reg [31:0] cfg,

    output reg        ioctl_wr,
    output reg [24:0] ioctl_addr,
    output reg [15:0] ioctl_dout,

    output reg        osd_we,
    output reg  [9:0] osd_addr,
    output reg [15:0] osd_data,
    output reg        txt_we,
    output reg  [8:0] txt_addr,
    output reg  [7:0] txt_data
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
reg ram_wait_rd, ram_done;
reg [31:0] ram_q;
assign rv_req   = mem_valid & is_ram & ~ram_wait_rd & ~ram_done;
assign rv_we    = is_wr;
assign rv_addr  = mem_addr[22:2];
assign rv_wdata = mem_wdata;
assign rv_be    = is_wr ? mem_wstrb : 4'hF;
always @(posedge clk) begin
    if (!rv_resetn) begin
        ram_wait_rd <= 0;
        ram_done    <= 0;
    end else begin
        if (fire) ram_done <= 0;
        if (rv_ack) begin
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

// ------------------------------------------------------------ boot ROM
`include "bootrom.vh"

// ------------------------------------------------------------ SPI ports
reg  [7:0] sd_div, fl_div;
reg        sd_cs, fl_cs;
reg        sd_start, fl_start;
reg  [7:0] sd_tx, fl_tx;
wire [7:0] sd_rx, fl_rx;
wire       sd_busy, fl_busy;
spi_byte u_sd (.clk(clk), .reset(reset), .div(sd_div), .start(sd_start), .tx(sd_tx),
               .rx(sd_rx), .busy(sd_busy), .sck(sd_clk), .mosi(sd_mosi), .miso(sd_miso));
spi_byte u_fl (.clk(clk), .reset(reset), .div(fl_div), .start(fl_start), .tx(fl_tx),
               .rx(fl_rx), .busy(fl_busy), .sck(flash_clk), .mosi(flash_mosi), .miso(flash_miso));
assign sd_cs_n    = ~sd_cs;
assign flash_cs_n = ~fl_cs;

// word reads: four 0xFF transfers, little endian
reg  [2:0] sw_n, fw_n;          // transfers left (4..1), 0 idle
reg [31:0] sw_q, fw_q;
reg        sw_go, fw_go;        // a word read was started and is running

// ------------------------------------------------------------ UART TX (115200 8N1)
localparam UDIV = CLK_HZ / 115200;
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
reg        cram_d;
reg [15:0] frames;
wire       timeout = (wait_cnt == 0);

// ------------------------------------------------------------ register read / ready
wire [5:0] reg_a = mem_addr[7:2];
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
            6'h00: mem_rdata = 32'h4F47_0001;                       // "OG", version
            6'h01: mem_rdata = {16'd0, in_q};
            6'h02: mem_rdata = ms;
            6'h03: mem_rdata = {frames, 13'd0, dirty, stat_2x, stat_gbc};
            6'h04: begin mem_ready = ~sd_busy & ~sd_start;              mem_rdata = {24'd0, sd_rx}; end
            6'h05: begin mem_ready = sw_go & (sw_n == 0) & ~sd_busy; mem_rdata = sw_q; end
            6'h06: mem_rdata = {16'd0, sd_div, 7'd0, sd_cs};
            6'h08: begin mem_ready = ~fl_busy & ~fl_start;              mem_rdata = {24'd0, fl_rx}; end
            6'h09: begin mem_ready = fw_go & (fw_n == 0) & ~fl_busy; mem_rdata = fw_q; end
            6'h0A: mem_rdata = {16'd0, fl_div, 7'd0, fl_cs};
            6'h0C: mem_ready = ~u_busy;
            6'h0D: begin mem_ready = is_wr | ev | timeout;   mem_rdata = {31'd0, ev}; end
            6'h0E: mem_rdata = ctrl;
            6'h0F: mem_rdata = cfg;
            default: ;
        endcase
        // word reads first start the transfers, then wait for them
        if (reg_a == 6'h05 && !sw_go) mem_ready = 0;
        if (reg_a == 6'h09 && !fw_go) mem_ready = 0;
        if ((reg_a == 6'h04 || reg_a == 6'h05 || reg_a == 6'h08 || reg_a == 6'h09) && is_wr)
            mem_ready = reg_a[3] ? (~fl_busy & ~fl_start & (fw_n == 0)) : (~sd_busy & ~sd_start & (sw_n == 0));
    end else
        mem_ready = mem_valid;                                 // unmapped
end

// ------------------------------------------------------------ register writes and side effects
always @(posedge clk) begin
    sd_start <= 0;
    fl_start <= 0;
    ioctl_wr <= 0;
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
    cram_d <= cram_wr;
    if (cram_wr & ~cram_d) dirty <= 1;
    if (frame_tick) frames <= frames + 1'd1;

    // UART
    if (u_n != 0) begin
        if (u_cnt == 0) begin
            u_cnt <= UDIV - 1;
            u_sh  <= {1'b1, u_sh[9:1]};
            u_n   <= u_n - 1'd1;
        end else u_cnt <= u_cnt - 1'd1;
    end

    // SD word read sequencer
    if (sw_n != 0 && !sd_busy && !sd_start) begin
        if (sw_n != 3'd5) sw_q <= {sd_rx, sw_q[31:8]};
        if (sw_n == 3'd1) sw_n <= 0;
        else begin sd_tx <= 8'hFF; sd_start <= 1; sw_n <= sw_n - 1'd1; end
    end
    if (fw_n != 0 && !fl_busy && !fl_start) begin
        if (fw_n != 3'd5) fw_q <= {fl_rx, fw_q[31:8]};
        if (fw_n == 3'd1) fw_n <= 0;
        else begin fl_tx <= 8'hFF; fl_start <= 1; fw_n <= fw_n - 1'd1; end
    end
    if (mem_valid && is_io && !is_wr && reg_a == 6'h05 && !sw_go && !sd_busy && !sd_start) begin sw_go <= 1; sw_n <= 3'd5; end
    if (mem_valid && is_io && !is_wr && reg_a == 6'h09 && !fw_go && !fl_busy && !fl_start) begin fw_go <= 1; fw_n <= 3'd5; end

    if (fire && is_io) begin
        if (is_wr) case (reg_a)
            6'h04, 6'h05: begin sd_tx <= mem_wdata[7:0]; sd_start <= 1; end
            6'h06: begin sd_cs <= mem_wdata[0]; sd_div <= mem_wdata[15:8]; end
            6'h08, 6'h09: begin fl_tx <= mem_wdata[7:0]; fl_start <= 1; end
            6'h0A: begin fl_cs <= mem_wdata[0]; fl_div <= mem_wdata[15:8]; end
            6'h0C: begin u_sh <= {1'b1, mem_wdata[7:0], 1'b0}; u_n <= 4'd10; u_cnt <= UDIV - 1; end
            6'h0D: begin wait_cnt <= mem_wdata[15:0]; ev <= 0; end
            6'h0E: ctrl <= mem_wdata;
            6'h0F: cfg  <= mem_wdata;
            6'h10: ioctl_addr <= mem_wdata[24:0];
            6'h11: begin ioctl_dout <= mem_wdata[15:0]; ioctl_wr <= 1; end
            default: ;
        endcase else case (reg_a)
            6'h03: dirty <= 0;
            6'h05: sw_go <= 0;
            6'h09: fw_go <= 0;
            6'h0D: ev <= 0;
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
            txt_addr <= mem_addr[8:0];
            case (mem_addr[1:0])
                2'd0: txt_data <= mem_wdata[7:0];
                2'd1: txt_data <= mem_wdata[15:8];
                2'd2: txt_data <= mem_wdata[23:16];
                default: txt_data <= mem_wdata[31:24];
            endcase
        end
    end

    if (reset) begin
        ctrl   <= 32'h0000_0001;          // core held in reset until a game is loaded
        cfg    <= 32'h0000_0000;
        sd_cs  <= 0; fl_cs <= 0;
        sd_div <= 8'd63; fl_div <= 8'd0;
        sw_n   <= 0; fw_n <= 0; sw_go <= 0; fw_go <= 0;
        u_n    <= 0; u_sh <= 10'h3FF;
        ev     <= 0; dirty <= 0;
        ms     <= 0; ms_div <= 0; wait_cnt <= 0;
    end
end

endmodule
