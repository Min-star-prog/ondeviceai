`timescale 1ns / 1ps

module uart (
    input       clk,
    input       rst,       // reset
    input       tx_start,       // tx start
    input       [7:0] tx_data,
    input       rx,
    output      [7:0]rx_data,
    output      rx_done,
    output      tx_busy,        // tx_data from switches
    output      tx
);

   
    wire w_b_tick;

    
    uart_tx U_UART_TX(
        .clk      (clk),
        .rst      (rst),
        .tx_start (tx_start),
        .tx_data  (tx_data),
        .i_b_tick (w_b_tick),
        .tx_busy  (tx_busy),
        .tx       (tx)
    );

    uart_rx U_UART_RX(
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .i_b_tick(w_b_tick),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    baud_tick_gen U_BAUD_TICK_GEN(
        .clk      (clk),
        .rst      (rst),
        .o_b_tick (w_b_tick)
    );

endmodule


//*********************************************************************************************

module uart_tx(
    input        clk,
    input        rst,
    input        tx_start,
    input  [7:0] tx_data,
    input        i_b_tick,
    output       tx_busy,
    output       tx
);

    parameter IDLE    = 0,
              START   = 1,
              BIT_ALL = 2,
              STOP    = 3;

    reg [1:0] c_state, n_state;
    reg       tx_reg, tx_next;
    reg [7:0] data_reg, data_next;
    reg [2:0] bit_count_reg, bit_next_count;
    reg [3:0] b_tick_cnt_reg, b_tick_cnt_next;
    reg       tx_busy_reg, tx_busy_next;

    assign tx      = tx_reg;
    assign tx_busy = tx_busy_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_state        <= IDLE;
            tx_reg         <= 1'b1;
            data_reg       <= 8'h00;
            bit_count_reg  <= 3'b000;
            b_tick_cnt_reg <= 4'h0;
            tx_busy_reg    <= 1'b0;
        end else begin
            c_state        <= n_state;
            tx_reg         <= tx_next;
            data_reg       <= data_next;
            bit_count_reg  <= bit_next_count;
            b_tick_cnt_reg <= b_tick_cnt_next;
            tx_busy_reg    <= tx_busy_next;
        end
    end

    always @(*) begin
        n_state         = c_state;
        tx_next         = tx_reg;
        data_next       = data_reg;
        bit_next_count  = bit_count_reg;
        b_tick_cnt_next = b_tick_cnt_reg;
        tx_busy_next    = tx_busy_reg;

        case (c_state)
            IDLE: begin
                tx_next         = 1'b1;
                tx_busy_next    = 1'b0;
                bit_next_count  = 3'b000;
                b_tick_cnt_next = 4'h0;

                if (tx_start) begin
                    tx_busy_next    = 1'b1;
                    data_next       = tx_data;
                    b_tick_cnt_next = 4'h0;
                    n_state         = START;
                end
            end

            START: begin
                tx_next = 1'b0; // start bit
                if (i_b_tick) begin
                    if (b_tick_cnt_reg == 15) begin
                        b_tick_cnt_next = 0;
                        bit_next_count  = 3'b000;
                        n_state         = BIT_ALL;
                    end else begin
                        b_tick_cnt_next = b_tick_cnt_reg + 1;
                    end
                end
            end

            BIT_ALL: begin
                tx_next = data_reg[bit_count_reg];
                if (i_b_tick) begin
                    if (b_tick_cnt_reg == 15) begin
                        b_tick_cnt_next = 0;
                        if (bit_count_reg == 3'b111) begin
                            n_state = STOP;
                        end else begin
                            bit_next_count = bit_count_reg + 1'b1;
                        end
                    end else begin
                        b_tick_cnt_next = b_tick_cnt_reg + 1;
                    end
                end
            end

            STOP: begin
                tx_next = 1'b1; // stop bit
                if (i_b_tick) begin
                    if (b_tick_cnt_reg == 15) begin
                        b_tick_cnt_next = 0;
                        tx_busy_next    = 1'b0;
                        bit_next_count  = 3'b000;
                        n_state         = IDLE;
                    end else begin
                        b_tick_cnt_next = b_tick_cnt_reg + 1;
                    end
                end
            end

            default: begin
                n_state         = IDLE;
                tx_next         = 1'b1;
                data_next       = 8'h00;
                bit_next_count  = 3'b000;
                b_tick_cnt_next = 4'h0;
                tx_busy_next    = 1'b0;
            end
        endcase
    end

endmodule



//*********************************************************************************************

module baud_tick_gen (      //baud tick * 16
    input  clk,
    input  rst,
    output reg o_b_tick
);

    parameter F_COUNT = 100_000_000 / (9600 * 16);
    parameter WIDTH   = $clog2(F_COUNT);

    reg [WIDTH-1:0] counter_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter_reg <= 0;
            o_b_tick    <= 1'b0;
        end else begin
            if (counter_reg == F_COUNT - 1) begin
                counter_reg <= 0;
                o_b_tick    <= 1'b1;
            end else begin
                counter_reg <= counter_reg + 1'b1;
                o_b_tick    <= 1'b0;
            end
        end
    end

endmodule