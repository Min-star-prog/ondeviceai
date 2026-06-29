# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Working\OndeviceAI2\260622_microblaze_GPIO\vitis_workspace\led_2_system\_ide\scripts\debugger_led_2-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Working\OndeviceAI2\260622_microblaze_GPIO\vitis_workspace\led_2_system\_ide\scripts\debugger_led_2-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -filter {jtag_cable_name =~ "Digilent Basys3 210183BE9E54A" && level==0 && jtag_device_ctx=="jsn-Basys3-210183BE9E54A-0362d093-0"}
fpga -file C:/Working/OndeviceAI2/260622_microblaze_GPIO/vitis_workspace/led_2/_ide/bitstream/gpio_test_wrapper_1.bit
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
loadhw -hw C:/Working/OndeviceAI2/260622_microblaze_GPIO/vitis_workspace/led_1/export/led_1/hw/gpio_test_wrapper_1.xsa -regs
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
rst -system
after 3000
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
dow C:/Working/OndeviceAI2/260622_microblaze_GPIO/vitis_workspace/led_2/Debug/led_2.elf
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
con
