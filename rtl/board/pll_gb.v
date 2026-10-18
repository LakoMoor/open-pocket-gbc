// 27 MHz -> 33.75 MHz Game Boy clk_sys (8x 4.21875 MHz, 0.58% faster than a real GB)
// plus the same clock shifted by 180 degrees for the SDRAM chip.
module pll_gb(
        input  clock_in,
        output clk_sys,
        output clk_sys_p,
        output locked
    );

    rPLL #(
        .FCLKIN("27.0"),
        .IDIV_SEL(3),        // PFD = 6.75 MHz
        .FBDIV_SEL(4),       // CLKOUT = 33.75 MHz
        .ODIV_SEL(16),       // VCO = 540 MHz
        .PSDA_SEL("1000"),   // CLKOUTP = 180 deg
        .DUTYDA_SEL("1000"),
        .DEVICE("GW2A-18C")
    ) pll (.CLKOUTD(), .CLKOUTD3(), .RESET(1'b0), .RESET_P(1'b0), .CLKFB(1'b0), .FBDSEL(6'b0), .IDSEL(6'b0), .ODSEL(6'b0), .PSDA(4'b0), .DUTYDA(4'b0), .FDLY(4'b0),
        .CLKIN(clock_in),
        .CLKOUT(clk_sys),
        .CLKOUTP(clk_sys_p),
        .LOCK(locked)
    );

endmodule
