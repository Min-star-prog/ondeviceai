`timescale 1ns / 1ps
// `define TEST_SIMULATION


module instruction_mem (
    input  logic [31:0] instr_addr,
    output logic [31:0] instr_code
);

    logic [31:0] instr_rom[0:127];  //word address 1씩 증가
`ifdef TEST_SIMULATION
    initial begin
        //R-type Simulation
        // instr_rom[0]  = 32'h0031_02b3;  // ADD  rd=x5,  rs1=x2, rs2=x3
        // instr_rom[1]  = 32'h0041_82b3;  // ADD  rd=x5,  rs1=x3, rs2=x4
        instr_rom[0]  = 32'h4031_02b3;  // SUB  rd=x5,  rs1=x2, rs2=x3
        instr_rom[1]  = 32'h4041_0333;  // SUB  rd=x6,  rs1=x2, rs2=x4

        // instr_rom[4]  = 32'h0041_13b3;  // SLL  rd=x7,  rs1=x2, rs2=x4
        // instr_rom[5]  = 32'h0012_a433;  // SLT  rd=x8,  rs1=x5, rs2=x1
        // instr_rom[6]  = 32'h0012_b4b3;  // SLTU rd=x9,  rs1=x5, rs2=x1
        // instr_rom[7]  = 32'h0021_c533;  // XOR  rd=x10, rs1=x3, rs2=x2
        // instr_rom[8]  = 32'h0012_d5b3;  // SRL  rd=x11, rs1=x5, rs2=x1
        // instr_rom[9]  = 32'h4012_d633;  // SRA  rd=x12, rs1=x5, rs2=x1
        // instr_rom[10] = 32'h0021_e6b3;  // OR   rd=x13, rs1=x3, rs2=x2
        // instr_rom[11] = 32'h0021_f733;  // AND  rd=x14, rs1=x3, rs2=x2



        // //IL_Type

// LB  : 8bit signed load
// instr_rom[6] = 32'h0000_8383; // LB  rd=x7,  imm=0(rs1=x1)
// // LH  : 16bit signed load
// instr_rom[7] = 32'h0040_9403; // LH  rd=x8,  imm=4(rs1=x1)
// // LW  : 32bit load
// instr_rom[8] = 32'h0000_a483; // LW  rd=x9,  imm=0(rs1=x1)
// // LBU : 8bit unsigned load
// instr_rom[9] = 32'h0080_c503; // LBU rd=x10, imm=8(rs1=x1)
// // LHU : 16bit unsigned load
// instr_rom[10] = 32'h0040_d583; // LHU rd=x11, imm=4(rs1=x1)
        // // I_Type
        // instr_rom[2]  = 32'hfff1_0393;  // ADDI  rd=x7,  rs1=x2, imm=-1
        // instr_rom[3]  = 32'h0012_a413;  // SLTI  rd=x8,  rs1=x5, imm=1
        // instr_rom[4]  = 32'h0012_b493;  // SLTIU rd=x9,  rs1=x5, imm=1
        // instr_rom[5]  = 32'h0021_c513;  // XORI  rd=x10, rs1=x3, imm=2
        // instr_rom[6]  = 32'h0021_e593;  // ORI   rd=x11, rs1=x3, imm=2
        // instr_rom[7]  = 32'h0021_f613;  // ANDI  rd=x12, rs1=x3, imm=2
        // instr_rom[8]  = 32'h0041_1693;  // SLLI  rd=x13, rs1=x2, shamt=4
        // instr_rom[9]  = 32'h0012_d713;  // SRLI  rd=x14, rs1=x5, shamt=1
        // instr_rom[10] = 32'h4012_d793;  // SRAI  rd=x15, rs1=x5, shamt=1

        // //S-Type
        // x16 = 0xFFFF_FFFF
        // instr_rom[2]  = 32'hfff0_0813;  // ADDI rd=x16, rs1=x0, imm=-1
        // // SW : MEM[x1 + 0] = x16 (32bit 저장)
        // instr_rom[3]  = 32'h0100_a023;  // SW rs2=x16, imm=0(rs1=x1)
        // // SH : MEM[x1 + 4] = x16[15:0] (하위 16bit 저장)
        // instr_rom[4]  = 32'h0100_9223;  // SH rs2=x16, imm=4(rs1=x1)
        // // SB : MEM[x1 + 8] = x16[7:0] (하위 8bit 저장)
        // instr_rom[5]  = 32'h0100_8423;  // SB rs2=x16, imm=8(rs1=x1)

        // //B_TYPE
        // BEQ  : 1 == 1 → branch
        // instr_rom[2] = 32'h0010_8463; // beq  x1, x1, 8
        // // BNE  : 1 != -1 → branch
        // instr_rom[3] = 32'h0050_9463; // bne  x1, x5, 8
        // // BLT  : -1 < 1 → branch (signed)
        // instr_rom[4] = 32'h0012_c463; // blt  x5, x1, 8
        // // BGE  : 1 >= -1 → branch (signed)
        // instr_rom[5] = 32'h0050_d463; // bge  x1, x5, 8
        // // BLTU : FFFF_FFFF < 1 → false (unsigned)
        // instr_rom[6] = 32'h0012_e463; // bltu x5, x1, 8
        // // BGEU : FFFF_FFFF >= 1 → true (unsigned)
        // instr_rom[7] = 32'h0012_f463; // bgeu x5, x1, 8

        // LUI / AUIPC / JAL / JALR Simulation

// LUI
// instr_rom[2] = 32'h1234_53b7;
// // AUIPC
// instr_rom[3] = 32'h1234_5417;
// // JAL : PC+8 로 점프
// instr_rom[4] = 32'h0080_04ef;
// // JALR
// instr_rom[6] = 32'h00f0_8567;
    end
`endif

    initial begin
        $readmemh("instruction_mem_sort.mem",instr_rom);      //다른 directory면 앞에 경로를 추가해줘야됨.
    end

    assign instr_code = instr_rom[instr_addr[31:2]];  //byte address 4씩 증가



endmodule









