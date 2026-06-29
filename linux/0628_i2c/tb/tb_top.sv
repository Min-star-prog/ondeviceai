`timescale 1ns/1ps

module tb_top;

    import uvm_pkg::*;
    import i2c_axi_no_slave_pkg::*;

    logic aclk;
    axi_i2c_if vif(aclk);

    // 100 MHz AXI clock. The DUT divider creates a 100 kHz SCL clock.
    initial aclk = 1'b0;
    always #5 aclk = ~aclk;

    i2c_v1_0 #(
        .C_S00_AXI_DATA_WIDTH(32),
        .C_S00_AXI_ADDR_WIDTH(4)
    ) dut (
        .scl              (vif.scl),
        .sda              (vif.sda),
        .intr             (vif.intr),

        .s00_axi_aclk     (aclk),
        .s00_axi_aresetn  (vif.aresetn),

        .s00_axi_awaddr   (vif.awaddr),
        .s00_axi_awprot   (vif.awprot),
        .s00_axi_awvalid  (vif.awvalid),
        .s00_axi_awready  (vif.awready),

        .s00_axi_wdata    (vif.wdata),
        .s00_axi_wstrb    (vif.wstrb),
        .s00_axi_wvalid   (vif.wvalid),
        .s00_axi_wready   (vif.wready),

        .s00_axi_bresp    (vif.bresp),
        .s00_axi_bvalid   (vif.bvalid),
        .s00_axi_bready   (vif.bready),

        .s00_axi_araddr   (vif.araddr),
        .s00_axi_arprot   (vif.arprot),
        .s00_axi_arvalid  (vif.arvalid),
        .s00_axi_arready  (vif.arready),

        .s00_axi_rdata    (vif.rdata),
        .s00_axi_rresp    (vif.rresp),
        .s00_axi_rvalid   (vif.rvalid),
        .s00_axi_rready   (vif.rready)
    );

    initial begin
        vif.aresetn = 1'b0;
        vif.awaddr  = '0;
        vif.awprot  = '0;
        vif.awvalid = 1'b0;
        vif.wdata   = '0;
        vif.wstrb   = '0;
        vif.wvalid  = 1'b0;
        vif.bready  = 1'b0;
        vif.araddr  = '0;
        vif.arprot  = '0;
        vif.arvalid = 1'b0;
        vif.rready  = 1'b0;

        repeat (10) @(posedge aclk);
        vif.aresetn = 1'b1;
    end

`ifdef FSDB
    initial begin
        $fsdbDumpfile("i2c_axi_no_slave_uvm.fsdb");
        $fsdbDumpvars(0, tb_top);
    end
`else
    initial begin
        $dumpfile("i2c_axi_no_slave_uvm.vcd");
        $dumpvars(0, tb_top);
    end
`endif

    initial begin
        uvm_config_db#(virtual axi_i2c_if)::set(null, "*", "vif", vif);
        run_test();
    end

endmodule
