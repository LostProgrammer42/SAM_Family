module SAM_Con_Wrapper (pcpi_valid_SAM, pcpi_insn_SAM, pcpi_wait_SAM, pcpi_ready_SAM, mem_en_SAM, mem_wstrb_SAM, mem_addr_SAM, mem_rdata_SAM, 
mem_wdata_SAM, Clk, Rst);
	input wire pcpi_valid_SAM;
	input wire[31:0] pcpi_insn_SAM;
	output reg pcpi_wait_SAM;
	output reg pcpi_ready_SAM;
	output reg mem_en_SAM;
	output reg[3:0] mem_wstrb_SAM;
	output reg[31:0] mem_addr_SAM;
	input reg[31:0] mem_rdata_SAM;
	output reg[31:0] mem_wdata_SAM;
	input wire Clk;
	input wire Rst;
	
	reg[16:0] Data_Size;
	reg[7:0] Kernel_Size;
	reg[7:0] Stride;
	reg[31:0] Input_Location;
	reg[31:0] Output_Location;
	reg[31:0] Kernel = 32'b0;
	
	reg Start_Con = 1'b0;
	reg SAM_Con_En = 1'b0;
	reg SAM_Con_rst = 1'b1;
	reg Last_Data_In;
	reg[31:0] Data_In, Read_Store;
	reg[31:0] Data_Out;
	reg[1:0] Kernel_Serial_Input;
	integer counter = 0;
	reg[1:0] sub_counter = 2'b0;
	reg[7:0] Stride_counter = 8'b0;
	reg sup_counter = 1'b0;
	always@(posedge Clk) begin
		mem_en_SAM = 1'b0;
		pcpi_ready_SAM = 1'b0;
		mem_wstrb_SAM = 4'b0000;
		if(pcpi_valid_SAM == 1'b1) begin
			if(Start_Con == 1'b0) begin
				case(pcpi_insn_SAM[6:2])
					5'b10000: begin //Data Size and Kernel Size | 31-15: Data Size, 14-7: Kernel Size, 6-2: Opcode, 1-0: Unused 
						Data_Size = pcpi_insn_SAM[31:15];
						Kernel_Size = pcpi_insn_SAM[14:7];
						Start_Con <= 1'b0;
						pcpi_ready_SAM <= 1'b1;
						pcpi_wait_SAM <= 1'b0;
					end
					5'b10001: begin //Stride and Page Select | 31-29: Unused, 28-22: Input Location 7 MSBS, 21-15: Output Location 7 MSBS, 14-7: Stride, 6-2: Opcode, 1-0: Unused 
						Stride = pcpi_insn_SAM[14:7];
						Input_Location[31:25] = pcpi_insn_SAM[28:22];
						Output_Location[31:25] = pcpi_insn_SAM[21:15];
						Start_Con <= 1'b0;
						pcpi_ready_SAM <= 1'b1;
						pcpi_wait_SAM <= 1'b0;
					end
					5'b10010: begin //Output Location | 31-7: Output Location Remaining 25 LSBs, 6-2: Opcode, 1-0: Unused
						Output_Location[24:0] = pcpi_insn_SAM[31:7];
						Start_Con <= 1'b0;
						pcpi_ready_SAM <= 1'b1;
						pcpi_wait_SAM <= 1'b0;
					end
					5'b10011: begin //Kernel + input data location (also acts as the start) | 31-7: Input Location Remaining 25 LSBs, 6-2: Opcode, 1-0: Unused
						Input_Location[24:0] = pcpi_insn_SAM[31:7];
						Start_Con <= 1'b1;
						pcpi_ready_SAM <= 1'b0;
						pcpi_wait_SAM <= 1'b1;
					end
					default: begin 
						pcpi_ready_SAM <= 1'b0;
						pcpi_wait_SAM <= 1'b0;
					end
				endcase
				SAM_Con_rst = 1'b1;
			end else begin
				if (sup_counter ==  1'b0) begin
					sup_counter = 1'b1;
					SAM_Con_En = 1'b0;
				end else begin
					sup_counter = 1'b0;
					if (counter == 0) begin
						mem_en_SAM = 1'b1;
						mem_addr_SAM = Input_Location << 2;
						Input_Location = Input_Location + 1;
						counter = counter + 1;
						SAM_Con_En = 1'b0;
					end else if (counter == 1) begin
						Kernel = mem_rdata_SAM;
						mem_en_SAM = 1'b1;
						mem_addr_SAM = Input_Location << 2;
						Input_Location = Input_Location + 1;
						counter = counter + 1; 
						SAM_Con_En = 1'b0;
					end else if (counter < Kernel_Size + 2) begin
						Data_In = mem_rdata_SAM;
						Kernel_Serial_Input = Kernel[2*counter-3 -: 2];
						mem_en_SAM = 1'b1;
						mem_addr_SAM = Input_Location << 2;
						Input_Location = Input_Location + 1;
						counter = counter + 1; //KS = 2 | 0, 1, 2, 3, 4
						SAM_Con_En = 1'b1;
						if (counter == Data_Size + 1) begin
							Last_Data_In = 1'b0;
						end
					end else if (counter < Data_Size + 2) begin
						if (counter == Data_Size + 1) begin
							Last_Data_In = 1'b0;
						end
						
						if (sub_counter == 2'b00) begin
							Read_Store = mem_rdata_SAM;
							SAM_Con_En = 1'b0;
							sub_counter = 2'b01;
							
						end else if (sub_counter == 2'b01 && Stride_counter == 0) begin
							sub_counter = 2'b10;
							SAM_Con_En = 1'b0;
							mem_wdata_SAM = Data_Out;
							mem_en_SAM = 1'b1;
							mem_addr_SAM = Output_Location << 2;
							Output_Location = Output_Location + 1;
							mem_wstrb_SAM = 4'b1111;
						end else begin
							Data_In = Read_Store;
							mem_en_SAM = 1'b1;
							mem_addr_SAM = Input_Location << 2;
							Input_Location = Input_Location + 1;
							mem_wstrb_SAM = 4'b0000;
							sub_counter = 2'b00;
							SAM_Con_En = 1'b1;
							counter = counter + 1;
							Stride_counter = (Stride_counter + 1) % Stride;
						end
					end else if (counter == Data_Size + 2) begin
						mem_wdata_SAM = Data_Out;
							mem_en_SAM = 1'b1;
							mem_addr_SAM = Output_Location << 2;
							mem_wstrb_SAM = 4'b1111;
					end else begin
						SAM_Con_En = 1'b1;
						Start_Con = 1'b0;
						pcpi_ready_SAM = 1'b1;
						pcpi_wait_SAM = 1'b0;
					end
				end
			end
		end
	end
	//SAM CON instantiation
	SAM_Con Convolutioner (.STRIDE(Stride), .KERNEL_SIZE(Kernel_Size), .En(SAM_Con_En), .Data_in(Data_In), .Data_Out(Data_Out), .Kernel_Serial_Input(Kernel_Serial_Input), .Last_Data_In(Last_Data_In), .Last_Data_Out(), .Clk(Clk), .Rst(SAM_Con_Rst | ~Rst));

endmodule 