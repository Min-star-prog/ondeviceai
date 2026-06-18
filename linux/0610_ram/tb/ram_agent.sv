class ram_agent extends uvm_agent;
    `uvm_component_utils(ram_agent)

    ram_monitor mon;
    ram_driver drv;
    uvm_sequencer#(ram_seq_item) sqr;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction 

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        mon = ram_monitor::type_id::create("mon",this);
        drv = ram_driver::type_id::create("drv",this);
        sqr =  uvm_sequencer#(ram_seq_item)::type_id::create("sqr",this);
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction

    

endclass