-- cd {C:\Users\user\OneDrive - ort braude college of engineering\B.sc\Year 4\Semester B\VHDL\Labs\VHDL\Lab 2\sim}
-- vlib work
vcom ../src/pulse_generator.vhd 
vcom ../src/pulse_generator_tb.vhd 

vsim pulse_generator_tb

add wave -group pulse_generator_test pulse_generator_tb/dut/*
config wave -signalnamewidth 1
--restart -f


run 2000 ms