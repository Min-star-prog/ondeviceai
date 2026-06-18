.PHONY : comp simv clean
VCS_OPTS = -full64 -sverilog
VCS_OPTS += -ntb_opts uvm-1.2
VCS_OPTS += -timescale=1ns/1ps
VCS_OPTS += -debug_access+all -kdb -lca
VCS_OPTS += -cm line+cond+fsm+tgl+branch+assert
VCS_OUTPUT = -o simv
# VCS_SRC_FILES = ./tb/spi_intf.sv
VCS_SRC_FILES += ./tb/spi_pkg.sv
VCS_SRC_FILES += ./rtl/spi_master.sv
VCS_SRC_FILES += ./rtl/spi_slave.sv
VCS_SRC_FILES += ./rtl/spi_loopback.sv
VCS_SRC_FILES += ./tb/tb_top.sv
VCS_INCDIR = +incdir+tb +incdir+rtl

TEST ?= spi_basic_test	
SEED ?= 1
INFO_LEVEL ?= UVM_MEDIUM
SIMV_OPTS = +UVM_TESTNAME=$(TEST)
SIMV_OPTS +=	+UVM_VERBOSITY=$(INFO_LEVEL)
SIMV_OPTS +=	+ntb_random_seed=$(SEED)
SIMV_OPTS += -cm line+cond+fsm+tgl+branch+assert
SIMV_OPTS += -cm_dir coverage.vdb
SIMV_OPTS += -cm_name sim1

all : simv

comp :
	@vcs $(VCS_OPTS) $(VCS_INCDIR) $(VCS_OUTPUT) $(VCS_SRC_FILES)
	@echo "VCS Compile 완료"
	@echo "Target [$@]"

simv : comp
	@./simv $(SIMV_OPTS) 
	@echo "Simulation 완료"
	@echo "의존 타겟 [$<]"	
	@echo "Target [$@]"

clean : 
	@rm -rf simv* csrc *.log *.key *.h
	@echo "자료 정리 끝"