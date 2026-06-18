`timescale 1ns / 1ps

interface ram_intf;
    logic clk;
    logic we;
    logic [7:0] addr;
    logic [7:0] wdata;
    logic [7:0] rdata;
endinterface






class tester_ram;
    virtual ram_intf ram_if;

    function new(virtual ram_intf ram_if);
        this.ram_if = ram_if;
    endfunction

    task write_test(logic [7:0] addr, logic [7:0] wdata);
        ram_if.we = 1'b1;
        ram_if.wdata = wdata;
        ram_if.addr = addr;
    endtask
    task read_test(logic [7:0] addr);
        ram_if.we   = 1'b0;
        ram_if.addr = addr;
    endtask

endclass

module tb_ram ();

    ram_intf ram_if ();



    ram dut_ram (
        .clk(ram_if.clk),
        .we(ram_if.we),
        .addr(ram_if.addr),
        .wdata(ram_if.wdata),
        .rdata(ram_if.rdata)
    );

    always #5 ram_if.clk = ~ram_if.clk;

    tester_ram BTS;


    initial begin

        ram_if.clk = 0;
        ram_if.wdata = 0;
        ram_if.addr = 0;
        ram_if.we = 0;
        @(negedge ram_if.clk);
        BTS = new(ram_if);

        @(negedge ram_if.clk);
        BTS.write_test(8'h03, 8'h13);

        @(negedge ram_if.clk);
        BTS.write_test(8'h04, 8'h14);

        @(negedge ram_if.clk);
        BTS.write_test(8'h05, 8'h15);

        @(negedge ram_if.clk);
        BTS.read_test(8'h03);

        @(negedge ram_if.clk);
        BTS.read_test(8'h04);

        @(negedge ram_if.clk);
        BTS.read_test(8'h05);

        @(negedge ram_if.clk);
    end

endmodule
