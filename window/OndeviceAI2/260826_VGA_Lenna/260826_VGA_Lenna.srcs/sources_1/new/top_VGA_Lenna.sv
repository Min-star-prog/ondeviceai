`timescale 1ns / 1ps




module top_VGA_Lenna (
    input logic clk,
    input logic rst,
    output logic hsync,
    output logic vsync,
    output logic [3:0] port_r,
    output logic [3:0] port_g,
    output logic [3:0] port_b
);

    logic        w_hsync;
    logic        w_vsync;
    logic [ 9:0] x_pixel;
    logic [ 9:0] y_pixel;
    logic        de;
    logic [16:0] addr;
    logic [15:0] px_data;
    logic [11:0] w_rgb;

    rom_reader U_ROM_READER (
        .*,
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .o_rgb(w_rgb)
    );

    image_rom U_IMAGE_ROM (
        .*
    );

    VGA_Decoder U_VGA_DECODER (
        .*,
        .hsync(w_hsync),
        .vsync(w_vsync),
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .de(de)
    );


    VGA_OutReg U_VGA_OUTREG (
        .clk(clk),
        .rst(rst),
        .i_hsync(w_hsync),
        .i_vsync(w_vsync),
        .i_rgb(w_rgb),
        .o_hsync(hsync),
        .o_vsync(vsync),
        .o_rgb({port_r,port_g,port_b})
    );




endmodule




module VGA_OutReg (
    input  logic        clk,
    input  logic        rst,
    input  logic        i_hsync,
    input  logic        i_vsync,
    input  logic [11:0] i_rgb,
    output logic        o_hsync,
    output logic        o_vsync,
    output logic [11:0] o_rgb
);

    logic r_hsync, r_vsync;
    logic [11:0] r_rgb;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            r_rgb   <= 0;
            r_hsync <= 1;
            r_vsync <= 1;
        end else begin
            r_rgb   <= i_rgb;
            r_hsync <= i_hsync;
            r_vsync <= i_vsync;
        end
    end

    assign o_hsync = r_hsync;
    assign o_vsync = r_vsync;
    assign o_rgb   = r_rgb;


endmodule
