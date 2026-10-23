// Live screen stream engine: sends the changed rows of one framebuffer over the USB-UART as 'M'
// rows, so the menu CPU (which runs from SDRAM at about 1 us per access) does not touch the pixels.
//
// For each of the 144 rows (80 words, two pixels each):
//   1. hash the row (rotate and xor) and compare with the hash stored for that row in a table in
//      SDRAM; unchanged rows are skipped, except row `fix` (one row per frame is always sent, so
//      a hash collision heals);
//   2. send 0x00 'M' y, then 10 groups of 8 words: a mask byte (bit n set: word n repeats the
//      word before it; before the first word of the row comes 0), then the other words of the
//      group, 4 bytes each, low byte first. Each group is read twice (mask, then words): SDRAM is
//      much faster than the 2 Mbaud UART, and every read is rowa + o with one offset counter.
// One SDRAM access at a time; req is held until ack (the iosys / memsys handshake).
module scr_engine (
    input             clk,
    input             reset,
    input             start,          // one cycle: base, htab and fix are valid
    input      [20:0] base,           // word address of the framebuffer (row y at base + y * 80)
    input      [20:0] htab,           // word address of the 144-word hash table (256-word aligned)
    input       [7:0] fix,            // a row that is sent even when unchanged
    output reg        busy,

    output reg        req,
    output reg        we,
    output     [20:0] addr,
    output     [31:0] wdata,
    input             ack,
    input      [31:0] rdata,
    input             rvalid,

    output            tx_valid,
    output      [7:0] tx_byte,
    input             tx_take         // the UART took tx_byte
);

localparam S_IDLE = 3'd0, S_HASH = 3'd1, S_OLD = 3'd2, S_HWR = 3'd3, S_MASK = 3'd4, S_SENDM = 3'd5,
           S_WORDS = 3'd6, S_NEXT = 3'd7;
reg  [2:0] st;
reg  [7:0] y;
reg  [6:0] o;                  // word in the row
reg  [2:0] n;                  // word in the group
reg  [7:0] mask;
reg [20:0] rowa;
reg [31:0] prev, h, q;
reg        hsel;               // the access goes to the hash table
reg        pend, got;

assign addr  = hsel ? {htab[20:8], y} : rowa + o;
assign wdata = h;

// output: `on` bytes of the source `os` (header, mask or the word in q), byte oi first
localparam O_HDR = 2'd0, O_MASK = 2'd1, O_WORD = 2'd2;
reg  [1:0] os;
reg  [2:0] on;
reg  [1:0] oi;
assign tx_valid = on != 0;
wire [31:0] osrc = os == O_HDR ? {8'd0, y, 8'h4D, 8'h00} : os == O_MASK ? {24'd0, mask} : q;
assign tx_byte  = oi == 0 ? osrc[7:0] : oi == 1 ? osrc[15:8] : oi == 2 ? osrc[23:16] : osrc[31:24];
wire same = q == (hsel ? h : prev);    // one comparator: the stored hash, or the word before

always @(posedge clk) begin
    if (ack) req <= 1'b0;
    if (rvalid && pend && !we) begin q <= rdata; got <= 1'b1; end
    if (tx_take && on != 0) begin oi <= oi + 1'd1; on <= on - 1'd1; end

    if (reset) begin
        st <= S_IDLE; busy <= 0; req <= 0; pend <= 0; got <= 0; on <= 0;
    end else case (st)
    S_IDLE: if (start) begin
        busy <= 1; y <= 0; rowa <= base; o <= 0; h <= 0; hsel <= 0; st <= S_HASH;
    end
    // 1. hash: rotate left by one, xor the word
    S_HASH:
        if (!pend) begin if (on == 0) begin we <= 0; req <= 1; pend <= 1; got <= 0; end end
        else if (got) begin
            pend <= 0; got <= 0;
            h <= {h[30:0], h[31]} ^ q;
            o <= o + 1'd1;
            if (o == 7'd79) begin hsel <= 1; st <= S_OLD; end
        end
    S_OLD:
        if (!pend) begin we <= 0; req <= 1; pend <= 1; got <= 0; end
        else if (got) begin
            pend <= 0; got <= 0;
            if (same && y != fix) begin hsel <= 0; st <= S_NEXT; end
            else st <= S_HWR;
        end
    S_HWR:
        if (!pend) begin we <= 1; req <= 1; pend <= 1; end
        else if (!req && on == 0) begin
            pend <= 0; we <= 0; hsel <= 0;
            os <= O_HDR; on <= 3'd3; oi <= 0;
            o <= 0; n <= 0; prev <= 0; st <= S_MASK;
        end
    // 2. a group: the mask from 8 reads, then the words that differ from the one before
    S_MASK:
        if (!pend) begin if (on == 0) begin we <= 0; req <= 1; pend <= 1; got <= 0; end end   // q is being sent
        else if (got) begin
            pend <= 0; got <= 0;
            mask <= {same, mask[7:1]};
            prev <= q;
            n <= n + 1'd1;
            if (n == 3'd7) begin o <= o - 3'd7; st <= S_SENDM; end
            else o <= o + 1'd1;
        end
    S_SENDM:
        if (on == 0) begin os <= O_MASK; on <= 3'd1; oi <= 0; st <= S_WORDS; end
    S_WORDS:
        if (on != 0) ;                           // the mask byte or a word is still going out
        else if (mask[0]) begin                  // a repeat: nothing to send
            mask <= mask >> 1; o <= o + 1'd1; n <= n + 1'd1;
            if (n == 3'd7) st <= o == 7'd79 ? S_NEXT : S_MASK;
        end else if (!pend) begin if (on == 0) begin we <= 0; req <= 1; pend <= 1; got <= 0; end end
        else if (got) begin
            pend <= 0; got <= 0;
            os <= O_WORD; on <= 3'd4; oi <= 0;
            mask <= mask >> 1; o <= o + 1'd1; n <= n + 1'd1;
            if (n == 3'd7) st <= o == 7'd79 ? S_NEXT : S_MASK;
        end
    S_NEXT:
        if (y == 8'd143) begin
            if (on == 0) begin busy <= 0; st <= S_IDLE; end
        end else begin
            y <= y + 1'd1; rowa <= addr; o <= 0; h <= 0; st <= S_HASH;   // o is 80 here
        end
    default: st <= S_IDLE;
    endcase
end

endmodule
