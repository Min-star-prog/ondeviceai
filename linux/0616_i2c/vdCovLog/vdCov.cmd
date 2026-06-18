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
gui_covtable_show -show  { Function Groups } -id  CoverageTable.1  -test  MergedTest
verdiSetActWin -dock widgetDock_<Summary>
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { /i2c_pkg::i2c_coverage::i2c_cg   }
gui_list_expand -id  CoverageTable.1   -list {covtblFGroupsList} /i2c_pkg::i2c_coverage::i2c_cg
gui_list_expand -id CoverageTable.1   /i2c_pkg::i2c_coverage::i2c_cg
gui_list_action -id  CoverageTable.1 -list {covtblFGroupsList} /i2c_pkg::i2c_coverage::i2c_cg  -column {Group} 
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { /i2c_pkg::i2c_coverage::i2c_cg   }
gui_covtable_show -show  { Tests } -id  CoverageTable.1  -test  MergedTest
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
gui_list_select -id CoverageTable.1 -list covtblStatGroupList { {Cover Point}   }
gui_list_select -id CoverageTable.1 -list covtblStatGroupList { {Cover Point}  {Cover Point Bins}   }
gui_list_select -id CoverageTable.1 -list covtblStatGroupList { {Cover Point Bins}  {All Group Bins}   }
verdiSetActWin -dock widgetDock_Message
gui_list_select -id CovDetail.1 -list covergroup { i2c_pkg::i2c_coverage::i2c_cg.cp_act   } -type { {Cover Group}  }
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CovDetail.1 -list covergroup { i2c_pkg::i2c_coverage::i2c_cg.cp_read_data   } -type { {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { i2c_pkg::i2c_coverage::i2c_cg.cp_read_data  i2c_pkg::i2c_coverage::i2c_cg.cross_read_data   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list {covergroup detail} { not_read   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { not_read  {{[read],[zero]}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[zero]}}  not_read   }
gui_list_select -id CovDetail.1 -list covergroup { i2c_pkg::i2c_coverage::i2c_cg.cross_read_data  i2c_pkg::i2c_coverage::i2c_cg.cp_read_data   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { i2c_pkg::i2c_coverage::i2c_cg.cp_read_data  i2c_pkg::i2c_coverage::i2c_cg.cross_read_data   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { i2c_pkg::i2c_coverage::i2c_cg.cross_read_data  i2c_pkg::i2c_coverage::i2c_cg.cp_read_data   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { i2c_pkg::i2c_coverage::i2c_cg.cp_read_data  i2c_pkg::i2c_coverage::i2c_cg.cross_read_data   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { i2c_pkg::i2c_coverage::i2c_cg.cross_read_data  i2c_pkg::i2c_coverage::i2c_cg.cp_read_data   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { i2c_pkg::i2c_coverage::i2c_cg.cp_read_data  i2c_pkg::i2c_coverage::i2c_cg.cross_read_data   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list covergroup { i2c_pkg::i2c_coverage::i2c_cg.cross_read_data  i2c_pkg::i2c_coverage::i2c_cg.cp_read_data   } -type { {Cover Group} {Cover Group}  }
vdCovExit -noprompt
