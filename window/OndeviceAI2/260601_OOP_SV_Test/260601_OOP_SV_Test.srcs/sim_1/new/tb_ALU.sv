`timescale 1ns / 1ps


interface alu_intf;

    logic [7:0] a;
    logic [7:0] b;
    logic       opcode;
    logic [7:0] result;


endinterface  //interfacename

class tester;
    virtual alu_intf alu_if;

    function new(virtual alu_intf alu_if);
        this.alu_if = alu_if;  //물리적인 interface가 아님 -> virtaul
    endfunction

    task add_test(logic [7:0] add_a, logic [7:0] add_b);
        alu_if.opcode = 1'b0;
        alu_if.a = add_a;
        alu_if.b = add_b;
    endtask

    task sub_test(logic [7:0] sub_a, logic [7:0] sub_b);
        alu_if.opcode = 1'b1;
        alu_if.a = sub_a;
        alu_if.b = sub_b;
    endtask
endclass

module tb_ALU ();

    alu_intf alu_if ();     //얘는 물리적인 interface임.


    logic [7:0] a;
    logic [7:0] b;
    logic       opcode;
    logic [7:0] result;



    ALU dut (
        .a     (alu_if.a),
        .b     (alu_if.b),
        .opcode(alu_if.opcode),
        .result(alu_if.result)
    );
        tester BTS;
        tester BlackPink;

    initial begin
        alu_if.opcode = 0;
        alu_if.a = 0;
        alu_if.b = 0;
        #10;
        BTS = new(alu_if); //생성자(메모리에 올라감), BTS라는 Tester 객체 생성, interface 연결.
        BlackPink = new(alu_if);
        #10;
        BTS.add_test(10,20);
        #10;
        BTS.sub_test(10,5);
        #10;
        BlackPink.add_test(4,6);
        #10;
        BlackPink.add_test(6,4);
        #10;
    end

endmodule
//interface 안만들어도 되긴했었네
