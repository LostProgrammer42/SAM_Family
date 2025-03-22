module SAM_Con #(parameter KERNEL_SIZE = 8, STRIDE = 1)(Data_in,Data_Out,Kernel_Serial_Input,Last_Data_In,Last_Data_Out,Clk,Rst);
	input [31:0] Data_in;
	output reg [31:0] Data_Out;
	input [1:0] Kernel_Serial_Input;
	input Last_Data_In, Clk, Rst;
	output reg Last_Data_Out;
	
	wire [1:0] Kernel [KERNEL_SIZE-1:0];
	reg [31:0] Data_Cache [KERNEL_SIZE:0];
	
	parameter Initial_State = 2'b00, Wait_State = 2'b01, Computation_State = 2'b10, Wrapup_State = 2'b11;
	reg [1:0] State;
	
	reg [7:0] Counter; //Max Kernel Size Supported: 256 Bits
	
	always@(posedge Clk) begin
		if (Rst == 1'b1) begin
			State <= Initial_State;
			Data_Out <= 32'bZ;
			Last_Data_Out <= 1'b0;
			Counter <= 8'b0;
		end else begin
			case (State)
				Initial_State: begin
					if (Counter == KERNEL_SIZE[7:0] - 1) begin
						State <= Computation_State;
					end else begin
						State <= Initial_State;
					end
					Data_Cache[Counter] <= Data_in;
					Kernel[Counter] <= Kernel_Serial_Input;
					Counter <= Counter + 1;
				end
				
				Computation_State: begin
					Counter <= 8'b0;
					//Shifting Logic
					for (integer i = 0; i < KERNEL_SIZE; i = i + 1) begin
						Data_Cache[i] <= Data_Cache[i + 1]; //Lower (0 is lower than 1) Index stores older value
					end
					Data_Cache[KERNEL_SIZE] <= Data_in;
					// Computation Logic
					Data_Out = 32'b0;
               for (integer i = 0; i < KERNEL_SIZE; i = i + 1) begin
						Data_Out = Data_Out + Data_Cache[i];
					end
					if (Last_Data_In == 1'b1) begin
						State <= Wrapup_State;
					end else if (STRIDE == 1) begin
						State <= Computation_State;
					end else begin
						State <= Wait_State;
					end
					
				end
				Wait_State: begin
					for (integer i = 0; i < KERNEL_SIZE; i = i + 1) begin
						Data_Cache[i] <= Data_Cache[i + 1]; //Lower (0 is lower than 1) Index stores older value
					end
					Data_Cache[KERNEL_SIZE] <= Data_in;
					
					if (Last_Data_In == 1'b1) begin
						State <= Wrapup_State;
					end else if (Counter == STRIDE[7:0] - 1) begin
						State <= Computation_State;
					end else begin
						State <= Wait_State;
					end
					Counter <= Counter + 1;
					
				end
				
				Wrapup_State: begin
					Last_Data_Out <= 1'b0;
					State <= Wrapup_State;
				end
			endcase
		end 
	end
endmodule 