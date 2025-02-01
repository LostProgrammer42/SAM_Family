module Bus_Conductor (ALE, bus_in, bus_out, bus_en, addr_bus, Data_Bus_In, Data_Bus_Out, adbd);
	input ALE, adbd;
	output reg [7:0] bus_en;
	input [7:0] bus_in;
	output reg [7:0] bus_out;
	input [7:0] addr_bus; 
	output reg [7:0] Data_Bus_In; // CPU ko janne waala
	input [7:0] Data_Bus_Out; // CPU se aane waala
	
	always @(*)
	begin
		if(ALE == 1'b1) begin
			bus_en = 8'b11111111;
			bus_out = addr_bus;
			Data_Bus_In = 8'bzzzzzzzz;
		end
		else if(adbd == 1'b1) begin
			bus_en = 8'b11111111;
			bus_out = Data_Bus_Out;
			Data_Bus_In = 8'bzzzzzzzz;
		end
		else begin
			bus_en = 8'b00000000;
			bus_out = 8'bzzzzzzzz;
			Data_Bus_In = bus_in;
		end
	end
endmodule
	