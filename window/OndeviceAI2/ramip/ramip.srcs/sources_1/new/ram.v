`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/28 14:33:23
// Design Name: 
// Module Name: ram
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


module ram (
    input [3:0] addr,
    input [7:0] wdata,
    input we,
    input clk,
    output [7:0] rdata
);
    reg [7:0] ram[0:15];  // [0:15] = addr



    always @(posedge clk) begin

        if (we) begin

            ram[addr] <= wdata;

        end 
        // else begin
        //     rdata_reg <= ram[addr];

        // end

    end
// CL output
assign rdata = ram[addr];

endmodule
