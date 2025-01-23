transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM {E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM/AND_8.v}
vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM {E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM/Adder_8.v}
vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM {E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM/Mux_2x1_8_bit.v}
vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM {E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM/Mux_2x1_1_bit.v}
vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM {E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM/Mux_4x1_8_bit.v}
vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM {E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM/D_Flip_Flop.v}
vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM {E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM/Pipo_Register.v}
vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM {E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM/ALU.v}
vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM {E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM/Datapath.v}
vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM {E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM/CPU.v}
vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM {E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM/Toplevel.v}

vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM {E:/Semester_4/Hardware_Description_Languages/Very_Half_SAM/Testbench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  Testbench

add wave *
view structure
view signals
run -all
