class ram_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(ram_scoreboard)
    uvm_analysis_imp #(ram_seq_item, ram_scoreboard) imp;
    bit [7:0] mem_model[0:255];
    int pass_cnt = 0;
    int fail_cnt = 0;
    int write_cnt = 0;
    int read_cnt = 0;
    function new(string name, uvm_component parent);
        super.new(name, parent);
        imp = new("imp", this);
    endfunction


    function write(ram_seq_item tr);
        if (tr.we) begin
            mem_model[tr.addr] = tr.wdata;
            write_cnt++;
        end else begin
            read_cnt++;
            if (tr.rdata === mem_model[tr.addr]) begin
                pass_cnt++;
                `uvm_info(get_type_name(), $sformatf("PASS: %s (기대값=0x%02h)",
                                                     tr.convert2string(), mem_model[tr.addr]),
                          UVM_HIGH)
            end else begin
                fail_cnt++;
                `uvm_error(get_type_name(), $sformatf(
                           "FAIL: %s (기대값=0x%02h)", tr.convert2string(), mem_model[tr.addr]))
            end
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCB", "=========================================",UVM_LOW)
        `uvm_info("SCB", "======== SCOREBOARD 최종 report ==========",UVM_LOW)
        `uvm_info("SCB", $sformatf("   write count : %0d", write_cnt),UVM_LOW)
        `uvm_info("SCB", $sformatf("   read  count : %0d", read_cnt),UVM_LOW)
        `uvm_info("SCB", $sformatf("   pass  count : %0d", pass_cnt),UVM_LOW)
        `uvm_info("SCB", $sformatf("   fail  count : %0d", fail_cnt),UVM_LOW)
        `uvm_info("SCB", "=========================================",UVM_LOW)

    endfunction

endclass
