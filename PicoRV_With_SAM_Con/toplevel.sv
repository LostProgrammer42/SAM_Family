module toplevel (clk, resetn, trap, mem_valid, mem_instr, mem_ready, mem_addr, mem_wdata, mem_wstrb, mem_rdata, mem_en_SAM, mem_wstrb_SAM, 
					  mem_addr_SAM, mem_rdata_SAM, mem_wdata_SAM);
					  
	input wire clk, resetn;
	input wire trap;
	output wire mem_valid;
	output wire mem_instr;
	input reg mem_ready;
	output wire [31:0] mem_addr;
	output wire [31:0] mem_wdata;
	output wire [3:0] mem_wstrb;
	input reg  [31:0] mem_rdata;
	
	wire[31:0] pcpi_insn;
	wire pcpi_wait, pcpi_ready, pcpi_valid;
	
	output wire mem_en_SAM;
	output wire[3:0] mem_wstrb_SAM;
	input reg[31:0] mem_rdata_SAM;
	output wire[31:0] mem_addr_SAM, mem_wdata_SAM;
	
	picorv32 uut (
		.clk(clk), .resetn(resetn), .trap(trap), .mem_valid(mem_valid), .mem_instr(mem_instr), .mem_ready(mem_ready),
		.mem_addr(mem_addr), .mem_wdata(mem_wdata), .mem_wstrb(mem_wstrb), .mem_rdata(mem_rdata), .pcpi_valid(pcpi_valid), .pcpi_insn(pcpi_insn),
		.pcpi_wait(pcpi_wait), .pcpi_ready(pcpi_ready)
	);
	
	SAM_Con_Wrapper SAM_PCPI (.pcpi_valid_SAM(pcpi_valid), .pcpi_insn_SAM(pcpi_insn), .pcpi_wait_SAM(pcpi_wait), .pcpi_ready_SAM(pcpi_ready), 
									  .mem_en_SAM(mem_en_SAM), .mem_wstrb_SAM(mem_wstrb_SAM), .mem_addr_SAM(mem_addr_SAM), .mem_rdata_SAM(mem_rdata_SAM), 
									  .mem_wdata_SAM(mem_wdata_SAM), .Clk(clk), .Rst(resetn));
endmodule 