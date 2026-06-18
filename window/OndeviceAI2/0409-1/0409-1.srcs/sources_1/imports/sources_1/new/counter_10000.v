`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/09 14:42:17
// Design Name: 
// Module Name: counter_10000
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


module counter_10000 (
    input clk,
    input rst,
    input btnL,
    input btnD,
    input btnR,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);
    wire [13:0] w_tick_counter;
    wire w_run_stop, w_clear, w_mode;
    wire w_btnR, w_btnL, w_btnD;

    button_debounce U_DB_RUNSTOP (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btnR),
        .o_btn(w_btnR)
    );
    button_debounce U_DB_CLEAR (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btnL),
        .o_btn(w_btnL)
    );
    button_debounce U_DB_MODE (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btnD),
        .o_btn(w_btnD)
    );
    control_unit U_CONTROL_UNIT (
        .clk(clk),
        .rst(rst),
        .i_run_stop(w_btnR),
        .i_clear(w_btnL),
        .i_mode(w_btnD),
        .o_mode(w_mode),
        .o_clear(w_clear),
        .o_run_stop(w_run_stop)
    );
    fnd_controller U_FND_CTRL (
        .clk(clk),
        .rst(rst),
        .fnd_in(w_tick_counter),
        .fnd_com(fnd_com),
        .fnd_data(fnd_data)
    );
    datapath U_DATAPATH (
        .clk(clk),
        .rst(rst),
        .i_run_stop(w_run_stop),
        .i_clear(w_clear),
        .i_mode(w_mode),
        .tick_counter(w_tick_counter)
    );
endmodule






module datapath (
    input clk,
    input rst,
    input i_run_stop,
    input i_clear,
    input i_mode,
    output [13:0] tick_counter
);

    wire w_tick_10hz;

    tick_counter U_TICK_COUNTER (
        .clk(clk),
        .rst(rst),
        .i_tick(w_tick_10hz),
        .i_clear(i_clear),
        .i_mode(i_mode),
        .o_tick_counter(tick_counter)
    );


    clk_tick_gen U_CLK_TICK_GEN (
        .clk(clk),
        .rst(rst),
        .i_run_stop(i_run_stop),
        .i_clear(i_clear),
        .o_tick(w_tick_10hz)
    );


endmodule






// module tick_counter (
//     input clk,
//     input rst,
//     input i_tick,
//     input [2:0] sw,
//     output [13:0] o_tick_counter
// );


//     reg [$clog2(10_000)-1:0] tick_counter_reg;

//     assign o_tick_counter = tick_counter_reg;


//     always @(posedge clk, posedge rst) begin
//         if (rst) begin
//             tick_counter_reg <= 14'd0;

//         end else if (!sw[0]) begin
//             if (i_tick) begin  // 1: run / 0 : stop
//                 tick_counter_reg <= tick_counter_reg;
//             end

//         end else if (sw[1]) begin
//             if (i_tick) begin  // 1: clear / 0 : run
//                 tick_counter_reg <= 14'd0;
//             end

//         end else if (sw[2]) begin
//             if (i_tick) begin  // 1 : down / 0 : up
//                 tick_counter_reg <= tick_counter_reg - 1;
//                 if (tick_counter_reg == (0)) begin
//                     tick_counter_reg <= 14'd9999;
//                 end
//             end
//         end else begin
//             if (i_tick) begin
//                 tick_counter_reg <= tick_counter_reg + 1;
//                 if (tick_counter_reg == (10000 - 1)) begin
//                     tick_counter_reg <= 14'd0;
//                 end
//             end
//         end

//     end

// endmodule



module tick_counter (
    input clk,
    input rst,
    input i_tick,
    input i_clear,
    input i_mode,
    output [13:0] o_tick_counter
);


    reg [$clog2(10_000)-1:0] tick_counter_reg;

    assign o_tick_counter = tick_counter_reg;


    always @(posedge clk, posedge rst) begin
        if (rst | i_clear) begin
            tick_counter_reg <= 14'd0;

        end else begin
            if (i_tick) begin  // after 10ns 1->0
                if (!i_mode) begin
                    //up count
                    tick_counter_reg <= tick_counter_reg + 1;
                    if (tick_counter_reg == (10000 - 1)) begin
                        tick_counter_reg <= 14'd0;
                    end
                end else begin
                    //down count
                    tick_counter_reg <= tick_counter_reg - 1;
                    if (tick_counter_reg == 0) begin
                        tick_counter_reg <= 14'd9999;
                    end
                end
            end
        end
    end

endmodule





module clk_tick_gen (
    input clk,
    input rst,
    input i_run_stop,
    input i_clear,
    output reg o_tick
);
    // counter = 100_000_000 / 10 -1 : 100MHz -> 10hz
    reg [$clog2(100_000_000/10)-1:0] counter_reg;  //$clog2 = bit automatic


    always @(posedge clk, posedge rst) begin
        if (rst | i_clear) begin
            counter_reg <= 24'd0;
            o_tick      <= 1'b0;
        end else begin
            if (i_run_stop) begin
                counter_reg <= counter_reg + 1;
                o_tick <= 1'b0;

                if (counter_reg == (10_000_000 - 1)) begin
                    counter_reg <= 24'd0;
                    o_tick <= 1'b1;
                end
            end
        end
    end


endmodule



// module control_unit (
//     input clk,
//     input rst,
//     input btn_r,
//     input btn_l,
//     input btn_d,
//     output reg [2:0] sw
// );

//     reg [1:0] state_reg, next_state;

//     // state declare
//     parameter stop = 2'b00;
//     parameter run = 2'b01;
//     parameter clear = 2'b10;
//     parameter mode = 2'b11;

//     // next state decision always Comb
//     always @(state_reg or btn_d or btn_l or btn_r) begin
//         case (state_reg)
//             stop:
//             if (btn_r == 1) next_state = run;
//             else if (btn_l == 1) next_state = clear;
//             else if (btn_d == 1) next_state = mode;
//             else next_state = stop;

//             run:
//             if (btn_r == 0) next_state = run;
//             else if (btn_r == 1) next_state = stop;
//             else next_state = stop;

//             clear: next_state = stop;

//             mode: next_state = stop;

//             default: next_state = stop;
//         endcase
//     end

//     always @(posedge clk or posedge rst) begin
//         if (rst) begin
//             state_reg <= stop;
//         end else begin
//             state_reg <= next_state;

//             case (state_reg)
//                 stop:  sw <= 3'b000;
//                 run:   sw <= 3'b001;
//                 clear: sw <= 3'b011;
//                 mode:  sw[2] <= ~sw[2];  // toggle
//             endcase
//         end
//     end


// endmodule







