module ALU(a,b,s,y);
	input [7:0] a,b;
	input [1:0] s;
	output reg [7:0] y;
	
	wire [7:0] adder_out, and_out, not_out, a_in, b_in;
	AND_8 u1 (.a(a),.b(b),.y(and_out));
	Adder_8 u2 (.a(a_in),.b(b_in),.s(adder_out),.cin(1'b0));
	assign not_out = ~a;
	Mux_2x1_8_bit u3 (.I0(not_out),.I1(a),.S(s[0]),.Y(a_in));
	Mux_2x1_8_bit u4 (.I0(8'b00000001),.I1(b),.S(s[0]),.Y(b_in));

	always @*
	begin
		case(s)
			2'b00: y = adder_out;
			2'b01: y = adder_out;
			2'b10: y = and_out;
			2'b11: y = 8'b00000000;
		endcase
	end
endmodule 
	