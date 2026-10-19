// 128x128 ST7735S SPI LCD output (1.44" modules, 4-wire SPI, RGB565).
//
// The Game Boy pixel stream (same as the SDRAM framebuffer writer) is converted to RGB,
// scaled and stored in a 128x128 x 13 bit BSRAM frame (R4 G5 B4):
//   fit  : 160x144 -> 128x115 with a 2-tap filter in both directions (5 -> 4), letterboxed
//   crop : centre 128x128 1:1
// A free-running SPI engine sends the frame to the panel continuously (~64 fps at
// 16.9 MHz SCL) and draws the menu on top while it is open: 16 x 12 cells of 8 x 10 px
// (4 px margin above and below) with {bg, fg, char} per cell, like the HDMI OSD.
module lcd_st7735 #(
    parameter        CLK_HZ   = 33_750_000,
    parameter        SPI_HALF = 1,          // SCL half period in clk cycles (1: clk/2)
    parameter  [7:0] MADCTL   = 8'hC8,      // MY|MX|BGR: usual for the 1.44" red-board modules
    parameter  [7:0] X_OFS    = 8'd2,       // panel RAM is 132x162; window offset
    parameter  [7:0] Y_OFS    = 8'd3,
    parameter        INVERT   = 0           // 1: send INVON (some IPS variants)
) (
    input             clk,
    input             reset,

    // pixel stream from fb_writer
    input             px_we,
    input             px_first,      // first pixel of a frame
    input      [14:0] px_data,

    // settings (clk domain)
    input             isGBC,
    input       [2:0] dmg_pal,
    input             gbc_raw,
    input             crop,
    input             menu_open,
    input             dbg_on,        // debug status line in the top text row

    // menu text RAM read port: 16 x 12 cells {attr, char} at 0, debug line at 384,
    // one cycle latency; char bit 7 repeats the top / bottom glyph row into the padding
    output reg  [8:0] txt_addr,
    input      [15:0] txt_q,

    output reg        lcd_scl,
    output            lcd_sda,
    output reg        lcd_cs,
    output reg        lcd_dc,
    output reg        lcd_rst,
    output            lcd_bl
);

assign lcd_bl = 1'b1;

// ================================================================ capture + scaling
// position of the incoming pixel; phases count 0..4 inside each group of 5 pixels/lines
reg [7:0] sx, sy;
reg [2:0] hx, vy;
reg [4:0] hg, vg;
wire [7:0] cx  = px_first ? 8'd0 : sx;
wire [7:0] cy  = px_first ? 8'd0 : sy;
wire [2:0] chx = px_first ? 3'd0 : hx;
wire [2:0] cvy = px_first ? 3'd0 : vy;
wire [4:0] chg = px_first ? 5'd0 : hg;
wire [4:0] cvg = px_first ? 5'd0 : vg;

wire [23:0] px_rgb;
gb_color u_color (.pix(px_data), .gbc(isGBC), .pal(dmg_pal), .raw(gbc_raw), .rgb(px_rgb));

