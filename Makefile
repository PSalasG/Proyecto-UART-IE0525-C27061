uart: 
	rm -rf *.vcd *.vvp *.out
	iverilog -o tb.vvp testbench.v
	vvp tb.vvp 
	gtkwave proyecto.vcd

clear:
	rm -rf *.vcd *.vvp *.out