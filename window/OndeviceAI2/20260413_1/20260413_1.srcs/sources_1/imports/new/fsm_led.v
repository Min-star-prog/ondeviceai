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
    output [2:0] led
);

    parameter [2:0] STATE_A = 3'b000, STATE_B = 3'b001, STATE_C = 3'b010, 
                    STATE_D = 3'b011, STATE_E = 3'b100;

    // state register
    reg [2:0] current_state, next_state;
    //output SL
    reg [2:0] led_reg, led_next;

    assign led = led_reg;

    always @(posedge clk) begin
        if (rst) begin
            current_state <= STATE_A;
            led_reg <= 3'b000;
        end else begin
            current_state <= next_state;
            led_reg <= led_next;
        end
    end

    // next state Combinational Logic
    always @(*) begin
        next_state = current_state;  // default
        led_next   = led_reg;

        case (current_state)
            STATE_A: begin
                // led_next = 3'b000;  // moore output
                if (sw == STATE_B) begin
                    next_state = STATE_B;
                    led_next   = 3'b001;  // mealy output
                end else if (sw == STATE_C) begin
                    next_state = STATE_C;
                    led_next   = 3'b010;  // mealy output
                end else begin
                    next_state = current_state;
                end
            end

            STATE_B: begin
                // led_next = 3'b001;
                if (sw == STATE_C) begin
                    led_next   = 3'b010;  // mealy output
                    next_state = STATE_C;
                end else begin
                    next_state = current_state;
                end
            end
            STATE_C: begin
                // led_next = 3'b010;
                if (sw == STATE_D) begin
                    led_next   = 3'b100;  // mealy output
                    next_state = STATE_D;
                end else begin
                    next_state = current_state;
                end
            end
            STATE_D: begin
                // led_next = 3'b100;
                if (sw == STATE_B) begin
                    led_next   = 3'b001;  // mealy output
                    next_state = STATE_B;
                end else if (sw == STATE_A) begin
                    led_next   = 3'b000;  // mealy output
                    next_state = STATE_A;
                end else if (sw == STATE_E) begin
                    led_next   = 3'b111;  // mealy output
                    next_state = STATE_E;
                end else begin
                    next_state = current_state;
                end
            end
            STATE_E: begin
                // led_next = 3'b111;
                if (sw == STATE_A) begin
                    led_next   = 3'b000;  // mealy output
                    next_state = STATE_A;
                end else begin
                    next_state = current_state;
                end
            end
            default: next_state = current_state;
        endcase
    end

    // output Combinational logic
    // assign led = (current_state == STATE_A) ? 3'b000 : 
    //              (current_state == STATE_B) ? 3'b001 : 
    //              (current_state == STATE_C) ? 3'b010 :
    //              (current_state == STATE_D) ? 3'b100 : 
    //              (current_state == STATE_E) ? 3'b111 :  3'b000;

    // always @(*) begin
    //     case (current_state)
    //         STATE_A: led = 3'b000;
    //         STATE_B: led = 3'b001;
    //         STATE_C: led = 3'b010;
    //         STATE_D: led = 3'b100;
    //         STATE_E: led = 3'b111;
    //         default: led = 3'b000;
    //     endcase
    // end

endmodule
