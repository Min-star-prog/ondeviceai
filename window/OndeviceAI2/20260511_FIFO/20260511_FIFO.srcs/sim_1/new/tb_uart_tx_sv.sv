`timescale 1ns / 1ps


class transaction;

    rand bit tx_start;  
    rand bit tx_data;
    bit b_tick;
    bit tx;
    bit tx_busy;

    // function debug_print(string name);
    //     $display(
    //         "%t : %s : tx_start=%d, tx_data = %d, bit =%d, tx = %d, tx_busy = %d"
    //         , $time, name, push_data, tx_start, tx_data, bit, tx, tx_busy);
    // endfunction
endclass

interface uart_tx_interface;

    logic       clk;
    logic       rst;
    logic       tx_start;
    logic [7:0] tx_data;
    logic       b_tick;
    logic       tx;
    logic       tx_busy;

endinterface


class generator;
    transaction            tr;
    mailbox #(transaction) gen2drv_mbox;
    int                    count           = 0;
    event                  event_gen_next;
    function new(mailbox#(transaction) gen2drv_mbox, event event_gen_next);
        this.gen2drv_mbox   = gen2drv_mbox;
        this.event_gen_next = event_gen_next;
    endfunction

    task run(int count);
        repeat (count) begin
            tr = new;
            tr.randomize();
            tr.debug_print("GEN");
            gen2drv_mbox.put(tr);
            @(event_gen_next);
        end
    endtask
endclass





class driver;
    transaction tr;
    mailbox #(transaction) gen2drv_mbox;
    event event_gen_next;
    virtual uart_tx_interface uart_tx_vif;


    function new(mailbox#(transaction) gen2drv_mbox, event event_gen_next,
                 virtual uart_tx_interface uart_tx_vif);
        this.gen2drv_mbox = gen2drv_mbox;
        this.event_gen_next = event_gen_next;
        this.uart_tx_vif = uart_tx_vif;
    endfunction  //new()

    task preset();
        uart_tx_vif.rst       = 1;
        uart_tx_vif.push_data = 0;
        uart_tx_vif.push      = 0;
        uart_tx_vif.pop       = 0;
        @(posedge uart_tx_vif.clk);
        @(posedge uart_tx_vif.clk);
        uart_tx_vif.rst = 0;

        @(negedge uart_tx_vif.clk);

        assert (uart_tx_vif.empty) $display("[DRV Assert] reset pass : empty!");
        else $display("[DRV Assert] reset fail : empty = %d", uart_tx_vif.empty);

        assert (!uart_tx_vif.full) $display("[DRV Assert] reset pass : NOT full!");
        else $display("[DRV Assert] reset fail : full = %d", uart_tx_vif.full);
    endtask  //preset


    task run();
        forever begin
            gen2drv_mbox.get(tr);
            tr.debug_print("DRV");
            @(posedge uart_tx_vif.clk);
            #1;
            uart_tx_vif.push      = tr.push;
            uart_tx_vif.push_data = tr.push_data;
            uart_tx_vif.pop       = tr.pop;
        end
    endtask
endclass





module tb_uart_tx_sv(  );


    uart_tx_interface uart_tx_if ();
    environment env;


 uart_tx U_UART_TX(
    .clk(uart_tx_if.clk),
    .rst(uart_tx_if.rst),
    .tx_start(uart_tx_if.tx_start),  
    .tx_data(uart_tx_if.tx_data),
    .b_tick(uart_tx_if.b_tick),
    .tx(uart_tx_if.tx),
    .tx_busy(uart_tx_if.tx_busy)
);


baud_tick_gen U_BAUD_TICK_GEN(
    .clk(uart_tx_if.clk),
    .rst(uart_tx_if.rst),
    .o_b_tick(uart_tx_if.b_tick)
);

always #5 uart_tx_if.clk = ~uart_tx_if.clk;

initial begin
    uart_tx_if.clk = 0;
    env = new(uart_tx_if);
    env.run();
end

endmodule
