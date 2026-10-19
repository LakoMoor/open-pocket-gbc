/**
 * PLL configuration
 *
 * This Verilog module was generated automatically
 * using the gowin-pll tool.
 * Use at your own risk.
 *
 * Target-Device:                GW2AR-18 C8/I7
 * Given input frequency:        27.000 MHz
 * Requested output frequency:   135.000 MHz
 * Achieved output frequency:    135.000 MHz
 */

module pll_hdmi480(
        input  clock_in,
        input  pwrdn,
        output clock_out,
        output locked
    );

    rPLL #(
        .FCLKIN("27.0"),
        .IDIV_SEL(0), // -> PFD = 27.0 MHz (range: 3-500 MHz)
        .FBDIV_SEL(4), // -> CLKOUT = 135.0 MHz (range: 3.90625-625 MHz)
        .ODIV_SEL(4) // -> VCO = 540.0 MHz (range: 500-1250 MHz)
    ) pll (.CLKOUTP(), .CLKOUTD(), .CLKOUTD3(), .RESET(1'b0), .RESET_P(pwrdn), .CLKFB(1'b0), .FBDSEL(6'b0), .IDSEL(6'b0), .ODSEL(6'b0), .PSDA(4'b0), .DUTYDA(4'b0), .FDLY(4'b0), 
        .CLKIN(clock_in), // 27.0 MHz
        .CLKOUT(clock_out), // 135.0 MHz
        .LOCK(locked)
    );

endmodule
