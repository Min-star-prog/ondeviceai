`timescale 1ns / 1ps


module image_rom (
    input  logic        clk,
    input  logic [16:0] addr,
    output logic [15:0] px_data
);

    logic [15:0] mem[0:320*240-1];
    initial $readmemh("Lenna_320x240.mem", mem);

//BRAM
    always @(posedge clk) begin
        px_data <= mem[addr];

    end

//LUT
// assign px_data = mem[addr];

endmodule
