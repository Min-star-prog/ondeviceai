`timescale 1ns / 1ps


// module OV7670_Mem_Ctrl (
//     input logic pclk,
//     input logic rst,
//     input logic cam_href,
//     input logic cam_vsync,
//     input logic [7:0] cam_data,
//     output logic we,
//     output logic [16:0] waddr,
//     output logic [15:0] wdata
// );

//     logic bytesel;
//     logic [7:0] px_data;
//     always @(posedge pclk or posedge rst) begin
//         if (rst) begin
//             we       <= 0;
//             waddr     <= 0;
//             wdata     <= 0;
//             px_data <= 0;
//             bytesel      <= 0;
//         end else if (cam_vsync) begin
//             waddr     <= 0;
//             wdata     <= 0;
//             px_data <= 0;
//             bytesel      <= 0;
//             we       <= 0;
//         end else  begin
//             if (we)
//             waddr <= waddr + 1;
//             we <= 0;
//          if (cam_href) begin
//             if (bytesel) begin
//                 we   <= 1'b1;
//                 wdata <= {px_data, cam_data};
//             end else begin
//                 px_data <= cam_data;
//                 we <= 0;
//             end
//             bytesel <= bytesel + 1;
//         end else begin
//             bytesel <= 0;
//             we  <= 0;
//         end
//     end
//     end


// endmodule



module OV7670_Mem_Ctrl #(    
    parameter IMG_W = 320,
    parameter IMG_H = 240,
    parameter DW = 16,  //Data Width = 16bit
    parameter AW = $clog2(IMG_W * IMG_H)  // Address Width
)(
    input logic pclk,
    input logic rst,
    input logic cam_href,
    input logic cam_vsync,
    input logic [7:0] cam_data,
    output logic we,
    output logic [AW-1:0] waddr,
    output logic [DW-1:0] wdata
);

    logic bytesel;
    logic [15:0] px_data;

    assign wdata = px_data;

    always @(posedge pclk or posedge rst) begin
        if (rst) begin
            we      <= 0;
            waddr   <= 0;
            px_data <= 0;
            bytesel <= 0;
        end else begin
            
            if (we) waddr <= waddr + 1;
            we <= 0;
            if (cam_vsync) begin

            waddr   <= 0;
            bytesel <= 0;
        end else if (cam_href) begin
                bytesel <= bytesel + 1;
                if (bytesel) begin
                    we <= 1'b1;
                    px_data[7:0] <= cam_data;
                end else begin
                    px_data[15:8] <= cam_data;
                end
            end 
        end
    end


endmodule
