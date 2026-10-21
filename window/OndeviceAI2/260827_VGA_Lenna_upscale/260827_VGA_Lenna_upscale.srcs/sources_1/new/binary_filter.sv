`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/27 13:32:06
// Design Name: 
// Module Name: binary_filter
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


// module binary_filter (
//     input  logic        clk,
//     input  logic        rst,
//     input  logic        sw_bin,
//     input logic sw_inv,
//     input  logic [ 3:0] sw_bin_thr,
//     input  logic        i_hsync,
//     input  logic        i_vsync,
//     input  logic [11:0] i_rgb,
//     output logic        o_hsync,
//     output logic        o_vsync,
//     output logic [11:0] o_rgb
// );

//     always @(posedge clk or posedge rst) begin
//         if (rst) begin
            // o_hsync <= 1'b1;
            // o_vsync <= 1'b1;
//         end else begin
//             o_hsync <= i_hsync;
//             o_vsync <= i_vsync;
//         end
//     end
//     /////////// ///////////////////
//     logic [11:0] s1_r, s1_g, s1_b;
//         assign    s1_r   = 8'd77 * i_rgb[11:8];
//         assign    s1_g   = 8'd150 * i_rgb[7:4];
//         assign    s1_b   = 8'd29 * i_rgb[3:0];

//     ///////////////////////////
//     logic [ 3:0] gray;    
//     logic [11:0] y_sum;
//     assign y_sum = s1_r + s1_g + s1_b;
//     assign gray  = y_sum[11:8];


//     always @(posedge clk or posedge rst) begin
//         if (rst) begin
//             o_rgb <= 0;
//         end else if (sw_bin) begin
//             if (gray >= sw_bin_thr) begin
//                 o_rgb <= 12'hfff;
//             end else begin
//                 o_rgb <= 12'h000;
//             end
//         end else begin
//             o_rgb <= i_rgb;
//         end
//     end


// endmodule



module binary_filter (
    input  logic        clk,
    input  logic        rst,
    input  logic        sw_bin,
    input  logic        sw_inv,
    input  logic [ 3:0] sw_bin_thr,
    input  logic        i_hsync,
    input  logic        i_vsync,
    input  logic [11:0] i_rgb,
    output logic        o_hsync,
    output logic        o_vsync,
    output logic [11:0] o_rgb
);



    ///////////////////////////
    logic [ 3:0] gray;
    logic [11:0] bin_rgb;
    logic over;
    assign gray  = i_rgb[11:8];
    assign over = (gray >= sw_bin_thr) ^ sw_inv;
    assign bin_rgb = over ? 12'hfff : 12'h000;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_rgb <= 0;
        end else if (sw_bin) begin
                o_rgb <= bin_rgb;
            end else begin
                o_rgb <= i_rgb;
            end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_hsync <= 1'b1;
            o_vsync <= 1'b1;
        end else begin
            o_hsync <= i_hsync;
            o_vsync <= i_vsync;
        end
    end

endmodule
