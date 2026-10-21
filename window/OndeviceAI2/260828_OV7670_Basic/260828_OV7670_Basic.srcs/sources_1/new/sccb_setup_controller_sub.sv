
`timescale 1ns / 1ps


module sccb_setup_controller_sub ();











endmodule


module i2c_master (
    input logic clk,
    input logic rst,
    input logic start,
    input logic [7:0] reg_addr,
    input logic [7:0] write_data,
    output logic busy,
    output logic done,
    output logic ack_error,
    output logic scl,
    inout logic sda
);

    localparam OV7670_ADDR = 8'h42;


    logic sda_i, sda_o;
    logic [3:0] bit_cnt, bit_cnt_reg;
    logic [7:0] div_cnt;
    logic       qtr_tick;
    logic       scl_reg;
    logic       sda_reg;
    logic [1:0] step;
    logic ack_out;
    logic [7:0] write_data_reg;
    logic [1:0] byte_cnt;
    assign sda_i = sda;
    assign sda   = sda_o ? 1'b0 : 1'bz;

    assign scl = scl_reg;
    assign sda_o = sda_reg;

    typedef enum logic [3:0] {
        IDLE = 4'b000,
        START,
        DATA,
        ACK,
        STOP,
        DONE
    } i2c_state_e;
    i2c_state_e c_state, n_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            div_cnt  <= 0;
            qtr_tick <= 1'b0;
        end else begin
            if (div_cnt == 250 - 1) begin
                div_cnt  <= 0;
                qtr_tick <= 1'b1;
            end else begin
                div_cnt  <= div_cnt + 1;
                qtr_tick <= 1'b0;
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_state <= IDLE;

        end else begin
            c_state <= n_state;
        end
    end

    always_comb begin
            n_state = c_state;
        case (c_state)
            IDLE: begin
                scl_reg = 1'b1;
                sda_reg = 1'b1;
                if(start) begin
                    n_state = START;
                end
            end
            START : begin
                    if (qtr_tick) begin
                        case (step)
                            2'd0: begin
                                sda_reg = 1'b1;
                                scl_reg = 1'b1;
                                step  = 2'd1;
                            end
                            2'd1: begin
                                sda_reg = 1'b0;
                                scl_reg = 1'b1;
                                step  = 2'd2;
                            end
                            2'd2: begin
                                sda_reg = 1'b0;
                                scl_reg = 1'b0;
                                step  = 2'd3;
                            end
                            2'd3: begin
                                sda_reg = 1'b0;
                                scl_reg = 1'b0;
                                step  = 2'd0;
                                done  = 1'b1;
                                n_state = DATA;
                            end
                        endcase
                    end
                end
                DATA: begin     //0x42
                    if (qtr_tick) begin
                        case (step)
                            2'd0: begin
                                step  = 2'd1;
                                scl_reg = 1'b0;
                                sda_reg = write_data_reg[7];
                            end
                            2'd1: begin
                                step  = 2'd2;
                                scl_reg = 1'b1;
                            end
                            2'd2: begin
                                step  = 2'd3;
                                scl_reg = 1'b1;
                            end
                            2'd3: begin
                                step  = 2'd0;
                                scl_reg = 1'b0;
                                    write_data_reg = {write_data_reg[6:0], 1'b0};
                                if (bit_cnt == 7) begin
                                    n_state = ACK;
                                end else begin
                                    bit_cnt = bit_cnt + 1;
                                end
                            end
                        endcase
                    end
                end
                ACK : begin
                    if (qtr_tick) begin
                        case (step)
                            2'd0: begin
                                step  = 2'd1;
                                scl_reg = 1'b0;
                                sda_reg = 1'b1;
                            end
                            2'd1: begin
                                step  = 2'd2;
                                scl_reg = 1'b1;
                            end
                            2'd2: begin
                                step  = 2'd3;
                                scl_reg = 1'b1;
                                ack_out = sda_i;
                            end
                            2'd3: begin
                                step  = 2'd0;
                                scl_reg = 1'b0;
                                done  = 1'b1;
                                byte_cnt = byte_cnt + 3;
                                if(byte_cnt==2) begin
                                n_state = STOP;
                                end else begin
                                n_state = DATA;
                            end
                            end
                        endcase
                    end
                end
                STOP : begin
                    if (qtr_tick) begin
                        case (step)
                            2'd0: begin
                                sda_reg <= 1'b0;
                                scl_reg <= 1'b0;
                                step  <= 2'd1;
                            end
                            2'd1: begin
                                sda_reg <= 1'b0;
                                scl_reg <= 1'b1;
                                step  <= 2'd2;
                            end
                            2'd2: begin
                                sda_reg <= 1'b1;
                                scl_reg <= 1'b1;
                                step  <= 2'd3;
                            end
                            2'd3: begin
                                sda_reg <= 1'b1;
                                scl_reg <= 1'b1;
                                done <= 1'b1;
                                step  <= 2'd0;
                                n_state <= IDLE;
                            end
                        endcase
                    end
                end

        endcase

    end

endmodule



module OV7670_setup_fsm ();





endmodule
