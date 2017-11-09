onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /testbench/qprocessor1/exec
add wave -noupdate -format Literal -radix hexadecimal /testbench/inst_memory
add wave -noupdate -format Literal -radix decimal /testbench/qprocessor1/qalu1/qinstruction
add wave -noupdate -format Literal /testbench/qopcode
add wave -noupdate -format Literal -radix decimal /testbench/parameter1
add wave -noupdate -format Literal -radix unsigned /testbench/address1
add wave -noupdate -format Literal -radix unsigned /testbench/address2
add wave -noupdate -format Literal /testbench/qprocessor1/qmemory
add wave -noupdate -format Literal /testbench/qprocessor1/measurement_reg
add wave -noupdate -format Literal /testbench/counter
add wave -noupdate -format Logic /testbench/clock
add wave -noupdate -format Logic /testbench/reset
add wave -noupdate -format Literal /testbench/qprocessor1/qalu1/cs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1747 ns} 0}
configure wave -namecolwidth 282
configure wave -valuecolwidth 69
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {363 ns} {2823 ns}
