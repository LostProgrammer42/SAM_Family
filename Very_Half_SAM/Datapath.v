module Datapath(IReg_En, Mux_PC_Add_Sel, PC_En, IAR_En, Acc_En, IReg_Buffer_Sel, PC_Buffer_Sel, IAR_Buffer_Sel, Acc_Buffer_Sel, Mux_PC_In_Sel,
			clk, rst, Mux_Acc_In_Sel, ALU_Sel, Data_Bus, Address_Bus, IReg_Data_Out, PC_Data_Out, Acc_Data_Out);
	input IReg_En, Mux_PC_Add_Sel, PC_En, IAR_En, Acc_En, IReg_Buffer_Sel, PC_Buffer_Sel, IAR_Buffer_Sel, Acc_Buffer_Sel, Mux_PC_In_Sel, clk, rst;
	input [1:0] Mux_Acc_In_Sel, ALU_Sel;
	inout [7:0] Data_Bus;
	output reg [7:0] Address_Bus;
	output [7:0] IReg_Data_Out, PC_Data_Out, Acc_Data_Out;
	
	wire [7:0] IReg_Data_Out_Buff, PC_Data_Out_Buff, Acc_Data_Out_Buff, IAR_Data_Out_Buff;
	wire [7:0] IReg_Data_In, IAR_Data_In, Acc_Data_In, ALU_Data_Out, IAR_Data_Out;
	wire [7:0] IReg_Acc_Signal, PC_Incremented_Signal, PC_Adding_Signal, target, Abus1, Abus2, Abus3;
	
	assign IReg_Data_In = Data_Bus;
	always @({PC_Buffer_Sel, IReg_Buffer_Sel})
	begin
		if (PC_Buffer_Sel == 1'b1) Address_Bus = Abus2;
		else if (IReg_Buffer_Sel == 1'b1) Address_Bus = Abus1;
		else Address_Bus = Abus3;
	end 
	
	Pipo_Register IReg (.din(IReg_Data_In), .dout(IReg_Data_Out_Buff), .en(IReg_En), .rst(rst), .clk(clk));
	Mux_2x1_8_bit IReg_Tristate_Buffer (.I0(8'bzzzzzzzz), .I1(target), .S(IReg_Buffer_Sel), .Y(Abus1));
	assign target = {4'b0000, IReg_Data_Out_Buff[3:0]};
	
	Mux_2x1_8_bit Mux_PC_Add (.I1(8'b00000001), .I0(target), .S(Mux_PC_Add_Sel), .Y(PC_Adding_Signal));
	Mux_2x1_8_bit Mux_PC_Input_Sel (.I1(PC_Incremented_Signal), .I0(Data_Bus), .S(Mux_PC_In_Sel), .Y(PC_Data_In));
	Adder_8 Adder (.a(PC_Adding_Signal), .b(PC_Data_Out_Buff), .cin(1'b0), .s(PC_Incremented_Signal));
	Pipo_Register PC (.din(PC_Data_In), .dout(PC_Data_Out_Buff), .en(PC_En), .rst(rst), .clk(clk));
	Mux_2x1_8_bit PC_Tristate_Buffer (.I0(8'bzzzzzzzz), .I1(PC_Data_out_Buff), .S(PC_Buffer_Sel), .Y(Abus2));
	
	assign IAR_Data_In = Data_Bus;
	Pipo_Register IAR (.din(IAR_Data_In), .dout(IAR_Data_Out_Buff), .en(IAR_En), .rst(rst), .clk(clk));
	Mux_2x1_8_bit IAR_Tristate_Buffer (.I0(8'bzzzzzzzz), .I1(IAR_Data_out_Buff), .S(IAR_Buffer_Sel), .Y(Abus3));
	
	Mux_4x1_8_bit Mux_ACC (.I3(ALU_Data_Out_Buff), .I2(Data_Bus), .I1(target), .I0(8'bzzzzzzzz), .S(Mux_Acc_In_Sel), .Y(Acc_Data_In));
	Pipo_Register ACC (.din(ACC_Data_In), .dout(ACC_Data_Out_Buff), .en(ACC_En), .rst(rst), .clk(clk));
	Mux_2x1_8_bit ACC_Tristate_Buffer (.I0(8'bzzzzzzzz), .I1(ACC_Data_out_Buff), .S(ACC_Buffer_Sel), .Y(Data_Bus));
	
	ALU AL_Unit (.a(ACC_Data_out), .b(Data_bus), .y(ALU_Data_Out_Buff), .s(ALU_Sel));
	
	assign IReg_Data_Out = IReg_Data_Out_Buff;
	assign PC_Data_Out = PC_Data_Out_Buff;
	assign IAR_Data_Out = IAR_Data_Out_Buff;
	assign ACC_Data_Out = ACC_Data_Out_Buff;
endmodule
