`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/28 14:48:53
// Design Name: 
// Module Name: tb_ram
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


module tb_ram(

    );

reg clk;
reg [3:0] addr;
reg [7:0] wdata;
reg we;
wire [7:0] rdata;


ram dut1(
.addr(addr),
.wdata(wdata),
.we(we),
.clk(clk),
.rdata(rdata)
);


always #5 clk = ~clk;
initial begin
clk = 0;
addr = 0;
we = 0;
@(negedge clk); we = 1;
@(negedge clk); addr = 4'd10; wdata = 8'h0a;
@(negedge clk); addr = 4'd11; wdata = 8'h0b;
@(negedge clk); addr = 4'd14; wdata = 8'h0c;
@(negedge clk); addr = 4'd15; wdata = 8'h0d;

@(negedge clk); we = 0; addr = 4'd10;
@(negedge clk);         addr = 4'd11;
@(negedge clk);         addr = 4'd14;
@(negedge clk);         addr = 4'd15;
#20;
$stop;

end

endmodule
