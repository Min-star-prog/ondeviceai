`include "uvm_macros.svh"
import uvm_pkg::*;


interface ram_intf(
    input logic clk
);

logic we;
logic [7:0] addr;
logic [7:0] wdata;
logic [7:0] rdata;
endinterface

class ram_seq_item extends uvm_sequence_item;
rand logic we;
rand logic [7:0] addr;
rand logic [7:0] wdata;
logic [7:0] rdata;

function new (string name = "ram_seq_item");
    super.new(name);
endfunction


`uvm_object_utils_begin(ram_seq_item)
    `uvm_field_int(we,UVM_DEFAULT)
    `uvm_field_int(addr,UVM_DEFAULT)
    `uvm_field_int(wdata,UVM_DEFAULT)
    `uvm_field_int(rdata,UVM_DEFAULT)
`uvm_object_utils_end

endclass

class ram_sequence extends uvm_sequence#(ram_seq_item);
`uvm_object_utils(ram_sequence)
ram_seq_item item;


function new (string name = "ram_sequence");
    super.new(name);
endfunction

virtual task body();
    item = ram_seq_item::type_id::create("item");
    repeat(200) begin
        start_item(item);
        if(!item.randomize()) begin `uvm_error(get_name(),"Randomize Failed") end
        `uvm_info(get_name(),"Data send to Driver",UVM_NONE)
        finish_item(item);
    end

endtask

endclass

class ram_driver extends uvm_driver#(ram_seq_item);
`uvm_component_utils(ram_driver)

virtual ram_intf ram_vif;
ram_seq_item item;


function new(string name ="ram_driver",uvm_component c);
    super.new(name,c);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ram_intf)::get(this,"*","ram_vif",ram_vif)) 
        `uvm_error(get_name(), "Unable to access ram interface")
endfunction

virtual task run_phase(uvm_phase phase);
    $display("Display Driver run phase");
    forever begin
    seq_item_port.get_next_item(item);
    ram_vif.we <= item.we;
    ram_vif.addr <= item.addr;
    ram_vif.wdata <= item.wdata;
    #10;
    seq_item_port.item_done();
    end
endtask

endclass

class ram_monitor extends uvm_monitor;
`uvm_component_utils(ram_monitor)

uvm_analysis_port #(ram_seq_item) send;
virtual ram_intf ram_vif;
ram_seq_item item;

function new (string name = "ram_monitor", uvm_component c);
    super.new(name,c);
    send = new("send",this);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item = ram_seq_item::type_id::create("item",this);
    if(!uvm_config_db#(virtual ram_intf)::get(this,"*","ram_vif",ram_vif)) 
        `uvm_error(get_name(), "Unable to access ram interface")
    
endfunction



virtual task run_phase(uvm_phase phase);

forever begin
    @(posedge ram_vif.clk);
    #1;
    item.we = ram_vif.we;
    item.addr = ram_vif.addr;
    item.wdata = ram_vif.wdata;
    item.rdata = ram_vif.rdata;
    `uvm_info(get_name(),"Send data to Scoreboard",UVM_LOW)
    send.write(item);
end
endtask


endclass

class ram_agent extends uvm_agent;
`uvm_component_utils(ram_agent);

ram_driver drv;
ram_monitor mon;
uvm_sequencer#(ram_seq_item) sqr;

function new(string name = "ram_agent",uvm_component c);
    super.new(name, c);
endfunction


function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = ram_driver::type_id::create("drv",this);
    mon = ram_monitor::type_id::create("mon",this);
    sqr = uvm_sequencer#(ram_seq_item)::type_id::create("sqr",this);
    
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);     //보내는 쪽.connect(받는 쪽) //// 이건 drv가 요청을 하면 sqr가 item을 보내주는 것이기 때문에
endfunction

endclass

class ram_scoreboard extends uvm_scoreboard;
`uvm_component_utils(ram_scoreboard)
uvm_analysis_imp #(ram_seq_item,ram_scoreboard) recv;


int total_cnt = 0; int pass_cnt = 0; int fail_cnt = 0; 
logic [7:0] mem [0:255];
logic valid [0:255];

function new(string name = "ram_scoreboard",uvm_component c);
    super.new(name,c);
    recv = new("read",this);
endfunction

//we, addr, wdata, rdata
function void write (ram_seq_item data);
    `uvm_info(get_name(), "Data received from monitor",UVM_LOW);
    total_cnt++;
    if(data.we) begin
            mem[data.addr] = data.wdata;
            valid[data.addr] = 1'b1;
    end else if (valid[data.addr]) begin
        if(mem[data.addr] == data.rdata) begin
            pass_cnt++;
            `uvm_info(get_name(),$sformatf("PASS!, :%0d addr, %0d wdata, %0d rdata", data.addr,data.wdata,data.rdata),UVM_LOW)
        end else begin
            fail_cnt++;
            `uvm_error(get_name(),$sformatf("FAIL!, :%0d addr, %0d wdata, %0d rdata", data.addr,data.wdata,data.rdata))
        end

    end
    endfunction


    virtual function void report_phase(uvm_phase phase);
        `uvm_info("SCOREBOARD", $sformatf(
                  "Final Report: %0d total, %0d pass, %0d fail", total_cnt, pass_cnt, fail_cnt),
                  UVM_LOW)
    endfunction



endclass 

class ram_env extends uvm_env;
`uvm_component_utils(ram_env)

ram_agent agt;
ram_scoreboard scb;

function new(string name = "ram_env", uvm_component c);
    super.new(name,c);
endfunction
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = ram_agent::type_id::create("agt",this);
    scb = ram_scoreboard::type_id::create("scb",this);

endfunction

function void connect_phase(uvm_phase phase);
    agt.mon.send.connect(scb.recv);
endfunction
endclass






class ram_test extends uvm_test;
`uvm_component_utils(ram_test)

ram_sequence seq;
ram_env env;
virtual ram_intf ram_vif;

function new(string name = "ram_test", uvm_component c);
    super.new(name,c);
    
endfunction

function void build_phase(uvm_phase phase);
    seq = ram_sequence::type_id::create("seq",this);
    env = ram_env::type_id::create("env",this);
endfunction

virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
        seq.start(env.agt.sqr);
    phase.drop_objection(this);

endtask

    virtual function void report_phase(uvm_phase phase);
        uvm_top.print_topology();  //UVM frame 구조 report로 출력.
    endfunction

endclass 







module tb_ram();



logic clk;


ram_intf ram_if(clk);

ram dut(
    .clk(clk),
    .we(ram_if.we),
    .addr(ram_if.addr),
    .wdata(ram_if.wdata),
    .rdata(ram_if.rdata)
);


always #5 clk = ~clk;

initial begin

clk = 0;
$fsdbDumpfile("wave_ram.fsdb");
$fsdbDumpvars(0);
$fsdbDumpMDA();
end


initial begin

uvm_config_db#(virtual ram_intf)::set(null,"*","ram_vif", ram_if);
run_test("ram_test");
end




endmodule