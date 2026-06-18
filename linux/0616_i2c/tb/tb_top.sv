`timescale 1ns / 1ps

`include "uvm_macros.svh"
import uvm_pkg::*;
import i2c_pkg::*;

module tb_top;

    logic clk;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    i2c_if i2c_vif(clk);

    i2c_loopback #(
        .SLAVE_ADDR(7'h40)
    ) dut (
        .clk             (i2c_vif.clk),
        .rst             (i2c_vif.rst),

        .cmd_start       (i2c_vif.cmd_start),
        .cmd_write       (i2c_vif.cmd_write),
        .cmd_read        (i2c_vif.cmd_read),
        .cmd_stop        (i2c_vif.cmd_stop),

        .master_tx_data  (i2c_vif.master_tx_data),
        .master_rx_data  (i2c_vif.master_rx_data),
        .master_ack_in   (i2c_vif.master_ack_in),
        .master_ack_out  (i2c_vif.master_ack_out),
        .master_busy     (i2c_vif.master_busy),
        .master_done     (i2c_vif.master_done),

        .slave_tx_data   (i2c_vif.slave_tx_data),
        .slave_ack_in    (i2c_vif.slave_ack_in),
        .slave_rx_data   (i2c_vif.slave_rx_data),
        .slave_rx_valid  (i2c_vif.slave_rx_valid),
        .slave_ack_out   (i2c_vif.slave_ack_out),
        .slave_busy      (i2c_vif.slave_busy),
        .slave_done      (i2c_vif.slave_done),

        .scl             (i2c_vif.scl),
        .sda             (i2c_vif.sda)
    );

    initial begin
        uvm_config_db#(virtual i2c_if)::set(null, "*", "i2c_vif", i2c_vif);
        run_test("i2c_test");
    end

    initial begin
        $fsdbDumpfile("wave_i2c.fsdb");
        $fsdbDumpvars(0, tb_top);
    end

endmodule