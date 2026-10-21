`timescale 1ns / 1ps



module top_vga_colorbar (
    input logic clk,
    input logic rst,
    input logic [3:0] sw_r,
    input logic [3:0] sw_g,
    input logic [3:0] sw_b,
    input logic sw_mode,
    output logic hsync,
    output logic vsync,
    output logic [3:0] port_r,
    output logic [3:0] port_g,
    output logic [3:0] port_b
);

    logic de;
    logic w_hsync, w_vsync;
    logic [9:0] x_pixel;
    logic [9:0] y_pixel;

    logic [11:0] w_colorbar_rgb;
    logic [11:0] w_rgbsw_rgb;
    logic [11:0] w_rgb,r_rgb;
assign {port_r, port_g, port_b} = r_rgb;

    ColorBar U_COLORBAR (
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .de(de),
        .*,
        .port_r(w_colorbar_rgb[11:8]),
        .port_g(w_colorbar_rgb[7:4]),
        .port_b(w_colorbar_rgb[3:0])
    );

    VGA_Decoder U_VGA_DECODER (
        .*,
        .hsync(w_hsync),
        .vsync(w_vsync),
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .de(de)
    );
    VGA_RGB_SW U_VGA_RGB_SW (
        .*,
        .de(de),
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .port_r(w_rgbsw_rgb[11:8]),
        .port_g(w_rgbsw_rgb[7:4]),
        .port_b(w_rgbsw_rgb[3:0])
    );


    mux U_MUX (
        .sel(sw_mode),
        .a  (w_rgbsw_rgb),
        .b  (w_colorbar_rgb),
        .y  (w_rgb)
    );

 VGA_OutReg U_VGA_OUTREG(
    .clk(clk),
    .rst(rst),
    .i_hsync(w_hsync),
    .i_vsync(w_vsync),
    .i_rgb(w_rgb),
    .o_hsync(hsync),
    .o_vsync(vsync),
    .o_rgb(r_rgb)
);

endmodule


module mux (
    input logic sel,
    input logic [11:0] a,
    input logic [11:0] b,
    output logic [11:0] y
);


    assign y = sel ? b : a;

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
    assign o_rgb = r_rgb;

    
endmodule
