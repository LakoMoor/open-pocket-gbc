// Game Boy pixel -> RGB888: DMG palettes (shade in bits 1:0) or GBC colour (BGR555)
// with optional LCD colour correction. Shared by the HDMI and the SPI LCD outputs.
module gb_color (
    input      [14:0] pix,
    input             gbc,
    input       [2:0] pal,
    input             raw,
    output     [23:0] rgb
);

reg [23:0] dmg_rgb;
always @* begin
    case ({pal, pix[1:0]})
        // grayscale
        5'b000_00: dmg_rgb = 24'hF8F8F8; 5'b000_01: dmg_rgb = 24'hA8A8A8;
        5'b000_10: dmg_rgb = 24'h585858; 5'b000_11: dmg_rgb = 24'h101010;
        // DMG green
        5'b001_00: dmg_rgb = 24'h9BBC0F; 5'b001_01: dmg_rgb = 24'h8BAC0F;
        5'b001_10: dmg_rgb = 24'h306230; 5'b001_11: dmg_rgb = 24'h0F380F;
        // Pocket
        5'b010_00: dmg_rgb = 24'hC4CFA1; 5'b010_01: dmg_rgb = 24'h8B956D;
        5'b010_10: dmg_rgb = 24'h4D533C; 5'b010_11: dmg_rgb = 24'h1F1F1F;
        // Light (backlit)
        5'b011_00: dmg_rgb = 24'h00B581; 5'b011_01: dmg_rgb = 24'h009A71;
        5'b011_10: dmg_rgb = 24'h00694A; 5'b011_11: dmg_rgb = 24'h004F3B;
        // Amber
        5'b100_00: dmg_rgb = 24'hFFC060; 5'b100_01: dmg_rgb = 24'hC88830;
        5'b100_10: dmg_rgb = 24'h784818; 5'b100_11: dmg_rgb = 24'h301808;
        default:   dmg_rgb = 24'hF8F8F8;
    endcase
end

// GBC LCD colour correction (byuu/Near formula), result 0..240
wire [4:0] r5 = pix[4:0], g5 = pix[9:5], b5 = pix[14:10];
wire [9:0] cr = r5*5'd26 + g5*5'd4  + b5*5'd2;
wire [9:0] cg =            g5*5'd24 + b5*5'd8;
wire [9:0] cb = r5*5'd6  + g5*5'd4  + b5*5'd22;
wire [23:0] gbc_fix = {cr[9:2], cg[9:2], cb[9:2]};
wire [23:0] gbc_raw = {r5, r5[4:2], g5, g5[4:2], b5, b5[4:2]};

assign rgb = !gbc ? dmg_rgb : (raw ? gbc_raw : gbc_fix);

endmodule