// stage 1: colour, position
reg        s1_v;
reg [17:0] s1_c;                 // 6 bits per channel
reg [7:0]  s1_x, s1_y;
reg [2:0]  s1_hx, s1_vy;
reg [4:0]  s1_hg, s1_vg;
always @(posedge clk) begin
    s1_v <= px_we;
    if (px_we) begin
        s1_c  <= {px_rgb[23:18], px_rgb[15:10], px_rgb[7:2]};
        s1_x  <= cx;  s1_y  <= cy;
        s1_hx <= chx; s1_vy <= cvy;
        s1_hg <= chg; s1_vg <= cvg;
        if (cx == 8'd159) begin
            sx <= 0; hx <= 0; hg <= 0;
            sy <= cy + 1'd1;
            vy <= (cvy == 3'd4) ? 3'd0 : cvy + 1'd1;
            vg <= (cvy == 3'd4) ? cvg + 1'd1 : cvg;
        end else begin
            sx <= cx + 1'd1;
            hx <= (chx == 3'd4) ? 3'd0 : chx + 1'd1;
            hg <= (chx == 3'd4) ? chg + 1'd1 : chg;
            sy <= cy; vy <= cvy; vg <= cvg;
        end
    end
    if (reset) begin
        sx <= 0; sy <= 0; hx <= 0; vy <= 0; hg <= 0; vg <= 0;
    end
end

// 2-tap blend per channel: w 0 = (3a+b)/4, 1 = (a+b)/2, 2 = (a+3b)/4
function automatic [5:0] mix(input [5:0] a, input [5:0] b, input [1:0] w);
    reg [7:0] s;
    case (w)
        2'd0:    s = {a, 1'b0} + a + b;
        2'd1:    s = {a, 1'b0} + {b, 1'b0};
        default: s = a + {b, 1'b0} + b;
    endcase
    mix = s[7:2];
endfunction
function automatic [17:0] mix3(input [17:0] a, input [17:0] b, input [1:0] w);
    mix3 = {mix(a[17:12], b[17:12], w), mix(a[11:6], b[11:6], w), mix(a[5:0], b[5:0], w)};
endfunction
// phase 1..4 -> weight
function automatic [1:0] wsel(input [2:0] ph);
    wsel = (ph == 3'd1) ? 2'd0 : (ph == 3'd4) ? 2'd2 : 2'd1;
endfunction

// stage 2: horizontal filter (fit) or crop window
reg [17:0] prev;
reg        s2_v;
reg [17:0] s2_c;
reg [6:0]  s2_ox, s2_crow;
reg [2:0]  s2_vy;
reg [4:0]  s2_vg;
reg        s2_crop;
wire       in_crop = (s1_x >= 8'd16) && (s1_x < 8'd144) && (s1_y >= 8'd8) && (s1_y < 8'd136);
wire [7:0] crop_x  = s1_x - 8'd16;
wire [7:0] crop_y  = s1_y - 8'd8;
always @(posedge clk) begin
    s2_v <= 0;
    if (s1_v) begin
        prev    <= s1_c;
        s2_crop <= crop;
        s2_vy   <= s1_vy;
        s2_vg   <= s1_vg;
        s2_crow <= crop_y[6:0];
        if (crop) begin
            s2_v  <= in_crop;
            s2_c  <= s1_c;
            s2_ox <= crop_x[6:0];
        end else begin
            s2_v  <= (s1_hx != 3'd0) && (s1_y < 8'd144);
            s2_c  <= mix3(prev, s1_c, wsel(s1_hx));
            s2_ox <= {s1_hg, s1_hx[1:0] - 2'd1};
        end
    end
end

// stage 3: read the previous filtered line
reg [17:0] lbuf [0:127];
reg [17:0] lb_q;
reg        s3_v;
reg [17:0] s3_c;
reg [6:0]  s3_ox, s3_crow;
reg [2:0]  s3_vy;
reg [4:0]  s3_vg;
reg        s3_crop;
always @(posedge clk) begin
    lb_q    <= lbuf[s2_ox];
    s3_v    <= s2_v;
    s3_c    <= s2_c;
    s3_ox   <= s2_ox;
    s3_crow <= s2_crow;
    s3_vy   <= s2_vy;
    s3_vg   <= s2_vg;
    s3_crop <= s2_crop;
end

// stage 4: vertical filter, frame write
reg [8:0] fb_hi [0:16383];       // R4 G5
reg [3:0] fb_lo [0:16383];       // B4
wire [17:0] vmix   = mix3(lb_q, s3_c, wsel(s3_vy));
wire [17:0] wcol   = s3_crop ? s3_c : vmix;
wire [6:0]  oy     = s3_crop ? s3_crow : {s3_vg, s3_vy[1:0] - 2'd1};
wire        fb_we  = s3_v && (s3_crop || s3_vy != 3'd0);
wire [13:0] fb_wa  = {oy, s3_ox};
always @(posedge clk) begin
    if (s3_v && !s3_crop) lbuf[s3_ox] <= s3_c;
    if (fb_we) begin
        fb_hi[fb_wa] <= {wcol[17:14], wcol[11:7]};
        fb_lo[fb_wa] <= wcol[5:2];
    end
end

// ================================================================ menu font
reg [7:0] font_rom [0:1023];
initial $readmemh("rtl/video/font8x8.hex", font_rom);

// ================================================================ SPI shifter (mode 0, MSB first)
reg        tx_busy;
reg [15:0] sh;
reg  [4:0] bits;
reg  [7:0] hdiv;
reg        tx_go;
reg        tx_16, tx_dc;
reg [15:0] tx_data;
assign lcd_sda = sh[15];
always @(posedge clk) begin
    if (reset) begin
        tx_busy <= 0;
        lcd_scl <= 0;
        sh      <= 0;
    end else if (tx_go && !tx_busy) begin
        tx_busy <= 1;
        sh      <= tx_16 ? tx_data : {tx_data[7:0], 8'h00};
        bits    <= tx_16 ? 5'd16 : 5'd8;
        lcd_dc  <= tx_dc;
        hdiv    <= SPI_HALF - 1;
    end else if (tx_busy) begin
        if (hdiv != 0) hdiv <= hdiv - 1'd1;
        else begin
            hdiv <= SPI_HALF - 1;
            if (!lcd_scl) lcd_scl <= 1;           // panel samples on the rising edge
            else begin
                lcd_scl <= 0;
                if (bits == 5'd1) tx_busy <= 0;
                else begin sh <= {sh[14:0], 1'b0}; bits <= bits - 1'd1; end
            end
        end
    end
end

// ================================================================ panel control
localparam integer MS = CLK_HZ / 1000;
reg [15:0] ms_div = 0;
reg        ms_tick;
always @(posedge clk) begin
    ms_tick <= 0;
    if (ms_div == MS - 1) begin ms_div <= 0; ms_tick <= 1; end
    else ms_div <= ms_div + 1'd1;
end

// init sequence: {kind, value}; kind 0 command, 1 data, 2 delay (ms), 3 end
function automatic [9:0] init_rom(input [4:0] i);
    case (i)
        5'd0:  init_rom = {2'd0, 8'h01};             // SWRESET
        5'd1:  init_rom = {2'd2, 8'd150};
        5'd2:  init_rom = {2'd0, 8'h11};             // SLPOUT
        5'd3:  init_rom = {2'd2, 8'd200};
        5'd4:  init_rom = {2'd0, 8'h3A};             // COLMOD
        5'd5:  init_rom = {2'd1, 8'h05};             //   16 bit/pixel
        5'd6:  init_rom = {2'd0, 8'h36};             // MADCTL
        5'd7:  init_rom = {2'd1, MADCTL};
        5'd8:  init_rom = {2'd0, 8'h2A};             // CASET
        5'd9:  init_rom = {2'd1, 8'h00};
        5'd10: init_rom = {2'd1, X_OFS};
        5'd11: init_rom = {2'd1, 8'h00};
        5'd12: init_rom = {2'd1, X_OFS + 8'd127};
        5'd13: init_rom = {2'd0, 8'h2B};             // RASET
        5'd14: init_rom = {2'd1, 8'h00};
        5'd15: init_rom = {2'd1, Y_OFS};
        5'd16: init_rom = {2'd1, 8'h00};
        5'd17: init_rom = {2'd1, Y_OFS + 8'd127};
        5'd18: init_rom = {2'd0, INVERT ? 8'h21 : 8'h20};   // INVON / INVOFF
        5'd19: init_rom = {2'd0, 8'h13};             // NORON
        5'd20: init_rom = {2'd2, 8'd10};
        5'd21: init_rom = {2'd0, 8'h29};             // DISPON
        5'd22: init_rom = {2'd2, 8'd20};
        default: init_rom = {2'd3, 8'h00};
    endcase
endfunction

localparam M_RST_LO = 3'd0, M_RST_HI = 3'd1, M_INIT = 3'd2, M_DELAY = 3'd3,
           M_RAMWR = 3'd4, M_FETCH = 3'd5, M_SEND = 3'd6;
reg  [2:0] m;
reg  [7:0] wait_ms;
reg  [4:0] ii;
reg [13:0] p;                    // pixel index, row-major
reg  [2:0] fcnt;
wire [9:0] ie = init_rom(ii);

// pixel fetch pipeline
reg [13:0] rd_a;
reg  [8:0] q_hi;
reg  [3:0] q_lo;
reg  [7:0] fq;
reg  [6:0] pr, pr_d, pr_dd;
reg  [6:0] pc, pc_d, pc_dd;
reg        inr, inr_d, inr_dd;
reg        dov, dov_d, dov_dd;      // debug overlay row
reg [15:0] pix565;
reg        s_menu1, s_menu2, s_crop1, s_crop2, s_dbg1, s_dbg2;
always @(posedge clk) begin
    s_menu1 <= menu_open; s_menu2 <= s_menu1;
    s_dbg1  <= dbg_on & ~menu_open; s_dbg2 <= s_dbg1;
    s_crop1 <= crop;      s_crop2 <= s_crop1;
end

always @(posedge clk) begin
    q_hi <= fb_hi[rd_a];
    q_lo <= fb_lo[rd_a];
    fq   <= font_rom[{txt_q[6:0], fy_d}];
    fext <= txt_q[7];
end

reg  [8:0]  q_hi_d;
reg  [3:0]  q_lo_d;
reg  [7:0]  attr_d;
reg         fext;
// text cell position, advanced pixel by pixel (p counts row-major from 0)
reg  [3:0]  ty;                 // row inside the cell, 0..9
reg  [3:0]  trow;               // cell row, 0..11
reg         tvis;               // inside the 12 text rows (y 4..123)
reg  [2:0]  fy, fy_d;
reg         tpad, tpad_d, tpad_dd, tvis_d, tvis_dd;
wire [15:0] game565 = {q_hi_d[8:5], q_hi_d[8], q_hi_d[4:0], q_hi_d[4], q_lo_d, q_lo_d[3]};
wire [15:0] g_in  = inr_dd ? game565 : 16'h0000;
// x0.375 per channel
wire [15:0] g_dim = {(g_in[15:11] >> 2) + (g_in[15:11] >> 3),
                     (g_in[10:5] >> 2) + (g_in[10:5] >> 3),
                     (g_in[4:0] >> 2) + (g_in[4:0] >> 3)};
localparam [15:0] C_TEXT   = 16'hFFFF;
// x1/8 for the menu backdrop
wire [15:0] g_eighth = {2'b0, g_in[15:13], 3'b0, g_in[10:8], 2'b0, g_in[4:2]};
// OSD palette in RGB565 (same colours as video_out pal16)
function automatic [15:0] pal565(input [3:0] i);
    case (i)
        4'd1:  pal565 = 16'h0000;
        4'd2:  pal565 = 16'h1082;
        4'd3:  pal565 = 16'h2124;
        4'd4:  pal565 = 16'h39E7;
        4'd5:  pal565 = 16'h7BCF;
        4'd6:  pal565 = 16'hBDF7;
        4'd7:  pal565 = 16'hFFFF;
        4'd8:  pal565 = 16'h3B7E;
        4'd9:  pal565 = 16'h2E6E;
        4'd10: pal565 = 16'hF623;
        4'd11: pal565 = 16'hE247;
        4'd12: pal565 = 16'h9B5C;
        4'd13: pal565 = 16'h08C6;
        4'd14: pal565 = 16'h25D4;
        default: pal565 = 16'h0000;
    endcase
endfunction
wire       fbit   = fq[3'd7 - pc_dd[2:0]] & (~tpad_dd | fext_d);
reg        fext_d;
wire [3:0] a_fg   = attr_d[3:0];
wire [3:0] a_bg   = attr_d[7:4];

always @(posedge clk) begin
    tx_go <= 0;
    case (m)
        M_RST_LO: begin
            lcd_rst <= 0; lcd_cs <= 1;
            if (ms_tick) begin
                if (wait_ms == 8'd10) begin m <= M_RST_HI; wait_ms <= 0; end
                else wait_ms <= wait_ms + 1'd1;
            end
        end
        M_RST_HI: begin
            lcd_rst <= 1;
            if (ms_tick) begin
                if (wait_ms == 8'd120) begin m <= M_INIT; ii <= 0; lcd_cs <= 0; end
                else wait_ms <= wait_ms + 1'd1;
            end
        end
        M_INIT: if (!tx_busy && !tx_go) begin
            case (ie[9:8])
                2'd0, 2'd1: begin
                    tx_go <= 1; tx_16 <= 0; tx_dc <= ie[8]; tx_data <= {8'h00, ie[7:0]};
                    ii <= ii + 1'd1;
                end
                2'd2: begin wait_ms <= ie[7:0]; m <= M_DELAY; end
                default: m <= M_RAMWR;
            endcase
        end
        M_DELAY: if (ms_tick) begin
            if (wait_ms == 0) begin ii <= ii + 1'd1; m <= M_INIT; end
            else wait_ms <= wait_ms - 1'd1;
        end
        M_RAMWR: if (!tx_busy && !tx_go) begin
            tx_go <= 1; tx_16 <= 0; tx_dc <= 0; tx_data <= 16'h002C;   // RAMWR
            p <= 0; fcnt <= 0;
            tvis <= 0; ty <= 0; trow <= 0;
            m <= M_FETCH;
        end
        M_FETCH: begin
            // cycle 0: addresses; 1: frame/text data; 2: font; 3: compose
            fcnt <= fcnt + 1'd1;
            case (fcnt)
                3'd0: begin
                    pr   <= p[13:7]; pc <= p[6:0];
                    inr  <= s_crop2 || (p[13:7] >= 7'd6 && p[13:7] < 7'd121);
                    rd_a <= s_crop2 ? p : {p[13:7] - 7'd6, p[6:0]};
                    txt_addr <= {1'b0, trow, p[6:3]};
                    dov      <= s_dbg2 && tvis && trow == 4'd0;
                    if (s_dbg2 && trow == 4'd0) txt_addr <= {5'b11000, p[6:3]};
                    fy       <= (ty == 4'd0) ? 3'd0 : (ty == 4'd9) ? 3'd7 : ty[2:0] - 3'd1;
                    tpad     <= (ty == 4'd0) || (ty == 4'd9);
                end
                3'd1: begin pr_d <= pr; pc_d <= pc; inr_d <= inr; dov_d <= dov; fy_d <= fy; tpad_d <= tpad; tvis_d <= tvis; end
                3'd2: begin
                    pr_dd <= pr_d; pc_dd <= pc_d; inr_dd <= inr_d; dov_dd <= dov_d; tpad_dd <= tpad_d; tvis_dd <= tvis_d;
                    q_hi_d <= q_hi; q_lo_d <= q_lo; attr_d <= txt_q[15:8]; fext_d <= fext;
                end
                default: begin
                    if (dov_dd)                     pix565 <= fbit ? C_TEXT : g_dim;
                    else if (s_menu2 && !tvis_dd)   pix565 <= g_eighth;
                    else if (s_menu2 && fbit)       pix565 <= pal565(a_fg);
                    else if (s_menu2)               pix565 <= (a_bg == 4'd0) ? g_dim : (a_bg == 4'd15) ? g_eighth : pal565(a_bg);
                    else                            pix565 <= g_in;
                    m <= M_SEND;
                end
            endcase
        end
        M_SEND: if (!tx_busy && !tx_go) begin
            tx_go <= 1; tx_16 <= 1; tx_dc <= 1; tx_data <= pix565;
            p <= p + 1'd1; fcnt <= 0;
            m <= (p == 14'h3FFF) ? M_RAMWR : M_FETCH;
            if (p[6:0] == 7'd127) begin                 // next pixel row
                if (p[13:7] == 7'd3)        begin tvis <= 1; ty <= 0; trow <= 0; end
                else if (p[13:7] == 7'd123) tvis <= 0;
                else if (ty == 4'd9)        begin ty <= 0; trow <= trow + 1'd1; end
                else                        ty <= ty + 1'd1;
            end
        end
        default: m <= M_RST_LO;
    endcase
    if (reset) begin
        m <= M_RST_LO; wait_ms <= 0; lcd_rst <= 0; lcd_cs <= 1;
    end
end

endmodule
