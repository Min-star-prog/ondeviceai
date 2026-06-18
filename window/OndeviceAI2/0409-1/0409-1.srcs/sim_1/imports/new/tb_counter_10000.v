`timescale 1ns / 10ps
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


module tb_counter_10000 ();

    reg clk, rst, btnL, btnD, btnR;
    wire [3:0] fnd_com;
    wire [7:0] fnd_data;

    counter_10000 DUTT (
        .clk(clk),
        .rst(rst),
        .btnL(btnL),
        .btnD(btnD),
        .btnR(btnR),
        .fnd_com(fnd_com),
        .fnd_data(fnd_data)
    );


    always #5 clk = ~clk;

    initial begin
        clk  = 0;
        rst  = 1;
        btnL = 0;
        btnD = 0;
        btnR = 0;
        #20;
        rst = 0;
        // 300ms delay / Mode 1 STOP
        #410_000_000;
        btnR = 1;
        #90_000;
        btnR = 0;
        // Mode 2 RUN
        #410_000_000;
        btnR = 1;
        #90_000;
        btnR = 0;
        // Mode 3 clear
        #410_000_000;
        btnL = 1;
        #90_000;
        btnL = 0;
        #410_000_000;
        btnD = 1;
        #90_000;
        btnD = 0;
        #410_000_000;
        btnR = 1;
        #510_000_000;

        $stop;

    end
endmodule
