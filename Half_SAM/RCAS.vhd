library ieee;
use ieee.std_logic_1164.all;

entity RCAS is 
	port (A, B : in std_logic_vector(7 downto 0);
		M: in std_logic;
		S : out std_logic_vector(7 downto 0);
		Cout : out std_logic);
end entity RCAS;

architecture struct of RCAS is 
	signal C_temp : std_logic_vector(6 downto 0);
	signal b_temp : std_logic_vector(7 downto 0);
	component full_adder_nand is
		port (A, B, C_in: in std_logic; S, C_out : out std_logic);
	end component;
	
	begin
	b_temp(0) <= B(0) xor M;
	b_temp(1) <= B(1) xor M;
	b_temp(2) <= B(2) xor M;
	b_temp(3) <= B(3) xor M;
	b_temp(4) <= B(4) xor M;
	b_temp(5) <= B(5) xor M;
	b_temp(6) <= B(6) xor M;
	b_temp(7) <= B(7) xor M;
	
	FA1: full_adder_nand port map (A => A(0), B => b_temp(0), C_in => M, S => S(0), C_out => C_temp(0));
	FA2: full_adder_nand port map (A => A(1), B => b_temp(1), C_in => C_temp(0), S => S(1), C_out => C_temp(1));
	FA3: full_adder_nand port map (A => A(2), B => b_temp(2), C_in => C_temp(1), S => S(2), C_out => C_temp(2));
	FA4: full_adder_nand port map (A => A(3), B => b_temp(3), C_in => C_temp(2), S => S(3), C_out => C_temp(3));
	FA5: full_adder_nand port map (A => A(4), B => b_temp(4), C_in => C_temp(3), S => S(4), C_out => C_temp(4));
	FA6: full_adder_nand port map (A => A(5), B => b_temp(5), C_in => C_temp(4), S => S(5), C_out => C_temp(5));
	FA7: full_adder_nand port map (A => A(6), B => b_temp(6), C_in => C_temp(5), S => S(6), C_out => C_temp(6));
	FA8: full_adder_nand port map (A => A(7), B => b_temp(7), C_in => C_temp(6), S => S(7), C_out => Cout);
	
	
end struct;