`timescale 1ns / 1ps

module tb_uart_loopback;

    parameter BAUD_DELAY = 0; // 2_000;
    parameter BAUD_PERIOD = (100_000_000 / 9600) * 10;

    reg clk;
    reg rst;
    reg rx;  
    reg [7:0] compare_data;

    wire tx;
    integer i;

    uart_fifo_loopback U_UART_FIFO_LOOPBACK(
        .clk(clk),
        .rst(rst),
        .rx(rx),     
        .tx(tx)
    );

    always #5 clk = ~clk;

    task SENDER_UART (input [7:0] send_data); 
        begin
            rx = 1'b0; // start bit
            #(BAUD_PERIOD);

            for (i = 0 ; i < 8 ; i = i + 1) begin
                rx = send_data[i];
                #(BAUD_PERIOD);
            end

            rx = 1'b1; // stop bit 
            #(BAUD_PERIOD);
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        rx  = 1;
        compare_data = 8'h30;   //input 
        @(negedge clk);
        @(negedge clk);

        rst = 0;

        
        SENDER_UART(compare_data);
        SENDER_UART(compare_data);
        SENDER_UART(compare_data);
        SENDER_UART(compare_data);

        SENDER_UART(compare_data);
        SENDER_UART(compare_data);
        SENDER_UART(compare_data);
        SENDER_UART(compare_data);
        

        #(BAUD_PERIOD * 10);
        #1000;
        $stop;
    end

endmodule