// SPDX-License-Identifier: GPL-3.0-or-later
// Physical SDRAM layout is deliberately independent of the GBC layout.
module gba_address_decode (
    input logic [31:0] addr,
    output logic [22:0] physical,
    output logic mapped, readonly, bios, io
);
    always_comb begin
        physical = 0;
        mapped = 1;
        readonly = 0;
        bios = 0;
        io = 0;
        case (addr[31:24])
            8'h00: begin bios = addr[23:14] == 0; mapped = bios; readonly = 1; end
            8'h02: physical = 23'h600000 | {5'd0, addr[17:0]};
            8'h03: physical = 23'h640000 | {8'd0, addr[14:0]};
            8'h04: begin io = addr[23:10] == 0; mapped = io; end
            8'h05: physical = 23'h660000 | {13'd0, addr[9:0]};
            8'h06: physical = 23'h680000 | {6'd0, (addr[16:15] == 2'b11 ? {2'b10,addr[14:0]} : addr[16:0])};
            8'h07: physical = 23'h660400 | {13'd0, addr[9:0]};
            8'h08,8'h09,8'h0a,8'h0b,8'h0c,8'h0d: begin
                // No silent wrapping of a 32 MiB ROM into the 6 MiB resident area.
                physical = addr[22:0];
                mapped = addr[24:0] < 25'h0600000;
                readonly = 1;
            end
            // SRAM only. Flash/EEPROM protocols are not implemented here.
            8'h0e: physical = 23'h650000 | {7'd0,addr[15:0]};
            default: mapped = 0;
        endcase
    end
endmodule
