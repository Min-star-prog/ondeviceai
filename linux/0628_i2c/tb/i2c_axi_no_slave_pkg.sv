`timescale 1ns/1ps

package i2c_axi_no_slave_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Byte addresses derived from ADDR_LSB=2 in i2c_v1_0_S00_AXI.
    localparam bit [3:0] CR_ADDR  = 4'h0;
    localparam bit [3:0] TDR_ADDR = 4'h4;
    localparam bit [3:0] RDR_ADDR = 4'h8;
    localparam bit [3:0] SR_ADDR  = 4'hC;

    typedef enum bit [1:0] {
        I2C_WRITE_ONLY,
        I2C_READ_ONLY,
        I2C_WRITE_READ
    } i2c_op_e;

    typedef enum bit [1:0] {
        I2C_EVT_START,
        I2C_EVT_BYTE,
        I2C_EVT_STOP
    } i2c_evt_e;

    // Sequence transaction issued by the AXI driver.
    class i2c_axi_item extends uvm_sequence_item;
        rand i2c_op_e  op;
        rand bit [7:0] tx_data;
        rand bit       master_ack;  // 0=ACK, 1=NACK after a READ byte

        // constraint c_write_data {
        //     // Do not use FF here so a write byte is visibly distinct from the
        //     // no-slave read value, which is always FF due to the SDA pull-up.
        //     tx_data inside {8'h00, 8'h01, 8'h3C, 8'h55, 8'hA5, 8'hAA};
        // }

        function new(string name = "i2c_axi_item");
            super.new(name);
        endfunction

        `uvm_object_utils_begin(i2c_axi_item)
            `uvm_field_enum(i2c_op_e, op, UVM_DEFAULT)
            `uvm_field_int(tx_data, UVM_DEFAULT)
            `uvm_field_int(master_ack, UVM_DEFAULT)
        `uvm_object_utils_end

        function string convert2string();
            return $sformatf("op=%s tx=0x%02h master_ack=%0b",
                             op.name(), tx_data, master_ack);
        endfunction
    endclass

    // Item emitted by both expected path and the SCL/SDA pin monitor.
    class i2c_bus_item extends uvm_sequence_item;
        i2c_evt_e  kind;
        bit [7:0]  data;
        bit        ack;

        function new(string name = "i2c_bus_item");
            super.new(name);
        endfunction

        `uvm_object_utils_begin(i2c_bus_item)
            `uvm_field_enum(i2c_evt_e, kind, UVM_DEFAULT)
            `uvm_field_int(data, UVM_DEFAULT)
            `uvm_field_int(ack, UVM_DEFAULT)
        `uvm_object_utils_end

        function string convert2string();
            case (kind)
                I2C_EVT_START: return "START";
                I2C_EVT_STOP : return "STOP";
                default      : return $sformatf("BYTE data=0x%02h ninth_bit=%0b", data, ack);
            endcase
        endfunction
    endclass

    class i2c_axi_sequencer extends uvm_sequencer #(i2c_axi_item);
        `uvm_component_utils(i2c_axi_sequencer)

        function new(string name = "i2c_axi_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    endclass

    class i2c_axi_driver extends uvm_driver #(i2c_axi_item);
        `uvm_component_utils(i2c_axi_driver)

        virtual axi_i2c_if vif;
        uvm_analysis_port #(i2c_bus_item) exp_ap;

        function new(string name = "i2c_axi_driver", uvm_component parent = null);
            super.new(name, parent);
            exp_ap = new("exp_ap", this);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db#(virtual axi_i2c_if)::get(this, "", "vif", vif)) begin
                `uvm_fatal("NOVIF", "i2c_axi_driver: virtual interface was not set")
            end
        endfunction

        task automatic set_idle();
            vif.awaddr  <= '0;
            vif.awprot  <= '0;
            vif.awvalid <= 1'b0;
            vif.wdata   <= '0;
            vif.wstrb   <= '0;
            vif.wvalid  <= 1'b0;
            vif.bready  <= 1'b0;
            vif.araddr  <= '0;
            vif.arprot  <= '0;
            vif.arvalid <= 1'b0;
            vif.rready  <= 1'b0;
        endtask

        task automatic wait_aclk();
            @(posedge vif.aclk);
        endtask

        // This DUT accepts AW and W together. VALID remains asserted until
        // both registered READY signals have been observed.
        task automatic axi_write(bit [3:0] addr, bit [31:0] data);
            int unsigned timeout;
            bit aw_w_done;

            @(negedge vif.aclk);
            vif.awaddr  <= addr;
            vif.awprot  <= 3'b000;
            vif.awvalid <= 1'b1;
            vif.wdata   <= data;
            vif.wstrb   <= 4'hF;
            vif.wvalid  <= 1'b1;
            vif.bready  <= 1'b1;

            timeout = 0;
            aw_w_done = 1'b0;
            while (!aw_w_done) begin
                wait_aclk();
                if (vif.awready && vif.wready) begin
                    aw_w_done = 1'b1;
                end
                timeout++;
                if (timeout > 100) begin
                    `uvm_fatal("AXI_TIMEOUT", $sformatf("Write handshake timeout at 0x%0h", addr))
                end
            end

            @(negedge vif.aclk);
            vif.awvalid <= 1'b0;
            vif.wvalid  <= 1'b0;

            timeout = 0;
            while (!vif.bvalid) begin
                wait_aclk();
                timeout++;
                if (timeout > 100) begin
                    `uvm_fatal("AXI_TIMEOUT", $sformatf("B response timeout at 0x%0h", addr))
                end
            end
            if (vif.bresp !== 2'b00) begin
                `uvm_error("AXI_BRESP", $sformatf("BRESP=%b at address 0x%0h", vif.bresp, addr))
            end

            @(negedge vif.aclk);
            vif.bready <= 1'b0;
        endtask

        task automatic axi_read(bit [3:0] addr, output bit [31:0] data);
            int unsigned timeout;
            bit ar_done;

            @(negedge vif.aclk);
            vif.araddr  <= addr;
            vif.arprot  <= 3'b000;
            vif.arvalid <= 1'b1;
            vif.rready  <= 1'b1;

            timeout = 0;
            ar_done = 1'b0;
            while (!ar_done) begin
                wait_aclk();
                if (vif.arready) begin
                    ar_done = 1'b1;
                end
                timeout++;
                if (timeout > 100) begin
                    `uvm_fatal("AXI_TIMEOUT", $sformatf("AR handshake timeout at 0x%0h", addr))
                end
            end

            @(negedge vif.aclk);
            vif.arvalid <= 1'b0;

            timeout = 0;
            while (!vif.rvalid) begin
                wait_aclk();
                timeout++;
                if (timeout > 100) begin
                    `uvm_fatal("AXI_TIMEOUT", $sformatf("R response timeout at 0x%0h", addr))
                end
            end

            data = vif.rdata;
            if (vif.rresp !== 2'b00) begin
                `uvm_error("AXI_RRESP", $sformatf("RRESP=%b at address 0x%0h", vif.rresp, addr))
            end

            @(negedge vif.aclk);
            vif.rready <= 1'b0;
        endtask

        // A new command clears done_flag first, so wait for a 0 then the
        // following 1. This avoids accepting a stale completion flag.
        task automatic wait_i2c_done(output bit [31:0] status);
            int unsigned timeout;
            bit seen_low;

            status = '0;
            timeout = 0;
            seen_low = 1'b0;
            while (1) begin
                axi_read(SR_ADDR, status);
                if (!status[1]) begin
                    seen_low = 1'b1;
                end
                if (seen_low && status[1]) begin
                    break;
                end
                timeout++;
                if (timeout > 20000) begin
                    `uvm_fatal("I2C_TIMEOUT", "Timed out while waiting for SR.done_flag")
                end
            end
        endtask

        task automatic publish_expected(i2c_evt_e kind,
                                        bit [7:0] data = 8'h00,
                                        bit ack = 1'b0);
            i2c_bus_item exp;
            exp = i2c_bus_item::type_id::create("exp_item");
            exp.kind = kind;
            exp.data = data;
            exp.ack  = ack;
            exp_ap.write(exp);
        endtask

        task automatic do_start();
            bit [31:0] status;

            publish_expected(I2C_EVT_START);
            axi_write(CR_ADDR, 32'h0000_0001); // CR[0] = START
            wait_i2c_done(status);

            if (status[0] !== 1'b1) begin
                `uvm_error("START_STATUS", "SR.busy must be 1 after START")
            end
        endtask

        task automatic do_write_byte(bit [7:0] tx_data);
            bit [31:0] status;
            bit [31:0] tdr_data;

            axi_write(TDR_ADDR, {24'h0, tx_data});
            axi_read(TDR_ADDR, tdr_data);
            if (tdr_data[7:0] !== tx_data) begin
                `uvm_error("TDR_CHECK", $sformatf(
                    "TDR expected 0x%02h, observed 0x%02h", tx_data, tdr_data[7:0]))
            end

            // No slave is attached. The ninth bit therefore remains high:
            // ACK_OUT must become 1 (NACK).
            publish_expected(I2C_EVT_BYTE, tx_data, 1'b1);
            axi_write(CR_ADDR, 32'h0000_0002); // CR[1] = WRITE
            wait_i2c_done(status);

            if (status[2] !== 1'b1) begin
                `uvm_error("NO_SLAVE_ACK", $sformatf(
                    "WRITE 0x%02h: expected SR.ack_out=1 (NACK), got %b",
                    tx_data, status[2]))
            end
            if (status[0] !== 1'b1) begin
                `uvm_error("WRITE_STATUS", "SR.busy must remain 1 before STOP")
            end
        endtask

        task automatic do_read_byte(bit master_ack);
            bit [31:0] status;
            bit [31:0] rdata;
            bit [31:0] cr_data;

            // No slave is attached and SDA is tri1, so the DUT samples FF.
            // The ninth SDA bit is driven by the master according to CR[8].
            publish_expected(I2C_EVT_BYTE, 8'hFF, master_ack);

            cr_data = 32'h0000_0004; // CR[2] = READ
            cr_data[8] = master_ack;
            axi_write(CR_ADDR, cr_data);
            wait_i2c_done(status);

            if (status[3] !== 1'b1) begin
                `uvm_error("RX_VALID", "SR.rx_valid_flag must be 1 after READ completion")
            end

            axi_read(RDR_ADDR, rdata);
            if (rdata[7:0] !== 8'hFF) begin
                `uvm_error("NO_SLAVE_READ", $sformatf(
                    "No slave is connected: expected RDR=FF, got 0x%02h", rdata[7:0]))
            end
        endtask

        task automatic do_stop();
            bit [31:0] status;

            publish_expected(I2C_EVT_STOP);
            axi_write(CR_ADDR, 32'h0000_0008); // CR[3] = STOP
            wait_i2c_done(status);

            if (status[0] !== 1'b0) begin
                `uvm_error("STOP_STATUS", "SR.busy must be 0 after STOP")
            end
        endtask

        task automatic execute_item(i2c_axi_item tr);
            `uvm_info("I2C_DRV", {"Executing ", tr.convert2string()}, UVM_MEDIUM)

            case (tr.op)
                I2C_WRITE_ONLY: begin
                    do_start();
                    do_write_byte(tr.tx_data);
                    do_stop();
                end
                I2C_READ_ONLY: begin
                    do_start();
                    do_read_byte(tr.master_ack);
                    do_stop();
                end
                I2C_WRITE_READ: begin
                    do_start();
                    do_write_byte(tr.tx_data);
                    do_start();  // repeated START
                    do_read_byte(tr.master_ack);
                    do_stop();
                end
                default: begin
                    `uvm_fatal("BAD_OP", "Unsupported i2c_axi_item.op")
                end
            endcase
        endtask

        task run_phase(uvm_phase phase);
            i2c_axi_item tr;

            wait (vif.aresetn === 1'b1);
            set_idle();

            forever begin
                seq_item_port.get_next_item(tr);
                execute_item(tr);
                seq_item_port.item_done();
            end
        endtask
    endclass

    // Passive monitor that uses only the DUT's external SCL/SDA pins.
    // With no slave BFM attached, it observes the actual byte stream, start,
    // stop, no-slave NACK, and master ACK/NACK bits.
    class i2c_pin_monitor extends uvm_component;
        `uvm_component_utils(i2c_pin_monitor)

        virtual axi_i2c_if vif;
        uvm_analysis_port #(i2c_bus_item) ap;

        function new(string name = "i2c_pin_monitor", uvm_component parent = null);
            super.new(name, parent);
            ap = new("ap", this);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db#(virtual axi_i2c_if)::get(this, "", "vif", vif)) begin
                `uvm_fatal("NOVIF", "i2c_pin_monitor: virtual interface was not set")
            end
        endfunction

        task automatic publish_actual(i2c_evt_e kind,
                                      bit [7:0] data = 8'h00,
                                      bit ack = 1'b0);
            i2c_bus_item act;
            act = i2c_bus_item::type_id::create("act_item");
            act.kind = kind;
            act.data = data;
            act.ack  = ack;
            `uvm_info("I2C_MON", {"Observed ", act.convert2string()}, UVM_MEDIUM)
            ap.write(act);
        endtask

        task automatic capture_one_byte();
            bit [7:0] data;
            bit ninth_bit;
            integer i;

            data = '0;
            for (i = 7; i >= 0; i = i - 1) begin
                @(posedge vif.scl);
                data[i] = vif.sda;
            end
            @(posedge vif.scl);
            ninth_bit = vif.sda;

            publish_actual(I2C_EVT_BYTE, data, ninth_bit);
        endtask

        task automatic watch_start_and_bytes();
            forever begin
                @(negedge vif.sda);
                if (vif.aresetn && (vif.scl === 1'b1)) begin
                    publish_actual(I2C_EVT_START);
                    fork
                        capture_one_byte();
                    join_none
                end
            end
        endtask

        task automatic watch_stop();
            forever begin
                @(posedge vif.sda);
                if (vif.aresetn && (vif.scl === 1'b1)) begin
                    publish_actual(I2C_EVT_STOP);
                end
            end
        endtask

        task run_phase(uvm_phase phase);
            fork
                watch_start_and_bytes();
                watch_stop();
            join
        endtask
    endclass

    class i2c_axi_scoreboard extends uvm_component;
        `uvm_component_utils(i2c_axi_scoreboard)

        uvm_tlm_analysis_fifo #(i2c_bus_item) exp_fifo;
        uvm_tlm_analysis_fifo #(i2c_bus_item) act_fifo;

        int unsigned pass_count;
        int unsigned fail_count;

        function new(string name = "i2c_axi_scoreboard", uvm_component parent = null);
            super.new(name, parent);
            exp_fifo = new("exp_fifo", this);
            act_fifo = new("act_fifo", this);
        endfunction

        task run_phase(uvm_phase phase);
            i2c_bus_item exp;
            i2c_bus_item act;

            forever begin
                exp_fifo.get(exp);
                act_fifo.get(act);

                if ((exp.kind !== act.kind) ||
                    ((exp.kind == I2C_EVT_BYTE) &&
                     ((exp.data !== act.data) || (exp.ack !== act.ack)))) begin
                    fail_count++;
                    `uvm_error("I2C_SCB", $sformatf(
                        "FAIL\n  expected: %s\n  actual  : %s",
                        exp.convert2string(), act.convert2string()))
                end else begin
                    pass_count++;
                    `uvm_info("I2C_SCB", {"PASS: ", act.convert2string()}, UVM_LOW)
                end
            end
        endtask

        function void check_phase(uvm_phase phase);
            super.check_phase(phase);
            if ((exp_fifo.used() != 0) || (act_fifo.used() != 0)) begin
                `uvm_error("I2C_SCB", $sformatf(
                    "Unmatched events remain: expected=%0d actual=%0d",
                    exp_fifo.used(), act_fifo.used()))
            end
            if (fail_count != 0) begin
                `uvm_error("I2C_SCB", $sformatf(
                    "Scoreboard result: PASS=%0d FAIL=%0d", pass_count, fail_count))
            end else begin
                `uvm_info("I2C_SCB", $sformatf(
                    "Scoreboard result: PASS=%0d FAIL=%0d", pass_count, fail_count), UVM_NONE)
            end
        endfunction
    endclass
class i2c_axi_coverage extends uvm_subscriber #(i2c_bus_item);
    `uvm_component_utils(i2c_axi_coverage)

    i2c_bus_item cov_tr;

    // ------------------------------------------------------------
    // Log에 보여줄 event / bin hit count
    // ------------------------------------------------------------
    int unsigned total_sample_cnt;

    int unsigned start_evt_cnt;
    int unsigned byte_evt_cnt;
    int unsigned stop_evt_cnt;

    int unsigned data_zero_cnt;
    int unsigned data_low_cnt;
    int unsigned data_mid_cnt;
    int unsigned data_high_cnt;
    int unsigned data_ff_cnt;

    int unsigned ninth_low_cnt;
    int unsigned ninth_high_cnt;

    covergroup cg_bus;
        option.per_instance = 1;

        cp_kind: coverpoint cov_tr.kind {
            bins start_evt = {I2C_EVT_START};
            bins data_byte = {I2C_EVT_BYTE};
            bins stop_evt  = {I2C_EVT_STOP};
        }

        cp_data: coverpoint cov_tr.data
            iff (cov_tr.kind == I2C_EVT_BYTE) {

            bins zero = {8'h00};
            bins low  = {[8'h01 : 8'h3F]};
            bins mid  = {[8'h40 : 8'hBF]};
            bins high = {[8'hC0 : 8'hFE]};
            bins ff   = {8'hFF};
        }

        cp_ninth_bit: coverpoint cov_tr.ack
            iff (cov_tr.kind == I2C_EVT_BYTE) {

            bins low  = {1'b0};
            bins high = {1'b1};
        }

        data_x_ninth: cross cp_data, cp_ninth_bit;
    endgroup

    function new(
        string name = "i2c_axi_coverage",
        uvm_component parent = null
    );
        super.new(name, parent);

        cg_bus = new;

        total_sample_cnt = 0;

        start_evt_cnt = 0;
        byte_evt_cnt  = 0;
        stop_evt_cnt  = 0;

        data_zero_cnt = 0;
        data_low_cnt  = 0;
        data_mid_cnt  = 0;
        data_high_cnt = 0;
        data_ff_cnt   = 0;

        ninth_low_cnt  = 0;
        ninth_high_cnt = 0;
    endfunction

    function void write(i2c_bus_item t);

        // coverage sample 시점에만 transaction handle 사용
        cov_tr = t;

        // covergroup coverage sample
        cg_bus.sample();

        // --------------------------------------------------------
        // Log용 counter 증가
        // --------------------------------------------------------
        total_sample_cnt++;

        case (t.kind)

            I2C_EVT_START: begin
                start_evt_cnt++;
            end

            I2C_EVT_STOP: begin
                stop_evt_cnt++;
            end

            I2C_EVT_BYTE: begin
                byte_evt_cnt++;

                // data bin count
                if (t.data == 8'h00) begin
                    data_zero_cnt++;
                end
                else if ((t.data >= 8'h01) &&
                         (t.data <= 8'h3F)) begin
                    data_low_cnt++;
                end
                else if ((t.data >= 8'h40) &&
                         (t.data <= 8'hBF)) begin
                    data_mid_cnt++;
                end
                else if ((t.data >= 8'hC0) &&
                         (t.data <= 8'hFE)) begin
                    data_high_cnt++;
                end
                else if (t.data == 8'hFF) begin
                    data_ff_cnt++;
                end

                // 9번째 ACK/NACK bit count
                if (t.ack == 1'b0) begin
                    ninth_low_cnt++;
                end
                else begin
                    ninth_high_cnt++;
                end
            end

            default: begin
            end

        endcase

        // 필요하면 transaction마다 coverage 상태를 보고 싶을 때 사용
        `uvm_info(
            "COV_SAMPLE",
            $sformatf(
                "kind=%s data=0x%02h ninth_bit=%0b | current coverage=%0.2f%%",
                t.kind.name(),
                t.data,
                t.ack,
                cg_bus.get_inst_coverage()
            ),
            UVM_HIGH
        )

    endfunction

    // ------------------------------------------------------------
    // Simulation 종료 시 coverage summary 출력
    // ------------------------------------------------------------
    function void report_phase(uvm_phase phase);

        super.report_phase(phase);

        `uvm_info(
            "COV_SUMMARY",
            $sformatf(
                "\n============================================================\n\
 I2C AXI Coverage Summary\n\
============================================================\n\
 Total samples         : %0d\n\
------------------------------------------------------------\n\
 Event count\n\
   START event          : %0d\n\
   BYTE event           : %0d\n\
   STOP event           : %0d\n\
------------------------------------------------------------\n\
 Data bin hit count\n\
   zero  (0x00)         : %0d\n\
   low   (0x01~0x3F)    : %0d\n\
   mid   (0x40~0xBF)    : %0d\n\
   high  (0xC0~0xFE)    : %0d\n\
   ff    (0xFF)         : %0d\n\
------------------------------------------------------------\n\
 9th bit hit count\n\
   ACK  (0)             : %0d\n\
   NACK (1)             : %0d\n\
------------------------------------------------------------\n\
 Covergroup coverage    : %0.2f %%\n\
============================================================",
                total_sample_cnt,

                start_evt_cnt,
                byte_evt_cnt,
                stop_evt_cnt,

                data_zero_cnt,
                data_low_cnt,
                data_mid_cnt,
                data_high_cnt,
                data_ff_cnt,

                ninth_low_cnt,
                ninth_high_cnt,

                cg_bus.get_inst_coverage()
            ),
            UVM_NONE
        );

    endfunction

endclass
    class i2c_axi_agent extends uvm_agent;
        `uvm_component_utils(i2c_axi_agent)

        i2c_axi_sequencer sqr;
        i2c_axi_driver    drv;
        i2c_pin_monitor   mon;

        function new(string name = "i2c_axi_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sqr = i2c_axi_sequencer::type_id::create("sqr", this);
            drv = i2c_axi_driver::type_id::create("drv", this);
            mon = i2c_pin_monitor::type_id::create("mon", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            drv.seq_item_port.connect(sqr.seq_item_export);
        endfunction
    endclass

    class i2c_axi_env extends uvm_env;
        `uvm_component_utils(i2c_axi_env)

        i2c_axi_agent      agent;
        i2c_axi_scoreboard scb;
        i2c_axi_coverage   cov;

        function new(string name = "i2c_axi_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent = i2c_axi_agent::type_id::create("agent", this);
            scb   = i2c_axi_scoreboard::type_id::create("scb", this);
            cov   = i2c_axi_coverage::type_id::create("cov", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agent.drv.exp_ap.connect(scb.exp_fifo.analysis_export);
            agent.mon.ap.connect(scb.act_fifo.analysis_export);
            agent.mon.ap.connect(cov.analysis_export);
        endfunction
    endclass

    // ------------------------------- Sequences -------------------------------
    class i2c_write_seq extends uvm_sequence #(i2c_axi_item);
        `uvm_object_utils(i2c_write_seq)
        int unsigned num_items = 3;

        function new(string name = "i2c_write_seq");
            super.new(name);
        endfunction

        task body();
            i2c_axi_item tr;
            repeat (num_items) begin
                tr = i2c_axi_item::type_id::create("write_tr");
                start_item(tr);
                assert(tr.randomize() with { op == I2C_WRITE_ONLY; });
                finish_item(tr);
            end
        endtask
    endclass

    class i2c_read_nack_seq extends uvm_sequence #(i2c_axi_item);
        `uvm_object_utils(i2c_read_nack_seq)
        int unsigned num_items = 2;

        function new(string name = "i2c_read_nack_seq");
            super.new(name);
        endfunction

        task body();
            i2c_axi_item tr;
            repeat (num_items) begin
                tr = i2c_axi_item::type_id::create("read_nack_tr");
                start_item(tr);
                assert(tr.randomize() with {
                    op == I2C_READ_ONLY;
                    master_ack == 1'b1;
                });
                finish_item(tr);
            end
        endtask
    endclass

    // Verifies CR[8]=0 drives SDA low during the ninth READ clock.
    class i2c_read_ack_seq extends uvm_sequence #(i2c_axi_item);
        `uvm_object_utils(i2c_read_ack_seq)
        int unsigned num_items = 2;

        function new(string name = "i2c_read_ack_seq");
            super.new(name);
        endfunction

        task body();
            i2c_axi_item tr;
            repeat (num_items) begin
            tr = i2c_axi_item::type_id::create("read_ack_tr");
            start_item(tr);
            assert(tr.randomize() with {
                op == I2C_READ_ONLY;
                master_ack == 1'b0;
            });
            finish_item(tr);
            end
        endtask
    endclass

    class i2c_write_read_seq extends uvm_sequence #(i2c_axi_item);
        `uvm_object_utils(i2c_write_read_seq)
        int unsigned num_items = 2;

        function new(string name = "i2c_write_read_seq");
            super.new(name);
        endfunction

        task body();
            i2c_axi_item tr;
            repeat (num_items) begin
                tr = i2c_axi_item::type_id::create("write_read_tr");
                start_item(tr);
                assert(tr.randomize() with {
                    op == I2C_WRITE_READ;
                    master_ack == 1'b1;
                });
                finish_item(tr);
            end
        endtask
    endclass

    class i2c_axi_base_test extends uvm_test;
        `uvm_component_utils(i2c_axi_base_test)

        i2c_axi_env env;

        function new(string name = "i2c_axi_base_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = i2c_axi_env::type_id::create("env", this);
        endfunction

        task automatic drain_bus();
            // Last observed STOP reaches the monitor at most a few ns after
            // the final command. Keep a margin before check_phase.
            #20us;
        endtask
    endclass

    class i2c_axi_smoke_test extends i2c_axi_base_test;
        `uvm_component_utils(i2c_axi_smoke_test)

        function new(string name = "i2c_axi_smoke_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            i2c_write_seq      wr_seq;
            i2c_read_nack_seq  rd_nack_seq;
            i2c_read_ack_seq   rd_ack_seq;
            i2c_write_read_seq wr_rd_seq;

            phase.raise_objection(this);

            wr_seq      = i2c_write_seq::type_id::create("wr_seq");
            rd_nack_seq = i2c_read_nack_seq::type_id::create("rd_nack_seq");
            rd_ack_seq  = i2c_read_ack_seq::type_id::create("rd_ack_seq");
            wr_rd_seq   = i2c_write_read_seq::type_id::create("wr_rd_seq");

            wr_seq.num_items      = 3;
            rd_nack_seq.num_items = 2;
            wr_rd_seq.num_items   = 2;

            wr_seq.start(env.agent.sqr);
            rd_nack_seq.start(env.agent.sqr);
            rd_ack_seq.start(env.agent.sqr);
            wr_rd_seq.start(env.agent.sqr);

            drain_bus();
            phase.drop_objection(this);
        endtask
    endclass

    class i2c_axi_random_test extends i2c_axi_base_test;
        `uvm_component_utils(i2c_axi_random_test)

        function new(string name = "i2c_axi_random_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            i2c_write_seq      wr_seq;
            i2c_read_nack_seq  rd_nack_seq;
            i2c_read_ack_seq  rd_ack_seq;
            i2c_write_read_seq wr_rd_seq;
            int unsigned count;

            phase.raise_objection(this);

            count = 100;
            void'($value$plusargs("NUM_ITEMS=%0d", count));

            wr_seq    = i2c_write_seq::type_id::create("wr_seq");
        rd_nack_seq = i2c_read_nack_seq::type_id::create("rd_nack_seq");
        rd_ack_seq  = i2c_read_ack_seq::type_id::create("rd_ack_seq");
            wr_rd_seq = i2c_write_read_seq::type_id::create("wr_rd_seq");

            wr_seq.num_items    = count;
        rd_nack_seq.num_items = count;
        rd_ack_seq.num_items  = count;
            wr_rd_seq.num_items = count;

            wr_seq.start(env.agent.sqr);
        // READ 후 master가 NACK(1) 전송
        rd_nack_seq.start(env.agent.sqr);

        // READ 후 master가 ACK(0) 전송
        rd_ack_seq.start(env.agent.sqr);
            wr_rd_seq.start(env.agent.sqr);

            drain_bus();
            phase.drop_objection(this);
        endtask
    endclass

endpackage
