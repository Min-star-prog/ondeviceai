`include "uvm_macros.svh"       // uvm macro(`uvm component_utils, `uvm_info 등등)를 사용하기 위해 include
import uvm_pkg::*;              // uvm_package 안에 있는 class들 사용하기 위해 import (uvm_test, uvm_driver 등등)

interface adder_intf;
//DUT와 testbench 신호 연결
logic [7:0] a;
logic [7:0] b;
logic [8:0] y;

endinterface


class adder_seq_item extends uvm_sequence_item;     //uvm_sequence_item에서 상속받음. component들이 주고 받는 data 단위
        rand logic [7:0] a;     //random 선언
        rand logic [7:0] b;     //random 선언
        logic [8:0] y;
        
    function new(string name = "adder_seq_item");   //생성자
        super.new(name);                            //uvm_sequence_item의 부모 생성자를 call
    endfunction

    `uvm_object_utils_begin(adder_seq_item)     //factory 등록 // item은 uvm_component가 아니라 uvm_object
        `uvm_field_int(a,UVM_DEFAULT)           //uvm_field에 등록
        `uvm_field_int(b,UVM_DEFAULT)
        `uvm_field_int(y,UVM_DEFAULT)
    `uvm_object_utils_end
endclass



class adder_sequence extends uvm_sequence#(adder_seq_item);     //sequence에 item을 넣어서 sequencer에 보냄
        `uvm_object_utils(adder_sequence)                       //factory 등록. sequence는 uvm_component가 아니라 uvm_object

        adder_seq_item seq_item;                            //item handle
        function new(string name = "adder_sequence");       //sequence 생성자. sequence의 new()생성자에는 uvm_component가 안 들어간다(parent 인자가 안 들어간다).
            super.new(name);                                //부모 class의 생성자를 호출
        endfunction

        //얘는 component가 아니라 uvm_object라 phase 대신 body임
        virtual task body();
            seq_item = adder_seq_item::type_id::create("seq_item");     //factory에서 transaction(or item) 객체 생성
            repeat(100) begin                                           //100번
                start_item(seq_item);                                   //sequencer에게 item을 보낸다고 알림.
                if(!seq_item.randomize()) begin                         //a,b 랜덤화
                    `uvm_error("seq_item","Fail to generate random value!")     //a,b 랜덤화 실패 시 error 출력
                end
                `uvm_info("sequence", "Data send to Driver", UVM_NONE)      //data를 driver에 보냈다고 메시지 출력
                finish_item(seq_item);                                      //랜덤화된 item을 sequencer를 통해 driver에게 전달.
            end
        endtask
        

endclass




// item을 받아서 DUT input 신호를 구동하는 class
class adder_driver extends uvm_driver#(adder_seq_item);         //uvm_driver에서 상속받음.item을 argument로 받는다.
    `uvm_component_utils(adder_driver)                          //factory에 등록.

    virtual adder_intf adder_if;                                //interface handler. class이므로 virtual 선언.
    adder_seq_item seq_item;                                    //seq_item handler.


    function new(string name = "adder_drv", uvm_component c = null);       //driver 생성자, component는 parent가 필요
        super.new(name,c);                                                 //부모 class 생성자
    endfunction

    virtual function void build_phase(uvm_phase phase);                    //handler를 만들어 놓은 instance를 factory에서 transaction 객체 생성
        super.build_phase(phase);                                          //부모 class build_phase 호출
        seq_item = adder_seq_item::type_id::create("seq_item", this);      //factory에서 transaction 객체 생성
        if (!uvm_config_db#(virtual adder_intf)::get(this, "", "adder_if", adder_if)) begin     //tb_adder에서 uvm_config_db에 set한 vif를 config_db에서 get
            `uvm_fatal(get_name(), "Unable to access adder interface.")     //vif 못 가져오면 메시지 출력하고 시뮬레이션 중단.
        end
    endfunction

    virtual task run_phase(uvm_phase phase);                               // run_phase 
        $display("Display run phase");                                     // run_phase 시작 시에 출력
        forever begin                                                      //시뮬레이션 동안 계속 실행
            seq_item_port.get_next_item(seq_item);                         //sequencer로부터 item 1개 받음
            adder_if.a <= seq_item.a;                                      //받은 item 값을 DUT input에 넣음
            adder_if.b <= seq_item.b;
            #10;                                                            //10ns // DUT가 돌아갈 시간
            seq_item_port.item_done();                                      //item 처리 끝났다고 sequencer에 알려줌
        end
    endtask
endclass



class adder_monitor extends uvm_monitor;                                    //DUT I/O를 모니터링 하는 class
    `uvm_component_utils(adder_monitor)                                     //factory 등록

    uvm_analysis_port #(adder_seq_item) send;                               //scoreboard로 item 보내기 위한 analysis port handle

    virtual adder_intf adder_if;                                            //interface handler
    adder_seq_item seq_item;                                                //item handler

    function new(string name, uvm_component c = null);                      //생성자
        super.new(name,c);                                                  //부모 class 생성자
        send = new("send", this);                                           //send(analysis port) 객체 생성
     endfunction                                                            

    virtual function void build_phase(uvm_phase phase);                     //handle로 instance해놓은걸 factory에 등록되있는걸 가져와서 객체 생성
        super.build_phase(phase);                                           //부모 class build_phase
        seq_item = adder_seq_item::type_id::create("seq_item",this);        //item 객체 생성
               if (!uvm_config_db#(virtual adder_intf)::get(this, "", "adder_if", adder_if)) begin  //config_db에서 vif 가져와서 vif 객체 생성
            `uvm_fatal(get_name(), "Unable to access adder interface");     // vif 생성 안되면 시뮬레이션 종료
            end
            endfunction

            virtual task run_phase(uvm_phase phase);                        //run phase
                forever begin
                    #10;                                                    //10ns 마다 신호 확인
                    seq_item.a = adder_if.a;                                //vif에서 DUT I/O를 읽어 item으로 data 실어줌.
                    seq_item.b = adder_if.b;
                    seq_item.y = adder_if.y;
                    `uvm_info("monitor", "Send data to Scoreboard", UVM_LOW)//signal 다 실으면 메시지 출력
                    send.write(seq_item);                                   //uvm_analysis_port를 통해 scoreboard로 item 보냄.
                end
            endtask
endclass




class adder_agent extends uvm_agent;                                        //uvm_agent에서 상속
    `uvm_component_utils(adder_agent)                                       //factory에 등록
//agent 구성요소들 handle 생성
    uvm_sequencer#(adder_seq_item) sequencer;                               //sequencer는 item을 argument로 필요
    adder_driver driver;
    adder_monitor monitor;

    function new(string name = "adder_agent", uvm_component c = null);  //new()생성자
        super.new(name,c);                                              //부모 class 생성자
    endfunction

    virtual function void build_phase(uvm_phase phase);                 //handle 만든 component들 factory에서 객체 생성
        super.build_phase(phase);                                       //부모 class build_phase
        monitor = adder_monitor::type_id::create("monitor",this);       //monitor 객체 생성
        driver = adder_driver::type_id::create("driver",this);          //driver 객체 생성
        sequencer = uvm_sequencer#(adder_seq_item)::type_id::create("sequencer",this); //sequencer 객체 생성
    endfunction

    virtual function void connect_phase(uvm_phase phase);               //connect_phase
        super.connect_phase(phase);                                     //부모 class connect phase
        driver.seq_item_port.connect(sequencer.seq_item_export);        //driver와 sequencer를 연결해서 item을 줌.
    endfunction

endclass

class adder_scoreboard extends uvm_scoreboard;                          //uvm_scoreboard를 상속
    `uvm_component_utils(adder_scoreboard)                              //factory에 등록

    uvm_analysis_imp #(adder_seq_item,adder_scoreboard) recv;           //handle 생성. monitor로 부터 item을 받음.

    function new(string name = "adder_scoreboard", uvm_component c);    //new()생성자.
    super.new(name,c);                                                  //부모 class 생성자
    recv = new("read",this);                                            //recv 객체 생성.
    endfunction

    virtual function void write(adder_seq_item data);                   //write 함수 생성
        `uvm_info("scoreboard", "Data received from monitor", UVM_LOW); //write 함수 실행되면 메시지 출력.
        if(data.a + data.b == data.y) begin                             //monitor에서 수집한 item(data)에서 a+b = y인지 판별
            `uvm_info("scoreboard", $sformatf("PASS!, a:%0d + b:%0d = y:%0d", data.a, data.b, data.y), UVM_LOW) //맞으면 pass 메시지 출력

        end else begin
            `uvm_error("scoreboard", $sformatf("FAIL!, a:%0d + b:%0d = y:%0d", data.a, data.b, data.y))         //틀리면 fail 메시지 출력
        end

        endfunction


endclass



class adder_env extends uvm_env;                                        //uvm_env에서 상속
    `uvm_component_utils(adder_env)                                     //factory에 등록

    //create system
    adder_agent agent;                                                  //agent handle 생성
    adder_scoreboard scoreboard;                                        //scoreboard handle 생성
    

    function new(string name = "adder_env", uvm_component parent);      //생성자 만듬.
        super.new(name,parent);                                         //부모 class 생성자
    endfunction

    function void build_phase(uvm_phase phase);                         //build_phase 
        super.build_phase(phase);                                       //부모 class build_phase
            agent = adder_agent:: type_id::create("agent",this);        //agent 객체 생성
            scoreboard = adder_scoreboard:: type_id::create("scoreboard",this);//scoreboard 객체 생성
    endfunction

    function void connect_phase(uvm_phase phase);                       //connect phase
        agent.monitor.send.connect(scoreboard.recv);                    //agent 안의 monitor에서 scoreboard로 item을 보내도록 연결
    endfunction


endclass




class adder_test extends uvm_test;                                      //uvm_test에서 상속
  `uvm_component_utils(adder_test)  //factory에 adder_test 등록 macro
  adder_sequence seq;                                                   //sequence handle 생성
  adder_env env;                                                        //env handle 생성
  virtual adder_intf adder_if;                                          ////vif handle 생성

  function new(string name ="adder_test", uvm_component c ); //생성자
    super.new(name,c);                                      //부모 class 생성자 호출
  endfunction

  virtual function void build_phase(uvm_phase phase);       // handler를 만들어놓은 instance를 만드는 구간
    super.build_phase(phase);                               //부모 class build phase 호출
    env = adder_env::type_id::create("env", this);          //factory에서 가져와서 env 객체 생성
    seq = adder_sequence::type_id::create("sequence", this);//factory에서 가져와서 seq 객체 생성

    // uvm_config_db#(virtual adder_intf)::set(null, "*", "adder_if", adder_if);
  endfunction

    virtual task run_phase(uvm_phase phase);                //run_phase(test의 실제 실행 부분)
        phase.raise_objection(this);                        // simulation이 끝나지 않도록 이의 신청
            seq.start(env.agent.sequencer);                 //sequencer에서 sequence를 시작
        phase.drop_objection(this);                         //simulation 끝나면 이의 신청 종료.
    endtask

endclass






module tb_adder();                                          //top testbench


adder_intf adder_if();                                      //interface instance 생성

adder dut(
    .a(adder_if.a),                                         //DUT를 interface와 연결.
    .b(adder_if.b),
    .y(adder_if.y)
);

initial begin
    $fsdbDumpfile("wave.fsdb");                             //fsdb waveform 저장 설정
    $fsdbDumpvars(0);                                       //tb_adder 밑에 모든 하위 신호 보겠다는 옵션

end
  // UVM config_db로 virtual interface 주입
initial begin
    uvm_config_db#(virtual adder_intf)::set(null, "*", "adder_if", adder_if);//uvm class들이 interface를 사용할 수 있도록 config_db에 등록.
    run_test("adder_test");                                 //test 실행.
end




endmodule