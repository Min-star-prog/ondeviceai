`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/11 15:31:16
// Design Name: 
// Module Name: tb_spi_master
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


module tb_spi_master(

    );




logic clk;
logic rst;
logic start;
logic [7:0] clk_div;
logic [7:0] tx_data;
logic tx_busy;
logic [7:0] rx_data;
logic rx_done;
logic sclk;
logic mosi;
logic miso;
logic ss_n;
 
spi_master dut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .clk_div(clk_div),  //sclk 속도 계산용
    .tx_data(tx_data),
    .tx_busy(tx_busy),
    .rx_data(rx_data),
    .rx_done(rx_done),
    .sclk(sclk),
    .mosi(mosi),
    .miso(miso),
    .ss_n(ss_n)
);




endmodule
