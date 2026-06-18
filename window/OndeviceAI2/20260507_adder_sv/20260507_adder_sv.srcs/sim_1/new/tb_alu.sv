`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/07 10:30:34
// Design Name: 
// Module Name: tb_alu
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


class generator; 
    transaction tr;

    virtual adder_interface adder_vif; //SW?? ?—°ê²°í•´?•¼?˜?‹ˆê¹? Swê°? HW interface?? ë¶™ì´ê¸? ?œ„?•œ ?„¤? •
                                       //virtual?? class?—ë§? ?“°ì§? ?•Šê³? ?‹¤ë¥¸ë°?„ ??. ?‹¤ì²´ê? ?‚˜?•œ?…Œ ?—†?œ¼ë©? virtual
    function new(
        virtual adder_interface adder_vinterf
    );  // ?´ ?•ˆ?—?„œ ?“°ê¸? ?œ„?•œ ?„¤? •
        adder_vif = adder_vinterf;  //
        tr        = new;  // 
    endfunction

    task run(int repeat_count);
        repeat (repeat_count) begin
            tr.randomize(); // rand ?‚¤?›Œ?“œ ?ˆ?Š” ë³??ˆ˜?“¤ random ê°’ì„ ?ƒ?„±?•´ì¤?
            adder_vif.a = tr.a;
            adder_vif.b = tr.b;
            adder_vif.mode = tr.mode;
            #10;
        end
    endtask

endclass


module tb_alu ();

    adder_interface adder_if ();
    generator gen; //? •?  ?• ?‹¹ : generator?¼?Š” classë¥? ?„ ?–¸?•œ ê±? . gen = handler

    adder dut (
        .a   (adder_if.a),
        .b   (adder_if.b),
        .mode(adder_if.mode),  //0: sum, 1:sub
        .s   (adder_if.s),
        .c   (adder_if.c)
    );


    initial begin
        gen = new(adder_if);  // ?™?  ?• ?‹¹ : new?¼?Š” ?ƒ?„±?ë¡? ?ƒ?„±?•´ì£¼ëŠ” ê±°ì„. ?œ„?— function newê°? ë¶ˆë¦¼
        gen.run(10);  //gen?•ˆ?— ?ˆ?Š” run ?‹¤?–‰
        $stop;
    end

endmodule




