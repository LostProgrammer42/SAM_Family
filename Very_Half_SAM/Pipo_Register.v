module Pipo_Register(din,clk,dout,rst,en);
	input en,clk,rst;
	inout [7:0] dout;
	input [7:0] din;
	
	wire [7:0] d;
	
	genvar i;
	generate
		for (i=0;i<8;i=i+1) begin: loop
			D_FF df(.d(d[i]),.q(dout[i]),.clk(clk),.rst(rst));
			Mux_2x1_1_bit mux(.I1(din[i]),.I0(dout[i]),.S(en),.Y(d[i]));
		end
	endgenerate
	
endmodule
