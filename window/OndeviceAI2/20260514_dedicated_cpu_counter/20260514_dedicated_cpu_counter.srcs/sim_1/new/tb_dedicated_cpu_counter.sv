`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/14 14:14:48
// Design Name: 
// Module Name: tb_dedicated_cpu_counter
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


module tb_dedicated_cpu_counter ();

    logic       clk;
    logic       rst;
    logic [7:0] out;
    dedicated_cpu_counter dut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        @(negedge clk);
        @(negedge clk);
        rst = 0;

        repeat (12) @(negedge clk);
        $stop;

    end


endmodule
