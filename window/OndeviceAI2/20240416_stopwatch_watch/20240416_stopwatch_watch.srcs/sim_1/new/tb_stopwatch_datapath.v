`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/16 13:38:17
// Design Name: 
// Module Name: tb_stopwatch_datapath
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



module tb_stopwatch_datapath ();
    parameter SEC_DELAY = 1_000_000,
    MIN_DELAY = 60_000_000,
    MSEC_WIDTH = 7,
    SEC_WIDTH = 6,
    MIN_WIDTH = 6,
    HOUR_WIDTH = 5;


    reg clk, rst, i_runstop, i_clear, i_mode;
    wire [MSEC_WIDTH  -1 : 0] msec;
    wire [ SEC_WIDTH - 1 : 0] sec;
    wire [ MIN_WIDTH - 1 : 0] min;
    wire [  HOUR_WIDTH - 1:0] hour;
    stopwatch_datapath dut (
        .clk(clk),
        .rst(rst),
        .i_runstop(i_runstop),
        .i_clear(i_clear),
        .i_mode(i_mode),
        .msec(msec),
        .sec(sec),
        .min(min),
        .hour(hour)
    );


    always #5 clk = ~clk;


    initial begin
        clk = 0;
        rst = 1;
        i_runstop = 0;
        i_clear = 0;
        i_mode = 0;

        @(negedge clk);
        @(negedge clk);
        @(negedge clk);

        rst = 0;
        i_runstop = 1;
        repeat (10) #(SEC_DELAY);
        i_clear = 1;
        
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        i_clear = 0;
        #(SEC_DELAY);

        i_mode = 1;
        #(MIN_DELAY);



        
        $stop;

    end



endmodule
