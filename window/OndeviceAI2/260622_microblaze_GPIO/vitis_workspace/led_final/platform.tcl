# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Working\OndeviceAI2\260622_microblaze_GPIO\vitis_workspace\led_final\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Working\OndeviceAI2\260622_microblaze_GPIO\vitis_workspace\led_final\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {led_final}\
-xpfm {C:/Working/OndeviceAI2/260622_microblaze_GPIO/vitis_workspace/led_1/export/led_1/led_1.xpfm}\
-out {C:/Working/OndeviceAI2/260622_microblaze_GPIO/vitis_workspace}

platform write
platform active {led_final}
platform active {led_final}
