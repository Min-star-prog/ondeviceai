`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/30 10:31:26
// Design Name: 
// Module Name: tb_sr04
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


// module tb_sr04(

//     );

// reg clk, rst,sr04_start,tick_us,echo;
// wire trig;
// wire [8:0] distance;




// sr04_controller dut(

//     .clk(clk),
//     .rst(rst),
//     .sr04_start(sr04_start),
//     .tick_us(tick_us),
//     .echo(echo),
//     .trig(trig),
//     .distance(distance)
// );







// always #5 clk = ~clk;


//     parameter F_COUNT = 100_000_000 / 1_000_000;
//     reg [$clog2(F_COUNT)-1:0] counter_reg;


//     always @(posedge clk, posedge rst) begin

//         if (rst) begin
//             counter_reg <= 0;
//             tick_us <= 1'b0;


//         end else begin
//             counter_reg <= counter_reg + 1;

//             if (counter_reg == F_COUNT - 1) begin
//                 counter_reg <= 0;
//                 tick_us <= 1'b1;
//             end else begin
//                 tick_us <= 1'b0;
//             end
//         end

//     end



// initial begin
//     clk = 0;
//     rst = 1;
//     sr04_start = 0;
//     echo = 0;

//     @(negedge clk);
//     @(negedge clk);

//     rst = 0;

//     @(negedge clk);
//     @(negedge clk);
//     sr04_start = 1;
//     #10;
//     sr04_start = 0;

//     #12_000;
//     echo = 1;
//     #1_000_000_000;
//     echo = 0;


//     #1_000_000;

// end



// endmodule





module tb_sr04_multi_input();

    parameter US_DELAY = 1000, MS_DELAY = 1_000_000;


    reg clk, rst, sr04_start, tick_us, echo;
    wire trig;
    wire [8:0] distance;
    wire w_tick_us;

    sr04_controller dut (

        .clk(clk),
        .rst(rst),
        .sr04_start(sr04_start),
        .tick_us(w_tick_us),
        .echo(echo),
        .trig(trig),
        .distance(distance)
    );


    tick_gen_us dut2 (
        .clk(clk),
        .rst(rst),
        .tick_us(w_tick_us)
    );

always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        sr04_start = 0;
        echo = 0;

        #20;
        rst = 0;

        // start sr04
        @(posedge clk);
        sr04_start = 1;
        @(posedge clk);
        sr04_start = 0;
        //echo response

        #(US_DELAY * 20);
        // @(negedge trig);
        echo = 1;
        #(50*MS_DELAY);
        echo = 0;


        #(US_DELAY * 20);
        sr04_start = 1;
        @(posedge clk);
        sr04_start = 0;

        #(US_DELAY * 20);
        // @(negedge trig);
        echo = 1;
        #(20*MS_DELAY);
        echo = 0;


        #(20*MS_DELAY);



        #(US_DELAY * 20);
        sr04_start = 1;
        @(posedge clk);
        sr04_start = 0;

        #(MS_DELAY * 32); //timeout
        // @(negedge trig);
        echo = 1;
        #(15*MS_DELAY);
        echo = 0;




        #(20*MS_DELAY);


        #(US_DELAY * 20);
        sr04_start = 1;
        @(posedge clk);
        sr04_start = 0;

        #(US_DELAY * 20);
        // @(negedge trig);
        echo = 1;
        #(5*MS_DELAY);
        echo = 0;

        $stop;

    end



endmodule
