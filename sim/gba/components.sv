// SPDX-License-Identifier: GPL-3.0-or-later
module gba_components (
    input logic clk, reset, vclk, vreset, enable,
    input logic [9:0] cx, cy,
    output logic [23:0] rgb,
    output logic underrun,
    input logic cpu_req,cpu_we,
    input logic [20:0] cpu_addr,
    input logic [31:0] cpu_wdata,
    input logic [3:0] cpu_be,
    output logic cpu_ack,cpu_rvalid,
    output logic lp_req,lp_we,
    output logic [20:0] lp_addr,
    output logic [31:0] lp_wdata,
    output logic [3:0] lp_be,
    input logic lp_ack,lp_rvalid,
    input logic [31:0] lp_rdata,
    input logic [31:0] addr,
    output logic [22:0] physical,
    output logic mapped,readonly,bios,io
);
    logic video_req,video_ack,video_rvalid;
    logic [20:0] video_addr;
    gba_address_decode decode(.*);
    gba_sdram_arbiter arbiter(.*);
    gba_mode3_scanout scanout(.video_rdata(lp_rdata),.*);
endmodule
