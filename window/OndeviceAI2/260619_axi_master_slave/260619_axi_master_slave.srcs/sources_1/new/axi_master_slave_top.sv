`timescale 1ns / 1ps

module axi_master_slave_top (
    input  logic        ACLK,
    input  logic        ARESETn,

    // 사용자 또는 Testbench가 Master에 전달하는 제어 신호
    input  logic        transfer,
    output logic        ready,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata,
    input  logic        write
);

    // ------------------------------------------------------------
    // Master <-> Slave 사이의 AXI4-Lite 연결 신호
    // ------------------------------------------------------------

    // Write Address Channel
    logic [31:0] awaddr;
    logic        awvalid;
    logic        awready;

    // Write Data Channel
    logic [31:0] wdata_axi;
    logic        wvalid;
    logic        wready;

    // Write Response Channel
    logic [1:0]  bresp;
    logic        bvalid;
    logic        bready;

    // Read Address Channel
    logic [31:0] araddr;
    logic        arvalid;
    logic        arready;

    // Read Data Channel
    logic [31:0] rdata_axi;
    logic [1:0]  rresp;
    logic        rvalid;
    logic        rready;

    // ------------------------------------------------------------
    // AXI Master Instance
    // ------------------------------------------------------------
    axi_master u_axi_master (
        .ACLK       (ACLK),
        .ARESETn    (ARESETn),

        .transfer   (transfer),
        .ready      (ready),
        .addr       (addr),
        .wdata      (wdata),
        .rdata      (rdata),
        .write      (write),

        // AW Channel
        .AWADDR     (awaddr),
        .AWVALID    (awvalid),
        .AWREADY    (awready),

        // W Channel
        .WDATA      (wdata_axi),
        .WVALID     (wvalid),
        .WREADY     (wready),

        // B Channel
        .BRESP      (bresp),
        .BVALID     (bvalid),
        .BREADY     (bready),

        // AR Channel
        .ARADDR     (araddr),
        .ARVALID    (arvalid),
        .ARREADY    (arready),

        // R Channel
        .RDATA      (rdata_axi),
        .RVALID     (rvalid),
        .RREADY     (rready),
        .RRESP      (rresp)
    );

    // ------------------------------------------------------------
    // AXI4-Lite Slave IP Instance
    // ------------------------------------------------------------
    myip_v1_0_S00_AXI #(
        .C_S_AXI_DATA_WIDTH (32),
        .C_S_AXI_ADDR_WIDTH (4)
    ) u_axi_slave (
        .S_AXI_ACLK     (ACLK),
        .S_AXI_ARESETN  (ARESETn),

        // Write Address Channel
        // Slave 주소 폭이 4bit이므로 Master 주소의 하위 4bit만 사용
        .S_AXI_AWADDR   (awaddr[3:0]),
        .S_AXI_AWPROT   (3'b000),
        .S_AXI_AWVALID  (awvalid),
        .S_AXI_AWREADY  (awready),

        // Write Data Channel
        .S_AXI_WDATA    (wdata_axi),
        .S_AXI_WSTRB    (4'b1111),   // 32bit 전체 Write
        .S_AXI_WVALID   (wvalid),
        .S_AXI_WREADY   (wready),

        // Write Response Channel
        .S_AXI_BRESP    (bresp),
        .S_AXI_BVALID   (bvalid),
        .S_AXI_BREADY   (bready),

        // Read Address Channel
        .S_AXI_ARADDR   (araddr[3:0]),
        .S_AXI_ARPROT   (3'b000),
        .S_AXI_ARVALID  (arvalid),
        .S_AXI_ARREADY  (arready),

        // Read Data Channel
        .S_AXI_RDATA    (rdata_axi),
        .S_AXI_RRESP    (rresp),
        .S_AXI_RVALID   (rvalid),
        .S_AXI_RREADY   (rready)
    );

endmodule