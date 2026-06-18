`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/08 09:50:15
// Design Name: 
// Module Name: tb_adder_8bit
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


module tb_adder_8bit(
    );
reg [7:0] a,b;
wire [7:0] s;
wire cout;
integer i,j;

adder_8bit dut_8bit(
     .a(a),
     .b(b),
     .s(s),
     .cout(cout)
    );

    initial begin
        i = 0;
        j = 0;
        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 256; j = j + 1) begin

                a = i;
                b = j;
                #1;
            end
        end



    end



endmodule
