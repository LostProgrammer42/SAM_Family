// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

`timescale 1 ns / 1 ps

module testbench_ez;
	reg clk = 1;
	reg resetn = 0;
	wire trap;

	always #5 clk = ~clk;

	initial begin
		repeat (100) @(posedge clk);
		resetn <= 1;
		repeat (1000) @(posedge clk);
	end

	wire mem_valid;
	wire mem_instr;
	reg mem_ready;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0] mem_wstrb;
	reg  [31:0] mem_rdata;
	
	wire mem_en_SAM;
	wire[3:0] mem_wstrb_SAM;
	reg[31:0] mem_rdata_SAM;
	wire[31:0] mem_addr_SAM, mem_wdata_SAM;

	always @(posedge clk) begin
		if (mem_valid && mem_ready) begin
			if (mem_instr)
				$display("ifetch 0x%08x: 0x%08x", mem_addr, mem_rdata);
			else if (mem_wstrb)
				$display("write  0x%08x: 0x%08x (wstrb=%b)", mem_addr, mem_wdata, mem_wstrb);
			else
				$display("read   0x%08x: 0x%08x", mem_addr, mem_rdata);
		end
	end

	 toplevel uut (.clk(clk), .resetn(resetn), .trap(trap), .mem_valid(mem_valid), .mem_instr(mem_instr), .mem_ready(mem_ready), .mem_addr(mem_addr),
						.mem_wdata(mem_wdata), .mem_wstrb(mem_wstrb), .mem_rdata(mem_rdata), .mem_en_SAM(mem_en_SAM), .mem_wstrb_SAM(mem_wstrb_SAM), 
					   .mem_addr_SAM(mem_addr_SAM), .mem_rdata_SAM(mem_rdata_SAM), .mem_wdata_SAM(mem_wdata_SAM));
					  
					  
	reg [31:0] memory [0:255];

	initial begin
		memory[0] =  32'b 00000000000000010000000101000011; //Data_Size = 6, Kernel_Size = 2
		memory[1] =  32'b 00000000000000000000000011000111; //Stride = 1
		memory[2] =  32'b 00000000000000000000100101001011; //Output_Location = 18
		memory[3] =  32'b 00000000000000000000010101001111; //Input_Location = 10;
		
		memory[10] = 32'b 00000000000000000000000000000011; //Kernel
		memory[11] = 32'h 00000003; //Data Point 1     
		memory[12] = 32'h 00000004; //Data Point 2 
		memory[13] = 32'h 00000005; //Data Point 3
		memory[14] = 32'h 00000003; //Data Point 4     
		memory[15] = 32'h 00000004; //Data Point 5 
		memory[16] = 32'h 00000005; //Data Point 6
	end
	
	always @(posedge clk) begin
		if (mem_en_SAM == 1'b0) begin
			mem_ready <= 0;
			if (mem_valid) begin
				if (mem_addr < 1024) begin
					mem_ready <= 1;
					mem_rdata <= memory[mem_addr >> 2];
					if (mem_wstrb[0]) memory[mem_addr >> 2][ 7: 0] <= mem_wdata[ 7: 0];
					if (mem_wstrb[1]) memory[mem_addr >> 2][15: 8] <= mem_wdata[15: 8];
					if (mem_wstrb[2]) memory[mem_addr >> 2][23:16] <= mem_wdata[23:16];
					if (mem_wstrb[3]) memory[mem_addr >> 2][31:24] <= mem_wdata[31:24];
				end
			end
		end else begin
			if (mem_addr_SAM < 1024) begin
				mem_ready <= 1;
				mem_rdata_SAM <= memory[mem_addr_SAM >> 2];
				if (mem_wstrb_SAM[0]) memory[mem_addr_SAM >> 2][ 7: 0] <= mem_wdata_SAM[ 7: 0];
				if (mem_wstrb_SAM[1]) memory[mem_addr_SAM >> 2][15: 8] <= mem_wdata_SAM[15: 8];
				if (mem_wstrb_SAM[2]) memory[mem_addr_SAM >> 2][23:16] <= mem_wdata_SAM[23:16];
				if (mem_wstrb_SAM[3]) memory[mem_addr_SAM >> 2][31:24] <= mem_wdata_SAM[31:24];
			end
		end
	end
endmodule
