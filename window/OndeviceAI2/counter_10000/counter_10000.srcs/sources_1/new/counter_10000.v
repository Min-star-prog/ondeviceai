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
    output [3:0] fnd_com,
    output [7:0] fnd_data

);

    wire [13:0] w_tick_counter;

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
        .tick_counter(w_tick_counter)
    );



endmodule






module datapath (
    input clk,
    input rst,
    output [13:0] tick_counter
);

    wire w_tick_10hz;

    tick_counter U_TICK_COUNTER (
        .clk(clk),
        .rst(rst),
        .i_tick(w_tick_10hz),
        .o_tick_counter(tick_counter)
    );




    clk_tick_gen U_CLK_TICK_GEN (
        .clk(clk),
        .rst(rst),
        .o_tick(w_tick_10hz)
    );




endmodule






module tick_counter (
    input clk,
    input rst,
    input i_tick,
    output [13:0] o_tick_counter
);


    reg [$clog2(10_000)-1:0] tick_counter_reg;

    assign o_tick_counter = tick_counter_reg;


    always @(posedge clk, posedge rst) begin
        if (rst) begin
            tick_counter_reg <= 14'd0;

        end else begin
            if (i_tick) begin            // after 10ns 1->0
                tick_counter_reg <= tick_counter_reg + 1;
                if (tick_counter_reg == (10000 - 1)) begin
                    tick_counter_reg <= 14'd0;
                end
            end
        end

    end

endmodule

module clk_tick_gen (
    input clk,
    input rst,
    output reg o_tick
);
    // counter = 100_000_000 / 10 -1 : 100MHz -> 10hz
    reg [$clog2(100_000_000/10)-1:0] counter_reg;  //$clog2 = bit automatic


    always @(posedge clk, posedge rst) begin
        if (rst) begin
            counter_reg <= 24'd0;
            o_tick      <= 1'b0;
        end else begin
            counter_reg <= counter_reg + 1;
            o_tick <= 1'b0;

            if (counter_reg == (10_000_000 - 1)) begin
                counter_reg <= 24'd0;
                o_tick <= 1'b1;
            end
        end
    end



endmodule
