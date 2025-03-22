transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/SAM_Con {E:/Semester_4/Hardware_Description_Languages/SAM_Con/SAM_Con.v}

vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/SAM_Con {E:/Semester_4/Hardware_Description_Languages/SAM_Con/Testbench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  Testbench

add wave *
view structure
view signals
run -all
