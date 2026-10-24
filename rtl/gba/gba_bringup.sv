// SPDX-License-Identifier: GPL-3.0-or-later
module gba_bringup (
    input logic clk, reset,
    input logic [9:0] keys,
    output logic mem_req, mem_we,
    output logic [20:0] mem_addr,
    output logic [31:0] mem_wdata,
    output logic [3:0] mem_be,
    input logic mem_ack, mem_rvalid,
    input logic [31:0] mem_rdata,
    output logic fault, thumb,
    output logic [15:0] dispcnt
);
    wire rom_en,ram_cen,ram_wen,cpu_en;
    wire [31:0] rom_addr,ram_addr,ram_wdata,rom_data,ram_rdata;
    wire [3:0] ram_be;
    wire irq;
    gba_cpu cpu(.clk(clk),.rst(reset),.cpu_en(cpu_en),.cpu_restart(1'b0),
        .fiq(1'b0),.irq(irq),.ram_abort(1'b0),.rom_abort(1'b0),
        .ram_rdata(ram_rdata),.rom_data(rom_data),.ram_addr(ram_addr),
        .ram_cen(ram_cen),.ram_flag(ram_be),.ram_wdata(ram_wdata),
        .ram_wen(ram_wen),.rom_addr(rom_addr),.rom_en(rom_en),.thumb(thumb));
    wire req,we,done;
    wire [31:0] addr,wdata,rdata;
    wire [3:0] be;
    gba_cpu_bridge bridge(.*);
    gba_memory memory(.*);
endmodule
