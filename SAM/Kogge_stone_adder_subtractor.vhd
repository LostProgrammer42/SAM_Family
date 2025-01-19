library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity kogge_stone_adder_subtractor is
	port(
		A : in std_logic_vector(15 downto 0);
		B : in std_logic_vector(15 downto 0);
		M: in std_logic := '0';
		S: out std_logic_vector(15 downto 0);
		Cout: out std_logic);
end entity;

architecture str of kogge_stone_adder_subtractor is
	component kogge_stone is
		port(
			A : in std_logic_vector(15 downto 0);
			B : in std_logic_vector(15 downto 0);
			Cin: in std_logic := '0';
			S: out std_logic_vector(15 downto 0);
			Cout: out std_logic);
	end component;

	signal B_sig: std_logic_vector(15 downto 0);
	begin
		for1: for i in 0 to 15 generate
			B_sig(i) <= B(i) xor M;
		end generate;
		
		kogge: kogge_stone port map(A=>A,B=>B_sig,Cin=>M,S=>S,Cout=>Cout);
end architecture;
					