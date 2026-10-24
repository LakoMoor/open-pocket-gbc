// SPDX-License-Identifier: GPL-3.0-or-later
// Two clients, one outstanding transaction. Registered grant prevents a new
// higher-priority request from stealing a delayed sdram_ctrl acknowledgement.
module gba_sdram_arbiter (
    input logic clk, reset,
    input logic cpu_req, cpu_we,
    input logic [20:0] cpu_addr,
    input logic [31:0] cpu_wdata,
    input logic [3:0] cpu_be,
    output logic cpu_ack, cpu_rvalid,
    input logic video_req,
    input logic [20:0] video_addr,
    output logic video_ack, video_rvalid,
    output logic lp_req, lp_we,
    output logic [20:0] lp_addr,
    output logic [31:0] lp_wdata,
    output logic [3:0] lp_be,
    input logic lp_ack, lp_rvalid
);
    typedef enum logic [1:0] {IDLE, ISSUE, READ} state_t;
    state_t state;
    logic owner_video, last_video;
    wire select_video = video_req && (!cpu_req || !last_video);
    assign lp_req = state == ISSUE && !reset;
    assign cpu_ack = lp_req && lp_ack && !owner_video;
    assign video_ack = lp_req && lp_ack && owner_video;
    assign cpu_rvalid = state == READ && lp_rvalid && !owner_video;
    assign video_rvalid = state == READ && lp_rvalid && owner_video;
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE; owner_video <= 0; last_video <= 0;
            lp_we <= 0; lp_addr <= 0; lp_wdata <= 0; lp_be <= 0;
        end else case (state)
            IDLE: if (cpu_req || video_req) begin
                owner_video <= select_video;
                last_video <= select_video;
                lp_addr <= select_video ? video_addr : cpu_addr;
                lp_we <= !select_video && cpu_we;
                lp_wdata <= cpu_wdata;
                lp_be <= select_video ? 4'hf : cpu_be;
                state <= ISSUE;
            end
            ISSUE: if (lp_ack) state <= lp_we ? IDLE : READ;
            READ: if (lp_rvalid) state <= IDLE;
            default: state <= IDLE;
        endcase
    end
endmodule
