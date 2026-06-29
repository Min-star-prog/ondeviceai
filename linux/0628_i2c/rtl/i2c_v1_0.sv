

`timescale 1ns / 1ps

module i2c_v1_0 #
(
    parameter integer C_S00_AXI_DATA_WIDTH = 32,
    parameter integer C_S00_AXI_ADDR_WIDTH = 4
)
(
    // --------------------------------------------------------
    // User ports
    // --------------------------------------------------------
    output wire scl,
    inout  wire sda,
    output wire intr,

    // --------------------------------------------------------
    // AXI4-Lite ports
    // --------------------------------------------------------
    input  wire  s00_axi_aclk,
    input  wire  s00_axi_aresetn,

    input  wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
    input  wire [2 : 0] s00_axi_awprot,
    input  wire  s00_axi_awvalid,
    output wire  s00_axi_awready,

    input  wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
    input  wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
    input  wire  s00_axi_wvalid,
    output wire  s00_axi_wready,

    output wire [1 : 0] s00_axi_bresp,
    output wire  s00_axi_bvalid,
    input  wire  s00_axi_bready,

    input  wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
    input  wire [2 : 0] s00_axi_arprot,
    input  wire  s00_axi_arvalid,
    output wire  s00_axi_arready,

    output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
    output wire [1 : 0] s00_axi_rresp,
    output wire  s00_axi_rvalid,
    input  wire  s00_axi_rready
);

    // --------------------------------------------------------
    // AXI register block <-> I2C master internal signals
    // --------------------------------------------------------
    wire       cmd_start;
    wire       cmd_write;
    wire       cmd_read;
    wire       cmd_stop;

    wire [7:0] tx_data;
    wire [7:0] rx_data;

    wire       ack_in;
    wire       ack_out;
    wire       busy;
    wire       done;

    // --------------------------------------------------------
    // AXI4-Lite register block
    // --------------------------------------------------------
    i2c_v1_0_S00_AXI #
    (
        .C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
    )
    i2c_v1_0_S00_AXI_inst
    (
        .cmd_start(cmd_start),
        .cmd_write(cmd_write),
        .cmd_read (cmd_read),
        .cmd_stop (cmd_stop),

        .tx_data  (tx_data),
        .rx_data  (rx_data),

        .ack_in   (ack_in),
        .ack_out  (ack_out),

        .busy     (busy),
        .done     (done),

        .intr     (intr),

        .S_AXI_ACLK   (s00_axi_aclk),
        .S_AXI_ARESETN(s00_axi_aresetn),

        .S_AXI_AWADDR (s00_axi_awaddr),
        .S_AXI_AWPROT (s00_axi_awprot),
        .S_AXI_AWVALID(s00_axi_awvalid),
        .S_AXI_AWREADY(s00_axi_awready),

        .S_AXI_WDATA  (s00_axi_wdata),
        .S_AXI_WSTRB  (s00_axi_wstrb),
        .S_AXI_WVALID (s00_axi_wvalid),
        .S_AXI_WREADY (s00_axi_wready),

        .S_AXI_BRESP  (s00_axi_bresp),
        .S_AXI_BVALID (s00_axi_bvalid),
        .S_AXI_BREADY (s00_axi_bready),

        .S_AXI_ARADDR (s00_axi_araddr),
        .S_AXI_ARPROT (s00_axi_arprot),
        .S_AXI_ARVALID(s00_axi_arvalid),
        .S_AXI_ARREADY(s00_axi_arready),

        .S_AXI_RDATA  (s00_axi_rdata),
        .S_AXI_RRESP  (s00_axi_rresp),
        .S_AXI_RVALID (s00_axi_rvalid),
        .S_AXI_RREADY (s00_axi_rready)
    );

    // --------------------------------------------------------
    // I2C Master Core
    //
    // i2c_master reset is active-low.
    // Therefore, s00_axi_aresetn is connected directly.
    // --------------------------------------------------------
    i2c_master_top u_i2c_master
    (
        .clk      (s00_axi_aclk),
        .reset    (s00_axi_aresetn),

        .cmd_start(cmd_start),
        .cmd_write(cmd_write),
        .cmd_read (cmd_read),
        .cmd_stop (cmd_stop),

        .tx_data  (tx_data),
        .rx_data  (rx_data),

        .ack_in   (ack_in),
        .ack_out  (ack_out),

        .busy     (busy),
        .done     (done),

        .scl      (scl),
        .sda      (sda)
    );

endmodule



module i2c_master_top (
    input  logic       clk,
    input  logic       reset,
    // command port
    input  logic       cmd_start,
    input  logic       cmd_write,
    input  logic       cmd_read,
    input  logic       cmd_stop,
    // internal port
    input  logic [7:0] tx_data,
    output logic [7:0] rx_data,
    input  logic       ack_in,     // read  떆 master媛  蹂대궪 ACK(0)/NACK(1)
    output logic       ack_out,    // write  떆 slave濡쒕  꽣 諛쏆  ACK(0)/NACK(1)
    output logic       busy,
    output logic       done,
    // external i2c port
    output logic       scl,
    inout  wire       sda
);
    logic sda_o, sda_i;

    assign sda_i = sda;
    assign sda   = sda_o ? 1'bz : 1'b0;

    i2c_master u_i2c_master (
        .*,
        .sda_o(sda_o),
        .sda_i(sda_i)
    );
endmodule

module i2c_master (
    input  logic       clk,
    input  logic       reset,
    // command port
    input  logic       cmd_start,
    input  logic       cmd_write,
    input  logic       cmd_read,
    input  logic       cmd_stop,
    // internal port
    input  logic [7:0] tx_data,
    output logic [7:0] rx_data,
    input  logic       ack_in,     // read  떆 master媛  蹂대궪 ACK(0)/NACK(1)
    output logic       ack_out,    // write  떆 slave濡쒕  꽣 諛쏆  ACK(0)/NACK(1)
    output logic       busy,
    output logic       done,
    // external i2c port
    output logic       scl,
    output logic       sda_o,
    input  logic       sda_i
);
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        START,
        WAIT_CMD,
        DATA,
        DATA_ACK,
        STOP
    } i2c_state_e;

    i2c_state_e       state;

    logic       [7:0] div_cnt;
    logic             qtr_tick;  // 1/4 SCL 二쇨린留덈떎 1clk  럡 뒪
    logic             scl_r;
    logic             sda_r;
    logic       [1:0] step;  //  긽 깭  궡 荑쇳꽣 吏꾪뻾  떒怨  (0~3)
    logic       [7:0] tx_shift_reg;
    logic       [7:0] rx_shift_reg;
    logic       [2:0] bit_cnt;
    logic             is_read;
    logic             ack_in_r;

    assign scl   = scl_r;
    assign sda_o = sda_r;
    assign busy  = (state != IDLE);

    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            div_cnt  <= 0;
            qtr_tick <= 1'b0;
        end else begin
            if (div_cnt == 250 - 1) begin
                div_cnt  <= 0;
                qtr_tick <= 1'b1;
            end else begin
                div_cnt  <= div_cnt + 1;
                qtr_tick <= 1'b0;
            end
        end
    end


    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            state        <= IDLE;
            scl_r        <= 1'b1;  // idle: SCL High
            sda_r        <= 1'b1;  // idle: SDA High (Hi-Z, pull-up high)
            step         <= 0;
            done         <= 1'b0;
            tx_shift_reg <= 0;
            rx_shift_reg <= 0;
            is_read      <= 1'b0;
            bit_cnt      <= 0;
            ack_in_r     <= 1'b1;
        end else begin
            done <= 1'b0;

            case (state)
                IDLE: begin
                    scl_r <= 1'b1;
                    sda_r <= 1'b1;
                    if (cmd_start) begin
                        state <= START;
                        step  <= 0;
                    end
                end
                START: begin
                    if (qtr_tick) begin
                        case (step)
                            2'd0: begin
                                sda_r <= 1'b1;
                                scl_r <= 1'b1;
                                step  <= 2'd1;
                            end
                            2'd1: begin
                                sda_r <= 1'b0;
                                scl_r <= 1'b1;
                                step  <= 2'd2;
                            end
                            2'd2: begin
                                sda_r <= 1'b0;
                                scl_r <= 1'b0;
                                step  <= 2'd3;
                            end
                            2'd3: begin
                                sda_r <= 1'b0;
                                scl_r <= 1'b0;
                                step  <= 2'd0;
                                done  <= 1'b1;
                                state <= WAIT_CMD;
                            end
                        endcase
                    end
                end
                WAIT_CMD: begin
                    if (cmd_write) begin
                        tx_shift_reg <= tx_data;
                        bit_cnt      <= 0;
                        is_read      <= 1'b0;
                        state        <= DATA;
                    end else if (cmd_read) begin
                        rx_shift_reg <= 0;
                        bit_cnt      <= 0;
                        is_read      <= 1'b1;
                        ack_in_r     <= ack_in;
                        state        <= DATA;
                    end else if (cmd_stop) begin
                        state <= STOP;
                    end else if (cmd_start) begin
                        state <= START;
                    end
                end
                DATA: begin
                    if (qtr_tick) begin
                        case (step)
                            2'd0: begin
                                step  <= 2'd1;
                                scl_r <= 1'b0;
                                sda_r <= is_read ? 1'b1 : tx_shift_reg[7];
                            end
                            2'd1: begin
                                step  <= 2'd2;
                                scl_r <= 1'b1;
                            end
                            2'd2: begin
                                step  <= 2'd3;
                                scl_r <= 1'b1;
                                if (is_read) begin
                                    rx_shift_reg <= {rx_shift_reg[6:0], sda_i};
                                end
                            end
                            2'd3: begin
                                step  <= 2'd0;
                                scl_r <= 1'b0;
                                if (!is_read) begin
                                    tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
                                end
                                if (bit_cnt == 7) begin
                                    state <= DATA_ACK;
                                end else begin
                                    bit_cnt <= bit_cnt + 1;
                                end
                            end
                        endcase
                    end
                end
                DATA_ACK: begin
                    if (qtr_tick) begin
                        case (step)
                            2'd0: begin
                                step  <= 2'd1;
                                scl_r <= 1'b0;
                                if (is_read) begin
                                    sda_r <= ack_in_r;
                                end else begin
                                    sda_r <= 1'b1;
                                end
                            end
                            2'd1: begin
                                step  <= 2'd2;
                                scl_r <= 1'b1;
                            end
                            2'd2: begin
                                step  <= 2'd3;
                                scl_r <= 1'b1;
                                if (!is_read) begin
                                    ack_out <= sda_i;
                                end else begin
                                    rx_data <= rx_shift_reg;
                                end
                            end
                            2'd3: begin
                                step  <= 2'd0;
                                scl_r <= 1'b0;
                                done  <= 1'b1;
                                state <= WAIT_CMD;
                            end
                        endcase
                    end
                end
                STOP: begin
                    if (qtr_tick) begin
                        case (step)
                            2'd0: begin
                                sda_r <= 1'b0;
                                scl_r <= 1'b0;
                                step  <= 2'd1;
                            end
                            2'd1: begin
                                sda_r <= 1'b0;
                                scl_r <= 1'b1;
                                step  <= 2'd2;
                            end
                            2'd2: begin
                                sda_r <= 1'b1;
                                scl_r <= 1'b1;
                                step  <= 2'd3;
                            end
                            2'd3: begin
                                sda_r <= 1'b1;
                                scl_r <= 1'b1;
                                step  <= 2'd0;
                                done  <= 1'b1;
                                state <= IDLE;
                            end
                        endcase
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule

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
