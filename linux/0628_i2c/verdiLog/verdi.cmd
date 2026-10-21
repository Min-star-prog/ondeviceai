verdiSetActWin -dock widgetDock_<Message>
verdiWindowResize -win $_Verdi_1 "8" "31" "2560" "1369"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -dock widgetDock_<Message>
debLoadSimResult \
           /home/pedu24/workspace_mini/linux/0628_i2c/i2c_axi_no_slave_uvm.vcd.fsdb
verdiSetActWin -win $_nWave2
wvSetCursor -win $_nWave2 6061755976.534500
wvSelectGroup -win $_nWave2 {G1}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top"
verdiWindowResize -win $_Verdi_1 "1281" "31" "1278" "1360"
wvSelectGroup -win $_nWave2 {G1}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top/unnamed\$\$_vcs_0"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
wvGetSignalSetScope -win $_nWave2 "/tb_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvSetPosition -win $_nWave2 {("G1" 39)}
wvSetPosition -win $_nWave2 {("G1" 39)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/s00_axi_aclk} -height 16 \
{/tb_top/dut/s00_axi_aresetn} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/scl_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/sda_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/done} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/axi_awaddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_awvalid} -height 16 \
{/tb_top/dut/s00_axi_awready} -height 16 \
{/tb_top/dut/s00_axi_arready} -height 16 \
{/tb_top/dut/s00_axi_wdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_wvalid} -height 16 \
{/tb_top/dut/s00_axi_wready} -height 16 \
{/tb_top/dut/s00_axi_bresp\[1:0\]} -height 16 \
{/tb_top/dut/s00_axi_bvalid} -height 16 \
{/tb_top/dut/s00_axi_bready} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/bit_cnt\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/is_read} -height 16 \
{/tb_top/dut/scl} -height 16 \
{/tb_top/dut/sda} -height 16 \
{/tb_top/dut/cmd_start} -height 16 \
{/tb_top/dut/cmd_write} -height 16 \
{/tb_top/dut/cmd_read} -height 16 \
{/tb_top/dut/cmd_stop} -height 16 \
{/tb_top/dut/tx_data\[7:0\]} -height 16 \
{/tb_top/dut/rx_data\[7:0\]} -height 16 \
{/tb_top/dut/ack_in} -height 16 \
{/tb_top/dut/ack_out} -height 16 \
{/tb_top/dut/busy} -height 16 \
{/tb_top/dut/done} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/done_flag} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/rx_valid_flag} -height 16 \
{/tb_top/dut/s00_axi_araddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_arvalid} -height 16 \
{/tb_top/dut/s00_axi_arready} -height 16 \
{/tb_top/dut/s00_axi_rdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_rvalid} -height 16 \
{/tb_top/dut/s00_axi_rready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 39 )} 
wvSetPosition -win $_nWave2 {("G1" 39)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 5148489798.651341 -snap {("G1" 26)}
wvSelectSignal -win $_nWave2 {( "G1" 26 )} 
wvSelectSignal -win $_nWave2 {( "G1" 12 26 )} 
wvSelectSignal -win $_nWave2 {( "G1" 12 26 )} 
wvSetRadix -win $_nWave2 -format Bin
wvSelectSignal -win $_nWave2 {( "G1" 23 )} 
wvSetCursor -win $_nWave2 73785509495.619385 -snap {("G1" 23)}
wvSetCursor -win $_nWave2 73934349761.986435 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 73899588765.596436 -snap {("G2" 0)}
wvSelectSignal -win $_nWave2 {( "G1" 37 )} 
wvSelectSignal -win $_nWave2 {( "G1" 37 )} 
wvSetRadix -win $_nWave2 -format Bin
wvGetSignalOpen -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 40)}
wvSetPosition -win $_nWave2 {("G1" 40)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/s00_axi_aclk} -height 16 \
{/tb_top/dut/s00_axi_aresetn} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/scl_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/sda_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/done} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/axi_awaddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_awvalid} -height 16 \
{/tb_top/dut/s00_axi_awready} -height 16 \
{/tb_top/dut/s00_axi_arready} -height 16 \
{/tb_top/dut/s00_axi_wdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_wvalid} -height 16 \
{/tb_top/dut/s00_axi_wready} -height 16 \
{/tb_top/dut/s00_axi_bresp\[1:0\]} -height 16 \
{/tb_top/dut/s00_axi_bvalid} -height 16 \
{/tb_top/dut/s00_axi_bready} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/bit_cnt\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/is_read} -height 16 \
{/tb_top/dut/scl} -height 16 \
{/tb_top/dut/sda} -height 16 \
{/tb_top/dut/cmd_start} -height 16 \
{/tb_top/dut/cmd_write} -height 16 \
{/tb_top/dut/cmd_read} -height 16 \
{/tb_top/dut/cmd_stop} -height 16 \
{/tb_top/dut/tx_data\[7:0\]} -height 16 \
{/tb_top/dut/rx_data\[7:0\]} -height 16 \
{/tb_top/dut/ack_in} -height 16 \
{/tb_top/dut/ack_out} -height 16 \
{/tb_top/dut/busy} -height 16 \
{/tb_top/dut/done} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/done_flag} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/rx_valid_flag} -height 16 \
{/tb_top/dut/s00_axi_araddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_arvalid} -height 16 \
{/tb_top/dut/s00_axi_arready} -height 16 \
{/tb_top/dut/s00_axi_rdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_rvalid} -height 16 \
{/tb_top/dut/s00_axi_rready} -height 16 \
{/tb_top/dut/intr} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 40 )} 
wvSetPosition -win $_nWave2 {("G1" 40)}
wvSetCursor -win $_nWave2 36931609454.674744 -snap {("G1" 40)}
wvSetCursor -win $_nWave2 88833657.441105 -snap {("G1" 40)}
wvSearchNext -win $_nWave2
wvSearchPrev -win $_nWave2
wvSetCursor -win $_nWave2 5266817.634848 -snap {("G1" 40)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomAll -win $_nWave2
wvSetCursor -win $_nWave2 15280793564.572607 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 5280862481.874356 -snap {("G1" 24)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 53910137140.584068 -snap {("G1" 24)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 54009296518.664528 -snap {("G1" 24)}
wvSearchPrev -win $_nWave2
wvSearchNext -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 24 )} 
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSetCursor -win $_nWave2 22120167161.257397 -snap {("G1" 23)}
wvSetCursor -win $_nWave2 21900321411.029163 -snap {("G1" 38)}
wvSetCursor -win $_nWave2 21900235688.085888 -snap {("G1" 24)}
wvSetCursor -win $_nWave2 22010206118.526829 -snap {("G1" 24)}
wvSetCursor -win $_nWave2 22010641608.054081 -snap {("G1" 27)}
wvSearchNext -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 27 )} 
wvSearchNext -win $_nWave2
wvSetCursor -win $_nWave2 22118664803.024532 -snap {("G1" 24)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 22120204718.090759 -snap {("G1" 24)}
wvSetCursor -win $_nWave2 22120208961.800819 -snap {("G1" 17)}
wvSetCursor -win $_nWave2 22120219783.261482 -snap {("G1" 35)}
wvSetCursor -win $_nWave2 22120204293.719749 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 22120219995.446983 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 22120303596.535229 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 22120219571.075977 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 22120235060.617710 -snap {("G1" 36)}
wvSetCursor -win $_nWave2 22120241001.811798 -snap {("G1" 35)}
wvSetCursor -win $_nWave2 22120245882.078369 -snap {("G1" 36)}
wvSetCursor -win $_nWave2 22120244821.150856 -snap {("G1" 38)}
wvSetCursor -win $_nWave2 22120250125.788433 -snap {("G1" 39)}
