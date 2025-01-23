module Toplevel(clk,Data_Bus,Address_Bus,rst,Rw,En, pause, regSelect, dispReg);
	input clk, rst, pause;
	output Rw, En;
	output [7:0] Address_Bus;
	inout [7:0] Data_Bus;
	
	input [1:0] regSelect;
	output [7:0] dispReg;
	
	wire IReg_En, Mux_PC_Add_Sel, Mux_PC_In_Sel, PC_En, IAR_En, Acc_En, IReg_Buffer_Sel, PC_Buffer_Sel, IAR_Buffer_Sel, 
	Acc_Buffer_Sel, regSelect, dispReg, pause;
	
	wire [1:0] Mux_Acc_In_Sel, ALU_Sel;
	wire [7:0] IReg_Data_Out, PC_Data_Out, Acc_Data_Out;
	
	cpu very_half_sam
	(.IReg_En(IReg_En), .Mux_PC_Add_Sel(Mux_PC_Add_Sel), .Mux_PC_In_Sel(Mux_PC_In_Sel), .PC_En(PC_En), .IAR_En(IAR_En), 
	.Acc_En(Acc_En), .IReg_Buffer_Sel(IReg_Buffer_Sel), .PC_Buffer_Sel(PC_Buffer_Sel), .IAR_Buffer_Sel(IAR_Buffer_Sel), 
	.Acc_Buffer_Sel(Acc_Buffer_Sel), .clk(clk), .rst(rst), .Mux_Acc_In_Sel(Mux_Acc_In_Sel), .ALU_Sel(ALU_Sel), .En(En), .Rw(Rw), 
	.IReg_Data_Out(IReg_Data_Out), .PC_Data_Out(PC_Data_Out), .Acc_Data_Out(Acc_Data_Out), .regSelect(regSelect), .dispReg(dispReg), 
	.pause(pause));
	
	 Datapath path_of_data (.IReg_En(IReg_En), .Mux_PC_Add_Sel(Mux_PC_Add_Sel), .PC_En(PC_En), .IAR_En(IAR_En), .Acc_En(Acc_En),
	.IReg_Buffer_Sel(IReg_Buffer_Sel), .PC_Buffer_Sel(PC_Buffer_Sel), .IAR_Buffer_Sel(IAR_Buffer_Sel), .Acc_Buffer_Sel(Acc_Buffer_Sel), 
	.Mux_PC_In_Sel(Mux_PC_In_Sel), .clk(clk), .rst(rst), .Mux_Acc_In_Sel(Mux_Acc_In_Sel), .ALU_Sel(ALU_Sel), .Data_Bus(Data_Bus), 
	.Address_Bus(Address_Bus), .IReg_Data_Out(IReg_Data_Out), .PC_Data_Out(PC_Data_Out), .Acc_Data_Out(Acc_Data_Out));
	
endmodule 