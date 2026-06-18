simSetSimulator "-vcssv" -exec "simv" -args
debImport "-dbdir" "simv.daidir" "/"
wvCreateWindow
wvOpenFile -win $_nWave2 {/home/pedu24/workspace_mini/0610_ram/ram_tb.fsdb}
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "1265" "362" "1250" "800"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiInvokeApp -vdCov
