`timescale 1ns / 1ps

module tb_axi_master_slave;

    logic        ACLK;
    logic        ARESETn;

    logic        transfer;
    logic        ready;
    logic [31:0] addr;
    logic [31:0] wdata;
    logic [31:0] rdata;
    logic        write;

    axi_master_slave_top dut (
        .ACLK     (ACLK),
        .ARESETn  (ARESETn),

        .transfer (transfer),
        .ready    (ready),
        .addr     (addr),
        .wdata    (wdata),
        .rdata    (rdata),
        .write    (write)
    );

    // 100 MHz Clock
    initial ACLK = 1'b0;
    always #5 ACLK = ~ACLK;

    task automatic axi_write (input logic [31:0] wr_addr,input logic [31:0] wr_data);
        begin
            @(posedge ACLK);

            addr     <= wr_addr;
            wdata    <= wr_data;
            write    <= 1'b1;
            transfer <= 1'b1;

            // transfer는 한 Clock만 활성화
            @(posedge ACLK);
            transfer <= 1'b0;
            // B Channel 응답까지 대기
            wait (ready == 1'b1);
            $display("[WRITE DONE] addr = 0x%08h, W data = 0x%08h",
                     wr_addr, wr_data);
            @(posedge ACLK);
        end
    endtask

    task automatic axi_read (
        input logic [31:0] rd_addr
    );
        begin
            @(posedge ACLK);

            addr     <= rd_addr;
            write    <= 1'b0;
            transfer <= 1'b1;

            // transfer는 한 Clock만 활성화
            @(posedge ACLK);
            transfer <= 1'b0;

            // R Channel 응답까지 대기
            wait (ready == 1'b1);

            #1;
            $display("[READ DONE] addr = 0x%08h, rdata = 0x%08h",
                     rd_addr, rdata);

            @(posedge ACLK);
        end
    endtask

    initial begin
        ARESETn  = 1'b0;
        transfer = 1'b0;
        addr     = 32'd0;
        wdata    = 32'd0;
        write    = 1'b0;

        repeat (5) @(posedge ACLK);
        ARESETn = 1'b1;

        // slv_reg0에 값 저장 후 읽기
        axi_write(32'h0000_0000, 32'h11111111);
        axi_read (32'h0000_0000);

        // slv_reg1에 값 저장 후 읽기
        axi_write(32'h0000_0004, 32'h22222222);
        axi_read (32'h0000_0004);

        // slv_reg2에 값 저장 후 읽기
        axi_write(32'h0000_0008, 32'h33333333);
        axi_read (32'h0000_0008);

        // slv_reg3에 값 저장 후 읽기
        axi_write(32'h0000_000C, 32'h44444444);
        axi_read (32'h0000_000C);

        #50;
        $finish;
    end

endmodule