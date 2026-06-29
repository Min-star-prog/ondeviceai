# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Working\OndeviceAI2\260623_microblaze_gpio\vitis_workspace\stopwatch_design_wrapper\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Working\OndeviceAI2\260623_microblaze_gpio\vitis_workspace\stopwatch_design_wrapper\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {stopwatch_design_wrapper}\
-hw {C:\Working\OndeviceAI2\260623_microblaze_gpio\XSA\stopwatch_design_wrapper.xsa}\
-fsbl-target {psu_cortexa53_0} -out {C:/Working/OndeviceAI2/260623_microblaze_gpio/vitis_workspace}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {stopwatch_design_wrapper}
platform generate -quick
platform generate
