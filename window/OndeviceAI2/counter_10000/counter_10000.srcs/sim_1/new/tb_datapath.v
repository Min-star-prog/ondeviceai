`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/09 16:17:32
// Design Name: 
// Module Name: tb_datapath
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


module tb_datapath ();

    reg clk, rst;
    wire [13:0] tick_counter;

    datapath dut (
        .clk(clk),
        .rst(rst),
        .tick_counter(tick_counter)
    );


always #5 clk = ~clk;

initial begin
    
clk = 0;
rst = 1;

#20;

rst = 0;

//500ms delay
#500_000_000;
$stop;

end




endmodule
