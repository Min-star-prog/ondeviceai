
`include "spi_intf.sv"

package spi_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_seq_item extends uvm_sequence_item;

        rand logic [7:0] master_tx_data;
        rand logic [7:0] slave_tx_data;
        rand logic [7:0] clk_div;

        logic [7:0] master_rx_data;
        logic [7:0] slave_rx_data;

        logic [7:0] cap_mosi_data;
        logic [7:0] cap_miso_data;

        `uvm_object_utils_begin(spi_seq_item)
            `uvm_field_int(master_tx_data, UVM_DEFAULT)
            `uvm_field_int(slave_tx_data, UVM_DEFAULT)
            `uvm_field_int(clk_div, UVM_DEFAULT)
            `uvm_field_int(master_rx_data, UVM_DEFAULT)
            `uvm_field_int(slave_rx_data, UVM_DEFAULT)
            `uvm_field_int(cap_mosi_data, UVM_DEFAULT)
            `uvm_field_int(cap_miso_data, UVM_DEFAULT)
        `uvm_object_utils_end

        function new(string name = "spi_seq_item");
            super.new(name);
        endfunction

        constraint c_clk_div {clk_div inside {[5 : 50]};}

    endclass


    class spi_base_seq extends uvm_sequence #(spi_seq_item);

        `uvm_object_utils(spi_base_seq)

        function new(string name = "spi_base_seq");
            super.new(name);
        endfunction

        task do_write(logic [7:0] data);
            spi_seq_item item;

            item = spi_seq_item::type_id::create("item");

            start_item(item);
            item.master_tx_data = data;
            item.slave_tx_data  = 8'h00;
            item.clk_div        = $urandom_range(5, 50);
            finish_item(item);
        endtask

        task do_read(logic [7:0] data);
            spi_seq_item item;

            item = spi_seq_item::type_id::create("item");

            start_item(item);
            item.master_tx_data = 8'h00;
            item.slave_tx_data  = data;
            item.clk_div        = $urandom_range(5, 50);
            finish_item(item);
        endtask

        task do_write_read(logic [7:0] m_data, logic [7:0] s_data);
            spi_seq_item item;

            item = spi_seq_item::type_id::create("item");

            start_item(item);
            item.master_tx_data = m_data;
            item.slave_tx_data  = s_data;
            item.clk_div        = $urandom_range(5, 50);
            finish_item(item);
        endtask

    endclass


    class spi_write_seq extends spi_base_seq;

        `uvm_object_utils(spi_write_seq)

        function new(string name = "spi_write_seq");
            super.new(name);
        endfunction

        task body();
            `uvm_info("SPI_WRITE_SEQ", "WRITE sequence start", UVM_MEDIUM)

            do_write(8'h55);
            do_write(8'hA5);
            do_write(8'hF0);

            `uvm_info("SPI_WRITE_SEQ", "WRITE sequence done", UVM_MEDIUM)
        endtask

    endclass


    class spi_read_seq extends spi_base_seq;

        `uvm_object_utils(spi_read_seq)

        function new(string name = "spi_read_seq");
            super.new(name);
        endfunction

        task body();
            `uvm_info("SPI_READ_SEQ", "READ sequence start", UVM_MEDIUM)

            do_read(8'h11);
            do_read(8'h22);
            do_read(8'h33);

            `uvm_info("SPI_READ_SEQ", "READ sequence done", UVM_MEDIUM)
        endtask

    endclass


    class spi_write_read_seq extends spi_base_seq;

        `uvm_object_utils(spi_write_read_seq)

        int num = 1;

        function new(string name = "spi_write_read_seq");
            super.new(name);
        endfunction

        task body();

            logic [7:0] m_data;
            logic [7:0] s_data;

            `uvm_info("SPI_WR_RD_SEQ", $sformatf("WRITE & READ sequence start (%0d 반복)", num),
                      UVM_MEDIUM)

            repeat (num) begin

                m_data = $urandom_range(0, 255);
                s_data = $urandom_range(0, 255);

                do_write_read(m_data, s_data);

            end

            `uvm_info("SPI_WR_RD_SEQ", "WRITE & READ sequence done", UVM_MEDIUM)

        endtask


    endclass


    class spi_driver extends uvm_driver #(spi_seq_item);

        `uvm_component_utils(spi_driver)

        virtual spi_intf spi_vif;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if (!uvm_config_db#(virtual spi_intf)::get(this, "", "spi_vif", spi_vif)) begin
                `uvm_fatal("SPI_DRV", "Failed to get spi_vif")
            end
        endfunction

        task run_phase(uvm_phase phase);
            spi_seq_item item;

            reset_dut();

            forever begin
                seq_item_port.get_next_item(item);
                drive_transfer(item);
                seq_item_port.item_done();
            end
        endtask

        task reset_dut();
            spi_vif.rst            <= 1'b1;
            spi_vif.start          <= 1'b0;
            spi_vif.cpol           <= 1'b0;  //mode 0으로 고정
            spi_vif.cpha           <= 1'b0;  //mode 0으로 고정
            spi_vif.clk_div        <= 8'd20;
            spi_vif.master_tx_data <= 8'd0;
            spi_vif.slave_tx_data  <= 8'd0;

            repeat (5) @(posedge spi_vif.clk);
            spi_vif.rst <= 1'b0;
            repeat (5) @(posedge spi_vif.clk);
        endtask

        task drive_transfer(spi_seq_item item);

            @(posedge spi_vif.clk);

            spi_vif.cpol           <= 1'b0;
            spi_vif.cpha           <= 1'b0;
            spi_vif.clk_div        <= item.clk_div;
            spi_vif.master_tx_data <= item.master_tx_data;
            spi_vif.slave_tx_data  <= item.slave_tx_data;

            spi_vif.start          <= 1'b1;
            @(posedge spi_vif.clk);
            spi_vif.start <= 1'b0;

            `uvm_info("SPI_DRV", $sformatf("Drive transfer: master_tx=0x%02h slave_tx=0x%02h",
                                           item.master_tx_data, item.slave_tx_data), UVM_MEDIUM)

            wait (spi_vif.master_done == 1'b1);
            @(posedge spi_vif.clk);

        endtask

    endclass


    class spi_monitor extends uvm_monitor;

        `uvm_component_utils(spi_monitor)

        virtual spi_intf spi_vif;
        uvm_analysis_port #(spi_seq_item) ap;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            ap = new("ap", this);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if (!uvm_config_db#(virtual spi_intf)::get(this, "", "spi_vif", spi_vif)) begin
                `uvm_fatal("SPI_MON", "Failed to get spi_vif")
            end
        endfunction

        task run_phase(uvm_phase phase);
            spi_seq_item item;

            forever begin
                wait (spi_vif.ss_n == 1'b0);

                item = spi_seq_item::type_id::create("item");

                item.master_tx_data = spi_vif.master_tx_data;
                item.slave_tx_data = spi_vif.slave_tx_data;

                item.cap_mosi_data = 8'd0;
                item.cap_miso_data = 8'd0;

                // CPOL=0, CPHA=0 기준
                // posedge sclk에서 MOSI/MISO sampling
                for (int i = 0; i < 8; i++) begin
                    @(posedge spi_vif.sclk);
                    item.cap_mosi_data = {item.cap_mosi_data[6:0], spi_vif.mosi};
                    item.cap_miso_data = {item.cap_miso_data[6:0], spi_vif.miso};
                end

                wait (spi_vif.master_done == 1'b1);
                // #1;

                item.master_rx_data = spi_vif.master_rx_data;
                item.slave_rx_data  = spi_vif.slave_rx_data;

                `uvm_info("SPI_MON", $sformatf(
                          "Capture: MOSI=0x%02h MISO=0x%02h master_rx=0x%02h slave_rx=0x%02h",
                          item.cap_mosi_data,
                          item.cap_miso_data,
                          item.master_rx_data,
                          item.slave_rx_data
                          ), UVM_MEDIUM)

                ap.write(item);

                wait (spi_vif.ss_n == 1'b1);
            end
        endtask

    endclass


    class spi_scoreboard extends uvm_scoreboard;

        `uvm_component_utils(spi_scoreboard)

        uvm_analysis_imp #(spi_seq_item, spi_scoreboard) imp;

        int total_cnt;
        int pass_cnt;
        int fail_cnt;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            imp = new("imp", this);
        endfunction

        function void write(spi_seq_item item);
            total_cnt++;

            if (
                item.master_tx_data == item.slave_rx_data  &&
                item.slave_tx_data  == item.master_rx_data &&
                item.cap_mosi_data  == item.master_tx_data &&
                item.cap_miso_data  == item.slave_tx_data
            ) begin
                pass_cnt++;

                `uvm_info(
                    "SPI_SCB",
                    $sformatf(
                        "PASS: master_tx=0x%02h slave_rx=0x%02h | slave_tx=0x%02h master_rx=0x%02h | cap_mosi=0x%02h cap_miso=0x%02h",
                        item.master_tx_data, item.slave_rx_data, item.slave_tx_data,
                        item.master_rx_data, item.cap_mosi_data, item.cap_miso_data), UVM_MEDIUM)
            end else begin
                fail_cnt++;

                `uvm_error("SPI_SCB", $sformatf(
                           "FAIL: master_tx=0x%02h slave_rx=0x%02h | slave_tx=0x%02h master_rx=0x%02h | cap_mosi=0x%02h cap_miso=0x%02h",
                           item.master_tx_data,
                           item.slave_rx_data,
                           item.slave_tx_data,
                           item.master_rx_data,
                           item.cap_mosi_data,
                           item.cap_miso_data
                           ))
            end
        endfunction

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);

            `uvm_info("SPI_SCB", $sformatf(
                      "SPI TEST RESULT: total=%0d pass=%0d fail=%0d", total_cnt, pass_cnt, fail_cnt
                      ), UVM_NONE)
        endfunction

    endclass

    class spi_coverage extends uvm_subscriber #(spi_seq_item);

        `uvm_component_utils(spi_coverage)

        spi_seq_item item;

        covergroup spi_cg;

            option.per_instance = 1;

            cp_master_tx: coverpoint item.master_tx_data {
                bins zero = {8'h00};
                bins low = {[8'h01 : 8'h3F]};
                bins mid = {[8'h40 : 8'hBF]};
                bins high = {[8'hC0 : 8'hFE]};
                bins ff = {8'hFF};
            }

            cp_slave_tx: coverpoint item.slave_tx_data {
                bins zero = {8'h00};
                bins low = {[8'h01 : 8'h3F]};
                bins mid = {[8'h40 : 8'hBF]};
                bins high = {[8'hC0 : 8'hFE]};
                bins ff = {8'hFF};
            }

            cp_master_rx: coverpoint item.master_rx_data;
            cp_slave_rx: coverpoint item.slave_rx_data;

            cp_cap_mosi: coverpoint item.cap_mosi_data;
            cp_cap_miso: coverpoint item.cap_miso_data;

            cross_master_slave_tx : cross cp_master_tx, cp_slave_tx;

        endgroup

        function new(string name, uvm_component parent);
            super.new(name, parent);
            spi_cg = new();
        endfunction

        function void write(spi_seq_item t);
            item = t;
            spi_cg.sample();

            `uvm_info("SPI_COV", $sformatf(
                      "Coverage sampled: master_tx=0x%02h slave_tx=0x%02h mosi=0x%02h miso=0x%02h",
                      item.master_tx_data,
                      item.slave_tx_data,
                      item.cap_mosi_data,
                      item.cap_miso_data
                      ), UVM_MEDIUM)
        endfunction

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);

            `uvm_info("SPI_COV", $sformatf(
                      "SPI functional coverage = %0.2f%%", spi_cg.get_inst_coverage()), UVM_NONE)
        endfunction

    endclass

    class spi_agent extends uvm_agent;

        `uvm_component_utils(spi_agent)

        uvm_sequencer #(spi_seq_item) sqr;
        spi_driver drv;
        spi_monitor mon;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            sqr = uvm_sequencer#(spi_seq_item)::type_id::create("sqr", this);

            drv = spi_driver::type_id::create("drv", this);
            mon = spi_monitor::type_id::create("mon", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            drv.seq_item_port.connect(sqr.seq_item_export);
        endfunction

    endclass


    class spi_env extends uvm_env;

        `uvm_component_utils(spi_env)

        spi_agent agt;
        spi_scoreboard scb;
        spi_coverage cov;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            agt = spi_agent::type_id::create("agt", this);
            scb = spi_scoreboard::type_id::create("scb", this);
            cov = spi_coverage::type_id::create("cov", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            agt.mon.ap.connect(scb.imp);
            agt.mon.ap.connect(cov.analysis_export);
        endfunction

    endclass


    class spi_basic_test extends uvm_test;

        `uvm_component_utils(spi_basic_test)

        spi_env env;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            env = spi_env::type_id::create("env", this);
        endfunction

        function void end_of_elaboration_phase(uvm_phase phase);
            super.end_of_elaboration_phase(phase);
            uvm_top.print_topology();
        endfunction


        task run_phase(uvm_phase phase);

            spi_write_seq      w_seq;
            spi_read_seq       r_seq;
            spi_write_read_seq wr_seq;

            phase.raise_objection(this);

            w_seq  = spi_write_seq::type_id::create("w_seq");
            r_seq  = spi_read_seq::type_id::create("r_seq");
            wr_seq = spi_write_read_seq::type_id::create("wr_seq");

            w_seq.start(env.agt.sqr);
            r_seq.start(env.agt.sqr);
            wr_seq.num = 400;
            wr_seq.start(env.agt.sqr);

            phase.drop_objection(this);

        endtask

    endclass

endpackage
