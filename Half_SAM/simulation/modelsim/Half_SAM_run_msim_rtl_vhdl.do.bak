transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/manan/Documents/EE721/Half_SAM/RCAS.vhd}
vcom -93 -work work {C:/Users/manan/Documents/EE721/Half_SAM/full_adder_nand.vhd}
vcom -93 -work work {C:/Users/manan/Documents/EE721/Half_SAM/Toplevel.vhd}
vcom -93 -work work {C:/Users/manan/Documents/EE721/Half_SAM/PIPO_Register.vhd}
vcom -93 -work work {C:/Users/manan/Documents/EE721/Half_SAM/Datapath.vhd}
vcom -93 -work work {C:/Users/manan/Documents/EE721/Half_SAM/D_Flip_Flop.vhd}
vcom -93 -work work {C:/Users/manan/Documents/EE721/Half_SAM/CPU.vhd}
vcom -93 -work work {C:/Users/manan/Documents/EE721/Half_SAM/And_8.vhd}
vcom -93 -work work {C:/Users/manan/Documents/EE721/Half_SAM/ALU.vhd}
vcom -93 -work work {C:/Users/manan/Documents/EE721/Half_SAM/4_X_1_Mux_8_bit.vhd}
vcom -93 -work work {C:/Users/manan/Documents/EE721/Half_SAM/2_X_1_Mux_8_Bit.vhd}
vcom -93 -work work {C:/Users/manan/Documents/EE721/Half_SAM/2_X_1_Mux.vhd}

vcom -93 -work work {C:/Users/manan/Documents/EE721/Half_SAM/CPU_testbench.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  CPU_testbench

add wave *
view structure
view signals
run -all
