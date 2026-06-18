`timescale 1ns / 1ps

interface spi_intf(input logic clk);

    logic rst;
    logic start;

    logic cpol;
    logic cpha;
    logic [7:0] clk_div;

    logic [7:0] master_tx_data;
    logic [7:0] slave_tx_data;

    logic [7:0] master_rx_data;
    logic [7:0] slave_rx_data;

    logic master_busy;
    logic slave_busy;
    logic master_done;
    logic slave_done;

    logic sclk;
    logic mosi;
    logic miso;
    logic ss_n;

endinterface