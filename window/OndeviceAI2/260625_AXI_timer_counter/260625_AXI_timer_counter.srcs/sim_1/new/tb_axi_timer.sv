`timescale 1ns / 1ps


module tb_axi_timer();

		parameter integer C_S00_AXI_DATA_WIDTH	= 32;
		parameter integer C_S00_AXI_ADDR_WIDTH	= 4;

logic clk;
logic rst_n;

logic  intr;
logic  s00_axi_aclk;
logic  s00_axi_aresetn;
logic [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr;
logic [2 : 0] s00_axi_awprot;
logic  s00_axi_awvalid;
logic   s00_axi_awready;
logic [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata;
logic [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb;
logic  s00_axi_wvalid;
logic   s00_axi_wready;
logic  [1 : 0] s00_axi_bresp;
logic   s00_axi_bvalid;
logic  s00_axi_bready;
logic [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr;
logic [2 : 0] s00_axi_arprot;
logic  s00_axi_arvalid;
logic   s00_axi_arready;
logic  [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata;
logic  [1 : 0] s00_axi_rresp;
logic   s00_axi_rvalid;
logic  s00_axi_rready;


axi_timer_v1_0 dut(.*);

assign s00_axi_aclk =  clk;
assign s00_axi_aresetn =  rst_n;

always #5 clk = ~clk;

localparam tim_cr_addr = 32'h0000_0000;
localparam tim_psc_addr = 32'h0000_0004;
localparam tim_arr_addr = 32'h0000_0008;
localparam tim_cnt_addr = 32'h0000_000c;
logic [31:0] cr, psc,arr,cnt;

task axi_writedata(logic [31:0] addr, logic [31:0] data);
    s00_axi_awaddr <= addr;
    s00_axi_wdata <= data;
    s00_axi_awvalid <= 1'b1;
    s00_axi_wvalid <= 1'b1;
    s00_axi_bready <= 1'b1;
    s00_axi_wstrb <=4'b1111;
    @(posedge clk);
    wait(s00_axi_awready & s00_axi_wready);
    @(posedge clk);    
    s00_axi_awvalid <= 1'b0;
    s00_axi_wvalid <= 1'b0;
    @(posedge clk);    
    wait(s00_axi_bvalid);
    @(posedge clk);    
    s00_axi_bready <= 1'b0;
    @(posedge clk);    
endtask

task axi_readdata(logic [31:0] addr);
    s00_axi_araddr  <= addr;
    s00_axi_arvalid  <= 1'b1;
    s00_axi_rready <= 1'b1;
    @(posedge clk);
    wait(s00_axi_arready);
    @(posedge clk);
    s00_axi_arvalid  <= 1'b0;
    @(posedge clk);
    
    wait(s00_axi_rvalid);
    s00_axi_rready  <= 1'b0;
    @(posedge clk);


endtask






initial begin
    clk = 0;
    rst_n = 0;
    cr =0; psc=0; arr=0; cnt=0; 
    repeat(5) @(posedge clk);
    rst_n = 1;
    @(posedge clk);

    psc = 100-1;
    axi_writedata(tim_psc_addr,psc);
    arr = 1000-1;
    axi_writedata(tim_arr_addr,arr);
    cr |= (1<<0) |(1<<1); 
    axi_writedata(tim_cr_addr,cr);

    wait(intr);
    @(posedge clk);
    #30_000;

    repeat(5) @(posedge clk);

    axi_readdata(tim_cr_addr);
    axi_readdata(tim_psc_addr);
    axi_readdata(tim_arr_addr);
    #3_000;
    axi_readdata(tim_cnt_addr);

    #1000;
    $finish;




    // axi_readdata();
end











endmodule
