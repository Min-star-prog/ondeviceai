
`include "i2c_if.sv"
package i2c_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    typedef enum {
        I2C_WRITE,
        I2C_READ,
        I2C_WRITE_READ
    } i2c_op_e;

    typedef enum {
        ACT_WRITE,
        ACT_READ
    } i2c_act_e;

    `uvm_analysis_imp_decl(_exp)
    `uvm_analysis_imp_decl(_act)

    class i2c_seq_item extends uvm_sequence_item;

        rand i2c_op_e op;
        rand logic [6:0] slave_addr;
        rand logic [7:0] master_tx_data;
        rand logic [7:0] slave_tx_data;

        logic [7:0] actual_data;
        i2c_act_e act;

        function new(string name = "i2c_seq_item");
            super.new(name);
            slave_addr = 7'h40;
        endfunction

        `uvm_object_utils_begin(i2c_seq_item)
            `uvm_field_enum(i2c_op_e, op, UVM_DEFAULT)
            `uvm_field_int(slave_addr, UVM_DEFAULT)
            `uvm_field_int(master_tx_data, UVM_DEFAULT)
            `uvm_field_int(slave_tx_data, UVM_DEFAULT)
            `uvm_field_int(actual_data, UVM_DEFAULT)
            `uvm_field_enum(i2c_act_e, act, UVM_DEFAULT)
        `uvm_object_utils_end

    endclass


    class i2c_base_seq extends uvm_sequence #(i2c_seq_item);

        `uvm_object_utils(i2c_base_seq)

        function new(string name = "i2c_base_seq");
            super.new(name);
        endfunction

    endclass


    class i2c_write_seq extends i2c_base_seq;

        `uvm_object_utils(i2c_write_seq)

        function new(string name = "i2c_write_seq");
            super.new(name);
        endfunction

        task body();
            i2c_seq_item tr;

            repeat (3) begin
                tr = i2c_seq_item::type_id::create("tr");
                start_item(tr);

                tr.op = I2C_WRITE;
                tr.slave_addr = 7'h40;
                tr.master_tx_data = $urandom_range(0, 255);
                tr.slave_tx_data = 8'h00;

                finish_item(tr);
            end
        endtask

    endclass


    class i2c_read_seq extends i2c_base_seq;

        `uvm_object_utils(i2c_read_seq)

        function new(string name = "i2c_read_seq");
            super.new(name);
        endfunction

        task body();
            i2c_seq_item tr;

            repeat (3) begin
                tr = i2c_seq_item::type_id::create("tr");
                start_item(tr);

                tr.op = I2C_READ;
                tr.slave_addr = 7'h40;
                tr.master_tx_data = 8'h00;
                tr.slave_tx_data = $urandom_range(0, 255);

                finish_item(tr);
            end
        endtask

    endclass


    class i2c_write_read_seq extends i2c_base_seq;

        `uvm_object_utils(i2c_write_read_seq)

        function new(string name = "i2c_write_read_seq");
            super.new(name);
        endfunction

        task body();
            i2c_seq_item tr;

            repeat (100) begin
                tr = i2c_seq_item::type_id::create("tr");
                start_item(tr);

                tr.op = I2C_WRITE_READ;
                tr.slave_addr = 7'h40;
                tr.master_tx_data = $urandom_range(0, 255);
                tr.slave_tx_data = $urandom_range(0, 255);

                finish_item(tr);
            end
        endtask

    endclass


    class i2c_driver extends uvm_driver #(i2c_seq_item);

        `uvm_component_utils(i2c_driver)

        virtual i2c_if vif;

        uvm_analysis_port #(i2c_seq_item) exp_ap;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            exp_ap = new("exp_ap", this);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if (!uvm_config_db#(virtual i2c_if)::get(this, "", "i2c_vif", vif)) begin
                `uvm_fatal("DRV", "i2c_vif get failed")
            end
        endfunction

        task reset_signal();
            vif.rst            <= 1'b1;
            vif.cmd_start      <= 1'b0;
            vif.cmd_write      <= 1'b0;
            vif.cmd_read       <= 1'b0;
            vif.cmd_stop       <= 1'b0;
            vif.master_tx_data <= 8'h00;
            vif.master_ack_in  <= 1'b1;
            vif.slave_tx_data  <= 8'h00;
            vif.slave_ack_in   <= 1'b0;

            repeat (10) @(posedge vif.clk);
            vif.rst <= 1'b0;
            repeat (10) @(posedge vif.clk);

        endtask

        task wait_done();
            wait (vif.master_done == 1'b1);
            @(posedge vif.clk);
        endtask

        task send_start();
            @(posedge vif.clk);
            vif.cmd_start <= 1'b1;
            @(posedge vif.clk);
            vif.cmd_start <= 1'b0;
            wait_done();
        endtask

        task send_stop();
            @(posedge vif.clk);
            vif.cmd_stop <= 1'b1;
            @(posedge vif.clk);
            vif.cmd_stop <= 1'b0;
            wait_done();
        endtask

        task send_write_byte(input logic [7:0] data);
            @(posedge vif.clk);
            vif.master_tx_data <= data;
            vif.cmd_write      <= 1'b1;
            @(posedge vif.clk);
            vif.cmd_write <= 1'b0;
            wait_done();
        endtask

        task send_read_byte(input logic ack_nack);
            @(posedge vif.clk);
            vif.master_ack_in <= ack_nack;
            vif.cmd_read      <= 1'b1;
            @(posedge vif.clk);
            vif.cmd_read <= 1'b0;
            wait_done();
        endtask

        task do_write(i2c_seq_item tr);
            i2c_seq_item exp;

            send_start();

            // address + write bit
            send_write_byte({tr.slave_addr, 1'b0});

            // data
            send_write_byte(tr.master_tx_data);

            exp = i2c_seq_item::type_id::create("exp");
            exp.act = ACT_WRITE;
            exp.actual_data = tr.master_tx_data;
            exp_ap.write(exp);

            send_stop();
        endtask

        task do_read(i2c_seq_item tr);
            i2c_seq_item exp;

            vif.slave_tx_data <= tr.slave_tx_data;

            send_start();

            // address + read bit
            send_write_byte({tr.slave_addr, 1'b1});

            // read 1 byte, then NACK
            send_read_byte(1'b1);

            exp = i2c_seq_item::type_id::create("exp");
            exp.act = ACT_READ;
            exp.actual_data = tr.slave_tx_data;
            exp_ap.write(exp);

            send_stop();
        endtask

        task do_write_read(i2c_seq_item tr);
            i2c_seq_item exp;

            vif.slave_tx_data <= tr.slave_tx_data;

            send_start();

            // address + write bit
            send_write_byte({tr.slave_addr, 1'b0});

            // write data
            send_write_byte(tr.master_tx_data);

            exp = i2c_seq_item::type_id::create("exp_write");
            exp.act = ACT_WRITE;
            exp.actual_data = tr.master_tx_data;
            exp_ap.write(exp);

            // repeated start
            send_start();

            // address + read bit
            send_write_byte({tr.slave_addr, 1'b1});

            // read data
            send_read_byte(1'b1);

            exp = i2c_seq_item::type_id::create("exp_read");
            exp.act = ACT_READ;
            exp.actual_data = tr.slave_tx_data;
            exp_ap.write(exp);

            send_stop();
        endtask

        task run_phase(uvm_phase phase);
            i2c_seq_item tr;

            reset_signal();

            forever begin
                seq_item_port.get_next_item(tr);

                case (tr.op)
                    I2C_WRITE: begin
                        do_write(tr);
                    end

                    I2C_READ: begin
                        do_read(tr);
                    end

                    I2C_WRITE_READ: begin
                        do_write_read(tr);
                    end
                endcase

                seq_item_port.item_done();
            end
        endtask

    endclass


    class i2c_monitor extends uvm_component;

        `uvm_component_utils(i2c_monitor)

        virtual i2c_if vif;

        uvm_analysis_port #(i2c_seq_item) exp_ap;
        uvm_analysis_port #(i2c_seq_item) act_ap;

        typedef enum logic [1:0] {
            MON_IDLE,
            MON_ADDR,
            MON_DATA
        } mon_state_e;

        mon_state_e mon_state;

        bit pending_read;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            exp_ap = new("exp_ap", this);
            act_ap = new("act_ap", this);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if (!uvm_config_db#(virtual i2c_if)::get(this, "", "i2c_vif", vif)) begin
                `uvm_fatal("MON", "i2c_vif get failed")
            end
        endfunction

        task run_phase(uvm_phase phase);
            i2c_seq_item exp_tr;
            i2c_seq_item act_tr;

            mon_state    = MON_IDLE;
            pending_read = 1'b0;

            forever begin
                @(posedge vif.clk);

                // START 또는 repeated START
                // 다음 write byte는 address byte라고 판단
                if (vif.cmd_start) begin
                    mon_state = MON_ADDR;
                end

                // WRITE expected capture
                // cmd_write 첫 번째 byte : address
                // cmd_write 두 번째 byte : data
                if (vif.cmd_write) begin
                    case (mon_state)

                        MON_ADDR: begin
                            // address byte는 scoreboard 비교 대상에서 제외
                            mon_state = MON_DATA;

                            `uvm_info("MON", $sformatf(
                                      "ADDRESS byte captured = 0x%02h", vif.master_tx_data),
                                      UVM_LOW)
                        end

                        MON_DATA: begin
                            exp_tr             = i2c_seq_item::type_id::create("write_exp");
                            exp_tr.act         = ACT_WRITE;
                            exp_tr.slave_addr  = 7'h40;
                            exp_tr.actual_data = vif.master_tx_data;

                            exp_ap.write(exp_tr);

                            `uvm_info("MON", $sformatf(
                                      "WRITE EXPECTED master_tx_data = 0x%02h", vif.master_tx_data),
                                      UVM_MEDIUM)
                        end

                        default: begin
                            // START 없이 write가 들어온 경우
                            `uvm_warning("MON", "cmd_write detected before START")
                        end

                    endcase
                end

                // WRITE actual capture
                // slave가 8bit data를 다 받은 순간
                if (vif.slave_rx_valid) begin
                    act_tr             = i2c_seq_item::type_id::create("write_act");
                    act_tr.act         = ACT_WRITE;
                    act_tr.slave_addr  = 7'h40;
                    act_tr.actual_data = vif.slave_rx_data;

                    act_ap.write(act_tr);

                    `uvm_info("MON", $sformatf("WRITE ACTUAL slave_rx_data = 0x%02h",
                                               vif.slave_rx_data), UVM_MEDIUM)
                end

                // READ expected capture
                // read 명령이 들어가면 slave_tx_data가 master에게 읽힐 값
                if (vif.cmd_read) begin
                    pending_read       = 1'b1;

                    exp_tr             = i2c_seq_item::type_id::create("read_exp");
                    exp_tr.act         = ACT_READ;
                    exp_tr.slave_addr  = 7'h40;
                    exp_tr.actual_data = vif.slave_tx_data;

                    exp_ap.write(exp_tr);

                    `uvm_info("MON", $sformatf("READ EXPECTED slave_tx_data = 0x%02h",
                                               vif.slave_tx_data), UVM_MEDIUM)
                end

                // READ actual capture
                // cmd_read 직후에는 아직 master_rx_data가 완성되지 않음
                // master_done이 뜬 시점에 capture
                if (pending_read && vif.master_done) begin
                    act_tr             = i2c_seq_item::type_id::create("read_act");
                    act_tr.act         = ACT_READ;
                    act_tr.slave_addr  = 7'h40;
                    act_tr.actual_data = vif.master_rx_data;

                    act_ap.write(act_tr);

                    `uvm_info("MON", $sformatf("READ ACTUAL master_rx_data = 0x%02h",
                                               vif.master_rx_data), UVM_MEDIUM)

                    pending_read = 1'b0;
                end

                // STOP이 들어오면 transaction 종료
                if (vif.cmd_stop) begin
                    mon_state    = MON_IDLE;
                    pending_read = 1'b0;
                end
            end
        endtask

    endclass



    class i2c_scoreboard extends uvm_component;

        `uvm_component_utils(i2c_scoreboard)

        uvm_analysis_imp_exp #(i2c_seq_item, i2c_scoreboard) exp_imp;
        uvm_analysis_imp_act #(i2c_seq_item, i2c_scoreboard) act_imp;

        i2c_seq_item exp_q[$];

        int total_cnt;
        int pass_cnt;
        int fail_cnt;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            exp_imp = new("exp_imp", this);
            act_imp = new("act_imp", this);
        endfunction

        function void write_exp(i2c_seq_item tr);
            exp_q.push_back(tr);

            `uvm_info("SCB", $sformatf("EXPECTED %s data = 0x%02h", tr.act.name(), tr.actual_data),
                      UVM_MEDIUM)
        endfunction

        function void write_act(i2c_seq_item act);
            i2c_seq_item exp;

            total_cnt++;

            if (exp_q.size() == 0) begin
                fail_cnt++;
                `uvm_error("SCB", $sformatf("Unexpected actual data. act=%s data=0x%02h",
                                            act.act.name(), act.actual_data))
                return;
            end

            exp = exp_q.pop_front();

            if ((exp.act == act.act) && (exp.actual_data == act.actual_data)) begin
                pass_cnt++;

                `uvm_info("SCB", $sformatf("PASS %s exp=0x%02h act=0x%02h", act.act.name(),
                                           exp.actual_data, act.actual_data), UVM_LOW)
            end else begin
                fail_cnt++;

                `uvm_error("SCB", $sformatf(
                           "FAIL exp_type=%s act_type=%s exp=0x%02h act=0x%02h",
                           exp.act.name(),
                           act.act.name(),
                           exp.actual_data,
                           act.actual_data
                           ))
            end
        endfunction

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);

            `uvm_info("SCB", $sformatf("TOTAL=%0d PASS=%0d FAIL=%0d", total_cnt, pass_cnt, fail_cnt
                      ), UVM_NONE)
        endfunction

    endclass

    class i2c_coverage extends uvm_subscriber #(i2c_seq_item);

        `uvm_component_utils(i2c_coverage)

        i2c_seq_item cov_tr;

        covergroup i2c_cg;
            option.per_instance = 1;

            cp_act: coverpoint cov_tr.act {bins write = {ACT_WRITE}; bins read = {ACT_READ};}

