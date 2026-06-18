`timescale 1ns / 1ps

module spi_loopback (
    input  logic       clk,
    input  logic       rst,

    // master control
    input  logic       start,
    input  logic       cpol,
    input  logic       cpha,
    input  logic [7:0] clk_div,

    // transfer data
    input  logic [7:0] master_tx_data,
    input  logic [7:0] slave_tx_data,

    // monitor outputs
    output logic [7:0] master_rx_data,
    output logic [7:0] slave_rx_data,
    output logic       master_busy,
    output logic       slave_busy,
    output logic       master_done,
    output logic       slave_done,

    // SPI lines for logic analyzer
    output logic       sclk,
    output logic       mosi,
    output logic       miso,
    output logic       ss_n
);

    spi_master u_spi_master (
        .clk     (clk),
        .rst     (rst),
        .start   (start),
        .cpol    (cpol),
        .cpha    (cpha),
        .clk_div (clk_div),
        .tx_data (master_tx_data),

        .busy    (master_busy),
        .rx_data (master_rx_data),
        .done    (master_done),

        .sclk    (sclk),
        .mosi    (mosi),
        .miso    (miso),
        .ss_n    (ss_n)
    );

    spi_slave u_spi_slave (
        .tx_data (slave_tx_data),
        .rx_data (slave_rx_data),
        .busy    (slave_busy),
        .done    (slave_done),

        .sclk    (sclk),
        .mosi    (mosi),
        .ss_n    (ss_n),
        .miso    (miso)
    );

endmodule