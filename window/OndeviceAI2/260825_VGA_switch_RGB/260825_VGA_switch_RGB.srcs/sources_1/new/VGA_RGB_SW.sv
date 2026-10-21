`timescale 1ns / 1ps


module VGA_RGB_SW (
    input logic [3:0] sw_r,
    input logic [3:0] sw_g,
    input logic [3:0] sw_b,
    input logic de,
    input logic [9:0] x_pixel,
    input logic [9:0] y_pixel,
    output logic [3:0] port_r,
    output logic [3:0] port_g,
    output logic [3:0] port_b
);


    assign port_r = de ? sw_r : 4'b0;
    assign port_g = de ? sw_g : 4'b0;
    assign port_b = de ? sw_b : 4'b0;


    //좌표 지금은 필요 없음.

// //Red
// always @(*) begin
//     {port_r, port_g, port_b} = 12'h000;
// if(de) begin
// if(y_pixel <300) begin
//     if((x_pixel >= 0 && x_pixel < 90)) begin
//         port_r = 4'hf;
//         port_g = 4'hf;
//         port_b = 4'hf;
//     end else if (x_pixel >= 90 && x_pixel < 181) begin
//         port_r = 4'hf;
//         port_g = 4'hf;
//         port_b = 4'h0;
//     end else if (x_pixel >= 181 && x_pixel < 272) begin
//         port_r = 4'h0;
//         port_g = 4'hf;
//         port_b = 4'hf;
//     end else if (x_pixel >= 272 && x_pixel < 363) begin
//         port_r = 4'h0;
//         port_g = 4'hf;
//         port_b = 4'h0;
//     end else if (x_pixel >= 363 && x_pixel < 454) begin
//         port_r = 4'hf;
//         port_g = 4'h0;
//         port_b = 4'hf;
//     end else if (x_pixel >= 454 && x_pixel < 545) begin
//         port_r = 4'hf;
//         port_g = 4'h0;
//         port_b = 4'h0;
//     end else if  (x_pixel >= 545 && x_pixel < 636) begin
//         port_r = 4'h0;
//         port_g = 4'h0;
//         port_b = 4'hf;
//     end
// end else if ((y_pixel>= 300) && (y_pixel <350 )) begin
//     if((x_pixel >= 0 && x_pixel < 90)) begin
//         port_r = 4'h0;
//         port_g = 4'h0;
//         port_b = 4'hf;
//     end else if (x_pixel >= 90 && x_pixel < 181) begin
//         port_r = 4'h0;
//         port_g = 4'h0;
//         port_b = 4'h0;
//     end else if (x_pixel >= 181 && x_pixel < 272) begin
//         port_r = 4'hf;
//         port_g = 4'h0;
//         port_b = 4'hf;
//     end else if (x_pixel >= 272 && x_pixel < 363) begin
//         port_r = 4'h0;
//         port_g = 4'h0;
//         port_b = 4'h0;
//     end else if (x_pixel >= 363 && x_pixel < 454) begin
//         port_r = 4'h0;
//         port_g = 4'hf;
//         port_b = 4'hf;
//     end else if (x_pixel >= 454 && x_pixel < 545) begin
//         port_r = 4'h0;
//         port_g = 4'h0;
//         port_b = 4'h0;
//     end else if  (x_pixel >= 545 && x_pixel < 636) begin
//         port_r = 4'hf;
//         port_g = 4'hf;
//         port_b = 4'hf;
//     end
// end else begin
//     if((x_pixel >= 0 && x_pixel < 112)) begin
//         port_r = 4'h0;
//         port_g = 4'h2;
//         port_b = 4'h4;
//     end else if (x_pixel >= 112 && x_pixel < 225) begin
//         port_r = 4'hf;
//         port_g = 4'hf;
//         port_b = 4'hf;
//     end else if (x_pixel >= 225 && x_pixel < 338) begin
//         port_r = 4'h3;
//         port_g = 4'h1;
//         port_b = 4'h7;
//     end else if (x_pixel >= 338 && x_pixel < 451) begin
//         port_r = 4'h0;
//         port_g = 4'h0;
//         port_b = 4'h0;
//     end else if (x_pixel >= 451 && x_pixel < 484) begin
//         port_r = 4'h0;
//         port_g = 4'h0;
//         port_b = 4'h0;
//     end else if (x_pixel >= 484 && x_pixel < 514) begin
//         port_r = 4'h2;
//         port_g = 4'h2;
//         port_b = 4'h2;
//     end else if (x_pixel >= 514 && x_pixel < 545) begin
//         port_r = 4'h4;
//         port_g = 4'h4;
//         port_b = 4'h4;
//     end else begin
//         port_r = 4'h0;
//         port_g = 4'h0;
//         port_b = 4'h0;
//     end
// end


// end
// end


endmodule
