module pattern_stick (
    input logic clk,
    input logic rst,
    input logic game_start,
    input logic [9:0] i_stick_x_pixel,
    input logic [9:0] i_stick_y_pixel,
    input logic i_vsync,
    input logic game_stop,
    input logic pattern_uart_ready,
    output logic pattern_uart_valid,
    output logic [2:0] pattern_state,
    output logic pattern_tick,
    output logic done
);


    typedef enum logic [2:0] {
        IDLE = 3'b000,
        START,
        PATTERN_1,
        PATTERN_2,
        PATTERN_3,
        PATTERN_4,
        STOP
    } pattern_state_e;
    pattern_state_e c_state, n_state;

    assign zone1 = (i_stick_x_pixel >= 140 && i_stick_x_pixel <= 180) && (i_stick_y_pixel >= 175 && i_stick_y_pixel <= 215);
    assign zone2 = (i_stick_x_pixel >= 75 && i_stick_x_pixel <= 125) && (i_stick_y_pixel >= 110 && i_stick_y_pixel <= 160);
    assign zone3 = (i_stick_x_pixel >= 195 && i_stick_x_pixel <= 245) && (i_stick_y_pixel >= 110 && i_stick_y_pixel <= 160);
    assign zone4 = (i_stick_x_pixel >= 140 && i_stick_x_pixel <= 180) && (i_stick_y_pixel >= 40 && i_stick_y_pixel <= 80);


    logic pattern_tick_reg;
    logic done_flag;




    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_state <= IDLE;
            pattern_tick <= 0;
            done <= 1'b0;
            //vsync마다 현재 상태 출력
        end else if (i_vsync) begin
            pattern_state <= c_state;
            pattern_uart_valid <= 1'b1;
        end else begin
            c_state <= n_state;
            pattern_tick <= pattern_tick_reg;
            done <= done_flag;
        end

    end

    always_comb begin
        n_state = c_state;
        pattern_tick_reg = 1'b0;
        case (c_state)
            IDLE: begin
                if (game_start) begin
                    n_state = START;
                    pattern_tick_reg = 1'b1;
                    done_flag = 1'b0;
                end
            end
            // START : zone 4 벗어나면 tick 1번, zone 1 도달하면 tick 1번
            START: begin
                if (!zone4) begin
                    pattern_tick_reg = 1'b1;
                    if (zone1) begin
                        n_state = PATTERN_1;
                        pattern_tick_reg = 1'b1;
                    end
                end
            end
            PATTERN_1: begin
                if (zone2) begin
                    n_state = PATTERN_2;
                    pattern_tick_reg = 1'b1;
                end
            end
            PATTERN_2: begin
                if (zone3) begin
                    n_state = PATTERN_3;
                    pattern_tick_reg = 1'b1;
                end
            end
            PATTERN_3: begin
                if (zone4) begin
                    n_state = PATTERN_4;
                    pattern_tick_reg = 1'b1;
                end
            end
            PATTERN_4: begin
                if (game_stop) begin
                    n_state = STOP;
                    pattern_tick_reg = 1'b1;

                end else if (zone1) begin
                    n_state = PATTERN_1;
                    pattern_tick_reg = 1'b1;
                end
            end
            STOP: begin
                n_state   = IDLE;
                done_flag = 1'b1;
            end
        endcase
    end

endmodule
