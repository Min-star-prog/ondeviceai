`timescale 1 ns / 1 ps

// ============================================================
// AXI4-Lite Register Block for I2C Master
//
// Register Map
//
// 0x00 : CR (Control Register)
//   [0]  CMD_START      : write 1 -> START command pulse
//   [1]  CMD_WRITE      : write 1 -> WRITE command pulse
//   [2]  CMD_READ       : write 1 -> READ command pulse
//   [3]  CMD_STOP       : write 1 -> STOP command pulse
//
//   [8]  ACK_IN
//          0 = ACK  : read 후 다음 byte도 계속 읽음
//          1 = NACK : 이번 read byte가 마지막
//
//   [16] IRQ_CLEAR      : write 1 -> interrupt pending clear
//   [17] IRQ_EN_SET     : write 1 -> interrupt enable
//   [18] IRQ_EN_CLR     : write 1 -> interrupt disable
//
// 0x04 : TDR (Transmit Data Register)
//   [7:0] TX_DATA
//
// 0x08 : RDR (Receive Data Register)
//   [7:0] RX_DATA
//
// 0x0C : SR (Status Register, Read Only)
//   [0] busy
//   [1] done_flag
//   [2] ack_out
//   [3] rx_valid_flag
//   [4] irq_pending
//   [5] irq_enable
// ============================================================

module i2c_v1_0_S00_AXI #
(
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    parameter integer C_S_AXI_ADDR_WIDTH = 4
)
(
    // --------------------------------------------------------
    // I2C Master interface
    // --------------------------------------------------------
    output wire       cmd_start,
    output wire       cmd_write,
    output wire       cmd_read,
    output wire       cmd_stop,

    output wire [7:0] tx_data,
    input  wire [7:0] rx_data,

    output wire       ack_in,
    input  wire       ack_out,

    input  wire       busy,
    input  wire       done,

    output wire       intr,

    // --------------------------------------------------------
    // AXI4-Lite interface
    // --------------------------------------------------------
    input  wire  S_AXI_ACLK,
    input  wire  S_AXI_ARESETN,

    input  wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
    input  wire [2 : 0] S_AXI_AWPROT,
    input  wire  S_AXI_AWVALID,
    output wire  S_AXI_AWREADY,

    input  wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
    input  wire  S_AXI_WVALID,
    output wire  S_AXI_WREADY,

    output wire [1 : 0] S_AXI_BRESP,
    output wire  S_AXI_BVALID,
    input  wire  S_AXI_BREADY,

    input  wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
    input  wire [2 : 0] S_AXI_ARPROT,
    input  wire  S_AXI_ARVALID,
    output wire  S_AXI_ARREADY,

    output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
    output wire [1 : 0] S_AXI_RRESP,
    output wire  S_AXI_RVALID,
    input  wire  S_AXI_RREADY
);

    // --------------------------------------------------------
    // AXI internal registers
    // --------------------------------------------------------
    reg [C_S_AXI_ADDR_WIDTH-1 : 0] axi_awaddr;
    reg                            axi_awready;
    reg                            axi_wready;
    reg [1 : 0]                    axi_bresp;
    reg                            axi_bvalid;

    reg [C_S_AXI_ADDR_WIDTH-1 : 0] axi_araddr;
    reg                            axi_arready;
    reg [C_S_AXI_DATA_WIDTH-1 : 0] axi_rdata;
    reg [1 : 0]                    axi_rresp;
    reg                            axi_rvalid;

    reg                            aw_en;

    localparam integer ADDR_LSB          = (C_S_AXI_DATA_WIDTH / 32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 1;

    wire [1:0] wr_addr;
    wire [1:0] rd_addr;

    wire slv_reg_wren;
    wire slv_reg_rden;

    assign wr_addr =
        axi_awaddr[ADDR_LSB + OPT_MEM_ADDR_BITS : ADDR_LSB];

    assign rd_addr =
        axi_araddr[ADDR_LSB + OPT_MEM_ADDR_BITS : ADDR_LSB];

    // --------------------------------------------------------
    // I2C control/status registers
    // --------------------------------------------------------
    reg       cmd_start_reg;
    reg       cmd_write_reg;
    reg       cmd_read_reg;
    reg       cmd_stop_reg;

    reg [7:0] tx_data_reg;
    reg [7:0] rx_data_reg;

    reg       ack_in_reg;

    reg       done_flag;
    reg       rx_valid_flag;
    reg       read_inflight;

    reg       irq_pending_reg;
    reg       irq_enable_reg;

    reg [C_S_AXI_DATA_WIDTH-1 : 0] reg_data_out;

    // --------------------------------------------------------
    // AXI output assignments
    // --------------------------------------------------------
    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY  = axi_wready;
    assign S_AXI_BRESP   = axi_bresp;
    assign S_AXI_BVALID  = axi_bvalid;

    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RDATA   = axi_rdata;
    assign S_AXI_RRESP   = axi_rresp;
    assign S_AXI_RVALID  = axi_rvalid;

    // --------------------------------------------------------
    // I2C output assignments
    // --------------------------------------------------------
    assign cmd_start = cmd_start_reg;
    assign cmd_write = cmd_write_reg;
    assign cmd_read  = cmd_read_reg;
    assign cmd_stop  = cmd_stop_reg;

    assign tx_data = tx_data_reg;
    assign ack_in  = ack_in_reg;

    // done 발생 후 irq_pending_reg가 1로 유지됨
    assign intr = irq_enable_reg && irq_pending_reg;

    // --------------------------------------------------------
    // Write / Read event decode
    // --------------------------------------------------------
    assign slv_reg_wren =
        axi_awready && S_AXI_AWVALID &&
        axi_wready  && S_AXI_WVALID;

    assign slv_reg_rden =
        axi_arready && S_AXI_ARVALID && !axi_rvalid;

    wire cr_write;
    wire tdr_write;
    wire rdr_read;

    assign cr_write  = slv_reg_wren && (wr_addr == 2'd0);
    assign tdr_write = slv_reg_wren && (wr_addr == 2'd1);
    assign rdr_read  = slv_reg_rden && (rd_addr == 2'd2);

    wire cmd_request;
    wire irq_clear_request;
    wire irq_enable_set_request;
    wire irq_enable_clr_request;

    assign cmd_request =
        cr_write &&
        S_AXI_WSTRB[0] &&
        (|S_AXI_WDATA[3:0]);

    assign irq_clear_request =
        cr_write &&
        S_AXI_WSTRB[2] &&
        S_AXI_WDATA[16];

    assign irq_enable_set_request =
        cr_write &&
        S_AXI_WSTRB[2] &&
        S_AXI_WDATA[17];

    assign irq_enable_clr_request =
        cr_write &&
        S_AXI_WSTRB[2] &&
        S_AXI_WDATA[18];

    // ============================================================
    // AXI Write Address Channel
    // ============================================================
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_awready <= 1'b0;
            aw_en       <= 1'b1;
        end else begin
            if (!axi_awready &&
                S_AXI_AWVALID &&
                S_AXI_WVALID &&
                aw_en) begin

                axi_awready <= 1'b1;
                aw_en       <= 1'b0;

            end else if (axi_bvalid && S_AXI_BREADY) begin

                axi_awready <= 1'b0;
                aw_en       <= 1'b1;

            end else begin
                axi_awready <= 1'b0;
            end
        end
    end

    // ============================================================
    // AXI Write Address Latch
    // ============================================================
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_awaddr <= {C_S_AXI_ADDR_WIDTH{1'b0}};
        end else begin
            if (!axi_awready &&
                S_AXI_AWVALID &&
                S_AXI_WVALID &&
                aw_en) begin

                axi_awaddr <= S_AXI_AWADDR;
            end
        end
    end

    // ============================================================
    // AXI Write Data Channel
    // ============================================================
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_wready <= 1'b0;
        end else begin
            if (!axi_wready &&
                S_AXI_WVALID &&
                S_AXI_AWVALID &&
                aw_en) begin

                axi_wready <= 1'b1;
            end else begin
                axi_wready <= 1'b0;
            end
        end
    end

    // ============================================================
    // User Control Register / TX Data Register Write
    // ============================================================
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            cmd_start_reg <= 1'b0;
            cmd_write_reg <= 1'b0;
            cmd_read_reg  <= 1'b0;
            cmd_stop_reg  <= 1'b0;

            tx_data_reg   <= 8'h00;
            ack_in_reg    <= 1'b1;   // 기본값: NACK

            irq_enable_reg <= 1'b0;

        end else begin
            // command signal은 기본적으로 0
            // AXI write가 들어온 한 clock 동안만 1
            cmd_start_reg <= 1'b0;
            cmd_write_reg <= 1'b0;
            cmd_read_reg  <= 1'b0;
            cmd_stop_reg  <= 1'b0;

            // ----------------------------------------------------
            // TDR write
            // ----------------------------------------------------
            if (tdr_write && S_AXI_WSTRB[0]) begin
                tx_data_reg <= S_AXI_WDATA[7:0];
            end

            // ----------------------------------------------------
            // CR write
            // ----------------------------------------------------
            if (cr_write) begin
                // CR[0:3] command pulse
                if (S_AXI_WSTRB[0]) begin
                    cmd_start_reg <= S_AXI_WDATA[0];
                    cmd_write_reg <= S_AXI_WDATA[1];
                    cmd_read_reg  <= S_AXI_WDATA[2];
                    cmd_stop_reg  <= S_AXI_WDATA[3];
                end

                // CR[8] ACK/NACK control
                if (S_AXI_WSTRB[1]) begin
                    ack_in_reg <= S_AXI_WDATA[8];
                end

                // CR[17] interrupt enable set
                if (irq_enable_set_request) begin
                    irq_enable_reg <= 1'b1;
                end

                // CR[18] interrupt enable clear
                if (irq_enable_clr_request) begin
                    irq_enable_reg <= 1'b0;
                end
            end
        end
    end

    // ============================================================
    // done / RDR / interrupt pending control
    // ============================================================
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            rx_data_reg    <= 8'h00;
            done_flag      <= 1'b0;
            rx_valid_flag  <= 1'b0;
            read_inflight  <= 1'b0;
            irq_pending_reg <= 1'b0;

        end else begin
            // READ command가 master로 전달되는 시점 표시
            if (cmd_read_reg) begin
                read_inflight <= 1'b1;
                rx_valid_flag <= 1'b0;
            end

            // 새 command를 넣으면 이전 done 상태 clear
            if (cmd_request) begin
                done_flag <= 1'b0;
            end

            // software가 CR[16]=1 write 시 interrupt clear
            if (irq_clear_request) begin
                irq_pending_reg <= 1'b0;
            end

            // RDR을 읽으면 rx_valid clear
            if (rdr_read) begin
                rx_valid_flag <= 1'b0;
            end

            // i2c_master의 START / WRITE / READ / STOP 완료
            if (done) begin
                done_flag       <= 1'b1;
                irq_pending_reg <= 1'b1;
            end

            // READ 완료 시 RDR에 rx_data 저장
            if (done && read_inflight) begin
                rx_data_reg   <= rx_data;
                rx_valid_flag <= 1'b1;
                read_inflight <= 1'b0;
            end
        end
    end

    // ============================================================
    // AXI Write Response Channel
    // ============================================================
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_bvalid <= 1'b0;
            axi_bresp  <= 2'b00;
        end else begin
            if (axi_awready &&
                S_AXI_AWVALID &&
                axi_wready &&
                S_AXI_WVALID &&
                !axi_bvalid) begin

                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b00; // OKAY

            end else if (axi_bvalid && S_AXI_BREADY) begin
                axi_bvalid <= 1'b0;
            end
        end
    end

    // ============================================================
    // AXI Read Address Channel
    // ============================================================
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_arready <= 1'b0;
            axi_araddr  <= {C_S_AXI_ADDR_WIDTH{1'b0}};
        end else begin
            if (!axi_arready &&
                S_AXI_ARVALID &&
                !axi_rvalid) begin

                axi_arready <= 1'b1;
                axi_araddr  <= S_AXI_ARADDR;

            end else begin
                axi_arready <= 1'b0;
            end
        end
    end

    // ============================================================
    // AXI Read Response Channel
    // ============================================================
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_rvalid <= 1'b0;
            axi_rresp  <= 2'b00;
        end else begin
            if (axi_arready &&
                S_AXI_ARVALID &&
                !axi_rvalid) begin

                axi_rvalid <= 1'b1;
                axi_rresp  <= 2'b00; // OKAY

            end else if (axi_rvalid && S_AXI_RREADY) begin
                axi_rvalid <= 1'b0;
            end
        end
    end

    // ============================================================
    // AXI Read Data Mux
    // ============================================================
    always @(*) begin
        reg_data_out = {C_S_AXI_DATA_WIDTH{1'b0}};

        case (rd_addr)

            // ----------------------------------------------------
            // CR read
            // command bits [3:0] are pulse signals, so read as 0
            // ----------------------------------------------------
            2'd0: begin
                reg_data_out[8]  = ack_in_reg;
                reg_data_out[17] = irq_enable_reg;
            end

            // ----------------------------------------------------
            // TDR read
            // ----------------------------------------------------
            2'd1: begin
                reg_data_out[7:0] = tx_data_reg;
            end

            // ----------------------------------------------------
            // RDR read
            // ----------------------------------------------------
            2'd2: begin
                reg_data_out[7:0] = rx_data_reg;
            end

            // ----------------------------------------------------
            // SR read
            // ----------------------------------------------------
            2'd3: begin
                reg_data_out[0] = busy;
                reg_data_out[1] = done_flag;
                reg_data_out[2] = ack_out;
                reg_data_out[3] = rx_valid_flag;
                reg_data_out[4] = irq_pending_reg;
                reg_data_out[5] = irq_enable_reg;
            end

            default: begin
                reg_data_out = {C_S_AXI_DATA_WIDTH{1'b0}};
            end
        endcase
    end

    // ============================================================
    // AXI Read Data Register
    // ============================================================
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            axi_rdata <= {C_S_AXI_DATA_WIDTH{1'b0}};
        end else begin
            if (slv_reg_rden) begin
                axi_rdata <= reg_data_out;
            end
        end
    end

endmodule


// ============================================================
// AXI I2C Top
// ============================================================


// ============================================================
// I2C Master Top
// ============================================================
