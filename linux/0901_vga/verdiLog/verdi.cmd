verdiSetActWin -dock widgetDock_<Message>
verdiWindowResize -win $_Verdi_1 "8" "31" "2560" "1369"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -dock widgetDock_<Message>
simSetSimulator "-vcssv" -exec "/home/pedu24/workspace_mini/linux/0901_vga/simv" \
           -args \
           "+UVM_TESTNAME=full_game_scenario_test +SEQ_REPEAT=3 +FSDB_FILE=full_game_scenario_test.fsdb -cm line+cond+branch+fsm+tgl -cm_dir coverage.vdb -cm_name full"
debImport "-dbdir" "/home/pedu24/workspace_mini/linux/0901_vga/simv.daidir"
debLoadSimResult \
           /home/pedu24/workspace_mini/linux/0901_vga/full_game_scenario_test.fsdb
wvCreateWindow
wvSetCursor -win $_nWave2 365925026599.695740
verdiSetActWin -win $_nWave2
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/_vcs_msglog"
wvGetSignalSetScope -win $_nWave2 "/tb_top/intf"
wvSetCursor -win $_nWave2 2005718746481.608643
verdiWindowResize -win $_Verdi_1 "1281" "31" "1278" "1360"
wvSetCursor -win $_nWave2 223838556407.747345
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_game_score"
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_game_score/c_state\[2:0\]} -height 16 \
{/tb_top/dut/u_game_score/o_score\[3:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[0:3\]} -height 16 \
{/tb_top/dut/u_game_score/speed_diff\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/score_control_valid} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 5 )} 
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_game_score/c_state\[2:0\]} -height 16 \
{/tb_top/dut/u_game_score/o_score\[3:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[0:3\]} -height 16 \
{/tb_top/dut/u_game_score/speed_diff\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/score_control_valid} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 5 )} 
wvSetPosition -win $_nWave2 {("G1" 5)}
wvGetSignalClose -win $_nWave2
srcDeselectAll -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
verdiSetActWin -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvSelectSignal -win $_nWave2 {( "G1" 2 )} 
wvSetPosition -win $_nWave2 {("G1" 2)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 9)}
wvSelectSignal -win $_nWave2 {( "G1" 2 )} 
wvSetPosition -win $_nWave2 {("G1" 2)}
wvCollapseBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 2)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvSetPosition -win $_nWave2 {("G1" 3)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 9)}
wvSelectSignal -win $_nWave2 {( "G1" 3 4 5 6 7 )} 
wvSelectSignal -win $_nWave2 {( "G1" 3 4 5 6 7 )} 
wvSetRadix -win $_nWave2 -format UDec
wvSelectSignal -win $_nWave2 {( "G1" 5 )} 
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/_vcs_msglog"
wvGetSignalSetScope -win $_nWave2 "/tb_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_game_score"
wvSetPosition -win $_nWave2 {("G1" 10)}
wvSetPosition -win $_nWave2 {("G1" 10)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_game_score/c_state\[2:0\]} -height 16 \
{/tb_top/dut/u_game_score/o_score\[3:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[0:3\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[0\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[1\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[2\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[3\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_diff\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/score_control_valid} -height 16 \
{/tb_top/dut/u_game_score/i_score_en} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 10 )} 
wvSetPosition -win $_nWave2 {("G1" 10)}
wvGetSignalClose -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 4 )} 
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/_vcs_msglog"
wvGetSignalSetScope -win $_nWave2 "/tb_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_game_score"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_game_score"
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_game_score/c_state\[2:0\]} -height 16 \
{/tb_top/dut/u_game_score/o_score\[3:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[0:3\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[0\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[1\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[2\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[3\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_diff\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/score_control_valid} -height 16 \
{/tb_top/dut/u_game_score/i_score_en} -height 16 \
{/tb_top/dut/u_game_score/i_song_speed\[7:0\]} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 11 )} 
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_game_score/c_state\[2:0\]} -height 16 \
{/tb_top/dut/u_game_score/o_score\[3:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[0:3\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[0\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[1\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[2\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[3\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_diff\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/score_control_valid} -height 16 \
{/tb_top/dut/u_game_score/i_score_en} -height 16 \
{/tb_top/dut/u_game_score/i_song_speed\[7:0\]} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 11 )} 
wvSetPosition -win $_nWave2 {("G1" 11)}
wvGetSignalClose -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 9 )} 
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/_vcs_msglog"
wvGetSignalSetScope -win $_nWave2 "/tb_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_game_score"
wvGetSignalSetScope -win $_nWave2 "/tb_top/dut/u_game_score"
wvSetPosition -win $_nWave2 {("G1" 12)}
wvSetPosition -win $_nWave2 {("G1" 12)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_game_score/c_state\[2:0\]} -height 16 \
{/tb_top/dut/u_game_score/o_score\[3:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[0:3\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[0\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[1\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[2\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[3\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_diff\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/score_control_valid} -height 16 \
{/tb_top/dut/u_game_score/i_score_en} -height 16 \
{/tb_top/dut/u_game_score/i_song_speed\[7:0\]} -height 16 \
{/tb_top/dut/u_game_score/i_speed\[7:0\]} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 12 )} 
wvSetPosition -win $_nWave2 {("G1" 12)}
wvSetPosition -win $_nWave2 {("G1" 12)}
wvSetPosition -win $_nWave2 {("G1" 12)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/dut/u_game_score/c_state\[2:0\]} -height 16 \
{/tb_top/dut/u_game_score/o_score\[3:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[0:3\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[0\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[1\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[2\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_ram\[3\]\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/speed_diff\[9:0\]} -height 16 \
{/tb_top/dut/u_game_score/score_control_valid} -height 16 \
{/tb_top/dut/u_game_score/i_score_en} -height 16 \
{/tb_top/dut/u_game_score/i_song_speed\[7:0\]} -height 16 \
{/tb_top/dut/u_game_score/i_speed\[7:0\]} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 12 )} 
wvSetPosition -win $_nWave2 {("G1" 12)}
wvGetSignalClose -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 11 12 )} 
wvSelectSignal -win $_nWave2 {( "G1" 11 12 )} 
wvSetRadix -win $_nWave2 -format UDec
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 15869288491997.933594 -snap {("G1" 11)}
debLoadSimResult \
           /home/pedu24/workspace_mini/linux/0901_vga/speed_ram_debug_test.fsdb
wvZoomAll -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 4 )} 
wvSearchPrev -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 5 )} 
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcDeselectAll -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
debExit
