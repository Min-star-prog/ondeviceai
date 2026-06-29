`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/25 13:29:22
// Design Name: 
// Module Name: tb_timecounter
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


module tb_time_counter ();

    logic clk;
    logic rst_n;
    logic cnt_en;
    logic intr_en;
    logic cnt_valid;
    logic [31:0] psc;
    logic [31:0] arr;
    logic [31:0] i_cnt;
    logic [31:0] o_cnt;
    logic intr;

    timer_counter dut (.*);



    task tim_setpsc(logic [31:0] prescale);
        psc = prescale;
    endtask

    task tim_setarr(logic [31:0] autoreload);
        arr = autoreload;
    endtask

    task tim_entimer();
        cnt_en = 1;
    endtask

    task tim_distimer();
        cnt_en = 0;
    endtask

    task tim_enintr();
        intr_en = 1;
    endtask

    task tim_disintr();
        intr_en = 0;
    endtask

    task tim_setcnt(logic [31:0] cntcnt);
        i_cnt = cntcnt;
        cnt_valid = 1'b1;
        @(posedge clk);
        cnt_valid = 1'b0;

    endtask

    always #5 clk = ~clk;
    initial begin
        clk   = 0;
        rst_n = 0;
        cnt_valid = 1'b0;
        i_cnt = 0;
        arr = 0;
         psc = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        tim_setpsc(100 - 1);  //output 1MHz
        tim_setarr(1000 - 1);  //output 1KHz
        tim_entimer();
        tim_disintr();
        wait (o_cnt == 999);
        @(posedge clk);
        wait (o_cnt == 0);
        @(posedge clk);
        tim_enintr();
        wait (o_cnt == 999);
        @(posedge clk);
        wait (o_cnt == 100);
        @(posedge clk);
        tim_setcnt(10);
        wait (o_cnt == 0);
        @(posedge clk);
//        tim_distimer();
        #1100;
        $finish;









    end




endmodule
