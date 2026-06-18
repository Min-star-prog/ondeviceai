`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/13 09:46:53
// Design Name: 
// Module Name: tb_practice1
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

//blocking & non-blocking
module tb_practice1 ();


    reg a, b;
    wire y;

    initial begin
        //blocking -> a = 0, b = 0
        a = 0;
        b = 1;
        b = a;
        a = b;
        $display("blocking : a = %d, b = %d", a, b);

        
        //non-blocking -> a = 1, b = 0
        a = 0;
        b = 1;
        #1;
        b <= a;
        a <= b;
        #1;
        $display("non-blocking : a = %d, b = %d", a, b);
    end



endmodule
