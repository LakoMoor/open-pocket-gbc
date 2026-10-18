// Remote control over the on-board USB-UART (BL616, 115200 8N1).
// One ASCII character per event, upper case = press, lower case = release:
//   U/u up  D/d down  L/l left  R/r right  A/a A  B/b B  S/s select  T/t start
//   M/m menu key (like S1)   X/x reset key (like S2)   0 releases everything
// tools/remote.py sends these from the PC.
module uart_pad #(
    parameter CLK_HZ = 33_750_000,
    parameter BAUD   = 115_200
) (
    input             clk,
    input             reset,
    input             rx,
    output reg [11:0] pad,          // {R L X A RIGHT LEFT DOWN UP START SELECT Y B}
    output reg        key_menu,
    output reg        key_reset
);

localparam integer DIV = CLK_HZ / BAUD;

reg [2:0]  rx_s = 3'b111;
always @(posedge clk) rx_s <= {rx_s[1:0], rx};
wire rxd = rx_s[2];

reg [15:0] cnt;
reg  [3:0] bitn;
reg  [7:0] sh;
reg        busy;
reg        strobe;
reg  [7:0] data;
always @(posedge clk) begin
    strobe <= 0;
    if (reset) begin
        busy <= 0;
    end else if (!busy) begin
        if (!rxd) begin busy <= 1; cnt <= DIV / 2; bitn <= 0; end
    end else if (cnt != 0) begin
        cnt <= cnt - 1'd1;
    end else begin
        cnt <= DIV - 1;
        bitn <= bitn + 1'd1;
        case (bitn)
            4'd0: if (rxd) busy <= 0;                     // false start bit
            4'd9: begin busy <= 0; if (rxd) begin strobe <= 1; data <= sh; end end
            default: sh <= {rxd, sh[7:1]};
        endcase
    end
end

wire press = (data >= "A") && (data <= "Z");
wire [7:0] up = press ? data : data - 8'h20;
always @(posedge clk) begin
    if (reset) begin
        pad <= 0; key_menu <= 0; key_reset <= 0;
    end else if (strobe) begin
        case (up)
            "U": pad[4]    <= press;
            "D": pad[5]    <= press;
            "L": pad[6]    <= press;
            "R": pad[7]    <= press;
            "A": pad[8]    <= press;
            "B": pad[0]    <= press;
            "S": pad[2]    <= press;
            "T": pad[3]    <= press;
            "M": key_menu  <= press;
            "X": key_reset <= press;
            default: if (data == "0") begin pad <= 0; key_menu <= 0; key_reset <= 0; end
        endcase
    end
end

endmodule
