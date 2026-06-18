`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/28 13:36:18
// Design Name: 
// Module Name: tb_register_8
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


module tb_register_8 ();

    reg clk, rst;
    reg  [7:0] d;
    wire [7:0] q;

    register_8 dut (
        .clk(clk),
        .rst(rst),
        .d(d),
        .q(q)
    );


    always #5 clk = ~clk;


    integer i;

    initial begin

        clk  = 0;
        rst  = 1;
        d = 8'h00;
        #10;
        rst = 0;
        @(posedge clk);
        #1;
        // @(negedge clk);
        for (i = 0; i < 256; i = i + 1) begin
            d = i;
            // @(negedge clk);
            #10;
        end

        @(negedge clk);
        $stop;
    end


endmodule
