`timescale 1ns / 1ps

// module adder_fnd (
//     input [7:0] a,
//     b,
//     output [3:0] fnd_com,
//     output [7:0] fnd_data,
//     output led
// );
//
//     wire [7:0] w_sum;
//
//     adder_8bit U_ADDER_8 (
//         .a(a),
//         .b(b),
//         .s(w_sum),
//         .cout(led)
//     );
//
//     fnd_controller U_FND_CTRL (
//         .bin(w_sum[3:0]),
//         .fnd_com(fnd_com),
//         .fnd_data(fnd_data)
//     );
//
// endmodule

// module adder_8bit (
//     input  [7:0] a,
//     input  [7:0] b,
//     output [7:0] s,
//     output       cout
// );
//
//     assign {cout, s} = a + b;
//
// endmodule

module counter_10000 (
    input        clk,
    input        rst,
    input        btn_d,
    input        btn_l,
    input        btn_r,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);

    wire [13:0] w_tick_counter;
    wire        w_btn_d;
    wire        w_btn_l;
    wire        w_btn_r;
    wire        w_run_stop;
    wire        w_clear;
    wire        w_mode;

    button_debounce U_BTN_DEBOUNCE_D (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btn_d),
        .o_btn(w_btn_d)
    );

    button_debounce U_BTN_DEBOUNCE_L (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btn_l),
        .o_btn(w_btn_l)
    );

    button_debounce U_BTN_DEBOUNCE_R (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btn_r),
        .o_btn(w_btn_r)
    );

    control_unit U_CONTROL_UNIT (
        .clk     (clk),
        .rst     (rst),
        .btn_d   (w_btn_d),
        .btn_l   (w_btn_l),
        .btn_r   (w_btn_r),
        .run_stop(w_run_stop),
        .clear   (w_clear),
        .mode    (w_mode)
    );

    datapath U_DATAPATH (
        .clk         (clk),
        .rst         (rst),
        .run_stop    (w_run_stop),
        .clear       (w_clear),
        .mode        (w_mode),
        .tick_counter(w_tick_counter)
    );

    fnd_controller U_FND_CONTROLLER (
        .clk     (clk),
        .rst     (rst),
        .fnd_in  (w_tick_counter),
        .fnd_com (fnd_com),
        .fnd_data(fnd_data)
    );

endmodule

module datapath (
    input         clk,
    input         rst,
    input         run_stop,
    input         clear,
    input         mode,
    output [13:0] tick_counter
);

    wire w_tick_10hz;

    clk_tick_gen_10Hz U_CLK_TICK_GEN_10HZ (
        .clk      (clk),
        .rst      (rst),
        .tick_10hz(w_tick_10hz)
    );

    tick_counter U_TICK_COUNTER (
        .clk         (clk),
        .rst         (rst),
        .i_tick      (w_tick_10hz),
        .i_run_stop  (run_stop),
        .i_clear     (clear),
        .i_mode      (mode),
        .tick_counter(tick_counter)
    );

endmodule

module clk_tick_gen_10Hz (
    input      clk,
    input      rst,
    output reg tick_10hz
);

    reg [23:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter   <= 24'd0;
            tick_10hz <= 1'b0;
        end else if (counter == 24'd9_999_999) begin
            counter   <= 24'd0;
            tick_10hz <= 1'b1;
        end else begin
            counter   <= counter + 1'b1;
            tick_10hz <= 1'b0;
        end
    end

endmodule

module tick_counter (
    input             clk,
    input             rst,
    input             i_tick,
    input             i_run_stop,
    input             i_clear,
    input             i_mode,
    output reg [13:0] tick_counter
);


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tick_counter <= 14'd0;
        end else if (!i_run_stop && i_clear) begin
            tick_counter <= 14'd0;
        end else if (i_tick && i_run_stop) begin
            if (i_mode) begin
                if (tick_counter == 14'd9999) begin
                    tick_counter <= 14'd0;
                end else begin
                    tick_counter <= tick_counter + 1'b1;
                end
            end else begin
                if (tick_counter == 14'd0) begin
                    tick_counter <= 14'd9999;
                end else begin
                    tick_counter <= tick_counter - 1'b1;
                end
            end
        end
    end



endmodule

module fnd_controller (
    input         clk,
    input         rst,
    input  [13:0] fnd_in,
    output [ 3:0] fnd_com,
    output [ 7:0] fnd_data
);

    wire       w_1khz;
    wire [1:0] w_digit_sel;
    wire [3:0] w_out_mux;
    wire [3:0] w_digit_1;
    wire [3:0] w_digit_10;
    wire [3:0] w_digit_100;
    wire [3:0] w_digit_1000;

    digit_spliter U_DIGIT_SPLITTER (
        .digit_in  (fnd_in),
        .digit_1   (w_digit_1),
        .digit_10  (w_digit_10),
        .digit_100 (w_digit_100),
        .digit_1000(w_digit_1000)
    );

    mux_4x1 U_MUX_4X1 (
        .in0    (w_digit_1),
        .in1    (w_digit_10),
        .in2    (w_digit_100),
        .in3    (w_digit_1000),
        .sel    (w_digit_sel),
        .out_mux(w_out_mux)
    );

    clk_div_1khz U_CLK_DIV_1KHZ (
        .clk   (clk),
        .rst   (rst),
        .o_1khz(w_1khz)
    );

    counter4 U_COUNTER4 (
        .clk      (w_1khz),
        .rst      (rst),
        .digit_sel(w_digit_sel)
    );

    decoder_2x4 U_DECODER_2X4 (
        .decoder_in(w_digit_sel),
        .fnd_com   (fnd_com)
    );

    BCD_decoder U_BCD_DECODER (
        .bin     (w_out_mux),
        .bcd_data(fnd_data)
    );

endmodule

module clk_div_1khz (
    input      clk,
    input      rst,
    output reg o_1khz
);

    reg [16:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 17'd0;
            o_1khz  <= 1'b0;
        end else if (counter == 17'd99_999) begin
            counter <= 17'd0;
            o_1khz  <= 1'b1;
        end else begin
            counter <= counter + 1'b1;
            o_1khz  <= 1'b0;
        end
    end

endmodule

module counter4 (
    input            clk,
    input            rst,
    output reg [1:0] digit_sel
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            digit_sel <= 2'd0;
        end else begin
            digit_sel <= digit_sel + 1'b1;
        end
    end

endmodule

module decoder_2x4 (
    input [1:0] decoder_in,
    output reg [3:0] fnd_com
);

    always @(*) begin
        case (decoder_in)
            2'd0: fnd_com = 4'b1110;
            2'd1: fnd_com = 4'b1101;
            2'd2: fnd_com = 4'b1011;
            2'd3: fnd_com = 4'b0111;
            default: fnd_com = 4'b1111;
        endcase
    end

endmodule

module digit_spliter (
    input  [13:0] digit_in,
    output [ 3:0] digit_1,
    output [ 3:0] digit_10,
    output [ 3:0] digit_100,
    output [ 3:0] digit_1000
);

    assign digit_1    = digit_in % 10;
    assign digit_10   = (digit_in / 10) % 10;
    assign digit_100  = (digit_in / 100) % 10;
    assign digit_1000 = (digit_in / 1000) % 10;

endmodule

module mux_4x1 (
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [1:0] sel,
    output reg [3:0] out_mux
);

    always @(*) begin
        case (sel)
            2'b00:   out_mux = in0;
            2'b01:   out_mux = in1;
            2'b10:   out_mux = in2;
            2'b11:   out_mux = in3;
            default: out_mux = 4'h0;
        endcase
    end

endmodule

module BCD_decoder (
    input      [3:0] bin,
    output reg [7:0] bcd_data
);

    always @(*) begin
        case (bin)
            4'd0: bcd_data = 8'hc0;
            4'd1: bcd_data = 8'hf9;
            4'd2: bcd_data = 8'ha4;
            4'd3: bcd_data = 8'hb0;
            4'd4: bcd_data = 8'h99;
            4'd5: bcd_data = 8'h92;
            4'd6: bcd_data = 8'h82;
            4'd7: bcd_data = 8'hf8;
            4'd8: bcd_data = 8'h80;
            4'd9: bcd_data = 8'h90;
            default: bcd_data = 8'hff;
        endcase
    end

endmodule


module control_unit (
    input      clk,
    input      rst,
    input      btn_d,
    input      btn_l,
    input      btn_r,
    output reg run_stop,
    output     clear,
    output reg mode
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            run_stop <= 1'b0;
            mode     <= 1'b1;
        end else begin
            if (btn_r) run_stop <= ~run_stop;
            if (btn_d) mode <= ~mode;
        end
    end

    assign clear = btn_l;

endmodule


module fsm_led (
    input  clk,
    input  rst,
    input  sw,
    output led
);

    parameter state_a = 0, state_b = 1;

    reg current_state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= state_a;

        end else begin
            current_state <= next_state;
        end
    end
    always @(*) begin
        case (current_state)
            state_a: begin
                if (sw) begin
                    next_state = state_b;
                end else begin
                    next_state = current_state;
                end
            end
            state_b: begin
                if (!sw) begin
                    next_state = state_a;
                end else begin
                    next_state = current_state;
                end
            end
        endcase
    end
    assign led = current_state;

endmodule



module button_debounce (
    input  clk,
    input  rst,
    input  i_btn,
    output o_btn
);

    // clock divider
    // 100MHz -> 100 KHz
    parameter F_COUNT = 100_000_000 / 100_000;
    reg [$clog2(F_COUNT)-1:0] r_counter;
    reg clk_100khz;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            r_counter  <= 0;
            clk_100khz <= 1'b0;
        end else begin
            r_counter <= r_counter + 1;

            if (r_counter == F_COUNT - 1) begin
                r_counter  <= 0;
                clk_100khz <= 1'b1;
            end else begin
                clk_100khz <= 1'b0;
            end
        end
    end


    // synchronizer
    reg [7:0] sync_reg, sync_next;
    reg  edge_reg;
    wire debounce;

    always @(posedge clk_100khz, posedge rst) begin
        if (rst) begin
            sync_reg <= 0;
        end else begin
            sync_reg <= sync_next;
        end
    end

    always @(*) begin
        sync_next = {i_btn, sync_reg[7:1]};
    end


    // 8input to 1 output and gate
    assign debounce = &sync_reg;


    // rising edge detector
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            edge_reg <= 1'b0;
        end else begin
            edge_reg <= debounce;
        end
    end

    assign o_btn = debounce & (~edge_reg);

endmodule




module baud_tick_gen (
    input clk,
    input rst,
    output reg baud_tick
);
    parameter f_count = 100_000_000 / (9600 * 16);
    reg [$clog2(f_count)-1:0] cnt_reg;


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt_reg   <= 0;
            baud_tick <= 0;
        end else if (cnt_reg == f_count - 1) begin
            baud_tick <= 1'b1;
            cnt_reg   <= 0;
        end else begin
            baud_tick <= 1'b0;
            cnt_reg   <= cnt_reg + 1;

        end
    end


endmodule


module uart_tx (
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    input b_tick,
    output tx,
    output tx_busy
);

    parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;

    reg [1:0] n_state, c_state;
    reg tx_reg, tx_next;
    reg tx_busy_reg, tx_busy_next;
    reg [7:0] data_reg, data_next;
    reg [2:0] bit_cnt_reg, bit_cnt_next;
    reg [3:0] b_tick_cnt_reg, b_tick_cnt_next;

    assign tx = tx_reg;
    assign tx_busy = tx_busy_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_state        <= IDLE;
            tx_reg         <= 1'b1;
            tx_busy_reg    <= 1'b0;
            data_reg       <= 8'b0;
            bit_cnt_reg    <= 3'b0;
            b_tick_cnt_reg <= 4'b0;
        end else begin
            c_state        <= n_state;
            tx_reg         <= tx_next;
            tx_busy_reg    <= tx_busy_next;
            data_reg       <= data_next;
            bit_cnt_reg    <= bit_cnt_next;
            b_tick_cnt_reg <= b_tick_cnt_next;
        end
    end

    always @(*) begin
        n_state         = c_state;
        tx_next         = tx_reg;
        tx_busy_next    = tx_busy_reg;
        data_next       = data_reg;
        bit_cnt_next    = bit_cnt_reg;
        b_tick_cnt_next = b_tick_cnt_reg;

        case (c_state)
            IDLE: begin
                tx_next      = 1'b1;
                tx_busy_next = 1'b0;

                if (tx_start) begin
                    n_state         = START;
                    tx_busy_next    = 1'b1;
                    data_next       = tx_data;
                    bit_cnt_next    = 0;
                    b_tick_cnt_next = 0;
                end
            end

            START: begin
                tx_next = 1'b0;

                if (b_tick) begin
                    if (b_tick_cnt_reg == 15) begin
                        b_tick_cnt_next = 0;
                        n_state = DATA;
                    end else begin
                        b_tick_cnt_next = b_tick_cnt_reg + 1'b1;
                    end
                end
            end

            DATA: begin
                tx_next = data_reg[bit_cnt_reg];

                if (b_tick) begin
                    if (b_tick_cnt_reg == 15) begin
                        b_tick_cnt_next = 0;

                        if (bit_cnt_reg == 7) begin
                            bit_cnt_next = 0;
                            n_state = STOP;
                        end else begin
                            bit_cnt_next = bit_cnt_reg + 1'b1;
                        end
                    end else begin
                        b_tick_cnt_next = b_tick_cnt_reg + 1'b1;
                    end
                end
            end

            STOP: begin
                tx_next = 1'b1;

                if (b_tick) begin
                    if (b_tick_cnt_reg == 15) begin
                        b_tick_cnt_next = 0;
                        tx_busy_next = 1'b0;
                        n_state = IDLE;
                    end else begin
                        b_tick_cnt_next = b_tick_cnt_reg + 1'b1;
                    end
                end
            end

            default: begin
                n_state         = IDLE;
                tx_next         = 1'b1;
                tx_busy_next    = 1'b0;
                bit_cnt_next    = 0;
                b_tick_cnt_next = 0;
            end
        endcase
    end
endmodule




module uart_rx (
    input clk,
    input rst,
    input b_tick,
    input rx,
    output [7:0] rx_data,
    output rx_done
);

    parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;

    reg [4:0] b_tick_cnt_reg, b_tick_cnt_next;  // oversampling tick count
    reg [3:0] bit_cnt_reg, bit_cnt_next;  // received data bit count
    reg [7:0] data_reg, data_next;
    reg [2:0] c_state, n_state;
    reg [7:0] rx_data_reg, rx_data_next;
    reg rx_done_reg, rx_done_next;

    assign rx_done = rx_done_reg;
    assign rx_data = rx_data_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            b_tick_cnt_reg <= 0;
            bit_cnt_reg <= 0;
            data_reg <= 0;
            c_state <= 0;
            rx_done_reg <= 0;
            rx_data_reg <= 0;

        end else begin
            b_tick_cnt_reg <= b_tick_cnt_next;
            bit_cnt_reg <= bit_cnt_next;
            data_reg <= data_next;
            c_state <= n_state;
            rx_done_reg <= rx_done_next;
            rx_data_reg <= rx_data_next;
        end
    end

    always @(*) begin
        b_tick_cnt_next = b_tick_cnt_reg;
        bit_cnt_next = bit_cnt_reg;
        data_next = data_reg;
        n_state = c_state;
        rx_done_next = 0;
        rx_data_next = rx_data_reg;

        case (c_state)
            IDLE: begin
                if (b_tick) begin
                    if (!rx) begin
                        n_state = START;
                    end
                end
            end
            START: begin
                if (b_tick) begin
                    b_tick_cnt_next = b_tick_cnt_reg + 1;
                    if (b_tick_cnt_reg == 7) begin
                        if (!rx) begin
                            n_state = DATA;
                        end else begin
                            n_state = IDLE;
                        end
                        b_tick_cnt_next = 0;
                    end

                end
            end
            DATA: begin
                if (b_tick) begin
                    if (b_tick_cnt_reg == 15) begin
                        data_next = {rx, data_reg[7:1]};
                        b_tick_cnt_next = 0;
                        if (bit_cnt_reg == 7) begin
                            n_state = STOP;
                            b_tick_cnt_next = 0;
                            bit_cnt_next = 0;
                        end else begin
                            bit_cnt_next = bit_cnt_reg + 1;
                        end
                    end else begin
                        b_tick_cnt_next = b_tick_cnt_reg + 1;
                    end
                end

            end
            STOP: begin
                if (b_tick) begin
                    b_tick_cnt_next = b_tick_cnt_reg + 1;
                    if (b_tick_cnt_reg == 15 && rx == 1) begin
                        n_state = IDLE;
                        rx_done_next = 1;
                        rx_data_next = data_reg;
                    end
                end
            end
        endcase
    end

endmodule



module ram (
    input [7:0] addr,
    input [7:0] wdata,
    input we,
    input clk,
    output [7:0] rdata
);

    reg [7:0] ram[0:255];

    always @(posedge clk) begin
        if (we) begin
            ram[addr] <= wdata;
        end
    end

    assign rdata = ram[addr];

endmodule


module fifo (
    input clk,
    input rst,
    input [7:0] push_data,
    input push,
    input pop,

    output [7:0] pop_data,
    output full,
    output empty
);




    reg [7:0] wptr_reg, wptr_next;
    reg [7:0] rptr_reg, rptr_next;
    reg full_reg, full_next;
    reg empty_reg, empty_next;

    register_file U_REGISTER_FILE(
    .waddr(wptr_reg),
    .raddr(rptr_reg),
    .wdata(push_data),
    .we((!full)&&push),
    .clk(clk),
    .rdata(pop_data)
);

    assign full = full_reg;
    assign empty = empty_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wptr_reg  <= 0;
            rptr_reg  <= 0;
            full_reg  <= 0;
            empty_reg <= 1;
        end else begin
            wptr_reg  <= wptr_next;
            rptr_reg  <= rptr_next;
            full_reg  <= full_next;
            empty_reg <= empty_next;
        end
    end

    always @(*) begin
        wptr_next  = wptr_reg;
        rptr_next  = rptr_reg;
        full_next  = full_reg;
        empty_next = empty_reg;

        case ({
            pop, push
        })
            //
            2'b00: begin

            end
            // push
            2'b01: begin
                if (!full_reg) begin
                    wptr_next  = wptr_reg + 1;
                    empty_next = 0;
                    if (wptr_next == rptr_reg) begin
                        full_next = 1;
                    end
                end
            end
            //pop
            2'b10: begin
                if (!empty_reg) begin
                    rptr_next = rptr_reg + 1;
                    full_next = 0;
                    if (rptr_next == wptr_reg) begin
                        empty_next = 1;
                    end
                end
            end
            //push,pop
            2'b11: begin
                if (empty_reg) begin
                    wptr_next = wptr_reg + 1;
                    empty_next = 0;
                end else if (full_reg) begin
                    rptr_next = rptr_reg + 1;
                    full_next = 0;
                end else begin
                    wptr_next = wptr_reg + 1;
                    rptr_next = rptr_reg + 1;
                end

            end

        endcase
    end


endmodule



module register_file (
    input [7:0] waddr,
    input [7:0] raddr,
    input [7:0] wdata,
    input we,
    input clk,
    output [7:0] rdata
);

    reg [7:0] ram[0:255];

    always @(posedge clk) begin
        if (we) begin
            ram[waddr] <= wdata;
        end
    end

    assign rdata = ram[raddr];

endmodule


module uart_ascii_decoder (
    input  wire       ascii_valid,
    input  wire [7:0] ascii_data,
    output wire       cmd_u,
    output wire       cmd_d,
    output wire       cmd_r,
    output wire       cmd_l,
    output wire       cmd_s
);

    assign cmd_u = ascii_valid && ((ascii_data == "u") || (ascii_data == "U"));
    assign cmd_d = ascii_valid && ((ascii_data == "d") || (ascii_data == "D"));
    assign cmd_r = ascii_valid && ((ascii_data == "r") || (ascii_data == "R"));
    assign cmd_l = ascii_valid && ((ascii_data == "l") || (ascii_data == "L"));
    assign cmd_s = ascii_valid && ((ascii_data == "s") || (ascii_data == "S"));

endmodule


module ascii_sender (
    input  wire        clk,
    input  wire        rst,
    input  wire        send,
    input  wire [13:0] number,
    input  wire        out_ready,
    output reg  [7:0]  out_data,
    output wire        out_valid,
    output reg          busy
);

    reg [13:0] number_latched;
    reg [2:0]  index;

    assign out_valid = busy;

    always @(*) begin
        case (index)
            3'd0: out_data = 8'h30 + ((number_latched / 1000) % 10);
            3'd1: out_data = 8'h30 + ((number_latched / 100)  % 10);
            3'd2: out_data = 8'h30 + ((number_latched / 10)   % 10);
            3'd3: out_data = 8'h30 +  (number_latched         % 10);
            3'd4: out_data = 8'h0d;
            default: out_data = 8'h0a;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            number_latched <= 14'd0;
            index          <= 3'd0;
            busy           <= 1'b0;
        end else if (!busy) begin
            if (send) begin
                number_latched <= number;
                index          <= 3'd0;
                busy           <= 1'b1;
            end
        end else if (out_ready) begin
            if (index == 3'd5) begin
                index <= 3'd0;
                busy  <= 1'b0;
            end else begin
                index <= index + 1'b1;
            end
        end
    end

endmodule


// PC -> UART RX -> RX FIFO -> ASCII decoder -> counter_10000 datapath
//    -> ASCII sender -> TX FIFO -> UART TX -> PC
module uart_counter_top #(
    parameter integer CLK_FREQ  = 100_000_000,
    parameter integer BAUD_RATE = 9_600
) (
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,
    output wire       tx,
    output wire [3:0] fnd_com,
    output wire [7:0] fnd_data
);

    localparam integer BAUD_DIV = CLK_FREQ / (BAUD_RATE * 16);

    wire       baud_tick;
    wire [7:0] uart_rx_data;
    wire       uart_rx_done;
    wire       uart_tx_busy;
    wire [7:0] rx_fifo_data;
    wire       rx_fifo_full;
    wire       rx_fifo_empty;
    wire       rx_fifo_pop;
    wire [7:0] tx_fifo_data;
    wire       tx_fifo_full;
    wire       tx_fifo_empty;
    wire       tx_fifo_pop;
    wire       cmd_u, cmd_d, cmd_r, cmd_l, cmd_s;
    wire       run_stop;
    wire       clear;
    wire       mode;
    wire [13:0] count;
    wire [7:0] sender_data;
    wire       sender_valid;
    wire       sender_busy;
    wire       sender_ready;

    assign rx_fifo_pop  = ~rx_fifo_empty;
    assign sender_ready = ~tx_fifo_full;
    assign tx_fifo_pop  = ~uart_tx_busy;

    baud_tick_gen #(
        .f_count(BAUD_DIV)
    ) U_BAUD_TICK_GEN (
        .clk(clk), .rst(rst), .baud_tick(baud_tick)
    );

    uart_rx U_UART_RX (
        .clk(clk), .rst(rst), .b_tick(baud_tick), .rx(rx),
        .rx_data(uart_rx_data), .rx_done(uart_rx_done)
    );

    fifo U_RX_FIFO (
        .clk(clk), .rst(rst),
        .push_data(uart_rx_data), .push(uart_rx_done),
        .pop(rx_fifo_pop), .pop_data(rx_fifo_data),
        .full(rx_fifo_full), .empty(rx_fifo_empty)
    );

    uart_ascii_decoder U_ASCII_DECODER (
        .ascii_valid(rx_fifo_pop), .ascii_data(rx_fifo_data),
        .cmd_u(cmd_u), .cmd_d(cmd_d), .cmd_r(cmd_r),
        .cmd_l(cmd_l), .cmd_s(cmd_s)
    );

    control_unit U_COUNTER_CONTROL (
        .clk(clk), .rst(rst),
        .btn_d(cmd_d), .btn_l(cmd_l), .btn_r(cmd_r),
        .run_stop(run_stop), .clear(clear), .mode(mode)
    );

    datapath U_COUNTER_DATAPATH (
        .clk(clk), .rst(rst),
        .run_stop(run_stop), .clear(clear), .mode(mode),
        .tick_counter(count)
    );

    fnd_controller U_FND_CONTROLLER (
        .clk(clk), .rst(rst), .fnd_in(count),
        .fnd_com(fnd_com), .fnd_data(fnd_data)
    );

    ascii_sender U_ASCII_SENDER (
        .clk(clk), .rst(rst), .send(cmd_s), .number(count),
        .out_ready(sender_ready), .out_data(sender_data),
        .out_valid(sender_valid), .busy(sender_busy)
    );

    fifo U_TX_FIFO (
        .clk(clk), .rst(rst),
        .push_data(sender_data), .push(sender_valid),
        .pop(tx_fifo_pop), .pop_data(tx_fifo_data),
        .full(tx_fifo_full), .empty(tx_fifo_empty)
    );

    uart_tx U_UART_TX (
        .clk(clk), .rst(rst), .b_tick(baud_tick),
        .tx_start(~tx_fifo_empty), .tx_data(tx_fifo_data),
        .tx(tx), .tx_busy(uart_tx_busy)
    );

endmodule


///// 나중에 센서 2종 연결해보자 //////

