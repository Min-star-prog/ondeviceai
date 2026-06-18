`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/13 15:18:29
// Design Name: 
// Module Name: fsm_led
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


module fsm_led (
    input clk,
    input rst,
    input [2:0] sw,
    output reg [2:0] led
);

    parameter STATE_A = 3'b000, STATE_B = 3'b001, STATE_C = 3'b010, 
              STATE_D = 3'b011, STATE_E = 3'b100;

    // state register
    reg [2:0] current_state, next_state;

    always @(posedge clk) begin
        if (rst) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    // next state Combinational Logic
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (sw == 3'b001) begin
                    next_state = STATE_B;
                end else if(sw == 3'b010) begin
                    next_state = STATE_C;
                end else begin
                    next_state = current_state;
                end
            end
            
            STATE_B: begin
                if (sw == 3'b010) begin
                    next_state = STATE_C;
                end else begin
                    next_state = current_state;
                end
            end
            STATE_C: begin
                if (sw == 3'b100) begin
                    next_state = STATE_D;
                end else begin
                    next_state = current_state;
                end
            end
            STATE_D: begin
                if (sw == 3'b001) begin
                    next_state = STATE_B;
                end else if (sw == 3'b000) begin
                    next_state = STATE_A;
                end else if (sw == 3'b111) begin
                    next_state = STATE_A;
                end else begin
                    next_state = current_state;
                end
            end
            STATE_E: begin
                if (sw == 3'b000) begin
                    next_state = STATE_A;
                end else begin
                    next_state = current_state;
                end
            end
            default: next_state = current_state;
        endcase
    end

    // output Combinational logic
    // assign led = (current_state == STATE_A) ? 3'b001 : 
    //              (current_state == STATE_B) ? 3'b010 : 
    //              (current_state == STATE_C) ? 3'b100 : 3'b000;

    always @(*) begin
        case (current_state)
            STATE_A: led = 3'b000;
            STATE_B: led = 3'b001;
            STATE_C: led = 3'b010;
            STATE_D: led = 3'b100;
            STATE_E: led = 3'b111;
            default: led = 3'b000;
        endcase
    end

endmodule
