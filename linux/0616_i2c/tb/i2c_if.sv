`timescale 1ns / 1ps

interface i2c_if(input logic clk);

    logic rst;

    logic cmd_start;
    logic cmd_write;
    logic cmd_read;
    logic cmd_stop;

    logic [7:0] master_tx_data;
    logic [7:0] master_rx_data;
    logic       master_ack_in;
    logic       master_ack_out;
    logic       master_busy;
    logic       master_done;

    logic [7:0] slave_tx_data;
    logic       slave_ack_in;
    logic [7:0] slave_rx_data;
    logic       slave_rx_valid;
    logic       slave_ack_out;
    logic       slave_busy;
    logic       slave_done;

    logic scl;
    wire  sda;

endinterface