
if {[file exists sim/work]} {
    vdel -all
}
vlib work
vcom ../src/light_organ.vhd
vcom ../src/light_organ_tb.vhd
vsim light_organ_tb
add wave -group light_organ light_organ_tb/uut/*
#restart -f
run 1300 ns
#run -all