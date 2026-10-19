// HDMI video generator: scales the 160x144 Game Boy picture (480p: 3x, 720p: 5x/4x),
// applies DMG palettes / GBC colour correction / LCD-style display modes and draws the
// on-screen display (42 x 24 cells of 16 x 20 px with colour attributes, written by the
// menu firmware) and the debug status lines on top. Runs in the HDMI pixel clock domain.
module video_out #(
    parameter P480 = 0             // 1: 720x480 (GB 3x), 0: 1280x720 (GB 5x/4x)
) (
    input             clk,          // 74.25 MHz
    input      [10:0] cx,           // from hdmi: current position
    input       [9:0] cy,
    output reg [23:0] rgb,

    // line fetch requests to the clk_sys domain
    output reg        line_req_tgl,
    output reg  [7:0] line_req_no,
    output reg        vs_tgl,

    // line buffer read port (written in clk_sys domain)
    output reg  [7:0] lb_addr,      // {line[0], pair[6:0]}
    input      [31:0] lb_q,

    // debug text RAM read port: debug lines at 256 + 64 * line
    output reg  [8:0] txt_addr,
    input       [7:0] txt_q,

    // OSD RAM read port: 42 x 24 cells {attr[15:8] = bg[7:4] fg[3:0], char[7:0]};
    // char bit 7 repeats the top / bottom glyph row into the cell padding (box drawing)
    output reg  [9:0] osd_addr,
    input      [15:0] osd_q,

    // settings (quasi static, from clk_sys domain)
    input             isGBC,
    input       [2:0] dmg_pal,
    input             gbc_raw,
    input       [1:0] disp_mode,    // 0 sharp, 1 grid, 2 scanlines
    input             scale4,
    input             menu_open,    // OSD visible
    input             osd_dim,      // dim the game behind the OSD (menu) or not (toast)
    input             dbg_on,       // debug status lines (top / bottom border)
    input      [31:0] dbg            // debug bits shown as squares at the top left
);

// ------------------------------------------------------------ settings sync
reg [10:0] set_s1, set_s2;
always @(posedge clk) begin
    set_s1 <= {osd_dim, isGBC, dmg_pal, gbc_raw, disp_mode, scale4, menu_open, dbg_on};
    set_s2 <= set_s1;
end
wire       s_dim   = set_s2[10];
wire       s_gbc   = set_s2[9];
wire [2:0] s_pal   = set_s2[8:6];
wire       s_raw   = set_s2[5];
wire [1:0] s_disp  = set_s2[4:3];
wire       s_x4    = set_s2[2];
wire       s_menu  = set_s2[1];
wire       s_dbg   = set_s2[0];

// ------------------------------------------------------------ geometry
localparam LAT = 6;                       // pipeline depth from position to rgb
wire [10:0] gx0   = P480 ? 11'd120 : s_x4 ? 11'd320 : 11'd240;
wire  [9:0] gy0   = P480 ? 10'd24  : s_x4 ? 10'd72  : 10'd0;
wire  [2:0] smax  = P480 ? 3'd2    : s_x4 ? 3'd3 : 3'd4;   // scale - 1
wire [10:0] gw    = P480 ? 11'd480 : s_x4 ? 11'd640 : 11'd800;
wire  [9:0] gh    = P480 ? 10'd432 : s_x4 ? 10'd576 : 10'd720;

// horizontal events in the blanking interval, last line of the frame
localparam [10:0] H_ROW  = P480 ? 11'd730 : 11'd1290;
localparam [10:0] H_REQ  = P480 ? 11'd740 : 11'd1300;
localparam [10:0] H_LINE = P480 ? 11'd850 : 11'd1640;
localparam  [9:0] V_LAST = P480 ? 10'd524 : 10'd749;

// OSD: 42 x 24 cells of 16 x 20 px (font 2x, 2 px padding above and below)
localparam [10:0] OSD_X0 = P480 ? 11'd24 : 11'd304, OSD_W = 11'd672;
localparam  [9:0] OSD_Y0 = P480 ? 10'd0  : 10'd120, OSD_H = 10'd480;

// debug lines: 42 characters of 16 px (font 2x) in the top and bottom border
localparam [10:0] DBG_X0 = 11'd24, DBG_W = 11'd672;
localparam  [9:0] DBG_Y0 = P480 ? 10'd4 : 10'd8, DBG_Y1 = P480 ? 10'd460 : 10'd696;

// position being computed this cycle
wire [10:0] X = cx + LAT;
wire  [9:0] Y = cy;

// ---- per-line state, updated at the start of each line (cx == 0)
reg [7:0] gb_row;     // GB line of current HDMI line
reg [2:0] sub_y;
reg       row_vis;
reg [9:0] osd_rbase;  // row * 42
reg [4:0] osd_suby;   // 0..19
reg       osd_rvis;
reg       dbg_rvis, dbg_line;
reg [2:0] dbg_fy;

// line request logic runs at cx == 1300 for the *next* line
wire [9:0] Yn = (cy == V_LAST) ? 10'd0 : cy + 1'd1;
reg  [9:0] yrel_n;    // Yn - gy0 (mod)
reg  [7:0] nrow;      // GB row of next line
reg  [2:0] nsub;

