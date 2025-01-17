library ieee;
use ieee.std_logic_1164.all;

entity AND_8 is
	port(a,b: in std_logic_vector(7 downto 0);
		  c: out std_logic_vector(7 downto 0)
		  );
end AND_8;

architecture str of AND_8 is
	begin
		for1: for i in 0 to 7 generate
			c(i) <= a(i) and b(i);
		end generate for1;
end architecture;