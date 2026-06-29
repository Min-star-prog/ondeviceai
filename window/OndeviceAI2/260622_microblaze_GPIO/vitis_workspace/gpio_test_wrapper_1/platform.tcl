# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Working\OndeviceAI2\260622_microblaze_GPIO\vitis_workspace\gpio_test_wrapper_1\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Working\OndeviceAI2\260622_microblaze_GPIO\vitis_workspace\gpio_test_wrapper_1\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {gpio_test_wrapper_1}\
-hw {C:\Working\OndeviceAI2\260622_microblaze_GPIO\XSA\gpio_test_wrapper_1.xsa}\
-fsbl-target {psu_cortexa53_0} -out {C:/Working/OndeviceAI2/260622_microblaze_GPIO/vitis_workspace}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {gpio_test_wrapper_1}
platform generate -quick
platform generate
