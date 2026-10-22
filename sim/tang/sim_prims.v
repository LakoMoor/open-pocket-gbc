// Simulation models of the Gowin parts of gbc_top (Verilator --timing).
// The PLLs make their clocks with delays; the 135 MHz HDMI serial clock is not generated
// (the TMDS serializer is not simulated: the picture is taken from video_out).

`timescale 1ps/1ps

module pll_gb (input clock_in, output reg clk_sys, output clk_sys_p, output locked);
    initial clk_sys = 0;
    always #14815 clk_sys = ~clk_sys;                 // 33.75 MHz
    assign clk_sys_p = ~clk_sys;
    assign locked = 1'b1;
endmodule

module pll_hdmi480 (input clock_in, input pwrdn, output clock_out, output locked);
    assign clock_out = 1'b0;                          // the 5x clock only feeds the serializer
    assign locked = 1'b1;
endmodule

module pll_hdmi (input clock_in, output clock_out, output locked);
    assign clock_out = 1'b0;
    assign locked = 1'b1;
endmodule

// clk_p for video: 27 MHz, generated here instead of dividing the serial clock.
// +no_hdmi stops it: the HDMI pipeline then costs nothing and the LCD runs ~2x faster.
module CLKDIV #(parameter DIV_MODE = "2", parameter GSREN = "false") (output reg CLKOUT, input HCLKIN, input RESETN, input CALIB);
    initial begin
        CLKOUT = 0;
        if (!$test$plusargs("no_hdmi")) forever #18519 CLKOUT = ~CLKOUT;
    end
endmodule

module OSER10 #(parameter GSREN = "false", parameter LSREN = "true") (output Q, input D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, input PCLK, FCLK, RESET);
    assign Q = D0;
endmodule

module TLVDS_OBUF (output O, OB, input I);
    assign O = I; assign OB = ~I;
endmodule

module TLVDS_TBUF (output O, OB, input I, OEN);
    assign O = I; assign OB = ~I;
endmodule

module ELVDS_OBUF (output O, OB, input I);
    assign O = I; assign OB = ~I;
endmodule

module rPLL #(parameter FCLKIN = "27", parameter IDIV_SEL = 0, parameter FBDIV_SEL = 0, parameter ODIV_SEL = 8,
              parameter DYN_SDIV_SEL = 2, parameter PSDA_SEL = "0000", parameter DEVICE = "GW2AR-18C",
              parameter CLKFB_SEL = "internal", parameter CLKOUT_BYPASS = "false", parameter CLKOUTP_BYPASS = "false",
              parameter CLKOUTD_BYPASS = "false", parameter CLKOUTD_SRC = "CLKOUT", parameter CLKOUTD3_SRC = "CLKOUT",
              parameter DYN_IDIV_SEL = "false", parameter DYN_FBDIV_SEL = "false", parameter DYN_ODIV_SEL = "false",
              parameter DUTYDA_SEL = "1000", parameter DYN_DA_EN = "false", parameter CLKOUT_FT_DIR = 1'b1,
              parameter CLKOUTP_FT_DIR = 1'b1, parameter CLKOUT_DLY_STEP = 0, parameter CLKOUTP_DLY_STEP = 0)
    (output CLKOUT, CLKOUTP, CLKOUTD, CLKOUTD3, LOCK, input CLKIN, CLKFB, RESET, RESET_P,
     input [5:0] FBDSEL, IDSEL, ODSEL, input [3:0] PSDA, DUTYDA, FDLY);
    assign CLKOUT = 0; assign CLKOUTP = 0; assign CLKOUTD = 0; assign CLKOUTD3 = 0; assign LOCK = 1;
endmodule
