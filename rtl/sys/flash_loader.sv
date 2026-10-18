// Loads games from the on-board SPI flash.
//
// Flash layout at GAMES_BASE (written by tools/make_games.py):
//   +0x000  "GBCP"            magic
//   +0x004  count             number of games (max 15)
//   +0x010  entry[i] (32 B):  name[24] (ASCII, zero padded), offset u32 LE (from GAMES_BASE), size u32 LE
//   ROM images follow (4 KB aligned).
//
// After reset the directory is read (names go to the menu), then game 0 is loaded.
// A load streams the ROM into SDRAM (byte address 0) and feeds the same bytes to the
// core's cart_top through the MiSTer-style ioctl interface so it can parse the header.
module flash_loader #(
    parameter [23:0] GAMES_BASE = 24'h200000
) (
    input             clk,
    input             reset,
    input             sdram_ready,

    // SPI flash
    output reg        spi_cs_n,
    output reg        spi_clk,
    output reg        spi_mosi,
    input             spi_miso,

    // directory
    output reg  [3:0] game_count,
    output reg        dir_valid,
    output reg        name_we,
    output reg  [8:0] name_addr,     // {index[3:0], char[4:0]}
    output reg  [7:0] name_data,

    // load control
    input             load_req,      // pulse
    input       [3:0] load_idx,
    output reg  [3:0] cur_game,
    output reg        loading,       // high during a load (hold the core in reset)

    // SDRAM writes
    output reg        ld_req,
    output reg [20:0] ld_addr,
    output reg [31:0] ld_data,
    input             ld_ack,

    // ioctl to cart_top
    output reg        ioctl_wr,
    output reg [24:0] ioctl_addr,
    output reg [15:0] ioctl_dout
);

// ------------------------------------------------------------ SPI byte engine (mode 0, clk/2)
reg  [7:0] sh_out, sh_in;
reg  [3:0] bitn;
reg        spi_busy, spi_phase;
reg        spi_start;
reg  [7:0] spi_tx;
wire [7:0] spi_rx = sh_in;

