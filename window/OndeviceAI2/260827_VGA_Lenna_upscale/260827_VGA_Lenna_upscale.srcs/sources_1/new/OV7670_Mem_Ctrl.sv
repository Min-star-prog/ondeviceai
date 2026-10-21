`timescale 1ns / 1ps


module OV7670_Mem_Ctrl (
    input logic pclk,
    input logic rst,
    input logic href,
    input logic vsync,
    input logic [7:0] pdata,
    output logic we,
    output logic [16:0] addr,
    output logic [15:0] data
);

    logic cnt;
    logic [7:0] reg_data;
    always @(posedge pclk or posedge rst) begin
        if (rst) begin
            we       <= 0;
            addr     <= 0;
            data     <= 0;
            reg_data <= 0;
            cnt      <= 0;
        end else if (vsync) begin
            addr     <= 0;
            data     <= 0;
            reg_data <= 0;
            cnt      <= 0;
            we       <= 0;
        end else  begin
            if (we)
            addr <= addr + 1;
            we <= 0;
         if (href) begin
            if (cnt) begin
                we   <= 1'b1;
                data <= {reg_data, pdata};
            end else begin
                reg_data <= pdata;
                we <= 0;
            end
            cnt <= cnt + 1;
        end else begin
            cnt <= 0;
            we  <= 0;
        end
    end
    end


endmodule
