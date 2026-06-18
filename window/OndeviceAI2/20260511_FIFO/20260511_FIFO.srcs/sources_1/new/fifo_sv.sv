`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/11 14:11:25
// Design Name: 
// Module Name: fifo_sv
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


module fifo_sv (

    input  logic       clk,
    input  logic       rst,
    input  logic [7:0] push_data,
    input  logic       push,
    input  logic       pop,
    output logic [7:0] pop_data,
    output logic       full,
    output logic       empty
);

    logic [3:0] w_wptr, w_rptr;

    reg_file U_REG_FILE (
        // .*,      : port 똑같은 거 자동 연결
        .clk(clk),
        .wdata(push_data),
        .we(!full && push),
        .waddr(w_wptr),
        .raddr(w_rptr),
        .rdata(pop_data)
    );

    fifo_control_unit U_FIFO_CTRL (
        .clk  (clk),
        .rst  (rst),
        .pop  (pop),
        .push (push),
        .full (full),
        .empty(empty),
        .wptr (w_wptr),
        .rptr (w_rptr)
    );




endmodule




module reg_file (
    input  logic       clk,
    input  logic [7:0] wdata,
    input  logic       we,
    input  logic [3:0] waddr,
    input  logic [3:0] raddr,
    output logic [7:0] rdata
);

    logic [7:0] ram[0:15];

    always_ff @(posedge clk) begin
        if (we) begin
            ram[waddr] <= wdata;

        end
    end
    assign rdata = ram[raddr];  //raddr바뀌면 pop_data나감


endmodule


module fifo_control_unit (
    input  logic       clk,
    input  logic       rst,
    input  logic       pop,
    input  logic       push,
    output logic       full,
    output logic       empty,
    output logic [3:0] wptr,
    output logic [3:0] rptr
);


    logic [3:0] wptr_next, wptr_reg;
    logic [3:0] rptr_next, rptr_reg;
    logic  full_next, full_reg;
    logic  empty_next, empty_reg;


    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            full_reg  <= 1'b0;
            empty_reg <= 1'b1;
            wptr_reg  <= 0;
            rptr_reg  <= 0;

        end else begin
            wptr_reg  <= wptr_next;
            rptr_reg  <= rptr_next;
            full_reg  <= full_next;
            empty_reg <= empty_next;

        end
    end

    always_comb begin
        wptr_next  = wptr_reg;
        rptr_next  = rptr_reg;
        full_next  = full_reg;
        empty_next = empty_reg;
        //IDLE상태는 rst에서 이미 다 처리해서 없어도 됨.
        //push only
        if (!full_reg && push && !pop) begin
                wptr_next = wptr_reg + 1;
                empty_next = 1'b0;
            if (wptr_next == rptr_reg) begin
                full_next = 1'b1;
            end 
        end else if ((!empty_reg) && (!push) && pop) begin
                rptr_next  = rptr_reg + 1;
                full_next = 1'b0;
            if (rptr_next == wptr_reg) begin
                empty_next = 1'b1;
            end 
        end else if (push && pop) begin
            if (full_reg) begin
                rptr_next = rptr_reg + 1;
                full_next = 1'b0;
            end else if (empty_reg) begin
                wptr_next  = wptr_reg + 1;
                empty_next = 1'b0;
            end else begin
                wptr_next = wptr_reg + 1;
                rptr_next = rptr_reg + 1;
            end
        end
    end

    assign wptr  = wptr_reg;
    assign rptr  = rptr_reg;
    assign full  = full_reg;
    assign empty = empty_reg;

endmodule
