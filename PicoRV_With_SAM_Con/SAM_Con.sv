module SAM_Con #(parameter MAX_KERNEL_SIZE = 16)(STRIDE,KERNEL_SIZE,En,Data_in,Data_Out,Kernel_Serial_Input,Last_Data_In,Last_Data_Out,Clk,Rst);
	input wire [31:0] Data_in;
	output reg [31:0] Data_Out;
	input wire [1:0] Kernel_Serial_Input;
	input wire Last_Data_In, Clk, Rst;
	output reg Last_Data_Out;
	input wire[7:0] STRIDE;
	input wire[7:0] KERNEL_SIZE;
	input wire En;
	
	reg [31:0] Data_Out_Temp;
	reg [1:0] Kernel [MAX_KERNEL_SIZE-1:0];
	reg [31:0] Data_Cache [MAX_KERNEL_SIZE-1:0];
	
	parameter Initial_State = 2'b00, Wait_State = 2'b01, Computation_State = 2'b10, Wrapup_State = 2'b11;
	reg [1:0] State;
	
	reg [7:0] Counter; //Max Kernel Size Supported: 256 Elements
	
	always@(posedge Clk) begin
		if (Rst == 1'b1) begin
			State <= Initial_State;
			Data_Out <= 32'bZ;
			Last_Data_Out <= 1'b0;
			Counter <= 8'b0;
			for (int i = 0; i < MAX_KERNEL_SIZE-1; i = i + 1) begin
				Kernel[i] <= 2'b0;
				Data_Cache[i] <= 32'b0;
			end
			Data_Out_Temp = 32'b0;
			
		end else begin
			case (State)
				Initial_State: begin
					if (En == 1'b1) begin
						if (Counter == KERNEL_SIZE[7:0] - 1) begin
							State <= Computation_State;
						end else begin
							State <= Initial_State;
						end
						for (int i = 0; i < MAX_KERNEL_SIZE - 1; i = i + 1) begin
							Data_Cache[i] <= Data_Cache[i + 1]; // Correctly shift elements down
						end
						Data_Cache[KERNEL_SIZE-1] <= Data_in; // Insert new data at the latest position
						
						for (int i = 0; i < MAX_KERNEL_SIZE-1; i = i + 1) begin
							Kernel[i] <= Kernel[i + 1];
						end
						Kernel[KERNEL_SIZE-1] <= Kernel_Serial_Input;

						Counter <= Counter + 1;
					end
				end
				
				Computation_State: begin
					Counter <= 8'b0;
					//Shifting Logic
					if (En == 1'b1) begin
						for (int i = 0; i < MAX_KERNEL_SIZE - 1; i = i + 1) begin
							Data_Cache[i] <= Data_Cache[i + 1]; //Lower (0 is lower than 1) Index stores older value
						end
						Data_Cache[KERNEL_SIZE-1] <= Data_in;
					end
					// Computation Logic
					Data_Out_Temp = 32'b0;
               for (int i = 0; i < KERNEL_SIZE[3:0]; i = i + 1) begin
						if (Kernel[KERNEL_SIZE[3:0] - i - 1] == 2'b01) begin
							Data_Out_Temp = Data_Out_Temp + Data_Cache[i];
						end else if(Kernel[KERNEL_SIZE[3:0] - i - 1] == 2'b11) begin
							Data_Out_Temp = Data_Out_Temp - Data_Cache[i];
						end
					end
					Data_Out = Data_Out_Temp;
					
					
					if (Last_Data_In == 1'b1) begin
						State <= Wrapup_State;
					end else if (STRIDE == 1) begin
						State <= Computation_State;
					end else begin
						State <= Wait_State;
					end
					
				end
				Wait_State: begin
					if (En == 1'b1) begin
						for (int i = 0; i < MAX_KERNEL_SIZE - 1; i = i + 1) begin
							Data_Cache[i] <= Data_Cache[i + 1]; //Lower (0 is lower than 1) Index stores older value
						end
						Data_Cache[KERNEL_SIZE-1] <= Data_in;
						
						if (Last_Data_In == 1'b1) begin
							State <= Wrapup_State;
						end else if (Counter == STRIDE[7:0] - 1) begin
							State <= Computation_State;
						end else begin
							State <= Wait_State;
						end
							Counter <= Counter + 1;
					end
				end
				
				Wrapup_State: begin
					Last_Data_Out <= 1'b1;
					State <= Wrapup_State;
				end
			endcase
		end 
	end

endmodule 