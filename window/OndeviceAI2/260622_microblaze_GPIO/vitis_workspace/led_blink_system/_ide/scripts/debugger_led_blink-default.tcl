# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Working\OndeviceAI2\260622_microblaze_GPIO\vitis_workspace\led_blink_system\_ide\scripts\debugger_led_blink-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Working\OndeviceAI2\260622_microblaze_GPIO\vitis_workspace\led_blink_system\_ide\scripts\debugger_led_blink-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -filter {jtag_cable_name =~ "Digilent Basys3 210183BE9E54A" && level==0 && jtag_device_ctx=="jsn-Basys3-210183BE9E54A-0362d093-0"}
fpga -file C:/Working/OndeviceAI2/260622_microblaze_GPIO/vitis_workspace/led_blink/_ide/bitstream/gpio_test_wrapper.bit
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
loadhw -hw C:/Working/OndeviceAI2/260622_microblaze_GPIO/vitis_workspace/gpio_test_wrapper/export/gpio_test_wrapper/hw/gpio_test_wrapper.xsa -regs
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
rst -system
after 3000
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
dow C:/Working/OndeviceAI2/260622_microblaze_GPIO/vitis_workspace/led_blink/Debug/led_blink.elf
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
con
