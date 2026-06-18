`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/14 15:11:14
// Design Name: 
// Module Name: mealy_1010
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


module mealy_1010(
    input  clk,
    input  rst,
    input  din_bit,
    output dout_bit
    );

    reg [1:0] state_reg, next_state;

    // 상태 선언
    parameter s0 = 2'b00;
    parameter s1 = 2'b01;
    parameter s2 = 2'b10;
    parameter s3 = 2'b11;

    // 다음 상태 결정을 위한 always 조합회로
    always @(state_reg or din_bit) begin
        case (state_reg)
            s0:
            if (din_bit == 0) next_state = s0;
            else if (din_bit == 1) next_state = s1;
            else next_state = s0;

            s1:
            if (din_bit == 0) next_state = s2;
            else if (din_bit == 1) next_state = s1;
            else next_state = s0;

            s2:
            if (din_bit == 0) next_state = s0;
            else if (din_bit == 1) next_state = s3;
            else next_state = s0;

            s3:
            if (din_bit == 0) next_state = s0;
            else if (din_bit == 1) next_state = s1;
            else next_state = s0;
            

            default: next_state = s0;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst == 1) 
        state_reg <= s0;
        else 
        state_reg <= next_state;
    end

assign dout_bit = ((state_reg == s3) && (din_bit == 0) ) ? 1 : 0;    
endmodule