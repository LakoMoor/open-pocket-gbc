`timescale 1ns/1ps
module tb_printer;
reg clk=0, reset=1, sc=1, si=0;
always #5 clk=~clk;
wire so;
reg [31:0] address=0, value=0;
reg valid=0;
reg [3:0] strobes=0;
iosys dut (
 .clk(clk),.reset(reset),.sdram_ready(1'b0),.rv_ack(1'b0),.rv_rdata(32'd0),.rv_rvalid(1'b0),
 .flash_miso(1'b1),.sd_miso(1'b1),.cart_miso(1'b1),.link_sc(sc),.link_si(si),.prn_so(so),
 .inputs(16'd0),.frame_tick(1'b0),.stat_gbc(1'b0),.stat_2x(1'b0),.stat_buf(2'd0),
 .uart_seen(1'b0),.uart_byte(8'd0),.aud_smp(1'b0),.aud_mono8(8'd128),.gpio_in(3'd0),.cram_wr(1'b0));
task wr(input[31:0] a,input[31:0] v);
 begin @(negedge clk);address=a;value=v;strobes=15;valid=1;@(negedge clk);valid=0;strobes=0;end
endtask
task rd(input[31:0] a,output[31:0] v);
 begin @(negedge clk);address=a;strobes=0;valid=1;#1;v=dut.mem_rdata;@(negedge clk);valid=0;end
endtask
task transfer(input[7:0] tx,output[7:0] rx);
 integer bitno;
 begin
  rx=0;
  for(bitno=7;bitno>=0;bitno=bitno-1)begin
   @(negedge clk);sc=0;si=tx[bitno];repeat(20)@(negedge clk);
   rx={rx[6:0],so};sc=1;repeat(20)@(negedge clk);
  end
 end
endtask
reg[7:0] reply;
reg[31:0] received;
integer bitno;
initial begin
 force dut.mem_valid=valid;force dut.mem_addr=address;force dut.mem_wdata=value;force dut.mem_wstrb=strobes;
 force dut.prn_n=0; // reproduce a power-up at byte boundary even on the unfixed design
 repeat(5)@(negedge clk);reset=0;release dut.prn_n;
 wr(32'h02000038,32'h00010000);
 wr(32'h02000060,32'h100);
 transfer(8'h88,reply);
 wr(32'h02000034,200); // WAIT write clears edge events after the byte already arrived
 @(negedge clk);address=32'h02000034;valid=1;#1;
 if(dut.mem_ready!==1'b1)$fatal(1,"WAIT lost a pending printer byte");
 @(negedge clk);valid=0;
 rd(32'h02000060,received);if(received!==32'h188)$fatal(1,"printer received %x instead of 88",received);
 // INIT packet: firmware queues ID at checksum-low, status at checksum-high.
 transfer(8'h33,reply);rd(32'h02000060,received);
 transfer(8'h01,reply);rd(32'h02000060,received);
 transfer(8'h00,reply);rd(32'h02000060,received);
 transfer(8'h00,reply);rd(32'h02000060,received);
 transfer(8'h00,reply);rd(32'h02000060,received);
 transfer(8'h01,reply);rd(32'h02000060,received);wr(32'h02000060,32'h81);
 transfer(8'h00,reply);rd(32'h02000060,received);wr(32'h02000060,32'h00);
 transfer(8'h00,reply);if(reply!==8'h81)$fatal(1,"game did not receive printer ID: %x",reply);rd(32'h02000060,received);
 transfer(8'h00,reply);if(reply!==0)$fatal(1,"bad INIT status: %x",reply);
 wr(32'h02000060,32'h100);rd(32'h02000060,received);if(received[8])$fatal(1,"flush retained a pending byte");
 // The menu CPU may pause the virtual Game Boy mid-byte during a tile copy.
 for(bitno=7;bitno>=5;bitno=bitno-1)begin
  @(negedge clk);sc=0;si=(8'ha5>>bitno)&1;repeat(20)@(negedge clk);sc=1;repeat(20)@(negedge clk);
 end
 wr(32'h02000038,32'h00010002);repeat(45000)@(negedge clk);wr(32'h02000038,32'h00010000);
 for(bitno=4;bitno>=0;bitno=bitno-1)begin
  @(negedge clk);sc=0;si=(8'ha5>>bitno)&1;repeat(20)@(negedge clk);sc=1;repeat(20)@(negedge clk);
 end
 rd(32'h02000060,received);if(received!==32'h1a5)$fatal(1,"paused transfer lost bit alignment: %x",received);
 transfer(8'he7,reply); // leave an unread byte while the next byte completes
 for(bitno=7;bitno>=0;bitno=bitno-1)begin
  @(negedge clk);sc=0;si=(8'h3c>>bitno)&1;repeat(20)@(negedge clk);sc=1;
  if(bitno==0)begin
   @(negedge clk);address=32'h02000060;valid=1;#1;
   if(dut.mem_rdata!==32'h1e7)$fatal(1,"old mailbox byte was lost");
   @(negedge clk);valid=0;
   repeat(18)@(negedge clk);
  end else repeat(20)@(negedge clk);
 end
 rd(32'h02000060,received);if(received!==32'h13c)$fatal(1,"read cleared a simultaneously arriving byte: %x",received);
 reset=1;repeat(3)@(negedge clk);
 if(dut.prn_n!==0 || dut.prn_valid!==0 || so!==0)$fatal(1,"warm reset did not reset printer");
 $display("PASS: printer detection, pending-byte wake-up, pause, read/receive race, flush and warm reset");$finish;
end
initial begin #1000000;$fatal(1,"timeout");end
endmodule
