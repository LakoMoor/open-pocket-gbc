// SPDX-License-Identifier: GPL-3.0-or-later
// Diagnostic Mode 3 scanout (not GBA PPU timing). Two 240-pixel line banks.
// A row is fetched during the previous row's first HDMI repetition, allowing
// almost three scanlines to complete. No framebuffer is allocated in BSRAM.
module gba_mode3_scanout (
    input logic clk, reset,
    output logic video_req,
    output logic [20:0] video_addr,
    input logic video_ack, video_rvalid,
    input logic [31:0] video_rdata,
    input logic vclk, vreset, enable,
    input logic [9:0] cx, cy,
    output logic [23:0] rgb,
    output logic underrun
);
    logic request_toggle;
    logic [7:0] request_row;
    logic [2:0] req_sync;
    logic [7:0] row;
    logic [6:0] index;
    logic active, waiting;
    logic done_toggle;
    logic [7:0] done_row;
    logic [31:0] lines[0:255];
    assign video_req = active && !waiting && !reset;
    assign video_addr = 21'h1a0000 + (21'(row)*21'd120) + 21'(index);
    always_ff @(posedge clk) begin
        if (reset) begin
            req_sync <= 0; active <= 0; waiting <= 0;
            row <= 0; index <= 0; done_toggle <= 0; done_row <= 0;
        end else begin
            req_sync <= {req_sync[1:0],request_toggle};
            if ((req_sync[2] ^ req_sync[1]) && !active) begin
                row <= request_row; index <= 0; active <= 1;
            end
            if (video_ack) waiting <= 1;
            if (video_rvalid && waiting) begin
                lines[{row[0],index}] <= video_rdata;
                waiting <= 0;
                if (index == 119) begin
                    active <= 0; done_row <= row; done_toggle <= !done_toggle;
                end else index <= index + 1'b1;
            end
        end
    end
    logic [2:0] done_sync;
    logic [7:0] valid_row[0:1];
    logic [1:0] valid_bank;
    logic [1:0] en_sync;
    logic [31:0] pair;
    logic [7:0] display_row;
    logic [1:0] suby;
    logic display_started;
    logic visible_q, high_q;
    // Prefetch one pixel clock ahead: the parent HDMI encoder samples the
    // synchronous line RAM output on the following edge.
    wire [9:0] next_x = cx == 857 ? 10'd0 : cx + 1'b1;
    wire [9:0] next_y = cx == 857 ? (cy == 524 ? 10'd0 : cy + 1'b1) : cy;
    wire [7:0] source_col = 8'(next_x / 10'd3);
    wire [7:0] source_row = 8'(next_y / 10'd3);
    wire [14:0] color = high_q ? pair[30:16] : pair[14:0];
    always_ff @(posedge vclk) begin
        if (vreset) begin
            request_toggle <= 0; request_row <= 0; done_sync <= 0;
            valid_bank <= 0; en_sync <= 0; display_started <= 0;
            display_row <= 0; suby <= 0;
            underrun <= 0; visible_q <= 0; high_q <= 0;
        end else begin
            done_sync <= {done_sync[1:0],done_toggle};
            en_sync <= {en_sync[0],enable};
            if (done_sync[2] ^ done_sync[1]) begin
                valid_row[done_row[0]] <= done_row;
                valid_bank[done_row[0]] <= 1;
            end
            // End of preceding line sets vertical state for the next line.
            if (cx == 857) begin
                if (cy == 524) begin
                    display_row <= 0; suby <= 0;
                    if (valid_bank[0] && valid_row[0] == 0) display_started <= 1;
                end
                else if (cy < 480) begin
                    if (suby == 2) begin display_row <= display_row + 1'b1; suby <= 0; end
                    else suby <= suby + 1'b1;
                end
            end
            if (cx == 730 && en_sync[1]) begin
                if (cy == 520) begin request_row <= 0; request_toggle <= !request_toggle; end
                else if (cy < 480 && suby == 0 && display_row < 159) begin
                    request_row <= display_row + 1'b1; request_toggle <= !request_toggle;
                end
            end
            pair <= lines[{source_row[0],source_col[7:1]}];
            high_q <= source_col[0];
            visible_q <= next_x < 720 && next_y < 480 && en_sync[1] && display_started &&
                         valid_bank[source_row[0]] && valid_row[source_row[0]] == source_row;
            if (cx == 0 && cy < 480 && en_sync[1] && display_started &&
                (!valid_bank[display_row[0]] || valid_row[display_row[0]] != display_row)) underrun <= 1;
        end
    end
    assign rgb = visible_q ? {color[4:0],color[4:2],color[9:5],color[9:7],color[14:10],color[14:12]} : 24'd0;
endmodule
