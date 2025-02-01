module Toplevel(clk,Bus_Out,Bus_In,rst,En,Rw, pause, regSelect, dispReg ,ALE, TT_En);
	input clk, rst, pause;
	output Rw, En;
	output [7:0] Bus_Out;
	input [7:0] Bus_In;
	
	wire Rw_Duplicate;
	
	input [1:0] regSelect;
	output [7:0] dispReg;
	
	wire IReg_En, Mux_PC_Add_Sel, Mux_PC_In_Sel, PC_En, IAR_En, Acc_En, IReg_Buffer_Sel, PC_Buffer_Sel, IAR_Buffer_Sel, 
	Acc_Buffer_Sel;
	wire [7:0] Data_Bus_In;
	wire [7:0] Data_Bus_Out;
	wire [7:0] Address_Bus;
	wire [1:0] Mux_Acc_In_Sel, ALU_Sel;
	wire [7:0] IReg_Data_Out, PC_Data_Out, Acc_Data_Out;
	output wire ALE;
	wire ALE_Duplicate;
	output wire [7:0] TT_En;
	
	cpu very_half_sam
	(.IReg_En(IReg_En), .Mux_PC_Add_Sel(Mux_PC_Add_Sel), .Mux_PC_In_Sel(Mux_PC_In_Sel), .PC_En(PC_En), .IAR_En(IAR_En), 
	.Acc_En(Acc_En), .IReg_Buffer_Sel(IReg_Buffer_Sel), .PC_Buffer_Sel(PC_Buffer_Sel), .IAR_Buffer_Sel(IAR_Buffer_Sel), 
	.Acc_Buffer_Sel(Acc_Buffer_Sel), .clk(clk), .rst(rst), .Mux_Acc_In_Sel(Mux_Acc_In_Sel), .ALU_Sel(ALU_Sel), .En(En), .Rw(Rw), 
	.IReg_Data_Out(IReg_Data_Out), .PC_Data_Out(PC_Data_Out), .Acc_Data_Out(Acc_Data_Out), .regSelect(regSelect), .dispReg(dispReg), 
	.pause(pause),.ALE(ALE));
	
	 Datapath path_of_data (.IReg_En(IReg_En), .Mux_PC_Add_Sel(Mux_PC_Add_Sel), .PC_En(PC_En), .IAR_En(IAR_En), .Acc_En(Acc_En),
	.IReg_Buffer_Sel(IReg_Buffer_Sel), .PC_Buffer_Sel(PC_Buffer_Sel), .IAR_Buffer_Sel(IAR_Buffer_Sel), .Acc_Buffer_Sel(Acc_Buffer_Sel), 
	.Mux_PC_In_Sel(Mux_PC_In_Sel), .clk(clk), .rst(rst), .Mux_Acc_In_Sel(Mux_Acc_In_Sel), .ALU_Sel(ALU_Sel), .Data_Bus_In(Data_Bus_In), 
	.Data_Bus_Out(Data_Bus_Out), .Address_Bus(Address_Bus), .IReg_Data_Out(IReg_Data_Out), .PC_Data_Out(PC_Data_Out), .Acc_Data_Out(Acc_Data_Out));
	
	assign ALE_Duplicate = ALE;
	assign Rw_Duplicate = Rw;
	
	Bus_Conductor bus (.ALE(ALE_Duplicate), .bus_in(Bus_In), .bus_out(Bus_Out), .bus_en(TT_En), .addr_bus(Address_Bus), .Data_Bus_In(Data_Bus_In),
	 .Data_Bus_Out(Data_Bus_Out), .adbd(~Rw_Duplicate));
	
endmodule 