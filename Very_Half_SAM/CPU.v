module cpu 
	(IReg_En, Mux_PC_Add_Sel, Mux_PC_In_Sel, PC_En, IAR_En, 
	Acc_En, IReg_Buffer_Sel, PC_Buffer_Sel, IAR_Buffer_Sel, 
	Acc_Buffer_Sel, clk, rst, Mux_Acc_In_Sel, ALU_Sel, En, Rw, 
	IReg_Data_Out, PC_Data_Out, Acc_Data_Out, regSelect, dispReg, 
	pause);
	
	input clk, rst, pause;
	input [1:0] regSelect;
	input [7:0] IReg_Data_Out, PC_Data_Out, Acc_Data_Out;
	output reg IReg_En, Mux_PC_Add_Sel, Mux_PC_In_Sel, PC_En, IAR_En, Acc_En,
			IReg_Buffer_Sel, PC_Buffer_Sel, IAR_Buffer_Sel, Acc_Buffer_Sel,
			En, Rw;
	output reg [1:0] Mux_Acc_In_Sel, ALU_Sel;
	output reg [7:0] dispReg;
	
	parameter rstState = 5'b00000, 
				pauseState = 5'b00001, 
				fetch = 5'b00010, 
				halt = 5'b00011,
				negate = 5'b00100,
				branch = 5'b00101,
				brZero = 5'b00110,
				brPos = 5'b00111,
				brNeg = 5'b01000,
				brInd = 5'b01001,
				cLoad = 5'b01010,
				dLoad = 5'b01011,
				iLoad = 5'b01100,
				dStore = 5'b01101,
				iStore = 5'b01110,
				add = 5'b01111,
				andd = 5'b10000;
				
	reg [4:0] state;
	reg [3:0] tick;
	
	always@(*) begin
		case (regSelect)
			2'b00 : dispReg = IReg_Data_Out;
			2'b01 : dispReg = PC_Data_Out;
			2'b10 : dispReg = Acc_Data_Out;
			default : dispReg = 8'bzzzzzzzz;
		endcase
		
		case (state)
			negate : ALU_Sel = 2'b00;
			add : ALU_Sel = 2'b01;
			andd : ALU_Sel = 2'b10;
			default : ALU_Sel = 2'b11;
		endcase
	end
	
	function [4:0]decode;
		input [7:0] instr;
		begin
			case (instr[7:4])
				4'h0 : 
					case (instr[3:0])
						4'h0 : decode = halt;
						4'h1 : decode = negate;
						default : decode = halt;
					endcase
				4'h1 : decode = branch;
				4'h2 : decode = brZero;
				4'h3 : decode = brPos;
				4'h4 : decode = brNeg;
				4'h5 : decode = brInd;
				4'h6 : decode = cLoad;
				4'h7 : decode = dLoad;
				4'h8 : decode = iLoad;
				4'h9 : decode = dStore;
				4'hA : decode = iStore;
				4'hB : decode = add;
				4'hC : decode = andd;
				default : decode = halt;
			endcase
		end
	endfunction
	
	task wrapup;
		
		begin
			if (pause == 1'b1) begin
				state <= pauseState;
				tick  <= 4'h0;
			end else begin
				state <= fetch;
				tick  <= 4'h0;
			end
		end
	endtask
	
	always@(posedge clk) begin
	
		Acc_En <= 1'b0;
		IAR_En <= 1'b0;
		PC_En <= 1'b0;
		IReg_En <= 1'b0;
		Mux_PC_Add_Sel <= 1'b0;
		Mux_PC_In_Sel <= 1'b0;
		Mux_Acc_In_Sel <= 2'b00;
		
		if (rst) begin
			tick  <= 4'h0;
			state <= rstState;
		end else begin
			tick  <= tick + 1'b1;
			
			case (state)
				rstState : begin
					state <= fetch;
					tick  <= 4'h0;
				end
				pauseState : begin
					if (pause == 1'b0) begin
						state <= fetch;
						tick  <= 4'h0;
					end
				end
				fetch : begin
					Mux_PC_Add_Sel <= 1'b1;
					if (tick == 4'h0) begin
						IReg_En <= 1'b1;
						PC_En <= 1'b1;
					end else if (tick == 4'h2) begin
						state <= decode(IReg_Data_Out);
						tick  <= 4'h0;
					end
				end
				branch : begin
					if (tick == 4'h0) PC_En <= 1'b1 ;
					else if (tick == 4'h1) wrapup;
				end
				brZero : begin
					if (tick == 4'h0) begin
						if (Acc_Data_Out == 8'h00) PC_En <= 1'b1;
					end 
					else if (tick == 4'h1) wrapup;
				end
				brPos : begin
					if (tick == 4'h0) begin
						if ((Acc_Data_Out != 8'h00) && (Acc_Data_Out[7] == 1'b0)) PC_En <= 1'b1;
					end 
					else if (tick == 4'h1) wrapup;
				end
				brNeg : begin
					if (tick == 4'h0) begin
						if (Acc_Data_Out[7] == 1'b1) PC_En <= 1'b1;
					end 
					else if (tick == 4'h1) wrapup;
				end
				brInd : begin
					if (tick == 4'h0) PC_En <= 1'b1;
					else if (tick == 4'h2) begin
						Mux_PC_In_Sel <= 1'b1;
						PC_En <= 1'b1;
					end else if (tick == 4'h3) wrapup;
				end
				cLoad : begin
					if (tick == 4'h0) begin
						Mux_Acc_In_Sel <= 2'b01;
						Acc_En <= 1'b1;
					end 
					else if (tick == 4'h1) wrapup;
				end
				dLoad : begin
					if (tick == 4'h1) begin
						Mux_Acc_In_Sel <= 2'b01;
						Acc_En <= 1'b1;
						wrapup;
					end 
				end
				iLoad : begin
					if (tick == 4'h0) IAR_En <= 1'b1;
					else if (tick == 4'h3) begin
						Mux_Acc_In_Sel <= 2'b10;
						Acc_En <= 1'b1;
					end else if (tick == 4'h4) wrapup;
				end
				dStore : begin
					if (tick == 4'h2) wrapup;
				end
				iStore : begin
					if (tick == 4'h0) IAR_En <= 1'b1;
					else if (tick == 4'h3) wrapup;
				end
				negate : begin
					if (tick == 4'h1) begin
						Mux_Acc_In_Sel <= 2'b11;
						Acc_En <= 1'b1;
					end else if (tick == 4'h2) wrapup;
				end
				add : begin
					if (tick == 4'h1) begin
						Mux_Acc_In_Sel <= 2'b11;
						Acc_En <= 1'b1;
					end else if (tick == 4'h2) wrapup;
				end
				andd : begin
					if (tick == 4'h1) begin
						Mux_Acc_In_Sel <= 2'b11;
						Acc_En <= 1'b1;
					end else if (tick == 4'h2) wrapup;
				end
				default : state <= halt;
			endcase
		end
	end
	
	always@(state or tick) begin
	
		En <= 1'b0; 
		Rw <= 1'b1;
		PC_Buffer_Sel <= 1'b0;
		IReg_Buffer_Sel <= 1'b0;
		IAR_Buffer_Sel <= 1'b0;
		Acc_Buffer_Sel <= 1'b0;
		
		case (state)
			fetch : begin
				if (tick == 4'h0) begin
					En <= 1'b1;
					PC_Buffer_Sel <= 1'b1;
				end else if (tick == 4'h2) En <= 1'b1;
			end
			brInd : begin
				if (tick == 4'h2) begin
					En <= 1'b1;
					PC_Buffer_Sel <= 1'b1;
				end
			end
			dLoad : begin
				if (tick == 4'h0) begin
					En <= 1'b1;
					IReg_Buffer_Sel <= 1'b1;
				end
			end
			add : begin
				if (tick == 4'h0) begin
					En <= 1'b1;
					IReg_Buffer_Sel <= 1'b1;
				end
			end
			andd : begin
				if (tick == 4'h0) begin
					En <= 1'b1;
					IReg_Buffer_Sel <= 1'b1;
				end
			end
			iLoad : begin
				if (tick == 4'h0) begin
					En <= 1'b1;
					IReg_Buffer_Sel <= 1'b1;
				end else if (tick == 4'h2) begin
					En <= 1'b1;
					IAR_Buffer_Sel <= 1'b1;
				end
			end
			dStore : begin
				if (tick == 4'h0) begin
					En <= 1'b1;
				end else if (tick == 4'h1) begin
					En <= 1'b1;
					Rw <= 1'b0;
					IReg_Buffer_Sel <= 1'b1;
					Acc_Buffer_Sel <= 1'b1;
				end
			end
			iStore : begin
				if (tick == 4'h0) begin
					En <= 1'b1;
					IReg_Buffer_Sel <= 1'b1;
				end else if (tick == 4'h1) begin
					En <= 1'b1;
				end else if (tick == 4'h2) begin
					En <= 1'b1;
					Rw <= 1'b0;
					IAR_Buffer_Sel <= 1'b1;
					Acc_Buffer_Sel <= 1'b1;
				end
			end
			default : begin
			end
		endcase
	end
		
endmodule 