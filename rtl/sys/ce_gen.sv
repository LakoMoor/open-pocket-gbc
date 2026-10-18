// Clock enables for the Game Boy core, after MiSTer speedcontrol.vhd (normal speed only).
// ce = 4 MHz, ce_n = 4 MHz shifted by half a period, ce_2x = 8 MHz.
// Generated on the falling edge of clk_sys like the original: the core relies on
// this phase (its negedge blocks sample ce half a cycle after the rising edge).
// pause stops all enables at a bus-cycle boundary (used while the menu is open).
module ce_gen (
    input      clk_sys,
    input      pause,
    output reg ce,
    output reg ce_n,
    output reg ce_2x,
    output reg paused
);

reg [2:0] clkdiv = 0;
initial begin ce = 0; ce_n = 0; ce_2x = 0; paused = 0; end

always @(negedge clk_sys) begin
    ce    <= 0;
    ce_n  <= 0;
    ce_2x <= 0;
    if (!paused) begin
        if (pause && clkdiv == 3'b111)
            paused <= 1;
        else begin
            clkdiv <= clkdiv + 1'd1;
            if (clkdiv == 3'b000)      ce   <= 1;
            if (clkdiv == 3'b100)      ce_n <= 1;
            if (clkdiv[1:0] == 2'b00)  ce_2x <= 1;
        end
    end else if (!pause)
        paused <= 0;
end

endmodule
