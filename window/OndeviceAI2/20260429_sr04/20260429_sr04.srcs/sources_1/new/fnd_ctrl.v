`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 15:43:17
// Design Name: 
// Module Name: fnd_controller
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


module fnd_controller (
    input clk,
    input rst,
    input [13:0] fnd_in,
    // input  [1:0] digit_sel,
    input timeout,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);

    wire       w_1khz;
    wire [3:0] w_out_mux;
    wire [3:0] w_digit_1, w_digit_10, w_digit_100, w_digit_1000;

    wire [1:0] w_digit_sel;
    wire [3:0] w_f_d1, w_f_d10, w_f_d100, w_f_d1000;

    digit_splitter U_DIGIT_SPLIT (

        .digit_in  (fnd_in),
        .digit_1   (w_digit_1),
        .digit_10  (w_digit_10),
        .digit_100 (w_digit_100),
        .digit_1000(w_digit_1000)
    );

    assign w_f_d1    = timeout ? 4'hD : w_digit_1;     // e
    assign w_f_d10   = timeout ? 4'hC : w_digit_10;    // n
    assign w_f_d100  = timeout ? 4'hB : w_digit_100;   // o
    assign w_f_d1000 = timeout ? 4'hA : w_digit_1000;  // n





    mux_4x1 U_MUX_4x1 (
        .in0    (w_f_d1),       //digit 1
        .in1    (w_f_d10),      //digit 10
        .in2    (w_f_d100),     //digit 100
        .in3    (w_f_d1000),    //digit 1000
        .sel    (w_digit_sel),  // to select digit
        .out_mux(w_out_mux)

    );


    BCD_decoder U_BCD (
        .bin(w_out_mux),
        .bcd_data(fnd_data)
    );

    clk_div_1khz U_CLK_DIV_1KHZ (
        .clk(clk),
        .rst(rst),
        .o_1khz(w_1khz)
    );


    counter_4 U_COUNTER_4 (
        .clk(w_1khz),
        .rst(rst),
        .digit_sel(w_digit_sel)
    );



    decoder_2x4 U_DECODER_2x4 (
        .decoder_in(w_digit_sel),
        .fnd_com(fnd_com)
    );






endmodule





module digit_splitter (

    input  [13:0] digit_in,
    output [ 3:0] digit_1,
    output [ 3:0] digit_10,
    output [ 3:0] digit_100,
    output [ 3:0] digit_1000
);


    assign digit_1 = digit_in % 10;  // digit 1
    assign digit_10 = (digit_in / 10) % 10;  // digit 10
    assign digit_100 = (digit_in / 100) % 10;  // digit 100
    assign digit_1000 = (digit_in / 1000) % 10;  // digit 1000




endmodule




module mux_4x1 (
    input [3:0] in0,  //digit 1
    input [3:0] in1,  //digit 10
    input [3:0] in2,  //digit 100
    input [3:0] in3,  //digit 1000
    input [1:0] sel,  // to select digit
    output [3:0] out_mux

);
    reg [3:0] out_reg;
    assign out_mux = out_reg;

    // mux, * = all input : sensitivity list

    always @(*  /*in0,in1,in2,in3,sel*/) begin
        case (sel)
            2'b00:   out_reg = in0;
            2'b01:   out_reg = in1;
            2'b10:   out_reg = in2;
            2'b11:   out_reg = in3;
            default: out_reg = 4'b0000;
        endcase


    end

endmodule




module BCD_decoder (

    input      [3:0] bin,
    output reg [7:0] bcd_data

);

    always @(bin) begin
        case (bin)
            4'd0: bcd_data = 8'hc0;
            4'd1: bcd_data = 8'hf9;
            4'd2: bcd_data = 8'ha4;
            4'd3: bcd_data = 8'hb0;
            4'd4: bcd_data = 8'h99;
            4'd5: bcd_data = 8'h92;
            4'd6: bcd_data = 8'h82;
            4'd7: bcd_data = 8'hf8;
            4'd8: bcd_data = 8'h80;
            4'd9: bcd_data = 8'h90;

            4'hA: bcd_data = 8'b1100_1000;  //n
            4'hB: bcd_data = 8'hc0;         //o
            4'hC: bcd_data = 8'b1100_1000;  //n
            4'hD: bcd_data = 8'b1000_0110;  //e

            4'hE:    bcd_data = 8'b1011_1111;  //-
            4'hF:    bcd_data = 8'hff;
            default : bcd_data = 8'hff;
        endcase

    end

endmodule




module clk_div_1khz (
    input  clk,
    input  rst,
    output o_1khz
);


    reg [15:0] counter_reg;
    reg o_1khz_reg;

    assign o_1khz = o_1khz_reg;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            counter_reg <= 16'd0;
            o_1khz_reg  <= 1'b0;  //
        end else begin
            counter_reg <= counter_reg + 1;
            if (counter_reg == (50_000 - 1)) begin
                counter_reg <= 16'd0;
                o_1khz_reg  <= ~o_1khz_reg;
            end
        end
    end

endmodule





module counter_4 (
    input clk,
    input rst,
    output [1:0] digit_sel
);

    reg [1:0] counter_reg;

    assign digit_sel = counter_reg;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            counter_reg <= 0;
        end else begin
            counter_reg <= counter_reg + 1;

        end


    end



endmodule






module decoder_2x4 (
    input      [1:0] decoder_in,
    output reg [3:0] fnd_com
);


    always @(*) begin
        case (decoder_in)
            2'b00:   fnd_com = 4'b1110;
            2'b01:   fnd_com = 4'b1101;
            2'b10:   fnd_com = 4'b1011;
            2'b11:   fnd_com = 4'b0111;
            default: fnd_com = 4'b1111;
        endcase
    end

endmodule





