`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/15 12:54:25
// Design Name: 
// Module Name: tb_spi_slave
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


// module tb_spi_slave ();

//     logic clk;
//     logic rst;
//     logic sclk;
//     logic mosi;
//     logic miso;
//     logic ss_n;
//     logic [3:0] an;
//     logic [6:0] seg;

//     spi_slave_stopwatch dut (.*);

//     task spi_write(input [7:0] data);

//         integer i;
//         begin
//             ss_n = 0;
//             #20;
//             for (i = 7; i >= 0; i = i - 1) begin
//                 mosi <= data[i];
//                 #20;
//                 sclk = 1;
//                 #20;
//                 sclk = 0;

//             end
//             #20;
//             ss_n = 1;

//             #100;
//         end

//     endtask

//     initial begin

//         clk  = 0;
//         sclk = 0;
//         rst  = 1;
//         ss_n = 1;
//         mosi = 0;



//         repeat (5) @(posedge clk);

//         rst  = 0;
//         repeat (5) @(posedge clk);
//     spi_write(8'haa);
//     spi_write(8'h55);
//     spi_write(8'hff);
//     spi_write(8'haa);
//     #5_000_000;
//     $finish;
//     end


//     always #5 clk = ~clk;










// endmodule




module tb_spi_slave ();

    // board clock
    logic clk;
    logic rst;

    // SPI signals
    logic sclk;
    logic mosi;
    logic miso;
    logic ss_n;

    // FND signals
    logic [3:0] an;
    logic [6:0] seg;

    spi_slave_stopwatch dut (
        .clk  (clk),
        .rst  (rst),
        .sclk (sclk),
        .mosi (mosi),
        .miso (miso),
        .ss_n (ss_n),
        .an   (an),
        .seg  (seg)
    );

    // 100MHz board clock
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // CPOL=0, CPHA=0
    // mosi changes before rising edge
    // slave samples at rising edge
    task spi_send_byte(input logic [7:0] data);
        integer i;
        begin
            ss_n = 1'b0;

            // 약간의 setup time
            #20;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = data[i];

                #20;
                sclk = 1'b1;   // rising edge: slave samples MOSI

                #20;
                sclk = 1'b0;   // falling edge: slave changes MISO
            end

            #20;
            ss_n = 1'b1;

            #200;

            $display("SPI SEND = %0d, DUT rx_data = %0d, an=%b, seg=%b",
                     data, dut.rx_data, an, seg);
        end
    endtask

    initial begin
        sclk = 1'b0;
        mosi = 1'b0;
        ss_n = 1'b1;
        rst  = 1'b1;

        repeat (10) @(posedge clk);
        rst = 1'b0;

        repeat (10) @(posedge clk);

        spi_send_byte(8'd0);
        spi_send_byte(8'd7);
        spi_send_byte(8'd25);
        spi_send_byte(8'd59);
        spi_send_byte(8'd99);

        #1000;
        $finish;
    end

endmodule