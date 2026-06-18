`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/07 10:25:01
// Design Name: 
// Module Name: adder
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


module adder (
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic       mode,  //0: sum, 1:sub
    output logic [7:0] s,
    output logic       c
);


assign {c,s} = mode ? a - b : a + b;


endmodule
