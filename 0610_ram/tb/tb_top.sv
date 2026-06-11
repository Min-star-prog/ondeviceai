import uvm_pkg::*;
import ram_pkg::*;




module tb_top ();



    logic clk;


    ram_intf ram_if (clk);

    ram dut (
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


    initial begin                           //initial에는 처음에 delay 주면 안됨(ex) #10, posedge clk)
        uvm_config_db#(virtual ram_intf)::set(null, "*", "ram_vif", ram_if);
        run_test("ram_test");
    end




endmodule
