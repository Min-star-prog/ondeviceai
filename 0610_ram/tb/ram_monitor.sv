class ram_monitor extends uvm_monitor;
    `uvm_component_utils(ram_monitor)

    virtual ram_intf ram_vif;
    uvm_analysis_port #(ram_seq_item) ap;
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ram_intf)::get(this, "", "ram_vif", ram_vif))
            `uvm_fatal(get_type_name(), "Virtual interface(vif)를 config_db에서 찾지 못함")
    endfunction



    task run_phase(uvm_phase phase);
        // ram_seq_item req;   //이걸 안 써도 원래 ram_seq_item req;를 자동으로 uvm에서 만들어줌.지금까지 처럼 그냥 우리가 만들어도 되긴함.
        ram_seq_item tr;
        ram_seq_item pending_rd = null; //(원래 주소를 넣어줘야되는데 null을 넣음->0번지에 instance 배치.)
            // @(ram_vif.mon_cb); //error때매 추가
        
        forever begin
            @(ram_vif.mon_cb);  //interface의 clocking block을 사용

            if(pending_rd != null) begin    //그 주소에 data가 있으면 // 여기서 null = pending_rd가 아직 어떤 객체도 가리키지 않음
                pending_rd.rdata = ram_vif.mon_cb.rdata;
                `uvm_info(get_type_name(),$sformatf("%s", pending_rd.convert2string()),UVM_HIGH)
                ap.write(pending_rd);
                pending_rd = null;      // 여기서 null = 읽기 응답 처리가 끝났으니 더 이상 객체를 가리키지 않음
            end

            tr = ram_seq_item::type_id::create("tr");
            tr.we = ram_vif.mon_cb.we;
            tr.addr = ram_vif.mon_cb.addr;
            tr.wdata = ram_vif.mon_cb.wdata;
            
            if (tr.we) begin
                `uvm_info(get_type_name(), $sformatf("%s", tr.convert2string()), UVM_HIGH)
                ap.write(tr);
            end else begin
                pending_rd = tr;
            end

            end

    endtask



    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction

endclass
