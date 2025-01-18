library ieee;
use ieee.std_logic_1164.all;

entity full_adder_nand is 
	port (A, B, C_in: in std_logic; S, C_out : out std_logic);
end entity full_adder_nand;

architecture struct of full_adder_nand is 
	signal w_1, w_2, AB_not : std_logic;
	
	begin
	
	S <= (A xor B) xor C_in;
	C_out <= (A and B)or(B and C_in)or(A and C_in);
	
end struct;