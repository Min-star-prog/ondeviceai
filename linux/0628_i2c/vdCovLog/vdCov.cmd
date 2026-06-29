verdiWindowResize -win $_vdCoverage_1 "830" "370" "900" "700"
gui_set_pref_value -category {coveragesetting} -key {geninfodumping} -value 1
gui_exclusion -set_force true
verdiSetFont  -font  {DejaVu Sans}  -size  12
verdiSetFont -font "DejaVu Sans" -size "12"
gui_assert_mode -mode flat
gui_class_mode -mode hier
gui_excl_mgr_flat_list -on  0
gui_covdetail_select -id  CovDetail.1   -name   Line
verdiWindowWorkMode -win $_vdCoverage_1 -coverageAnalysis
verdiSetActWin -dock widgetDock_Message
verdiWindowResize -win $_vdCoverage_1 "830" "370" "1034" "710"
verdiSetActWin -dock widgetDock_<Summary>
gui_open_cov  -hier simv.vdb -testdir  {simv.vdb coverage.vdb} -test { coverage/sim1 } -merge MergedTest -db_max_tests 10 -sdc_level 1 -fsm transition
gui_covtable_show -show  { Function Groups } -id  CoverageTable.1  -test  MergedTest
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { /i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus   }
gui_list_expand -id  CoverageTable.1   -list {covtblFGroupsList} /i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus
gui_list_expand -id CoverageTable.1   /i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus
gui_list_action -id  CoverageTable.1 -list {covtblFGroupsList} /i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus  -column {Group} 
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { /i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus   }
gui_list_select -id CovDetail.1 -list covergroup { i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.cp_data   } -type { {Cover Group}  }
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CovDetail.1 -list covergroup { i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.data_x_ninth   } -type { {Cover Group}  }
gui_list_action -id  CovDetail.1 -list {covergroup} i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.data_x_ninth  -type {Cover Group}
gui_list_select -id CovDetail.1 -list covergroup { i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.data_x_ninth   } -type { {Cover Group}  }
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { /i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus/i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.tb_top.me.obj.cg_bus   }
verdiSetActWin -dock widgetDock_<Summary>
gui_list_expand -id  CoverageTable.1   -list {covtblFGroupsList} /i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus/i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.tb_top.me.obj.cg_bus
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { /i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus/i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.tb_top.me.obj.cg_bus  i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.tb_top.me.obj.cg_bus.data_x_ninth   }
verdiWindowResize -win $_vdCoverage_1 "830" "370" "1034" "710"
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[high , mid , low , zero],[low]}}   }
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CovDetail.1 -list covergroup { i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.data_x_ninth   } -type { {Cover Group}  }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{ff,low}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{ff,low}}  {{[high , mid , low , zero],[low]}}   }
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.tb_top.me.obj.cg_bus.data_x_ninth   }
verdiSetActWin -dock widgetDock_<Summary>
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.data_x_ninth   }
gui_list_action -id  CoverageTable.1 -list {covtblFGroupsList} i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.data_x_ninth  -column {} 
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.data_x_ninth  i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.tb_top.me.obj.cg_bus.data_x_ninth   }
gui_list_action -id  CoverageTable.1 -list {covtblFGroupsList} i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.tb_top.me.obj.cg_bus.data_x_ninth  -column {} 
verdiSetActWin -dock widgetDock_<CovDetail>
verdiSetActWin -dock widgetDock_Message
verdiWindowResize -win $_vdCoverage_1 "122" "253" "1034" "710"
verdiWindowResize -win $_vdCoverage_1 "122" "253" "1176" "710"
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{ff,low}}   }
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { i2c_axi_no_slave_pkg::i2c_axi_coverage::cg_bus.tb_top.me.obj.cg_bus.data_x_ninth   }
verdiSetActWin -dock widgetDock_<Summary>
gui_covtable_show -show  { Asserts } -id  CoverageTable.1  -test  MergedTest
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertInstList} Assertion
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertInstList} {Cover Property}
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertInstList} {Cover Sequence}
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertInstList} Total
gui_covtable_show -show  { Function Groups } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Tests } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Function Groups } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Tests } -id  CoverageTable.1  -test  MergedTest
gui_list_select -id CoverageTable.1 -list covtblTestSummaryList { coverage/sim1   }
gui_list_action -id  CoverageTable.1 -list {covtblTestSummaryList} coverage/sim1  -column {Type} 
gui_covtable_show -show  { Statistics } -id  CoverageTable.1  -test  MergedTest
gui_list_expand -id  CoverageTable.1   -list {covtblStatModuleList} Assert
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertDefList} Assertion
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertDefList} {Cover Property}
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertDefList} {Cover Sequence}
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertDefList} Total
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{ff,low}}   }
verdiSetActWin -dock widgetDock_<CovDetail>
vdCovExit -noprompt
