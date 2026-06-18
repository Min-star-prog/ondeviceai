`timescale 1ns / 1ps



class transaction;

    rand bit we;
    rand logic [7:0] addr;
    rand logic [7:0] wdata;
    logic [7:0] rdata;

    function debug_print(string name);
        $display("%t : %s : we=%d,addr=%d,wdata=%d,rdata=%d", $time, name, we,
                 addr, wdata, rdata);
    endfunction

endclass




interface ram_intf (
    input logic clk
);  //clk, rst는 global signal
    logic we;
    logic [7:0] addr;
    logic [7:0] wdata;
    logic [7:0] rdata;
endinterface





class generator;
    transaction            tr;
    mailbox #(transaction) gen2drv_mbox;
    int                    count           = 0;
    event                  event_gen_next;
    function new(mailbox #(transaction) gen2drv_mbox, event event_gen_next);
        this.gen2drv_mbox   = gen2drv_mbox;
        this.event_gen_next = event_gen_next;
    endfunction

    task run(int count);
        repeat (count) begin
            tr = new;
            tr.randomize();
            gen2drv_mbox.put(tr);
            tr.debug_print("GEN");
            @(event_gen_next);
        end
    endtask
endclass


class driver;
    transaction tr;
    mailbox #(transaction) gen2drv_mbox;
    virtual ram_intf ram_if;


    function new(mailbox#(transaction) gen2drv_mbox, virtual ram_intf ram_if);
        this.gen2drv_mbox = gen2drv_mbox;
        this.ram_if = ram_if;
    endfunction  //new()


    task run();
        forever begin
            gen2drv_mbox.get(tr);
            tr.debug_print("DRV");
            ram_if.addr = tr.addr;
            ram_if.wdata = tr.wdata;
            ram_if.we = tr.we;
        end
    endtask
endclass


class monitor;
    transaction tr;
    mailbox #(transaction) mon2scb_mbox;
    virtual ram_intf ram_if;
    function new(mailbox#(transaction) mon2scb_mbox, virtual ram_intf ram_if);
        this.mon2scb_mbox = mon2scb_mbox;
        this.ram_if = ram_if;
    endfunction





    task run();
        forever begin
            @(negedge ram_if.clk);  //예전에 negedge 왜 안 됐지?
            #1;
            tr       = new;
            tr.wdata = ram_if.wdata;
            tr.addr  = ram_if.addr;
            tr.we    = ram_if.we;
            tr.rdata = ram_if.rdata;
            mon2scb_mbox.put(tr);
            tr.debug_print("MON");
        end
    endtask
endclass



class scoreboard;
    transaction tr;
    mailbox #(transaction) mon2scb_mbox;
    event event_gen_next;

    int total_cnt = 0, pass_cnt = 0, fail_cnt = 0;

    logic [7:0] ram_test[0:255];
    logic valid [0:255];



    function new(mailbox#(transaction) mon2scb_mbox, event event_gen_next);
        this.mon2scb_mbox   = mon2scb_mbox;
        this.event_gen_next = event_gen_next;
    endfunction

    task run();
        forever begin
            mon2scb_mbox.get(tr);
            tr.debug_print("SCB");
            total_cnt++;
            if (tr.we) begin
                ram_test[tr.addr] = tr.wdata;
                valid[tr.addr] = 1'b1;
            end else if(valid[tr.addr]) begin
                if (tr.rdata == ram_test[tr.addr]) begin
        $display("PASS addr=%0d rdata=%0d", tr.addr, tr.rdata);
                    pass_cnt++;
                end else begin
                    $display("FAIL addr = %0d, rdata = %0d",tr.addr, tr.rdata);
                    fail_cnt++;
                end
            end
            ->event_gen_next;
        end
    endtask
endclass



class environment;
    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;

    mailbox #(transaction) mon2scb_mbox;
    mailbox #(transaction) gen2drv_mbox;

    event event_gen_next;

    virtual ram_intf ram_if;

    int run_count;

    function new(virtual ram_intf ram_if);
        gen2drv_mbox = new;
        mon2scb_mbox = new;

        gen = new(gen2drv_mbox, event_gen_next);
        drv = new(gen2drv_mbox, ram_if);
        mon = new(mon2scb_mbox, ram_if);
        scb = new(mon2scb_mbox, event_gen_next);

        this.ram_if = ram_if;
    endfunction

    task run();

        @(posedge ram_if.clk);
        #10;
        fork
            gen.run(200);
            drv.run();
            mon.run();
            scb.run();
        join_any
        #20;
        $display("RAM random test end");
        $display("________________________");
        $display("** RAM IP Verificaiton **");
        $display("** total test num = %2d ***", scb.total_cnt);
        $display("** Pass test num = %2d ***", scb.pass_cnt);
        $display("** Fail test num = %2d ***", scb.fail_cnt);
        $display("*************************");
        $stop;

    endtask
endclass



module tb_ram ();


    logic clk;


    ram_intf ram_if (clk);
    environment env;


    ram dut_ram (
        .clk  (ram_if.clk),
        .we   (ram_if.we),
        .addr (ram_if.addr),
        .wdata(ram_if.wdata),
        .rdata(ram_if.rdata)
    );

    always #5 clk = ~clk;


    initial begin

        clk = 0;
        env = new(ram_if);
        ram_if.wdata = 0;
        ram_if.addr = 0;
        ram_if.we = 0;
        env.run();

        $finish;
    end

endmodule
