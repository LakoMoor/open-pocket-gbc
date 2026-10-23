// Live screen stream engine: sends the changed rows of one framebuffer over the USB-UART, like
// the firmware's 'R' rows (fw/src/main.c, scr_poll), so the menu CPU (which runs from SDRAM at
// about 1 us per access) does not touch the pixels.
//
// For each of the 144 rows (80 words, two pixels each):
//   1. hash the row (two running sums) and compare with the hash stored for that row in a table
//      in SDRAM; unchanged rows are skipped, except row `fix` (one row per frame is always sent,
//      so a hash collision heals);
//   2. send 0x00 'R' y, then PackBits over the words: c < 128: c + 1 literal words follow,
//      c >= 128: c - 126 copies of the next word. Words are read again instead of buffered:
//      SDRAM is much faster than the 2 Mbaud UART.
// One SDRAM access at a time; req is held until ack (the iosys / memsys handshake).
module scr_engine (
    input             clk,
    input             reset,
    input             start,          // one cycle: base, htab and fix are valid
    input      [20:0] base,           // word address of the framebuffer (row y at base + y * 80)
    input      [20:0] htab,           // word address of the 144-word hash table
    input       [7:0] fix,            // a row that is sent even when unchanged
    output reg        busy,
    output reg  [7:0] rows,           // rows sent

    output reg        req,
    output reg        we,
    output reg [20:0] addr,
    output reg [31:0] wdata,
    input             ack,
    input      [31:0] rdata,
    input             rvalid,

    output            tx_valid,
    output      [7:0] tx_byte,
    input             tx_take         // the UART took tx_byte
);

localparam S_IDLE = 4'd0, S_HASH = 4'd1, S_OLD = 4'd2, S_HWR = 4'd3, S_HDR = 4'd4, S_E0 = 4'd5,
           S_E1 = 4'd6, S_RUN = 4'd7, S_RUNC = 4'd8, S_RUNW = 4'd9, S_LIT = 4'd10, S_LITC = 4'd11,
           S_LITW = 4'd12, S_NEXT = 4'd13, S_DONE = 4'd14;
reg  [3:0] st;
reg  [7:0] y;
reg  [6:0] i, j, k;
reg [20:0] rowa;
reg [31:0] w, prev, ha, hb, q;
reg        pend, got;

// output bytes, low byte first
reg [31:0] ob;
reg  [2:0] on;
assign tx_valid = on != 0;
assign tx_byte  = ob[7:0];

wire [31:0] h = ha ^ {hb[18:0], hb[31:19]};

// read the word at rowa + o; `got` with q when it is there
task automatic rd(input [6:0] o);
    begin addr <= rowa + o; we <= 1'b0; req <= 1'b1; pend <= 1'b1; got <= 1'b0; end
endtask

always @(posedge clk) begin
    if (ack) req <= 1'b0;
    if (rvalid && pend && !we) begin q <= rdata; got <= 1'b1; end
    if (tx_take && on != 0) begin ob <= ob >> 8; on <= on - 1'd1; end

    if (reset) begin
        st <= S_IDLE; busy <= 0; req <= 0; pend <= 0; got <= 0; on <= 0;
    end else case (st)
    S_IDLE: if (start) begin
        busy <= 1; rows <= 0; y <= 0; rowa <= base; i <= 0; ha <= 0; hb <= 0; st <= S_HASH;
    end
    // 1. hash: a += word, b += a (before the add)
    S_HASH:
        if (!pend) rd(i);
        else if (got) begin
            pend <= 0; got <= 0;
            ha <= ha + q; hb <= hb + ha;
            i <= i + 1'd1;
            if (i == 7'd79) st <= S_OLD;
        end
    S_OLD:
        if (!pend) begin addr <= htab + y; we <= 1'b0; req <= 1'b1; pend <= 1'b1; got <= 1'b0; end
        else if (got) begin
            pend <= 0; got <= 0;
            if (q == h && y != fix) st <= S_NEXT;
            else st <= S_HWR;
        end
    S_HWR:
        if (!pend) begin addr <= htab + y; we <= 1'b1; wdata <= h; req <= 1'b1; pend <= 1'b1; end
        else if (!req) begin pend <= 0; st <= S_HDR; end
    S_HDR:
        if (on == 0) begin ob <= {8'd0, y, 8'h52, 8'h00}; on <= 3'd3; i <= 0; st <= S_E0; rows <= rows + 1'd1; end
    // 2. PackBits over words
    S_E0:
        if (i == 7'd80) st <= S_NEXT;
        else if (!pend) rd(i);
        else if (got) begin
            pend <= 0; got <= 0; w <= q;
            if (i == 7'd79) begin j <= 7'd80; st <= S_LITC; end
            else st <= S_E1;
        end
    S_E1:
        if (!pend) rd(i + 1'd1);
        else if (got) begin
            pend <= 0; got <= 0;
            if (q == w) begin j <= i + 2'd2; st <= S_RUN; end
            else begin j <= i + 1'd1; prev <= q; st <= S_LIT; end
        end
    S_RUN:
        if (j == 7'd80) st <= S_RUNC;
        else if (!pend) rd(j);
        else if (got) begin
            pend <= 0; got <= 0;
            if (q == w) j <= j + 1'd1;
            else st <= S_RUNC;
        end
    S_RUNC:
        if (on == 0) begin ob <= {24'd0, {1'b0, j} - {1'b0, i} + 8'd126}; on <= 3'd1; st <= S_RUNW; end
    S_RUNW:
        if (on == 0) begin ob <= w; on <= 3'd4; i <= j; st <= S_E0; end
    // literal: words i .. j - 1 until two equal words follow (prev is word j)
    S_LIT:
        if (j >= 7'd79) begin j <= 7'd80; st <= S_LITC; end
        else if (!pend) rd(j + 1'd1);
        else if (got) begin
            pend <= 0; got <= 0;
            if (q == prev) st <= S_LITC;
            else begin prev <= q; j <= j + 1'd1; end
        end
    S_LITC:
        if (on == 0) begin ob <= {24'd0, 1'b0, 7'(j - i - 1'd1)}; on <= 3'd1; k <= i; st <= S_LITW; end
    S_LITW:
        if (k == j) begin i <= j; st <= S_E0; end
        else if (!pend) rd(k);
        else if (got && on == 0) begin
            pend <= 0; got <= 0;
            ob <= q; on <= 3'd4; k <= k + 1'd1;
        end
    S_NEXT: begin
        y <= y + 1'd1; rowa <= rowa + 21'd80; i <= 0; ha <= 0; hb <= 0;
        st <= y == 8'd143 ? S_DONE : S_HASH;
    end
    S_DONE:
        if (on == 0) begin busy <= 0; st <= S_IDLE; end
    default: st <= S_IDLE;
    endcase
end

endmodule
