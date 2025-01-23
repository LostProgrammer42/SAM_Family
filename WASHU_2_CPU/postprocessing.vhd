library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity postprocessing	is
	port(
		G, P, P_or: in std_logic_vector(15 downto 0);
		Cin : in std_logic;
		C: out std_logic_vector(16 downto 1);
		S: out std_logic_Vector(15 downto 0)
	);
end entity;

architecture behav of postprocessing is
	signal C_buff : std_logic_vector(16 downto 0) := (others => '0');
begin
	inst4: C_buff(0) <= Cin;
	inst3: S(0) <= P(0) xor Cin;
	inst2: C_buff(1) <= G(0) or (P(0) and Cin);
	inst2a: C(1) <= C_buff(1);
	inst1: for i in 1 to 15 generate
					C(i+1) <= C_buff(i+1);
					C_buff(i+1) <= G(i) or (P(i) and C_buff(i));
					S(i) <= P_or(i) xor C_buff(i);
				end generate;
end architecture;