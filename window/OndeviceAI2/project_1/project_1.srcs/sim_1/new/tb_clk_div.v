`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/08 16:09:03
// Design Name: 
// Module Name: tb_clk_div
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


module tb_clk_div ();


    reg clk, rst;
    wire o_1khz;

    reg [15:0] cnt;
    // module instance
    clk_div_1khz CLK_DIV_1khz (
        .clk(clk),
        .rst(rst),
        .o_1khz(o_1khz)
    );



    always #5 clk = ~clk;  //per 10ns-> 100MHz
    always @(posedge clk) begin
        if (rst) begin
            cnt <= 16'd0;
        end else begin
            cnt = cnt + 1;
            if (cnt == 50000) begin
                cnt <= 16'd0;
            end
        end
    end


    initial begin
        clk = 0;
        rst = 1;

        #20;
        rst = 0;
    end




endmodule
