`timescale 1ns / 1ps

module tb_top;

    import uvm_pkg::*;
    import spi_pkg::*;

    logic clk;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    spi_intf spi_if(clk);

    spi_loopback dut (
        .clk            (spi_if.clk),
        .rst            (spi_if.rst),

        .start          (spi_if.start),
        .cpol           (spi_if.cpol),
        .cpha           (spi_if.cpha),
        .clk_div        (spi_if.clk_div),

        .master_tx_data (spi_if.master_tx_data),
        .slave_tx_data  (spi_if.slave_tx_data),

        .master_rx_data (spi_if.master_rx_data),
        .slave_rx_data  (spi_if.slave_rx_data),

        .master_busy    (spi_if.master_busy),
        .slave_busy     (spi_if.slave_busy),
        .master_done    (spi_if.master_done),
        .slave_done     (spi_if.slave_done),

        .sclk           (spi_if.sclk),
        .mosi           (spi_if.mosi),
        .miso           (spi_if.miso),
        .ss_n           (spi_if.ss_n)
    );

    initial begin
        uvm_config_db#(virtual spi_intf)::set(
            null,
            "*",
            "spi_vif",
            spi_if
        );

        run_test("spi_basic_test");
    end

    initial begin
        $fsdbDumpfile("wave_spi.fsdb");
        $fsdbDumpvars(0, tb_top);
    end

endmodule