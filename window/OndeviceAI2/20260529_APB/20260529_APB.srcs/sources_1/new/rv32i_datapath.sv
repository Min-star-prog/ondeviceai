`timescale 1ns / 1ps
`include "define.vh"

module rv32i_datapath (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] instr_code,
    input  logic        rf_we,
    input  logic [ 2:0] rfsrc_sel,
    input  logic        alusrc_sel,
    input  logic [31:0] rdata,
    input  logic [ 3:0] alu_control,
    input  logic        branch,
    input  logic        jal,
    input  logic        jalr,
    input  logic        pc_en,

    output logic [31:0] instr_addr,
    output logic [31:0] addr,
    output logic [31:0] wdata
);



    logic [31:0]
        rs2,
        rs1,
        alu_result,
        alu_rs2_mux,
        imm_extend,
        wb_out,
        pc_branch,
        pc_4,
        pc_imm;
    logic b_taken;

//DEC to execute register for multi-cycle
logic [31:0] o_dec_rs1,o_dec_rs2,o_dec_imm_extend;
//EXE 
logic [31:0] o_exe_alu, o_exe_rs2;
logic [31:0] o_wb_drdata;

    assign addr  = o_exe_alu;
    assign wdata = o_exe_rs2;


register_s U_WB_DRDATA(
    .clk(clk),
    .rst(rst),
    .in(rdata),
    .out(o_wb_drdata)
);


    mux_wb U_REG_FILE_SRC_MUX (
        .in0   (alu_result),
        .in1   (o_wb_drdata),
        .in2   (o_dec_imm_extend),
        .in3   (pc_imm),
        .in4   (pc_4),
        .sel   (rfsrc_sel),
        .wb_out(wb_out)
    );



    program_counter U_PC (
        .clk       (clk),
        .rst       (rst),
        .b_taken   (b_taken),
        .branch    (branch),
        .pc_en     (pc_en),
        .jal       (jal),
        .jalr      (jalr),
        .rs1       (o_dec_rs1),
        .imm_extend(o_dec_imm_extend),
        .pc_imm    (pc_imm),
        .pc_4      (pc_4),
        .pc_in     (instr_addr),  //for next program count
        .pc_out    (instr_addr)   // current program count
    );

//DEC register
register_s U_DEC_RS1(
    .clk(clk),
    .rst(rst),
    .in(rs1),
    .out(o_dec_rs1)
);
register_s U_DEC_RS2(
    .clk(clk),
    .rst(rst),
    .in(rs2),
    .out(o_dec_rs2)
);
register_s U_DEC_IMM(
    .clk(clk),
    .rst(rst),
    .in(imm_extend),
    .out(o_dec_imm_extend)
);


    alu U_ALU (
        .alu_control(alu_control),
        .rs1        (o_dec_rs1),
        .rs2        (alu_rs2_mux),
        .alu_result (alu_result),
        .b_taken    (b_taken)
    );


    mux_2x1 U_ALU_RS2_MUX (
        .in0    (o_dec_rs2),
        .in1    (o_dec_imm_extend),
        .sel    (alusrc_sel),
        .out_mux(alu_rs2_mux)
    );

//EXE register
register_s U_EXE_ALU(
    .clk(clk),
    .rst(rst),
    .in(alu_result),
    .out(o_exe_alu)
);
register_s U_EXE_RS2(
    .clk(clk),
    .rst(rst),
    .in(o_dec_rs2),
    .out(o_exe_rs2)
);




    imm_extend U_IMM_EXTEND (
        .instr_code(instr_code),
        .imm_extend(imm_extend)
    );



    register_file U_REG_FILE (
        .clk   (clk),
        .rf_we (rf_we),
        .waddr (instr_code[11:7]),
        .wdata (wb_out),
        .raddr1(instr_code[19:15]),
        .raddr2(instr_code[24:20]),
        .rdata1(rs1),
        .rdata2(rs2)

    );

endmodule

module register_s(
    input clk,
    input rst,
    input [31:0] in,
    output [31:0] out
);
    logic [31:0] register;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            register <= 0;
        end else begin
            register <= in;
        end
    end

    assign out = register;

endmodule
module program_counter (
    input logic clk,
    input logic rst,
    input logic b_taken,
    input logic branch,
    input logic jal,
    input logic jalr,
    input logic pc_en,
    input logic [31:0] rs1,
    input logic [31:0] pc_in,
    input logic [31:0] imm_extend,
    output logic [31:0] pc_out,
    output logic [31:0] pc_imm,
    output logic [31:0] pc_4
);

    logic [31:0] pc_reg, pc_jalr,pc_next;
    logic [31:0] o_exe_pc_next;

    assign pc_imm = (imm_extend + pc_jalr) & ~32'd1;
    assign pc_4   = pc_in + 32'd4;

    mux_2x1 U_PC_SRC_FRONT (
        .in0    (pc_in),
        .in1    (rs1),
        .sel    (jalr),
        .out_mux(pc_jalr)  //pc or rs1
    );


    mux_2x1 U_PC_SRC_BACK (
        .in0    (pc_4),                             //pc + 4
        .in1    (pc_imm),                           //imm + pc or imm + rs1
        .sel    ((branch & b_taken) | jal | jalr),
        .out_mux(pc_next)
    );

