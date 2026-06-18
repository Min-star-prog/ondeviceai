`timescale 1ns / 1ps

module i2c_loopback #(
    parameter logic [6:0] SLAVE_ADDR = 7'h40
) (
    input  logic       clk,
    input  logic       rst,

    // master command port
    input  logic       cmd_start,
    input  logic       cmd_write,
    input  logic       cmd_read,
    input  logic       cmd_stop,

    // master data port
    input  logic [7:0] master_tx_data,
    output logic [7:0] master_rx_data,
    input  logic       master_ack_in,
    output logic       master_ack_out,
    output logic       master_busy,
    output logic       master_done,

    // slave data port
    input  logic [7:0] slave_tx_data,
    input  logic       slave_ack_in,
    output logic [7:0] slave_rx_data,
    output logic       slave_rx_valid,
    output logic       slave_ack_out,
    output logic       slave_busy,
    output logic       slave_done,

    // observation port
    output logic       scl,
    inout  wire        sda
);

    // pull-up for open-drain SDA
    pullup (sda);

    // Master
    i2c_master_top u_i2c_master_top (
        .clk       (clk),
        .rst       (rst),

        .cmd_start (cmd_start),
        .cmd_write (cmd_write),
        .cmd_read  (cmd_read),
        .cmd_stop  (cmd_stop),

        .tx_data   (master_tx_data),
        .rx_data   (master_rx_data),
        .ack_in    (master_ack_in),
        .ack_out   (master_ack_out),
        .busy      (master_busy),
        .done      (master_done),

        .scl       (scl),
        .sda       (sda)
    );

    // Slave
    i2c_slave_top #(
        .SLAVE_ADDR(SLAVE_ADDR)
    ) u_i2c_slave_top (
        .clk      (clk),
        .rst    (rst),

        .scl      (scl),
        .tx_data  (slave_tx_data),
        .ack_in   (slave_ack_in),
        .rx_data  (slave_rx_data),
        .rx_valid (slave_rx_valid),
        .ack_out  (slave_ack_out),
        .busy     (slave_busy),
        .done     (slave_done),

        .sda      (sda)
    );

endmodule