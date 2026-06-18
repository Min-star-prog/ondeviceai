`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/19 15:40:49
// Design Name: 
// Module Name: tb_rv32i
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


module tb_rv32i ();


    logic clk, rst;
    top_rv32i_soc dut (.*);

    always #5 clk = ~clk;
    initial begin
        clk = 0;
        rst = 1;

        @(negedge clk);
        @(negedge clk);

        rst = 0;
        repeat(800) @(negedge clk);
        $stop;
    end

endmodule
