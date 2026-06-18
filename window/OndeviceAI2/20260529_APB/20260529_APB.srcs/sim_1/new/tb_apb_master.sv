`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/29 15:04:35
// Design Name: 
// Module Name: tb_apb_master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_apb_master();

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

apb_master U_APB_MASTER(.*);


always #5 pclk = ~pclk;

initial begin
pclk = 0;
preset = 1;

@(negedge pclk);
@(negedge pclk);
preset = 0;

//RAM Write test, 0x1000_0000
@(posedge pclk);
#1;
//CPU -> APB Master
addr = 32'h1000_0000;
wdata = 32'h0a0a_5050;
w_req = 1'b1;
r_req = 0;

// Completer response
@(penable & psel0)
pready0 = 1'b1;
@(posedge pclk);
@(posedge pclk);

$stop;


end

endmodule
