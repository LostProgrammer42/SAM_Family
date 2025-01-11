transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/CPU.vhd}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/And_16.vhd}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/4_X_1_Mux_16_bit.vhd}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/2_X_1_Mux_16_Bit.vhd}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/preprocessing.vhd}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/postprocessing.vhd}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/kogge_stone_node.vhd}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/Kogge_stone_adder_subtractor.vhd}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/kogge_stone.vhd}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/2_X_1_Mux.vhd}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/PIPO_Register.vhd}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/D_Flip_Flop.vhd}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/Datapath.vhdl}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/ALU.vhd}
vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/Toplevel.vhd}

vcom -93 -work work {E:/Semester_4/Hardware_Description_Languages/WASHU_2_CPU/CPU_testbench.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  CPU_Testbench

add wave *
view structure
view signals
run 2 us
