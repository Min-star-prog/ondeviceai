`timescale 1ns / 1ps

class transaction;

    rand bit [7:0] send_data;
    bit            rx;
    bit            rx_done;
    bit      [7:0] rx_data;
    bit      [7:0] pop_data;

    bit            R;
    bit            L;
    bit            U;
    bit            D;
    bit      [1:0] M;
    bit      [1:0] T;
    bit            S;

    function debug_print(string name);
        $display("%t : %s : send_data = %d, rx_data = %d, pop_data = %d"
                 , $time, name, send_data, rx_data, pop_data);
    endfunction


    constraint ascii {
        send_data inside {8'h52,  // R
        8'h4C,  // L
        8'h55,  // U
        8'h44,  // D
        8'h4D,  // M
        8'h54,  // T
        8'h53  // S
        };
    }

endclass


interface uart_fifo_decoder_interface;

    logic       clk;
    logic       rst;
    logic       rx;

    logic       b_tick;
    logic       rx_done;
    logic [7:0] rx_data;
    logic [7:0] pop_data;

    logic       R;
    logic       L;
    logic       U;
    logic       D;
    logic [1:0] M;
    logic [1:0] T;
    logic       S;

endinterface


class generator;
    transaction            tr;
    mailbox #(transaction) gen2scb_mbox;
    mailbox #(transaction) gen2drv_mbox;
    int                    count           = 0;
    event                  event_gen_next;
    function new(mailbox#(transaction) gen2drv_mbox,
                 mailbox#(transaction) gen2scb_mbox, event event_gen_next);
        this.gen2scb_mbox   = gen2scb_mbox;
        this.gen2drv_mbox   = gen2drv_mbox;
        this.event_gen_next = event_gen_next;
    endfunction

    task run(int count);
        repeat (count) begin
            tr = new;
            tr.randomize();
            gen2scb_mbox.put(tr);
            gen2drv_mbox.put(tr);
            tr.debug_print("GEN");
            @(event_gen_next);
        end
    endtask
endclass


class driver;
    transaction tr;
    mailbox #(transaction) gen2drv_mbox;
    virtual uart_fifo_decoder_interface uart_fifo_decoder_vif;


    function new(mailbox#(transaction) gen2drv_mbox,
                 virtual uart_fifo_decoder_interface uart_fifo_decoder_vif);
        this.gen2drv_mbox = gen2drv_mbox;
        this.uart_fifo_decoder_vif = uart_fifo_decoder_vif;
    endfunction

    task preset();
        uart_fifo_decoder_vif.rst = 1;
        uart_fifo_decoder_vif.rx  = 0;

        @(posedge uart_fifo_decoder_vif.clk);
        @(posedge uart_fifo_decoder_vif.clk);
        uart_fifo_decoder_vif.rst = 0;

        @(negedge uart_fifo_decoder_vif.clk);

    endtask

    task send_uart_byte(input bit [7:0] send_data);
        // start bit
        uart_fifo_decoder_vif.rx <= 1'b0;
        repeat (16) @(posedge uart_fifo_decoder_vif.b_tick);
        // data bit, LSB first
        for (int i = 0; i < 8; i++) begin
            uart_fifo_decoder_vif.rx <= send_data[i];
            repeat (16) @(posedge uart_fifo_decoder_vif.b_tick);
        end
        // stop bit
        uart_fifo_decoder_vif.rx <= 1'b1;
        repeat (16) @(posedge uart_fifo_decoder_vif.b_tick);
    endtask

    task run();
        forever begin
            gen2drv_mbox.get(tr);
            tr.debug_print("DRV");
            @(posedge uart_fifo_decoder_vif.clk);
            #1;
            send_uart_byte(tr.send_data);
        end
    endtask
endclass


class monitor;

    transaction tr;
    mailbox #(transaction) mon2scb_mbox;
    virtual uart_fifo_decoder_interface uart_fifo_decoder_vif;
    function new(mailbox#(transaction) mon2scb_mbox,
                 virtual uart_fifo_decoder_interface uart_fifo_decoder_vif);
        this.mon2scb_mbox = mon2scb_mbox;
        this.uart_fifo_decoder_vif = uart_fifo_decoder_vif;
    endfunction



    task run();
        forever begin

            tr = new;
            @(posedge uart_fifo_decoder_vif.rx_done);
            tr.rx_data = uart_fifo_decoder_vif.rx_data;
            @(posedge uart_fifo_decoder_vif.clk);
            #1;
            tr.pop_data = uart_fifo_decoder_vif.pop_data;
            @(posedge uart_fifo_decoder_vif.clk);
            #1;
            tr.R = uart_fifo_decoder_vif.R;
            tr.L = uart_fifo_decoder_vif.L;
            tr.U = uart_fifo_decoder_vif.U;
            tr.D = uart_fifo_decoder_vif.D;
            tr.M = uart_fifo_decoder_vif.M;
            tr.T = uart_fifo_decoder_vif.T;
            tr.S = uart_fifo_decoder_vif.S;

            mon2scb_mbox.put(tr);
            tr.debug_print("MON");

        end
    endtask
endclass


class scoreboard;

    mailbox #(transaction) gen2scb_mbox;
    mailbox #(transaction) mon2scb_mbox;
    event event_gen_next;

    transaction gen_tr;
    transaction mon_tr;

    int pass_cnt;
    int fail_cnt;
    int total_cnt;

    function new(mailbox#(transaction) mon2scb_mbox,
                 mailbox#(transaction) gen2scb_mbox, event event_gen_next);
        this.gen2scb_mbox   = gen2scb_mbox;
        this.mon2scb_mbox   = mon2scb_mbox;
        this.event_gen_next = event_gen_next;
    endfunction


    bit exp_R, exp_L, exp_U, exp_D, exp_S;
    bit [1:0] exp_M, exp_T;


    task ascii_expected(input bit [7:0] ascii);

        begin
            exp_R = 0;
            exp_L = 0;
            exp_U = 0;
            exp_D = 0;
            exp_S = 0;
            exp_M = exp_M;
            exp_T = exp_T;
        end

        case (ascii)
            "R": exp_R = 1;
            "L": exp_L = 1;
            "U": exp_U = 1;
            "D": exp_D = 1;
            "M": exp_M = exp_M + 1;
            "T": exp_T = exp_T + 1;
            "S": exp_S = 1;
            default: begin
                exp_R = 0;
                exp_L = 0;
                exp_U = 0;
                exp_D = 0;
                exp_S = 0;
                exp_M = exp_M;
                exp_T = exp_T;
            end
        endcase
    endtask


    task run();
        forever begin
            gen2scb_mbox.get(gen_tr);
            mon2scb_mbox.get(mon_tr);
            total_cnt++;

            ascii_expected(gen_tr.send_data);


            if ((mon_tr.rx_data == gen_tr.send_data) && (mon_tr.pop_data == gen_tr.send_data) 
            && (mon_tr.R == exp_R)
            && (mon_tr.L == exp_L)
            && (mon_tr.U == exp_U)
            && (mon_tr.D == exp_D)
            && (mon_tr.M == exp_M)
            && (mon_tr.T == exp_T)
            && (mon_tr.S == exp_S)) begin
                pass_cnt++;
                $display("%0t [SCB] PASS send_data=%c, rx_data=%c, ascii_data=%c",
                         $time, gen_tr.send_data, mon_tr.rx_data,
                         mon_tr.pop_data);
            end else begin
                fail_cnt++;
                $display("%0t [SCB] FAIL send_data=%c, rx_data=%c, ascii_data=%c",
                         $time, gen_tr.send_data, mon_tr.rx_data,
                         mon_tr.pop_data);
            end
            ->event_gen_next;
        end
    endtask
endclass



class environment;
    transaction tr;
    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;

    mailbox #(transaction) gen2scb_mbox;
    mailbox #(transaction) mon2scb_mbox;
    mailbox #(transaction) gen2drv_mbox;

    event event_gen_next;

    function new(virtual uart_fifo_decoder_interface uart_fifo_decoder_vif);
        gen2scb_mbox = new;
        gen2drv_mbox = new;
        mon2scb_mbox = new;
        gen = new(gen2drv_mbox, gen2scb_mbox, event_gen_next);
        drv = new(gen2drv_mbox, uart_fifo_decoder_vif);
        mon = new(mon2scb_mbox, uart_fifo_decoder_vif);
        scb = new(mon2scb_mbox, gen2scb_mbox, event_gen_next);
    endfunction

    task run();
        //ram interface initial
        drv.preset();
        fork
            gen.run(10);
            drv.run();
            mon.run();
            scb.run();
        join_any
        #10;
        $display("env run task end");

        $display("________________________");
        $display("** UART IP Verificaiton **");
        $display("** total test num = %2d ***", scb.total_cnt);
        $display("** Pass test num = %2d ***", scb.pass_cnt);
        $display("** Fail test num = %2d ***", scb.fail_cnt);
        $display("*************************");
        $stop;

    endtask

endclass





module tb_uart_fifo_decoder_sv ();


    uart_fifo_decoder_interface uart_fifo_decoder_if ();
    environment env;


    uart_fifo_decoder U_UART_FIFO (
        .clk(uart_fifo_decoder_if.clk),
        .rst(uart_fifo_decoder_if.rst),
        .rx (uart_fifo_decoder_if.rx),
        .R  (uart_fifo_decoder_if.R),
        .L  (uart_fifo_decoder_if.L),
        .U  (uart_fifo_decoder_if.U),
        .D  (uart_fifo_decoder_if.D),
        .M  (uart_fifo_decoder_if.M),
        .T  (uart_fifo_decoder_if.T),
        .S  (uart_fifo_decoder_if.S)
    );

    assign uart_fifo_decoder_if.rx_done  = U_UART_FIFO.U_UART_RX_1.rx_done;
    assign uart_fifo_decoder_if.rx_data  = U_UART_FIFO.U_UART_RX_1.rx_data;
    assign uart_fifo_decoder_if.b_tick   = U_UART_FIFO.U_BAUD_TICK_GEN_1.o_b_tick;
    assign uart_fifo_decoder_if.pop_data = U_UART_FIFO.U_FIFO_RX_1.pop_data;

    always #5 uart_fifo_decoder_if.clk = ~uart_fifo_decoder_if.clk;

    initial begin
        uart_fifo_decoder_if.clk = 0;
        env = new(uart_fifo_decoder_if);
        env.run();
    end
endmodule
