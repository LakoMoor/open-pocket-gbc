// Open Pocket GBC: Game Boy / Game Boy Color for the Sipeed Tang Nano 20K.
// MiSTer Gameboy core + SDRAM framebuffer + 720p HDMI (with audio) + Pocket-style menu,
// games loaded from the on-board SPI flash, DualShock 2 controller and/or GPIO buttons,
// optional 1.44" 128x128 ST7735S SPI LCD (runs together with HDMI).
module gbc_top (
    input             sys_clk,      // 27 MHz
    input             s1,           // menu
    input             s2,           // reset game
    output      [1:0] led,

    output            tmds_clk_p, tmds_clk_n,
    output      [2:0] tmds_d_p,   tmds_d_n,

    // GPIO buttons to GND (internal pull-ups): up, down, left, right, A, B, select, start
    input       [7:0] key_n,

    // ST7735S SPI LCD
    output            lcd_scl,
    output            lcd_sda,
    output            lcd_cs,
    output            lcd_dc,
    output            lcd_rst,
    output            lcd_bl,

    input             uart_rx,      // USB-UART from the BL616: remote control (tools/remote.py)

    output            ds_clk,
    output            ds_cs,
    output            ds_mosi,
    input             ds_miso,

    output            flash_cs_n,
    output            flash_clk,
    output            flash_mosi,
    input             flash_miso,

    output            O_sdram_clk,
    output            O_sdram_cke,
    output            O_sdram_cs_n,
    output            O_sdram_cas_n,
    output            O_sdram_ras_n,
    output            O_sdram_wen_n,
    output      [3:0] O_sdram_dqm,
    output     [10:0] O_sdram_addr,
    output      [1:0] O_sdram_ba,
    inout      [31:0] IO_sdram_dq
);

localparam [20:0] FB_BASE_W   = 21'h1C0000;   // byte 0x700000
localparam [22:0] CRAM_BASE   = 23'h600000;

