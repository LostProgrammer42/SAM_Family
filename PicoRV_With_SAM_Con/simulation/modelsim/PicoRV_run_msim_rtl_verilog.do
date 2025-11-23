transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+E:/Semester_4/Hardware_Description_Languages/PicoRV_With_SAM_Con {E:/Semester_4/Hardware_Description_Languages/PicoRV_With_SAM_Con/SAM_Con.sv}
vlog -sv -work work +incdir+E:/Semester_4/Hardware_Description_Languages/PicoRV_With_SAM_Con {E:/Semester_4/Hardware_Description_Languages/PicoRV_With_SAM_Con/picorv32.sv}
vlog -sv -work work +incdir+E:/Semester_4/Hardware_Description_Languages/PicoRV_With_SAM_Con {E:/Semester_4/Hardware_Description_Languages/PicoRV_With_SAM_Con/SAM_Con_Wrapper.sv}
vlog -sv -work work +incdir+E:/Semester_4/Hardware_Description_Languages/PicoRV_With_SAM_Con {E:/Semester_4/Hardware_Description_Languages/PicoRV_With_SAM_Con/toplevel.sv}

vlog -vlog01compat -work work +incdir+E:/Semester_4/Hardware_Description_Languages/PicoRV_With_SAM_Con {E:/Semester_4/Hardware_Description_Languages/PicoRV_With_SAM_Con/testbench_ez.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench_ez

add wave *
view structure
view signals
run 200 us
