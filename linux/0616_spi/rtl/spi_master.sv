`timescale 1ns / 1ps

module spi_master (
    // global signals
    input  logic       clk,
    input  logic       rst,
    // internal signals
    input  logic       start,
    input  logic       cpol,     // clock polarity
    input  logic       cpha,
    input  logic [7:0] clk_div,  // SCLK 속도 계산용 분주값
    input  logic [7:0] tx_data,
    output logic       busy,
    output logic [7:0] rx_data,
    output logic       done,
    // external signals
    output logic       sclk,
    output logic       mosi,
    input  logic       miso,
    output logic       ss_n
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        START,
        DATA,
        STOP
    } spi_state_e;

    spi_state_e state;

    logic [7:0] div_cnt;
    logic [7:0] clk_div_reg;
    logic half_tick;
    logic [7:0] tx_shift_reg;
    logic [7:0] rx_shift_reg;
    logic [2:0] bit_cnt;
    logic step;
    logic cpol_reg;
    logic cpha_reg;
    logic sclk_reg;

    assign sclk = sclk_reg;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            div_cnt   <= 0;
            half_tick <= 1'b0;
        end else begin
            if (state == DATA) begin
                if (div_cnt == clk_div_reg) begin
                    div_cnt   <= 0;
                    half_tick <= 1'b1;
                end else begin
                    div_cnt   <= div_cnt + 1;
                    half_tick <= 1'b0;
                end
            end else begin
                div_cnt   <= 0;
                half_tick <= 1'b0;
            end
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            mosi         <= 1'b1;
            ss_n         <= 1'b1;
            busy         <= 1'b0;
            done         <= 1'b0;
            tx_shift_reg <= 0;
            rx_shift_reg <= 0;
            bit_cnt      <= 0;
            rx_data      <= 0;
            sclk_reg     <= cpol;
            cpol_reg     <= 1'b0;
            cpha_reg     <= 1'b0;
            clk_div_reg  <= 0;
        end else begin
            done <= 1'b0;
            case (state)
                IDLE: begin
                    mosi <= 1'b1;
                    ss_n <= 1'b1;
                    sclk_reg <= cpol;
                    if (start) begin
                        state        <= START;
                        cpol_reg     <= cpol;
                        cpha_reg     <= cpha;
                        tx_shift_reg <= tx_data;  // latching
                        clk_div_reg  <= clk_div;  // latching
                        bit_cnt      <= 0;
                        busy         <= 1'b1;
                        step         <= 1'b0;
                        ss_n         <= 1'b0;
                    end
                end
                START: begin
                    state <= DATA;
                    if (!cpha_reg) begin
                        mosi <= tx_shift_reg[7];
                        tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
                    end
                end
                DATA: begin
                    if (half_tick) begin
                        sclk_reg <= ~sclk_reg;
                        if (step == 0) begin  // -- 첫번째 에지
                            step <= 1'b1;
                            if (!cpha_reg) begin
                                rx_shift_reg <= {rx_shift_reg[6:0], miso};
                            end else begin
                                mosi <= tx_shift_reg[7];
                                tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
                            end
                        end else begin
                            step <= 1'b0;
                            if (!cpha_reg) begin
                                if (bit_cnt < 7) begin
                                    mosi         <= tx_shift_reg[7];
                                    tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
                                end
                                end else begin
                                    rx_shift_reg <= {rx_shift_reg[6:0], miso};
                                end
                                //8bit 전송 완료(2nd edge 시점)
                                if (bit_cnt == 7) begin
                                    state <= STOP;
                                    if (!cpha_reg) begin
                                        // cpha = 0: 마지막 sample은 
                                        // 이미 1st edge에서 rx_shift_reg에 반영됨 -> 그대로 복사
                                        rx_data <= rx_shift_reg;
                                    end else begin
                                        // cpha = 1: 바로 위의 rx_shift_reg 갱신은 
                                        //NBA라 이번 cycle에는 아직 미반영.
                                        // 현재 miso를 직접 결합해 최종 8bit 구성
                                        rx_data <= {rx_shift_reg[6:0], miso};
                                    end
                                end else begin
                                    bit_cnt <= bit_cnt + 1;
                                end
                            end
                        end
                    end
                STOP: begin
                    sclk_reg <= cpol_reg;
                    ss_n <= 1'b1;
                    done <= 1'b1;
                    busy <= 1'b0;
                    mosi <= 1'b1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
