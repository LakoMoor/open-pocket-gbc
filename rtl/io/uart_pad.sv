// Remote control over the on-board USB-UART (BL616, 115200 8N1).
// One ASCII character per event, upper case = press, lower case = release:
//   U/u up  D/d down  L/l left  R/r right  A/a A  B/b B  S/s select  T/t start
//   M/m menu key (like S1)   X/x reset key (like S2)   0 releases everything
// '[' / ']' suspend / resume button decoding during settings commands.
// '~' opts into a 2 s input lease and renews it; '0' releases and disarms it.
// Legacy clients do not send '~' and keep their original hold behaviour.
module uart_pad #(
    parameter CLK_HZ = 33_750_000,
    parameter BAUD   = 115_200,
    parameter LEASE_MS = 2000
) (
    input             clk,
    input             reset,
    input             rx,
    input      [11:0] div,          // bit time in clocks (CLK_HZ / BAUD by default, set by the firmware)
    output reg [11:0] pad,          // {R L X A RIGHT LEFT DOWN UP START SELECT Y B}
    output reg        key_menu,
    output reg        key_reset,
    output            rx_seen,      // one clock per received byte (remote activity)
    output     [7:0]  rx_byte       // the byte, valid with rx_seen
);


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
        if (!rxd) begin busy <= 1; cnt <= div[11:1]; bitn <= 0; end
    end else if (cnt != 0) begin
        cnt <= cnt - 1'd1;
    end else begin
        cnt <= div - 1'd1;
        bitn <= bitn + 1'd1;
        case (bitn)
            4'd0: if (rxd) busy <= 0;                     // false start bit
            4'd9: begin busy <= 0; if (rxd) begin strobe <= 1; data <= sh; end end
            default: sh <= {rxd, sh[7:1]};
        endcase
    end
end

assign rx_seen = strobe;
assign rx_byte = data;
wire press = (data >= "A") && (data <= "Z");
wire [7:0] up = press ? data : data - 8'h20;
localparam MS_DIV = CLK_HZ / 1000 > 0 ? CLK_HZ / 1000 : 1;
localparam MS_BITS = MS_DIV > 1 ? $clog2(MS_DIV) : 1;
localparam AGE_BITS = LEASE_MS > 1 ? $clog2(LEASE_MS + 1) : 1;
reg [MS_BITS-1:0] lease_tick;
reg [AGE_BITS-1:0] lease_age;
reg lease_on, command_mode;
always @(posedge clk) begin
    if (reset) begin
        pad <= 0; key_menu <= 0; key_reset <= 0;
        lease_tick <= 0; lease_age <= 0; lease_on <= 0; command_mode <= 0;
    end else begin
        if (lease_on) begin
            if (lease_tick == MS_DIV - 1) begin
                lease_tick <= 0;
                if (lease_age < LEASE_MS) lease_age <= lease_age + 1'd1;
                if (lease_age >= LEASE_MS - 1) begin
                    pad <= 0; key_menu <= 0; key_reset <= 0;
                    command_mode <= 0;
                end
            end else lease_tick <= lease_tick + 1'd1;
        end
        if (strobe && data == "~") begin
            lease_on <= 1; lease_age <= 0; lease_tick <= 0;
        end
        if (strobe && data == "[") begin
            command_mode <= 1;
            lease_on <= 1; lease_age <= 0; lease_tick <= 0;
            pad <= 0; key_menu <= 0; key_reset <= 0;
        end
        if (strobe && command_mode) begin lease_age <= 0; lease_tick <= 0; end
        if (strobe && data == "]") command_mode <= 0;
        if (strobe && data == "0") begin
            pad <= 0; key_menu <= 0; key_reset <= 0;
            if (!command_mode) lease_on <= 0;
        end else if (strobe && !command_mode) begin
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
            default: ;
          endcase
        end
    end
end

endmodule
