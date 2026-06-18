`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/29 10:54:37
// Design Name: 
// Module Name: apb_master
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


module apb_master (
    //BUS Global Signal
    input  logic        pclk,
    input  logic        preset,
    //SoC Internal Signal with CPU
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    input  logic        w_req,    //transfer 요청 : IDLE에서 SETUP
    input  logic        r_req,    //transfer 요청 : IDLE에서 SETUP
    output logic [31:0] rdata,
    output logic        ready,
    //APB Interface Signal
    output logic [31:0] paddr,
    output logic [31:0] pwdata,
    output logic        penable,
    output logic        pwrite,
    output logic        psel0,
    output logic        psel1,
    output logic        psel2,
    output logic        psel3,
    output logic        psel4,
    input  logic [31:0] prdata0,
    input  logic [31:0] prdata1,
    input  logic [31:0] prdata2,
    input  logic [31:0] prdata3,
    input  logic [31:0] prdata4,
    input  logic        pready0,
    input  logic        pready1,
    input  logic        pready2,
    input  logic        pready3,
    input  logic        pready4
);

    typedef enum logic [1:0] {
        IDLE   = 0,
        SETUP,
        ACCESS
    } apb_state_e;
    apb_state_e c_state, n_state;


logic [2:0] mux_sel;

    always_ff @(posedge pclk, posedge preset) begin
        if (preset) begin
            c_state <= IDLE;
        end else begin
            c_state <= n_state;
        end
    end

    always_comb begin
        n_state = c_state;
        paddr   = 0;
        pwdata  = 0;
        penable = 0;
        pwrite  = 0;

        case (c_state)
            IDLE: begin
                if (w_req | r_req) begin
                    n_state = SETUP;
                end
            end
            SETUP: begin
                paddr = addr;
                if (w_req) begin
                    pwdata = wdata;
                    pwrite = 1;
                end else begin
                    pwdata = 32'd0;
                    pwrite = 0;
                end
                n_state = ACCESS;
                penable = 0;

            end
            ACCESS: begin
                paddr = addr;
                if (w_req) begin
                    pwdata = wdata;
                    pwrite = 1'b1;
                end else begin
                    pwdata = 32'd0;
                    pwrite = 1'b0;
                end
                penable = 1;
                if (ready) begin
                    n_state = IDLE;
                end
            end
        endcase
    end

address_decoder U_ADDR_DECODER (.*);
apb_mux U_APB_MUX(.*,.sel(mux_sel));

endmodule



module apb_mux (
    input logic [2:0] sel,
    input logic [31:0] prdata0,
    input logic [31:0] prdata1,
    input logic [31:0] prdata2,
    input logic [31:0] prdata3,
    input logic [31:0] prdata4,
    input logic pready0,
    input logic pready1,
    input logic pready2,
    input logic pready3,
    input logic pready4,
    output logic [31:0] rdata,
    output logic ready
);

    always_comb begin
        rdata = 0;
        ready = 1'b0;
        case (sel)
            3'd0: begin
                rdata = prdata0;
                ready = pready0;
            end

            3'd1: begin
                rdata = prdata1;
                ready = pready1;
            end
            3'd2: begin
                rdata = prdata2;
                ready = pready2;
            end
            3'd3: begin
                rdata = prdata3;
                ready = pready3;
            end
            3'd4: begin
                rdata = prdata4;
                ready = pready4;
            end
        endcase
    end
endmodule


module address_decoder (
    input logic [31:0] addr,
    output logic psel0,
    output logic psel1,
    output logic psel2,
    output logic psel3,
    output logic psel4,
    output logic [2:0] mux_sel
);



    always_comb begin
        psel0   = 0;
        psel4   = 0;
        psel3   = 0;
        psel2   = 0;
        psel1   = 0;
        mux_sel = 3'd0;
        case ({addr[31:28]})
            4'h1: begin
                psel0   = 1;
                mux_sel = 3'd0;
            end  // RAM
            4'h2 : begin
            case({addr[15:12]}) 
            //peripheral
            4'h0: begin
                psel1   = 1;
                mux_sel = 3'd1;
            end  // GPO
            4'h1: begin
                psel2   = 1;
                mux_sel = 3'd2;
            end  // GPI
            4'h2: begin
                psel3   = 1;
                mux_sel = 3'd3;
            end  // GPIO
            4'h3: begin
                psel4   = 1;
                mux_sel = 3'd4;
            end  //reserve
            endcase
            end
        endcase
    end
endmodule
