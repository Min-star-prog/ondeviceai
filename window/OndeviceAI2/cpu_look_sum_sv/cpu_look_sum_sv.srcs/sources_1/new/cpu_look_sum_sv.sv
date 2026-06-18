`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/18 16:37:13
// Design Name: 
// Module Name: cpu_loop_sum_sv
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


module cpu_loop_sum_sv (
    input        clk,
    input        rst,
    output [7:0] out
);
    logic       ag10;
    logic       rf_src_sel;
    logic [1:0] RA0;
    logic [1:0] RA1;
    logic [1:0] WA;
    logic       we;
    cpu_datapath U_CPU_DATAPATH (.*);
    cpu_sum_control U_CPU_SUM_CNTL (.*);
endmodule

module cpu_datapath (
    input        clk,
    input        rst,
    output       ag10,
    input        rf_src_sel,
    input  [1:0] RA0,
    input  [1:0] RA1,
    input  [1:0] WA,
    input        we,
    output [7:0] out
);
    logic [7:0] alu_result, reg_mux_out;
    logic [7:0] w_RD0, w_RD1;
    assign out = w_RD1;
    mux_2x1 U_CPU_DATA_MUX (
        .in0(8'h01),
        .in1(alu_result),
        .sel(rf_src_sel),
        .mux_out(reg_mux_out)
    );
    register U_CPU_REG (
        .clk(clk),
        .rst(rst),
        .WA (WA),
        .we (we),
        .WD (reg_mux_out),
        .RA0(RA0),
        .RA1(RA1),
        .RD0(w_RD0),
        .RD1(w_RD1)
    );
    comparator U_CPU_AG10 (
        .in(w_RD0),
        .compare(8'h09),
        .comp_out(ag10)
    );
    alu U_CPU_ALU (
        .a(w_RD0),
        .b(w_RD1),
        .alu_result(alu_result)
    );

endmodule

module mux_2x1 (
    input  logic [7:0] in0,
    input  logic [7:0] in1,
    input  logic       sel,
    output logic [7:0] mux_out
);
    assign mux_out = (sel == 0) ? in0 : in1;

endmodule

module register (
    input  logic       clk,
    input  logic       rst,
    input  logic [1:0] WA,
    input  logic       we,
    input  logic [7:0] WD,
    input  logic [1:0] RA0,
    input  logic [1:0] RA1,
    output logic [7:0] RD0,
    output logic [7:0] RD1
);

    logic [7:0] cpu_reg[0:3];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cpu_reg[0] <= 0;
        end else begin
            if (we) cpu_reg[WA] <= WD;
        end
    end

    assign RD0 = cpu_reg[RA0];
    assign RD1 = cpu_reg[RA1];

endmodule

module comparator (
    input [7:0] in,
    input [7:0] compare,
    output comp_out
);

    assign comp_out = (in > compare);

endmodule

module alu (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] alu_result
);

    assign alu_result = a + b;

endmodule

module cpu_sum_control (
    input  logic       clk,
    input  logic       rst,
    input  logic       ag10,
    output logic       rf_src_sel,
    output logic [1:0] RA0,
    output logic [1:0] RA1,
    output logic [1:0] WA,
    output logic       we
);
    typedef enum {
        S0 = 0,
        S1,
        S2,
        S3,
        S4,
        S5,
        S6,
        S7
    } state_t;
    state_t c_state, n_state;
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            c_state <= S0;
        end else begin
            c_state <= n_state;
        end
    end

    always_comb begin
        n_state = c_state;
        RA0 = 0;
        RA1 = 0;
        rf_src_sel = 0;
        WA = 0;
        we = 0;
        case (c_state)
            S0: begin  //R1=1
                RA0 = 0;
                RA1 = 0;
                rf_src_sel = 0;
                WA = 1;
                we = 1;
                n_state = S1;
            end
            S1: begin  //R3=a=0
                RA0 = 0;
                RA1 = 0;
                rf_src_sel = 1;
                WA = 3;
                we = 1;
                n_state = S2;
            end
            S2: begin  //R2=sum=0
                RA0 = 0;
                RA1 = 0;
                rf_src_sel = 1;
                WA = 2;
                we = 1;
                n_state = S3;
            end
            S3: begin  //if(a>10)
                RA0 = 3;
                RA1 = 0;
                rf_src_sel = 0;
                WA = 0;
                we = 0;
                if (!ag10) begin
                    n_state = S4;
                end else begin
                    n_state = S7;
                end
            end
            S4: begin  //R2=sum=0
                RA0 = 0;
                RA1 = 2;
                rf_src_sel = 0;
                WA = 0;
                we = 0;
                n_state = S5;
            end
            S5: begin  //a= a+1
                RA0 = 3;
                RA1 = 1;
                rf_src_sel = 1;
                WA = 3;
                we = 1;
                n_state = S6;
            end
            S6: begin  //s=s+a
                RA0 = 3;
                RA1 = 2;
                rf_src_sel = 1;
                WA = 2;
                we = 1;
                n_state = S3;
            end
            S7: begin  //R2=sum=0
                RA0 = 0;
                RA1 = 2;
                rf_src_sel = 0;
                WA = 0;
                we = 0;
            end
        endcase
    end

endmodule
