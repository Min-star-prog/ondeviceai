`timescale 1ns / 1ps

//sync 신호를 관찰하자

module tb_vga_sw();


    logic clk;
    logic rst;
    logic [3:0] sw_r;
    logic [3:0] sw_g;
    logic [3:0] sw_b;
     logic hsync;
     logic vsync;
     logic [3:0] port_r;
     logic [3:0] port_b;
     logic [3:0] port_g;

VGA_SW_Top dut (.*);

initial clk = 0;
always #5 clk = ~clk;

initial begin
rst = 1;
repeat (5) @(posedge clk);
rst = 0;
 @(posedge clk);

 sw_r = 4'hf;
 sw_g = 4'hf;
 sw_b = 4'hf;

wait(!vsync);
 @(posedge clk);
wait(vsync);
 @(posedge clk);

 
wait(!vsync);
 @(posedge clk);
wait(vsync);
 @(posedge clk);

 
wait(!vsync);
 @(posedge clk);
wait(vsync);
 @(posedge clk);

$finish;

end

endmodule
