// SPI port of the I/O system: three registers on the CPU bus.
//   +0 DATA  write: send a byte (waits while busy); read: last received byte
//   +4 WORD  read: four 0xFF transfers, returned little endian
//   +8 CTRL  [0] CS asserted  [15:8] SCK half period - 1
module spi_port #(
    parameter [7:0] DIV0 = 8'd0
) (
    input             clk,
    input             reset,

    input             valid,        // bus request to this port
    input       [1:0] sel,          // 0 DATA, 1 WORD, 2 CTRL
    input             wr,
    input             fire,         // valid & ready this cycle
    input      [31:0] wdata,
    output reg        ready,
    output reg [31:0] rdata,

    output            cs_n,
    output            sck,
    output            mosi,
    input             miso
);

reg  [7:0] div;
reg        cs;
reg        start;
reg  [7:0] tx;
wire [7:0] rx;
wire       busy;
spi_byte u_spi (.clk(clk), .reset(reset), .div(div), .start(start), .tx(tx),
                .rx(rx), .busy(busy), .sck(sck), .mosi(mosi), .miso(miso));
assign cs_n = ~cs;

reg  [2:0] wn;                  // transfers left of a word read (5 = not started), 0 idle
reg [31:0] wq;
reg        wgo;
wire       idle = ~busy & ~start & (wn == 0);

always @* begin
    rdata = 32'd0;
    case (sel)
        2'd0: begin ready = idle;                  rdata = {24'd0, rx}; end
        2'd1: begin ready = wr ? idle : (wgo & idle); rdata = wq; end
        default: begin ready = 1;                  rdata = {16'd0, div, 7'd0, cs}; end
    endcase
end

always @(posedge clk) begin
    start <= 0;
    if (wn != 0 && !busy && !start) begin
        if (wn != 3'd5) wq <= {rx, wq[31:8]};
        if (wn == 3'd1) wn <= 0;
        else begin tx <= 8'hFF; start <= 1; wn <= wn - 1'd1; end
    end
    if (valid && !wr && sel == 2'd1 && !wgo && idle) begin wgo <= 1; wn <= 3'd5; end
    if (fire) begin
        if (wr) case (sel)
            2'd0, 2'd1: begin tx <= wdata[7:0]; start <= 1; end
            2'd2: begin cs <= wdata[0]; div <= wdata[15:8]; end
            default: ;
        endcase
        else if (sel == 2'd1) wgo <= 0;
    end
    if (reset) begin
        cs <= 0; div <= DIV0; wn <= 0; wgo <= 0;
    end
end

endmodule