//             cp_op: coverpoint cov_tr.op {
//     bins write      = {I2C_WRITE};
//     bins read       = {I2C_READ};
//     bins write_read = {I2C_WRITE_READ};
// }

            cp_write_data: coverpoint cov_tr.actual_data iff (cov_tr.act == ACT_WRITE) {
                bins low = {[8'h00 : 8'h3F]};
                bins mid_1 = {[8'h40 : 8'h7F]};
                bins mid_2 = {[8'h80 : 8'hAF]};
                bins high = {[8'hB0 : 8'hFF]};
                bins zero = {8'h00};
                bins ff = {8'hFF};
            }

            cp_read_data: coverpoint cov_tr.actual_data iff (cov_tr.act == ACT_READ) {
                bins low = {[8'h00 : 8'h3F]};
                bins mid_1 = {[8'h40 : 8'h7F]};
                bins mid_2 = {[8'h80 : 8'hAF]};
                bins high = {[8'hB0 : 8'hFF]};
                bins zero = {8'h00};
                bins ff = {8'hFF};
            }

            cp_addr: coverpoint cov_tr.slave_addr {bins slave_40 = {7'h40};}


            // WRITE 동작에서 어떤 data 구간이 나왔는지
            cross_write_data: cross cp_act, cp_write_data{
                ignore_bins not_write = binsof (cp_act.read);
            }

            // READ 동작에서 어떤 data 구간이 나왔는지
            cross_read_data: cross cp_act, cp_read_data{
                ignore_bins not_read = binsof (cp_act.write);
            }
            // cross_op_act: cross cp_op, cp_act;

        endgroup

        function new(string name, uvm_component parent);
            super.new(name, parent);
            i2c_cg = new();
        endfunction

        virtual function void write(i2c_seq_item t);
            cov_tr = t;
            i2c_cg.sample();

            `uvm_info("COV", $sformatf(
                      "COVERAGE sample act=%s data=0x%02h addr=0x%02h coverage=%.2f%%",
                      t.act.name(),
                      t.actual_data,
                      t.slave_addr,
                      i2c_cg.get_inst_coverage()
                      ), UVM_MEDIUM)
        endfunction

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);

            `uvm_info("COV", $sformatf(
                      "I2C Functional Coverage = %.2f%%", i2c_cg.get_inst_coverage()), UVM_NONE)
        endfunction

    endclass


    class i2c_agent extends uvm_agent;

        `uvm_component_utils(i2c_agent)

        uvm_sequencer #(i2c_seq_item) sqr;
        i2c_driver drv;
        i2c_monitor mon;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            sqr = uvm_sequencer#(i2c_seq_item)::type_id::create("sqr", this);
            drv = i2c_driver::type_id::create("drv", this);
            mon = i2c_monitor::type_id::create("mon", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            drv.seq_item_port.connect(sqr.seq_item_export);
        endfunction

    endclass


    class i2c_env extends uvm_env;

        `uvm_component_utils(i2c_env)

        i2c_agent      agt;
        i2c_scoreboard scb;
        i2c_coverage   cov;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            agt = i2c_agent::type_id::create("agt", this);
            scb = i2c_scoreboard::type_id::create("scb", this);
            cov = i2c_coverage::type_id::create("cov", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            agt.mon.exp_ap.connect(scb.exp_imp);
            agt.mon.act_ap.connect(scb.act_imp);
            agt.mon.act_ap.connect(cov.analysis_export);
        endfunction

    endclass


    class i2c_test extends uvm_test;

        `uvm_component_utils(i2c_test)

        i2c_env env;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            env = i2c_env::type_id::create("env", this);
        endfunction

        function void end_of_elaboration_phase(uvm_phase phase);
            super.end_of_elaboration_phase(phase);
            uvm_top.print_topology();
        endfunction

        task run_phase(uvm_phase phase);
            i2c_write_seq      write_seq;
            i2c_read_seq       read_seq;
            i2c_write_read_seq wr_rd_seq;

            phase.raise_objection(this);

            write_seq = i2c_write_seq::type_id::create("write_seq");
            read_seq  = i2c_read_seq::type_id::create("read_seq");
            wr_rd_seq = i2c_write_read_seq::type_id::create("wr_rd_seq");

            write_seq.start(env.agt.sqr);
            read_seq.start(env.agt.sqr);
            wr_rd_seq.start(env.agt.sqr);

            #1000;

            phase.drop_objection(this);
        endtask

    endclass

endpackage
