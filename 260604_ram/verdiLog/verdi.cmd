verdiSetActWin -dock widgetDock_<Message>
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiWindowResize -win $_Verdi_1 "1265" "362" "1250" "800"
simSetSimulator "-vcssv" -exec "/home/pedu24/workspace_mini/260604_ram/simv" \
           -args
debImport "-dbdir" "/home/pedu24/workspace_mini/260604_ram/simv.daidir"
debLoadSimResult /home/pedu24/workspace_mini/260604_ram/wave_ram.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
