module Mux_2x1_8_bit(I1,I0,S,Y);
	input [7:0] I1,I0;
	input S;
	reg [7:0] Y_Sig;
	output [7:0] Y;
	
	assign Y = Y_Sig;
	always @*
		if (S == 1'b1)
			Y_Sig = I1;
		else
			Y_Sig = I0;
endmodule
