`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/14 14:22:37
// Design Name: 
// Module Name: tb_dut
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


`timescale 1ns / 1ps

module tb_dut;

    // 입력 신호 선언
    reg  clk;
    reg  rst;
    reg  din_bit;

    // 출력 신호 선언
    wire dout_bit;

    // DUT 인스턴스
    seq_det_mealy uut (
        .clk(clk),
        .rst(rst),
        .din_bit(din_bit),
        .dout_bit(dout_bit)
    );

    // 클럭 생성 (예: 10ns 주기)
    always #5 clk = ~clk;

    initial begin
        // 초기값 설정
        clk = 0;
        rst = 1;
        din_bit = 0;

        // 리셋 해제
        #15 rst = 0;

        // 입력 신호 패턴 (예시)
        #5 din_bit = 1;
        #30 din_bit = 0;
        #10 din_bit = 1;
        #20 din_bit = 0;
        #40 din_bit = 1;

        #10 din_bit = 0;
        #30 din_bit = 1;
        #40 din_bit = 0;
        #10 din_bit = 1;

        #10 din_bit = 0;
        #30 din_bit = 1;
        #20 din_bit = 0;

        #100 $finish;
    end

endmodule
