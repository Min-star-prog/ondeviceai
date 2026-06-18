simSetSimulator "-vcssv" -exec "./simv" -args \
           "+UVM_TESTNAME=spi_basic_test +UVM_VERBOSITY=UVM_MEDIUM +ntb_random_seed=1 -cm line+cond+fsm+tgl+branch+assert -cm_dir coverage.vdb -cm_name sim1"
debImport "-dbdir" "./simv.daidir"
debLoadSimResult /home/pedu24/workspace_mini/0616_spi/wave_spi.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "8" "31" "2560" "1369"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top"
verdiSetActWin -win $_nWave2
wvGetSignalClose -win $_nWave2
wvAddAllSignals -win $_nWave2
wvSetCursor -win $_nWave2 21350613.361309 -snap {("G1" 11)}
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
verdiSetActWin -dock widgetDock_<Inst._Tree>
debExit
