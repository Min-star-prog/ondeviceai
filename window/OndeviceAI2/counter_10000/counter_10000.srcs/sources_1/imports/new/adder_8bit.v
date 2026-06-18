`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/08 09:40:55
// Design Name: 
// Module Name: adder_8bit
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


module adder_8bit(
input [7:0] a,
input [7:0] b,
// input cin,
output [7:0] s,
output cout
    );

wire w_c0;
full_adder_4bit FA4bit_0(

    .cin(1'b0),
    .a(a[3:0]),
    .b(b[3:0]),
    .s(s[3:0]),
    .cout(w_c0)
    );

full_adder_4bit FA4bit_1(

    .cin(w_c0),
    .a(a[7:4]),
    .b(b[7:4]),
    .s(s[7:4]),
    .cout(cout)
    );



endmodule
