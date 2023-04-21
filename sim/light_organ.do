
if {[file exists sim/work]} {
    vdel -all
}
vlib work
vcom ../src/shift_register.vhd
vcom ../src/pulse_generator.vhd
vcom ../src/light_organ.vhd
vcom ../src/light_organ_tb.vhd
vsim light_organ_tb
add wave -group light_organ light_organ_tb/uut/*
add wave -group shift light_organ_tb/uut/shift_reg/*
add wave -group gen light_organ_tb/uut/pulse_gen/*
#restart -f
run 1500 ns
#run -all