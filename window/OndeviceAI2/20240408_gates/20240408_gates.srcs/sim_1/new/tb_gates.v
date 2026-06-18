`timescale 1ns / 1ps
// test simulation environment module


module tb_gates ();


    reg a, b;
    wire Y0, Y1, Y2, Y3, Y4, Y5, Y6;

    gates dut (
        .a (a),
        .b (b),
        .Y0(Y0),
        .Y1(Y1),
        .Y2(Y2),
        .Y3(Y3),
        .Y4(Y4),
        .Y5(Y5),
        .Y6(Y6)

    );


    initial begin
        a = 0;
        b = 0;
        #10;
        a = 0;
        b = 1;
        #10;
        a = 1;
        b = 0;
        #10;
        a = 1;
        b = 1;
        #10;
        a = 1;
        b = 1;
        $finish; // 마지막 1,1의 결과는 안 보임.

    end



endmodule
