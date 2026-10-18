// Pocket-style on-screen menu: navigation, settings, actions and text rendering.
// Text goes to a 16x16 character RAM read by video_out and the SPI LCD (bit 7 = highlighted cell).
// The same RAM holds the debug status lines at 256 + 64 * line:
//   line 0: HDMI top border, line 1: HDMI bottom border, line 2: SPI LCD top row (16 chars)
module menu (
    input             clk,
    input             reset,

    // buttons: {R L X A RIGHT LEFT DOWN UP START SELECT Y B}, active high
    input      [11:0] btn,
    input             key_menu,      // board button S1
    input             key_reset,     // board button S2

    // game directory
    input       [3:0] game_count,
    input       [3:0] cur_game,
    input             loading,
    input             name_we,
    input       [8:0] name_waddr,
    input       [7:0] name_wdata,

    // state / settings
    output reg        menu_open,
    output reg  [1:0] disp_mode,
    output reg  [2:0] dmg_pal,
    output reg        gbc_raw,
    output reg        lcd_crop,      // SPI LCD: 0 fit (scaled 4/5), 1 crop 1:1
    output reg  [1:0] sys_mode,      // 0 auto, 1 force GBC, 2 force DMG
    output reg        dbg_on,        // status lines on the main screen

    // status shown in the debug lines
    input             frame_tick,    // one pulse per Game Boy frame
    input             stat_gbc,      // running in GBC mode
    input             stat_2x,       // GBC double speed
    input       [7:0] cart_type,     // header 0x147
    input       [7:0] rom_size,      // header 0x148

    // actions
    output reg        reset_req,     // pulse
    output reg        load_req,      // pulse
    output reg  [3:0] load_idx,

    // buttons for the Game Boy (gated while the menu is open)
    output     [11:0] game_btn,

    // text RAM write port
    output reg        txt_we,
    output reg  [8:0] txt_waddr,     // 0..255 menu, 256.. debug lines
    output reg  [7:0] txt_wdata
);

localparam B_B = 0, B_Y = 1, B_SEL = 2, B_START = 3, B_UP = 4, B_DOWN = 5,
           B_LEFT = 6, B_RIGHT = 7, B_A = 8, B_X = 9, B_L = 10, B_R = 11;

// ------------------------------------------------------------ input conditioning
reg [11:0] btn_q, btn_prev;
reg        armed;
reg [21:0] arm_cnt;      // pad accepted only after it was seen fully released once
                        // (the DS2 receiver starts with zeroed bytes = everything pressed)
reg [1:0] km_s, kr_s;
reg [15:0] key_div;
reg km_q, km_prev, kr_q, kr_prev;
always @(posedge clk) begin
    if (reset || btn != 0) begin
        if (!armed) arm_cnt <= 0;
    end else if (!armed) begin
        arm_cnt <= arm_cnt + 1'd1;
        if (&arm_cnt) armed <= 1;          // released for ~124 ms (several DS2 polls)
    end
    if (reset) armed <= 0;
    btn_q    <= armed ? btn : 12'd0;
    btn_prev <= btn_q;
    km_s     <= {km_s[0], key_menu};
    kr_s     <= {kr_s[0], key_reset};
    key_div  <= key_div + 1'd1;
    if (key_div == 0) begin           // ~2 ms sampling debounces the board buttons
        km_q <= km_s[1]; km_prev <= km_q;
        kr_q <= kr_s[1]; kr_prev <= kr_q;
    end
end
wire [11:0] press = btn_q & ~btn_prev;
wire km_press = (key_div == 1) && km_q && !km_prev;
wire kr_press = (key_div == 1) && kr_q && !kr_prev;

