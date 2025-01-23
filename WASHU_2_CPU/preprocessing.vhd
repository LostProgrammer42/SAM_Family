library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity preprocessing	is
	port(
		A, B: in std_logic_vector(15 downto 0);
		G, P: out std_logic_vector(15 downto 0)
	);
end entity;

architecture behav of preprocessing is
begin
	inst1: for i in 0 to 15 generate
					G(i) <= A(i) and B(i);
					P(i) <= A(i) xor B(i);
				end generate;
end architecture;