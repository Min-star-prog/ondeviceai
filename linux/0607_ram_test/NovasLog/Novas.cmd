simSetSimulator "-vcssv" -exec "./simv" -args
debImport "-dbdir" "./simv.daidir"
debLoadSimResult /home/pedu24/workspace_mini/0607_ram_test/wave_ram.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "1265" "362" "1250" "800"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcHBSelect "tb_ram.dut" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "tb_ram.ram_if" -win $_nTrace1
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/_vcs_msglog"
verdiSetActWin -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/_vcs_unit__2374409791"
wvGetSignalSetScope -win $_nWave2 "/tb_ram"
wvGetSignalSetScope -win $_nWave2 "/tb_ram"
wvSetPosition -win $_nWave2 {("G1" 1)}
wvSetPosition -win $_nWave2 {("G1" 1)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_ram/clk} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 )} 
wvSetPosition -win $_nWave2 {("G1" 1)}
wvGetSignalSetScope -win $_nWave2 "/tb_ram/dut"
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_ram/clk} -height 16 \
{/tb_ram/dut/addr\[7:0\]} -height 16 \
{/tb_ram/dut/rdata\[7:0\]} -height 16 \
{/tb_ram/dut/wdata\[7:0\]} -height 16 \
{/tb_ram/dut/we} -height 16 \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 2 3 4 5 )} 
wvSetPosition -win $_nWave2 {("G1" 5)}
wvGetSignalSetScope -win $_nWave2 "/tb_ram/ram_if"
wvGetSignalSetScope -win $_nWave2 "/uvm_custom_install_recording"
wvGetSignalSetScope -win $_nWave2 "/uvm_custom_install_verdi_recording"
wvGetSignalSetScope -win $_nWave2 "/uvm_pkg"
wvGetSignalClose -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 2 )} 
wvSelectSignal -win $_nWave2 {( "G1" 2 3 4 )} 
wvSelectSignal -win $_nWave2 {( "G1" 2 3 4 )} 
wvSetRadix -win $_nWave2 -format UDec
wvSetCursor -win $_nWave2 62625.539431 -snap {("G2" 0)}
wvZoom -win $_nWave2 424993.662864 578605.830165
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "tb_ram.dut" -win $_nTrace1
verdiSetActWin -win $_nWave2
wvSetCursor -win $_nWave2 47314.868149 -snap {("G2" 0)}
srcDeselectAll -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
wvSetCursor -win $_nWave2 81995.248345 -snap {("G2" 0)}
verdiSetActWin -win $_nWave2
wvSetCursor -win $_nWave2 108424.534368 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 51827.185275 -snap {("G1" 3)}
wvSetCursor -win $_nWave2 844013.519223
wvSetCursor -win $_nWave2 62785.669723 -snap {("G2" 0)}
srcDeselectAll -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
debExit
