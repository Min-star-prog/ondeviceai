`timescale 1ns / 1ps

module tb_sub;

    logic       clk;
    logic       rst;

    logic       i_score_en;
    logic       i_pattern_tick;
    logic [7:0] i_speed;
    logic [7:0] i_song_speed;

    logic       score_control_ready;

    logic       score_control_valid;
    logic [3:0] o_score;


    //============================================================
    // DUT
    //============================================================

    game_score dut (
        .clk                 (clk),
        .rst                 (rst),

        .i_score_en          (i_score_en),
        .i_pattern_tick      (i_pattern_tick),
        .i_speed             (i_speed),

        .i_song_speed        (i_song_speed),

        .score_control_ready (score_control_ready),

        .score_control_valid (score_control_valid),
        .o_score             (o_score)
    );


    //============================================================
    // Clock : 100 MHz
    //============================================================

    always #5 clk = ~clk;


    //============================================================
    // 1/4 박자 입력 task
    //============================================================

    task send_speed(input [7:0] speed);
    begin

        @(negedge clk);

        i_speed        = speed;
        i_pattern_tick = 1'b1;

        @(negedge clk);

        i_pattern_tick = 1'b0;

    end
    endtask


    //============================================================
    // Test
    //============================================================

    initial begin

        // --------------------------------------------------------
        // 초기값
        // --------------------------------------------------------
        clk                 = 0;
        rst                 = 1;

        i_score_en          = 0;
        i_pattern_tick      = 0;
        i_speed             = 0;

        i_song_speed        = 8'd100;

        score_control_ready = 1;


        // --------------------------------------------------------
        // Reset
        // --------------------------------------------------------
        #20;

        rst = 0;

        #20;


        // --------------------------------------------------------
        // Game Start
        // 초기 score = 5 (실제 50점)
        // --------------------------------------------------------
        i_score_en = 1;

        @(posedge clk);

        $display("--------------------------------");
        $display("GAME START");
        $display("Initial Score = %0d", o_score);
        $display("--------------------------------");


        // ========================================================
        // TEST 1
        //
        // 최초에는
        //
        // RAM[0] = 100
        // RAM[1] = 100
        // RAM[2] = 106
        // RAM[3] = 110
        //
        // 평균 = 104
        // 원곡 = 100
        // 차이 = 4
        //
        // score : 5 -> 6
        // ========================================================

        $display("\nTEST 1 : First Measure");

        send_speed(8'd106);
        send_speed(8'd110);


        // valid 발생 기다림
        wait(score_control_valid == 1'b1);

        $display(
            "Time = %0t, Score = %0d, Expected = 6",
            $time,
            o_score
        );

        if (o_score == 4'd6)
            $display("TEST 1 PASS");
        else
            $display("TEST 1 FAIL");


        // valid가 내려갈 때까지 기다림
        wait(score_control_valid == 1'b0);


        // ========================================================
        // TEST 2
        //
        // 이후부터는 실제 BPM 4개
        //
        // 130, 130, 130, 130
        //
        // 평균 = 130
        // 원곡 = 100
        // 차이 = 30
        //
        // score : 6 -> 5
        // ========================================================

        $display("\nTEST 2 : Wrong Tempo");

        send_speed(8'd130);
        send_speed(8'd130);
        send_speed(8'd130);
        send_speed(8'd130);


        wait(score_control_valid == 1'b1);

        $display(
            "Time = %0t, Score = %0d, Expected = 5",
            $time,
            o_score
        );

        if (o_score == 4'd5)
            $display("TEST 2 PASS");
        else
            $display("TEST 2 FAIL");


        wait(score_control_valid == 1'b0);


        // ========================================================
        // TEST 3
        //
        // 96, 100, 104, 100
        //
        // 평균 = 100
        // 차이 = 0
        //
        // score : 5 -> 6
        // ========================================================

        $display("\nTEST 3 : Correct Tempo");

        send_speed(8'd96);
        send_speed(8'd100);
        send_speed(8'd104);
        send_speed(8'd100);


        wait(score_control_valid == 1'b1);

        $display(
            "Time = %0t, Score = %0d, Expected = 6",
            $time,
            o_score
        );

        if (o_score == 4'd6)
            $display("TEST 3 PASS");
        else
            $display("TEST 3 FAIL");


        // --------------------------------------------------------
        // Game End
        // --------------------------------------------------------

        wait(score_control_valid == 1'b0);

        i_score_en = 0;

        #50;


        $display("\n================================");
        $display("TEST FINISH");
        $display("================================");

        $finish;

    end

endmodule