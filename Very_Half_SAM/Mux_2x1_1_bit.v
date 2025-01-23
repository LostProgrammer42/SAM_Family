module Mux_2x1_1_bit(I1,I0,S,Y);
	input I1,I0,S;
	reg Y_Sig;
	output Y;
	
	assign Y = Y_Sig;
	always @*
		if (S == 1'b1)
			Y_Sig = I1;
		else
			Y_Sig = I0;
endmodule
