`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/08 15:26:48
// Design Name: 
// Module Name: clk_div_1khz
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


module clk_div_1khz (
    input  clk,
    input  rst,
    output o_1khz
);


    reg [15:0] counter_reg;
    reg o_1khz_reg;

    assign o_1khz = o_1khz_reg;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            counter_reg <= 16'd0;
            o_1khz_reg  <= 1'b0;  //
        end else begin
            counter_reg <= counter_reg + 1;
            if (counter_reg == (50_000 - 1)) begin
                counter_reg <= 16'd0;
                o_1khz_reg <= ~o_1khz_reg;
            end
        end
    end

endmodule