// ================================================================ clocks
// The HDMI PLL must get the PLL at X55Y45 (HCLK reach to the OSER10s); nextpnr hands
// out PLL sites in instance order, so it is instantiated (and named) first.
wire clk_p5, clk_p, hdmi_lock;
`ifdef VIDEO_720P
pll_hdmi    u_pll_a_hdmi (.clock_in(sys_clk), .clock_out(clk_p5), .locked(hdmi_lock));  // 371.25 MHz
`else
pll_hdmi480 u_pll_a_hdmi (.clock_in(sys_clk), .clock_out(clk_p5), .locked(hdmi_lock));  // 135 MHz
`endif

wire clk_sys, clk_sys_p, gb_lock;
pll_gb u_pll_b_gb (.clock_in(sys_clk), .clk_sys(clk_sys), .clk_sys_p(clk_sys_p), .locked(gb_lock));
CLKDIV #(.DIV_MODE("5")) u_div5 (.CLKOUT(clk_p), .HCLKIN(clk_p5), .RESETN(hdmi_lock), .CALIB(1'b0));

// ================================================================ resets
reg [7:0] por_cnt = 0;
reg       sys_rst = 1;
always @(posedge clk_sys) begin
    if (!gb_lock) por_cnt <= 0;
    else if (por_cnt != 8'hFF) por_cnt <= por_cnt + 1'd1;
    sys_rst <= (por_cnt != 8'hFF);
end

reg [3:0] hrst_cnt = 0;
reg       hdmi_rst = 1;
always @(posedge clk_p) begin
    if (!hdmi_lock) hrst_cnt <= 0;
    else if (hrst_cnt != 4'hF) hrst_cnt <= hrst_cnt + 1'd1;
    hdmi_rst <= (hrst_cnt != 4'hF);
end

// ================================================================ controller
wire [7:0] ds_rx0, ds_rx1;
dualshock_controller #(.FREQ(33_750_000)) u_ds2 (
    .clk(clk_sys), .I_RSTn(1'b1),
    .O_psCLK(ds_clk), .O_psSEL(ds_cs), .O_psTXD(ds_mosi), .I_psRXD(ds_miso),
    .O_RXD_1(ds_rx0), .O_RXD_2(ds_rx1), .O_RXD_3(), .O_RXD_4(), .O_RXD_5(), .O_RXD_6()
);
// {R L X A RIGHT LEFT DOWN UP START SELECT Y B}, A = circle, B = cross, X = triangle, Y = square
wire [11:0] pad = {~ds_rx1[3] | ~ds_rx1[1], ~ds_rx1[2] | ~ds_rx1[0],
                   ~ds_rx1[4], ~ds_rx1[5], ~ds_rx0[5], ~ds_rx0[7],
                   ~ds_rx0[6], ~ds_rx0[4], ~ds_rx0[3], ~ds_rx0[0],
                   ~ds_rx1[7], ~ds_rx1[6]};
// no controller attached: the line reads all ones -> pad would be all zeros already;
// ignore impossible "everything pressed" patterns from a floating input
wire [11:0] pad_ds = (&pad) ? 12'd0 : pad;

// GPIO buttons: synchronise, sample every ~1.9 ms, accept two equal samples (debounce)
reg  [7:0] key_s1, key_s2, key_a, key_b, key_q;
reg [15:0] key_div;
always @(posedge clk_sys) begin
    key_s1  <= ~key_n;
    key_s2  <= key_s1;
    key_div <= key_div + 1'd1;
    if (key_div == 0) begin
        key_a <= key_s2;
        key_b <= key_a;
        if (key_a == key_b) key_q <= key_a;
    end
    if (sys_rst) key_q <= 0;
end
//                     A         RIGHT     LEFT      DOWN      UP        START     SELECT        B
wire [11:0] pad_gpio = {3'b000, key_q[4], key_q[3], key_q[2], key_q[1], key_q[0], key_q[7], key_q[6], 1'b0, key_q[5]};
// remote control over the USB-UART
wire [11:0] pad_uart;
wire        uart_menu, uart_reset;
uart_pad #(.CLK_HZ(33_750_000)) u_uart_pad (
    .clk(clk_sys), .reset(sys_rst), .rx(uart_rx),
    .pad(pad_uart), .key_menu(uart_menu), .key_reset(uart_reset)
);
wire [11:0] pad_ok   = pad_ds | pad_gpio | pad_uart;

// ================================================================ menu + loader
wire        menu_open, gbc_raw, lcd_crop, dbg_on;
wire  [1:0] sys_mode;
reg   [7:0] cart_type, rom_size;     // from the cart header while loading
wire  [1:0] disp_mode;
wire  [2:0] dmg_pal;
wire        menu_reset_req, load_req;
wire  [3:0] load_idx, game_count, cur_game;
wire [11:0] game_btn;
wire        name_we;
wire  [8:0] name_addr;
wire  [7:0] name_data;
wire        txt_we;
wire  [8:0] txt_waddr;
wire  [7:0] txt_wdata;
wire        loading, dir_valid;

menu u_menu (
    .clk(clk_sys), .reset(sys_rst),
    .btn(pad_ok), .key_menu(s1 | uart_menu), .key_reset(s2 | uart_reset),
    .game_count(game_count), .cur_game(cur_game), .loading(loading),
    .name_we(name_we), .name_waddr(name_addr), .name_wdata(name_data),
    .menu_open(menu_open), .disp_mode(disp_mode), .dmg_pal(dmg_pal),
    .gbc_raw(gbc_raw), .lcd_crop(lcd_crop), .sys_mode(sys_mode), .dbg_on(dbg_on),
    .frame_tick(lcd_vs_rise), .stat_gbc(isGBC), .stat_2x(speed),
    .cart_type(cart_type), .rom_size(rom_size),
    .reset_req(menu_reset_req), .load_req(load_req), .load_idx(load_idx),
    .game_btn(game_btn),
    .txt_we(txt_we), .txt_waddr(txt_waddr), .txt_wdata(txt_wdata)
);

wire        sdram_ready;
wire        ld_req, ld_ack;
wire [20:0] ld_addr;
wire [31:0] ld_data;
wire        ioctl_wr;
wire [24:0] ioctl_addr;
wire [15:0] ioctl_dout;

flash_loader u_loader (
    .clk(clk_sys), .reset(sys_rst), .sdram_ready(sdram_ready),
    .spi_cs_n(flash_cs_n), .spi_clk(flash_clk), .spi_mosi(flash_mosi), .spi_miso(flash_miso),
    .game_count(game_count), .dir_valid(dir_valid),
    .name_we(name_we), .name_addr(name_addr), .name_data(name_data),
    .load_req(load_req), .load_idx(load_idx), .cur_game(cur_game), .loading(loading),
    .ld_req(ld_req), .ld_addr(ld_addr), .ld_data(ld_data), .ld_ack(ld_ack),
    .ioctl_wr(ioctl_wr), .ioctl_addr(ioctl_addr), .ioctl_dout(ioctl_dout)
);

always @(posedge clk_sys) if (ioctl_wr) begin
    if (ioctl_addr == 25'h146) cart_type <= ioctl_dout[15:8];
    if (ioctl_addr == 25'h148) rom_size  <= ioctl_dout[7:0];
end

// ================================================================ Game Boy
wire ce, ce_n, ce_2x, paused;
ce_gen u_ce (.clk_sys(clk_sys), .pause(menu_open & ~loading), .ce(ce), .ce_n(ce_n), .ce_2x(ce_2x), .paused(paused));

// reset: power-on, loading, menu "reset game" (stretched)
reg [15:0] rst_stretch;
always @(posedge clk_sys) begin
    if (menu_reset_req) rst_stretch <= 16'hFFFF;
    else if (rst_stretch != 0) rst_stretch <= rst_stretch - 1'd1;
end
wire gb_reset = sys_rst | ~sdram_ready | loading | (rst_stretch != 0);

wire isGBC_game;
reg  isGBC = 0;
always @(posedge clk_sys) if (gb_reset) isGBC <= (sys_mode == 2'd1) | ((sys_mode == 2'd0) & isGBC_game);

wire [14:0] ext_bus_addr;
wire        ext_bus_a15, cart_rd, cart_wr, cart_oe, nCS, sdram_rd;
wire  [7:0] cart_do, cart_di;
wire [15:0] audio_l, audio_r;
wire        lcd_clkena, lcd_on, lcd_vsync;
wire [14:0] lcd_data;
wire  [1:0] lcd_data_gb, lcd_mode;
wire  [1:0] joy_p54;
wire        speed, DMA_on;
wire  [7:0] cart_ram_size;
wire [63:0] ss_ext_din, ss_ext_dout;
wire  [9:0] ss_ext_adr;
wire        ss_ext_wren, ss_ext_rst;

wire btn_a = game_btn[8] | game_btn[9];
wire btn_b = game_btn[0] | game_btn[1];
wire [3:0] joy_dir     = ~{game_btn[5], game_btn[4], game_btn[6], game_btn[7]} | {4{joy_p54[0]}};
wire [3:0] joy_buttons = ~{game_btn[3], game_btn[2], btn_b, btn_a} | {4{joy_p54[1]}};
wire [3:0] joy_din = joy_dir & joy_buttons;

`ifndef NO_CORE
gb u_gb (
    .reset(gb_reset),
    .clk_sys(clk_sys), .ce(ce), .ce_n(ce_n), .ce_2x(ce_2x),
    .joystick(8'd0), .isGBC(isGBC), .real_cgb_boot(1'b0), .isSGB(1'b0), .extra_spr_en(1'b0),
    .ext_bus_addr(ext_bus_addr), .ext_bus_a15(ext_bus_a15),
    .cart_rd(cart_rd), .cart_wr(cart_wr), .cart_do(cart_do), .cart_di(cart_di), .cart_oe(cart_oe),
    .nCS(nCS), .PHI(), .sdram_rd(sdram_rd),
    .cgb_boot_download(1'b0), .dmg_boot_download(1'b0), .sgb_boot_download(1'b0),
    .ioctl_wr(1'b0), .ioctl_addr(25'd0), .ioctl_dout(16'd0),
    .boot_gba_en(1'b0), .fast_boot_en(1'b0),
    .audio_l(audio_l), .audio_r(audio_r), .audio_no_pops(1'b0),
    .megaduck(1'b0),
    .lcd_clkena(lcd_clkena), .lcd_data(lcd_data), .lcd_data_gb(lcd_data_gb),
    .lcd_mode(lcd_mode), .lcd_on(lcd_on), .lcd_vsync(lcd_vsync),
    .joy_p54(joy_p54), .joy_din(joy_din),
    .speed(speed), .DMA_on(DMA_on),
    .gg_reset(1'b0), .gg_en(1'b0), .gg_code(129'd0), .gg_available(),
    .sc_int_clock2(), .serial_clk_in(1'b1), .serial_clk_out(), .serial_data_in(1'b1), .serial_data_out(),
    .increaseSSHeaderCount(1'b0), .cart_ram_size(cart_ram_size),
    .save_state(1'b0), .load_state(1'b0), .savestate_number(2'd0),
    .sleep_savestate(), .savestate_ovr(),
    .SaveStateExt_Din(ss_ext_din), .SaveStateExt_Adr(ss_ext_adr), .SaveStateExt_wren(ss_ext_wren),
    .SaveStateExt_rst(ss_ext_rst), .SaveStateExt_Dout(ss_ext_dout), .SaveStateExt_load(),
    .Savestate_CRAMAddr(), .Savestate_CRAMRdEn(), .Savestate_CRAMRWrEn(), .Savestate_CRAMWriteData(),
    .Savestate_CRAMReadData(16'd0),
    .SAVE_out_Din(), .SAVE_out_Dout(64'd0), .SAVE_out_Adr(), .SAVE_out_rnw(), .SAVE_out_ena(),
    .SAVE_out_be(), .SAVE_out_done(1'b0),
    .savestate_sdram_busy(1'b0), .rewind_on(1'b0), .rewind_active(1'b0)
);

wire [22:0] mbc_addr;
wire        is_cram_addr, cram_rd, cram_wr;
wire [16:0] cram_addr;
wire  [7:0] sdram_cart_dout;

reg ce_32k;
reg [9:0] ce_32k_div;
always @(posedge clk_sys) begin
    ce_32k_div <= ce_32k_div + 1'b1;
    ce_32k <= !ce_32k_div;
end

cart_top u_cart (
    .reset(gb_reset),
    .clk_sys(clk_sys), .ce_cpu(ce), .ce_cpu2x(ce_2x), .speed(speed),
    .megaduck(1'b0), .duck_md0_mode(1'b0), .mapper_sel(3'd0),
    .cart_addr(ext_bus_addr), .cart_a15(ext_bus_a15), .cart_rd(cart_rd), .cart_wr(cart_wr),
    .cart_do(cart_do), .cart_di(cart_di), .cart_oe(cart_oe),
    .nCS(nCS),
    .mbc_addr(mbc_addr),
    .dn_write(), .cart_ready(),
    .is_cram_addr(is_cram_addr), .cram_rd(cram_rd), .cram_wr(cram_wr), .cram_bram_wr(), .cram_addr(cram_addr),
    .cart_download(loading),
    .ram_mask_file(), .ram_size(cart_ram_size), .has_save(), .bram_save(),
    .isGBC_game(isGBC_game), .isSGB_game(),
    .ioctl_download(loading), .ioctl_wr(ioctl_wr), .ioctl_addr(ioctl_addr), .ioctl_dout(ioctl_dout), .ioctl_wait(),
    .bk_wr(1'b0), .bk_rtc_wr(1'b0), .bk_addr(17'd0), .bk_data(16'd0), .bk_q(), .img_size(64'd0),
    .rom_di(sdram_cart_dout),
    .joystick_analog_0(16'd0),
    .ce_32k(ce_32k), .RTC_time(33'd0), .RTC_timestampOut(), .RTC_savedtimeOut(), .RTC_inuse(),
    .SaveStateExt_Din(ss_ext_din), .SaveStateExt_Adr(ss_ext_adr), .SaveStateExt_wren(ss_ext_wren),
    .SaveStateExt_rst(ss_ext_rst), .SaveStateExt_Dout(ss_ext_dout),
    .savestate_load(1'b0), .savestate_ovr(1'b0),
    .Savestate_CRAMAddr(20'd0), .Savestate_CRAMRWrEn(1'b0), .Savestate_CRAMWriteData(16'd0), .Savestate_CRAM_Q(),
    .rumbling()
);

`else
assign sdram_rd = 1'b1;
assign lcd_clkena = 0; assign lcd_on = 0; assign lcd_vsync = 0; assign lcd_data = 0; assign lcd_mode = 0;
assign audio_l = 0; assign audio_r = 0; assign isGBC_game = 0; assign cram_wr = 0; assign is_cram_addr = 0; assign mbc_addr = 0; assign cram_addr = 0; assign cart_di = 0; assign cart_rd = 0;
`endif

// ================================================================ SDRAM
wire        lp_req, lp_ack, lp_we, lp_rvalid;
wire [20:0] lp_addr;
wire [31:0] lp_wdata, lp_rdata;
wire  [3:0] lp_be;
wire        gb_running = ~gb_reset & ~paused;

sdram_ctrl u_sdram (
    .clk(clk_sys), .resetn(~sys_rst), .ready(sdram_ready),
    .cart_rd_strobe(sdram_rd & ~gb_reset), .cart_wr_strobe(cram_wr & ~gb_reset),
    .cart_addr(is_cram_addr ? (CRAM_BASE | {6'd0, cram_addr}) : mbc_addr),
    .cart_din(cart_di), .cart_dout(sdram_cart_dout),
    .lp_block(gb_running & ~sdram_rd),
    .lp_req(lp_req), .lp_ack(lp_ack), .lp_we(lp_we), .lp_addr(lp_addr),
    .lp_wdata(lp_wdata), .lp_be(lp_be), .lp_rdata(lp_rdata), .lp_rvalid(lp_rvalid),
    .O_sdram_clk(O_sdram_clk), .O_sdram_cke(O_sdram_cke), .O_sdram_cs_n(O_sdram_cs_n),
    .O_sdram_ras_n(O_sdram_ras_n), .O_sdram_cas_n(O_sdram_cas_n), .O_sdram_wen_n(O_sdram_wen_n),
    .O_sdram_dqm(O_sdram_dqm), .O_sdram_addr(O_sdram_addr), .O_sdram_ba(O_sdram_ba),
    .IO_sdram_dq(IO_sdram_dq), .clk_sdram_p(clk_sys_p)
);

// ================================================================ framebuffer
wire        vs_tgl, line_req_tgl;
wire  [7:0] line_req_no;
reg   [2:0] vs_sync;
always @(posedge clk_sys) vs_sync <= {vs_sync[1:0], vs_tgl};
wire vs_event = vs_sync[2] ^ vs_sync[1];

wire  [1:0] rd_buf;
wire        wq_empty, wq_pop;
wire [20:0] wq_addr;
wire [31:0] wq_data;
wire  [5:0] wq_level;
wire        px_we, px_first;
wire [14:0] px_data;

fb_writer #(.FB_BASE_W(FB_BASE_W)) u_fbw (
    .clk(clk_sys), .reset(gb_reset), .ce(ce), .isGBC(isGBC),
    .lcd_clkena(lcd_clkena), .lcd_data(lcd_data), .lcd_mode(lcd_mode), .lcd_on(lcd_on), .lcd_vsync(lcd_vsync),
    .vs_event(vs_event), .rd_buf(rd_buf),
    .wq_empty(wq_empty), .wq_addr(wq_addr), .wq_data(wq_data), .wq_level(wq_level), .wq_pop(wq_pop),
    .px_we(px_we), .px_first(px_first), .px_data(px_data)
);

// ================================================================ SPI LCD
wire [8:0] lcd_txt_a;
reg  [7:0] lcd_txt_q;
lcd_st7735 #(.CLK_HZ(33_750_000)) u_lcd (
    .clk(clk_sys), .reset(sys_rst),
    .px_we(px_we), .px_first(px_first), .px_data(px_data),
    .isGBC(isGBC), .dmg_pal(dmg_pal), .gbc_raw(gbc_raw), .crop(lcd_crop), .menu_open(menu_open), .dbg_on(dbg_on),
    .txt_addr(lcd_txt_a), .txt_q(lcd_txt_q),
    .lcd_scl(lcd_scl), .lcd_sda(lcd_sda), .lcd_cs(lcd_cs), .lcd_dc(lcd_dc),
    .lcd_rst(lcd_rst), .lcd_bl(lcd_bl)
);

wire  [7:0] lb_raddr;
wire [31:0] lb_q;
memsys #(.FB_BASE_W(FB_BASE_W)) u_mem (
    .clk(clk_sys), .reset(sys_rst),
    .lp_req(lp_req), .lp_ack(lp_ack), .lp_we(lp_we), .lp_addr(lp_addr), .lp_wdata(lp_wdata),
    .lp_be(lp_be), .lp_rdata(lp_rdata), .lp_rvalid(lp_rvalid),
    .wq_empty(wq_empty), .wq_addr(wq_addr), .wq_data(wq_data), .wq_level(wq_level), .wq_pop(wq_pop),
    .ld_req(ld_req), .ld_addr(ld_addr), .ld_data(ld_data), .ld_ack(ld_ack),
    .line_req_tgl(line_req_tgl), .line_req_no(line_req_no), .rd_buf(rd_buf),
    .vclk(clk_p), .lb_raddr(lb_raddr), .lb_q(lb_q)
);

// ================================================================ OSD text RAM
// port A (clk_sys): menu writes, SPI LCD reads in between; port B (clk_p): HDMI reads
reg [7:0] txt_ram [0:511];
reg [7:0] txt_q;
wire [8:0] txt_raddr;
wire [8:0] txt_a = txt_we ? txt_waddr : lcd_txt_a;
always @(posedge clk_sys) begin
    if (txt_we) txt_ram[txt_a] <= txt_wdata;
    else        lcd_txt_q <= txt_ram[txt_a];
end
always @(posedge clk_p) txt_q <= txt_ram[txt_raddr];

// ================================================================ audio
wire        clk_audio;
wire [15:0] aud_l, aud_r;
audio_out u_audio (
    .clk(clk_sys), .ce(ce), .mute(gb_reset | paused),
    .in_l(audio_l), .in_r(audio_r),
    .clk_audio(clk_audio), .out_l(aud_l), .out_r(aud_r)
);
// HDMI audio clock in the pixel domain (74.25 MHz / 1547 = 48 kHz), like hdmi_test_top.
// Samples cross from clk_sys: accept a value only after it was stable for two clocks.
`ifdef VIDEO_720P
localparam [10:0] AUD_HALF = 11'd773;   // 74.25 MHz / 1547
`else
localparam [10:0] AUD_HALF = 11'd280;   // 27 MHz / 562
`endif
reg [10:0] aud_div = 0;
reg        clk_audio_p = 0;
always @(posedge clk_p) begin
    if (aud_div == AUD_HALF) begin aud_div <= 0; clk_audio_p <= ~clk_audio_p; end
    else aud_div <= aud_div + 1'd1;
end
reg [31:0] aud_s1, aud_s2, aud_hold;
always @(posedge clk_p) begin
    aud_s1 <= {aud_l, aud_r};
    aud_s2 <= aud_s1;
    if (aud_s1 == aud_s2) aud_hold <= aud_s2;
end
reg [31:0] aud_a;
always @(posedge clk_audio_p) aud_a <= aud_hold;
logic [15:0] audio_word [1:0];
assign audio_word[0] = aud_a[31:16];
assign audio_word[1] = aud_a[15:0];

// ================================================================ debug
reg  lcd_vs_q;
always @(posedge clk_sys) lcd_vs_q <= lcd_vsync;
wire lcd_vs_rise = lcd_vsync & ~lcd_vs_q;   // one per Game Boy frame (FPS counter)
reg dbg_frame, dbg_clkena, dbg_lpr, dbg_line, dbg_ld, dbg_ioctl, dbg_cartrd;
reg [7:0] dbg_byte;
always @(posedge clk_sys) begin
    if (lcd_clkena & ce)  dbg_clkena <= 1;
    if (lp_rvalid)        dbg_lpr    <= 1;
    if (vs_event)         dbg_frame  <= ~dbg_frame;
    if (ld_ack)           dbg_ld     <= 1;
    if (ioctl_wr)         dbg_ioctl  <= 1;
    if (cart_rd & ~gb_reset) dbg_cartrd <= 1;
    if (ld_ack && ld_addr == 21'h40) dbg_byte <= ld_data[7:0];  // ROM byte 0x100
end
wire [31:0] dbg = {pad, s1, s2, menu_open, paused, ds_rx0, ds_rx1, 2'b00};

// ================================================================ video
`ifdef VIDEO_720P
wire [10:0] cx, cx_h;
assign cx = cx_h;
`else
wire  [9:0] cx_h;
wire [10:0] cx = {1'b0, cx_h};
`endif
wire  [9:0] cy;
wire [23:0] rgb;

`ifdef VIDEO_720P
localparam P480 = 0;
`else
localparam P480 = 1;
`endif
video_out #(.P480(P480)) u_video (
    .clk(clk_p), .cx(cx), .cy(cy), .rgb(rgb),
    .line_req_tgl(line_req_tgl), .line_req_no(line_req_no), .vs_tgl(vs_tgl),
    .lb_addr(lb_raddr), .lb_q(lb_q),
    .txt_addr(txt_raddr), .txt_q(txt_q),
    .isGBC(isGBC), .dmg_pal(dmg_pal), .gbc_raw(gbc_raw), .disp_mode(disp_mode),
    .scale4(1'b0), .menu_open(menu_open), .dbg_on(dbg_on),
    .dbg(dbg)
);

wire [2:0] tmds;
wire       tmds_clock;
hdmi #(
    .VIDEO_ID_CODE(P480 ? 2 : 4), .DVI_OUTPUT(0), .VIDEO_REFRESH_RATE(P480 ? 59.94 : 60.0),
    .AUDIO_RATE(48000), .AUDIO_BIT_WIDTH(16),
    .VENDOR_NAME({"OpenGBC", 8'd0}), .PRODUCT_DESCRIPTION({"TangNano20K", 40'd0})
) u_hdmi (
    .clk_pixel_x5(clk_p5), .clk_pixel(clk_p), .clk_audio(clk_audio_p), .reset(hdmi_rst),
`ifdef HDMI_PATTERN
    .rgb({cx[7:0], cy[7:0], 8'h80}), .audio_sample_word(audio_word),
`else
    .rgb(rgb), .audio_sample_word(audio_word),
`endif
    .tmds(tmds), .tmds_clock(tmds_clock),
    .cx(cx_h), .cy(cy),
    .frame_width(), .frame_height(), .screen_width(), .screen_height()
);

TLVDS_OBUF u_obuf [3:0] (.I({tmds_clock, tmds}), .O({tmds_clk_p, tmds_d_p}), .OB({tmds_clk_n, tmds_d_n}));

assign led = {~menu_open, ~loading};

endmodule
