// Toolchain smoke test: 720p60 HDMI colour bars with a moving box, 440 Hz tone, blinking LED.
module hdmi_test_top (
    input  logic       sys_clk,     // 27 MHz
    input  logic       s1,          // button, active high
    output logic [1:0] led,         // active low
    output logic       tmds_clk_p, tmds_clk_n,
    output logic [2:0] tmds_d_p,  tmds_d_n
`ifdef WITH_FLASH
   ,output flash_cs_n, output flash_clk, output flash_mosi, input flash_miso
`endif
`ifdef WITH_SDRAM
   ,output O_sdram_clk, O_sdram_cke, O_sdram_cs_n, O_sdram_cas_n, O_sdram_ras_n, O_sdram_wen_n,
    output [3:0] O_sdram_dqm, output [10:0] O_sdram_addr, output [1:0] O_sdram_ba,
    inout [31:0] IO_sdram_dq
`endif
);

logic clk_p5, clk_p, hdmi_lock;
pll_hdmi u_pll_a_hdmi (.clock_in(sys_clk), .clock_out(clk_p5), .locked(hdmi_lock));
CLKDIV #(.DIV_MODE("5")) u_div5 (.CLKOUT(clk_p), .HCLKIN(clk_p5), .RESETN(hdmi_lock), .CALIB(1'b0));

logic [3:0] rst_cnt = 0;
logic reset = 1;
always_ff @(posedge clk_p) begin
    if (!hdmi_lock) rst_cnt <= 0;
    else if (rst_cnt != 4'hf) rst_cnt <= rst_cnt + 1'd1;
    reset <= rst_cnt != 4'hf;
end

// 48 kHz audio clock from 74.25 MHz: 74.25e6 / 48e3 = 1546.875
logic [10:0] aud_div = 0;
logic clk_audio = 0;
always_ff @(posedge clk_p) begin
    if (aud_div == 11'd773) begin aud_div <= 0; clk_audio <= ~clk_audio; end
    else aud_div <= aud_div + 1'd1;
end
logic [15:0] tone [1:0];
logic [6:0] tone_cnt = 0;
always_ff @(posedge clk_audio) begin
    tone_cnt <= (tone_cnt == 7'd108) ? 7'd0 : tone_cnt + 1'd1;  // ~440 Hz square
    tone[0] <= (tone_cnt < 7'd54) ? 16'sd2000 : -16'sd2000;
    tone[1] <= (tone_cnt < 7'd54) ? 16'sd2000 : -16'sd2000;
end

logic [10:0] cx;
logic [9:0]  cy;
logic [23:0] rgb;
logic [10:0] box_x = 0;
logic [9:0]  box_y = 0;
logic dir_x = 0, dir_y = 0;

always_ff @(posedge clk_p) begin
    if (cx == 0 && cy == 0) begin
        box_x <= dir_x ? box_x - 3'd4 : box_x + 3'd4;
        box_y <= dir_y ? box_y - 3'd3 : box_y + 3'd3;
        if (box_x > 11'd1140) dir_x <= 1; else if (box_x < 11'd8) dir_x <= 0;
        if (box_y > 10'd580)  dir_y <= 1; else if (box_y < 10'd8) dir_y <= 0;
    end
    if (cx >= box_x && cx < box_x + 11'd128 && cy >= box_y && cy < box_y + 10'd128)
        rgb <= s1 ? 24'hff0000 : 24'hffffff;
    else case (cx[10:7])
        4'd0: rgb <= 24'hffffff;
        4'd1: rgb <= 24'hffff00;
        4'd2: rgb <= 24'h00ffff;
        4'd3: rgb <= 24'h00ff00;
        4'd4: rgb <= 24'hff00ff;
        4'd5: rgb <= 24'hff0000;
        4'd6: rgb <= 24'h0000ff;
        4'd7: rgb <= 24'h000000;
        4'd8: rgb <= {cy[7:0], cy[7:0], cy[7:0]};
        default: rgb <= {cx[7:0], 8'h40, cy[7:0]};
    endcase
end

logic [2:0] tmds;
logic tmds_clock;
hdmi #(
    .VIDEO_ID_CODE(4), .DVI_OUTPUT(0), .VIDEO_REFRESH_RATE(60.0),
    .AUDIO_RATE(48000), .AUDIO_BIT_WIDTH(16),
    .VENDOR_NAME({"OpenGBC", 8'd0}), .PRODUCT_DESCRIPTION({"TangNano20K", 40'd0})
) u_hdmi (
    .clk_pixel_x5(clk_p5), .clk_pixel(clk_p), .clk_audio(clk_audio), .reset(reset),
    .rgb(rgb), .audio_sample_word(tone),
    .tmds(tmds), .tmds_clock(tmds_clock),
    .cx(cx), .cy(cy),
    .frame_width(), .frame_height(), .screen_width(), .screen_height()
);

TLVDS_OBUF u_obuf [3:0] (.I({tmds_clock, tmds}), .O({tmds_clk_p, tmds_d_p}), .OB({tmds_clk_n, tmds_d_n}));

logic [25:0] blink = 0;
`ifdef WITH_GB_PLL
wire clk_sys, clk_sys_p, gb_lock;
pll_gb u_pll_b_gb (.clock_in(sys_clk), .clk_sys(clk_sys), .clk_sys_p(clk_sys_p), .locked(gb_lock));
always_ff @(posedge clk_sys) blink <= blink + 1'd1;
`ifdef WITH_SDRAM
reg [7:0] sr_cnt = 0;
always_ff @(posedge clk_sys) if (gb_lock && sr_cnt != 8'hff) sr_cnt <= sr_cnt + 1'd1;
sdram_ctrl u_sdram (.clk(clk_sys), .resetn(sr_cnt == 8'hff), .ready(),
    .cart_rd_strobe(1'b0), .cart_wr_strobe(1'b0), .cart_addr(23'd0), .cart_din(8'd0), .cart_dout(),
    .lp_block(1'b0), .lp_req(1'b0), .lp_ack(), .lp_we(1'b0), .lp_addr(21'd0), .lp_wdata(32'd0), .lp_be(4'h0),
    .lp_rdata(), .lp_rvalid(),
    .O_sdram_clk(O_sdram_clk), .O_sdram_cke(O_sdram_cke), .O_sdram_cs_n(O_sdram_cs_n),
    .O_sdram_ras_n(O_sdram_ras_n), .O_sdram_cas_n(O_sdram_cas_n), .O_sdram_wen_n(O_sdram_wen_n),
    .O_sdram_dqm(O_sdram_dqm), .O_sdram_addr(O_sdram_addr), .O_sdram_ba(O_sdram_ba),
    .IO_sdram_dq(IO_sdram_dq), .clk_sdram_p(clk_sys_p));
`endif
`else
always_ff @(posedge clk_p) blink <= blink + 1'd1;
`endif
`ifdef WITH_FLASH
assign flash_cs_n = 1'b1;
assign flash_clk  = blink[3];
assign flash_mosi = flash_miso;
`endif
assign led = {~blink[25], blink[25]};

endmodule
