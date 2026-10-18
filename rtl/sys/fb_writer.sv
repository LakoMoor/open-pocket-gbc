// Captures the Game Boy LCD pixel stream into a triple-buffered framebuffer in SDRAM.
// LCD-on/off and blanking behaviour follows MiSTer lcd.v (input side).
// Pixels are 15-bit (GBC colour or DMG shade in bits 1:0) and stored two per 32-bit word.
module fb_writer #(
    parameter [20:0] FB_BASE_W = 21'h1C0000   // word address of buffer 0 (byte 0x700000)
) (
    input             clk,
    input             reset,
    input             ce,              // 4 MHz
    input             isGBC,

    input             lcd_clkena,
    input      [14:0] lcd_data,
    input       [1:0] lcd_mode,
    input             lcd_on,
    input             lcd_vsync,

    // triple buffer control
    input             vs_event,        // display side starts a new frame (one cycle)
    output reg  [1:0] rd_buf,          // buffer the display reads

    // write requests to SDRAM
    output            wq_empty,
    output     [20:0] wq_addr,
    output     [31:0] wq_data,
    output      [5:0] wq_level,
    input             wq_pop,

    // the same pixel stream for the SPI LCD
    output            px_we,
    output            px_first,
    output     [14:0] px_data
);

localparam BLANK_DELAY = 456*154;

reg [14:0] inptr;
reg lcd_off, lcd_freeze, blank_de, blank_output;
reg [14:0] blank_data;
reg [16:0] lcd_off_cnt;
reg [8:0] blank_hcnt, blank_vcnt;
reg old_lcd_off, old_lcd_vs;
reg frame_done;

wire pix_wr = ce & ((lcd_clkena & ~lcd_freeze) | blank_de);
wire [14:0] pix = (lcd_on & blank_output) ? blank_data : lcd_data;

always @(posedge clk) begin
    frame_done <= 0;

    lcd_off  <= !lcd_on || (lcd_mode == 2'd01);
    blank_de <= (!lcd_on && blank_output && blank_hcnt < 160 && blank_vcnt < 144);

    if (pix_wr) inptr <= inptr + 1'd1;

    old_lcd_off <= lcd_off;
    if (old_lcd_off ^ lcd_off) begin
        inptr <= 0;
        if (lcd_off && !lcd_freeze) frame_done <= 1;   // entered VBlank: frame complete
    end

    // Delay blanking the screen for GBC
    if (lcd_on) lcd_off_cnt <= 0;
    else if (ce & ~&lcd_off_cnt) lcd_off_cnt <= lcd_off_cnt + 1'b1;

    if (~lcd_on) begin
        lcd_freeze <= 1;
        if ((~isGBC | (lcd_off_cnt > BLANK_DELAY)) & ~blank_output) begin
            blank_output <= 1'b1;
            {blank_hcnt, blank_vcnt} <= 0;
        end
    end

    // Regenerate LCD timings for filling with blank colour while the LCD is off
    if (ce & ~lcd_on & blank_output) begin
        blank_data <= lcd_data;
        blank_hcnt <= blank_hcnt + 1'b1;
        if (blank_hcnt == 9'd455) begin
            blank_hcnt <= 0;
            blank_vcnt <= blank_vcnt + 1'b1;
            if (blank_vcnt == 9'd153) begin
                blank_vcnt <= 0;
                inptr <= 0;
                frame_done <= 1;
            end
        end
    end

    // Output one blank/repeated frame until VSync after the LCD is enabled
    old_lcd_vs <= lcd_vsync;
    if (~old_lcd_vs & lcd_vsync) begin
        lcd_freeze   <= 0;
        blank_output <= 0;
    end

    if (reset) begin
        lcd_freeze   <= 1;
        blank_output <= 0;
        inptr        <= 0;
    end
end

// ---------------------------------------------------------------- triple buffering
reg [1:0] wr_buf, done_buf;
always @(posedge clk) begin
    if (reset) begin
        wr_buf   <= 2'd0;
        done_buf <= 2'd1;
        rd_buf   <= 2'd1;
    end else begin
        if (vs_event) rd_buf <= done_buf;
        if (frame_done) begin
            done_buf <= wr_buf;
            wr_buf   <= 2'd3 - wr_buf - (vs_event ? done_buf : rd_buf);
        end
    end
end

assign px_we    = pix_wr && inptr < 15'd23040;
assign px_first = (inptr == 0);
assign px_data  = pix;

// ---------------------------------------------------------------- pixel pairs -> FIFO
reg [14:0] pix_lo;
reg        push;
reg [47:0] push_data;
always @(posedge clk) begin
    push <= 0;
    if (pix_wr && inptr < 15'd23040) begin
        if (!inptr[0])
            pix_lo <= pix;
        else begin
            push      <= 1;
            push_data <= {wr_buf, inptr[14:1], 1'b0, pix, 1'b0, pix_lo};
        end
    end
end

reg [47:0] fifo [0:63];
reg  [6:0] wp, rp;
wire [6:0] level = wp - rp;
always @(posedge clk) begin
    if (reset) begin
        wp <= 0;
        rp <= 0;
    end else begin
        if (push && level != 7'd64) begin
            fifo[wp[5:0]] <= push_data;
            wp <= wp + 1'd1;
        end
        if (wq_pop) rp <= rp + 1'd1;
    end
end

wire [47:0] head = fifo[rp[5:0]];
assign wq_empty = (level == 0);
assign wq_level = level[6] ? 6'd63 : level[5:0];
assign wq_addr  = FB_BASE_W | {5'd0, head[47:46], head[45:32]};
assign wq_data  = head[31:0];

endmodule
