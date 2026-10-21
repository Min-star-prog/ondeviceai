`timescale 1ns / 1ps



module frame_buffer_reader (
    input  logic        clk,
    input  logic        rst,
    input  logic [ 9:0] x_pixel,
    input  logic [ 9:0] y_pixel,
    input  logic        de,
    output logic [16:0] addr,
    input  logic [15:0] px_data,
    output logic [11:0] o_rgb
);

logic dispArea,dispArea_d;
// logic de_d;

    assign dispArea = de && (x_pixel <320) && (y_pixel <240);
    assign addr = dispArea ? (y_pixel * 320 + x_pixel) : 0;
    // assign addr  = de_d ? ((y_pixel >> 1) * 320 + (x_pixel >> 1)) : 0;

    // always_ff @(posedge clk or posedge rst) begin
    //     if(rst) begin
    //         de_d <= 1'b0;
    //     end else begin
    //         de_d <= de;
    //     end
    // end

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            dispArea_d <= 1'b0;
        end else begin
            dispArea_d <= dispArea;
        end
    end

    // assign o_rgb = de_d ? {px_data[15:12], px_data[10:7], px_data[4:1]} : 0;
    assign o_rgb = dispArea_d ? {px_data[15:12], px_data[10:7], px_data[4:1]} : 0;



endmodule
