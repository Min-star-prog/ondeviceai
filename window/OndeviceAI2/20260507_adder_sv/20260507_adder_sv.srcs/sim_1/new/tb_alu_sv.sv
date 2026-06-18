`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/07 14:26:54
// Design Name: 
// Module Name: tb_alu_sv
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
class transaction;

    rand bit [7:0] a;
    rand bit [7:0] b;
    rand bit       mode;  //0: sum, 1:sub
    bit      [7:0] s;
    bit            c;

    function debug_print(string name);
        $display("%t : [%s] a = %d, b = %d, mode = %d, s = %0d, c = %d", $time,
                 name, a, b, mode, $signed(s), c);
    endfunction

    // constraint in_range {
    //     a > 128;
    //     b > 250;
    //         }

    constraint in_range {a inside {[0 : 127]};}

    constraint in_b {
        if (mode == 0)
        b inside {0, 1, 2, 3, 15, 31, 250};
        else
        b > 128;
    }

    constraint mode_distribute {
        mode dist {
            0 :/ 80,
            1 :/ 20
        };
    }

endclass


interface adder_interface ();

    logic [7:0] a;
    logic [7:0] b;
    logic       mode;  //0: sum, 1:sub
    logic [7:0] s;
    logic       c;

endinterface

//to generate random stimulus
class generator;

    transaction tr;
    mailbox #(transaction) gen2drv_mbox;
    event event_gen_next;
    function new(mailbox#(transaction) gen2drv_mbox, event event_gen_next);
        this.gen2drv_mbox   = gen2drv_mbox;
        this.event_gen_next = event_gen_next;
    endfunction

    task run(int count);
        repeat (count) begin
            tr = new();
            tr.randomize();
            tr.debug_print("GEN");
            gen2drv_mbox.put(tr);
            @(event_gen_next);  //event가 올때까지 기다림
        end
        $display("GEN end task");
    endtask

endclass

//to drive by interface stimulus
class driver;
    transaction tr;  //handler. type은 transaction
    virtual adder_interface adder_vif;
    mailbox #(transaction) gen2drv_mbox;
    event event_gen_next;
    function new(
        mailbox #(transaction) gen2drv_mbox,  // mailbox의 data type은 transaction
        event event_gen_next, virtual adder_interface adder_vinterf);
        this.adder_vif = adder_vinterf;
        this.event_gen_next = event_gen_next;
        this.gen2drv_mbox = gen2drv_mbox;
    endfunction

    task run();
        forever begin
            gen2drv_mbox.get(tr);
            tr.debug_print("DRV");
            adder_vif.a    = tr.a;
            adder_vif.b    = tr.b;
            adder_vif.mode = tr.mode;
            #10;
            -> event_gen_next;  // event를 생성해라
        end
        $display("DRV task end");
    endtask
endclass


class monitor;

    transaction tr;
    virtual adder_interface adder_vif;
    mailbox #(transaction) mon2scb_mbox;
    function new(mailbox#(transaction) mon2scb_mbox,
                 virtual adder_interface adder_vinterf);
        this.adder_vif = adder_vinterf;
        this.mon2scb_mbox = mon2scb_mbox;
    endfunction

    task run();
        forever begin
            #5;
            tr = new;
            tr.a = adder_vif.a;
            tr.b = adder_vif.b;
            tr.mode = adder_vif.mode;
            tr.s = adder_vif.s;
            tr.c = adder_vif.c;
            mon2scb_mbox.put(tr);
            tr.debug_print("MON");
            #5;
        end
    endtask

endclass

class scoreboard;
    transaction tr;
    mailbox #(transaction) mon2scb_mbox;
    int total_cnt = 0, pass_cnt = 0, fail_cnt = 0 ;

    function new(mailbox#(transaction) mon2scb_mbox);
        this.mon2scb_mbox = mon2scb_mbox;
    endfunction
    task run();
    bit [7:0] expected_s;
    bit expected_c;

        forever begin
            mon2scb_mbox.get(tr);
            tr.debug_print("SCB");
            //pass / fail decision
            total_cnt++;
            // to calculate
            if (tr.mode) begin
                {expected_c,expected_s} = tr.a - tr.b;
            end else begin
                {expected_c,expected_s} = tr.a + tr.b;
            end
            // compare between expected data and monitor data
            if ((tr.s == expected_s) && (tr.c == expected_c))begin
                $display("%t, [pass] !!", $time);
                pass_cnt ++;
            end else begin
                $display("%t, [fail] !! mode = %d, a = %d, b = %d, sum = %d, carry = %d",$time, tr.mode, tr.a, tr.b, tr.s, tr.c);
                fail_cnt++;
            end
        end
    endtask

endclass


//manager
class environment;
    generator              gen;
    driver                 drv;
    monitor                mon;
    scoreboard             scb;
    mailbox #(transaction) gen2drv_mbox;
    mailbox #(transaction) mon2scb_mbox;
    event                  event_gen_next;

    function new(virtual adder_interface adder_vif);
        gen2drv_mbox = new;
        mon2scb_mbox = new;

        gen = new(gen2drv_mbox, event_gen_next);
        drv = new(gen2drv_mbox, event_gen_next, adder_vif);
        mon = new(mon2scb_mbox, adder_vif);
        scb = new(mon2scb_mbox);

    endfunction

    task run(int count);  // 딱 1번 돔.
        fork
            gen.run(20);
            drv.run();
            mon.run();
            scb.run();
        join_any
        $display("ENV fork join_any end");
        $display("______________________");
        $display("** Adder Verilfication **");
        $display("** total_test = %5d    **",scb.total_cnt);
        $display("** pass count = %5d    **",scb.pass_cnt);
        $display("** fail count = %5d    **",scb.fail_cnt);
        $display("************************");
    endtask
endclass


module tb_alu_sv ();



    adder_interface adder_if ();
    environment env;

    adder dut (
        .a   (adder_if.a),
        .b   (adder_if.b),
        .mode(adder_if.mode),  //0: sum, 1:sub
        .s   (adder_if.s),
        .c   (adder_if.c)
    );


    initial begin
        env = new(adder_if);
        env.run(10);
        $stop;
    end



endmodule
