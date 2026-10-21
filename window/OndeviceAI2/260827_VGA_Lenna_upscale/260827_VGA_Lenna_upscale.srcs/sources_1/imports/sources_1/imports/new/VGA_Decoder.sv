`timescale 1ns / 1ps



module VGA_Decoder (
    input  logic       clk,
    input  logic       rst,
    output logic       hsync,
    output logic       vsync,
    output logic [9:0] x_pixel,
    output logic [9:0] y_pixel,
    output logic       de
);

    logic pclk;
    logic [9:0] hcnt;
    logic [9:0] vcnt;

    pclk_gen U_PCLK_GEN (
        .*,
        .pclk(pclk)
    );
    pixel_counter U_PIXEL_COUNTER (
        .*,
        .pclk(pclk),
        .hcnt(hcnt),  //0~799
        .vcnt(vcnt)   //0~524
    );
    vga_decoder U_VGA_DECODER (
        .*,
        .hcnt(hcnt),
        .vcnt(vcnt)
    );



endmodule



module pclk_gen (
    input  logic clk,
    input  logic rst,
    output logic pclk
);

    logic [1:0] p_cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pclk  <= 0;
            p_cnt <= 0;
        end else begin
            if (p_cnt == 2'd3) begin
                p_cnt <= 0;
                pclk  <= 1'b1;
            end else begin
                p_cnt <= p_cnt + 1;
                pclk  <= 1'b0;
            end
        end
    end

endmodule

module pixel_counter (
    input logic clk,
    input logic rst,
    input logic pclk,
    output logic [9:0] hcnt,  //0~799
    output logic [9:0] vcnt  //0~524
);

    localparam H_MAX = 800, V_MAX = 525;
    // //Hcnt
    // always @(posedge clk or posedge rst) begin
    //     if (rst) begin
    //         hcnt <= 0;
    //     end else begin
    //         if (pclk) begin
    //             if (hcnt == H_MAX - 1) begin
    //                 hcnt <= 0;
    //             end else begin
    //                 hcnt <= hcnt + 1;
    //             end
    //         end
    //     end
    // end
    // //Vcnt
    // always @(posedge clk or posedge rst) begin
    //     if (rst) begin
    //         vcnt <= 0;
    //     end else begin
    //         if (pclk) begin
    //             if (hcnt == H_MAX - 1) begin
    //                 if (vcnt == V_MAX - 1) begin
    //                     vcnt <= 0;
    //                 end else begin
    //                     vcnt <= vcnt + 1;
    //                 end
    //             end
    //         end
    //     end
    // end
    //


    //합친거
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hcnt <= 0;
            vcnt <= 0;
        end else begin
            if (pclk) begin
                if (hcnt == H_MAX - 1) begin
                    hcnt <= 0;
                    if (vcnt == V_MAX - 1) begin
                        vcnt <= 0;
                    end else begin
                        vcnt <= vcnt + 1;
                    end
                end else begin
                    hcnt <= hcnt + 1;
                end
            end
        end
    end


endmodule

module vga_decoder (
    input logic [9:0] hcnt,
    input logic [9:0] vcnt,
    output logic hsync,
    output logic vsync,
    output logic [9:0] x_pixel,
    output logic [9:0] y_pixel,
    output logic de
);

    localparam H_Visible_area = 640;
    localparam H_Front_porch = 16;
    localparam H_Sync_pulse = 96;
    localparam H_Back_porch = 48;
    localparam H_Whole_line = 800;

    localparam V_Visible_area = 480;
    localparam V_Front_porch = 10;
    localparam V_Sync_pulse = 2;
    localparam V_Back_porch = 33;
    localparam V_Whole_frame = 525;


    assign x_pixel = hcnt;
    assign y_pixel = vcnt;

    assign hsync = !((hcnt >= H_Visible_area + H_Front_porch) 
    && (hcnt < H_Visible_area + H_Front_porch + H_Sync_pulse)) ;

    assign vsync = !((vcnt >= V_Visible_area + V_Front_porch) 
    && (vcnt < V_Visible_area + V_Front_porch + V_Sync_pulse)) ;

    assign de = (hcnt < H_Visible_area) && (vcnt < V_Visible_area);

endmodule








