`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/11 09:55:45
// Design Name: 
// Module Name: ram_ip
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

module ram_ip (
    input              clk,
    input  logic [7:0] addr,
    input  logic [7:0] wdata,
    input  logic       we,
    output logic [7:0] rdata

);

    logic [7:0] ram[0:255];

    always_ff @(posedge clk) begin
        if (we) begin
            ram[addr] <= wdata;
        end
    end

    always_comb begin
            rdata = ram[addr];
    end


//   assign rdata = ram[addr];

endmodule



