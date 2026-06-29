`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/26 13:01:59
// Design Name: 
// Module Name: tb_axi_uart
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


module tb_axi_uart ();

    parameter integer C_S00_AXI_DATA_WIDTH = 32;
    parameter integer C_S00_AXI_ADDR_WIDTH = 4;

    logic clk;
    logic rst_n;

    wire tx;
    wire rx;
    logic w_loop;
    logic intr;
    logic s00_axi_aclk;
    logic s00_axi_aresetn;
    logic [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr;
    logic [2 : 0] s00_axi_awprot;
    logic s00_axi_awvalid;
    logic s00_axi_awready;
    logic [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata;
    logic [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb;
    logic s00_axi_wvalid;
    logic s00_axi_wready;
    logic [1 : 0] s00_axi_bresp;
    logic s00_axi_bvalid;
    logic s00_axi_bready;
    logic [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr;
    logic [2 : 0] s00_axi_arprot;
    logic s00_axi_arvalid;
    logic s00_axi_arready;
    logic [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata;
    logic [1 : 0] s00_axi_rresp;
    logic s00_axi_rvalid;
    logic s00_axi_rready;


    axi_uart_top dut (
        .*,
        .tx(w_loop),
        .rx(w_loop)
    );


    logic [31:0] cr, tdr, rdr, sr;


    assign s00_axi_aclk = clk;
    assign s00_axi_aresetn = rst_n;

    always #5 clk = ~clk;

    localparam uart_sr_addr = 32'h0000_0000;
    localparam uart_tdr_addr = 32'h0000_0004;
    localparam uart_rdr_addr = 32'h0000_0008;
    localparam uart_cr_addr = 32'h0000_000c;



    task axi_writedata(logic [31:0] addr, logic [31:0] data);
        s00_axi_awaddr  <= addr;
        s00_axi_wdata   <= data;
        s00_axi_awvalid <= 1'b1;
        s00_axi_wvalid  <= 1'b1;
        s00_axi_bready  <= 1'b1;
        s00_axi_wstrb   <= 4'b1111;
        @(posedge clk);
        wait (s00_axi_awready & s00_axi_wready);
        @(posedge clk);
        s00_axi_awvalid <= 1'b0;
        s00_axi_wvalid  <= 1'b0;
        @(posedge clk);
        wait (s00_axi_bvalid);
        @(posedge clk);
        s00_axi_bready <= 1'b0;
        @(posedge clk);
    endtask

    task axi_readdata(input logic [31:0] addr, output logic [31:0] rdata);
        s00_axi_araddr  <= addr;
        s00_axi_arvalid <= 1'b1;
        s00_axi_rready  <= 1'b1;
        @(posedge clk);
        wait (s00_axi_arready);
        @(posedge clk);
        s00_axi_arvalid <= 1'b0;

        wait (s00_axi_rvalid);
        @(posedge clk);
        s00_axi_rready <= 1'b0;
        rdata <= s00_axi_rdata;
        @(posedge clk);


    endtask

    initial begin
        rst_n = 0;
        clk = 0;

        cr = 0;
        sr = 0;
        tdr = 0;
        rdr = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        cr |= (1 << 0);
        axi_writedata(uart_cr_addr, cr);


        //falling 방식(rx_flag 읽는 방식)

        do begin
            axi_readdata(uart_sr_addr, sr);
        end while (!(sr & (1 << 0)));

        tdr = 8'haa;
        axi_writedata(uart_tdr_addr, tdr);

        do begin
            axi_readdata(uart_sr_addr, sr);
        end while (!(sr & (1 << 1)));  //rx_flag 올때까지 기다림
        axi_readdata(uart_rdr_addr, rdr);  //rx_flag 오면 rdr 읽어





        do begin
            axi_readdata(uart_sr_addr, sr);
        end while (!(sr & (1 << 0)));
        tdr = 8'h55;
        axi_writedata(uart_tdr_addr, tdr);

        do begin
            axi_readdata(uart_sr_addr, sr);
        end while (!(sr & (1 << 1)));  //rx_flag 올때까지 기다림
        axi_readdata(uart_rdr_addr, rdr);  //rx_flag 오면 rdr 읽어





        do begin
            axi_readdata(uart_sr_addr, sr);
        end while (!(sr & (1 << 0)));
        tdr = 8'h12;
        axi_writedata(uart_tdr_addr, tdr);

        do begin
            axi_readdata(uart_sr_addr, sr);
        end while (!(sr & (1 << 1)));  //rx_flag 올때까지 기다림
        axi_readdata(uart_rdr_addr, rdr);  //rx_flag 오면 rdr 읽어





        do begin
            axi_readdata(uart_sr_addr, sr);
        end while (!(sr & (1 << 0)));
        tdr = 8'h34;
        axi_writedata(uart_tdr_addr, tdr);

        do begin
            axi_readdata(uart_sr_addr, sr);
        end while (!(sr & (1 << 1)));  //rx_flag 올때까지 기다림
        axi_readdata(uart_rdr_addr, rdr);  //rx_flag 오면 rdr 읽어





        //interrupt 방식

        do begin
            axi_readdata(uart_sr_addr, sr);
        end while (!(sr & (1 << 0)));
        tdr = 8'hff;
        axi_writedata(uart_tdr_addr, tdr);
        wait (intr);
        @(posedge clk);
        axi_readdata(uart_rdr_addr, rdr);
        @(posedge clk);


        do begin
            axi_readdata(uart_sr_addr, sr);
        end while (!(sr & (1 << 0)));
        tdr = 8'h11;
        axi_writedata(uart_tdr_addr, tdr);
        wait (intr);
        @(posedge clk);
        axi_readdata(uart_rdr_addr, rdr);
        @(posedge clk);


        do begin
            axi_readdata(uart_sr_addr, sr);
        end while (!(sr & (1 << 0)));
        tdr = 8'h22;
        axi_writedata(uart_tdr_addr, tdr);
        wait (intr);
        @(posedge clk);
        axi_readdata(uart_rdr_addr, rdr);
        @(posedge clk);









        repeat (5) @(posedge clk);
        // axi_readdata(uart_rdr_addr);

        #1000;
        $finish;
    end
endmodule



