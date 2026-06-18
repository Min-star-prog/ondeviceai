`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/28 13:26:07
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
    input clk,
    input rst,
    input [7:0] data,
    output [7:0] q
);
    reg [7:0] q_reg;
    
    assign q = q_reg;

    always @(posedge clk,posedge rst) begin

        if (rst) begin
            q_reg <= 8'h00;

        end else begin
            q_reg <= data;

        end




    end




endmodule
