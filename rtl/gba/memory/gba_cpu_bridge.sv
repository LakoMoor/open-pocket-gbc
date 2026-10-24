// SPDX-License-Identifier: GPL-3.0-or-later
// GBATang's cpu_en advances the pipeline BEFORE the newly fetched data is
// visible. Keep the previous response through STEP, publish at its ending edge.
// Serializes simultaneous instruction and data requests without duplicating stores.
module gba_cpu_bridge (
    input logic clk, reset,
    input logic rom_en, ram_cen, ram_wen,
    input logic [31:0] rom_addr, ram_addr, ram_wdata,
    input logic [3:0] ram_be,
    output logic cpu_en,
    output logic [31:0] rom_data, ram_rdata,
    output logic req, we,
    output logic [31:0] addr, wdata,
    output logic [3:0] be,
    input logic done,
    input logic [31:0] rdata
);
    typedef enum logic [2:0] {IDLE, FETCH, DATA, STEP} state_t;
    state_t state;
    logic data_pending, fetch_pending;
    logic [31:0] next_rom, next_ram;
    assign cpu_en = state == STEP && !reset;
    assign req = (state == FETCH || state == DATA) && !reset;
    assign addr = state == FETCH ? rom_addr : ram_addr;
    assign we = state == DATA && ram_wen;
    assign wdata = ram_wdata;
    assign be = state == FETCH ? 4'hf : ram_be;
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            rom_data <= 0; ram_rdata <= 0;
            next_rom <= 0; next_ram <= 0;
            fetch_pending <= 0; data_pending <= 0;
        end else case (state)
            IDLE: begin
                fetch_pending <= rom_en;
                data_pending <= ram_cen;
                if (rom_en) state <= FETCH;
                else if (ram_cen) state <= DATA;
                else state <= STEP;
            end
            FETCH: if (done) begin
                next_rom <= rdata;
                state <= data_pending ? DATA : STEP;
            end
            DATA: if (done) begin next_ram <= rdata; state <= STEP; end
            STEP: begin
                if (fetch_pending) rom_data <= next_rom;
                if (data_pending) ram_rdata <= next_ram;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
endmodule