always @(posedge clk) begin
    if (cx == H_ROW) begin
        // advance the row trackers for the next line
        if (Yn == gy0) begin
            nrow <= 0; nsub <= 0;
        end else if (nsub == smax) begin
            nrow <= nrow + 1'd1; nsub <= 0;
        end else
            nsub <= nsub + 1'd1;
    end
    if (cx == H_REQ) begin
        // request GB line k+1 at the first sub-line of GB line k, line 0 one row-height early
        if (Yn >= gy0 && Yn < gy0 + gh && nsub == 0 && nrow < 8'd143) begin
            line_req_no  <= nrow + 1'd1;
            line_req_tgl <= ~line_req_tgl;
        end
        if (Yn == ((gy0 == 0) ? V_LAST - 10'd4 : gy0 - 10'd3)) begin
            line_req_no  <= 8'd0;
            line_req_tgl <= ~line_req_tgl;
        end
        if (Yn == ((gy0 == 0) ? V_LAST - 10'd14 : gy0 - 10'd10))
            vs_tgl <= ~vs_tgl;
    end
    if (cx == H_LINE) begin
        gb_row  <= nrow;
        sub_y   <= nsub;
        row_vis <= (Yn >= gy0) && (Yn < gy0 + gh);
        if (Yn == OSD_Y0) begin
            osd_rbase <= 0; osd_suby <= 0;
        end else if (osd_suby == 5'd19) begin
            osd_rbase <= osd_rbase + 10'd42; osd_suby <= 0;
        end else
            osd_suby <= osd_suby + 1'd1;
        osd_rvis <= (Yn >= OSD_Y0) && (Yn < OSD_Y0 + OSD_H);
        dbg_rvis <= ((Yn >= DBG_Y0) && (Yn < DBG_Y0 + 10'd16)) || ((Yn >= DBG_Y1) && (Yn < DBG_Y1 + 10'd16));
        dbg_line <= (Yn >= DBG_Y1);
        dbg_fy   <= (Yn >= DBG_Y1) ? Yn[3:1] - DBG_Y1[3:1] : Yn[3:1] - DBG_Y0[3:1];
    end
end

// ---- per-pixel counters (stage 1)
reg [7:0] gb_col;
reg [2:0] sub_x;
reg       col_vis;
reg [5:0] osd_col;
reg [3:0] osd_subx;
reg       osd_cvis;
reg       dbg_cvis;
reg [5:0] dbg_col;
reg [2:0] dbg_fx;
wire [10:0] dbg_dx = X - DBG_X0;

always @(posedge clk) begin
    if (X == gx0) begin
        gb_col <= 0; sub_x <= 0; col_vis <= 1;
    end else begin
        if (X == gx0 + gw) col_vis <= 0;
        if (sub_x == smax) begin sub_x <= 0; gb_col <= gb_col + 1'd1; end
        else sub_x <= sub_x + 1'd1;
    end
    dbg_cvis <= (X >= DBG_X0) && (X < DBG_X0 + DBG_W);
    dbg_col  <= dbg_dx[9:4];
    dbg_fx   <= dbg_dx[3:1];
    if (X == OSD_X0) begin
        osd_col <= 0; osd_subx <= 0; osd_cvis <= 1;
    end else begin
        if (X == OSD_X0 + OSD_W) osd_cvis <= 0;
        if (osd_subx == 4'd15) osd_col <= osd_col + 1'd1;
        osd_subx <= osd_subx + 1'd1;
    end
end

// stage 2: memory addresses
reg vis2, osd2, edge2, scan2, src2, pad2;
reg sel_hi2;
reg [2:0] fx2, fy2;
always @(posedge clk) begin
    lb_addr  <= {gb_row[0], gb_col[7:1]};
    sel_hi2  <= gb_col[0];
    vis2     <= col_vis & row_vis;
    edge2    <= (sub_x == smax) | (sub_y == smax);
    scan2    <= (sub_y == smax);
    txt_addr <= {1'b1, 1'b0, dbg_line, dbg_col};
    osd_addr <= osd_rbase + osd_col;
    if (osd_cvis & osd_rvis & s_menu) begin
        osd2 <= 1; src2 <= 1;
        fx2  <= osd_subx[3:1];
        pad2 <= (osd_suby < 5'd2) || (osd_suby >= 5'd18);
        fy2  <= (osd_suby < 5'd2) ? 3'd0 : (osd_suby >= 5'd18) ? 3'd7 : osd_suby[3:1] - 3'd1;
    end else begin
        osd2 <= dbg_cvis & dbg_rvis & s_dbg & ~s_menu; src2 <= 0;
        fx2  <= dbg_fx;
        fy2  <= dbg_fy;
        pad2 <= 0;
    end
end

// stage 2d: align companions with the registered RAM outputs
reg vis2d, osd2d, edge2d, scan2d, sel_hi2d, src2d, pad2d;
reg [2:0] fx2d, fy2d;
always @(posedge clk) begin
    src2d    <= src2;
    pad2d    <= pad2;
    fy2d     <= fy2;
    vis2d    <= vis2;
    osd2d    <= osd2;
    edge2d   <= edge2;
    scan2d   <= scan2;
    sel_hi2d <= sel_hi2;
    fx2d     <= fx2;
end

// stage 3: memory data available, font lookup
reg vis3, osd3, edge3, scan3;
reg [7:0] attr3;
reg [14:0] pix3;
reg [2:0] fx3;
reg [7:0] font_q;
reg [7:0] font_rom [0:1023];
initial $readmemh("rtl/video/font8x8.hex", font_rom);
always @(posedge clk) begin
    pix3   <= sel_hi2d ? lb_q[30:16] : lb_q[14:0];
    vis3   <= vis2d;
    osd3   <= osd2d;
    edge3  <= edge2d;
    scan3  <= scan2d;
    attr3  <= src2d ? osd_q[15:8] : 8'h07;
    fx3    <= fx2d;
    if (src2d && pad2d && !osd_q[7]) font_q <= 8'h00;
    else font_q <= font_rom[{src2d ? osd_q[6:0] : txt_q[6:0], fy2d}];
end

// stage 4: colour
wire [23:0] game_rgb;
gb_color u_color (.pix(pix3), .gbc(s_gbc), .pal(s_pal), .raw(s_raw), .rgb(game_rgb));

reg vis4, osd4, edge4, scan4, fbit4;
reg [7:0] attr4;
reg [23:0] game4;
always @(posedge clk) begin
    vis4  <= vis3;
    osd4  <= osd3;
    edge4 <= edge3;
    scan4 <= scan3;
    attr4 <= attr3;
    fbit4 <= font_q[3'd7 - fx3];
    game4 <= game_rgb;
end

// stage 5: display mode, OSD compose
function automatic [23:0] scale34(input [23:0] c);   // x0.75
    scale34 = {c[23:16] - c[23:18], c[15:8] - c[15:10], c[7:0] - c[7:2]};
endfunction
function automatic [23:0] half(input [23:0] c);
    half = {1'b0, c[23:17], 1'b0, c[15:9], 1'b0, c[7:1]};
endfunction
function automatic [23:0] dim(input [23:0] c);       // x0.375
    dim = {2'b0, c[23:18], 2'b0, c[15:10], 2'b0, c[7:2]} + {3'b0, c[23:19], 3'b0, c[15:11], 3'b0, c[7:3]};
endfunction

function automatic [23:0] quarter(input [23:0] c);    // x1/8
    quarter = {3'b0, c[23:19], 3'b0, c[15:11], 3'b0, c[7:3]};
endfunction

localparam [23:0] BORDER = 24'h000000;

// OSD palette; 0 = game (dimmed in menu mode), 15 = game at 1/8 brightness
function automatic [23:0] pal16(input [3:0] i);
    case (i)
        4'd1:  pal16 = 24'h000000;
        4'd2:  pal16 = 24'h121212;
        4'd3:  pal16 = 24'h242424;
        4'd4:  pal16 = 24'h3C3C3C;
        4'd5:  pal16 = 24'h7A7A7A;
        4'd6:  pal16 = 24'hBEBEBE;
        4'd7:  pal16 = 24'hFFFFFF;
        4'd8:  pal16 = 24'h3A6FF0;
        4'd9:  pal16 = 24'h2ECC71;
        4'd10: pal16 = 24'hF5C518;
        4'd11: pal16 = 24'hE5483C;
        4'd12: pal16 = 24'h9B6BE0;
        4'd13: pal16 = 24'h0E1A33;
        4'd14: pal16 = 24'h20B8A0;
        default: pal16 = 24'h000000;
    endcase
endfunction

reg [23:0] g5c;
always @* begin
    if (!vis4) g5c = BORDER;
    else case (s_disp)
        2'd1:    g5c = edge4 ? scale34(game4) : game4;
        2'd2:    g5c = scan4 ? half(game4) : game4;
        default: g5c = game4;
    endcase
end

// debug squares: 32 cells of 16x16 px on line 4..19, bit 31 first
reg [31:0] dbg_s1, dbg_s2;
always @(posedge clk) begin dbg_s1 <= dbg; dbg_s2 <= dbg_s1; end
`ifdef DEBUG_SQUARES
wire dbg_area = (cy >= 10'd4) && (cy < 10'd20) && (cx < 11'd512);
`else
wire dbg_area = 1'b0;
`endif
wire dbg_bit  = dbg_s2[5'd31 - cx[8:4]];

always @(posedge clk) begin
    if (dbg_area)
        rgb <= (cx[3:0] == 0) ? 24'h000000 : (dbg_bit ? 24'h00E000 : 24'hC00000);
    else if (osd4) begin
        if (fbit4)                    rgb <= pal16(attr4[3:0]);
        else if (attr4[7:4] == 4'd0)  rgb <= s_dim ? dim(g5c) : g5c;
        else if (attr4[7:4] == 4'd15) rgb <= quarter(g5c);
        else                          rgb <= pal16(attr4[7:4]);
    end else if (s_menu & s_dim)
        rgb <= dim(g5c);
    else
        rgb <= g5c;
end

endmodule
