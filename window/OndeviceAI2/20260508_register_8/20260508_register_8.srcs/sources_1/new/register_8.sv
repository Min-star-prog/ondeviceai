`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/08 14:06:22
// Design Name: 
// Module Name: register_8
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


module register_8 (
    input  logic       clk,
    input  logic       rst,
    input  logic [7:0] d,
    output logic [7:0] q
);

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end



endmodule
