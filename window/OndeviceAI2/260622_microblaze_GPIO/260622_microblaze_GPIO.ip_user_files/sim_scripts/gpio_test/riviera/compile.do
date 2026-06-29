vlib work
vlib riviera

vlib riviera/xpm
vlib riviera/microblaze_v11_0_4
vlib riviera/xil_defaultlib
vlib riviera/lmb_v10_v3_0_11
vlib riviera/lmb_bram_if_cntlr_v4_0_19
vlib riviera/blk_mem_gen_v8_4_4
vlib riviera/axi_lite_ipif_v3_0_4
vlib riviera/mdm_v3_2_19
vlib riviera/lib_cdc_v1_0_2
vlib riviera/proc_sys_reset_v5_0_13
vlib riviera/lib_pkg_v1_0_2
vlib riviera/lib_srl_fifo_v1_0_2
vlib riviera/axi_uartlite_v2_0_26
vlib riviera/generic_baseblocks_v2_1_0
vlib riviera/axi_infrastructure_v1_1_0
vlib riviera/axi_register_slice_v2_1_22
vlib riviera/fifo_generator_v13_2_5
vlib riviera/axi_data_fifo_v2_1_21
vlib riviera/axi_crossbar_v2_1_23

vmap xpm riviera/xpm
vmap microblaze_v11_0_4 riviera/microblaze_v11_0_4
vmap xil_defaultlib riviera/xil_defaultlib
vmap lmb_v10_v3_0_11 riviera/lmb_v10_v3_0_11
vmap lmb_bram_if_cntlr_v4_0_19 riviera/lmb_bram_if_cntlr_v4_0_19
vmap blk_mem_gen_v8_4_4 riviera/blk_mem_gen_v8_4_4
vmap axi_lite_ipif_v3_0_4 riviera/axi_lite_ipif_v3_0_4
vmap mdm_v3_2_19 riviera/mdm_v3_2_19
vmap lib_cdc_v1_0_2 riviera/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 riviera/proc_sys_reset_v5_0_13
vmap lib_pkg_v1_0_2 riviera/lib_pkg_v1_0_2
vmap lib_srl_fifo_v1_0_2 riviera/lib_srl_fifo_v1_0_2
vmap axi_uartlite_v2_0_26 riviera/axi_uartlite_v2_0_26
vmap generic_baseblocks_v2_1_0 riviera/generic_baseblocks_v2_1_0
vmap axi_infrastructure_v1_1_0 riviera/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_22 riviera/axi_register_slice_v2_1_22
vmap fifo_generator_v13_2_5 riviera/fifo_generator_v13_2_5
vmap axi_data_fifo_v2_1_21 riviera/axi_data_fifo_v2_1_21
vmap axi_crossbar_v2_1_23 riviera/axi_crossbar_v2_1_23

vlog -work xpm  -sv2k12 "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/d0f7" "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ec67/hdl" \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work microblaze_v11_0_4 -93 \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/9285/hdl/microblaze_v11_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/gpio_test/ip/gpio_test_microblaze_0_0/sim/gpio_test_microblaze_0_0.vhd" \

vcom -work lmb_v10_v3_0_11 -93 \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/c2ed/hdl/lmb_v10_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/gpio_test/ip/gpio_test_dlmb_v10_0/sim/gpio_test_dlmb_v10_0.vhd" \
"../../../bd/gpio_test/ip/gpio_test_ilmb_v10_0/sim/gpio_test_ilmb_v10_0.vhd" \

vcom -work lmb_bram_if_cntlr_v4_0_19 -93 \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/0b98/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/gpio_test/ip/gpio_test_dlmb_bram_if_cntlr_0/sim/gpio_test_dlmb_bram_if_cntlr_0.vhd" \
"../../../bd/gpio_test/ip/gpio_test_ilmb_bram_if_cntlr_0/sim/gpio_test_ilmb_bram_if_cntlr_0.vhd" \

vlog -work blk_mem_gen_v8_4_4  -v2k5 "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/d0f7" "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ec67/hdl" \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/d0f7" "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ec67/hdl" \
"../../../bd/gpio_test/ip/gpio_test_lmb_bram_0/sim/gpio_test_lmb_bram_0.v" \

vcom -work axi_lite_ipif_v3_0_4 -93 \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work mdm_v3_2_19 -93 \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/8715/hdl/mdm_v3_2_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/gpio_test/ip/gpio_test_mdm_1_0/sim/gpio_test_mdm_1_0.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/d0f7" "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ec67/hdl" \
"../../../bd/gpio_test/ip/gpio_test_clk_wiz_1_0/gpio_test_clk_wiz_1_0_clk_wiz.v" \
"../../../bd/gpio_test/ip/gpio_test_clk_wiz_1_0/gpio_test_clk_wiz_1_0.v" \

vcom -work lib_cdc_v1_0_2 -93 \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13 -93 \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/gpio_test/ip/gpio_test_rst_clk_wiz_1_100M_0/sim/gpio_test_rst_clk_wiz_1_100M_0.vhd" \

vcom -work lib_pkg_v1_0_2 -93 \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -93 \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work axi_uartlite_v2_0_26 -93 \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/5edb/hdl/axi_uartlite_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/gpio_test/ip/gpio_test_axi_uartlite_0_0/sim/gpio_test_axi_uartlite_0_0.vhd" \

vlog -work generic_baseblocks_v2_1_0  -v2k5 "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/d0f7" "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ec67/hdl" \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/d0f7" "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ec67/hdl" \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_22  -v2k5 "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/d0f7" "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ec67/hdl" \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/af2c/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_5  -v2k5 "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/d0f7" "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ec67/hdl" \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_5 -93 \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_5  -v2k5 "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/d0f7" "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ec67/hdl" \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_21  -v2k5 "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/d0f7" "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ec67/hdl" \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/54c0/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_23  -v2k5 "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/d0f7" "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ec67/hdl" \
"../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/bc0a/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/d0f7" "+incdir+../../../../260622_microblaze_GPIO.gen/sources_1/bd/gpio_test/ipshared/ec67/hdl" \
"../../../bd/gpio_test/ip/gpio_test_xbar_0/sim/gpio_test_xbar_0.v" \
"../../../bd/gpio_test/ipshared/e16c/hdl/gpio_v1_0_S00_AXI.v" \
"../../../bd/gpio_test/ipshared/e16c/hdl/gpio_v1_0.v" \
"../../../bd/gpio_test/ip/gpio_test_gpio_0_0/sim/gpio_test_gpio_0_0.v" \
"../../../bd/gpio_test/sim/gpio_test.v" \
"../../../bd/gpio_test/ip/gpio_test_gpio_1_0/sim/gpio_test_gpio_1_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