always @(posedge clk) begin
    if (reset) begin
        spi_busy <= 0;
        spi_clk  <= 0;
    end else if (spi_start && !spi_busy) begin
        spi_busy  <= 1;
        sh_out    <= spi_tx;
        spi_mosi  <= spi_tx[7];
        bitn      <= 0;
        spi_phase <= 0;
    end else if (spi_busy) begin
        spi_phase <= ~spi_phase;
        if (!spi_phase) begin
            spi_clk <= 1;                       // rising edge: sample
            sh_in   <= {sh_in[6:0], spi_miso};
        end else begin
            spi_clk <= 0;                       // falling edge: shift out next bit
            sh_out  <= {sh_out[6:0], 1'b0};
            spi_mosi <= sh_out[6];
            bitn    <= bitn + 1'd1;
            if (bitn == 4'd7) spi_busy <= 0;
        end
    end
end

// ------------------------------------------------------------ main FSM
localparam S_WAIT = 0, S_CMD = 1, S_DIR = 2, S_IDLE = 3, S_ROM = 4, S_FLUSH = 5, S_END = 6;
reg  [2:0] state;
reg  [2:0] cmd_i;
reg [23:0] rd_addr;
reg [23:0] remain;
reg [22:0] pos;               // byte position within the ROM
reg  [9:0] dpos;              // byte position within the directory
reg        want_rom;
reg        wait_byte;
reg  [3:0] pend_idx;
reg        pend_load;
reg [15:0] end_cnt;

// directory tables
reg [23:0] g_off  [0:15];
reg [23:0] g_size [0:15];
reg [31:0] magic;
reg [31:0] fld;

reg [7:0] lo_byte;
reg [23:0] word_acc;

always @(posedge clk) begin
    spi_start <= 0;
    name_we   <= 0;
    ioctl_wr  <= 0;
    if (ld_ack) ld_req <= 0;
    if (load_req) begin pend_load <= 1; pend_idx <= load_idx; end

    if (reset) begin
        state      <= S_WAIT;
        spi_cs_n   <= 1;
        loading    <= 1;
        dir_valid  <= 0;
        game_count <= 0;
        ld_req     <= 0;
        pend_load  <= 1;
`ifdef BOOT_GAME1
        pend_idx   <= 1;      // test builds: start the second game
`else
        pend_idx   <= 0;
`endif
        cur_game   <= 0;
        wait_byte  <= 0;
    end else case (state)
    S_WAIT: if (sdram_ready) begin
        rd_addr  <= GAMES_BASE;
        want_rom <= 0;
        dpos     <= 0;
        state    <= S_CMD;
        cmd_i    <= 0;
    end

    // send READ (0x03) + 24-bit address
    S_CMD: if (!spi_busy && !spi_start) begin
        spi_cs_n <= 0;
        spi_start <= 1;
        case (cmd_i)
            3'd0: spi_tx <= 8'h03;
            3'd1: spi_tx <= rd_addr[23:16];
            3'd2: spi_tx <= rd_addr[15:8];
            3'd3: spi_tx <= rd_addr[7:0];
            default: spi_tx <= 8'h00;
        endcase
        cmd_i <= cmd_i + 1'd1;
        if (cmd_i == 3'd4) begin
            // the dummy transfer above clocks in the first data byte
            wait_byte <= 1;
            state <= want_rom ? S_ROM : S_DIR;
        end
    end

    S_DIR: if (!spi_busy && !spi_start && wait_byte) begin
        // a byte has arrived in spi_rx
        dpos <= dpos + 1'd1;
        if (dpos < 4) magic <= {spi_rx, magic[31:8]};
        if (dpos == 4) game_count <= (spi_rx > 8'd15) ? 4'd15 : spi_rx[3:0];
        if (dpos >= 16) begin
            // entry layout: dpos-16 = {idx[3:0], field[4:0]}
            logic [8:0] e;
            e = dpos[8:0] - 9'd16;
            if (e[4:0] < 5'd24) begin
                name_we   <= 1;
                name_addr <= e;
                name_data <= spi_rx;
            end
            fld <= {spi_rx, fld[31:8]};
            // fld holds the three previous bytes in [31:8]: {b+2, b+1, b+0}
            if (e[4:0] == 5'd27) g_off[e[8:5]]  <= fld[31:8];
            if (e[4:0] == 5'd31) g_size[e[8:5]] <= fld[31:8];
        end
        if (dpos == 10'd511) begin
            spi_cs_n <= 1;
            wait_byte <= 0;
            state <= S_IDLE;
            dir_valid <= 1;
        end else
            spi_start <= 1;    // clock in the next byte (tx 0x00)
        spi_tx <= 8'h00;
    end

    S_IDLE: begin
        if (magic != "PCBG") begin       // little-endian shift of "GBCP"
            game_count <= 0;
            loading    <= 1;             // nothing to run
        end else if (pend_load && game_count != 0) begin
            pend_load <= 0;
            cur_game  <= (pend_idx < game_count) ? pend_idx : 4'd0;
            rd_addr   <= GAMES_BASE + g_off[(pend_idx < game_count) ? pend_idx : 4'd0];
            remain    <= g_size[(pend_idx < game_count) ? pend_idx : 4'd0];
            pos       <= 0;
            loading   <= 1;
            want_rom  <= 1;
            cmd_i     <= 0;
            state     <= S_CMD;
        end else if (!pend_load)
            loading <= 0;
    end

    S_ROM: if (!spi_busy && !spi_start && wait_byte && !ld_req) begin
        // byte in spi_rx belongs to ROM position pos
        pos    <= pos + 1'd1;
        remain <= remain - 1'd1;
        if (!pos[0]) lo_byte <= spi_rx;
        else begin
            ioctl_wr   <= 1;
            ioctl_addr <= {2'b00, pos[22:1], 1'b0};
            ioctl_dout <= {spi_rx, lo_byte};
        end
        case (pos[1:0])
            2'd0: word_acc[7:0]   <= spi_rx;
            2'd1: word_acc[15:8]  <= spi_rx;
            2'd2: word_acc[23:16] <= spi_rx;
            2'd3: begin
                ld_req  <= 1;
                ld_addr <= pos[22:2];
                ld_data <= {spi_rx, word_acc};
            end
        endcase
        if (remain == 24'd1) begin
            spi_cs_n  <= 1;
            wait_byte <= 0;
            state     <= S_FLUSH;
        end else
            spi_start <= 1;
        spi_tx <= 8'h00;
    end

    S_FLUSH: if (!ld_req) begin
        end_cnt <= 0;
        state   <= S_END;
    end

    S_END: begin
        // give cart_top some 4 MHz cycles to finish its download handshake
        end_cnt <= end_cnt + 1'd1;
        if (end_cnt == 16'hFFFF) begin
            loading <= 0;
            state   <= S_IDLE;
        end
    end
    default: state <= S_WAIT;
    endcase
end

endmodule
