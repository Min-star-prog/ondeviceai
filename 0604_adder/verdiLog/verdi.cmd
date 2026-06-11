verdiSetActWin -dock widgetDock_<Watch>
simSetSimulator "-vcssv" -exec "./simv" -args
debImport "-dbdir" "./simv.daidir"
debLoadSimResult /home/pedu24/workspace_mini/260604_adder/wave.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "1265" "362" "1250" "800"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "tb_adder.dut" -win $_nTrace1
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("dut" 0)}
wvRenameGroup -win $_nWave2 {G1} {dut}
wvAddSignal -win $_nWave2 "/tb_adder/dut/a\[7:0\]" "/tb_adder/dut/b\[7:0\]" \
           "/tb_adder/dut/y\[8:0\]"
wvSetPosition -win $_nWave2 {("dut" 0)}
wvSetPosition -win $_nWave2 {("dut" 3)}
wvSetPosition -win $_nWave2 {("dut" 3)}
verdiDockWidgetSetCurTab -dock widgetDock_<Local>
verdiSetActWin -dock widgetDock_<Local>
verdiDockWidgetSetCurTab -dock widgetDock_<Member>
verdiSetActWin -dock widgetDock_<Member>
verdiDockWidgetSetCurTab -dock widgetDock_<Signal_List>
verdiSetActWin -dock widgetDock_<Signal_List>
srcDeselectAll -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcSelect -win $_nTrace1 -range {19 19 1 13 1 1}
srcTBAddBrkPnt -win $_nTrace1 -line 19 -file \
           /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
srcSelect -win $_nTrace1 -range {19 19 1 13 1 1}
srcTBSetBrkPnt -win $_nTrace1 -disable -index 0
srcSelect -win $_nTrace1 -range {19 19 1 13 1 1}
srcTBSetBrkPnt -win $_nTrace1 -delete -index 0
srcSelect -win $_nTrace1 -range {19 19 1 13 1 1}
srcTBAddBrkPnt -win $_nTrace1 -line 19 -file \
           /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
srcSelect -win $_nTrace1 -range {26 26 1 4 1 1}
srcTBAddBrkPnt -win $_nTrace1 -line 26 -file \
           /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
srcSelect -win $_nTrace1 -range {20 20 1 4 1 1}
srcTBAddBrkPnt -win $_nTrace1 -line 20 -file \
           /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
srcSelect -win $_nTrace1 -range {19 19 1 13 1 1}
srcTBSetBrkPnt -win $_nTrace1 -disable -index 1
srcSelect -win $_nTrace1 -range {19 19 1 13 1 1}
srcTBSetBrkPnt -win $_nTrace1 -delete -index 1
srcSelect -win $_nTrace1 -range {20 20 1 4 1 1}
srcTBSetBrkPnt -win $_nTrace1 -disable -index 3
srcSelect -win $_nTrace1 -range {20 20 1 4 1 1}
srcTBSetBrkPnt -win $_nTrace1 -delete -index 3
srcSelect -win $_nTrace1 -range {26 26 1 4 1 1}
srcTBSetBrkPnt -win $_nTrace1 -disable -index 2
srcSelect -win $_nTrace1 -range {26 26 1 4 1 1}
srcTBSetBrkPnt -win $_nTrace1 -delete -index 2
srcSelect -win $_nTrace1 -range {23 23 1 7 1 1}
srcTBAddBrkPnt -win $_nTrace1 -line 23 -file \
           /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
srcTBInvokeSim
verdiSetActWin -win $_InteractiveConsole_3
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
srcTBRunSim
srcTBRunSim
wvZoomAll -win $_nWave2
verdiDockWidgetSetCurTab -dock widgetDock_<Message>
verdiSetActWin -dock widgetDock_<Message>
nsMsgSwitchTab -tab cmpl
nsMsgSwitchTab -tab trace
nsMsgSwitchTab -tab search
nsMsgSwitchTab -tab intercon
nsMsgSwitchTab -tab general
verdiDockWidgetSetCurTab -dock windowDock_OneSearch
verdiSetActWin -win $_OneSearch
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
verdiDockWidgetSetCurTab -dock windowDock_OneSearch
verdiSetActWin -win $_OneSearch
verdiOneSearch -tab "GUI Content"
verdiOneSearch -tab "Menu Command"
verdiOneSearch -tab "DB/Log/Doc"
verdiDockWidgetSetCurTab -dock windowDock_InteractiveConsole_3
verdiSetActWin -win $_InteractiveConsole_3
srcSelect -win $_nTrace1 -range {25 25 1 13 1 1}
srcTBAddBrkPnt -line 25 -file \
           /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcTBSimReset
srcSelect -win $_nTrace1 -range {7 7 1 5 1 1}
srcTBAddBrkPnt -line 7 -file /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
viaLogViewerGoToTime -logID 3 -next -window "$_InteractiveConsole_3"
verdiSetActWin -win $_InteractiveConsole_3
srcSelect -win $_nTrace1 -range {7 7 1 5 1 1}
srcTBAddBrkPnt -line 7 -file /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcDeselectAll -win $_nTrace1
srcSelect -signal "y" -line 10 -pos 1 -win $_nTrace1
srcSelect -win $_nTrace1 -range {7 7 1 5 1 1}
srcTBAddBrkPnt -line 7 -file /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
verdiSetActWin -win $_InteractiveConsole_3
srcSelect -win $_nTrace1 -range {25 25 1 13 1 1}
srcTBSetBrkPnt -disable -index 2
srcSelect -win $_nTrace1 -range {23 23 1 7 1 1}
srcTBSetBrkPnt -disable -index 1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcSelect -win $_nTrace1 -range {25 25 1 13 1 1}
srcTBSetBrkPnt -delete -index 2
srcSelect -win $_nTrace1 -range {23 23 1 7 1 1}
srcTBSetBrkPnt -delete -index 1
srcSelect -win $_nTrace1 -range {16 16 1 7 1 1}
srcTBAddBrkPnt -line 16 -file \
           /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
srcSelect -win $_nTrace1 -range {23 23 1 7 1 1}
srcTBAddBrkPnt -line 23 -file \
           /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
srcTBAddBrkPnt -line 33 -file \
           /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
srcSelect -win $_nTrace1 -range {34 34 1 7 1 1}
srcTBAddBrkPnt -line 34 -file \
           /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
srcSelect -win $_nTrace1 -range {44 44 1 4 1 1}
srcTBAddBrkPnt -line 44 -file \
           /home/pedu24/workspace_mini/260604_adder/tb_adder.sv
verdiSetActWin -win $_InteractiveConsole_3
srcTBRunSim
srcTBRunSim
srcTBRunSim
srcTBRunSim
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
wvZoomAll -win $_nWave2
verdiDockWidgetSetCurTab -dock windowDock_InteractiveConsole_3
verdiSetActWin -win $_InteractiveConsole_3
srcTBRunSim
srcTBSimReset
srcTBRunSim
srcTBRunSim
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
wvZoomAll -win $_nWave2
verdiDockWidgetSetCurTab -dock windowDock_InteractiveConsole_3
verdiSetActWin -win $_InteractiveConsole_3
srcTBRunSim
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
wvZoomAll -win $_nWave2
debExit
