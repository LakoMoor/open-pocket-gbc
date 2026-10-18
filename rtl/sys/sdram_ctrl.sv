// SDRAM controller for the GW2AR-18 embedded 64 Mbit SDRAM (2M x 32, 4 banks,
// 2048 rows, 256 columns), running in the Game Boy clk_sys domain (33.75 MHz).
// The chip clock is clk_sys shifted by 180 degrees, so commands launched on a
// rising edge are sampled by the SDRAM half a cycle later.
//
// Every access is a single word with auto-precharge and takes 5 cycles:
//   c0 ACTIVE, c2 READ/WRITE (A10=1), read data captured RD_CAPTURE cycles after c2.
//
// Port priorities:
//   1. Cart port (Game Boy cartridge bus). Reads are triggered by the rising edge of
//      the core's sdram_rd strobe (start of each bus cycle), writes by the rising edge
//      of cram_wr. Data is ready ~6 cycles after the strobe, well before the CPU latches
//      it (>= 12 cycles later even in double speed mode).
//   2. Refresh and the generic low-priority port. These only start while lp_block is
//      low; the core drives lp_block in the cycles just before a cart strobe can occur,
//      so a cart access never has to wait.
module sdram_ctrl #(
    parameter RD_CAPTURE = 2,      // cycles from READ command to data capture
    parameter INIT_WAIT  = 7000,   // >200 us at 33.75 MHz
    parameter REFRESH_INTERVAL = 250 // 7.4 us
) (
    input             clk,
    input             resetn,          // hold low until PLL locked
    output reg        ready,

    // cart port (byte access)
    input             cart_rd_strobe,  // level; rising edge starts a read
    input             cart_wr_strobe,  // level; rising edge starts a write
    input      [22:0] cart_addr,       // byte address
    input       [7:0] cart_din,
    output reg  [7:0] cart_dout,

    // low priority port (word access)
    input             lp_block,
    input             lp_req,          // hold until lp_ack
    output reg        lp_ack,          // one cycle: request accepted
    input             lp_we,
    input      [20:0] lp_addr,         // word address
    input      [31:0] lp_wdata,
    input       [3:0] lp_be,
    output reg [31:0] lp_rdata,
    output reg        lp_rvalid,       // one cycle: lp_rdata valid for the last read

    // SDRAM pins
    output            O_sdram_clk,
    output reg        O_sdram_cke,
    output reg        O_sdram_cs_n,
    output reg        O_sdram_ras_n,
    output reg        O_sdram_cas_n,
    output reg        O_sdram_wen_n,
    output reg  [3:0] O_sdram_dqm,
    output reg [10:0] O_sdram_addr,
    output reg  [1:0] O_sdram_ba,
    inout      [31:0] IO_sdram_dq,

    input             clk_sdram_p      // clk_sys @ 180 deg
);

assign O_sdram_clk = clk_sdram_p;

localparam CMD_NOP       = 3'b111;
localparam CMD_ACTIVE    = 3'b011;
localparam CMD_READ      = 3'b101;
localparam CMD_WRITE     = 3'b100;
localparam CMD_PRECHARGE = 3'b010;
localparam CMD_REFRESH   = 3'b001;
localparam CMD_LOADMODE  = 3'b000;

// CAS latency 2, burst length 1, sequential, single write
localparam [10:0] MODE_REG = 11'b000_0_00_010_0_000;

reg [31:0] dq_out;
reg        dq_oe;
assign IO_sdram_dq = dq_oe ? dq_out : 32'bz;

task automatic cmd(input [2:0] c);
    {O_sdram_ras_n, O_sdram_cas_n, O_sdram_wen_n} <= c;
endtask

// ---------------------------------------------------------------- strobes
reg cart_rd_d, cart_wr_d;
reg cart_rd_pend, cart_wr_pend;
reg [22:0] cart_rd_addr, cart_wr_addr;
reg  [7:0] cart_wr_data;

// ---------------------------------------------------------------- refresh timer
reg [8:0] ref_cnt;
reg       ref_pend;

// ---------------------------------------------------------------- sequencer
localparam S_INIT = 0, S_IDLE = 1, S_ACCESS = 2;
reg  [1:0] state;
reg [13:0] init_cnt;
reg  [2:0] cyc;            // cycle within access
reg        acc_we, acc_ref;
reg        acc_cart, acc_lp;
reg [20:0] acc_waddr;
reg [31:0] acc_wdata;
reg  [3:0] acc_be;
reg  [1:0] acc_lane;

// read data capture pipeline: bit0 = cart, bit1 = lp, plus byte lane
reg [RD_CAPTURE:0] cap_cart, cap_lp;
reg  [1:0] cap_lane [0:RD_CAPTURE];

