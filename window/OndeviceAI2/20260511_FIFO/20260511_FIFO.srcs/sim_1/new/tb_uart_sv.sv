// `timescale 1ns / 1ps


// class transaction;

//     rand bit [7:0] send_data;
//     bit      [7:0] tx_data;
//     bit       rx;
//     bit       tx;

//     bit       tx_start;
//     bit       tx_busy;

//     bit       rx_done;
//     bit [7:0] rx_data;

//     function debug_print(string name);
//         $display(
//             "%t : %s : send_data = %d, rx_data = %d, tx_start = %d, tx_data = %d, tx = %d, tx_busy = %d"
//             , $time, name, send_data, rx_data, tx_start, tx_data, tx, tx_busy);
//     endfunction
// endclass

// interface uart_loopback_interface;

//     logic       clk;
//     logic       rst;
//     logic       tx;
//     logic       rx;
//     logic       b_tick;

//     logic       tx_start;
//     logic       tx_busy;
//     logic [7:0] tx_data;

//     logic       rx_done;
//     logic [7:0] rx_data;

// endinterface


// class generator;
//     transaction            tr;
//     mailbox #(transaction) gen2drv_mbox;
//     int                    count           = 0;
//     event                  event_gen_next;
//     function new(mailbox#(transaction) gen2drv_mbox, event event_gen_next);
//         this.gen2drv_mbox   = gen2drv_mbox;
//         this.event_gen_next = event_gen_next;
//     endfunction

//     task run(int count);
//         repeat (count) begin
//             tr = new;
//             tr.randomize();
//             gen2drv_mbox.put(tr);
//             tr.debug_print("GEN");
//             @(event_gen_next);
//         end
//     endtask
// endclass





// class driver;
//     transaction tr;
//     mailbox #(transaction) gen2drv_mbox;
//     virtual uart_loopback_interface uart_loopback_vif;


//     function new(mailbox#(transaction) gen2drv_mbox,
//                  virtual uart_loopback_interface uart_loopback_vif);
//         this.gen2drv_mbox = gen2drv_mbox;
//         this.uart_loopback_vif = uart_loopback_vif;
//     endfunction

//     task preset();
//         uart_loopback_vif.rst = 1;
//         uart_loopback_vif.rx  = 0;

//         @(posedge uart_loopback_vif.clk);
//         @(posedge uart_loopback_vif.clk);
//         uart_loopback_vif.rst = 0;

//         @(negedge uart_loopback_vif.clk);

//     endtask

//     task send_uart_byte(input bit [7:0] send_data);
//         // start bit
//         uart_loopback_vif.rx <= 1'b0;
//         repeat (16) @(posedge uart_loopback_vif.b_tick);
//         // data bit, LSB first
//         for (int i = 0; i < 8; i++) begin
//             uart_loopback_vif.rx <= send_data[i];
//             repeat (16) @(posedge uart_loopback_vif.b_tick);
//         end
//         // stop bit
//         uart_loopback_vif.rx <= 1'b1;
//         repeat (16) @(posedge uart_loopback_vif.b_tick);
//     endtask

//     task run();
//         forever begin
//             gen2drv_mbox.get(tr);
//             tr.debug_print("DRV");
//             @(posedge uart_loopback_vif.clk);
//             #1;
//             send_uart_byte(tr.send_data);
//         end
//     endtask
// endclass


// class monitor;

//     transaction tr;
//     mailbox #(transaction) mon2scb_mbox;
//     virtual uart_loopback_interface uart_loopback_vif;
//     function new(mailbox#(transaction) mon2scb_mbox,
//                  virtual uart_loopback_interface uart_loopback_vif);
//         this.mon2scb_mbox = mon2scb_mbox;
//         this.uart_loopback_vif = uart_loopback_vif;
//     endfunction

//     task run();
//         forever begin
//             @(posedge uart_loopback_vif.rx_done);

//             tr = new;
//             tr.tx_data = uart_loopback_vif.tx_data;
//             tr.send_data = uart_loopback_vif.rx_data;
//             mon2scb_mbox.put(tr);
//             tr.debug_print("MON");

//         end
//     endtask
// endclass


// class scoreboard;

//     mailbox #(transaction) mon2scb_mbox;
//     event event_gen_next;

//     transaction tr;

//     int pass_cnt;
//     int fail_cnt;
//     int total_cnt;

