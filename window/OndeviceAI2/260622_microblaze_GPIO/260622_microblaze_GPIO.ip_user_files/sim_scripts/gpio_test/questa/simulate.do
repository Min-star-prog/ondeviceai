onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib gpio_test_opt

do {wave.do}

view wave
view structure
view signals

do {gpio_test.udo}

run -all

quit -force
