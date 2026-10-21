`timescale 1ns / 1ps


module sccb_setup_controller #(
    parameter integer CLK_HZ  = 100_000_000,
    parameter integer SCCB_HZ = 100_000,

    // 0 : real camera
    // 1 : color bar
    parameter bit COLOR_BAR = 1'b0
)(
    input  logic clk,
    input  logic rst,

    output wire  sioc,
    inout  wire  siod,

    output logic init_done,
    output logic init_error,

    // 디버깅용
    output logic [6:0] debug_index
);

    //----------------------------------------------------------
    // Master interface
    //----------------------------------------------------------

    logic       master_start;
    logic [7:0] master_reg;
    logic [7:0] master_data;

    logic master_busy;
    logic master_done;
    logic master_ack_error;


    sccb_write_master #(
        .CLK_HZ  (CLK_HZ),
        .SCCB_HZ (SCCB_HZ)
    ) U_SCCB_MASTER (
        .clk       (clk),
        .rst       (rst),

        .start     (master_start),
        .reg_addr  (master_reg),
        .reg_data  (master_data),

        .busy      (master_busy),
        .done      (master_done),
        .ack_error (master_ack_error),

        .sioc      (sioc),
        .siod      (siod)
    );


    //----------------------------------------------------------
    // Delay values
    //----------------------------------------------------------

    // FPGA configuration 후 XCLK이 안정된 뒤 기다림
    localparam integer POWERUP_CYCLES =
        CLK_HZ / 10;               // 100 ms

    // COM7 software reset 뒤 30 ms
    localparam integer RESET_DELAY_CYCLES =
        (CLK_HZ / 1000) * 30;

    localparam integer DELAY_1MS =
        CLK_HZ / 1000;

    localparam integer DELAY_10MS =
        CLK_HZ / 100;


    //----------------------------------------------------------
    // OV7670 configuration ROM
    //----------------------------------------------------------
    //
    // [15:8] = register
    // [ 7:0] = value
    //
    // STM32에서 동작했던 설정을 그대로 옮김.
    //----------------------------------------------------------

    localparam integer CFG_COUNT = 61;

    function automatic logic [15:0] cfg_lut(
        input logic [6:0] index
    );
        begin
            case (index)

                //--------------------------------------------------
                // DEFAULT configuration
                //--------------------------------------------------

                 0: cfg_lut = 16'h3A04;
                 1: cfg_lut = 16'h1200;
                 2: cfg_lut = 16'h13E7;
                 3: cfg_lut = 16'h6F9F;
                 4: cfg_lut = 16'hB084;

                 5: cfg_lut = 16'h703A;
                 6: cfg_lut = 16'h7135;
                 7: cfg_lut = 16'h7211;
                 8: cfg_lut = 16'h73F0;

                 // Gamma
                 9: cfg_lut = 16'h7A20;
                10: cfg_lut = 16'h7B10;
                11: cfg_lut = 16'h7C1E;
                12: cfg_lut = 16'h7D35;
                13: cfg_lut = 16'h7E5A;
                14: cfg_lut = 16'h7F69;
                15: cfg_lut = 16'h8076;
                16: cfg_lut = 16'h8180;
                17: cfg_lut = 16'h8288;
                18: cfg_lut = 16'h838F;
                19: cfg_lut = 16'h8496;
                20: cfg_lut = 16'h85A3;
                21: cfg_lut = 16'h86AF;
                22: cfg_lut = 16'h87C4;
                23: cfg_lut = 16'h88D7;
                24: cfg_lut = 16'h89E8;

                // AGC / AEC
                25: cfg_lut = 16'h0000;
                26: cfg_lut = 16'h1000;
                27: cfg_lut = 16'h0D40;
                28: cfg_lut = 16'h1418;

                29: cfg_lut = 16'hA505;
                30: cfg_lut = 16'hAB07;

                31: cfg_lut = 16'h2495;
                32: cfg_lut = 16'h2533;
                33: cfg_lut = 16'h26E3;

                34: cfg_lut = 16'h9F78;
                35: cfg_lut = 16'hA068;
                36: cfg_lut = 16'hA103;
                37: cfg_lut = 16'hA6D8;
                38: cfg_lut = 16'hA7D8;
                39: cfg_lut = 16'hA8F0;
                40: cfg_lut = 16'hA990;
                41: cfg_lut = 16'hAA94;


                //--------------------------------------------------
                // QVGA 320x240
                //--------------------------------------------------

                42: cfg_lut = 16'h1211; // COM7
                43: cfg_lut = 16'h0C04; // COM3
                44: cfg_lut = 16'h3E19; // COM14

                45: cfg_lut = 16'h703A;
                46: cfg_lut = 16'h7135;
                47: cfg_lut = 16'h7211;
                48: cfg_lut = 16'h73F1;
                49: cfg_lut = 16'hA202;


                //--------------------------------------------------
                // Frame Control
                //
                // hstart = 168
                // hstop  = 24
                // vstart = 12
                // vstop  = 492
                //--------------------------------------------------

                50: cfg_lut = 16'h1715; // HSTART
                51: cfg_lut = 16'h1803; // HSTOP
                52: cfg_lut = 16'h3200; // HREF

                53: cfg_lut = 16'h1903; // VSTART
                54: cfg_lut = 16'h1A7B; // VSTOP
                55: cfg_lut = 16'h0300; // VREF


                //--------------------------------------------------
                // RGB565
                //--------------------------------------------------

                56: cfg_lut = 16'h1214; // COM7 RGB + QVGA
                57: cfg_lut = 16'h4010; // COM15 RGB565


                //--------------------------------------------------
                // Final options
                //--------------------------------------------------

                // AEC + AGC + AWB
                58: cfg_lut = 16'h13E7;

                // brightness = 120
                // C 코드 기준 255 - 120 = 135 = 0x87
                59: cfg_lut = 16'h5587;

                // COM17 bit3 = color bar
                60: cfg_lut = {
                    8'h42,
                    (COLOR_BAR ? 8'h08 : 8'h00)
                };

                default:
                    cfg_lut = 16'h0000;

            endcase
        end
    endfunction


    logic [6:0] cfg_index;
    logic [15:0] cfg_word;

    assign cfg_word    = cfg_lut(cfg_index);
    assign debug_index = cfg_index;


    //----------------------------------------------------------
    // Setup FSM
    //----------------------------------------------------------

    typedef enum logic [3:0] {

        ST_POWER_WAIT,

        ST_RESET_START,
        ST_RESET_WAIT,
        ST_RESET_DELAY,

        ST_CFG_START,
        ST_CFG_WAIT,
        ST_CFG_DELAY,

        ST_DONE,
        ST_ERROR

    } setup_state_t;


    setup_state_t state;

    logic [31:0] delay_counter;
    logic [31:0] delay_target;

    logic [1:0] retry_count;


    always_ff @(posedge clk or posedge rst) begin

        if (rst) begin

            state         <= ST_POWER_WAIT;

            master_start  <= 0;
            master_reg    <= 0;
            master_data   <= 0;

            cfg_index     <= 0;

            delay_counter <= 0;
            delay_target  <= 0;

            retry_count   <= 0;

            init_done     <= 0;
            init_error    <= 0;

        end
        else begin

            master_start <= 0;


            case (state)

                //--------------------------------------------------
                // Power up delay
                //--------------------------------------------------
                ST_POWER_WAIT: begin

                    if (delay_counter >= POWERUP_CYCLES-1) begin
                        delay_counter <= 0;
                        state         <= ST_RESET_START;
                    end
                    else begin
                        delay_counter <= delay_counter + 1'b1;
                    end
                end


                //--------------------------------------------------
                // COM7 = 0x80 : software reset
                //--------------------------------------------------
                ST_RESET_START: begin

                    if (!master_busy) begin

                        master_reg   <= 8'h12;
                        master_data  <= 8'h80;
                        master_start <= 1;

                        state <= ST_RESET_WAIT;
                    end
                end


                ST_RESET_WAIT: begin

                    if (master_done) begin

                        if (master_ack_error) begin

                            if (retry_count < 2) begin
                                retry_count <= retry_count + 1'b1;
                                state       <= ST_RESET_START;
                            end
                            else begin
                                init_error <= 1;
                                state      <= ST_ERROR;
                            end

                        end
                        else begin

                            retry_count   <= 0;
                            delay_counter <= 0;

                            state <= ST_RESET_DELAY;
                        end
                    end
                end


                //--------------------------------------------------
                // SW reset 이후 30 ms
                //--------------------------------------------------
                ST_RESET_DELAY: begin

                    if (delay_counter >= RESET_DELAY_CYCLES-1) begin

                        delay_counter <= 0;
                        cfg_index     <= 0;

                        state <= ST_CFG_START;
                    end
                    else begin
                        delay_counter <= delay_counter + 1'b1;
                    end
                end


                //--------------------------------------------------
                // Register write
                //--------------------------------------------------
                ST_CFG_START: begin

                    if (!master_busy) begin

                        master_reg   <= cfg_word[15:8];
                        master_data  <= cfg_word[7:0];
                        master_start <= 1;

                        state <= ST_CFG_WAIT;
                    end
                end


                ST_CFG_WAIT: begin

                    if (master_done) begin

                        //--------------------------------------------------
                        // ACK fail
                        //--------------------------------------------------
                        if (master_ack_error) begin

                            if (retry_count < 2) begin

                                retry_count <= retry_count + 1'b1;
                                state       <= ST_CFG_START;

                            end
                            else begin

                                init_error <= 1;
                                state      <= ST_ERROR;
                            end
                        end

                        //--------------------------------------------------
                        // Write OK
                        //--------------------------------------------------
                        else begin

                            retry_count <= 0;

                            if (cfg_index == CFG_COUNT-1) begin

                                init_done <= 1;
                                state     <= ST_DONE;

                            end
                            else begin

                                delay_counter <= 0;

                                // defaults 이후 10 ms
                                // frame control 이후 RGB 설정 전 10 ms
                                if ((cfg_index == 41) ||
                                    (cfg_index == 55))
                                    delay_target <= DELAY_10MS;
                                else
                                    delay_target <= DELAY_1MS;

                                state <= ST_CFG_DELAY;
                            end
                        end
                    end
                end


                //--------------------------------------------------
                // Register write interval
                //--------------------------------------------------
                ST_CFG_DELAY: begin

                    if (delay_counter >= delay_target-1) begin

                        delay_counter <= 0;
                        cfg_index     <= cfg_index + 1'b1;

                        state <= ST_CFG_START;
                    end
                    else begin
                        delay_counter <= delay_counter + 1'b1;
                    end
                end


                //--------------------------------------------------
                // Initialization complete
                //--------------------------------------------------
                ST_DONE: begin

                    init_done <= 1;
                end


                //--------------------------------------------------
                // Initialization failed
                //--------------------------------------------------
                ST_ERROR: begin

                    init_done  <= 0;
                    init_error <= 1;
                end


                default: begin
                    state <= ST_POWER_WAIT;
                end

            endcase
        end
    end

endmodule



module sccb_write_master #(
    parameter integer CLK_HZ   = 100_000_000,
    parameter integer SCCB_HZ  = 100_000
)(
    input  logic       clk,
    input  logic       rst,

    input  logic       start,
    input  logic [7:0] reg_addr,
    input  logic [7:0] reg_data,

    output logic       busy,
    output logic       done,
    output logic       ack_error,

    output wire        sioc,
    inout  wire        siod
);

    // OV7670 SCCB write address
    localparam logic [7:0] DEV_ADDR = 8'h42;

    // 100 MHz / (100 kHz * 2) = 500
    localparam integer HALF_DIV =
        CLK_HZ / (SCCB_HZ * 2);

    localparam integer DIV_W =
        (HALF_DIV <= 1) ? 1 : $clog2(HALF_DIV);

    logic [DIV_W-1:0] div_cnt;
    logic tick;

    //----------------------------------------------------------
    // 5 us half-period tick for 100 kHz SCCB
    //----------------------------------------------------------
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            div_cnt <= 0;
            tick    <= 0;
        end
        else begin
            tick <= 0;

            if (div_cnt == HALF_DIV-1) begin
                div_cnt <= 0;
                tick    <= 1;
            end
            else begin
                div_cnt <= div_cnt + 1'b1;
            end
        end
    end


    //----------------------------------------------------------
    // Open-drain outputs
    //----------------------------------------------------------
    logic sioc_drive_low;
    logic siod_drive_low;

    assign sioc = sioc_drive_low ? 1'b0 : 1'bz;
    assign siod = siod_drive_low ? 1'b0 : 1'bz;

    wire siod_in = siod;


    //----------------------------------------------------------
    // SCCB FSM
    //----------------------------------------------------------
    typedef enum logic [3:0] {
        ST_IDLE,

        ST_START_0,
        ST_START_1,
        ST_START_2,

        ST_BIT_LOW,
        ST_BIT_HIGH,

        ST_ACK_LOW,
        ST_ACK_HIGH,
        ST_ACK_SAMPLE,

        ST_STOP_0,
        ST_STOP_1,
        ST_STOP_2
    } state_t;

    state_t state;

    logic [7:0] shift_byte;
    logic [1:0] byte_index;
    logic [2:0] bit_index;


    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state           <= ST_IDLE;

            busy            <= 0;
            done            <= 0;
            ack_error       <= 0;

            sioc_drive_low  <= 0;
            siod_drive_low  <= 0;

            shift_byte      <= 0;
            byte_index      <= 0;
            bit_index       <= 7;
        end
        else begin

            done <= 0;

            //--------------------------------------------------
            // Request capture
            //--------------------------------------------------
            if (state == ST_IDLE) begin

                busy           <= 0;
                sioc_drive_low <= 0;
                siod_drive_low <= 0;

                if (start) begin

                    busy      <= 1;
                    ack_error <= 0;

                    shift_byte <= DEV_ADDR;
                    byte_index <= 0;
                    bit_index  <= 7;

                    state <= ST_START_0;
                end
            end

            //--------------------------------------------------
            // SCCB timing
            //--------------------------------------------------
            else if (tick) begin

                case (state)

                    //------------------------------------------------
                    // START
                    //------------------------------------------------
                    ST_START_0: begin
                        // SIOC=1, SIOD=1
                        sioc_drive_low <= 0;
                        siod_drive_low <= 0;

                        state <= ST_START_1;
                    end

                    ST_START_1: begin
                        // SIOD : 1 -> 0 while SIOC=1
                        sioc_drive_low <= 0;
                        siod_drive_low <= 1;

                        state <= ST_START_2;
                    end

                    ST_START_2: begin
                        // pull clock low
                        sioc_drive_low <= 1;
                        siod_drive_low <= 1;

                        state <= ST_BIT_LOW;
                    end


                    //------------------------------------------------
                    // DATA BIT
                    //------------------------------------------------
                    ST_BIT_LOW: begin

                        sioc_drive_low <= 1;

                        // SCCB open drain:
                        // data 0 -> drive low
                        // data 1 -> release
                        siod_drive_low <= ~shift_byte[bit_index];

                        state <= ST_BIT_HIGH;
                    end


                    ST_BIT_HIGH: begin

                        // clock high
                        sioc_drive_low <= 0;

                        if (bit_index == 0) begin
                            state <= ST_ACK_LOW;
                        end
                        else begin
                            bit_index <= bit_index - 1'b1;
                            state     <= ST_BIT_LOW;
                        end
                    end


                    //------------------------------------------------
                    // ACK
                    //------------------------------------------------
                    ST_ACK_LOW: begin

                        sioc_drive_low <= 1;

                        // master releases data line
                        siod_drive_low <= 0;

                        state <= ST_ACK_HIGH;
                    end


                    ST_ACK_HIGH: begin

                        // clock high
                        sioc_drive_low <= 0;
                        siod_drive_low <= 0;

                        state <= ST_ACK_SAMPLE;
                    end


                    ST_ACK_SAMPLE: begin

                        // sample while SIOC has been high
                        if (siod_in)
                            ack_error <= 1'b1;

                        // clock back low
                        sioc_drive_low <= 1;

                        if (byte_index == 2) begin
                            state <= ST_STOP_0;
                        end
                        else begin

                            byte_index <= byte_index + 1'b1;
                            bit_index  <= 7;

                            case (byte_index)
                                0: shift_byte <= reg_addr;
                                1: shift_byte <= reg_data;
                                default:
                                    shift_byte <= 0;
                            endcase

                            state <= ST_BIT_LOW;
                        end
                    end


                    //------------------------------------------------
                    // STOP
                    //------------------------------------------------
                    ST_STOP_0: begin

                        sioc_drive_low <= 1;
                        siod_drive_low <= 1;

                        state <= ST_STOP_1;
                    end


                    ST_STOP_1: begin

                        // clock high, data still low
                        sioc_drive_low <= 0;
                        siod_drive_low <= 1;

                        state <= ST_STOP_2;
                    end


                    ST_STOP_2: begin

                        // SIOD : 0 -> 1 while SIOC=1
                        sioc_drive_low <= 0;
                        siod_drive_low <= 0;

                        busy <= 0;
                        done <= 1;

                        state <= ST_IDLE;
                    end


                    default: begin
                        state <= ST_IDLE;
                    end

                endcase
            end
        end
    end

endmodule