//     function new(mailbox#(transaction) mon2scb_mbox, event event_gen_next);
//         this.mon2scb_mbox   = mon2scb_mbox;
//         this.event_gen_next = event_gen_next;
//     endfunction

//     task run();
//         forever begin
//             mon2scb_mbox.get(tr);
//             total_cnt++;

//             if (tr.tx_data == tr.send_data) begin
//                 pass_cnt++;
//                 $display("%0t [SCB] PASS send_data=%d tx_data=%d", $time, tr.send_data,
//                          tr.tx_data);
//             end else begin
//                 fail_cnt++;
//                 $display("%0t [SCB] FAIL send_data=%d tx_data=%d", $time, tr.send_data,
//                          tr.tx_data);
//             end
//             ->event_gen_next;
//         end
//     endtask
// endclass



// class environment;
//     transaction tr;
//     generator gen;
//     driver drv;
//     monitor mon;
//     scoreboard scb;

//     mailbox #(transaction) mon2scb_mbox;
//     mailbox #(transaction) gen2drv_mbox;

//     event event_gen_next;

//     function new(virtual uart_loopback_interface uart_loopback_vif);
//         gen2drv_mbox = new;
//         mon2scb_mbox = new;
//         gen = new(gen2drv_mbox, event_gen_next);
//         drv = new(gen2drv_mbox, uart_loopback_vif);
//         mon = new(mon2scb_mbox, uart_loopback_vif);
//         scb = new(mon2scb_mbox, event_gen_next);
//     endfunction

//     task run();
//         //ram interface initial
//         drv.preset();
//         fork
//             gen.run(10);
//             drv.run();
//             mon.run();
//             scb.run();
//         join_any
//         #10;
//         $display("env run task end");

//         $display("________________________");
//         $display("** UART IP Verificaiton **");
//         $display("** total test num = %2d ***",scb.total_cnt);
//         $display("** Pass test num = %2d ***",scb.pass_cnt);
//         $display("** Fail test num = %2d ***",scb.fail_cnt);
//         $display("*************************");
//         $stop;

//     endtask

// endclass





// module tb_uart_sv();


//     uart_loopback_interface uart_loopback_if ();
//     environment env;


//     uart_loopback U_UART(
//         .clk(uart_loopback_if.clk),
//         .rst(uart_loopback_if.rst),
//         .rx (uart_loopback_if.rx),
//         .tx (uart_loopback_if.tx)
//     );

//     assign uart_loopback_if.tx_busy  = U_UART.U_UART_TOP.tx_busy;
//     assign uart_loopback_if.rx_done  = U_UART.U_UART_TOP.rx_done;
//     assign uart_loopback_if.rx_data  = U_UART.U_UART_TOP.rx_data;
//     assign uart_loopback_if.tx_data  = U_UART.U_UART_TOP.tx_data;
//     assign uart_loopback_if.tx_start = U_UART.w_tx_start;
//     assign uart_loopback_if.b_tick = U_UART.U_UART_TOP.U_UART_TX.b_tick;

//     always #5 uart_loopback_if.clk = ~uart_loopback_if.clk;

//     initial begin
//         uart_loopback_if.clk = 0;
//         env = new(uart_loopback_if);
//         env.run();
//     end

// endmodule









// // rx_done 뜨면 비교

// `timescale 1ns / 1ps


// class transaction;

//     rand bit [7:0] send_data;
//     bit      [7:0] tx_data;
//     bit            rx;
//     bit            tx;

//     bit            tx_start;
//     bit            tx_busy;

//     bit            rx_done;
//     bit      [7:0] rx_data;

//     function debug_print(string name);
//         $display(
//             "%t : %s : send_data = %d, rx_data = %d, tx_start = %d, tx_data = %d, tx = %d, tx_busy = %d"
//             , $time, name, send_data, rx_data, tx_start, tx_data, tx, tx_busy);
//     endfunction
// endclass

// interface uart_loopback_interface;

//     logic       clk;
//     logic       rst;
//     logic       tx;
//     logic       rx;
//     logic       b_tick;

//     logic       tx_start;
//     logic       tx_busy;
//     logic [7:0] tx_data;

//     logic       rx_done;
//     logic [7:0] rx_data;

// endinterface


