simSetSimulator "-vcssv" -exec "./simv" -args
debImport "-dbdir" "./simv.daidir"
wvCreateWindow
wvOpenFile -win $_nWave2 \
           {/home/pedu24/workspace_mini/linux/0628_i2c/i2c_axi_no_slave_uvm.fsdb}
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "1265" "362" "1250" "800"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcDeselectAll -win $_nTrace1
verdiSetActWin -win $_nWave2
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "tb_top.dut" -win $_nTrace1
srcHBSelect "tb_top.dut" -win $_nTrace1
srcSetScope "tb_top.dut" -delim "." -win $_nTrace1
srcHBSelect "tb_top.dut" -win $_nTrace1
srcHBSelect "tb_top.dut.i2c_v1_0_S00_AXI_inst" -win $_nTrace1
srcSetScope "tb_top.dut.i2c_v1_0_S00_AXI_inst" -delim "." -win $_nTrace1
srcHBSelect "tb_top.dut.i2c_v1_0_S00_AXI_inst" -win $_nTrace1
verdiSetActWin -win $_nWave2
verdiDockWidgetSetCurTab -dock widgetDock_<Message>
verdiSetActWin -dock widgetDock_<Message>
debLoadSimResult \
           /home/pedu24/workspace_mini/linux/0628_i2c/i2c_axi_no_slave_uvm.vcd.fsdb
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvSetPosition -win $_nWave2 {("G1" 22)}
wvSetPosition -win $_nWave2 {("G1" 22)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/s00_axi_aclk} -height 16 \
{/tb_top/dut/s00_axi_aresetn} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/scl_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/sda_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/done} -height 16 \
{/tb_top/dut/s00_axi_awaddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_awvalid} -height 16 \
{/tb_top/dut/s00_axi_awready} -height 16 \
{/tb_top/dut/s00_axi_wdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_wvalid} -height 16 \
{/tb_top/dut/s00_axi_wready} -height 16 \
{/tb_top/dut/s00_axi_bresp\[1:0\]} -height 16 \
{/tb_top/dut/s00_axi_bvalid} -height 16 \
{/tb_top/dut/s00_axi_bready} -height 16 \
{/tb_top/dut/s00_axi_araddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_arvalid} -height 16 \
{/tb_top/dut/s00_axi_arready} -height 16 \
{/tb_top/dut/s00_axi_rdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_rvalid} -height 16 \
{/tb_top/dut/s00_axi_rready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 22 )} 
wvSetPosition -win $_nWave2 {("G1" 22)}
wvGetSignalClose -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 17 )} 
wvSelectSignal -win $_nWave2 {( "G1" 17 18 19 20 21 22 )} 
wvSetPosition -win $_nWave2 {("G1" 22)}
wvSetPosition -win $_nWave2 {("G1" 22)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvAddGroup -win $_nWave2 {G3}
wvZoom -win $_nWave2 17248337557.331066 20123060483.552914
wvSelectGroup -win $_nWave2 {G3}
wvSelectGroup -win $_nWave2 {G3}
wvRenameGroup -win $_nWave2 {G3} {read}
wvSelectSignal -win $_nWave2 {( "G1" 20 )} 
wvSelectSignal -win $_nWave2 {( "G1" 17 )} 
wvSelectSignal -win $_nWave2 {( "G1" 22 )} 
wvSelectGroup -win $_nWave2 {read}
wvSelectGroup -win $_nWave2 {read}
wvSelectSignal -win $_nWave2 {( "G1" 17 )} 
wvSelectSignal -win $_nWave2 {( "G1" 17 18 19 20 21 22 )} 
wvSetPosition -win $_nWave2 {("G1" 21)}
wvSetPosition -win $_nWave2 {("G1" 22)}
wvSetPosition -win $_nWave2 {("read" 0)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("read" 6)}
wvSetPosition -win $_nWave2 {("read" 0)}
wvCollapseGroup -win $_nWave2 "read"
wvSelectGroup -win $_nWave2 {read}
wvExpandGroup -win $_nWave2 "read"
wvSelectGroup -win $_nWave2 {read}
verdiWindowResize -win $_Verdi_1 "1265" "362" "1250" "800"
wvScrollDown -win $_nWave2 4
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalClose -win $_nWave2
wvScrollDown -win $_nWave2 0
wvSelectGroup -win $_nWave2 {G2}
wvScrollUp -win $_nWave2 2
wvCollapseGroup -win $_nWave2 "read"
wvSelectGroup -win $_nWave2 {G2}
wvScrollDown -win $_nWave2 0
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
srcDeselectAll -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
verdiWindowResize -win $_Verdi_1 "1265" "362" "1250" "800"
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
verdiSetActWin -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
wvSetPosition -win $_nWave2 {("read" 11)}
wvSetPosition -win $_nWave2 {("read" 11)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/s00_axi_aclk} -height 16 \
{/tb_top/dut/s00_axi_aresetn} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/scl_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/sda_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/done} -height 16 \
{/tb_top/dut/s00_axi_awaddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_awvalid} -height 16 \
{/tb_top/dut/s00_axi_awready} -height 16 \
{/tb_top/dut/s00_axi_wdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_wvalid} -height 16 \
{/tb_top/dut/s00_axi_wready} -height 16 \
{/tb_top/dut/s00_axi_bresp\[1:0\]} -height 16 \
{/tb_top/dut/s00_axi_bvalid} -height 16 \
{/tb_top/dut/s00_axi_bready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"read" \
{/tb_top/dut/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master/tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/rx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/ack_in} -height 16 \
{/tb_top/dut/u_i2c_master/ack_out} -height 16 \
{/tb_top/dut/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/done} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/intr} -height 16 \
{/tb_top/dut/s00_axi_araddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_arvalid} -height 16 \
{/tb_top/dut/s00_axi_arready} -height 16 \
{/tb_top/dut/s00_axi_rdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_rvalid} -height 16 \
{/tb_top/dut/s00_axi_rready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "read" 11 )} 
wvSetPosition -win $_nWave2 {("read" 11)}
wvSetPosition -win $_nWave2 {("read" 13)}
wvSetPosition -win $_nWave2 {("read" 13)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/s00_axi_aclk} -height 16 \
{/tb_top/dut/s00_axi_aresetn} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/scl_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/sda_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/done} -height 16 \
{/tb_top/dut/s00_axi_awaddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_awvalid} -height 16 \
{/tb_top/dut/s00_axi_awready} -height 16 \
{/tb_top/dut/s00_axi_wdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_wvalid} -height 16 \
{/tb_top/dut/s00_axi_wready} -height 16 \
{/tb_top/dut/s00_axi_bresp\[1:0\]} -height 16 \
{/tb_top/dut/s00_axi_bvalid} -height 16 \
{/tb_top/dut/s00_axi_bready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"read" \
{/tb_top/dut/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master/tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/rx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/ack_in} -height 16 \
{/tb_top/dut/u_i2c_master/ack_out} -height 16 \
{/tb_top/dut/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/done} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/intr} -height 16 \
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
wvSelectSignal -win $_nWave2 {( "read" 13 )} 
wvSetPosition -win $_nWave2 {("read" 13)}
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
wvSetPosition -win $_nWave2 {("read" 14)}
wvSetPosition -win $_nWave2 {("read" 14)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/s00_axi_aclk} -height 16 \
{/tb_top/dut/s00_axi_aresetn} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/scl_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/sda_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/done} -height 16 \
{/tb_top/dut/s00_axi_awaddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_awvalid} -height 16 \
{/tb_top/dut/s00_axi_awready} -height 16 \
{/tb_top/dut/s00_axi_wdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_wvalid} -height 16 \
{/tb_top/dut/s00_axi_wready} -height 16 \
{/tb_top/dut/s00_axi_bresp\[1:0\]} -height 16 \
{/tb_top/dut/s00_axi_bvalid} -height 16 \
{/tb_top/dut/s00_axi_bready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"read" \
{/tb_top/dut/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master/tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/rx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/ack_in} -height 16 \
{/tb_top/dut/u_i2c_master/ack_out} -height 16 \
{/tb_top/dut/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/done} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/intr} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/done_flag} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/rx_valid_flag} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/done} -height 16 \
{/tb_top/dut/s00_axi_araddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_arvalid} -height 16 \
{/tb_top/dut/s00_axi_arready} -height 16 \
{/tb_top/dut/s00_axi_rdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_rvalid} -height 16 \
{/tb_top/dut/s00_axi_rready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "read" 14 )} 
wvSetPosition -win $_nWave2 {("read" 14)}
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master/u_i2c_master"
wvSetPosition -win $_nWave2 {("read" 16)}
wvSetPosition -win $_nWave2 {("read" 16)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/s00_axi_aclk} -height 16 \
{/tb_top/dut/s00_axi_aresetn} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/scl_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/sda_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/done} -height 16 \
{/tb_top/dut/s00_axi_awaddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_awvalid} -height 16 \
{/tb_top/dut/s00_axi_awready} -height 16 \
{/tb_top/dut/s00_axi_wdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_wvalid} -height 16 \
{/tb_top/dut/s00_axi_wready} -height 16 \
{/tb_top/dut/s00_axi_bresp\[1:0\]} -height 16 \
{/tb_top/dut/s00_axi_bvalid} -height 16 \
{/tb_top/dut/s00_axi_bready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"read" \
{/tb_top/dut/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master/tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/rx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/ack_in} -height 16 \
{/tb_top/dut/u_i2c_master/ack_out} -height 16 \
{/tb_top/dut/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/done} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/intr} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/done_flag} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/rx_valid_flag} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/done} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/bit_cnt\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/is_read} -height 16 \
{/tb_top/dut/s00_axi_araddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_arvalid} -height 16 \
{/tb_top/dut/s00_axi_arready} -height 16 \
{/tb_top/dut/s00_axi_rdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_rvalid} -height 16 \
{/tb_top/dut/s00_axi_rready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "read" 16 )} 
wvSetPosition -win $_nWave2 {("read" 16)}
wvSetPosition -win $_nWave2 {("read" 16)}
wvSetPosition -win $_nWave2 {("read" 16)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/s00_axi_aclk} -height 16 \
{/tb_top/dut/s00_axi_aresetn} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/scl_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/sda_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/done} -height 16 \
{/tb_top/dut/s00_axi_awaddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_awvalid} -height 16 \
{/tb_top/dut/s00_axi_awready} -height 16 \
{/tb_top/dut/s00_axi_wdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_wvalid} -height 16 \
{/tb_top/dut/s00_axi_wready} -height 16 \
{/tb_top/dut/s00_axi_bresp\[1:0\]} -height 16 \
{/tb_top/dut/s00_axi_bvalid} -height 16 \
{/tb_top/dut/s00_axi_bready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"read" \
{/tb_top/dut/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master/tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/rx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/ack_in} -height 16 \
{/tb_top/dut/u_i2c_master/ack_out} -height 16 \
{/tb_top/dut/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/done} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/intr} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/done_flag} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/rx_valid_flag} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/done} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/bit_cnt\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/is_read} -height 16 \
{/tb_top/dut/s00_axi_araddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_arvalid} -height 16 \
{/tb_top/dut/s00_axi_arready} -height 16 \
{/tb_top/dut/s00_axi_rdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_rvalid} -height 16 \
{/tb_top/dut/s00_axi_rready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "read" 16 )} 
wvSetPosition -win $_nWave2 {("read" 16)}
wvSetPosition -win $_nWave2 {("read" 16)}
wvSetPosition -win $_nWave2 {("read" 16)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/s00_axi_aclk} -height 16 \
{/tb_top/dut/s00_axi_aresetn} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/scl_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/sda_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/done} -height 16 \
{/tb_top/dut/s00_axi_awaddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_awvalid} -height 16 \
{/tb_top/dut/s00_axi_awready} -height 16 \
{/tb_top/dut/s00_axi_wdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_wvalid} -height 16 \
{/tb_top/dut/s00_axi_wready} -height 16 \
{/tb_top/dut/s00_axi_bresp\[1:0\]} -height 16 \
{/tb_top/dut/s00_axi_bvalid} -height 16 \
{/tb_top/dut/s00_axi_bready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"read" \
{/tb_top/dut/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master/tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/rx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/ack_in} -height 16 \
{/tb_top/dut/u_i2c_master/ack_out} -height 16 \
{/tb_top/dut/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/done} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/intr} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/done_flag} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/rx_valid_flag} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/done} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/bit_cnt\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/is_read} -height 16 \
{/tb_top/dut/s00_axi_araddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_arvalid} -height 16 \
{/tb_top/dut/s00_axi_arready} -height 16 \
{/tb_top/dut/s00_axi_rdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_rvalid} -height 16 \
{/tb_top/dut/s00_axi_rready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "read" 16 )} 
wvSetPosition -win $_nWave2 {("read" 16)}
wvGetSignalClose -win $_nWave2
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 18
wvScrollDown -win $_nWave2 18
wvSelectSignal -win $_nWave2 {( "read" 15 16 )} 
wvScrollUp -win $_nWave2 11
wvScrollDown -win $_nWave2 5
wvSetPosition -win $_nWave2 {("read" 13)}
wvSetPosition -win $_nWave2 {("read" 10)}
wvSetPosition -win $_nWave2 {("read" 4)}
wvSetPosition -win $_nWave2 {("read" 3)}
wvSetPosition -win $_nWave2 {("read" 2)}
wvSetPosition -win $_nWave2 {("read" 1)}
wvSetPosition -win $_nWave2 {("read" 0)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("read" 0)}
wvSetPosition -win $_nWave2 {("read" 2)}
wvScrollUp -win $_nWave2 12
wvSetCursor -win $_nWave2 52793583066.979202 -snap {("G1" 11)}
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 52728561963.759659 -snap {("G1" 11)}
wvSetCursor -win $_nWave2 52643484028.685356 -snap {("G1" 11)}
wvSelectSignal -win $_nWave2 {( "G1" 11 )} 
wvSelectSignal -win $_nWave2 {( "G1" 11 )} 
wvSetRadix -win $_nWave2 -format UDec
wvSelectSignal -win $_nWave2 {( "G1" 11 )} 
wvSetRadix -win $_nWave2 -format Hex
wvSelectSignal -win $_nWave2 {( "G1" 11 )} 
wvSetRadix -win $_nWave2 -format Bin
wvSetCursor -win $_nWave2 19354014053.344692 -snap {("G1" 11)}
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 15942874372.946121 -snap {("read" 3)}
wvSetCursor -win $_nWave2 22891068602.790623 -snap {("read" 5)}
wvSetCursor -win $_nWave2 22951835988.980297 -snap {("read" 4)}
wvSetCursor -win $_nWave2 21789597206.056137 -snap {("read" 4)}
wvSetCursor -win $_nWave2 8227540365.649695 -snap {("read" 5)}
wvSelectSignal -win $_nWave2 {( "read" 5 )} 
wvSearchNext -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvSetCursor -win $_nWave2 22114623753.157291 -snap {("read" 3)}
wvSetCursor -win $_nWave2 22118269796.328671 -snap {("read" 5)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchPrev -win $_nWave2
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectSignal -win $_nWave2 {( "read" 20 )} 
wvScrollUp -win $_nWave2 8
wvScrollUp -win $_nWave2 10
wvSelectSignal -win $_nWave2 {( "G1" 11 )} 
wvScrollDown -win $_nWave2 18
wvSelectSignal -win $_nWave2 {( "read" 20 )} 
wvSelectSignal -win $_nWave2 {( "read" 20 )} 
wvSetRadix -win $_nWave2 -format Hex
wvSelectSignal -win $_nWave2 {( "read" 20 )} 
wvSetRadix -win $_nWave2 -format Bin
wvSelectSignal -win $_nWave2 {( "read" 13 )} 
wvSelectSignal -win $_nWave2 {( "read" 20 )} 
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 20517395512.407211 -snap {("read" 20)}
wvSetCursor -win $_nWave2 20441132442.739265 -snap {("read" 7)}
wvSelectSignal -win $_nWave2 {( "read" 7 )} 
wvSelectSignal -win $_nWave2 {( "read" 7 )} 
wvSelectSignal -win $_nWave2 {( "read" 7 )} 
wvSetRadix -win $_nWave2 -format Bin
wvSelectSignal -win $_nWave2 {( "read" 8 )} 
wvSelectSignal -win $_nWave2 {( "read" 8 )} 
wvSetRadix -win $_nWave2 -format Bin
wvSetCursor -win $_nWave2 102239691575.831543 -snap {("read" 8)}
wvSetCursor -win $_nWave2 22126986031.304508 -snap {("read" 8)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSetCursor -win $_nWave2 31767618257.409744 -snap {("read" 7)}
wvSetCursor -win $_nWave2 21993381786.721786 -snap {("read" 7)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 15
wvScrollUp -win $_nWave2 9
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/i2c_v1_0_S00_AXI_inst"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvSetPosition -win $_nWave2 {("read" 4)}
wvSetPosition -win $_nWave2 {("read" 4)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/s00_axi_aclk} -height 16 \
{/tb_top/dut/s00_axi_aresetn} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/scl_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/sda_r} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/done} -height 16 \
{/tb_top/dut/s00_axi_awaddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_awvalid} -height 16 \
{/tb_top/dut/s00_axi_awready} -height 16 \
{/tb_top/dut/s00_axi_wdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_wvalid} -height 16 \
{/tb_top/dut/s00_axi_wready} -height 16 \
{/tb_top/dut/s00_axi_bresp\[1:0\]} -height 16 \
{/tb_top/dut/s00_axi_bvalid} -height 16 \
{/tb_top/dut/s00_axi_bready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"read" \
{/tb_top/dut/u_i2c_master/u_i2c_master/bit_cnt\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/u_i2c_master/is_read} -height 16 \
{/tb_top/dut/scl} -height 16 \
{/tb_top/dut/sda} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master/tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/rx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master/ack_in} -height 16 \
{/tb_top/dut/u_i2c_master/ack_out} -height 16 \
{/tb_top/dut/u_i2c_master/busy} -height 16 \
{/tb_top/dut/u_i2c_master/done} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/intr} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/done_flag} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/rx_valid_flag} -height 16 \
{/tb_top/dut/i2c_v1_0_S00_AXI_inst/done} -height 16 \
{/tb_top/dut/s00_axi_araddr\[3:0\]} -height 16 \
{/tb_top/dut/s00_axi_arvalid} -height 16 \
{/tb_top/dut/s00_axi_arready} -height 16 \
{/tb_top/dut/s00_axi_rdata\[31:0\]} -height 16 \
{/tb_top/dut/s00_axi_rvalid} -height 16 \
{/tb_top/dut/s00_axi_rready} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "read" 4 )} 
wvSetPosition -win $_nWave2 {("read" 4)}
wvSelectSignal -win $_nWave2 {( "read" 20 )} 
wvScrollUp -win $_nWave2 11
wvScrollDown -win $_nWave2 5
wvSelectSignal -win $_nWave2 {( "read" 3 )} 
wvSelectSignal -win $_nWave2 {( "read" 4 )} 
wvSetCursor -win $_nWave2 30072546888.365494 -snap {("read" 6)}
wvSetCursor -win $_nWave2 21679912073.989204 -snap {("read" 6)}
wvSelectSignal -win $_nWave2 {( "read" 6 )} 
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvSetCursor -win $_nWave2 67857537230.478333 -snap {("read" 7)}
wvSetCursor -win $_nWave2 67955372722.243584 -snap {("read" 7)}
wvScrollUp -win $_nWave2 6
wvScrollUp -win $_nWave2 3
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetPosition -win $_nWave2 {("read" 0)}
wvSetCursor -win $_nWave2 67900985911.603897 -snap {("G1" 13)}
srcDeselectAll -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 67587715940.268784 -snap {("read" 7)}
verdiSetActWin -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSearchPrev -win $_nWave2
wvSetCursor -win $_nWave2 67580209426.382172 -snap {("G1" 15)}
wvZoomIn -win $_nWave2
wvSearchPrev -win $_nWave2
wvSetCursor -win $_nWave2 67580205891.484108 -snap {("read" 7)}
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "read" 19 )} 
wvSelectSignal -win $_nWave2 {( "read" 6 )} 
wvSearchNext -win $_nWave2
wvSetCursor -win $_nWave2 67690533341.558189 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 67690230519.288048 -snap {("G1" 8)}
wvSetCursor -win $_nWave2 67690297682.203995 -snap {("G1" 8)}
wvSetCursor -win $_nWave2 67690305341.133003 -snap {("G1" 9)}
wvSetCursor -win $_nWave2 67690366023.416710 -snap {("G1" 9)}
wvSelectSignal -win $_nWave2 {( "read" 19 )} 
wvSelectSignal -win $_nWave2 {( "G1" 8 )} {( "read" 19 )} 
wvSelectSignal -win $_nWave2 {( "G1" 8 )} {( "read" 19 )} 
wvSetRadix -win $_nWave2 -format Bin
wvSelectGroup -win $_nWave2 {G2}
wvSetCursor -win $_nWave2 67690610519.996689 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 67690193992.088150 -snap {("read" 7)}
wvSelectSignal -win $_nWave2 {( "read" 7 )} 
wvSetCursor -win $_nWave2 67790210965.921165 -snap {("read" 7)}
wvSetCursor -win $_nWave2 67790563276.655693 -snap {("G2" 0)}
wvSelectSignal -win $_nWave2 {( "read" 6 )} 
wvSetCursor -win $_nWave2 67790265756.721016 -snap {("read" 6)}
wvSetCursor -win $_nWave2 67690071669.368858 -snap {("read" 7)}
wvSelectSignal -win $_nWave2 {( "read" 19 )} 
wvSetCursor -win $_nWave2 67790507778.884956 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 67790111871.169899 -snap {("read" 5)}
wvSetCursor -win $_nWave2 67780713965.288361 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 67780127173.496407 -snap {("read" 8)}
wvSetCursor -win $_nWave2 67880346997.106262 -snap {("read" 8)}
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 67880128878.857712 -snap {("read" 7)}
wvSetCursor -win $_nWave2 67790149561.132866 -snap {("read" 6)}
wvSetCursor -win $_nWave2 67690228971.989639 -snap {("read" 7)}
wvSetCursor -win $_nWave2 67790255741.199951 -snap {("read" 6)}
wvSetCursor -win $_nWave2 67690226026.244789 -snap {("read" 7)}
wvSetCursor -win $_nWave2 67790256919.491882 -snap {("read" 6)}
wvSetCursor -win $_nWave2 67690227793.691879 -snap {("read" 7)}
wvSetCursor -win $_nWave2 67790248612.504959 -snap {("read" 6)}
wvSetCursor -win $_nWave2 67690597189.732658 -snap {("G2" 0)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 67650908030.449387 -snap {("G2" 0)}
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 67650003098.529266 -snap {("G2" 0)}
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 67450013144.183411 -snap {("read" 8)}
srcDeselectAll -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
debExit
