library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity kogge_stone is
	port(
		A : in std_logic_vector(15 downto 0);
		B : in std_logic_vector(15 downto 0);
		S: out std_logic_vector(15 downto 0);
		Cout: out std_logic;
		Cin: in std_logic := '0'
		);
end entity;

architecture behav of kogge_stone is
	component preprocessing	is
		port(
			A, B: in std_logic_vector(15 downto 0);
			G, P: out std_logic_vector(15 downto 0)
		);
	end component;
	component postprocessing is
		port(
			G, P, P_or: in std_logic_vector(15 downto 0);
			Cin : in std_logic;
			C: out std_logic_vector(16 downto 1);
			S: out std_logic_Vector(15 downto 0)
		);
	end component;
	component kogge_stone_node is
		port(
			g_in1 , g_in2, p_in1, p_in2 : in std_logic;
			g_out, p_out : out std_logic
		);
	end component;
	signal Pre_Processed_G, Pre_Processed_P, temp1_G, temp1_P, temp2_G, temp2_P, temp3_G, temp3_P, temp4_G, temp4_P, temp5_G, temp5_P, Carry_Calculated_G, Carry_Calculated_P, Post_Processed_S : std_logic_vector(15 downto 0);
	signal Post_Processed_C : std_logic_vector(16 downto 1);
	signal C: std_logic_vector(16 downto 0);
begin
	inst1: preprocessing port map(A=>A, B=>B, G=>Pre_Processed_G, P=>Pre_Processed_P);
	inst2: temp1_G <= Pre_Processed_G;
	inst3: temp1_P <= Pre_Processed_P;
	inst4: for i in 1 to 15 generate
				inst4a: kogge_stone_node port map(g_in1=>temp1_G(i-1), g_in2=>temp1_G(i), p_in1=>temp1_P(i-1), p_in2=>temp1_P(i), g_out=>temp2_G(i), p_out=>temp2_P(i));
			 end generate;
	inst4a: temp2_G(0) <= temp1_G(0);
	inst4b: temp2_P(0) <= temp1_P(0);
	inst5: for i in 2 to 15 generate
				inst5a: kogge_stone_node port map(g_in1=>temp2_G(i-2), g_in2=>temp2_G(i), p_in1=>temp2_P(i-2), p_in2=>temp2_P(i), g_out=>temp3_G(i), p_out=>temp3_P(i));
			 end generate;
	inst5a: temp3_G(1 downto 0) <= temp2_G(1 downto 0);
	inst5b: temp3_P(1 downto 0) <= temp2_P(1 downto 0);
	inst6: for i in 4 to 15 generate
				inst6a: kogge_stone_node port map(g_in1=>temp3_G(i-4), g_in2=>temp3_G(i), p_in1=>temp3_P(i-4), p_in2=>temp3_P(i), g_out=>temp4_G(i), p_out=>temp4_P(i));
			 end generate;
	inst6a: temp4_G(3 downto 0) <= temp3_G(3 downto 0);
	inst6b: temp4_P(3 downto 0) <= temp3_P(3 downto 0);
	inst7: for i in 8 to 15 generate
				inst7a: kogge_stone_node port map(g_in1=>temp4_G(i-8), g_in2=>temp4_G(i), p_in1=>temp4_P(i-8), p_in2=>temp4_P(i), g_out=>Carry_Calculated_G(i), p_out=>Carry_Calculated_P(i));
			 end generate;
	inst7a: Carry_Calculated_G(7 downto 0) <= temp4_G(7 downto 0);
	inst7b: Carry_Calculated_P(7 downto 0) <= temp4_P(7 downto 0);
	inst8: postprocessing port map(G=>Carry_Calculated_G, P=>Carry_Calculated_P, P_or=>Pre_Processed_P, Cin=>Cin, C=>Post_Processed_C, S=>Post_Processed_S);
	inst9: Cout <= Post_Processed_C(16);
	inst10: S <= Post_Processed_S;
end architecture;
