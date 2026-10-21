`timescale 1ns / 1ps




module top_OV7670 (
    input  logic       clk,
    input  logic       rst,
    // OV7670 side
    output logic       xclk,
    input  logic       pclk,
    input  logic       cam_href,
    input  logic       cam_vsync,
    input  logic [7:0] cam_data,
    //VGA side
    output logic       hsync,
    output logic       vsync,
    output logic [3:0] port_r,
    output logic [3:0] port_g,
    output logic [3:0] port_b,
    //sccb side
    output wire sioc,
    inout wire siod
);


    parameter IMG_W = 320;
    parameter IMG_H = 240;
    parameter DW = 16;  //Data Width = 16bit
    parameter AW = $clog2(IMG_W * IMG_H);  // Address Width

    logic [1:0] xclk_cnt;




    always_ff @(posedge clk or posedge rst) begin
        if (rst) xclk_cnt <= 0;
        else xclk_cnt <= xclk_cnt + 1'b1;
    end

    assign xclk = xclk_cnt[1];


    // pclk_gen U_PCLK_GEN(
    //     .clk(clk),
    //     .rst(rst),
    //     .pclk(xclk)
    // );

    logic we;
    logic [16:0] waddr;
    logic [15:0] wdata;

    logic [9:0] x_pixel;
    logic [9:0] y_pixel;
    logic de;
    logic w_hsync;
    logic w_vsync;
    logic [AW-1:0] raddr;
    logic [DW-1:0] rdata;
    logic [11:0] w_rgb;


    logic init_done;
    logic init_error;
    logic [6:0] debug_index;

sccb_setup_controller U_SCCB_SETUP_CONTROLLER(
    .clk(clk),
    .rst(rst),
    .sioc(sioc),
    .siod(siod),
    .init_done(init_done),
    .init_error(init_error),
    .debug_index(debug_index)
);










    OV7670_Mem_Ctrl U_OV7670_MEM_CTRL (
        .pclk(pclk),
        .rst(rst),
        .cam_href(cam_href),
        .cam_vsync(cam_vsync),
        .cam_data(cam_data),
        .we(we),
        .waddr(waddr),
        .wdata(wdata)
    );



    frame_buffer U_FRAME_BUFFER (
        .wclk(pclk),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(clk),
        .raddr(raddr),
        .rdata(rdata)
    );


    frame_buffer_reader U_FRAMEBUFFER_READER (
        .clk(clk),
        .rst(rst),
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .de(de),
        .addr(raddr),
        .px_data(rdata),
        .o_rgb(w_rgb)
    );


    VGA_Decoder U_VGA_DECODER (
        .clk(clk),
        .rst(rst),
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
        .o_rgb({port_r, port_g, port_b})
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

