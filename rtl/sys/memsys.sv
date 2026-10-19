// Low-priority SDRAM clients: framebuffer writer queue, framebuffer line reader and
// the I/O CPU (lowest priority). Includes the dual-clock line buffer read by the video output.
module memsys #(
    parameter [20:0] FB_BASE_W = 21'h1C0000
) (
    input             clk,          // clk_sys
    input             reset,

    // to sdram_ctrl low priority port
    output reg        lp_req,
    input             lp_ack,
    output reg        lp_we,
    output reg [20:0] lp_addr,
    output reg [31:0] lp_wdata,
    output reg  [3:0] lp_be,
    input      [31:0] lp_rdata,
    input             lp_rvalid,

    // framebuffer writer queue
    input             wq_empty,
    input      [20:0] wq_addr,
    input      [31:0] wq_data,
    input       [5:0] wq_level,
    output            wq_pop,

    // I/O CPU
    input             rv_req,
    input             rv_we,
    input      [20:0] rv_addr,
    input      [31:0] rv_wdata,
    input       [3:0] rv_be,
    output            rv_ack,
    output            rv_rvalid,

    // line requests from the video domain (toggle + line number)
    input             line_req_tgl,
    input       [7:0] line_req_no,
    input       [1:0] rd_buf,

    // line buffer read port (video clock)
    input             vclk,
    input       [7:0] lb_raddr,
    output reg [31:0] lb_q
);

// ------------------------------------------------------------ line request sync
reg [2:0] lr_sync;
always @(posedge clk) lr_sync <= {lr_sync[1:0], line_req_tgl};
wire line_start = lr_sync[2] ^ lr_sync[1];

localparam C_NONE = 2'd0, C_RV = 2'd1, C_WQ = 2'd2, C_RD = 2'd3;
reg [1:0] sel, sel_q;
reg [7:0]  rd_line;
reg [6:0]  rd_issue, rd_ret;
reg        rd_active;
reg [13:0] rd_base;            // line * 80

always @(posedge clk) begin
    if (reset) begin
        rd_active <= 0;
    end else if (line_start) begin
        rd_line   <= line_req_no;
        rd_base   <= {line_req_no, 6'd0} + {line_req_no, 4'd0};   // *64 + *16
        rd_issue  <= 0;
        rd_ret    <= 0;
        rd_active <= 1;
    end else begin
        if (rd_active && rd_ret == 7'd80) rd_active <= 0;
        if (lp_ack && sel_q == C_RD) rd_issue <= rd_issue + 1'd1;
        if (lp_rvalid && rd_owner == C_RD) rd_ret <= rd_ret + 1'd1;
    end
end

// ------------------------------------------------------------ arbitration
wire rd_want = rd_active && rd_issue != 7'd80;
always @* begin
    if (!wq_empty && wq_level >= 6'd16) sel = C_WQ;
    else if (rd_want)                   sel = C_RD;
    else if (!wq_empty)                 sel = C_WQ;
    else if (rv_req)                    sel = C_RV;
    else                                sel = C_NONE;
end

// present the selected request; the controller latches it in the cycle it accepts,
// and lp_ack (one cycle later) refers to sel_q.
always @* begin
    lp_req   = (sel != C_NONE);
    lp_we    = (sel == C_RV) ? rv_we : (sel != C_RD);
    lp_be    = (sel == C_RV) ? rv_be : 4'hF;
    case (sel)
        C_RV:    begin lp_addr = rv_addr; lp_wdata = rv_wdata; end
        C_WQ:    begin lp_addr = wq_addr; lp_wdata = wq_data; end
        default: begin lp_addr = FB_BASE_W | {5'd0, rd_buf, rd_base + rd_issue}; lp_wdata = 32'd0; end
    endcase
end

// lp_req is combinational from sel, so the accepted client is the one selected in
// the cycle before lp_ack is seen.
// Only one read is in flight at a time (the controller returns the data before it
// accepts the next access), so the owner of the last accepted read gets lp_rvalid.
reg       we_q;
reg [1:0] rd_owner;
always @(posedge clk) begin
    sel_q <= sel;
    we_q  <= lp_we;
    if (lp_ack && !we_q) rd_owner <= sel_q;
end

assign wq_pop    = lp_ack && sel_q == C_WQ;
assign rv_ack    = lp_ack && sel_q == C_RV;
assign rv_rvalid = lp_rvalid && rd_owner == C_RV;


// ------------------------------------------------------------ line buffer
reg [31:0] lbuf [0:255];
always @(posedge clk)
    if (lp_rvalid && rd_owner == C_RD) lbuf[{rd_line[0], rd_ret}] <= lp_rdata;
always @(posedge vclk)
    lb_q <= lbuf[lb_raddr];

endmodule
