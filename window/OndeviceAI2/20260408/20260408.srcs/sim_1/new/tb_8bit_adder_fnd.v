`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/08 19:13:30
// Design Name: 
// Module Name: tb_8bit_adder_fnd
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


module tb_8bit_adder_fnd ();
// module tb_adder_fnd_2 ();

    reg clk, rst;
    reg [7:0] a, b;

    wire [3:0] fnd_com;
    wire [7:0] fnd_data;


    always #5 clk <= ~clk;

    adder_fnd top (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .fnd_com(fnd_com),
        .fnd_data(fnd_data),
        .led(led)
    );

    initial begin
        clk = 0;
        rst = 1;
        a = 8'd0;
        b = 8'd0;

        #20;
        rst = 0;

        #50;
        a = 8'd32;
        b = 8'd84;

        #5_000_000;

        a = 8'd125;
        b = 8'd92;

        #5_000_000;

    $finish;
    end



endmodule








