
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



// module i2c_master_top (
//     input  logic       clk,
//     input  logic       reset,

//     input  logic       cmd_start,
//     input  logic       cmd_write,
//     input  logic       cmd_read,
//     input  logic       cmd_stop,

//     input  logic [7:0] tx_data,
//     output logic [7:0] rx_data,

//     input  logic       ack_in,
//     output logic       ack_out,

//     output logic       busy,
//     output logic       done,

//     output logic       scl,
//     inout  wire        sda
// );

//     logic sda_o;
//     logic sda_i;

//     assign sda_i = sda;

//     // sda_o = 0 -> SDA Low 구동
//     // sda_o = 1 -> SDA release(High-Z)
//     assign sda = sda_o ? 1'bz : 1'b0;

//     i2c_master u_i2c_master (
//         .clk      (clk),
//         .reset    (reset),

//         .cmd_start(cmd_start),
//         .cmd_write(cmd_write),
//         .cmd_read (cmd_read),
//         .cmd_stop (cmd_stop),

//         .tx_data  (tx_data),
//         .rx_data  (rx_data),

//         .ack_in   (ack_in),
//         .ack_out  (ack_out),

//         .busy     (busy),
//         .done     (done),

//         .scl      (scl),
//         .sda_o    (sda_o),
//         .sda_i    (sda_i)
//     );

// endmodule


// // ============================================================
// // I2C Master Core
// // ============================================================

// module i2c_master (
//     input  logic       clk,
//     input  logic       reset,

//     input  logic       cmd_start,
//     input  logic       cmd_write,
//     input  logic       cmd_read,
//     input  logic       cmd_stop,

//     input  logic [7:0] tx_data,
//     output logic [7:0] rx_data,

//     input  logic       ack_in,
//     output logic       ack_out,

//     output logic       busy,
//     output logic       done,

//     output logic       scl,
//     output logic       sda_o,
//     input  logic       sda_i
// );

//     typedef enum logic [2:0] {
//         IDLE     = 3'b000,
//         START    = 3'b001,
//         WAIT_CMD = 3'b010,
//         DATA     = 3'b011,
//         DATA_ACK = 3'b100,
//         STOP     = 3'b101
//     } i2c_state_e;

//     i2c_state_e state;

//     logic [7:0] div_cnt;
//     logic       qtr_tick;

//     logic       scl_r;
//     logic       sda_r;

//     logic [1:0] step;

//     logic [7:0] tx_shift_reg;
//     logic [7:0] rx_shift_reg;

//     logic [2:0] bit_cnt;

//     logic       is_read;
//     logic       ack_in_r;

//     assign scl   = scl_r;
//     assign sda_o = sda_r;

//     assign busy = (state != IDLE);

//     // --------------------------------------------------------
//     // 100 MHz input clock 기준:
//     //
//     // 250 clk = 2.5 us
//     // 4 quarter = 10 us
//     // SCL = 100 kHz
//     // --------------------------------------------------------
//     always_ff @(posedge clk or negedge reset) begin
//         if (!reset) begin
//             div_cnt  <= 8'd0;
//             qtr_tick <= 1'b0;
//         end else begin
//             if (div_cnt == 8'd249) begin
//                 div_cnt  <= 8'd0;
//                 qtr_tick <= 1'b1;
//             end else begin
//                 div_cnt  <= div_cnt + 1'b1;
//                 qtr_tick <= 1'b0;
//             end
//         end
//     end

//     // --------------------------------------------------------
//     // I2C Master FSM
//     // --------------------------------------------------------
//     always_ff @(posedge clk or negedge reset) begin
//         if (!reset) begin
//             state        <= IDLE;

//             scl_r        <= 1'b1;
//             sda_r        <= 1'b1;

//             step         <= 2'd0;
//             done         <= 1'b0;

//             tx_shift_reg <= 8'h00;
//             rx_shift_reg <= 8'h00;

//             bit_cnt      <= 3'd0;
//             is_read      <= 1'b0;
//             ack_in_r     <= 1'b1;

//             ack_out      <= 1'b1;
//             rx_data      <= 8'h00;

//         end else begin
//             done <= 1'b0;

//             case (state)

//                 // ------------------------------------------------
//                 // I2C idle bus:
//                 // SCL = High, SDA = High(Z)
//                 // ------------------------------------------------
//                 IDLE: begin
//                     scl_r <= 1'b1;
//                     sda_r <= 1'b1;

//                     if (cmd_start) begin
//                         state <= START;
//                         step  <= 2'd0;
//                     end
//                 end

//                 // ------------------------------------------------
//                 // START:
//                 // SDA High -> Low while SCL High
//                 // ------------------------------------------------
//                 START: begin
//                     if (qtr_tick) begin
//                         case (step)

//                             2'd0: begin
//                                 scl_r <= 1'b1;
//                                 sda_r <= 1'b1;
//                                 step  <= 2'd1;
//                             end

//                             2'd1: begin
//                                 scl_r <= 1'b1;
//                                 sda_r <= 1'b0;
//                                 step  <= 2'd2;
//                             end

//                             2'd2: begin
//                                 scl_r <= 1'b0;
//                                 sda_r <= 1'b0;
//                                 step  <= 2'd3;
//                             end

//                             2'd3: begin
//                                 scl_r <= 1'b0;
//                                 sda_r <= 1'b0;

