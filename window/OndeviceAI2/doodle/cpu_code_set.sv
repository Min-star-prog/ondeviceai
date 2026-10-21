`timescale 1ns / 1ps

// RV32I single-cycle CPU core with external instruction/data memories.
module rv32i_cpu (
    input logic clk,
    rst,
    input logic [31:0] instr_code,
    drdata,
    output logic [31:0] instr_addr,
    output logic [2:0] mem_mode,
    output logic dwe,
    output logic [31:0] daddr,
    dwdata
);
    logic rf_we, alu_src_imm, branch, jal, jalr;
    logic [3:0] alu_control;
    logic [2:0] wb_sel;

    control_unit U_CONTROL_UNIT (.*);
    rv32i_datapath U_DATAPATH (.*);
endmodule


module control_unit (
    input logic [31:0] instr_code,
    output logic rf_we,
    alu_src_imm,
    output logic [3:0] alu_control,
    output logic [2:0] mem_mode,
    output logic dwe,
    output logic [2:0] wb_sel,
    output logic branch,
    jal,
    jalr
);
    localparam logic [6:0] OP_LOAD   = 7'b0000011,
                           OP_IMM    = 7'b0010011,
                           OP_AUIPC  = 7'b0010111,
                           OP_STORE  = 7'b0100011,
                           OP_REG    = 7'b0110011,
                           OP_LUI    = 7'b0110111,
                           OP_BRANCH = 7'b1100011,
                           OP_JALR   = 7'b1100111,
                           OP_JAL    = 7'b1101111;
    localparam logic [3:0] ALU_ADD = 4'b0000;
    localparam logic [2:0] WB_ALU = 0, WB_MEM = 1, WB_IMM = 2, WB_PCIMM = 3, WB_PC4 = 4;

    logic [6:0] opcode;
    logic [2:0] funct3;
    assign opcode = instr_code[6:0];
    assign funct3 = instr_code[14:12];

    always_comb begin
        rf_we       = 1'b0;
        alu_src_imm = 1'b0;
        alu_control = ALU_ADD;
        mem_mode    = funct3;
        dwe         = 1'b0;
        wb_sel      = WB_ALU;
        branch      = 1'b0;
        jal         = 1'b0;
        jalr        = 1'b0;

        case (opcode)
            OP_REG: begin
                rf_we       = 1'b1;
                alu_control = {instr_code[30], funct3};
            end
            OP_IMM: begin
                rf_we       = 1'b1;
                alu_src_imm = 1'b1;
                alu_control = (funct3 == 3'b101) ? {instr_code[30], funct3} : {1'b0, funct3};
            end
            OP_LOAD: begin
                rf_we       = 1'b1;
                alu_src_imm = 1'b1;
                wb_sel      = WB_MEM;
            end
            OP_STORE: begin
                alu_src_imm = 1'b1;
                dwe         = 1'b1;
            end
            OP_BRANCH: branch = 1'b1;
            OP_LUI: begin
                rf_we  = 1'b1;
                wb_sel = WB_IMM;
            end
            OP_AUIPC: begin
                rf_we  = 1'b1;
                wb_sel = WB_PCIMM;
            end
            OP_JAL: begin
                rf_we  = 1'b1;
                wb_sel = WB_PC4;
                jal    = 1'b1;
            end
            OP_JALR: begin
                rf_we  = 1'b1;
                wb_sel = WB_PC4;
                jalr   = 1'b1;
            end
            default: begin
            end  // Illegal instruction: NOP
        endcase
    end
endmodule


module rv32i_datapath (
    input logic clk,
    rst,
    input logic [31:0] instr_code,
    drdata,
    input logic rf_we,
    alu_src_imm,
    input logic [3:0] alu_control,
    input logic [2:0] wb_sel,
    input logic branch,
    jal,
    jalr,
    output logic [31:0] instr_addr,
    daddr,
    dwdata
);
    logic [31:0] pc, pc_next, pc_plus4, pc_plus_imm, jalr_addr;
    logic [31:0] imm, rs1_data, rs2_data, alu_b, alu_result, wb_data;
    logic branch_taken;

    assign instr_addr  = pc;
    assign pc_plus4    = pc + 32'd4;
    assign pc_plus_imm = pc + imm;
    assign jalr_addr   = (rs1_data + imm) & 32'hffff_fffe;
    assign alu_b       = alu_src_imm ? imm : rs2_data;
    assign daddr       = alu_result;
    assign dwdata      = rs2_data;

    always_comb begin
        pc_next = pc_plus4;
        if (branch && branch_taken) pc_next = pc_plus_imm;
        if (jal) pc_next = pc_plus_imm;
        if (jalr) pc_next = jalr_addr;
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) pc <= 32'd0;
        else pc <= pc_next;
    end

    imm_extend U_IMM_EXTEND (
        .instr_code(instr_code),
        .imm(imm)
    );
    register_file U_REGISTER_FILE (
        .clk(clk),
        .rst(rst),
        .rf_we(rf_we),
        .waddr(instr_code[11:7]),
        .wdata(wb_data),
        .raddr1(instr_code[19:15]),
        .raddr2(instr_code[24:20]),
        .rdata1(rs1_data),
        .rdata2(rs2_data)
    );
    alu U_ALU (
        .alu_control(alu_control),
        .a(rs1_data),
        .b(alu_b),
        .result(alu_result)
    );
    branch_comp U_BRANCH_COMP (
        .funct3(instr_code[14:12]),
        .a(rs1_data),
        .b(rs2_data),
        .taken(branch_taken)
    );

    always_comb begin
        case (wb_sel)
            3'd1: wb_data = drdata;
            3'd2: wb_data = imm;
            3'd3: wb_data = pc_plus_imm;
            3'd4: wb_data = pc_plus4;
            default: wb_data = alu_result;
        endcase
    end
endmodule


module imm_extend (
    input  logic [31:0] instr_code,
    output logic [31:0] imm
);
    localparam logic [6:0] OP_LOAD   = 7'b0000011,
                           OP_IMM    = 7'b0010011,
                           OP_AUIPC  = 7'b0010111,
                           OP_STORE  = 7'b0100011,
                           OP_LUI    = 7'b0110111,
                           OP_BRANCH = 7'b1100011,
                           OP_JALR   = 7'b1100111,
                           OP_JAL    = 7'b1101111;

    always_comb begin
        case (instr_code[6:0])
            OP_LOAD, OP_IMM, OP_JALR: imm = {{20{instr_code[31]}}, instr_code[31:20]};
            OP_STORE: imm = {{20{instr_code[31]}}, instr_code[31:25], instr_code[11:7]};
            OP_BRANCH:
            imm = {
                {19{instr_code[31]}},
                instr_code[31],
                instr_code[7],
                instr_code[30:25],
                instr_code[11:8],
                1'b0
            };
            OP_LUI, OP_AUIPC: imm = {instr_code[31:12], 12'b0};
            OP_JAL:
            imm = {
                {11{instr_code[31]}},
                instr_code[31],
                instr_code[19:12],
                instr_code[20],
                instr_code[30:21],
                1'b0
            };
            default: imm = 32'd0;
        endcase
    end
endmodule


module alu (
    input  logic [ 3:0] alu_control,
    input  logic [31:0] a,
    b,
    output logic [31:0] result
);
    always_comb begin
        case (alu_control)
            4'b0000: result = a + b;  // ADD
            4'b1000: result = a - b;  // SUB
            4'b0001: result = a << b[4:0];  // SLL
            4'b0010: result = {31'd0, $signed(a) < $signed(b)};  // SLT
            4'b0011: result = {31'd0, a < b};  // SLTU
            4'b0100: result = a ^ b;  // XOR
            4'b0101: result = a >> b[4:0];  // SRL
            4'b1101: result = $signed(a) >>> b[4:0];  // SRA
            4'b0110: result = a | b;  // OR
            4'b0111: result = a & b;  // AND
            default: result = 32'd0;
        endcase
    end
endmodule


module branch_comp (
    input logic [2:0] funct3,
    input logic [31:0] a,
    b,
    output logic taken
);
    always_comb begin
        case (funct3)
            3'b000:  taken = (a == b);  // BEQ
            3'b001:  taken = (a != b);  // BNE
            3'b100:  taken = ($signed(a) < $signed(b));  // BLT
            3'b101:  taken = ($signed(a) >= $signed(b));  // BGE
            3'b110:  taken = (a < b);  // BLTU
            3'b111:  taken = (a >= b);  // BGEU
            default: taken = 1'b0;
        endcase
    end
endmodule


module register_file (
    input logic clk,
    rst,
    rf_we,
    input logic [4:0] waddr,
    raddr1,
    raddr2,
    input logic [31:0] wdata,
    output logic [31:0] rdata1,
    rdata2
);
    logic [31:0] registers[0:31];
    integer i;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) registers[i] <= 32'd0;
        end else if (rf_we && (waddr != 5'd0)) begin
            registers[waddr] <= wdata;
        end
    end

    always_comb begin
        rdata1 = (raddr1 == 5'd0) ? 32'd0 : registers[raddr1];
        rdata2 = (raddr2 == 5'd0) ? 32'd0 : registers[raddr2];
    end
endmodule


// Optional 64-word little-endian memory for a simple SoC or testbench.
module data_mem (
    input logic clk,
    input logic [31:0] daddr,
    input logic dwe,
    input logic [2:0] mem_mode,
    input logic [31:0] dwdata,
    output logic [31:0] drdata
);
    logic [31:0] ram[0:63];
    logic [31:0] word_data;
    assign word_data = ram[daddr[7:2]];

    always_ff @(posedge clk) begin
        if (dwe) begin
            case (mem_mode)
                3'b000:
                case (daddr[1:0])  // SB
                    2'd0: ram[daddr[7:2]][7:0] <= dwdata[7:0];
                    2'd1: ram[daddr[7:2]][15:8] <= dwdata[7:0];
                    2'd2: ram[daddr[7:2]][23:16] <= dwdata[7:0];
                    2'd3: ram[daddr[7:2]][31:24] <= dwdata[7:0];
                endcase
                3'b001: begin  // SH
                    if (daddr[1]) ram[daddr[7:2]][31:16] <= dwdata[15:0];
                    else ram[daddr[7:2]][15:0] <= dwdata[15:0];
                end
                3'b010: ram[daddr[7:2]] <= dwdata;  // SW
                default: begin
                end
            endcase
        end
    end

    always_comb begin
        case (mem_mode)
            3'b000:
            case (daddr[1:0])  // LB
                2'd0: drdata = {{24{word_data[7]}}, word_data[7:0]};
                2'd1: drdata = {{24{word_data[15]}}, word_data[15:8]};
                2'd2: drdata = {{24{word_data[23]}}, word_data[23:16]};
                default: drdata = {{24{word_data[31]}}, word_data[31:24]};
            endcase
            3'b001:
            drdata = daddr[1] ?
                    {{16{word_data[31]}}, word_data[31:16]} :
                    {{16{word_data[15]}}, word_data[15:0]}; // LH
            3'b010: drdata = word_data;  // LW
            3'b100:
            case (daddr[1:0])  // LBU
                2'd0: drdata = {24'd0, word_data[7:0]};
                2'd1: drdata = {24'd0, word_data[15:8]};
                2'd2: drdata = {24'd0, word_data[23:16]};
                default: drdata = {24'd0, word_data[31:24]};
            endcase
            3'b101:
            drdata = daddr[1] ? {16'd0, word_data[31:16]} : {16'd0, word_data[15:0]};  // LHU
            default: drdata = 32'd0;
        endcase
    end
endmodule


module instruction_mem (
    input  logic [31:0] instr_addr,
    output logic [31:0] instr_code
);

    logic [31:0] instr_rom[0:15];

    initial begin
        instr_rom[0] = 32'h0031_02b3;  // x5 = x2 + x3
        instr_rom[1] = 32'h0041_82b3;  // x5 = x4 + x3
    end

    assign instr_code = instr_rom[instr_addr];





endmodule
