`timescale 1ns/1ps
module tb_uart_pad;
reg clk=0, reset=1, rx=1;
always #5 clk=~clk;
wire [11:0] pad;
wire menu_key, reset_key, seen;
wire [7:0] byte_rx;
// 10 clocks/ms, 8 clocks/serial bit; a short lease keeps the simulation fast.
uart_pad #(.CLK_HZ(10000), .LEASE_MS(100)) dut(
 .clk(clk), .reset(reset), .rx(rx), .div(12'd8), .pad(pad),
 .key_menu(menu_key), .key_reset(reset_key), .rx_seen(seen), .rx_byte(byte_rx));
task send(input [7:0] value);
 integer i;
 begin
  @(negedge clk);rx=0;repeat(8)@(negedge clk);
  for(i=0;i<8;i=i+1)begin rx=value[i];repeat(8)@(negedge clk);end
  rx=1;repeat(12)@(negedge clk);
 end
endtask
initial begin
 repeat(5)@(negedge clk);reset=0;
 send("A");if(!pad[8])$fatal(1,"A press lost");
 repeat(1300)@(negedge clk);if(!pad[8])$fatal(1,"legacy hold unexpectedly expired");
 send("a");if(pad[8])$fatal(1,"A release lost");
 send("~");send("U");if(!pad[4])$fatal(1,"leased press lost");
 repeat(400)@(negedge clk);send("~");repeat(400)@(negedge clk);
 if(!pad[4])$fatal(1,"heartbeat did not renew lease");
 repeat(700)@(negedge clk);if(pad || menu_key || reset_key)$fatal(1,"lease failed to release inputs");
 send("[");send("0"); // digits in settings do not leave command mode
 send("L");send("i");send("s");send("t");send("M");send("X");
 if(pad || menu_key || reset_key)$fatal(1,"settings bytes reached buttons");
 send("]");send("0");send("M");if(!menu_key)$fatal(1,"menu did not recover after config");
 send("0");if(pad || menu_key || reset_key)$fatal(1,"release all failed");
 send("[");send("0");repeat(1200)@(negedge clk);send("B");
 if(!pad[0])$fatal(1,"abandoned config did not expire");
 reset=1;repeat(2)@(negedge clk);if(pad || menu_key || reset_key)$fatal(1,"reset failed");
 $display("PASS: UART legacy controls, lease, heartbeat, config isolation and recovery");$finish;
end
initial begin #1000000;$fatal(1,"simulation timeout");end
endmodule
