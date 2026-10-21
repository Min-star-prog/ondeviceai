module VGA_SW_Top (
    input logic clk,
    input logic rst,
    input logic [3:0] sw_r,
    input logic [3:0] sw_g,
    input logic [3:0] sw_b,
    output logic hsync,
    output logic vsync,
    output logic [3:0] port_r,
    output logic [3:0] port_b,
    output logic [3:0] port_g
);


    logic [9:0] x_pixel;
    logic [9:0] y_pixel;
    logic de;
    VGA_RGB_SW U_VGA_RGB_SW (
        .*,
        .de(de),
        .x_pixel(x_pixel),
        .y_pixel(y_pixel)
    );

    VGA_Decoder U_VGA_DECODER (
        .*,
        .de(de),
        .x_pixel(x_pixel),
        .y_pixel(y_pixel)
    );




endmodule
