`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/15 09:35:12
// Design Name: 
// Module Name: mux4x1
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


module mux4x1 (
    input  [3:0] a, b, c, d,
    input  [1:0] sel,
    output reg [3:0] mux_out
);

    always @(*) begin
        mux_out = 4'b0000;
        if (sel == 2'b00) mux_out = a;
        if (sel == 2'b01) mux_out = b;
        if (sel == 2'b10) mux_out = c;
        if (sel == 2'b11) mux_out = d;
    end

endmodule
