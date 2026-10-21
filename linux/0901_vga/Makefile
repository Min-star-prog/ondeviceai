.PHONY : comp simv clean
VCS_OPTS = -full64 -sverilog
VCS_OPTS += -ntb_opts uvm-1.2
VCS_OPTS += -timescale=1ns/1ps
VCS_OPTS += -debug_access+all -kdb -lca
VCS_OPTS += -cm line+cond+fsm+tgl+branch+assert
VCS_OPTS += -cm_fsmcfg ./tb_ai/fsm.cfg
VCS_OPTS += -cm_hier ./tb_ai/cm_hier.cfg
VCS_OUTPUT = -o simv
VCS_SRC_FILES = -f ./tb_ai/files.f
VCS_INCDIR = +incdir+tb +incdir+rtl

TEST ?= game_logic_test	
SEED ?= 2
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