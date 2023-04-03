vcom ../src/pulse_generator.vhd
vsim pulse_generator
add wave -group my_group pulse_generator/*
restart -f
force D_IN1 00000001
force D_IN2 00000011
force D_IN3 00000111
force D_IN4 00001111
force SEL 00 20ns, 01 40ns, 10 60ns, 11 80ns
run 100 ns