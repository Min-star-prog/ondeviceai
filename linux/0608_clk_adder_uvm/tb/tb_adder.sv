`include "uvm_macros.svh"
import uvm_pkg::*;


interface adder_if (
    input logic clk,
    input logic rst_n
);

    logic [7:0] a;
    logic [7:0] b;
    logic [8:0] y;

endinterface


class adder_seq_item extends uvm_sequence_item;  //얘는 factory에 등록을 안함.

    rand logic [7:0] a;
    rand logic [7:0] b;
    logic [8:0] y;

    function new(string name = "adder_seq_item");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(adder_seq_item)  //factory 등록. 각각에 대한 변수를 등록.
        `uvm_field_int(a, UVM_ALL_ON)  //UVM_ALL_ON : uvm 전체 다 사용한다.
        `uvm_field_int(b, UVM_ALL_ON)
        `uvm_field_int(y, UVM_ALL_ON)
    `uvm_object_utils_end

    function string convert2string();
        return $sformatf("a=%0d, b=%0d, y=%0d", a, b, y);
    endfunction

endclass


class adder_sequence extends uvm_sequence;
    `uvm_object_utils(adder_sequence)
    int loop_count;


    function new(string name = "adder_seq");
        super.new(name);
    endfunction

    virtual task body();  // 동작점
        adder_seq_item item;
        for (int i = 0; i < loop_count; i++) begin
            item = adder_seq_item::type_id::create(
                $sformatf("item_%0d", i));  //create 안에는 이름 할당하는거임.
            start_item(item);  //sqr에 item 넘겨줌
            if (!item.randomize()) `uvm_fatal(get_type_name(), "Randomization failed")

            finish_item(item);
            `uvm_info(get_type_name(), $sformatf(
                      "[%0d/%0d] %s", i + 1, loop_count, item.convert2string()), UVM_HIGH)
        end
    endtask
endclass



class adder_driver extends uvm_driver #(adder_seq_item);

    `uvm_component_utils(adder_driver)  //내가 만든 class를 factory에 등록

    virtual adder_if a_if;

    function new(string name, uvm_component c);  //
        super.new(name, c);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "a_if", a_if))
            `uvm_fatal(get_type_name(), "a_if를  찾을 수 없습니다")
        `uvm_info(get_type_name(), "build_phase 실행 완료.", UVM_HIGH);

    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    virtual task drive_item(adder_seq_item item);
        @(posedge a_if.clk);
        a_if.a <= item.a;
        a_if.b <= item.b;
        @(posedge a_if.clk);
        @(posedge a_if.clk);
        `uvm_info(get_type_name(), item.convert2string(), UVM_HIGH);
    endtask

    virtual task run_phase(uvm_phase phase);
        adder_seq_item item;
        @(posedge a_if.rst_n);
        forever begin
            seq_item_port.get_next_item(item);
            drive_item(item);
            seq_item_port.item_done();
        end
    endtask


endclass



class adder_monitor extends uvm_monitor;

    `uvm_component_utils(adder_monitor)  //내가 만든 class를 factory에 등록
    uvm_analysis_port #(adder_seq_item) ap;
    virtual adder_if a_if;


    function new(string name, uvm_component c);  //
        super.new(name, c);
        ap = new("ap", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "a_if", a_if))
            `uvm_fatal(get_type_name(), "a_if를  찾을 수 없습니다")
        `uvm_info(get_type_name(), "build_phase 실행 완료.", UVM_HIGH);


    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    virtual task run_phase(uvm_phase phase);
        @(posedge a_if.rst_n);
        forever begin
            adder_seq_item item = adder_seq_item::type_id::create(
                "item"
            );  //handle과 factory에서 객체를 동시에 생성.
            @(posedge a_if.clk);
            @(posedge a_if.clk);
            item.a = a_if.a;
            item.b = a_if.b;
            @(posedge a_if.clk);
            item.y = a_if.y;
            ap.write(item);  //scoreboard에 넘겨줌.
            `uvm_info(get_type_name(), item.convert2string(), UVM_MEDIUM);
        end
    endtask


endclass


