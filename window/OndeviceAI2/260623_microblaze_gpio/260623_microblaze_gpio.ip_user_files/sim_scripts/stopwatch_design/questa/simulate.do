onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib stopwatch_design_opt

do {wave.do}

view wave
view structure
view signals

do {stopwatch_design.udo}

run -all

quit -force
