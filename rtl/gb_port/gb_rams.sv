// Generic RAMs replacing the Altera altsyncram wrappers (dpram.vhd / spram.vhd).
// Only port A is implemented: port B of the original was used for savestates.
// Read is synchronous with write-through, like altsyncram NEW_DATA_NO_NBE_READ.
//
// The MiSTer core clocks some RAMs with clk_sys & ce. Because ce is produced on the
// falling edge of clk_sys, that gated edge coincides with a rising edge of clk_sys
// where ce is high, so clock_a = clk_sys with clken_a = ce behaves identically.

module dpram #(
    parameter addr_width = 8,
    parameter data_width = 8,
    parameter mem_init_file = " "
) (
    input                       clock_a,
    input                       clken_a = 1'b1,
    input      [addr_width-1:0] address_a,
    input      [data_width-1:0] data_a = '0,
    input                       wren_a = 1'b0,
    output reg [data_width-1:0] q_a,

    input                       clock_b = 1'b0,
    input                       clken_b = 1'b1,
    input      [addr_width-1:0] address_b = '0,
    input      [data_width-1:0] data_b = '0,
    input                       wren_b = 1'b0,
    output     [data_width-1:0] q_b
);
    reg [data_width-1:0] mem [0:(1<<addr_width)-1];

    always @(posedge clock_a) begin
        if (clken_a) begin
            if (wren_a) begin
                mem[address_a] <= data_a;
                q_a <= data_a;
            end else begin
                q_a <= mem[address_a];
            end
        end
    end

    assign q_b = {data_width{1'b0}};
endmodule

// Same as dpram (port A only), forced into block RAM.
module dpram_blk #(
    parameter addr_width = 8,
    parameter data_width = 8
) (
    input                       clock_a,
    input                       clken_a = 1'b1,
    input      [addr_width-1:0] address_a,
    input      [data_width-1:0] data_a = '0,
    input                       wren_a = 1'b0,
    output reg [data_width-1:0] q_a,

    input                       clock_b = 1'b0,
    input                       clken_b = 1'b1,
    input      [addr_width-1:0] address_b = '0,
    input      [data_width-1:0] data_b = '0,
    input                       wren_b = 1'b0,
    output     [data_width-1:0] q_b
);
    (* ram_style = "block" *)
    reg [data_width-1:0] mem [0:(1<<addr_width)-1];

    always @(posedge clock_a) begin
        if (clken_a) begin
            if (wren_a) begin
                mem[address_a] <= data_a;
                q_a <= data_a;
            end else begin
                q_a <= mem[address_a];
            end
        end
    end

    assign q_b = {data_width{1'b0}};
endmodule

// Boot ROM: 4 KB, CGB at $000-$8FF, DMG at $900, SGB at $A00 (SameBoy based, MIT).
module boot_rom (
    input             clk,
    input      [11:0] addr,
    output reg  [7:0] q
);
    reg [7:0] rom [0:4095];
    initial $readmemh("rtl/gb_port/boot_rom.hex", rom);
    always @(posedge clk) q <= rom[addr];
endmodule
