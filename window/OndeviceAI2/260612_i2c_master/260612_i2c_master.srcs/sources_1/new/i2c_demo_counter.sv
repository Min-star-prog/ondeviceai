`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/15 11:19:48
// Design Name: 
// Module Name: i2c_demo_counter
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


module i2c_demo_counter(
    input logic clk,
    input logic rst,
    input logic sw,
    output logic scl,
    inout logic sda
    );

typedef enum logic [2:0] { 
    IDLE = 0,
    START,
    ADDR,
    WRITE,
    STOP
} i2c_state_e;

i2c_state_e state;
localparam SLA_W = {7'h12, 1'b0};

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

logic [1:0] dff; // synchronizer
logic sw_r;
logic [7:0] counter;

assign sw_r = dff[1];

i2c_master_top dut1(.*);


always_ff @(posedge clk, posedge rst) begin
    if(rst) begin
        dff <= 0;
    end else begin
        dff[0] <= sw;
        dff[1] <= dff[0];

    end
end

always_ff @(posedge clk, posedge rst) begin
if(rst) begin
    state <= IDLE;
    counter <= 0;
    cmd_start <= 1'b0;
    cmd_write <= 1'b0;
    cmd_read  <= 1'b0;
    cmd_stop  <= 1'b0;
    tx_data <= 0;
end else begin
    case (state) 
    IDLE : begin
    cmd_start <= 1'b0;
    cmd_write <= 1'b0;
    cmd_read  <= 1'b0;
    cmd_stop  <= 1'b0;
    if(sw_r) begin
        state <= START;
    end
        
    end
    START : begin
        cmd_start <= 1'b1;
    cmd_write <= 1'b0;
    cmd_read  <= 1'b0;
    cmd_stop  <= 1'b0;
        if(done) begin  //master에서 done을 받으면 addr로
        state <= ADDR;
        end
    end
    ADDR : begin
    cmd_start <= 1'b0;
    cmd_write <= 1'b1;
    cmd_read  <= 1'b0;
    cmd_stop  <= 1'b0;
    tx_data <= SLA_W;
    if(done) begin
        state <= WRITE;
    end

    end
    WRITE : begin
    cmd_start <= 1'b0;
    cmd_write <= 1'b1;
    cmd_read  <= 1'b0;
    cmd_stop  <= 1'b0;
    tx_data <= counter;
    if(done) begin
        state <= STOP;
    end


    end
    STOP : begin
    cmd_start <= 1'b0;
    cmd_write <= 1'b0;
    cmd_read  <= 1'b0;
    cmd_stop  <= 1'b1;
    tx_data <= counter;
    if(done) begin
        state <= IDLE;
        counter <= counter + 1;
    end

    end
    default : state <= IDLE;

    endcase

end
end
endmodule
