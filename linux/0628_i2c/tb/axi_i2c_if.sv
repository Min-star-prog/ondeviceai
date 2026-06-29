`timescale 1ns/1ps

// AXI4-Lite signals and the external I2C pins of the DUT.
// SDA is tri1, so with no slave connected it remains released-high.
interface axi_i2c_if(input logic aclk);

    logic aresetn;

    // AXI4-Lite write address channel
    logic [3:0]  awaddr;
    logic [2:0]  awprot;
    logic        awvalid;
    logic        awready;

    // AXI4-Lite write data channel
    logic [31:0] wdata;
    logic [3:0]  wstrb;
    logic        wvalid;
    logic        wready;

    // AXI4-Lite write response channel
    logic [1:0]  bresp;
    logic        bvalid;
    logic        bready;

    // AXI4-Lite read address channel
    logic [3:0]  araddr;
    logic [2:0]  arprot;
    logic        arvalid;
    logic        arready;

    // AXI4-Lite read data channel
    logic [31:0] rdata;
    logic [1:0]  rresp;
    logic        rvalid;
    logic        rready;

    // DUT I2C pins. No slave BFM is connected in this testbench.
    logic scl;
    tri1  sda;
    logic intr;

    clocking mon_cb @(posedge aclk);
        default input #1step;
        input aresetn;
        input awaddr, awvalid, awready;
        input wdata, wstrb, wvalid, wready;
        input bresp, bvalid, bready;
        input araddr, arvalid, arready;
        input rdata, rresp, rvalid, rready;
        input intr;
    endclocking

endinterface
