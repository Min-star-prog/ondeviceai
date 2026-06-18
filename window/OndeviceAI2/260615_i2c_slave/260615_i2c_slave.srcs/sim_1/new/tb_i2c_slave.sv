`timescale 1ns / 1ps

module tb_i2c_slave_top;

    logic clk;
    logic rst;

    logic scl;
    tri   sda;

    logic sda_master_drive_low;

    logic [3:0] an;
    logic [6:0] seg;

    logic [7:0] read_data;

    assign sda = sda_master_drive_low ? 1'b0 : 1'bz;

    pullup (sda);

    i2c_slave_top dut (
        .clk (clk),
        .rst (rst),
        .scl (scl),
        .sda (sda),
        .an  (an),
        .seg (seg)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;   // 100MHz


    initial begin
        rst = 1'b1;
        scl = 1'b1;
        sda_master_drive_low = 1'b0;

        #100;
        rst = 1'b0;
        #100;

        // slave read 응답 데이터 강제 설정
        dut.tx_data = 8'hA5;

        // -------------------------
        // WRITE TEST
        // -------------------------
        i2c_start();
        i2c_write_byte({7'h37, 1'b0}); // 8'h6E
        i2c_write_byte(8'd25);
        i2c_write_byte(8'd32);

        i2c_stop();

        #3000;

        if (dut.fnd_value == 8'd25)
            $display("[%0t] WRITE PASS : fnd_value = %0d", $time, dut.fnd_value);
        else
            $display("[%0t] WRITE FAIL : fnd_value = %0d", $time, dut.fnd_value);

        #3000;

        // -------------------------
        // READ TEST
        // -------------------------
        i2c_start();
        i2c_write_byte({7'h37, 1'b1}); // 8'h6F
        i2c_read_byte(read_data, 1'b1); // NACK
        i2c_stop();

        #1000;

        if (read_data == 8'hA5)
            $display("[%0t] READ PASS : read_data = %h", $time, read_data);
        else
            $display("[%0t] READ FAIL : read_data = %h", $time, read_data);

        #5000;
        $finish;
    end


    task i2c_start();
        begin
            sda_master_drive_low = 1'b0;
            scl = 1'b1;
            #1000;

            sda_master_drive_low = 1'b1;
            #1000;

            scl = 1'b0;
            #1000;
        end
    endtask


    task i2c_stop();
        begin
            sda_master_drive_low = 1'b1;
            scl = 1'b0;
            #1000;

            scl = 1'b1;
            #1000;

            sda_master_drive_low = 1'b0;
            #1000;
        end
    endtask


    task i2c_write_bit(input logic bit_data);
        begin
            scl = 1'b0;

            if (bit_data == 1'b0)
                sda_master_drive_low = 1'b1;
            else
                sda_master_drive_low = 1'b0;

            #1000;

            scl = 1'b1;
            #1000;

            scl = 1'b0;
            #1000;
        end
    endtask


    task i2c_write_byte(input logic [7:0] data);
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                i2c_write_bit(data[i]);
            end

            // ACK bit: master release, slave pulls SDA low
            scl = 1'b0;
            sda_master_drive_low = 1'b0;
            #1000;

            scl = 1'b1;
            #500;

            $display("[%0t] ACK = %b", $time, sda);

            #500;
            scl = 1'b0;
            #1000;
        end
    endtask


    task i2c_read_byte(
        output logic [7:0] data,
        input  logic       nack
    );
        integer i;
        begin
            data = 8'd0;

            // master release SDA
            sda_master_drive_low = 1'b0;

            for (i = 7; i >= 0; i = i - 1) begin
                scl = 1'b0;
                #1000;

                scl = 1'b1;
                #500;

                data[i] = sda;

                #500;
                scl = 1'b0;
                #1000;
            end

            // ACK/NACK bit from master
            // ACK  = 0 : drive low
            // NACK = 1 : release
            if (nack)
                sda_master_drive_low = 1'b0;
            else
                sda_master_drive_low = 1'b1;

            #1000;
            scl = 1'b1;
            #1000;

            scl = 1'b0;
            #1000;

            sda_master_drive_low = 1'b0;
        end
    endtask

endmodule