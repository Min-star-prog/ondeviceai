`timescale 1ns / 1ps

`include "define.vh"

module control_unit(                    //clk 없음, 1clk마다 자동으로 값이 계속 바껴서 들어옴.
    input logic [31:0] instr_code,
    input logic rst,
    input logic clk,
    input logic ready, // from apb master
    output logic pc_en,
    output logic rf_we,
    output logic alusrc_sel,
    output logic [3:0] alu_control,
    output logic [2:0] mem_mode,
    output logic w_req,
    output logic r_req,
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


    typedef enum logic [2:0] {
        FETCH   = 0,
        DECODE,
        EXECUTE,
        MEM,
        WB
    } state_t;
    state_t c_state, n_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_state <= FETCH;
        end else begin
            c_state <= n_state;
        end
    end


    always_comb begin
        n_state          = c_state;
        rf_we            = 1'b0;
        alusrc_sel       = 0;
        alu_control      = 4'd0;
        mem_mode         = 3'b0;
        w_req              = 0;
        r_req              = 0;
        rfsrc_sel        = 0;
        branch           = 0;
        jal              = 0;
        jalr             = 0;
        pc_en            = 0;

        case (c_state)
            FETCH: begin
                n_state = DECODE;
                pc_en   = 1;
            end
            DECODE: begin
                n_state = EXECUTE;
            end
            EXECUTE: begin
                if (opcode == `S_TYPE) begin
                    n_state     = MEM;
                    alusrc_sel  = 1;
                    alu_control = `ADD;
                end else if (opcode == `IL_TYPE) begin
                    n_state = MEM;
                    alusrc_sel = 1;  //immediate 값
                    alu_control = `ADD;  //add만 있으면 됨
                end else begin
                    n_state = FETCH;
                    case (opcode)
                        `R_TYPE: begin
                            rf_we       = 1'b1;
                            alusrc_sel  = 0;
                            alu_control = {funct7[5], funct3};
                            rfsrc_sel   = 0;
                        end
                        `I_TYPE: begin
                            rf_we      = 1'b1;
                            alusrc_sel = 1'b1;
                            rfsrc_sel  = 3'b0;
                            if (funct3 == 3'b101)
                                alu_control = {funct7[5], funct3};
                            else alu_control = {1'b0, funct3};
                        end
                        `B_TYPE: begin
                            rf_we = 1'b0;  // 
                            alusrc_sel = 0;  //immediate 값
                            alu_control = {1'b0, funct3};
                            rfsrc_sel = 0;  //memory에서 값이 오는거임
                            branch = 1;
                            jal = 0;
                            jalr = 0;
                        end
                        `LUI: begin
                            rf_we = 1'b1;  // 
                            alusrc_sel = 0;  //immediate 값
                            alu_control = `ADD;
                            rfsrc_sel = 3'd2;  //memory에서 값이 오는거임
                        end
                        `AUIPC: begin
                            rf_we = 1'b1;  // 
                            alusrc_sel = 0;  //immediate 값
                            alu_control = `ADD;
                            rfsrc_sel = 3'd3;  //memory에서 값이 오는거임
                        end
                        `JAL: begin
                            rf_we = 1'b1;  // 
                            alusrc_sel = 0;  //immediate 값
                            alu_control = `ADD;
                            rfsrc_sel = 3'd4;  //memory에서 값이 오는거임
                            branch = 0;
                            jal = 1;
                            jalr = 0;
                        end
                        `JALR: begin
                            rf_we = 1'b1;  // 
                            alusrc_sel = 0;  //immediate 값
                            alu_control = `ADD;
                            rfsrc_sel = 3'd4;  //memory에서 값이 오는거임
                            branch = 0;
                            jalr = 1;
                            jal = 0;
                        end

                    endcase
                end
            end
            MEM: begin
                mem_mode = funct3;
                alusrc_sel  = 1;
                if (opcode == `S_TYPE) begin
                    w_req     = 1;
                    if(ready) begin
                    n_state = FETCH;
                end 
                end else begin
                    r_req     = 1;
                    if(ready) begin
                    n_state = WB;
                    end
                end
            end
            WB: begin
                n_state = FETCH;
                rfsrc_sel = 3'd1;
                rf_we   = 1'b1;
            end

        endcase

    end




    //[DEBUG]
    typedef enum logic [6:0] {
        R_TYPE = `R_TYPE,
        S_TYPE = `S_TYPE,
        IL_TYPE = `IL_TYPE,
        I_TYPE = `I_TYPE,
        B_TYPE = `B_TYPE,
        JAL = `JAL,
        JALR = `JALR,
        AUIPC = `AUIPC
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

    assign r_type_dbg = r_type_dbg_e'(alu_control);
    assign b_type_dbg = b_type_dbg_e'(funct3);



endmodule















