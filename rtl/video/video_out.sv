// HDMI video generator: scales the 160x144 Game Boy picture (480p: 3x, 720p: 5x/4x),
// applies DMG palettes / GBC colour correction / LCD-style display modes and draws the
// on-screen menu and the debug status lines on top. Runs in the HDMI pixel clock domain.
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

    // OSD text RAM read port: 16 x 16 menu characters (bit 7 = highlight) at 0,
    // debug lines at 256 + 64 * line
    output reg  [8:0] txt_addr,
    input       [7:0] txt_q,

    // settings (quasi static, from clk_sys domain)
    input             isGBC,
    input       [2:0] dmg_pal,
    input             gbc_raw,
    input       [1:0] disp_mode,    // 0 sharp, 1 grid, 2 scanlines
    input             scale4,
    input             menu_open,
    input             dbg_on,       // debug status lines (top / bottom border)
    input      [31:0] dbg            // debug bits shown as squares at the top left
);

// ------------------------------------------------------------ settings sync
reg [9:0] set_s1, set_s2;
always @(posedge clk) begin
    set_s1 <= {isGBC, dmg_pal, gbc_raw, disp_mode, scale4, menu_open, dbg_on};
    set_s2 <= set_s1;
end
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

// menu panel: 16 x 16 characters (same layout as the 128x128 SPI LCD),
// 24 px (480p, font 3x) or 32 px (720p, font 4x) cells
localparam [4:0]  CELL_MAX = P480 ? 5'd23 : 5'd31;
localparam [10:0] OSD_X0 = P480 ? 11'd168 : 11'd384, OSD_W = P480 ? 11'd384 : 11'd512;
localparam  [9:0] OSD_Y0 = P480 ? 10'd48  : 10'd104, OSD_H = P480 ? 10'd384 : 10'd512;

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
reg [4:0] osd_row;
reg [4:0] osd_suby;   // 0..31
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
            osd_row <= 0; osd_suby <= 0;
        end else if (osd_suby == CELL_MAX) begin
            osd_row <= osd_row + 1'd1; osd_suby <= 0;
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
reg [4:0] osd_col;
reg [4:0] osd_subx;
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
        if (osd_subx == CELL_MAX) begin osd_subx <= 0; osd_col <= osd_col + 1'd1; end
        else osd_subx <= osd_subx + 1'd1;
    end
end

// stage 2: memory addresses
reg vis2, osd2, edge2, scan2;
reg sel_hi2;
reg [2:0] fx2, fy2;
always @(posedge clk) begin
    lb_addr  <= {gb_row[0], gb_col[7:1]};
    sel_hi2  <= gb_col[0];
    vis2     <= col_vis & row_vis;
    edge2    <= (sub_x == smax) | (sub_y == smax);
    scan2    <= (sub_y == smax);
    if (dbg_cvis & dbg_rvis & s_dbg) begin
        txt_addr <= {1'b1, 1'b0, dbg_line, dbg_col};
        osd2     <= 1;
        fx2      <= dbg_fx;
        fy2      <= dbg_fy;
    end else begin
        txt_addr <= {1'b0, osd_row[3:0], osd_col[3:0]};
        osd2     <= osd_cvis & osd_rvis & s_menu;
        fx2      <= P480 ? osd_subx / 3 : osd_subx[4:2];
        fy2      <= P480 ? osd_suby / 3 : osd_suby[4:2];
    end
end

// stage 2d: align companions with the registered RAM outputs
reg vis2d, osd2d, edge2d, scan2d, sel_hi2d;
reg [2:0] fx2d;
always @(posedge clk) begin
    vis2d    <= vis2;
    osd2d    <= osd2;
    edge2d   <= edge2;
    scan2d   <= scan2;
    sel_hi2d <= sel_hi2;
    fx2d     <= fx2;
end

// stage 3: memory data available, font lookup
reg vis3, osd3, edge3, scan3, hl3;
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
    hl3    <= txt_q[7];
    fx3    <= fx2d;
    font_q <= font_rom[{txt_q[6:0], fy2}];
end

// stage 4: colour
wire [23:0] game_rgb;
gb_color u_color (.pix(pix3), .gbc(s_gbc), .pal(s_pal), .raw(s_raw), .rgb(game_rgb));

reg vis4, osd4, edge4, scan4, hl4, fbit4;
reg [23:0] game4;
always @(posedge clk) begin
    vis4  <= vis3;
    osd4  <= osd3;
    edge4 <= edge3;
    scan4 <= scan3;
    hl4   <= hl3;
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

localparam [23:0] BORDER = 24'h000000;
localparam [23:0] ACCENT = 24'h3A6FF0;
localparam [23:0] TEXT   = 24'hF2F2F2;

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
        if (fbit4)      rgb <= TEXT;
        else if (hl4)   rgb <= ACCENT;
        else            rgb <= dim(g5c);
    end else if (s_menu)
        rgb <= half(g5c);
    else
        rgb <= g5c;
end

endmodule
