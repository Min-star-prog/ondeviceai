`include "uvm_macros.svh"   // UVM macro 코드 다 있음
import uvm_pkg::*;          // UVM package 다 사용하겠다.

class hello_test extends uvm_test;      //UVM
    `uvm_component_utils(hello_test)         
    
    function new(string name = "hello_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("Build_phase", "[1] build_phase run.",UVM_LOW)
    endfunction




    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
     `uvm_info("Connect_phase", "[2] Connect_phase run.",UVM_LOW)

    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
            `uvm_info("Run_phase", "[3] run_phase run.", UVM_LOW)
            `uvm_warning("Hello", "warning 메세지 입니다.!")
            `uvm_error("Hello", "error 메세지 입니다.!")
            `uvm_info("Run_phase", "[4] run_phase stop.",UVM_LOW)

        phase.drop_objection(this);
    endtask

    function void report_phase(uvm_phase phase);
        `uvm_info("Report_phase", "[5] report_phase run.",UVM_LOW)
    
    endfunction

endclass

module test_run();



initial begin
run_test("hello_test");     //uvm trigger 신호

end


endmodule