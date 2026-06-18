
#####  += : 기존 값에 추가
VCS_OPTS = -full64 -sverilog
VCS_OPTS += -ntb_opts uvm-1.2
VCS_OPTS += -timescale=1ns/1ps
VCS_OPTS += -debug_access+all -kdb -lca 

VCS_OUTPUT = -o simv
VCS_SRC_FILES = ./rtl/adder.sv ./tb/tb_adder.sv
SIMV_OPTS = 	+UVM_TESTNAME=adder_test
SIMV_OPTS +=	+UVM_VERBOSITY=UVM_MEDIUM
SIMV_OPTS +=	+ntb_random_seed=1234

#### File명과 target 명이 같을때를 대비
.PHONY: compile sim clean

compile : 
	@vcs $(VCS_OPTS) $(VCS_OUTPUT) $(VCS_SRC_FILES)
	@echo "vcs compile 실행 중........"
	@echo "Target [$@]"

sim: compile
	@./simv $(SIMV_OPTS)
	@echo "Simulation 실행 중........"	
	@echo "의존 타겟 [$<]"	
	@echo "Target [$@]"
clean: 
	@rm -rf simv* csrc *.log *.key *.h
	@echo "결과물 정리 중........"

###### @ : 명령어를 안 보여주고 해당 명령 결과만 보여줌.



A = hello
B = $(A) world
A ?= goodbye

test:
	@echo $(B)