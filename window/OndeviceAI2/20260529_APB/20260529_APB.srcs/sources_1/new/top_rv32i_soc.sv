`timescale 1ns / 1ps




module top_rv32i_soc (
    input clk,
    input rst

);

    logic [31:0] instr_addr, instr_code;
    logic [2:0] mem_mode;
    // logic       dwe;
    logic        pclk;
    logic        preset;
    logic [31:0] addr;
    logic [31:0] wdata;
    logic        w_req;
    logic        r_req;
    logic [31:0] rdata;
    logic        ready;
    logic [31:0] paddr;
    logic [31:0] pwdata;
    logic        penable;
    logic        pwrite;
    logic        psel0;     //RAM
    logic        psel1;     //GPO
    logic        psel2;     //GPI
    logic        psel3;     //GPIO
    logic        psel4;
    logic [31:0] prdata0;
    logic [31:0] prdata1;
    logic [31:0] prdata2;
    logic [31:0] prdata3;
    logic [31:0] prdata4;
    logic        pready0;
    logic        pready1;
    logic        pready2;
    logic        pready3;
    logic        pready4;

    rv32i_cpu U_RV32I_CPU (.*);
    
    instruction_mem U_INSTR_ROM (.*);

    apb_master U_APB_MASTER(.*,
    
    //BUS Global Signal
    .pclk(clk),
    .preset(rst),

    .addr(addr),
    .wdata(wdata),
    .w_req(w_req),
    .r_req(r_req),
    .ready(ready),
    .rdata(rdata),

    .psel0(psel0),
    .pready0(pready0),
    .prdata0(prdata0)

    );


    apb_bram U_APB_BRAM(
        .*,
    .pclk(clk),
    .psel(psel0),
    .pready(pready0),
    .prdata(prdata0)
    );

    //data_mem U_DATA_RAM (.*);
endmodule
