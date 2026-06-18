class ram_driver extends uvm_driver #(ram_seq_item);
    `uvm_component_utils(ram_driver)

    virtual ram_intf ram_vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual ram_intf)::get(this, "", "ram_vif", ram_vif))
            `uvm_fatal(get_type_name(), "Virtual interface(vif)를 config_db에서 찾지 못함")
    endfunction

    task run_phase(uvm_phase phase);
        // ram_seq_item req;   //이걸 안 써도 원래 ram_seq_item req;를 자동으로 uvm에서 만들어줌.지금까지 처럼 그냥 우리가 만들어도 되긴함.
            ram_vif.drv_cb.we   <= 0;
            ram_vif.drv_cb.addr <= 0;
            ram_vif.drv_cb.wdata <=0;

        forever begin
            seq_item_port.get_next_item(req);      
            @(ram_vif.drv_cb);  //interface의 clocking block을 사용
            ram_vif.drv_cb.we <= req.we;
            ram_vif.drv_cb.addr <= req.addr;
            ram_vif.drv_cb.wdata <= req.wdata;

            `uvm_info(get_type_name(), $sformatf("구동: %s", req.convert2string()), UVM_HIGH)
            // @(ram_vif.mon_cb); //초기값 error 때매 추가

            seq_item_port.item_done();
        end

    endtask




endclass
