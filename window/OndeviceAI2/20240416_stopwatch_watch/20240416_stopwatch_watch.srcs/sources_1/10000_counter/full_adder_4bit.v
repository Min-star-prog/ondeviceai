`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 11:38:37
// Design Name: 
// Module Name: full_adder_4bit
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


module full_adder_4bit(

    input cin,
    input [3:0] a,
    input [3:0] b,

    output [3:0] s,
    output cout
    );

wire [3:0] c;

full_adder FA0( .a(a[0]), .b(b[0]), .cin(cin),   .s(s[0]), .c(c[0])    );
full_adder FA1( .a(a[1]), .b(b[1]), .cin(c[0]),  .s(s[1]), .c(c[1])    );
full_adder FA2( .a(a[2]), .b(b[2]), .cin(c[1]),  .s(s[2]), .c(c[2])    );
full_adder FA3( .a(a[3]), .b(b[3]), .cin(c[2]),  .s(s[3]), .c(cout)    );






endmodule



