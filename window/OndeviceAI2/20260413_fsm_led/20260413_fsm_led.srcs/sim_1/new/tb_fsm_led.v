`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/13 16:16:21
// Design Name: 
// Module Name: tb_fsm_led
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


module tb_fsm_led ();

    reg clk, rst;
    reg  [1:0] sw;
    wire [2:0] led;

    fsm_led dut (
        .clk(clk),
        .rst(rst),
        .sw (sw),
        .led(led)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1'b1;
        //reset
        #20;
        rst = 1'b0;

        // state a -> b
        // sw == 2'b01;
        sw  = 2'b01;
        // wait : next positive clock
        @(posedge clk);
        @(posedge clk);

        // b -> c
        sw = 2'b10;
        @(posedge clk);
        @(posedge clk);

        // c -> a
        sw = 2'b11;
        
        @(posedge clk);
        @(posedge clk);
        $stop;
    end

endmodule
