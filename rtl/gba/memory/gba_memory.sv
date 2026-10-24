// SPDX-License-Identifier: GPL-3.0-or-later
// Diagnostic bring-up memory system, not a complete GBA memory controller.
// Writes complete on SDRAM acceptance; reads wait for the actual response.
module gba_memory (
    input logic clk, reset,
    input logic req, we,
    input logic [31:0] addr, wdata,
    input logic [3:0] be,
    input logic [9:0] keys,
    output logic done,
    output logic [31:0] rdata,
    output logic fault,
    output logic [15:0] dispcnt,
    output logic irq,
    output logic mem_req, mem_we,
    output logic [20:0] mem_addr,
    output logic [31:0] mem_wdata,
    output logic [3:0] mem_be,
    input logic mem_ack, mem_rvalid,
    input logic [31:0] mem_rdata
);
    logic [22:0] physical;
    logic mapped, readonly, bios, io;
    gba_address_decode decode(.*);
    typedef enum logic [1:0] {IDLE, ISSUE, READ, RESP} state_t;
    state_t state;
    logic [31:0] boot_data;
    logic [25:0] tick_acc;
    wire [26:0] tick_sum={1'b0,tick_acc}+27'd16777216;
    wire tick=tick_sum>=27'd33750000;
    always_ff @(posedge clk) begin
        if(reset) tick_acc<=0;
        else tick_acc<=26'(tick ? tick_sum-27'd33750000 : tick_sum);
    end
    wire peripheral_selected;
    wire [31:0] peripheral_rdata;
    gba_timers_irq peripherals(.clk(clk),.reset(reset),.ce(tick),.keys(keys),
        .access(state==IDLE && req && io),.we(we),.addr(addr[9:0]),.wdata(wdata),.be(be),
        .selected(peripheral_selected),.rdata(peripheral_rdata),.irq(irq),.overflow());
    // Original diagnostic vector table: no Nintendo BIOS or BIOS replacement.
    always_comb begin
        case (addr[13:2])
            12'h000: boot_data = 32'he59ff018; // ldr pc,[pc,#24]
            12'h002: boot_data = 32'he1b0f00e; // SWI: movs pc,lr
            12'h006: boot_data = 32'hea000018; // IRQ: branch to diagnostic handler
            12'h008: boot_data = 32'h08000000;
            12'h020: boot_data = 32'he3a0b403; // mov r11,#IWRAM
            12'h021: boot_data = 32'he3a0c001;
            12'h022: boot_data = 32'he58bc00c; // IWRAM[12] = 1 (IRQ marker)
            12'h023: boot_data = 32'he3a0b301; // mov r11,#IO
            12'h024: boot_data = 32'he3a0c000;
            12'h025: boot_data = 32'he58bc208; // IME=0; stop further IRQ entries
            12'h026: boot_data = 32'he25ef004; // subs pc,lr,#4; restores SPSR
            default: boot_data = 32'heafffffe;
        endcase
    end
    assign mem_req = state == ISSUE && !reset;
    assign done = state == RESP && !reset;
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE; fault <= 0; dispcnt <= 16'h0080;
            rdata <= 0; mem_we <= 0; mem_addr <= 0; mem_be <= 0; mem_wdata <= 0;
        end else case (state)
            IDLE: if (req) begin
                rdata <= 0;
                if (!mapped || (io && addr[9:2] != 0 && !peripheral_selected) || (we && readonly)) begin
                    fault <= 1; state <= RESP;
                end else if (bios) begin rdata <= boot_data; state <= RESP; end
                else if (io) begin
                    rdata <= peripheral_selected ? peripheral_rdata : {16'd0,dispcnt};
                    if (we && addr[9:2]==0) begin
                        if (be[0]) dispcnt[7:0] <= wdata[7:0];
                        if (be[1]) dispcnt[15:8] <= wdata[15:8];
                    end
                    state <= RESP;
                end else begin
                    mem_addr <= physical[22:2]; mem_we <= we;
                    mem_wdata <= wdata; mem_be <= be;
                    state <= ISSUE;
                end
            end
            ISSUE: if (mem_ack) state <= mem_we ? RESP : READ;
            READ: if (mem_rvalid) begin rdata <= mem_rdata; state <= RESP; end
            RESP: state <= IDLE;
            default: state <= IDLE;
        endcase
    end
endmodule
