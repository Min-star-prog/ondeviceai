`timescale 1ns / 1ps


module tb_spi_master ();

    logic       cpol;  // clock polarity
    logic       cpha;
    logic       clk;
    logic       rst;
    logic       start;
    logic [7:0] clk_div;
    logic [7:0] tx_data;
    logic       busy;
    logic [7:0] rx_data;
    logic       done;
    logic       sclk;
    // logic       mosi;
    // logic       miso;
    logic       ss_n;

    logic loop_wire;
    spi_master dut (.*,.mosi(loop_wire),.miso(loop_wire));

    initial clk = 0;
    always #5 clk = ~clk;

    task spi_set_mode(bit pol, bit pha);
        cpol = pol;    cpha = pha;
        @(posedge clk);

    endtask


    task spi_send_data(logic [7:0] data);
        tx_data = data;
        start   = 1'b1;
        @(posedge clk);
        start = 1'b0;
        @(posedge clk);
        wait (done);
        @(posedge clk);
    endtask


    initial begin
        rst = 1;
        repeat (3) @(posedge clk);
        rst = 0;

        @(posedge clk);
        clk_div = 4;  // sclk = 10Mhz -> (100Mhz / (10Mhz * 2)) - 1 = 4
        @(posedge clk);

        spi_set_mode(0,0);
        spi_send_data(8'haa);
        
        spi_set_mode(1,0);
        spi_send_data(8'haa);
        
        spi_set_mode(0,1);
        spi_send_data(8'haa);
        spi_set_mode(1,1);
        spi_send_data(8'haa);

        #20;
        $finish;



    end



endmodule