// class generator;
//     transaction            tr;
//     mailbox #(transaction) gen2scb_mbox;
//     mailbox #(transaction) gen2drv_mbox;
//     int                    count           = 0;
//     event                  event_gen_next;
//     function new(mailbox#(transaction) gen2drv_mbox,
//                  mailbox#(transaction) gen2scb_mbox, event event_gen_next);
//         this.gen2scb_mbox   = gen2scb_mbox;
//         this.gen2drv_mbox   = gen2drv_mbox;
//         this.event_gen_next = event_gen_next;
//     endfunction

//     task run(int count);
//         repeat (count) begin
//             tr = new;
//             tr.randomize();
//             gen2scb_mbox.put(tr);
//             gen2drv_mbox.put(tr);
//             tr.debug_print("GEN");
//             @(event_gen_next);
//         end
//     endtask
// endclass





// class driver;
//     transaction tr;
//     mailbox #(transaction) gen2drv_mbox;
//     virtual uart_loopback_interface uart_loopback_vif;


//     function new(mailbox#(transaction) gen2drv_mbox,
//                  virtual uart_loopback_interface uart_loopback_vif);
//         this.gen2drv_mbox = gen2drv_mbox;
//         this.uart_loopback_vif = uart_loopback_vif;
//     endfunction

//     task preset();
//         uart_loopback_vif.rst = 1;
//         uart_loopback_vif.rx  = 0;

//         @(posedge uart_loopback_vif.clk);
//         @(posedge uart_loopback_vif.clk);
//         uart_loopback_vif.rst = 0;

//         @(negedge uart_loopback_vif.clk);

//     endtask

//     task send_uart_byte(input bit [7:0] send_data);
//         // start bit
//         uart_loopback_vif.rx <= 1'b0;
//         repeat (16) @(posedge uart_loopback_vif.b_tick);
//         // data bit, LSB first
//         for (int i = 0; i < 8; i++) begin
//             uart_loopback_vif.rx <= send_data[i];
//             repeat (16) @(posedge uart_loopback_vif.b_tick);
//         end
//         // stop bit
//         uart_loopback_vif.rx <= 1'b1;
//         repeat (16) @(posedge uart_loopback_vif.b_tick);
//     endtask

//     task run();
//         forever begin
//             gen2drv_mbox.get(tr);
//             tr.debug_print("DRV");
//             @(posedge uart_loopback_vif.clk);
//             #1;
//             send_uart_byte(tr.send_data);
//         end
//     endtask
// endclass


// class monitor;

//     transaction tr;
//     mailbox #(transaction) mon2scb_mbox;
//     virtual uart_loopback_interface uart_loopback_vif;
//     function new(mailbox#(transaction) mon2scb_mbox,
//                  virtual uart_loopback_interface uart_loopback_vif);
//         this.mon2scb_mbox = mon2scb_mbox;
//         this.uart_loopback_vif = uart_loopback_vif;
//     endfunction


//     task run();
//         forever begin
//             @(posedge uart_loopback_vif.rx_done);

//             tr = new;
//             tr.tx_data = uart_loopback_vif.tx_data;
//             tr.rx_data = uart_loopback_vif.rx_data;
//             mon2scb_mbox.put(tr);
//             tr.debug_print("MON");

//         end
//     endtask
// endclass


// class scoreboard;

//     mailbox #(transaction) gen2scb_mbox;
//     mailbox #(transaction) mon2scb_mbox;
//     event event_gen_next;

//     transaction gen_tr;
//     transaction mon_tr;

//     int pass_cnt;
//     int fail_cnt;
//     int total_cnt;

//     function new(mailbox#(transaction) mon2scb_mbox,
//                  mailbox#(transaction) gen2scb_mbox, event event_gen_next);
//         this.gen2scb_mbox   = gen2scb_mbox;
//         this.mon2scb_mbox   = mon2scb_mbox;
//         this.event_gen_next = event_gen_next;
//     endfunction

//     task run();
//         forever begin
//             gen2scb_mbox.get(gen_tr);
//             mon2scb_mbox.get(mon_tr);
//             total_cnt++;

//             if ((mon_tr.rx_data == gen_tr.send_data) && (mon_tr.tx_data == gen_tr.send_data)) begin
//                 pass_cnt++;
//                 $display("%0t [SCB] PASS send_data=%d, rx_data=%d, tx_data=%d",
//                          $time, gen_tr.send_data, mon_tr.rx_data,
//                          mon_tr.tx_data);
//             end else begin
//                 fail_cnt++;
//                 $display("%0t [SCB] FAIL send_data=%d, rx_data=%d, tx_data=%d",
//                          $time, gen_tr.send_data, mon_tr.rx_data,
//                          mon_tr.tx_data);
//             end
//             ->event_gen_next;
//         end
//     endtask
// endclass



