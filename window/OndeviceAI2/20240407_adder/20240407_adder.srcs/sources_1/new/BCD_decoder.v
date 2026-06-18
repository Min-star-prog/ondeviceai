`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 15:41:51
// Design Name: 
// Module Name: BCD_decoder
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


module BCD_decoder(

    input       [3:0] bin,
    output reg  [7:0] bcd_data

    );

always @(bin) begin
    case(bin)
        4'b0000 : bcd_data = 8'hc0;  //1
        4'b0001 : bcd_data = 8'hf9;  //2
        4'b0010 : bcd_data = 8'ha4;  //3
        4'b0011 : bcd_data = 8'hb0;  //4
        4'b0100 : bcd_data = 8'h99;  //5
        4'b0101 : bcd_data = 8'h92;  //6
        4'b0110 : bcd_data = 8'h82;  //7
        4'b0111 : bcd_data = 8'hf8;  //8
          
        4'b1000 : bcd_data = 8'h80;   //9
        4'b1001 : bcd_data = 8'h90;  //a
        4'b1010 : bcd_data = 8'h88;  //b
        4'b1011 : bcd_data = 8'h83;  //c
        4'b1100 : bcd_data = 8'hc6;  //d
        4'b1101 : bcd_data = 8'ha1;  //e
        4'b1110 : bcd_data = 8'h86;  //f
        4'b1111 : bcd_data = 8'h8e;  //g
        default : bcd_data = 8'hff;
    endcase

end

endmodule
