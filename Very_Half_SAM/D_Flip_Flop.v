module D_FF(d,clk,q,rst);
	input d,clk,rst;
	output reg q;
	
	always @(posedge(clk))
		if (rst == 1'b1)
			q <= 1'b0;
		else
			q <= d;
endmodule
