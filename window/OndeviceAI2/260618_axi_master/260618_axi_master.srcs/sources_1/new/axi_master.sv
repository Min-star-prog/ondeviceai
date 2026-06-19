`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/18 16:37:32
// Design Name: 
// Module Name: axi_master
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


module axi_master (
    input  logic clk,
    input  logic rst,
    
    input  logic transfer,
    output logic ready,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata,
    input  logic write,

    output logic [31:0] AWADDR,
    output logic AWVALID,
    input  logic AWREADY,

    output logic [31:0] WDATA,
    output logic WVALID,
    input  logic WREADY,

    input  logic [1:0] BRESP,
    input  logic BVALID,
    output logic BREADY,

    output logic [31:0] ARADDR,
    output logic ARVALID,
    input  logic ARREADY,

    input  logic [31:0] RDATA,
    input  logic RVALID,
    output logic RREADY,
    input  logic [1:0] RRESP

);

    typedef enum logic [2:0] {
        // AW_IDLE  = 0,
        // AW_VALID,
        // W_IDLE,
        // W_VALID,
        // B_IDLE,
        // B_READY,
        // AR_IDLE,
        // AR_VALID,
        // R_IDLE,
        // R_READY
IDLE = 0,
WRITE_VALID,
WRITE_READY,
READ_VALID,
READ_READY
    } state_e;

    state_e state;


    logic aw_done;
    logic w_done;


    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            ready   <= 1'b1;

            AWADDR  <= 32'b0;
            AWVALID <= 1'b0;

            WDATA   <= 32'b0;
            WVALID  <= 1'b0;

            BREADY  <= 1'b0;

            ARADDR  <= 32'b0;
            ARVALID <= 1'b0;

            RREADY  <= 1'b0;
            rdata   <= 32'b0;

            aw_done <= 1'b0;
            w_done  <= 1'b0;
        end else begin
            case(state) 
                IDLE : begin
                    ready   <= 1'b1;

                    AWVALID <= 1'b0;
                    WVALID  <= 1'b0;
                    BREADY  <= 1'b0;
                    ARVALID <= 1'b0;
                    RREADY  <= 1'b0;

                    aw_done <= 1'b0;
                    w_done  <= 1'b0;
                    if(transfer&&write) begin
                        ready   <= 1'b0;

                        AWADDR  <= addr;
                        AWVALID <= 1'b1;

                        WDATA   <= wdata;
                        WVALID  <= 1'b1;

                        state   <= WRITE_VALID;
                    end else if(transfer&&(!write)) begin
                        ready   <= 1'b0;

                        ARADDR  <= addr;
                        ARVALID <= 1'b1;

                        state   <= READ_VALID;
                    end

                end
                WRITE_VALID : begin
                    ready <= 1'b0;

                    // AW channel handshake
                    if (AWVALID && AWREADY) begin
                        AWVALID <= 1'b0;
                        aw_done <= 1'b1;
                    end

                    // W channel handshake
                    if (WVALID && WREADY) begin
                        WVALID <= 1'b0;
                        w_done <= 1'b1;
                    end

                    // AW, W 둘 다 handshake 완료되면 B response 대기
                    if ((aw_done || (AWVALID && AWREADY)) &&
                        (w_done  || (WVALID  && WREADY))) begin
                        BREADY <= 1'b1;
                        state  <= WRITE_READY;
                    end
                end
                WRITE_READY : begin
                    ready  <= 1'b0;
                    BREADY <= 1'b1;

                    // B channel handshake
                    if (BVALID && BREADY) begin
                        BREADY <= 1'b0;
                        ready  <= 1'b1;
                        state  <= IDLE;
                    end
                end
                READ_VALID : begin
                    ready <= 1'b0;

                    // AR channel handshake
                    if (ARVALID && ARREADY) begin
                        ARVALID <= 1'b0;
                        RREADY  <= 1'b1;
                        state   <= READ_READY;
                    end
                end

                READ_READY : begin
                    ready  <= 1'b0;
                    RREADY <= 1'b1;

                    // R channel handshake
                    if (RVALID && RREADY) begin
                        rdata  <= RDATA;
                        RREADY <= 1'b0;
                        ready  <= 1'b1;
                        state  <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end


endmodule
