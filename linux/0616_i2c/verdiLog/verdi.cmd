simSetSimulator "-vcssv" -exec "./simv" -args \
           "+UVM_TESTNAME=i2c_test +UVM_VERBOSITY=UVM_MEDIUM +ntb_random_seed=2 -cm line+cond+fsm+tgl+branch+assert -cm_dir coverage.vdb -cm_name sim1"
debImport "-dbdir" "./simv.daidir"
debLoadSimResult /home/pedu24/workspace_mini/0616_i2c/wave_i2c.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "8" "31" "2560" "1369"
verdiSetActWin -dock widgetDock_<Inst._Tree>
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top"
verdiSetActWin -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvSetPosition -win $_nWave2 {("G1" 16)}
wvSetPosition -win $_nWave2 {("G1" 16)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/ack_in} -height 16 \
{/tb_top/dut/u_i2c_master_top/ack_out} -height 16 \
{/tb_top/dut/u_i2c_master_top/busy} -height 16 \
{/tb_top/dut/u_i2c_master_top/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/cmd_write} -height 16 \
{/tb_top/dut/u_i2c_master_top/done} -height 16 \
{/tb_top/dut/u_i2c_master_top/rst} -height 16 \
{/tb_top/dut/u_i2c_master_top/rx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/scl} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_i} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_o} -height 16 \
{/tb_top/dut/u_i2c_master_top/tx_data\[7:0\]} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 )} \
           
