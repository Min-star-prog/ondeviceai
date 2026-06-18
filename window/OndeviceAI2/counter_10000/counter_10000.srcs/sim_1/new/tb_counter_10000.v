`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/09 17:20:53
// Design Name: 
// Module Name: tb_counter_10000
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


module tb_counter_10000(    );


reg clk,rst;
wire [3:0] fnd_com;
wire [7:0] fnd_data;


counter_10000 U_dut(
    .clk(clk),
    .rst(rst),
    .fnd_com(fnd_com),
    .fnd_data(fnd_data)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;

    #20;
    rst = 0;

    // 500ms delay
    #500_000_000;
    $stop;

end
endmodule
