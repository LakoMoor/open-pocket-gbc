// Game Boy audio -> 48 kHz samples for HDMI.
// Two one-pole low-pass stages at the 4 MHz APU rate (~40 kHz corner) then decimation.
// clk_audio is generated here (clk_sys / 703 = 48.009 kHz); samples change on its
// falling edge so the HDMI core can safely capture them on the rising edge.
module audio_out (
    input             clk,          // clk_sys 33.75 MHz
    input             ce,           // 4 MHz
    input             mute,
    input      [15:0] in_l,
    input      [15:0] in_r,
    output reg        clk_audio,
    output reg [15:0] out_l,
    output reg [15:0] out_r
);

reg signed [19:0] l1, r1, l2, r2;
always @(posedge clk) begin
    if (ce) begin
        l1 <= l1 + (($signed({in_l, 4'd0}) - l1) >>> 4);
        r1 <= r1 + (($signed({in_r, 4'd0}) - r1) >>> 4);
        l2 <= l2 + ((l1 - l2) >>> 4);
        r2 <= r2 + ((r1 - r2) >>> 4);
    end
end

reg [9:0] div;
always @(posedge clk) begin
    if (div == 10'd702) div <= 0;
    else div <= div + 1'd1;
    if (div == 10'd0)   clk_audio <= 1;
    if (div == 10'd351) begin
        clk_audio <= 0;
        out_l <= mute ? 16'd0 : l2[19:4];
        out_r <= mute ? 16'd0 : r2[19:4];
    end
end

endmodule
