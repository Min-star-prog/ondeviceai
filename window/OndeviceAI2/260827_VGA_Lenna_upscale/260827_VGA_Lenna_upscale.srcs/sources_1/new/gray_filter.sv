`timescale 1ns / 1ps



// module gray_filter (
//     input  logic [11:0] i_rgb,
//     output logic [11:0] o_rgb
// );

//     logic [11:0] y;
//     assign y = 12'd77 * i_rgb[11:8] + 12'd150 * i_rgb[7:4] + 12'd29 * i_rgb[3:0];
//     assign o_rgb = {y[11:8], y[11:8], y[11:8]};


// endmodule



module gray_filter_pipe (
    input  logic        clk,
    input  logic        rst,
    input  logic        sw_gray,
    input  logic        i_hsync,
    input  logic        i_vsync,
    input  logic [11:0] i_rgb,
    output logic        o_hsync,
    output logic        o_vsync,
    output logic [11:0] o_rgb
);

    localparam LATENCY = 2;

    ////////////STAGE 1 : 곱셈 ///////////////////
    logic [11:0] s1_r, s1_g, s1_b, s1_rgb;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s1_r   <= 0;
            s1_g   <= 0;
            s1_b   <= 0;
            s1_rgb <= 0;

        end else begin
            s1_r   <= 8'd77 * i_rgb[11:8];
            s1_g   <= 8'd150 * i_rgb[7:4];
            s1_b   <= 8'd29 * i_rgb[3:0];
            s1_rgb <= i_rgb;
        end
    end

    ////////////STAGE 2 : 덧셈 + shift + mux ///////////////////
    logic [11:0] y_sum;
    logic [ 3:0] gray;
    assign y_sum = s1_r + s1_g + s1_b;
    assign gray  = y_sum[11:8];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_rgb <= 0;
        end else if (sw_gray) begin
            o_rgb <= {gray, gray, gray};
        end else begin
            o_rgb <= s1_rgb;
        end
    end

    ////////////Sync signals////////////////
    logic [LATENCY-1 : 0] hsync_d, vsync_d;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hsync_d <= 0;
            vsync_d <= 0;
        end else begin
            hsync_d <= {hsync_d[LATENCY-2:0], i_hsync};
            vsync_d <= {vsync_d[LATENCY-2:0], i_vsync};
        end
    end

    assign o_hsync = hsync_d[LATENCY-1];
    assign o_vsync = vsync_d[LATENCY-1];

endmodule
