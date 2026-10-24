// SPDX-License-Identifier: GPL-3.0-or-later
`timescale 1ps/1ps
module gba_board_sim (
    input s1,
    output vid_clk,
    output [9:0] cx,cy,
    output [23:0] rgb,
    output done,fault,underrun
);
    wire sc,cke,cs,cas,ras,we;
    wire [3:0] dqm;
    wire [10:0] addr;
    wire [1:0] ba;
    wire [31:0] dq;
    gba_top board(.sys_clk(1'b0),.s1(s1),.key_n(8'hff),.led(),.tmds_clk_p(),.tmds_clk_n(),.tmds_d_p(),.tmds_d_n(),
        .O_sdram_clk(sc),.O_sdram_cke(cke),.O_sdram_cs_n(cs),.O_sdram_cas_n(cas),.O_sdram_ras_n(ras),
        .O_sdram_wen_n(we),.O_sdram_dqm(dqm),.O_sdram_addr(addr),.O_sdram_ba(ba),.IO_sdram_dq(dq));
    sdram_model memory(.clk(sc),.cke(cke),.cs_n(cs),.ras_n(ras),.cas_n(cas),.we_n(we),
        .dqm(dqm),.addr(addr),.ba(ba),.dq(dq));
    assign vid_clk=board.clk_p;
    assign cx=board.cx;
    assign cy=board.cy;
    assign rgb=board.rgb;
    assign done=board.demo_done;
    assign fault=board.fault;
    assign underrun=board.underrun;
endmodule
