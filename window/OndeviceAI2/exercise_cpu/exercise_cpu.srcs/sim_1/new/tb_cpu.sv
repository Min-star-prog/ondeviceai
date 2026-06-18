`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/15 16:27:26
// Design Name: 
// Module Name: tb_dedicated_cpu
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


module tb_cpu();

    logic       clk;
    logic       rst;
    logic [7:0] out;


cpu dut(
    

    .clk(clk),
    .rst(rst),
    .out(out)
);

always #5 clk = ~ clk;

initial begin
clk = 0;
rst = 1;

@(negedge clk);
@(negedge clk);
rst = 0;
#500;
$stop;
end

endmodule
