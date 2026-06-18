`timescale 1ns / 1ps



module spi_slave (
    //internal signal
    input logic [7:0] tx_data,
    output logic [7:0] rx_data,
    output logic busy,
    output logic done,
    //external signal
    input logic sclk,
    input logic mosi,
    input logic ss_n,
    output logic miso

);


    typedef enum logic [1:0] {
        IDLE = 0,
        DATA,
        STOP
    } spi_state_e;

    spi_state_e state;

    logic [7:0] tx_shift_reg;
    logic [7:0] rx_shift_reg;
    logic [2:0] bit_cnt;

    // MOSI sampling
    always_ff @(posedge sclk or posedge ss_n) begin
        if (ss_n) begin
            state        <= IDLE;
            // tx_shift_reg <= 0;
            rx_shift_reg <= 0;
            // rx_data       <= 0;
            bit_cnt      <= 0;
            busy         <= 0;
            done         <= 0;

        end else begin
            done <= 1'b0;
            case (state)
            //data를 shift_reg에 준비
                IDLE: begin
                    state   <= DATA;
                    bit_cnt <= 0;
                    busy    <= 1'b1;
                    rx_shift_reg <= {7'd0, mosi};
                end
                // reg에서 data를 1개씩 꺼냄
                DATA: begin
                    rx_shift_reg <= {rx_shift_reg[6:0], mosi};
                    if (bit_cnt == 6) begin
                        state   <= STOP;
                        rx_data <= {rx_shift_reg[6:0], mosi};
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                    end
                end
                STOP: begin
                    done  <= 1'b1;
                    busy  <= 1'b0;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    //MISO 송신
    always_ff @(negedge sclk or posedge ss_n or negedge ss_n) begin
        if (ss_n) begin
            tx_shift_reg <= 8'd0;
            miso         <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    miso         <= tx_data[7];
                    tx_shift_reg <= {tx_data[6:0], 1'b0};
                end

                DATA: begin
                    miso         <= tx_shift_reg[7];
                    tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
                end

                default: begin
                    miso <= 1'b1;
                end
            endcase
        end
    end

endmodule
