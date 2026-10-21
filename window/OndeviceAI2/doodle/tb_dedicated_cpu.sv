`timescale 1ns / 1ps

module tb_dedicated_cpu;
    logic       clk = 1'b0;
    logic       rst = 1'b1;
    logic [7:0] out;

    dedicated_cpu dut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    always #5 clk = ~clk;

    initial begin
        #12;
        rst = 1'b0;

        repeat (12) @(posedge clk);
        #1;
        assert (out == 8'd9)
            else $fatal(1, "Expected out=9, got out=%0d", out);

        $display("PASS: dedicated_cpu out=%0d", out);
        $finish;
    end
endmodule
