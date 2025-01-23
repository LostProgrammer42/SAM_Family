module Mux_4x1_8_bit(I3,I2,I1,I0,S,Y);
	input [7:0] I3,I2,I1,I0;
	input [1:0] S;
	reg [7:0] Y_Sig;
	output[7:0] Y;
	
	assign Y = Y_Sig;
	always @*
		case(S)
			2'b00: Y_Sig = I0;
			2'b01: Y_Sig = I1;
			2'b10: Y_Sig = I2;
			2'b11: Y_Sig = I3;
		endcase
endmodule 