wvSetPosition -win $_nWave2 {("G1" 16)}
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master_top/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/i2c_vif"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE"
wvSetCursor -win $_nWave2 1300004646.364425 -snap {("G2" 0)}
srcDeselectAll -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
wvGetSignalClose -win $_nWave2
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "1281" "31" "1278" "1360"
wvSelectSignal -win $_nWave2 {( "G1" 2 )} 
wvSelectSignal -win $_nWave2 {( "G1" 1 )} 
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 )} 
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 )} \
           
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 0)}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_slave_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master_top/u_i2c_master"
wvSetPosition -win $_nWave2 {("G1" 1)}
wvSetPosition -win $_nWave2 {("G1" 1)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 )} 
wvSetPosition -win $_nWave2 {("G1" 1)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_write} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 2 3 4 5 )} 
wvSetPosition -win $_nWave2 {("G1" 5)}
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master_top/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvSetPosition -win $_nWave2 {("G1" 9)}
wvSetPosition -win $_nWave2 {("G1" 9)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/master_ack_in} -height 16 \
{/tb_top/dut/master_ack_out} -height 16 \
{/tb_top/dut/master_busy} -height 16 \
{/tb_top/dut/master_done} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 6 7 8 9 )} 
wvSetPosition -win $_nWave2 {("G1" 9)}
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master_top/u_i2c_master"
wvSetPosition -win $_nWave2 {("G1" 10)}
wvSetPosition -win $_nWave2 {("G1" 10)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/master_ack_in} -height 16 \
{/tb_top/dut/master_ack_out} -height 16 \
{/tb_top/dut/master_busy} -height 16 \
{/tb_top/dut/master_done} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/state\[2:0\]} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 10 )} 
wvSetPosition -win $_nWave2 {("G1" 10)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/master_ack_in} -height 16 \
{/tb_top/dut/master_ack_out} -height 16 \
{/tb_top/dut/master_busy} -height 16 \
{/tb_top/dut/master_done} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/step\[1:0\]} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 11 )} 
wvSetPosition -win $_nWave2 {("G1" 11)}
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvSetPosition -win $_nWave2 {("G1" 13)}
wvSetPosition -win $_nWave2 {("G1" 13)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/master_ack_in} -height 16 \
{/tb_top/dut/master_ack_out} -height 16 \
{/tb_top/dut/master_busy} -height 16 \
{/tb_top/dut/master_done} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/step\[1:0\]} -height 16 \
{/tb_top/dut/master_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/master_tx_data\[7:0\]} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 12 13 )} 
wvSetPosition -win $_nWave2 {("G1" 13)}
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master_top"
wvSetPosition -win $_nWave2 {("G1" 15)}
wvSetPosition -win $_nWave2 {("G1" 15)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/master_ack_in} -height 16 \
{/tb_top/dut/master_ack_out} -height 16 \
{/tb_top/dut/master_busy} -height 16 \
{/tb_top/dut/master_done} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/step\[1:0\]} -height 16 \
{/tb_top/dut/master_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/master_tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_i} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_o} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 14 15 )} 
wvSetPosition -win $_nWave2 {("G1" 15)}
wvSetPosition -win $_nWave2 {("G1" 16)}
wvSetPosition -win $_nWave2 {("G1" 16)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/master_ack_in} -height 16 \
{/tb_top/dut/master_ack_out} -height 16 \
{/tb_top/dut/master_busy} -height 16 \
{/tb_top/dut/master_done} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/step\[1:0\]} -height 16 \
{/tb_top/dut/master_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/master_tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_i} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_o} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 16 )} 
wvSetPosition -win $_nWave2 {("G1" 16)}
wvSetPosition -win $_nWave2 {("G1" 17)}
wvSetPosition -win $_nWave2 {("G1" 17)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/master_ack_in} -height 16 \
{/tb_top/dut/master_ack_out} -height 16 \
{/tb_top/dut/master_busy} -height 16 \
{/tb_top/dut/master_done} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/step\[1:0\]} -height 16 \
{/tb_top/dut/master_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/master_tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_i} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_o} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda} -height 16 \
{/tb_top/dut/u_i2c_master_top/scl} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 17 )} 
wvSetPosition -win $_nWave2 {("G1" 17)}
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_slave_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvSetPosition -win $_nWave2 {("G1" 24)}
wvSetPosition -win $_nWave2 {("G1" 24)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/master_ack_in} -height 16 \
{/tb_top/dut/master_ack_out} -height 16 \
{/tb_top/dut/master_busy} -height 16 \
{/tb_top/dut/master_done} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/step\[1:0\]} -height 16 \
{/tb_top/dut/master_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/master_tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_i} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_o} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda} -height 16 \
{/tb_top/dut/u_i2c_master_top/scl} -height 16 \
{/tb_top/dut/slave_ack_in} -height 16 \
{/tb_top/dut/slave_ack_out} -height 16 \
{/tb_top/dut/slave_busy} -height 16 \
{/tb_top/dut/slave_done} -height 16 \
{/tb_top/dut/slave_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/slave_rx_valid} -height 16 \
{/tb_top/dut/slave_tx_data\[7:0\]} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 18 19 20 21 22 23 24 )} 
wvSetPosition -win $_nWave2 {("G1" 24)}
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE"
wvSetPosition -win $_nWave2 {("G1" 25)}
wvSetPosition -win $_nWave2 {("G1" 25)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/master_ack_in} -height 16 \
{/tb_top/dut/master_ack_out} -height 16 \
{/tb_top/dut/master_busy} -height 16 \
{/tb_top/dut/master_done} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/step\[1:0\]} -height 16 \
{/tb_top/dut/master_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/master_tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_i} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_o} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda} -height 16 \
{/tb_top/dut/u_i2c_master_top/scl} -height 16 \
{/tb_top/dut/slave_ack_in} -height 16 \
{/tb_top/dut/slave_ack_out} -height 16 \
{/tb_top/dut/slave_busy} -height 16 \
{/tb_top/dut/slave_done} -height 16 \
{/tb_top/dut/slave_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/slave_rx_valid} -height 16 \
{/tb_top/dut/slave_tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE/state\[3:0\]} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 25 )} 
wvSetPosition -win $_nWave2 {("G1" 25)}
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master_top/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_master_top/u_i2c_master"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE"
wvSetPosition -win $_nWave2 {("G1" 27)}
wvSetPosition -win $_nWave2 {("G1" 27)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/master_ack_in} -height 16 \
{/tb_top/dut/master_ack_out} -height 16 \
{/tb_top/dut/master_busy} -height 16 \
{/tb_top/dut/master_done} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/step\[1:0\]} -height 16 \
{/tb_top/dut/master_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/master_tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_i} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_o} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda} -height 16 \
{/tb_top/dut/u_i2c_master_top/scl} -height 16 \
{/tb_top/dut/slave_ack_in} -height 16 \
{/tb_top/dut/slave_ack_out} -height 16 \
{/tb_top/dut/slave_busy} -height 16 \
{/tb_top/dut/slave_done} -height 16 \
{/tb_top/dut/slave_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/slave_rx_valid} -height 16 \
{/tb_top/dut/slave_tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE/state\[3:0\]} -height 16 \
{/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE/sda_i} -height 16 \
{/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE/sda_o} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 26 27 )} 
wvSetPosition -win $_nWave2 {("G1" 27)}
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_i2c_slave_top"
wvSetPosition -win $_nWave2 {("G1" 28)}
wvSetPosition -win $_nWave2 {("G1" 28)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/master_ack_in} -height 16 \
{/tb_top/dut/master_ack_out} -height 16 \
{/tb_top/dut/master_busy} -height 16 \
{/tb_top/dut/master_done} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/step\[1:0\]} -height 16 \
{/tb_top/dut/master_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/master_tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_i} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_o} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda} -height 16 \
{/tb_top/dut/u_i2c_master_top/scl} -height 16 \
{/tb_top/dut/slave_ack_in} -height 16 \
{/tb_top/dut/slave_ack_out} -height 16 \
{/tb_top/dut/slave_busy} -height 16 \
{/tb_top/dut/slave_done} -height 16 \
{/tb_top/dut/slave_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/slave_rx_valid} -height 16 \
{/tb_top/dut/slave_tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE/state\[3:0\]} -height 16 \
{/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE/sda_i} -height 16 \
{/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE/sda_o} -height 16 \
{/tb_top/dut/u_i2c_slave_top/sda} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 28 )} 
wvSetPosition -win $_nWave2 {("G1" 28)}
wvSetPosition -win $_nWave2 {("G1" 29)}
wvSetPosition -win $_nWave2 {("G1" 29)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/clk} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_read} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_start} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_stop} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/cmd_write} -height 16 \
{/tb_top/dut/master_ack_in} -height 16 \
{/tb_top/dut/master_ack_out} -height 16 \
{/tb_top/dut/master_busy} -height 16 \
{/tb_top/dut/master_done} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/state\[2:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/u_i2c_master/step\[1:0\]} -height 16 \
{/tb_top/dut/master_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/master_tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_i} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda_o} -height 16 \
{/tb_top/dut/u_i2c_master_top/sda} -height 16 \
{/tb_top/dut/u_i2c_master_top/scl} -height 16 \
{/tb_top/dut/slave_ack_in} -height 16 \
{/tb_top/dut/slave_ack_out} -height 16 \
{/tb_top/dut/slave_busy} -height 16 \
{/tb_top/dut/slave_done} -height 16 \
{/tb_top/dut/slave_rx_data\[7:0\]} -height 16 \
{/tb_top/dut/slave_rx_valid} -height 16 \
{/tb_top/dut/slave_tx_data\[7:0\]} -height 16 \
{/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE/state\[3:0\]} -height 16 \
{/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE/sda_i} -height 16 \
{/tb_top/dut/u_i2c_slave_top/U_I2C_SLAVE/sda_o} -height 16 \
{/tb_top/dut/u_i2c_slave_top/sda} -height 16 \
{/tb_top/dut/u_i2c_slave_top/scl} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 29 )} 
wvSetPosition -win $_nWave2 {("G1" 29)}
wvGetSignalClose -win $_nWave2
wvSetCursor -win $_nWave2 1049245403.433693 -snap {("G1" 7)}
wvSetCursor -win $_nWave2 7046095.644252 -snap {("G1" 11)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 2000705829.611667 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 1974062780.456841 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 1975604113.879020 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 1974282970.945723 -snap {("G1" 12)}
wvSetCursor -win $_nWave2 1971310399.345805 -snap {("G1" 10)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSearchPrev -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 1998074675.346838 -snap {("G1" 10)}
wvSetCursor -win $_nWave2 1990086725.815484 -snap {("G1" 11)}
wvSetCursor -win $_nWave2 1990095327.006456 -snap {("G1" 10)}
wvSelectSignal -win $_nWave2 {( "G1" 10 )} 
wvSearchPrev -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchPrev -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 2057721465.242143 -snap {("G2" 0)}
verdiWindowResize -win $_Verdi_1 "8" "31" "2560" "1369"
wvSetCursor -win $_nWave2 2052546988.753396 -snap {("G2" 0)}
verdiWindowResize -win $_Verdi_1 "1281" "31" "1278" "1360"
verdiSetActWin -dock widgetDock_<Inst._Tree>
debExit