always @(posedge clk) begin
    if (!resetn) begin
        state        <= S_INIT;
        init_cnt     <= 0;
        ready        <= 0;
        O_sdram_cke  <= 0;
        O_sdram_cs_n <= 1;
        cmd(CMD_NOP);
        O_sdram_dqm  <= 4'hF;
        O_sdram_addr <= 0;
        O_sdram_ba   <= 0;
        dq_oe        <= 0;
        cart_rd_pend <= 0;
        cart_wr_pend <= 0;
        cart_rd_d    <= 1;
        cart_wr_d    <= 1;
        ref_cnt      <= 0;
        ref_pend     <= 0;
        lp_ack       <= 0;
        cap_cart     <= 0;
        cap_lp       <= 0;
    end else begin
        cmd(CMD_NOP);
        dq_oe  <= 0;
        lp_ack <= 0;

        // strobe edge detection; latch the address at the edge
        cart_rd_d <= cart_rd_strobe;
        cart_wr_d <= cart_wr_strobe;
        if (cart_rd_strobe & ~cart_rd_d) begin
            cart_rd_pend <= 1;
            cart_rd_addr <= cart_addr;
        end
        if (cart_wr_strobe & ~cart_wr_d) begin
            cart_wr_pend <= 1;
            cart_wr_addr <= cart_addr;
            cart_wr_data <= cart_din;
        end

        if (ref_cnt == REFRESH_INTERVAL - 1) begin
            ref_cnt  <= 0;
            ref_pend <= 1;
        end else
            ref_cnt <= ref_cnt + 1'd1;

        case (state)
        S_INIT: begin
            init_cnt    <= init_cnt + 1'd1;
            O_sdram_cke <= 1;
            O_sdram_cs_n <= 0;
            case (init_cnt)
                INIT_WAIT:      begin cmd(CMD_PRECHARGE); O_sdram_addr <= 11'b100_0000_0000; end
                INIT_WAIT + 4,
                INIT_WAIT + 12,
                INIT_WAIT + 20,
                INIT_WAIT + 28,
                INIT_WAIT + 36,
                INIT_WAIT + 44,
                INIT_WAIT + 52,
                INIT_WAIT + 60: cmd(CMD_REFRESH);
                INIT_WAIT + 68: begin cmd(CMD_LOADMODE); O_sdram_addr <= MODE_REG; O_sdram_ba <= 0; end
                INIT_WAIT + 72: begin state <= S_IDLE; ready <= 1; O_sdram_dqm <= 4'h0; end
                default: ;
            endcase
        end

        S_IDLE: begin
            acc_cart <= 0;
            acc_lp   <= 0;
            acc_ref  <= 0;
            acc_we   <= 0;
            cyc      <= 0;
            if (cart_rd_pend | (cart_rd_strobe & ~cart_rd_d)) begin
                // read (also covers a strobe arriving this very cycle)
                logic [22:0] a;
                a = cart_rd_pend ? cart_rd_addr : cart_addr;
                cart_rd_pend <= 0;
                acc_cart  <= 1;
                acc_waddr <= a[22:2];
                acc_lane  <= a[1:0];
                state     <= S_ACCESS;
                cmd(CMD_ACTIVE);
                O_sdram_ba   <= a[22:21];
                O_sdram_addr <= a[20:10];
            end else if (cart_wr_pend) begin
                cart_wr_pend <= 0;
                acc_cart  <= 1;
                acc_we    <= 1;
                acc_waddr <= cart_wr_addr[22:2];
                acc_wdata <= {4{cart_wr_data}};
                acc_be    <= 4'b0001 << cart_wr_addr[1:0];
                state     <= S_ACCESS;
                cmd(CMD_ACTIVE);
                O_sdram_ba   <= cart_wr_addr[22:21];
                O_sdram_addr <= cart_wr_addr[20:10];
            end else if (ref_pend & ~lp_block) begin
                ref_pend <= 0;
                acc_ref  <= 1;
                state    <= S_ACCESS;
                cmd(CMD_REFRESH);
            end else if (lp_req & ~lp_block) begin
                lp_ack    <= 1;
                acc_lp    <= 1;
                acc_we    <= lp_we;
                acc_waddr <= lp_addr;
                acc_wdata <= lp_wdata;
                acc_be    <= lp_be;
                state     <= S_ACCESS;
                cmd(CMD_ACTIVE);
                O_sdram_ba   <= lp_addr[20:19];
                O_sdram_addr <= lp_addr[18:8];
            end
        end

        S_ACCESS: begin
            cyc <= cyc + 1'd1;
            if (cyc == 3'd1 && !acc_ref) begin
                // column command with auto precharge
                O_sdram_addr <= {3'b100, acc_waddr[7:0]};
                if (acc_we) begin
                    cmd(CMD_WRITE);
                    dq_out      <= acc_wdata;
                    dq_oe       <= 1;
                    O_sdram_dqm <= ~acc_be;
                end else begin
                    cmd(CMD_READ);
                    O_sdram_dqm <= 4'h0;
                end
            end else
                O_sdram_dqm <= 4'h0;
            if (cyc == 3'd3) state <= S_IDLE;   // ACT at c0 .. next ACT at c5 (cycle after IDLE)
        end
        default: state <= S_INIT;
        endcase

        // capture pipeline (stage 0 is loaded with the READ command)
        cap_cart <= {cap_cart[RD_CAPTURE-1:0], (state == S_ACCESS && cyc == 3'd1 && !acc_ref && !acc_we && acc_cart)};
        cap_lp   <= {cap_lp[RD_CAPTURE-1:0],   (state == S_ACCESS && cyc == 3'd1 && !acc_ref && !acc_we && acc_lp)};
        cap_lane[0] <= acc_lane;
        for (int i = 1; i <= RD_CAPTURE; i++) cap_lane[i] <= cap_lane[i-1];
    end
end

// read data capture
always @(posedge clk) begin
    lp_rvalid <= 0;
    if (cap_cart[RD_CAPTURE-1]) begin
        case (cap_lane[RD_CAPTURE-1])
            2'd0: cart_dout <= IO_sdram_dq[7:0];
            2'd1: cart_dout <= IO_sdram_dq[15:8];
            2'd2: cart_dout <= IO_sdram_dq[23:16];
            2'd3: cart_dout <= IO_sdram_dq[31:24];
        endcase
    end
    if (cap_lp[RD_CAPTURE-1]) begin
        lp_rdata  <= IO_sdram_dq;
        lp_rvalid <= 1;
    end
end

endmodule
