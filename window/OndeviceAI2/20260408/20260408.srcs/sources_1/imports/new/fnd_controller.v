`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 15:43:17
// Design Name: 
// Module Name: fnd_controller
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


module fnd_controller (
    input clk,
    input rst,
    input  [7:0] fnd_in,
    // input  [1:0] digit_sel,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);

    wire       w_1khz;
    wire [3:0] w_out_mux;
    wire [3:0] w_digit_1, w_digit_10, w_digit_100, w_digit_1000;

    wire [1:0] w_digit_sel;


    digit_splitter U_DIGIT_SPLIT (

        .digit_in  (fnd_in),
        .digit_1   (w_digit_1),
        .digit_10  (w_digit_10),
        .digit_100 (w_digit_100),
        .digit_1000(w_digit_1000)
    );

    mux_4x1 U_MUX_4x1 (
        .in0    (w_digit_1),     //digit 1
        .in1    (w_digit_10),    //digit 10
        .in2    (w_digit_100),   //digit 100
        .in3    (w_digit_1000),  //digit 1000
        .sel    (w_digit_sel),   // to select digit
        .out_mux(w_out_mux)

    );


    BCD_decoder U_BCD (
        .bin(w_out_mux),
        .bcd_data(fnd_data)
    );

    clk_div_1khz U_CLK_DIV_1KHZ(
        .clk(clk),
        .rst(rst),
        .o_1khz(w_1khz)
    );  


    counter_4 U_COUNTER_4 (
        .clk(w_1khz),
        .rst(rst),
        .digit_sel(w_digit_sel)
    );



    decoder_2x4 U_DECODER_2x4 (
        .decoder_in(w_digit_sel),
        .fnd_com(fnd_com)
    );

endmodule
