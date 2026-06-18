`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/15 10:13:04
// Design Name: 
// Module Name: bus_driver
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



module bus_driver (
    input [7:0] data_A,
    input enA,
    input [7:0] data_B,
    input enB,
    output [7:0] bus_data
);

    // assign bus_data = enA ? data_A : enB ? data_B : 8'hzz;
    
    bufif1 bf1 [7:0] (bus_data, data_A, enA);
    bufif1 bf2 [7:0] (bus_data, data_B, enB);

endmodule

