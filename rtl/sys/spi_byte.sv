// SPI master, mode 0, one byte per transfer. SCK half period = div + 1 clocks.
module spi_byte (
    input            clk,
    input            reset,
    input      [7:0] div,
    input            start,       // ignored while busy
    input      [7:0] tx,
    output reg [7:0] rx,
    output           busy,
    output reg       sck,
    output           mosi,
    input            miso
);

reg [7:0] sh;
reg [3:0] n;
reg [7:0] cnt;
assign busy = (n != 0);
assign mosi = sh[7];

always @(posedge clk) begin
    if (reset) begin
        n   <= 0;
        sck <= 0;
        sh  <= 8'hFF;
    end else if (n == 0) begin
        sck <= 0;
        if (start) begin
            sh  <= tx;
            n   <= 4'd8;
            cnt <= div;
        end
    end else if (cnt != 0)
        cnt <= cnt - 1'd1;
    else begin
        cnt <= div;
        if (!sck) begin
            sck <= 1;
            rx  <= {rx[6:0], miso};
        end else begin
            sck <= 0;
            sh  <= {sh[6:0], 1'b1};
            n   <= n - 1'd1;
        end
    end
end

endmodule