// class environment;
//     transaction tr;
//     generator gen;
//     driver drv;
//     monitor mon;
//     scoreboard scb;

//     mailbox #(transaction) gen2scb_mbox;
//     mailbox #(transaction) mon2scb_mbox;
//     mailbox #(transaction) gen2drv_mbox;

//     event event_gen_next;

//     function new(virtual uart_loopback_interface uart_loopback_vif);
//         gen2scb_mbox = new;
//         gen2drv_mbox = new;
//         mon2scb_mbox = new;
//         gen = new(gen2scb_mbox, gen2drv_mbox, event_gen_next);
//         drv = new(gen2drv_mbox, uart_loopback_vif);
//         mon = new(mon2scb_mbox, uart_loopback_vif);
//         scb = new(gen2scb_mbox, mon2scb_mbox, event_gen_next);
//     endfunction

//     task run();
//         //ram interface initial
//         drv.preset();
//         fork
//             gen.run(10);
//             drv.run();
//             mon.run();
//             scb.run();
//         join_any
//         #10;
//         $display("env run task end");

//         $display("________________________");
//         $display("** UART IP Verificaiton **");
//         $display("** total test num = %2d ***", scb.total_cnt);
//         $display("** Pass test num = %2d ***", scb.pass_cnt);
//         $display("** Fail test num = %2d ***", scb.fail_cnt);
//         $display("*************************");
//         $stop;

//     endtask

// endclass





// module tb_uart_sv ();


//     uart_loopback_interface uart_loopback_if ();
//     environment env;


//     uart_loopback U_UART (
//         .clk(uart_loopback_if.clk),
//         .rst(uart_loopback_if.rst),
//         .rx (uart_loopback_if.rx),
//         .tx (uart_loopback_if.tx)
//     );

//     assign uart_loopback_if.tx_busy  = U_UART.U_UART_TOP.tx_busy;
//     assign uart_loopback_if.rx_done  = U_UART.U_UART_TOP.rx_done;
//     assign uart_loopback_if.rx_data  = U_UART.U_UART_TOP.rx_data;
//     assign uart_loopback_if.tx_data  = U_UART.U_UART_TOP.tx_data;
//     assign uart_loopback_if.tx_start = U_UART.w_tx_start;
//     assign uart_loopback_if.b_tick   = U_UART.U_UART_TOP.U_UART_TX.b_tick;

//     always #5 uart_loopback_if.clk = ~uart_loopback_if.clk;

//     initial begin
//         uart_loopback_if.clk = 0;
//         env = new(uart_loopback_if);
//         env.run();
//     end

// endmodule