//                                 step  <= 2'd0;
//                                 done  <= 1'b1;
//                                 state <= WAIT_CMD;
//                             end
//                         endcase
//                     end
//                 end

//                 // ------------------------------------------------
//                 // START 후 WRITE / READ / STOP command 대기
//                 // ------------------------------------------------
//                 WAIT_CMD: begin
//                     if (cmd_write) begin
//                         tx_shift_reg <= tx_data;
//                         bit_cnt      <= 3'd0;
//                         is_read      <= 1'b0;
//                         state        <= DATA;

//                     end else if (cmd_read) begin
//                         rx_shift_reg <= 8'h00;
//                         bit_cnt      <= 3'd0;
//                         is_read      <= 1'b1;

//                         // cmd_read 시점의 ACK/NACK 설정 latch
//                         ack_in_r     <= ack_in;

//                         state        <= DATA;

//                     end else if (cmd_stop) begin
//                         state <= STOP;

//                     end else if (cmd_start) begin
//                         // Repeated START
//                         state <= START;
//                         step  <= 2'd0;
//                     end
//                 end

//                 // ------------------------------------------------
//                 // DATA:
//                 // write : SDA에 tx bit 출력
//                 // read  : SDA release 후 slave data sample
//                 // ------------------------------------------------
//                 DATA: begin
//                     if (qtr_tick) begin
//                         case (step)

//                             // SCL Low 상태에서 data 준비
//                             2'd0: begin
//                                 scl_r <= 1'b0;
//                                 sda_r <= is_read ? 1'b1
//                                                  : tx_shift_reg[7];
//                                 step  <= 2'd1;
//                             end

//                             // SCL Rising
//                             2'd1: begin
//                                 scl_r <= 1'b1;
//                                 step  <= 2'd2;
//                             end

//                             // SCL High 구간에서 read data sample
//                             2'd2: begin
//                                 scl_r <= 1'b1;

//                                 if (is_read) begin
//                                     rx_shift_reg <= {
//                                         rx_shift_reg[6:0],
//                                         sda_i
//                                     };
//                                 end

//                                 step <= 2'd3;
//                             end

//                             // SCL Low, shift 및 bit count
//                             2'd3: begin
//                                 scl_r <= 1'b0;
//                                 step  <= 2'd0;

//                                 if (!is_read) begin
//                                     tx_shift_reg <= {
//                                         tx_shift_reg[6:0],
//                                         1'b0
//                                     };
//                                 end

//                                 if (bit_cnt == 3'd7) begin
//                                     state <= DATA_ACK;
//                                 end else begin
//                                     bit_cnt <= bit_cnt + 1'b1;
//                                 end
//                             end
//                         endcase
//                     end
//                 end

//                 // ------------------------------------------------
//                 // 9번째 clock:
//                 //
//                 // Write:
//                 //   Master SDA release
//                 //   Slave ACK/NACK sample
//                 //
//                 // Read:
//                 //   Master ACK/NACK 출력
//                 // ------------------------------------------------
//                 DATA_ACK: begin
//                     if (qtr_tick) begin
//                         case (step)

//                             2'd0: begin
//                                 scl_r <= 1'b0;

//                                 if (is_read) begin
//                                     // ack_in_r = 0 -> ACK
//                                     // ack_in_r = 1 -> NACK
//                                     sda_r <= ack_in_r;
//                                 end else begin
//                                     // Slave가 ACK/NACK을 내도록 SDA release
//                                     sda_r <= 1'b1;
//                                 end

//                                 step <= 2'd1;
//                             end

//                             2'd1: begin
//                                 scl_r <= 1'b1;
//                                 step  <= 2'd2;
//                             end

//                             2'd2: begin
//                                 scl_r <= 1'b1;

//                                 if (!is_read) begin
//                                     // Slave ACK/NACK sample
//                                     ack_out <= sda_i;
//                                 end else begin
//                                     // Read 완료 data 저장
//                                     rx_data <= rx_shift_reg;
//                                 end

//                                 step <= 2'd3;
//                             end

//                             2'd3: begin
//                                 scl_r <= 1'b0;
//                                 step  <= 2'd0;

//                                 done  <= 1'b1;
//                                 state <= WAIT_CMD;
//                             end
//                         endcase
//                     end
//                 end

//                 // ------------------------------------------------
//                 // STOP:
//                 // SDA Low -> High while SCL High
//                 // ------------------------------------------------
//                 STOP: begin
//                     if (qtr_tick) begin
//                         case (step)

//                             2'd0: begin
//                                 scl_r <= 1'b0;
//                                 sda_r <= 1'b0;
//                                 step  <= 2'd1;
//                             end

//                             2'd1: begin
//                                 scl_r <= 1'b1;
//                                 sda_r <= 1'b0;
//                                 step  <= 2'd2;
//                             end

//                             2'd2: begin
//                                 scl_r <= 1'b1;
//                                 sda_r <= 1'b1;
//                                 step  <= 2'd3;
//                             end

//                             2'd3: begin
//                                 scl_r <= 1'b1;
//                                 sda_r <= 1'b1;

//                                 step  <= 2'd0;
//                                 done  <= 1'b1;
//                                 state <= IDLE;
//                             end
//                         endcase
//                     end
//                 end

//                 default: begin
//                     state <= IDLE;
//                     scl_r <= 1'b1;
//                     sda_r <= 1'b1;
//                     step  <= 2'd0;
//                 end
//             endcase
//         end
//     end

// endmodule




`timescale 1ns / 1ps

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




