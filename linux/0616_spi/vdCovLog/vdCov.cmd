verdiWindowResize -win $_vdCoverage_1 "8" "31" "2560" "1369"
gui_set_pref_value -category {coveragesetting} -key {geninfodumping} -value 1
gui_exclusion -set_force true
verdiSetFont  -font  {DejaVu Sans}  -size  12
verdiSetFont -font "DejaVu Sans" -size "12"
gui_assert_mode -mode flat
gui_class_mode -mode hier
gui_excl_mgr_flat_list -on  0
gui_covdetail_select -id  CovDetail.1   -name   Line
verdiWindowWorkMode -win $_vdCoverage_1 -coverageAnalysis
gui_open_cov  -hier coverage.vdb -testdir {} -test {coverage/sim1} -merge MergedTest -db_max_tests 10 -sdc_level 1 -fsm transition
verdiSetActWin -dock widgetDock_<CovDetail>
verdiSetActWin -dock widgetDock_<Summary>
gui_covtable_show -show  { Function Groups } -id  CoverageTable.1  -test  MergedTest
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { /spi_pkg::spi_coverage::spi_cg   }
gui_list_expand -id  CoverageTable.1   -list {covtblFGroupsList} /spi_pkg::spi_coverage::spi_cg
gui_list_expand -id CoverageTable.1   /spi_pkg::spi_coverage::spi_cg
gui_list_action -id  CoverageTable.1 -list {covtblFGroupsList} /spi_pkg::spi_coverage::spi_cg  -column {Group} 
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { /spi_pkg::spi_coverage::spi_cg   }
gui_list_select -id CovDetail.1 -list covergroup { spi_pkg::spi_coverage::spi_cg.cp_cap_miso   } -type { {Cover Group}  }
verdiSetActWin -dock widgetDock_<CovDetail>
gui_covtable_show -show  { Statistics } -id  CoverageTable.1  -test  MergedTest
gui_list_expand -id  CoverageTable.1   -list {covtblStatModuleList} Assert
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertInstList} Assertion
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertInstList} {Cover Property}
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertInstList} {Cover Sequence}
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertInstList} Total
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertDefList} Assertion
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertDefList} {Cover Property}
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertDefList} {Cover Sequence}
gui_list_expand -id  CoverageTable.1   -list {covtblStatAssertDefList} Total
verdiSetActWin -dock widgetDock_<Summary>
gui_covtable_show -show  { Function Groups } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Asserts } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Statistics } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Asserts } -id  CoverageTable.1  -test  MergedTest
gui_list_select -id CoverageTable.1 -list covtblAssertList_flat { {/uvm_pkg.\uvm_component_name_check_visitor::visit .unnamed$$_0}   }
gui_covtable_show -show  { Module List } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Design Hierarchy } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Statistics } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Tests } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Statistics } -id  CoverageTable.1  -test  MergedTest
gui_list_select -id CovDetail.1 -list covergroup { spi_pkg::spi_coverage::spi_cg.cross_master_slave_tx   } -type { {Cover Group}  }
verdiSetActWin -dock widgetDock_<CovDetail>
gui_set_pref_value -category {ColumnCfg} -key {covergroup detail_V1.1_cp_master_tx_width} -value {143}
gui_set_pref_value -category {ColumnCfg} -key {covergroup detail_V1.1_cp_slave_tx_width} -value {110}
verdiSetActWin -dock widgetDock_Message
verdiSetActWin -dock widgetDock_<Summary>
gui_list_select -id CoverageTable.1 -list covtblStatAssertDefList { {In Package}   }
gui_list_select -id CovDetail.1 -list covergroup { spi_pkg::spi_coverage::spi_cg.cross_master_slave_tx   } -type { {Cover Group}  }
verdiSetActWin -dock widgetDock_<CovDetail>
verdiSetActWin -dock widgetDock_<Summary>
verdiSetActWin -dock widgetDock_<CovDetail>
verdiSetActWin -dock widgetDock_<Summary>
verdiSetActWin -dock widgetDock_<CovDetail>
verdiSetActWin -dock widgetDock_<Summary>
gui_list_select -id CovDetail.1 -list covergroup { /spi_pkg::spi_coverage::spi_cg   } -type { {Cover Group}  }
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CovDetail.1 -list covergroup { /spi_pkg::spi_coverage::spi_cg  spi_pkg::spi_coverage::spi_cg.cross_master_slave_tx   } -type { {Cover Group} {Cover Group}  }
vdCovExit -noprompt
