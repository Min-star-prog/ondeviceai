`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 16:16:20
// Design Name: 
// Module Name: adder_fnd
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


module adder_fnd (
    input        clk,
    input        rst,
    input  [7:0] a,
    input  [7:0] b,
    output [3:0] fnd_com,
    output [7:0] fnd_data,
    output       led
);

    wire [7:0] w_sum;

    fnd_controller U_FND_CTRL (
        .clk      (clk),
        .rst      (rst),
        .fnd_in   (w_sum),
        .fnd_com  (fnd_com),
        .fnd_data (fnd_data)
    );

    adder_8bit U_ADDER_8BIT (
        .a(a),
        .b(b),
        // .cin(1'b0),
        .s(w_sum),
        .cout(led)
    );






endmodule
