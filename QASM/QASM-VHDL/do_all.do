vlib work
#cp ../QASM-Interpreter/program.mem .
vcom txt_util.vhd COMPLEX.vhd QUANTUM_SYSTEMS.vhd q_generator.vhd qgate1.vhd qgate2.vhd Rkqgate1.vhd CRkqgate2.vhd qmeasure.vhd qalu.vhd qprocessor.vhd testbench.vhd 
vsim -novopt testbench
do wave.do