register_s U_EXE_PC_NEXT(
    .clk(clk),
    .rst(rst),
    .in(pc_next),
    .out(o_exe_pc_next)
);


    //register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_reg <= 0;
        end else if(pc_en) begin
            pc_reg <= o_exe_pc_next;
        end
    end

    assign pc_out = pc_reg;

endmodule

module imm_extend (
    input  logic [31:0] instr_code,
    output logic [31:0] imm_extend
);


    always_comb begin
        imm_extend = 32'd0;
        case (instr_code[6:0])
            `S_TYPE:
            imm_extend = {
                {20{instr_code[31]}}, instr_code[31:25], instr_code[11:7]
            };

            `IL_TYPE, `I_TYPE, `JALR:
            imm_extend = {{20{instr_code[31]}}, instr_code[31:20]};

            `B_TYPE:
            imm_extend = {
                {20{instr_code[31]}},
                instr_code[7],
                instr_code[30:25],
                instr_code[11:8],
                1'b0
            };
            //LUI
            `LUI: imm_extend = {instr_code[31:12], {12{1'b0}}};
            //AUIPC
            `AUIPC: imm_extend = {instr_code[31:12], {12{1'b0}}};
            //JAL
            `JAL:
            imm_extend = {
                {12{instr_code[31]}},
                instr_code[19:12],
                instr_code[20],
                instr_code[30:21],
                1'b0
            };
        endcase
    end

endmodule




module alu (
    input logic [3:0] alu_control,
    input logic [31:0] rs1,
    input logic [31:0] rs2,
    output logic [31:0] alu_result,
    output logic b_taken
);

    always_comb begin
        alu_result = 32'd0;
        case (alu_control)
            // R-type rd = rs1 + rs2
            // I-type rd = rs1 + Imm(rs2)
            `ADD:  alu_result = rs1 + rs2;
            `SUB:  alu_result = rs1 - rs2;
            `AND:  alu_result = rs1 & rs2;
            `OR:   alu_result = rs1 | rs2;
            `XOR:  alu_result = rs1 ^ rs2;  //cap
            `SLTU: alu_result = (rs1 < rs2) ? 1 : 0;  // 나머지 숙제
            `SLT:  alu_result = ($signed(rs1) < $signed(rs2)) ? 1 : 0;

            `SLL: alu_result = rs1 << rs2;
            `SRL: alu_result = rs1 >> rs2[4:0];
            `SRA: alu_result = $signed(rs1) >>> rs2[4:0];

        endcase
    end

    always_comb begin
        b_taken = 1'b0;
        case (alu_control)
            `BEQ: begin
                if (rs1 == rs2) b_taken = 1'b1;
                else b_taken = 1'b0;
            end
            `BNE: begin
                if (rs1 != rs2) b_taken = 1'b1;
                else b_taken = 1'b0;
            end
            `BLT: begin
                if ($signed(rs1) < $signed(rs2)) b_taken = 1'b1;
                else b_taken = 1'b0;
            end
            `BGE: begin
                if ($signed(rs1) >= $signed(rs2)) b_taken = 1'b1;
                else b_taken = 1'b0;
            end
            `BLTU: begin
                if (rs1 < rs2) b_taken = 1'b1;
                else b_taken = 1'b0;
            end
            `BGEU: begin
                if (rs1 >= rs2) b_taken = 1'b1;
                else b_taken = 1'b0;
            end
        endcase
    end

endmodule



module register_file (
    input  logic        clk,
    input  logic        rf_we,   //register file write enable
    input  logic [ 4:0] waddr,
    input  logic [31:0] wdata,
    input  logic [ 4:0] raddr1,
    input  logic [ 4:0] raddr2,
    output logic [31:0] rdata1,
    output logic [31:0] rdata2

);


    logic [31:0] register_file[1:31];

    
`ifdef TEST_SIMULATION
    int i = 0;
    initial begin
        for (i = 1; i < 32; i++) register_file[i] = i;
    end
`endif

    always @(posedge clk) begin
        if (rf_we && (waddr != 5'd0)) begin
            register_file[waddr] <= wdata;
        end
    end
    assign rdata1 = (raddr1 != 0) ? register_file [raddr1] :32'd0; // 조합으로 해야 1cycle 내에 처리됨. 순차로 하면 1cycle내에 처리가 안됨.
    assign rdata2 = (raddr2 != 0) ? register_file[raddr2] : 32'd0;



endmodule


module mux_2x1 (
    input logic [31:0] in0,
    input logic [31:0] in1,
    input logic sel,
    output logic [31:0] out_mux
);

    assign out_mux = (sel) ? in1 : in0;


endmodule




module mux_wb (
    input  logic [31:0] in0,    //alu
    input  logic [31:0] in1,    //data memory load
    input  logic [31:0] in2,    // LUI : load upper imm
    input  logic [31:0] in3,    //AUIPC Add Upper imm
    input  logic [31:0] in4,    //JAL,JALR : pc + 4
    input  logic [ 2:0] sel,
    output logic [31:0] wb_out
);

    // assign wb_out =  (sel == 3'b100) ? in4 : 
    //                  (sel == 3'b011) ? in3 : 
    //                  (sel == 3'b010) ? in2 :
    //                  (sel == 3'b001) ? in1 : in0;

    always_comb begin
        wb_out = 32'd0;
        case (sel)
            3'b100: wb_out = in4;
            3'b011: wb_out = in3;
            3'b010: wb_out = in2;
            3'b001: wb_out = in1;
            3'b000: wb_out = in0;
        endcase
    end

endmodule
