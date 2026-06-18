`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/13 16:43:39
// Design Name: 
// Module Name: uart_fifo_decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_fifo_decoder (
    input  logic       clk,
    input  logic       rst,
    input  logic       rx,
    output logic       R,
    output logic       L,
    output logic       U,
    output logic       D,
    output logic [1:0] M,
    output logic [1:0] T,
    output logic       S
);

    logic b_tick;
    logic [7:0] w_rx_pop_data, w_rx_push_data;
    logic w_empty;
    baud_tick_gen U_BAUD_TICK_GEN_1 (
        .clk(clk),
        .rst(rst),
        .o_b_tick(b_tick)
    );


    uart_rx U_UART_RX_1 (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .i_b_tick(b_tick),
        .rx_data(w_rx_push_data),
        .rx_done(w_rx_done)
    );


    fifo_sv U_FIFO_RX_1 (
        .clk      (clk),
        .rst      (rst),
        .push_data(w_rx_push_data),
        .push     (w_rx_done),
        .pop      (~w_empty),
        .pop_data (w_rx_pop_data),
        .full     (),
        .empty    (w_empty)
    );


    ascii_decoder U_ASCII_DECODER (
        .clk(clk),
        .rst(rst),
        .ascii_text(w_rx_pop_data),
        .R(R),
        .L(L),
        .U(U),
        .D(D),
        .M(M),
        .T(T),
        .S(S)
    );



endmodule
