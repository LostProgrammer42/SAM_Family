library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity kogge_stone_node is
	port(
		g_in1 , g_in2, p_in1, p_in2 : in std_logic;
		g_out, p_out : out std_logic
	);
end entity;

architecture struct of kogge_stone_node is 
begin
	inst1: g_out <= g_in2 or (g_in1 and p_in2);
	inst2: p_out <= p_in2 and p_in1;
end architecture;