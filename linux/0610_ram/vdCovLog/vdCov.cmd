verdiWindowResize -win $_vdCoverage_1 "830" "370" "1034" "710"
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
gui_set_pref_value -category {ColumnCfg} -key {covtblAssertList_Assert} -value {true}
verdiSetActWin -dock widgetDock_<CovDetail>
verdiWindowResize -win $_vdCoverage_1 "830" "370" "1034" "710"
gui_list_select -id CoverageTable.1 -list covtblInstancesList { uvm_pkg   }
gui_list_action -id  CoverageTable.1 -list {covtblInstancesList} uvm_pkg  -column {} 
verdiSetActWin -dock widgetDock_<Summary>
gui_covtable_show -show  { Module List } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Function Groups } -id  CoverageTable.1  -test  MergedTest
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { /ram_pkg::ram_coverage::ram_cg   }
gui_list_expand -id  CoverageTable.1   -list {covtblFGroupsList} /ram_pkg::ram_coverage::ram_cg
gui_list_expand -id CoverageTable.1   /ram_pkg::ram_coverage::ram_cg
gui_list_action -id  CoverageTable.1 -list {covtblFGroupsList} /ram_pkg::ram_coverage::ram_cg  -column {Group} 
gui_list_select -id CovDetail.1 -list covergroup { ram_pkg::ram_coverage::ram_cg.cp_addr   } -type { {Cover Group}  }
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { /ram_pkg::ram_coverage::ram_cg   }
verdiSetActWin -dock widgetDock_<Summary>
verdiWindowResize -win $_vdCoverage_1 "1181" "31" "1378" "1360"
gui_list_select -id CovDetail.1 -list covergroup { ram_pkg::ram_coverage::ram_cg.cp_wdata   } -type { {Cover Group}  }
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CovDetail.1 -list covergroup { ram_pkg::ram_coverage::ram_cg.cp_wdata  ram_pkg::ram_coverage::ram_cg.cx_op_addr   } -type { {Cover Group} {Cover Group}  }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_min]}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_min]}}  {{[read],[addr_max]}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_max]}}  {{[read],[addr_min]}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_min]}}  {{[read],[addr_max]}}   }
gui_list_action -id  CovDetail.1 -list {covergroup detail} {{[read],[addr_max]}}
gui_list_action -id  CovDetail.1 -list {covergroup detail} {{[read],[addr_max]}}
gui_list_action -id  CovDetail.1 -list {covergroup detail} {{[read],[addr_max]}}
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_max]}}  {{[read],[addr_min]}}   }
gui_list_action -id  CovDetail.1 -list {covergroup detail} {{[read],[addr_min]}}
gui_list_action -id  CovDetail.1 -list {covergroup detail} {{[read],[addr_min]}}
gui_filter_by_column_value_apply -id CovDetail.1 -list {covergroup detail} -col cp_op -action show
gui_filter_by_column_value_apply -id CovDetail.1 -list {covergroup detail} -col cp_op -action hide
verdiSetActWin -dock widgetDock_Message
gui_set_pref_value -category {ColumnCfg} -key {covergroup detail_V1.1_cp_op_width} -value {102}
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_min]}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_max]}}   }
verdiSetActWin -dock widgetDock_<Summary>
verdiSetActWin -dock widgetDock_Message
verdiSetActWin -dock widgetDock_<CovDetail>
verdiSetActWin -dock widgetDock_Message
verdiSetActWin -dock widgetDock_<Summary>
verdiWindowResize -win $_vdCoverage_1 "830" "370" "1034" "710"
gui_list_select -id CovDetail.1 -list covergroup { ram_pkg::ram_coverage::ram_cg.cx_op_addr   } -type { {Cover Group}  }
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_max]}}  {{[read],[addr_min]}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_min]}}  {{read,addr_low}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{read,addr_low}}  {{read,addr_mid}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{read,addr_mid}}  {{read,addr_high}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{read,addr_high}}  {{write,addr_max}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{write,addr_max}}  {{write,addr_min}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{write,addr_min}}  {{write,addr_high}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{write,addr_high}}  {{write,addr_low}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{write,addr_low}}  {{write,addr_mid}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{write,addr_mid}}   }
verdiSetActWin -dock widgetDock_Message
verdiSetActWin -dock widgetDock_<CovDetail>
gui_list_select -id CovDetail.1 -list covergroup { ram_pkg::ram_coverage::ram_cg.cx_op_addr   } -type { {Cover Group}  }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_max]}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_max]}}  {{[read],[addr_min]}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_min]}}  {{[read],[addr_max]}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_max]}}  {{[read],[addr_min]}}   }
gui_list_select -id CovDetail.1 -list {covergroup detail} { {{[read],[addr_min]}}  {{[read],[addr_max]}}   }
gui_list_select -id CovDetail.1 -list covergroup { ram_pkg::ram_coverage::ram_cg.cx_op_addr   } -type { {Cover Group}  }
verdiSetActWin -dock widgetDock_Message
vdCovExit -noprompt
