interface ram_intf (
    input logic clk
);

    logic       clk;
    logic       we;
    logic [7:0] addr;
    logic [7:0] wdata;
    logic [7:0] rdata;

    clocking drv_cb @(posedge clk);
        default input #1step output #0;
        output we;
        output addr;
        output wdata;
        input rdata;

    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step;
        input we;
        input addr;
        input wdata;
        input rdata;

    endclocking

    modport DRV(clocking drv_cb, input clk);  //Modport : interface에서 signal 방향을 정의
    modport MON(clocking mon_cb, input clk);




endinterface
