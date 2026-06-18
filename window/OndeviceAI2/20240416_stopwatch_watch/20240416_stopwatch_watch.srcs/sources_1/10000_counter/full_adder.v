`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 10:27:57
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    input a,
    input b,
    input cin,
    output s,
    output c

    );

wire c1,s1,cout;

    half_adder U_HA0 (
        .a(a),
        .b(b),
        .s(s1),
        .c(c1)
        
    );

    half_adder U_HA1 (
        .a(s1),
        .b(cin),
        .s(s),
        .c(cout)
        
    );

assign c = (cout)^(c1);



endmodule
