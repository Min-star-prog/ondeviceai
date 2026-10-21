`timescale 1ns / 1ps




module top_VGA_Lenna (
    input logic clk,
    input logic rst,
    input logic sw_mode,
    input logic sw_gray,
    input logic sw_bin,
    input logic sw_inv,
    input logic [3:0] sw_bin_thr,
    output logic hsync,
    output logic vsync,
    output logic [3:0] port_r,
    output logic [3:0] port_g,
    output logic [3:0] port_b
);

    logic       w_hsync,w_hsync2,w_hsync3;
    logic       w_vsync,w_vsync2,w_vsync3;
    logic [9:0] x_pixel;
    logic [9:0] y_pixel;
    logic       de;
    logic [16:0] rom_addr, qvga_addr, upscale_addr;
    logic [15:0] rom_px_data, qvga_px_data, upscale_px_data;
    logic [11:0] gray_rgb, w_rgb,w_rgb2,w_rgb3, qvga_w_rgb, upscale_w_rgb;

    VGA_Decoder U_VGA_DECODER (
        .*,
        .hsync(w_hsync),
        .vsync(w_vsync),
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .de(de)
    );

    rom_reader U_ROM_READER (
        .*,
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .addr(qvga_addr),
        .px_data(qvga_px_data),
        .o_rgb(qvga_w_rgb)
    );


    rom_reader_upscale U_ROM_READER_upscale (
        .*,
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .addr(upscale_addr),
        .px_data(upscale_px_data),
        .o_rgb(upscale_w_rgb)
    );

    assign rom_addr = sw_mode ? upscale_addr : qvga_addr;  //MUX

    image_rom U_IMAGE_ROM (
        .addr(rom_addr),
        .px_data(rom_px_data),
        .*
    );

    //DEMUX
    always_comb begin
        qvga_px_data = 0;
        upscale_px_data = 0;
        case (sw_mode)
            1'b0: qvga_px_data = rom_px_data;
            1'b1: upscale_px_data = rom_px_data;
            default: begin
                qvga_px_data = 0;
                upscale_px_data = 0;
            end
        endcase
    end

    assign w_rgb = sw_mode ? upscale_w_rgb : qvga_w_rgb;  //MUX

    VGA_OutReg U_VGA_OUTREG (
        .clk(clk),
        .rst(rst),
        .i_hsync(w_hsync),
        .i_vsync(w_vsync),
        .i_rgb(w_rgb),
        .o_hsync(w_hsync2),
        .o_vsync(w_vsync2),
        .o_rgb(w_rgb2)
    );


// gray_filter U_GRAY_FILTER(
// .i_rgb(w_rgb2),
// .o_rgb(gray_rgb)
//     );
gray_filter_pipe U_GRAY_FILTER_PIPE(
    .*,
    .sw_gray(sw_gray),
    .i_hsync(w_hsync2),
    .i_vsync(w_vsync2),
    .i_rgb(w_rgb2),
    .o_hsync(w_hsync3),
    .o_vsync(w_vsync3),
    .o_rgb(w_rgb3)
);

binary_filter U_BINARY_FILTER(
    .*,
    .i_hsync(w_hsync3),
    .i_vsync(w_vsync3),
    .i_rgb(w_rgb3),
    .o_hsync(hsync),
    .o_vsync(vsync),
    .o_rgb({port_r, port_g, port_b} )
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

