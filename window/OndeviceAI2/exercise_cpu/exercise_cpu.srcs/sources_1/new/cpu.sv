`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/14 11:40:10
// Design Name: 
// Module Name: dedicated_cpu_counter
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


module cpu (
    input        clk,
    input        rst,
    output [7:0] out
);


    logic ag10;
    logic       we;
    logic       rf_src_sel;
    logic [1:0] wa;
    logic [1:0] ra0;
    logic [1:0] ra1;



    data_path U_DATA_PATH (.*);
    control_unit U_CTRL_UNIT (.*);



endmodule







module data_path (
    input  logic       clk,
    input  logic       rst,
    input  logic       we,
    input  logic       rf_src_sel,
    input  logic [1:0] wa,
    input  logic [1:0] ra0,
    input  logic [1:0] ra1,
    output logic       ag10,
    output logic [7:0] out
);

    logic [7:0] rd0, mux_out;

    mux_2x1 U_MUX (
        .in0    (8'h01),
        .in1    (alu_result),
        .sel    (rf_src_sel),
        .mux_out(mux_out)
    );

    register_file U_REGISTER_FILE (
        .clk(clk),
        .rst(rst),
        .ra0(ra0),
        .ra1(ra1),
        .wa (wa),
        .we (we),
        .wd (mux_out),
        .rd0(rd0),
        .rd1(out)
    );

    alu U_ALU (
        .a         (rd0),
        .b         (out),
        .alu_result(alu_result)
    );

    comparator U_COMP_AG10 (
        .in      (rd0),
        .compare (8'h0a),
        .comp_out(ag10)
    );



endmodule





module mux_2x1 (
    input  logic [7:0] in0,
    input  logic [7:0] in1,
    input  logic       sel,
    output logic [7:0] mux_out
);
    assign mux_out = (sel == 0) ? in0 : in1;

    // always_comb begin
    //     if (sel == 0) mux_out = in0;
    //     else mux_out = in1;
    // end
endmodule



module register_file (
    input logic clk,
    input logic rst,
    input logic [1:0] ra0,
    input logic [1:0] ra1,
    input logic [1:0] wa,
    input logic we,
    input logic [7:0] wd,
    output logic [7:0] rd0,
    output logic [7:0] rd1
);

    logic [7:0] register[0:3];
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            register[0] <= 0;
        end else begin
            if (we) register[wa] <= wd;
        end
    end


              assign  rd0 = register[ra0];
              assign  rd1 = register[ra1];

endmodule  //s0에서 a랑 s를 쪼개야되는데 그러면 1clk 지연됨.srcsel = 0 //0 load하는 법 : RD0,RD1 둘다 0나가서 0을 저장시켜야됨











module alu (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] alu_result
);

    assign alu_result = a + b;

endmodule

module comparator (
    input [7:0] in,
    input [7:0] compare,
    output comp_out
);

    assign comp_out = (in > compare);

endmodule





module control_unit (
    input  logic       clk,
    input  logic       rst,
    input  logic       ag10,
    output logic       we,
    output logic       rf_src_sel,
    output logic [1:0] wa,
    output logic [1:0] ra0,
    output logic [1:0] ra1
);


    // we = 0;
    // wa = 0;
    // rf_src_sel = 0;
    // ra0 = 0;
    // ra1 = 0;

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


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c_state <= S0;
        end else begin
            c_state <= n_state;
        end
    end

    always @(*) begin
        n_state = c_state;
        we = 0;
        wa = 0;
        rf_src_sel = 0;
        ra0 = 0;
        ra1 = 0;
        case (c_state)
            S0: begin
                n_state = S1;
                we = 0;
                wa = 0;
                rf_src_sel = 1;
                ra0 = 0;
                ra1 = 0;
            end
            S1: begin
                //sum = 0
                we = 1;
                wa = 2;
                rf_src_sel = 1;
                ra0 = 0;
                ra1 = 0;
                    n_state = S2;
            end
            S2: begin
                // a = 0;
                we = 1;
                wa = 3;
                rf_src_sel = 1;
                ra0 = 0;
                ra1 = 0;
                n_state = S3;
            end
            S3: begin
                //1 load
                we = 1;
                wa = 1;
                rf_src_sel = 0;
                ra0 = 0;
                ra1 = 0;
                n_state = S4;
            end
            S4: begin
                //비교 및 전체 출력
                we = 0;
                wa = 0;
                rf_src_sel = 0;
                ra0 = 3;
                ra1 = 2;
                if (!ag10) begin
                    n_state = S5;
                end else begin
                    n_state = S7;
                end
            end

            S5: begin
                // a = a + 1
                we = 1;
                wa = 3;
                rf_src_sel = 1;
                ra0 = 3;
                ra1 = 1;
                    n_state = S6;
            end
            S6: begin
                // s = s + a
                we = 1;
                wa = 2;
                rf_src_sel = 1;
                ra0 = 3;
                ra1 = 2;
                    n_state = S7;
            end
            S7: begin
                we = 0;
                wa = 0;
                rf_src_sel = 1;
                ra0 = 0;
                ra1 = 2;
            end

        endcase
    end

endmodule
