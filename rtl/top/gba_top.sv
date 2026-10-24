// SPDX-License-Identifier: GPL-3.0-or-later
// Tang Nano 20K ARM/Thumb + SDRAM + Mode 3 diagnostic configuration.
// No commercial BIOS, menu or APU. See docs/gba-compatibility.md.
module gba_top (
    input sys_clk, s1,
    input [7:0] key_n,
    output [1:0] led,
    output tmds_clk_p,tmds_clk_n,
    output [2:0] tmds_d_p,tmds_d_n,
    output O_sdram_clk,O_sdram_cke,O_sdram_cs_n,O_sdram_cas_n,O_sdram_ras_n,O_sdram_wen_n,
    output [3:0] O_sdram_dqm,
    output [10:0] O_sdram_addr,
    output [1:0] O_sdram_ba,
    inout [31:0] IO_sdram_dq
);
    wire clk_p5,clk_p,hdmi_lock,clk_sys,clk_sys_p,gb_lock;
    pll_hdmi480 u_pll_a_hdmi(.clock_in(sys_clk),.pwrdn(1'b0),.clock_out(clk_p5),.locked(hdmi_lock));
    pll_gb u_pll_b_gb(.clock_in(sys_clk),.clk_sys(clk_sys),.clk_sys_p(clk_sys_p),.locked(gb_lock));
    CLKDIV #(.DIV_MODE("5")) u_div5(.CLKOUT(clk_p),.HCLKIN(clk_p5),.RESETN(hdmi_lock),.CALIB(1'b0));
    logic [7:0] por=0;
    logic [1:0] button_sync=0;
    always_ff @(posedge clk_sys) begin
        button_sync <= {button_sync[0],s1};
        if (!gb_lock || button_sync[1]) por <= 0;
        else if (!(&por)) por <= por + 1'b1;
    end
    wire reset = !(&por);
    logic [3:0] hpor=0;
    always_ff @(posedge clk_p) begin
        if (!hdmi_lock) hpor <= 0;
        else if (!(&hpor)) hpor <= hpor + 1'b1;
    end
    // Also reset the scanout on reboot, synchronously in the pixel domain.
    logic [1:0] reset_p=3;
    always_ff @(posedge clk_p) reset_p <= {reset_p[0],reset};
    wire vreset = !(&hpor) || reset_p[1];
    wire sdram_ready;
    logic [31:0] diagnostic[0:255];
    initial $readmemh("fw/gba/diagnostic.hex",diagnostic);
    logic [8:0] load_index;
    logic running,demo_done;
    wire core_req,core_we,core_ack,core_rvalid,fault,thumb;
    wire [20:0] core_addr;
    wire [31:0] core_wdata;
    wire [3:0] core_be;
    wire [15:0] dispcnt;
    wire [31:0] lp_rdata;
    logic [7:0] keys_s1,keys_s2;
    always_ff @(posedge clk_sys) begin keys_s1<=~key_n;keys_s2<=keys_s1;end
    wire [9:0] keys={2'b00,keys_s2[1],keys_s2[0],keys_s2[2],keys_s2[3],keys_s2[7],keys_s2[6],keys_s2[5],keys_s2[4]};
    gba_bringup core(.clk(clk_sys),.reset(reset || !running),
        .keys(keys),
        .mem_req(core_req),.mem_we(core_we),.mem_addr(core_addr),.mem_wdata(core_wdata),.mem_be(core_be),
        .mem_ack(core_ack && running),.mem_rvalid(core_rvalid && running),.mem_rdata(lp_rdata),
        .fault(fault),.thumb(thumb),.dispcnt(dispcnt));
    always_ff @(posedge clk_sys) begin
        if (reset) begin load_index <= 0; running <= 0; demo_done <= 0; end
        else begin
            if (!running && core_ack) begin
                if (load_index == 255) running <= 1;
                else load_index <= load_index + 1'b1;
            end
            if (running && core_ack && core_we && core_addr == 21'h180000 && core_wdata == 32'h12345678)
                demo_done <= 1;
        end
    end
    wire video_req,video_ack,video_rvalid,underrun;
    wire [20:0] video_addr;
    wire [9:0] cx,cy;
    wire [23:0] rgb;
    gba_mode3_scanout scanout(.clk(clk_sys),.reset(reset),.video_req(video_req),.video_addr(video_addr),
        .video_ack(video_ack),.video_rvalid(video_rvalid),.video_rdata(lp_rdata),
        .vclk(clk_p),.vreset(vreset),.enable(demo_done),.cx(cx),.cy(cy),.rgb(rgb),.underrun(underrun));
    wire lp_req,lp_we,lp_ack,lp_rvalid;
    wire [20:0] lp_addr;
    wire [31:0] lp_wdata;
    wire [3:0] lp_be;
    gba_sdram_arbiter arbiter(.clk(clk_sys),.reset(reset),
        .cpu_req(running ? core_req : sdram_ready),.cpu_we(running ? core_we : 1'b1),
        .cpu_addr(running ? core_addr : {13'd0,load_index[7:0]}),
        .cpu_wdata(running ? core_wdata : diagnostic[load_index[7:0]]),.cpu_be(running ? core_be : 4'hf),
        .cpu_ack(core_ack),.cpu_rvalid(core_rvalid),.video_req(video_req),.video_addr(video_addr),
        .video_ack(video_ack),.video_rvalid(video_rvalid),.lp_req(lp_req),.lp_we(lp_we),.lp_addr(lp_addr),
        .lp_wdata(lp_wdata),.lp_be(lp_be),.lp_ack(lp_ack),.lp_rvalid(lp_rvalid));
    sdram_ctrl u_sdram(.clk(clk_sys),.resetn(!reset),.ready(sdram_ready),
        .cart_rd_strobe(1'b0),.cart_wr_strobe(1'b0),.cart_addr(23'd0),.cart_din(8'd0),.cart_dout(),
        .lp_block(1'b0),.pd_en(1'b0),.sr_req(1'b0),.lp_req(lp_req),.lp_ack(lp_ack),.lp_we(lp_we),
        .lp_addr(lp_addr),.lp_wdata(lp_wdata),.lp_be(lp_be),.lp_rdata(lp_rdata),.lp_rvalid(lp_rvalid),
        .O_sdram_clk(O_sdram_clk),.O_sdram_cke(O_sdram_cke),.O_sdram_cs_n(O_sdram_cs_n),
        .O_sdram_ras_n(O_sdram_ras_n),.O_sdram_cas_n(O_sdram_cas_n),.O_sdram_wen_n(O_sdram_wen_n),
        .O_sdram_dqm(O_sdram_dqm),.O_sdram_addr(O_sdram_addr),.O_sdram_ba(O_sdram_ba),
        .IO_sdram_dq(IO_sdram_dq),.clk_sdram_p(clk_sys_p));
    // HDMI is reused intact. Silence is intentional: no GBA APU is present.
    wire [15:0] silence[1:0];
    assign silence[0]=0; assign silence[1]=0;
    wire [2:0] tmds;
    wire tmds_clock;
    hdmi #(.VIDEO_ID_CODE(2),.BIT_WIDTH(10),.DVI_OUTPUT(0),.AUDIO_RATE(48000),
        .VENDOR_NAME({"OpenGBA",8'd0}),.PRODUCT_DESCRIPTION({"GBA bringup",40'd0}))
    u_hdmi(.clk_pixel_x5(clk_p5),.clk_pixel(clk_p),.clk_audio(1'b0),.reset(vreset),
        .rgb(rgb),.audio_sample_word(silence),.tmds(tmds),.tmds_clock(tmds_clock),
        .cx(cx),.cy(cy),.frame_width(),.frame_height(),.screen_width(),.screen_height());
    TLVDS_OBUF u_obuf[3:0](.I({tmds_clock,tmds}),.O({tmds_clk_p,tmds_d_p}),.OB({tmds_clk_n,tmds_d_n}));
    assign led = {~fault,~demo_done};
endmodule
