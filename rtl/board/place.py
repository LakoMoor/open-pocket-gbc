# nextpnr pre-pack script: keep the HDMI CLKDIV in the HCLK section that serves the
# bottom-edge OSER10s (same placement as the working hdmi_test_top).
if "u_div5" in ctx.cells:
    ctx.cells["u_div5"].setAttr("BEL", "X55Y27/CLKDIV_HCLK0_SECT0")