`timescale 1ns / 1ps


class transaction;

    rand bit [7:0] send_data;
    bit      [7:0] tx_data;
    bit            rx;
    bit            tx;

    bit            tx_start;
    bit            tx_busy;

    bit            rx_done;
    bit      [7:0] rx_data;

    function debug_print(string name);
        $display(
            "%t : %s : send_data = %d, rx_data = %d, tx_start = %d, tx_data = %d, tx = %d, tx_busy = %d"
            , $time, name, send_data, rx_data, tx_start, tx_data, tx, tx_busy);
    endfunction


constraint ascii {send_data inside 
{[8'h41:8'h5A]};
}

endclass

interface uart_loopback_interface;

    logic       clk;
    logic       rst;
    logic       tx;
    logic       rx;
    logic       b_tick;

    logic       tx_start;
    logic       tx_busy;
    logic [7:0] tx_data;

    logic       rx_done;
    logic [7:0] rx_data;

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
    virtual uart_loopback_interface uart_loopback_vif;


    function new(mailbox#(transaction) gen2drv_mbox,
                 virtual uart_loopback_interface uart_loopback_vif);
        this.gen2drv_mbox = gen2drv_mbox;
        this.uart_loopback_vif = uart_loopback_vif;
    endfunction

    task preset();
        uart_loopback_vif.rst = 1;
        uart_loopback_vif.rx  = 0;

        @(posedge uart_loopback_vif.clk);
        @(posedge uart_loopback_vif.clk);
        uart_loopback_vif.rst = 0;

        @(negedge uart_loopback_vif.clk);

    endtask

    task send_uart_byte(input bit [7:0] send_data);
        // start bit
        uart_loopback_vif.rx <= 1'b0;
        repeat (16) @(posedge uart_loopback_vif.b_tick);
        // data bit, LSB first
        for (int i = 0; i < 8; i++) begin
            uart_loopback_vif.rx <= send_data[i];
            repeat (16) @(posedge uart_loopback_vif.b_tick);
        end
        // stop bit
        uart_loopback_vif.rx <= 1'b1;
        repeat (16) @(posedge uart_loopback_vif.b_tick);
    endtask

    task run();
        forever begin
            gen2drv_mbox.get(tr);
            tr.debug_print("DRV");
            @(posedge uart_loopback_vif.clk);
            #1;
            send_uart_byte(tr.send_data);
        end
    endtask
endclass


class monitor;

    transaction tr;
    mailbox #(transaction) mon2scb_mbox;
    virtual uart_loopback_interface uart_loopback_vif;
    function new(mailbox#(transaction) mon2scb_mbox,
                 virtual uart_loopback_interface uart_loopback_vif);
        this.mon2scb_mbox = mon2scb_mbox;
        this.uart_loopback_vif = uart_loopback_vif;
    endfunction



    task receive_uart_byte(output bit [7:0] data);
        // start bit 기다림
        @(negedge uart_loopback_vif.tx);

        // start bit 중앙 근처까지 이동
        repeat (8) @(posedge uart_loopback_vif.b_tick);

        // data bit 8개 샘플링
        for (int i = 0; i < 8; i++) begin
            repeat (16) @(posedge uart_loopback_vif.b_tick);
            data[i] = uart_loopback_vif.tx;
        end

        // stop bit 지나가기
        repeat (16) @(posedge uart_loopback_vif.b_tick);
    endtask


    task run();
        forever begin

            tr = new;
            @(posedge uart_loopback_vif.rx_done);
            tr.rx_data = uart_loopback_vif.rx_data;
            receive_uart_byte(tr.send_data);  //tr.tx_data에 tx 1bit씩 싣기
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

    task run();
        forever begin
            gen2scb_mbox.get(gen_tr);
            mon2scb_mbox.get(mon_tr);
            total_cnt++;

            if ((mon_tr.rx_data == gen_tr.send_data) && (mon_tr.send_data == gen_tr.send_data)) begin
                pass_cnt++;
                $display("%0t [SCB] PASS send_data=%d, rx_data=%d, tx_data=%d",
                         $time, gen_tr.send_data, mon_tr.rx_data,
                         mon_tr.send_data);
            end else begin
                fail_cnt++;
                $display("%0t [SCB] FAIL send_data=%d, rx_data=%d, tx_data=%d",
                         $time, gen_tr.send_data, mon_tr.rx_data,
                         mon_tr.send_data);
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

    function new(virtual uart_loopback_interface uart_loopback_vif);
        gen2scb_mbox = new;
        gen2drv_mbox = new;
        mon2scb_mbox = new;
        gen = new(gen2drv_mbox, gen2scb_mbox, event_gen_next);
        drv = new(gen2drv_mbox, uart_loopback_vif);
        mon = new(mon2scb_mbox, uart_loopback_vif);
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





module tb_uart_sv ();


    uart_loopback_interface uart_loopback_if ();
    environment env;


    uart_loopback U_UART (
        .clk(uart_loopback_if.clk),
        .rst(uart_loopback_if.rst),
        .rx (uart_loopback_if.rx),
        .tx (uart_loopback_if.tx)
    );

    assign uart_loopback_if.tx_busy  = U_UART.U_UART_TOP.tx_busy;
    assign uart_loopback_if.rx_done  = U_UART.U_UART_TOP.rx_done;
    assign uart_loopback_if.rx_data  = U_UART.U_UART_TOP.rx_data;
    assign uart_loopback_if.tx_data  = U_UART.U_UART_TOP.tx_data;
    assign uart_loopback_if.tx_start = U_UART.w_tx_start;
    assign uart_loopback_if.b_tick   = U_UART.U_UART_TOP.U_UART_TX.b_tick;

    always #5 uart_loopback_if.clk = ~uart_loopback_if.clk;

    initial begin
        uart_loopback_if.clk = 0;
        env = new(uart_loopback_if);
        env.run();
    end

endmodule
