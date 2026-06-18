`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 10:47:48
// Design Name: 
// Module Name: tb_adder
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


module tb_adder();

reg a,b,cin; //vector, Stimulus
wire s,c;     //
//instantiation
//dut : design under test
// uut : unit under test

full_adder dut1(
    .a(a),
    .b(b),
    .cin(cin),
    .s(s),
    .c(c)

    );


initial begin
    // init, time control


    a= 0;    b= 0;    cin=0;    #10;
    a= 0;    b= 1;    cin=0;    #10;    
    a= 1;    b= 0;    cin=0;    #10;
    a= 1;    b= 1;    cin=0;    #10;
    
    a= 0;    b= 0;    cin=1;    #10;
    a= 0;    b= 1;    cin=1;    #10;
    a= 1;    b= 0;    cin=1;    #10;
    a= 1;    b= 1;    cin=1;    #10;
    $finish;
    



    
end



endmodule













