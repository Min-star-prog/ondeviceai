`timescale 1ns / 1ps



module frame_buffer #(
    parameter IMG_W = 320,
    parameter IMG_H = 240,
    parameter DW = 16,  //Data Width = 16bit
    parameter AW = $clog2(IMG_W * IMG_H)  // Address Width
) (
    //Write side (camera, pclk)
    input  logic          wclk,
    input  logic          we,
    input  logic [AW-1:0] waddr,
    input  logic [DW-1:0] wdata,
    //read side(VGA, clk)
    input  logic          rclk,
    input  logic [AW-1:0] raddr,
    output logic [DW-1:0] rdata
);


    logic [DW-1:0] mem[0:IMG_W*IMG_H-1];

    // write
    always @(posedge wclk) begin
        if (we) begin
            mem[waddr] <= wdata;
        end
    end

    //read
    always @(posedge rclk) begin
        rdata <= mem[raddr];
    end

endmodule