// auto repeat for the d-pad
reg [24:0] rep_cnt;
reg        rep_fire;
wire [3:0] dpad = {btn_q[B_RIGHT], btn_q[B_LEFT], btn_q[B_DOWN], btn_q[B_UP]};
always @(posedge clk) begin
    rep_fire <= 0;
    if (dpad == 0 || press[B_UP] || press[B_DOWN] || press[B_LEFT] || press[B_RIGHT])
        rep_cnt <= 0;
    else begin
        rep_cnt <= rep_cnt + 1'd1;
        if (rep_cnt == 25'd13_500_000) begin       // 0.4 s
            rep_fire <= 1;
            rep_cnt  <= 25'd13_500_000 - 25'd4_000_000;  // then every 0.12 s
        end
    end
end
wire up    = press[B_UP]    | (rep_fire & btn_q[B_UP]);
wire down  = press[B_DOWN]  | (rep_fire & btn_q[B_DOWN]);
wire left  = press[B_LEFT]  | (rep_fire & btn_q[B_LEFT]);
wire right = press[B_RIGHT] | (rep_fire & btn_q[B_RIGHT]);
wire ok    = press[B_A] | press[B_X];
wire back  = press[B_B];
wire combo = btn_q[B_START] & btn_q[B_SEL] & (press[B_START] | press[B_SEL]);

// ------------------------------------------------------------ menu state
localparam P_MAIN = 1'b0, P_GAMES = 1'b1;
localparam N_ITEMS = 4'd9;
reg       drawing;
wire      draw_start;
reg       page;
reg [3:0] cursor;
reg       dirty;
reg       release_wait;

assign game_btn = (menu_open || release_wait) ? 12'd0 : btn_q;

function automatic [2:0] wrap_inc(input [2:0] v, input [2:0] n);
    wrap_inc = (v == n - 1'd1) ? 3'd0 : v + 1'd1;
endfunction
function automatic [2:0] wrap_dec(input [2:0] v, input [2:0] n);
    wrap_dec = (v == 0) ? n - 1'd1 : v - 1'd1;
endfunction

reg [3:0] prev_cur_game;
reg       prev_loading;
reg [3:0] prev_count;

always @(posedge clk) begin
    reset_req <= 0;
    load_req  <= 0;

    prev_cur_game <= cur_game;
    prev_loading  <= loading;
    prev_count    <= game_count;
    if (prev_cur_game != cur_game || prev_loading != loading || prev_count != game_count)
        dirty <= 1;

    if (release_wait && btn_q == 0) release_wait <= 0;

    if (reset) begin
`ifdef MENU_AT_BOOT
        menu_open    <= 1;      // test builds: show the menu without a controller
`else
        menu_open    <= 0;
`endif
        page         <= P_MAIN;
        cursor       <= 0;
        disp_mode    <= 2'd1;     // LCD grid, like the Pocket's original display mode
        dmg_pal      <= 3'd2;     // Pocket palette
        gbc_raw      <= 0;
        lcd_crop     <= 0;
        sys_mode     <= 0;
        dbg_on       <= 0;
        dirty        <= 1;
        release_wait <= 0;
    end else if (!menu_open) begin
        if (combo || km_press) begin
            menu_open <= 1;
            page      <= P_MAIN;
            cursor    <= 0;
            dirty     <= 1;
        end
        if (kr_press) reset_req <= 1;
    end else begin
        // menu open
        if (combo || km_press) begin
            menu_open <= 0;
            release_wait <= 1;
        end else if (kr_press) begin
            reset_req <= 1;
            menu_open <= 0;
            release_wait <= 1;
        end else if (page == P_MAIN) begin
            if (up)   begin cursor <= (cursor == 0) ? N_ITEMS - 1'd1 : cursor - 1'd1; dirty <= 1; end
            if (down) begin cursor <= (cursor == N_ITEMS - 1'd1) ? 4'd0 : cursor + 1'd1; dirty <= 1; end
            if (back) begin menu_open <= 0; release_wait <= 1; end
            if (ok || left || right) begin
                dirty <= 1;
                case (cursor)
                    4'd0: if (ok) begin menu_open <= 0; release_wait <= 1; end
                    4'd1: if (ok) begin reset_req <= 1; menu_open <= 0; release_wait <= 1; end
                    4'd2: if (ok && game_count != 0) begin page <= P_GAMES; cursor <= cur_game; end
                    4'd3: disp_mode <= left ? wrap_dec({1'b0, disp_mode}, 3'd3) : wrap_inc({1'b0, disp_mode}, 3'd3);
                    4'd4: dmg_pal   <= left ? wrap_dec(dmg_pal, 3'd5) : wrap_inc(dmg_pal, 3'd5);
                    4'd5: gbc_raw   <= ~gbc_raw;
                    4'd6: lcd_crop  <= ~lcd_crop;
                    4'd7: sys_mode  <= left ? wrap_dec({1'b0, sys_mode}, 3'd3) : wrap_inc({1'b0, sys_mode}, 3'd3);
                    4'd8: dbg_on    <= ~dbg_on;
                    default: ;
                endcase
            end
        end else begin
            // games page
            if (up)   begin cursor <= (cursor == 0) ? game_count - 1'd1 : cursor - 1'd1; dirty <= 1; end
            if (down) begin cursor <= (cursor == game_count - 1'd1) ? 4'd0 : cursor + 1'd1; dirty <= 1; end
            if (back) begin page <= P_MAIN; cursor <= 4'd2; dirty <= 1; end
            if (ok) begin
                load_req  <= 1;
                load_idx  <= cursor;
                menu_open <= 0;
                release_wait <= 1;
                page      <= P_MAIN;
                cursor    <= 0;
                dirty     <= 1;
            end
        end
    end
    if (draw_start) dirty <= 0;
end

// ------------------------------------------------------------ debug status
// frames per second and uptime, counted in BCD
reg [25:0] sec_div;
reg        sec_tick;
reg  [7:0] fps_cnt, fps;          // BCD
reg  [7:0] up_s, up_m, up_h;      // BCD
reg [21:0] dbg_div;
wire       dbg_tick = dbg_on && (dbg_div == 0);   // ~8 refreshes per second
function automatic [7:0] bcd_inc(input [7:0] v, input [7:0] top);
    if (v == top)             bcd_inc = 8'h00;
    else if (v[3:0] == 4'h9)  bcd_inc = {v[7:4] + 4'd1, 4'h0};
    else                      bcd_inc = v + 8'd1;
endfunction
always @(posedge clk) begin
    dbg_div  <= dbg_div + 1'd1;
    sec_tick <= 0;
    if (sec_div == 26'd33_749_999) begin sec_div <= 0; sec_tick <= 1; end
    else sec_div <= sec_div + 1'd1;
    if (frame_tick) fps_cnt <= bcd_inc(fps_cnt, 8'h99);
    if (sec_tick) begin
        fps     <= fps_cnt;
        fps_cnt <= frame_tick ? 8'h01 : 8'h00;
        up_s    <= bcd_inc(up_s, 8'h59);
        if (up_s == 8'h59) begin
            up_m <= bcd_inc(up_m, 8'h59);
            if (up_m == 8'h59) up_h <= bcd_inc(up_h, 8'h99);
        end
    end
    if (reset) begin up_s <= 0; up_m <= 0; up_h <= 0; fps <= 0; fps_cnt <= 0; end
end

function automatic [7:0] hexd(input [3:0] d); hexd = 8'h30 + d; endfunction
// pressed buttons as letters, '-' when released: U D L R A B s(elect) S(tart)
function automatic [7:0] padc(input [2:0] i);
    case (i)
        3'd0: padc = btn_q[B_UP]    ? "U" : "-";
        3'd1: padc = btn_q[B_DOWN]  ? "D" : "-";
        3'd2: padc = btn_q[B_LEFT]  ? "L" : "-";
        3'd3: padc = btn_q[B_RIGHT] ? "R" : "-";
        3'd4: padc = (btn_q[B_A] | btn_q[B_X]) ? "A" : "-";
        3'd5: padc = (btn_q[B_B] | btn_q[B_Y]) ? "B" : "-";
        3'd6: padc = btn_q[B_SEL]   ? "s" : "-";
        default: padc = btn_q[B_START] ? "S" : "-";
    endcase
endfunction

// line 0: "FPS 59  GBC 2X  PAD UDLRABsS  UP 01:23:45"
function automatic [7:0] dbg_line0(input [5:0] c);
    case (c)
        6'd0: dbg_line0 = "F"; 6'd1: dbg_line0 = "P"; 6'd2: dbg_line0 = "S";
        6'd4: dbg_line0 = hexd(fps[7:4]); 6'd5: dbg_line0 = hexd(fps[3:0]);
        6'd8:  dbg_line0 = stat_gbc ? "G" : "D";
        6'd9:  dbg_line0 = stat_gbc ? "B" : "M";
        6'd10: dbg_line0 = stat_gbc ? "C" : "G";
        6'd12: dbg_line0 = stat_2x ? "2" : "1"; 6'd13: dbg_line0 = "X";
        6'd16: dbg_line0 = "P"; 6'd17: dbg_line0 = "A"; 6'd18: dbg_line0 = "D";
        6'd20, 6'd21, 6'd22, 6'd23, 6'd24, 6'd25, 6'd26, 6'd27: dbg_line0 = padc(c - 6'd20);
        6'd30: dbg_line0 = "U"; 6'd31: dbg_line0 = "P";
        6'd33: dbg_line0 = hexd(up_h[7:4]); 6'd34: dbg_line0 = hexd(up_h[3:0]); 6'd35: dbg_line0 = ":";
        6'd36: dbg_line0 = hexd(up_m[7:4]); 6'd37: dbg_line0 = hexd(up_m[3:0]); 6'd38: dbg_line0 = ":";
        6'd39: dbg_line0 = hexd(up_s[7:4]); 6'd40: dbg_line0 = hexd(up_s[3:0]);
        default: dbg_line0 = " ";
    endcase
endfunction

// line 1 (after the 24-char game name): mapper and ROM size from the cart header
function automatic [31:0] mapper_name(input [7:0] t);
    case (t)
        8'h00, 8'h08, 8'h09:                      mapper_name = "ROM ";
        8'h01, 8'h02, 8'h03:                      mapper_name = "MBC1";
        8'h05, 8'h06:                             mapper_name = "MBC2";
        8'h0F, 8'h10, 8'h11, 8'h12, 8'h13:        mapper_name = "MBC3";
        8'h19, 8'h1A, 8'h1B, 8'h1C, 8'h1D, 8'h1E: mapper_name = "MBC5";
        8'h20:                                    mapper_name = "MBC6";
        8'h22:                                    mapper_name = "MBC7";
        8'hFC:                                    mapper_name = "CAM ";
        8'hFE:                                    mapper_name = "HUC3";
        8'hFF:                                    mapper_name = "HUC1";
        default:                                  mapper_name = "????";
    endcase
endfunction
function automatic [31:0] rom_name(input [7:0] n);
    case (n)
        8'h00: rom_name = " 32K"; 8'h01: rom_name = " 64K"; 8'h02: rom_name = "128K";
        8'h03: rom_name = "256K"; 8'h04: rom_name = "512K"; 8'h05: rom_name = "  1M";
        8'h06: rom_name = "  2M"; 8'h07: rom_name = "  4M"; 8'h08: rom_name = "  8M";
        default: rom_name = "  ? ";
    endcase
endfunction
wire [31:0] mname = mapper_name(cart_type);
wire [31:0] rname = rom_name(rom_size);
function automatic [7:0] dbg_line1(input [5:0] c);
    case (c)
        6'd25: dbg_line1 = mname[31:24]; 6'd26: dbg_line1 = mname[23:16];
        6'd27: dbg_line1 = mname[15:8];  6'd28: dbg_line1 = mname[7:0];
        6'd30: dbg_line1 = rname[31:24]; 6'd31: dbg_line1 = rname[23:16];
        6'd32: dbg_line1 = rname[15:8];  6'd33: dbg_line1 = rname[7:0];
        6'd35: dbg_line1 = "R"; 6'd36: dbg_line1 = "O"; 6'd37: dbg_line1 = "M";
        default: dbg_line1 = " ";
    endcase
endfunction

// line 2 (SPI LCD, 16 chars): "59fps   UDLRABsS"
function automatic [7:0] dbg_line2(input [5:0] c);
    case (c)
        6'd0: dbg_line2 = hexd(fps[7:4]); 6'd1: dbg_line2 = hexd(fps[3:0]);
        6'd2: dbg_line2 = "f"; 6'd3: dbg_line2 = "p"; 6'd4: dbg_line2 = "s";
        6'd8, 6'd9, 6'd10, 6'd11, 6'd12, 6'd13, 6'd14, 6'd15: dbg_line2 = padc(c - 6'd8);
        default: dbg_line2 = " ";
    endcase
endfunction

// ------------------------------------------------------------ text rendering
// strings: 32 x 16 chars, see tools/make_osd_roms.py for the ids
localparam S_TITLE = 0, S_ITEM0 = 1, S_NOWPLAY = 13, S_HINT = 10, S_SELGAME = 11,
           S_NOGAMES = 12, S_LOADING = 14,
           S_DISP0 = 16, S_PAL0 = 19, S_COL0 = 24, S_LCD0 = 26, S_SYS0 = 32, S_DBG0 = 30;

reg [7:0] str_rom [0:1023];
initial $readmemh("rtl/sys/osd_strings.hex", str_rom);

reg [7:0] name_ram [0:511];
always @(posedge clk) if (name_we) name_ram[name_waddr] <= name_wdata;

reg [8:0] ra;
assign draw_start = dirty && !drawing;

// stage A: describe cell (row, col) of the 16 x 16 grid
//   main page: row 0 title, rows 2..9 items ("Label  <value >"), rows 11/12 current game,
//              row 15 hints
//   games page: row 0 title, rows 1..15 game names ('*' marks the running game)
wire [3:0] row = ra[7:4];
wire [3:0] col = ra[3:0];
wire [1:0] dline = ra[7:6];      // debug region (ra[8] = 1)
wire [5:0] dcol  = ra[5:0];
reg  [1:0] kind;          // 0 space, 1 string, 2 name, 3 literal
reg  [5:0] sid;
reg  [4:0] ofs;
reg  [3:0] nidx;
reg  [7:0] lit;
reg        hl;

always @* begin
    kind = 0; sid = 0; ofs = 0; nidx = 0; lit = 8'h20; hl = 0;
    if (ra[8]) begin
        // debug status lines
        kind = 3;
        if (dline == 2'd0)      lit = dbg_line0(dcol);
        else if (dline == 2'd2) lit = dbg_line2(dcol);
        else if (dcol < 6'd24) begin
            kind = 2; nidx = cur_game; ofs = dcol[4:0];
            if (loading || game_count == 0) begin kind = 3; lit = 8'h2D; end
        end else lit = dbg_line1(dcol);
    end else if (row == 0) begin
        hl = 1; kind = 1; ofs = col;
        sid = (page == P_GAMES) ? S_SELGAME : S_TITLE;
    end else if (page == P_MAIN) begin
        if (row >= 2 && row < 2 + N_ITEMS) begin
            logic [3:0] it;
            it = row - 4'd2;
            hl = (it == cursor);
            if (col >= 1 && (it < 3 ? col < 15 : col < 8)) begin
                kind = 1; sid = S_ITEM0 + it; ofs = col - 4'd1;
            end else if (it >= 3 && col == 8 && it == cursor) begin
                kind = 3; lit = 8'h3C;   // '<'
            end else if (it >= 3 && col >= 9 && col < 15) begin
                kind = 1; ofs = col - 4'd9;
                case (it)
                    4'd3: sid = S_DISP0 + disp_mode;
                    4'd4: sid = S_PAL0  + dmg_pal;
                    4'd5: sid = S_COL0  + gbc_raw;
                    4'd6: sid = S_LCD0  + lcd_crop;
                    4'd7: sid = S_SYS0  + sys_mode;
                    default: sid = S_DBG0 + dbg_on;
                endcase
            end else if (it >= 3 && col == 15 && it == cursor) begin
                kind = 3; lit = 8'h3E;   // '>'
            end
        end else if (row == 11 && col >= 1) begin
            kind = 1; sid = S_NOWPLAY; ofs = col - 4'd1;
        end else if (row == 12 && col >= 1) begin
            if (loading)              begin kind = 1; sid = S_LOADING; ofs = col - 4'd1; end
            else if (game_count == 0) begin kind = 1; sid = S_NOGAMES; ofs = col - 4'd1; end
            else                      begin kind = 2; nidx = cur_game; ofs = col - 4'd1; end
        end else if (row == 15 && col >= 1) begin
            kind = 1; sid = S_HINT; ofs = col - 4'd1;
        end
    end else begin
        // games page
        if (row >= 1) begin
            logic [3:0] gi;
            gi = row - 4'd1;
            if (gi < game_count) begin
                hl = (gi == cursor);
                if (col >= 1)                       begin kind = 2; nidx = gi; ofs = col - 4'd1; end
                else if (gi == cur_game)            begin kind = 3; lit = 8'h2A; end  // '*'
            end else if (game_count == 0 && row == 2 && col >= 1) begin
                kind = 1; sid = S_NOGAMES; ofs = col - 4'd1;
            end
        end
    end
end

// stage B: ROM / RAM read
reg [8:0] ra_b;
reg [1:0] kind_b;
reg [7:0] lit_b;
reg       hl_b, v_b;
reg [7:0] str_q, name_q;
always @(posedge clk) begin
    ra_b   <= ra;
    kind_b <= kind;
    lit_b  <= lit;
    hl_b   <= hl;
    v_b    <= drawing;
    str_q  <= str_rom[{sid, ofs[3:0]}];
    name_q <= name_ram[{nidx, ofs}];
end

// stage C: write the text RAM
always @(posedge clk) begin
    txt_we    <= v_b;
    txt_waddr <= ra_b;
    case (kind_b)
        2'd1:    txt_wdata <= {hl_b, str_q[6:0]};
        2'd2:    txt_wdata <= {hl_b, (name_q == 0) ? 7'h20 : name_q[6:0]};
        2'd3:    txt_wdata <= {hl_b, lit_b[6:0]};
        default: txt_wdata <= {hl_b, 7'h20};
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        drawing <= 0;
        ra      <= 0;
    end else if (draw_start) begin
        drawing <= 1;
        ra      <= 0;
    end else if (dbg_tick && !drawing) begin
        drawing <= 1;
        ra      <= 9'd256;           // refresh the debug lines only
    end else if (drawing) begin
        if (ra == 9'd447) drawing <= 0;
        ra <= ra + 1'd1;
    end
end

endmodule
