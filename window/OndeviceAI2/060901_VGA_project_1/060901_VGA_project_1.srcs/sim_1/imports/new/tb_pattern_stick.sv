`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/01 14:46:25
// Design Name: 
// Module Name: tb_pattern_stick
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_pattern_stick ();

    logic       clk;
    logic       rst;
    logic       game_start;
    logic       game_stop;
    logic [9:0] i_stick_x_pixel;
    logic [9:0] i_stick_y_pixel;
    logic       i_vsync;
    logic       pattern_control_ready;
    logic       pattern_control_valid;
    logic [2:0] pattern_state;
    logic       pattern_tick;
    logic       i_state_change_enable;

    pattern_stick U_PATTERN_STICK (.*);

    always #5 clk = ~clk;

    task automatic check_state(input logic [2:0] expected);
        #1;
        if (pattern_state !== expected)
            $fatal(1, "Expected state %0d, got %0d", expected, pattern_state);
        $display("time=%0t state=%0d", $time, pattern_state);
    endtask

    initial begin
        rst = 1;
        clk = 0;
        game_start = 0;
        game_stop = 0;
        i_stick_x_pixel = 0;
        i_stick_y_pixel = 0;
        i_vsync = 0;
        pattern_control_ready = 1;
        i_state_change_enable = 1;
        @(posedge clk);
        check_state(3'd0);  // IDLE
        repeat (3) @(posedge clk);
        rst <= 0;

        // Model registered inputs: launch on posedge, sample on the next posedge.
        @(posedge clk);
        game_start <= 1;
        @(posedge clk);
        game_start <= 0;
        check_state(3'd1);  // START

        repeat (4) @(posedge clk);

        // Coordinates and vsync change together. Zone 4: START -> READY.
        i_stick_x_pixel <= 160;
        i_stick_y_pixel <= 30;
        i_vsync <= 1;
        @(posedge clk);
        i_vsync <= 0;
        check_state(3'd2);

        repeat (4) @(posedge clk);
        // Zone 1: READY -> PATTERN_1.
        i_stick_x_pixel <= 160;
        i_stick_y_pixel <= 195;
        i_vsync <= 1;
        @(posedge clk);
        i_vsync <= 0;
        check_state(3'd3);

        repeat (4) @(posedge clk);
        game_stop <= 1;
        @(posedge clk);
        game_stop <= 0;
        check_state(3'd7);  // STOP (one clock cycle)

        @(posedge clk);
        check_state(3'd0);  // IDLE
        repeat (4) @(posedge clk);
        $display("PASS: 0 -> 1 -> 2 -> 3 -> 7 -> 0");
        $finish;
    end



endmodule
