`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/12 16:40:45
// Design Name: 
// Module Name: tb_i2c_master
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


module tb_i2c_master(

    );

    localparam SLA = 8'h12;     //slave address
    logic       clk;
    logic       rst;
    logic       cmd_start;
    logic       cmd_write;
    logic       cmd_read;
    logic       cmd_stop;
    logic [7:0] tx_data;
    logic [7:0] rx_data;
    logic       ack_in;
    logic       ack_out;
    logic       busy;
    logic       done;
    logic       scl;
    wire       sda;     //inout은 wire

pullup (scl);
pullup (sda);
i2c_master_top dut (.*);

always #5 clk = ~clk;

task i2c_start();

    cmd_start = 1'b1;
    cmd_write = 1'b0;
    cmd_read = 1'b0;
    cmd_stop = 1'b0;
    @(posedge clk);
    wait (done);        //start signal 기다리기
    @(posedge clk);
endtask


task i2c_write(byte data);
    tx_data = data;
    cmd_start = 1'b0;
    cmd_write = 1'b1;
    cmd_read = 1'b0;
    cmd_stop = 1'b0;
    @(posedge clk);
    wait (done);    
    @(posedge clk);


endtask

task i2c_read ( );
    cmd_start = 1'b0;
    cmd_write = 1'b0;
    cmd_read = 1'b1;
    cmd_stop = 1'b0;
    @(posedge clk);
    wait (done);    
    @(posedge clk);


endtask

    //stop 보냈으니까 IDLE 로 넘어감
    //IDLE

task i2c_stop();
    cmd_start = 1'b0;
    cmd_write = 1'b0;
    cmd_read = 1'b0;
    cmd_stop = 1'b1;
    @(posedge clk);
    wait (done);    
    @(posedge clk);

endtask


initial begin
    clk = 0;
    rst = 1;

    repeat(5)     @(posedge clk);
    rst = 0;
    @(posedge clk);


    i2c_start();
    i2c_write(SLA << 1 | 1'b0);
    i2c_write(8'h55);
    i2c_write(8'haa);
    // i2c_read();
    i2c_stop();
    //SLA write
    //DATA write

    //STOP signal
    
    #50;
    $finish;


end


endmodule
