// Replacements for MiSTer-only parts of the Gameboy core.
// Savestates, rewind and cheat codes are not used on Tang Nano 20K.

// Savestate register: keeps its default value, reloaded while BUS_rst is high.
module eReg_SavestateV #(
    parameter index = 0,
    parameter Adr   = 0,
    parameter upper = 0,
    parameter lower = 0,
    parameter [63:0] def = 64'd0
) (
    input              clk,
    input       [63:0] BUS_Din,
    input        [9:0] BUS_Adr,
    input              BUS_wren,
    input              BUS_rst,
    output      [63:0] BUS_Dout,
    input  [upper:lower] Din,
    output [upper:lower] Dout
);
    assign BUS_Dout = 64'd0;
    assign Dout = def[upper:lower];
endmodule

// Savestate controller: only passes reset through.
// BUS_rst follows reset so the GHDL-converted CPU/APU registers load their defaults.
module gb_savestates (
    input             clk,
    input             reset_in,
    output reg        reset_out,
    output            load_done,
    input             increaseSSHeaderCount,
    input             save,
    input             load,
    input      [31:0] savestate_address,
    output            savestate_busy,
    input       [7:0] cart_ram_size,
    input             lcd_vsync,
    output     [63:0] BUS_Din,
    output      [9:0] BUS_Adr,
    output            BUS_wren,
    output            BUS_rst,
    input      [63:0] BUS_Dout,
    output            loading_savestate,
    output            saving_savestate,
    output            sleep_savestate,
    input             clock_ena_in,
    input             memory_busy,
    output     [19:0] Save_RAMAddr,
    output      [4:0] Save_RAMRdEn,
    output      [4:0] Save_RAMWrEn,
    output     [15:0] Save_RAMWriteData,
    input       [7:0] Save_RAMReadData_WRAM,
    input       [7:0] Save_RAMReadData_VRAM,
    input       [7:0] Save_RAMReadData_ORAM,
    input       [7:0] Save_RAMReadData_ZRAM,
    input      [15:0] Save_RAMReadData_CRAM,
    output     [63:0] bus_out_Din,
    input      [63:0] bus_out_Dout,
    output     [25:0] bus_out_Adr,
    output            bus_out_rnw,
    output            bus_out_ena,
    output      [7:0] bus_out_be,
    input             bus_out_done
);
    initial reset_out = 1'b1;
    always @(posedge clk) reset_out <= reset_in;

    assign load_done         = 1'b0;
    assign savestate_busy    = 1'b0;
    assign BUS_Din           = 64'd0;
    assign BUS_Adr           = 10'd0;
    assign BUS_wren          = 1'b0;
    assign BUS_rst           = reset_out;
    assign loading_savestate = 1'b0;
    assign saving_savestate  = 1'b0;
    assign sleep_savestate   = 1'b0;
    assign Save_RAMAddr      = 20'd0;
    assign Save_RAMRdEn      = 5'd0;
    assign Save_RAMWrEn      = 5'd0;
    assign Save_RAMWriteData = 16'd0;
    assign bus_out_Din       = 64'd0;
    assign bus_out_Adr       = 26'd0;
    assign bus_out_rnw       = 1'b1;
    assign bus_out_ena       = 1'b0;
    assign bus_out_be        = 8'd0;
endmodule

module gb_statemanager #(
    parameter Softmap_SaveState_ADDR = 0,
    parameter Softmap_Rewind_ADDR    = 0
) (
    input         clk,
    input         reset,
    input         rewind_on,
    input         rewind_active,
    input   [1:0] savestate_number,
    input         save,
    input         load,
    output        sleep_rewind,
    input         vsync,
    output        request_savestate,
    output        request_loadstate,
    output [31:0] request_address,
    input         request_busy
);
    assign sleep_rewind      = 1'b0;
    assign request_savestate = 1'b0;
    assign request_loadstate = 1'b0;
    assign request_address   = 32'd0;
endmodule

// Game Genie / cheat engine: disabled.
module CODES #(
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 8,
    parameter MAX_CODES  = 32
) (
    input            clk,
    input            reset,
    input            enable,
    output           available,
    input     [15:0] addr_in,
    input      [7:0] data_in,
    input    [128:0] code,
    output           genie_ovr,
    output     [7:0] genie_data
);
    assign available  = 1'b0;
    assign genie_ovr  = 1'b0;
    assign genie_data = 8'hFF;
endmodule

// MegaDuck address/register swizzle: not supported, pass-through.
module megaduck_swizzle (
    input         megaduck,
    input  [15:0] a_in,
    output [15:0] a_out,
    input   [7:0] snd_in_di,
    output  [7:0] snd_in_do,
    input   [7:0] snd_out_di,
    output  [7:0] snd_out_do
);
    assign a_out      = a_in;
    assign snd_in_do  = snd_in_di;
    assign snd_out_do = snd_out_di;
endmodule
