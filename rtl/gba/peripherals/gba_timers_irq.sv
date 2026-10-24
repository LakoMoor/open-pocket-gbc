// SPDX-License-Identifier: GPL-3.0-or-later
// Four running timers, cascades, keypad and IE/IF/IME. Writes are pulses.
// ce is one 16.777216 MHz GBA tick. No dependence on CPU memory stalls.
module gba_timers_irq (
    input logic clk,reset,ce,
    input logic [9:0] keys, // 1 = pressed, A B Select Start Right Left Up Down R L
    input logic access,we,
    input logic [9:0] addr,
    input logic [31:0] wdata,
    input logic [3:0] be,
    output logic selected,
    output logic [31:0] rdata,
    output logic irq,
    output logic [3:0] overflow
);
    logic [15:0] reload[0:3],counter[0:3];
    logic [7:0] control[0:3];
    logic [9:0] divider[0:3];
    logic [13:0] ie,flags,events,clear_flags;
    logic ime;
    logic [15:0] keycnt;
    logic key_match,key_previous;
    logic [3:0] increment;
    wire timer_address=addr[9:4]==6'h10;
    wire [1:0] timer_index=addr[3:2];
    assign irq=ime && |(ie & flags);
    always_comb begin
        increment=0;overflow=0;
        for (int t=0;t<4;t++) begin
            if (control[t][7]) begin
                if (t!=0 && control[t][2]) increment[t]=overflow[t-1];
                else if (ce) case(control[t][1:0])
                    0: increment[t]=1;
                    1: increment[t]=divider[t][5:0]==63;
                    2: increment[t]=divider[t][7:0]==255;
                    3: increment[t]=divider[t]==1023;
                endcase
            end
            overflow[t]=increment[t] && counter[t]==16'hffff;
        end
        key_match=keycnt[15] ? ((keys & keycnt[9:0])==keycnt[9:0] && |keycnt[9:0]) : |(keys & keycnt[9:0]);
        events=0;
        for (int t=0;t<4;t++) events[3+t]=overflow[t] && control[t][6];
        events[12]=key_match && !key_previous && keycnt[14];
        clear_flags=0;
        if(access && we && addr[9:2]==8'h80) begin
            if(be[2]) clear_flags[7:0]=wdata[23:16];
            if(be[3]) clear_flags[13:8]=wdata[29:24];
        end
        selected=1;
        rdata=0;
        if(timer_address) rdata={8'd0,control[timer_index],counter[timer_index]};
        else case(addr[9:2])
            8'h4c: rdata={keycnt,6'b111111,~keys};
            8'h80: rdata={2'd0,flags,2'd0,ie};
            8'h82: rdata={31'd0,ime};
            default: selected=0;
        endcase
    end
    always_ff @(posedge clk) begin
        if(reset) begin
            for(int t=0;t<4;t++) begin
                reload[t]<=0;counter[t]<=0;control[t]<=0;divider[t]<=0;
            end
            ie<=0;flags<=0;ime<=0;keycnt<=0;key_previous<=0;
        end else begin
            flags <= (flags & ~clear_flags) | events;
            key_previous <= key_match;
            for(int t=0;t<4;t++) begin
                if(ce && control[t][7]) divider[t]<=divider[t]+1'b1;
                if(increment[t]) counter[t]<=overflow[t] ? reload[t] : counter[t]+1'b1;
                if(access && we && timer_address && timer_index==2'(t)) begin
                    if(be[0]) reload[t][7:0]<=wdata[7:0];
                    if(be[1]) reload[t][15:8]<=wdata[15:8];
                    if(be[2]) begin
                        control[t]<=wdata[23:16] & (t==0 ? 8'hc3 : 8'hc7);
                        if(!control[t][7] && wdata[23]) begin
                            counter[t]<={be[1] ? wdata[15:8] : reload[t][15:8], be[0] ? wdata[7:0] : reload[t][7:0]};
                            divider[t]<=0;
                        end
                    end
                end
            end
            if(access && we) case(addr[9:2])
                8'h4c: begin
                    if(be[2]) keycnt[7:0]<=wdata[23:16];
                    if(be[3]) keycnt[15:8]<=wdata[31:24]&8'hc3;
                end
                8'h80: begin
                    if(be[0]) ie[7:0]<=wdata[7:0];
                    if(be[1]) ie[13:8]<=wdata[13:8];
                end
                8'h82: if(be[0]) ime<=wdata[0];
                default: ;
            endcase
        end
    end
endmodule
