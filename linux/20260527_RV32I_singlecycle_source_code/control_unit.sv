`timescale 1ns / 1ps

`include "define.vh"

module control_unit(                    //clk 없음, 1clk마다 자동으로 값이 계속 바껴서 들어옴.
    input logic [31:0] instr_code,
    output logic rf_we,
    output logic alusrc_sel,
    output logic [3:0] alu_control,
    output logic [2:0] mem_mode,
    output logic dwe,
    output logic [2:0] rfsrc_sel,
    output logic branch,
    output logic jal,
    output logic jalr
);


    logic [2:0] funct3;
    logic [6:0] funct7;  //7bit
    logic [6:0] opcode;  //7bit


    assign funct7 = instr_code[31:25];  //7bit
    assign funct3 = instr_code[14:12];  //3bit
    assign opcode = instr_code[6:0];  //7bit

    //[DEBUG]
    typedef enum logic [6:0] {
        R_TYPE = `R_TYPE,
        S_TYPE = `S_TYPE,
        IL_TYPE = `IL_TYPE,
        I_TYPE = `I_TYPE,
        B_TYPE = `B_TYPE,
        JAL = `JAL,
        JALR = `JALR,
        AUIPC = `AUIPC,
        LUI = `LUI
    } opcode_dbg_e;
    opcode_dbg_e opcode_dbg;
    assign opcode_dbg = opcode_dbg_e'(opcode);

typedef enum logic [3:0] {
    ADD  = `ADD,
    SUB  = `SUB,
    SLL  = `SLL,
    SLT  = `SLT,
    SLTU = `SLTU,
    XOR  = `XOR,
    SRL  = `SRL,
    SRA  = `SRA,
    OR   = `OR,
    AND  = `AND
} r_type_dbg_e;
r_type_dbg_e r_type_dbg;

typedef enum logic [2:0] {
    BEQ  = `BEQ,
    BNE  = `BNE,
    BLT  = `BLT,
    BGE  = `BGE,
    BLTU = `BLTU,
    BGEU = `BGEU
} b_type_dbg_e;
b_type_dbg_e b_type_dbg;

assign r_type_dbg =  r_type_dbg_e'(alu_control) ;
assign b_type_dbg =  b_type_dbg_e'(funct3) ;



    always_comb begin
        rf_we       = 1'b0;
        alusrc_sel  = 0;
        alu_control = 4'd0;
        mem_mode    = 3'b0;
        dwe         = 0;
        rfsrc_sel   = 0;
        branch      = 0;
                jal         = 0;
                jalr        = 0;
        case (opcode)
            `R_TYPE: begin
                rf_we       = 1'b1;
                alusrc_sel  = 0;
                alu_control = {funct7[5], funct3};
                mem_mode    = 3'b0;
                dwe         = 0;
                rfsrc_sel   = 0;
                branch      = 0;
                jal         = 0;
                jalr        = 0;
            end
            `S_TYPE: begin
                rf_we       = 1'b0;
                alusrc_sel  = 1;
                alu_control = `ADD;
                mem_mode    = funct3;
                dwe         = 1;
                rfsrc_sel   = 0;
                branch      = 0;
                jal         = 0;
                jalr        = 0;
            end
            `IL_TYPE: begin
                rf_we = 1'b1;  // 
                alusrc_sel = 1;  //immediate 값
                alu_control = `ADD;  //add만 있으면 됨
                mem_mode = funct3;  //1
                dwe = 0;  //memory에 write가 아니라 load를 해야됨.
                rfsrc_sel = 3'd1;  //memory에서 값이 오는거임
                branch = 0;
                jal         = 0;
                jalr        = 0;
            end

            `I_TYPE: begin
                rf_we      = 1'b1;
                alusrc_sel = 1'b1;
                mem_mode   = 3'b0;
                dwe        = 1'b0;
                rfsrc_sel  = 3'b0;
                jal         = 0;
                jalr        = 0;
                branch     = 0;
                if (funct3 == 3'b101) alu_control = {funct7[5], funct3};
                else alu_control = {1'b0, funct3};
            end

            `B_TYPE: begin
                rf_we = 1'b0;  // 
                alusrc_sel = 0;  //immediate 값
                alu_control = {1'b0, funct3};
                mem_mode = 3'b0;  //1
                dwe = 0;  //memory에 write가 아니라 load를 해야됨.
                rfsrc_sel = 0;  //memory에서 값이 오는거임
                branch = 1;
                jal         = 0;
                jalr        = 0;
            end
            `LUI: begin
                rf_we = 1'b1;  // 
                alusrc_sel = 0;  //immediate 값
                alu_control = `ADD;
                mem_mode = 3'b0;  //
                dwe = 0;  //memory에 write가 아니라 load를 해야됨.
                rfsrc_sel = 3'd2;  //memory에서 값이 오는거임
                branch = 0;
                jal         = 0;
                jalr        = 0;

            end
            `AUIPC: begin
                rf_we = 1'b1;  // 
                alusrc_sel = 0;  //immediate 값
                alu_control = `ADD;
                mem_mode = 3'b0;  //
                dwe = 0;  //memory에 write가 아니라 load를 해야됨.
                rfsrc_sel = 3'd3;  //memory에서 값이 오는거임
                branch = 0;
                jal         = 0;
                jalr        = 0;

            end
            `JAL: begin
                rf_we = 1'b1;  // 
                alusrc_sel = 0;  //immediate 값
                alu_control = `ADD;
                mem_mode = 3'b0;  //
                dwe = 0;  //memory에 write가 아니라 load를 해야됨.
                rfsrc_sel = 3'd4;  //memory에서 값이 오는거임
                branch = 0;
                jal = 1;
                jalr        = 0;

            end
            `JALR: begin
                rf_we = 1'b1;  // 
                alusrc_sel = 0;  //immediate 값
                alu_control = `ADD;
                mem_mode = 3'b0;  //1
                dwe = 0;  //memory에 write가 아니라 load를 해야됨.
                rfsrc_sel = 3'd4;  //memory에서 값이 오는거임
                branch = 0;
                jalr = 1;
                jal         = 0;
            end
        endcase
    end


endmodule
