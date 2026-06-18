`timescale 1ns / 1ps


// module tb_spi_master ();

//     logic       cpol;  // clock polarity
//     logic       cpha;
//     logic       clk;
//     logic       rst;
//     logic       start;
//     logic [7:0] clk_div;
//     logic [7:0] tx_data;
//     logic       busy;
//     logic [7:0] rx_data;
//     logic       done;
//     logic       sclk;
//     // logic       mosi;
//     // logic       miso;
//     logic       ss_n;

//     logic loop_wire;
//     spi_master dut (.*,.mosi(loop_wire),.miso(loop_wire));

//     initial clk = 0;
//     always #5 clk = ~clk;

//     task spi_set_mode(bit [1:0] mode);
//     {cpol, cpha} = mode;
//         @(posedge clk);

//     endtask


//     task spi_send_data(logic [7:0] data);
//         tx_data = data;
//         start   = 1'b1;
//         @(posedge clk);
//         start = 1'b0;
//         @(posedge clk);
//         wait (done);
//         @(posedge clk);
//     endtask


//     initial begin
//         rst = 1;
//         repeat (3) @(posedge clk);
//         rst = 0;

//         @(posedge clk);
//         clk_div = 4;  // sclk = 10Mhz -> (100Mhz / (10Mhz * 2)) - 1 = 4
//         @(posedge clk);

//         spi_set_mode(0);
//         spi_send_data(8'haa);
        
//         spi_set_mode(1);
//         spi_send_data(8'haa);
        
//         spi_set_mode(2);
//         spi_send_data(8'haa);
        
//         spi_set_mode(3);
//         spi_send_data(8'haa);
        
//         #20;
//         $finish;



//     end



// endmodule


module tb_spi_master_stopwatch ();

    logic clk;
    logic rst;

    logic btnR;
    logic btnL;
    logic btnD;

    logic sclk;
    logic mosi;
    logic miso;
    logic ss_n;

    spi_master_stopwatch dut (
        .clk (clk),
        .rst (rst),
        .btnR(btnR),
        .btnL(btnL),
        .btnD(btnD),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .ss_n(ss_n)
    );
    defparam dut.U_STOPWATCH_DATAPATH.U_TICK_GEN_1HZ.F_COUNT = 1000;
    
    assign miso = mosi;   // master ?ã®?èÖ ?Öå?ä§?ä∏?ö© loopback

    initial clk = 1'b0;
    always #5 clk = ~clk; // 100MHz

    task press_btnR();
        begin
            btnR = 1'b1;
            #100_000;     // debounce ?ÜµÍ≥ºÏö©
            btnR = 1'b0;
            #100_000;
        end
    endtask

    task press_btnL();
        begin
            btnL = 1'b1;
            #100_000;
            btnL = 1'b0;
            #100_000;
        end
    endtask

    task press_btnD();
        begin
            btnD = 1'b1;
            #100_000;
            btnD = 1'b0;
            #100_000;
        end
    endtask

    initial begin
        rst  = 1'b1;
        btnR = 1'b0;
        btnL = 1'b0;
        btnD = 1'b0;

        #1000;
        rst = 1'b0;

        #1000;

        $display("=== Run Start ===");
        press_btnR();

        wait(dut.w_run_stop == 1'b1);
        $display("[%0t] stopwatch run enabled", $time);

        // 1Ï¥? ?ù¥?ÉÅ Í∏∞Îã§Î¶¨Î©¥ count_99Í∞? 1 Ï¶ùÍ??ï®
        wait(dut.count_99 == 8'd1);
        $display("[%0t] count_99 = %0d", $time, dut.count_99);

        // SPI ?†Ñ?Ü° ?ïú Î≤? ?ôï?ù∏
        wait(dut.spi_done == 1'b1);
        $display("[%0t] SPI DONE, tx count = %0d", $time, dut.count_99);

        wait(dut.count_99 == 8'd2);
        $display("[%0t] count_99 = %0d", $time, dut.count_99);

        wait(dut.spi_done == 1'b1);
        $display("[%0t] SPI DONE, tx count = %0d", $time, dut.count_99);

        $display("=== Clear Test ===");
        press_btnL();

        #1000;
        $display("[%0t] count_99 after clear = %0d", $time, dut.count_99);

        $display("=== Mode Down Test ===");
        press_btnD();
        press_btnR();

        wait(dut.count_99 == 8'd99);
        $display("[%0t] down count result = %0d", $time, dut.count_99);

        #10000;
        $finish;
    end

endmodule
