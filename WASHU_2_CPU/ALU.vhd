library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port (a,b : in std_logic_vector(15 downto 0); 
			ALU_Sel: in std_logic_vector(1 downto 0); --1 for Add, 0 for Negate, 2 for AND
			c : out std_logic_vector(15 downto 0));
end entity;

architecture str of ALU is
	component kogge_stone_adder_subtractor is
		port(
			A : in std_logic_vector(15 downto 0);
			B : in std_logic_vector(15 downto 0);
			M: in std_logic := '0';
			S: out std_logic_vector(15 downto 0);
			Cout: out std_logic);
	end component;
	
	component AND_16 is
		port(a,b: in std_logic_vector(15 downto 0);
			  c: out std_logic_vector(15 downto 0));
	end component;
	
	component mux_4x1_16bit is
		port (I3,I2,I1,I0 : in std_logic_vector(15 downto 0); 
				S : in std_logic_vector(1 downto 0); 
				Y : out std_logic_vector(15 downto 0));
	end component;
	
	component mux_2x1_16bit is
		port (I1, I0 : in std_logic_vector(15 downto 0); 
				S : in std_logic; 
				Y : out std_logic_vector(15 downto 0));
	end component;
	
	signal Add_In_1,Add_Out,And_Out: std_logic_vector(15 downto 0);
	signal M_sig: std_logic;
	begin
	   M_sig <= not ALU_Sel(0);
		Mux1: mux_2x1_16bit port map(I0=>"0000000000000000", I1=>b, S=>ALU_Sel(0),Y=>Add_In_1);
		Adder: kogge_stone_adder_subtractor port map (A=>Add_In_1, B=>a, M=> M_sig,S=>Add_Out,Cout=>Open);
		Ander: AND_16 port map (a=>a, b=>b, c=>And_out);
		
		Mux2: mux_4x1_16bit port map(I3=>"ZZZZZZZZZZZZZZZZ", I2=>And_Out, I1=>Add_Out, I0=>Add_Out, S=>ALU_Sel, Y=>c); 
		
end architecture;