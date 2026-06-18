`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/06 10:56:45
// Design Name: 
// Module Name: gates
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


module gates(a,b,Y0,Y1,Y2,Y3,Y4,Y5,Y6); //Topmodule
input a,b;
output Y0,Y1,Y2,Y3,Y4,Y5,Y6;


assign Y0 = a&b;    //AND
assign Y1 = ~(a&b); //NAND
assign Y2 = a|b;    //OR, Vertical bar
assign Y3 = ~(a|b); //NOR
assign Y4 = a^b;    //XOR
assign Y5 = ~(a^b); //XNOR
assign Y6 = ~a;     //NOT






endmodule
