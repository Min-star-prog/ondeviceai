`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 16:40:29
// Design Name: 
// Module Name: tb_7segment
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


module tb_7segment ();

    reg [3:0] a, b;
    wire [3:0] fnd_com;
    wire [7:0] fnd_data;
    wire led;
    integer i, j;

    adder_fnd dut3(
        .a(a),
        .b(b),
        .fnd_com(fnd_com),
        .fnd_data(fnd_data),
        .led(led)
    );

    initial begin
        i = 0;
        j = 0;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin

                a = i;
                b = j;
                #1;
            end
        end



    end



endmodule
