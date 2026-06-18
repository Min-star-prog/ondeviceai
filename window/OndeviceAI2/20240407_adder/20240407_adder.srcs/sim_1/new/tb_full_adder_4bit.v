`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 13:21:55
// Design Name: 
// Module Name: tb_full_adder_4bit
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


module tb_full_adder_4bit();
    reg cin;
    reg [3:0] a,b;
    wire cout;
    wire [3:0] s;
    integer i,j;
    
full_adder_4bit dut0(
    .cin(cin),
    .a(a),
    .b(b),
    .s(s),
    .cout(cout)
    );


initial begin
    // init, time control
    cin = 0;
  
    i = 0; j = 0;
    for (i=0; i < 16; i = i+1) begin
        for(j=0; j <16; j = j+1) begin
   
        a = i;
        b = j;
        #1;
        end
    end
    $finish;
    
    
end


endmodule