class adder_agent extends uvm_agent;

    `uvm_component_utils(adder_agent)  //내가 만든 class를 factory에 등록

    uvm_sequencer #(adder_seq_item) sqr;
    adder_monitor mon;
    adder_driver drv;

    function new(string name, uvm_component c);  //
        super.new(name, c);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = uvm_sequencer#(adder_seq_item)::type_id::create("sqr", this);
        mon = adder_monitor::type_id::create("mon", this);
        drv = adder_driver::type_id::create("drv", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction


endclass


class adder_component1 extends uvm_component;
    `uvm_component_utils(adder_component1)  //내가 만든 class를 factory에 등록
    uvm_analysis_imp #(adder_seq_item, adder_component1) ap_imp_comp1;

    function new(string name, uvm_component c);  //
        super.new(name, c);
        ap_imp_comp1 = new("ap_imp_comp1", this);
    endfunction


    virtual function void write(adder_seq_item item);
        `uvm_info(get_type_name(), $sformatf("      ap_imp_comp1: %s", item.convert2string()),
                  UVM_MEDIUM)

    endfunction
endclass


class adder_component2 extends uvm_component;
    `uvm_component_utils(adder_component2)  //내가 만든 class를 factory에 등록
    uvm_analysis_imp #(adder_seq_item, adder_component2) ap_imp_comp2;

    function new(string name, uvm_component c);  //
        super.new(name, c);
        ap_imp_comp2 = new("ap_imp_comp2", this);
    endfunction
    virtual function void write(adder_seq_item item);
        `uvm_info(get_type_name(), $sformatf("      ap_imp_comp2: %s", item.convert2string()),
                  UVM_MEDIUM)

    endfunction
endclass

class adder_subscriber extends uvm_subscriber #(adder_seq_item);
 `uvm_component_utils(adder_subscriber)

 function new(string name, uvm_component c);
        super.new(name, c);
 endfunction

    virtual function void write(adder_seq_item item);
        `uvm_info(get_type_name(), $sformatf("    adder_subscriber: %s", item.convert2string()),
                  UVM_MEDIUM)
    endfunction

endclass

class adder_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(adder_scoreboard)  //내가 만든 class를 factory에 등록
    uvm_analysis_imp #(adder_seq_item, adder_scoreboard) ap_imp;

    int fail_cnt;
    int pass_cnt;

    function new(string name, uvm_component c);  //
        super.new(name, c);
        ap_imp   = new("ap_imp", this);
        fail_cnt = 0;
        pass_cnt = 0;
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "================== Scoreboard Summary ==============", UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Total transactions: %0d", pass_cnt + fail_cnt),
                  UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Pass : %0d", pass_cnt), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Fail : %0d", fail_cnt), UVM_LOW)

        if (fail_cnt > 0) begin
            `uvm_error(get_type_name(), $sformatf("TEST FAILED: %0d mismatched detected!",
                                                  fail_cnt))

        end else begin
            `uvm_info(get_type_name(), $sformatf("TEST PASSED: %0d all matches detected", pass_cnt),
                      UVM_LOW)
        end
    endfunction


    virtual function void write(adder_seq_item item);
        `uvm_info(get_type_name(), $sformatf("Scoreboard: %s", item.convert2string()), UVM_MEDIUM)
        if (item.y === item.a + item.b) begin
            // `uvm_info(get_type_name(), $sformatf("Mathched!: y:%0d === a:%0d + b:%0d", item.y,
            //                                      item.a, item.b), UVM_MEDIUM)
            pass_cnt++;
        end else begin
            // `uvm_error(get_type_name(), $sformatf(
            //            "MisMathched!: y:%0d === a:%0d + b:%0d", item.y, item.a, item.b))
            fail_cnt++;
        end
    endfunction

endclass

class adder_env extends uvm_env;

    `uvm_component_utils(adder_env)  //내가 만든 class를 factory에 등록
    adder_agent agt;
    adder_scoreboard scb;
    adder_component1 cmp1;
    adder_component2 cmp2;
    adder_subscriber subs;


    function new(string name, uvm_component c);  //
        super.new(name, c);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt   = adder_agent::type_id::create("agt", this);
        scb   = adder_scoreboard::type_id::create("scb", this);
        cmp1 = adder_component1::type_id::create("comp1", this);
        cmp2 = adder_component2::type_id::create("comp2", this);
        subs = adder_subscriber::type_id::create("subs", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.mon.ap.connect(scb.ap_imp);
        agt.mon.ap.connect(cmp1.ap_imp_comp1);
        agt.mon.ap.connect(cmp2.ap_imp_comp2);
        agt.mon.ap.connect(subs.analysis_export);          //subscriber는 uvm_analysis_imp로 안해도 이미 built-in이 있음.
    endfunction



endclass



class adder_test extends uvm_test;

    `uvm_component_utils(adder_test)  //내가 만든 class를 factory에 등록
    adder_env env;

    function new(string name, uvm_component c);  //
        super.new(name, c);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = adder_env::type_id::create("env", this);
        `uvm_info(get_type_name(), "build_phase", UVM_HIGH)
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "connect_phase", UVM_HIGH)
    endfunction

    virtual task run_phase(uvm_phase phase);
        adder_sequence seq;
        `uvm_info(get_type_name(), "adder_sequence seq 실행", UVM_DEBUG)


        phase.raise_objection(this);  //factory 멈추지 마라!
        `uvm_info(get_type_name(), "phase.raise_objection(this) 실행", UVM_DEBUG)
        seq = adder_sequence::type_id::create("seq");
        `uvm_info(get_type_name(), "seq = adder_sequence::type_id::create(seq) 실행", UVM_DEBUG)
        seq.loop_count = 10;
        `uvm_info(get_type_name(), "seq.loop_count = 10 실행", UVM_DEBUG)
        seq.start(env.agt.sqr);  //1. seq와 sqr 연결 2. seq의 body() task 실행
        `uvm_info(get_type_name(), "seq.start(env.agt.sqr) 실행", UVM_DEBUG)

        phase.drop_objection(this);  //factory 멈춰라!
        `uvm_info(get_type_name(), "phase.drop_objection(this) 실행", UVM_DEBUG)
    endtask


    virtual function void report_phase(uvm_phase phase);
        uvm_top.print_topology();  //UVM frame 구조 report로 출력.
    endfunction
endclass


module tb_adder ();
    logic clk, rst_n;

    adder_if a_if (
        clk,
        rst_n
    );

    adder dut (
        .clk(a_if.clk),
        .rst_n(a_if.rst_n),
        .a(a_if.a),
        .b(a_if.b),
        .y(a_if.y)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        rst_n = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;

    end


    initial begin
        uvm_config_db#(virtual adder_if)::set(null, "*", "a_if", a_if);
        run_test("adder_test");

    end


endmodule
