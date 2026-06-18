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

    function new();
        tr = new();
    endfunction

    task run();
        tr.randomize();
    endtask

endclass

//to drive by interface stimulus
class driver;
    transaction tr;  //handler. type은 transaction
    virtual adder_interface adder_vif;
    function new(virtual adder_interface adder_vinterf);
        this.adder_vif = adder_vinterf;
    endfunction
    task run();
        adder_vif.a = tr.a;
        adder_vif.b = tr.b;
        adder_vif.mode = tr.mode;
        #10;
    endtask
endclass

//manager
class environment;
    generator gen;
    driver drv;

    function new(virtual adder_interface adder_vif);
        drv = new(adder_vif);
        

    endfunction
endclass


module tb_alu_sv ();



    adder_interface adder_if ();
    generator gen; //정적 할당 : generator라는 class를 선언한 거 . gen = handler

    adder dut (
        .a   (adder_if.a),
        .b   (adder_if.b),
        .mode(adder_if.mode),  //0: sum, 1:sub
        .s   (adder_if.s),
        .c   (adder_if.c)
    );


    initial begin

        $stop;
    end



endmodule
