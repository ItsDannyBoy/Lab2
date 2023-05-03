
if {[file exists sim/work]} {
    vdel -all
}
vlib work
vcom ../src/shift_register.vhd
vcom ../src/shift_register_tb.vhd
vsim shift_register_tb
add wave -group shift_register shift_register_tb/uut/*
config wave -signalnamewidth 1
#restart -f
run 1300 ns
#run -all