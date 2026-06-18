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
        instr_rom[0] = 32'h0031_02b3;  //x5 = x2 + x3
        instr_rom[1] = 32'h0041_82b3;  //x5 = x4 + x3 ADD
        instr_rom[2] = 32'h4031_02b3; // sub x5, x2, x3 = -1
        instr_rom[3] = 32'h4041_0333; // sub x6, x2, x4 = -2
        instr_rom[4]  = 32'h0041_13b3; // SLL   rs1=x2 rs2=x4

        instr_rom[5]  = 32'h0053_2433; // SLT1  rs1=x6 rs2=x5
        // instr_rom[6]  = 32'h0011_24b3; // SLT2  rs1=x2 rs2=x1

        instr_rom[6]  = 32'h0053_3533; // SLTU1 rs1=x6 rs2=x5
        // instr_rom[8]  = 32'h0011_35b3; // SLTU2 rs1=x2 rs2=x1

        instr_rom[7]  = 32'h0021_c633; // XOR   rs1=x3 rs2=x2

        instr_rom[8] = 32'h0021_56b3; // SRL1  rs1=x2 rs2=x2
        // instr_rom[11] = 32'h0061_5733; // SRL2  rs1=x2 rs2=x6

        instr_rom[9] = 32'h4021_57b3; // SRA1  rs1=x2 rs2=x2
        // instr_rom[13] = 32'h4061_5833; // SRA2  rs1=x2 rs2=x6

        instr_rom[10] = 32'h0021_e8b3; // OR    rs1=x3 rs2=x2
        instr_rom[11] = 32'h0021_f933; // AND   rs1=x3 rs2=x2

        // //S-Type
        // instr_rom[2] = 32'h0031_2123;  // SW x2, x3, 2 rs1,rs2,imm

        // //IL_Type
        // instr_rom[3] = 32'h0021_2403;  //LW  x8, x2, 2 rd, rs1, imm

        // //
        // instr_rom[4] = 32'h0043_8413;  //addi x8,x7,4: rd, rs1, imm

        // //B_TYPE
        // instr_rom[5] = 32'hfe84_0ce3  ;      //BEQ x8, x8, -8 : rd, rs1, imm // 참이면 pc = pc -8

    end
`endif

    initial begin
        $readmemh("APB_BRAM.mem",instr_rom);      //다른 directory면 앞에 경로를 추가해줘야됨.
    end

    assign instr_code = instr_rom[instr_addr[31:2]];  //byte address 4씩 증가



endmodule









