module Full_Adder(a,b,cin,s,cout);
	input a,b,cin;
	output s,cout;
	
	assign s = a^b^cin;
	assign cout = a&b | b&cin | cin&a;
endmodule

module Adder_32(a,b,cin,s,cout);
	input [31:0] a,b;
	input cin;
	output [31:0] s;
	output cout;
	
	wire [32:0] c_sig;
	
	assign c_sig[0] = cin;
	assign cout = c_sig[32];
	
	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin : add_gen
			Full_Adder F (.a(a[i]), .b(b[i]), .cin(c_sig[i]), .s(s[i]), .cout(c_sig[i+1]));
		end
	endgenerate
endmodule
	