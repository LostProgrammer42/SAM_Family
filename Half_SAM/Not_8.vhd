library ieee;
use ieee.std_logic_1164.all;

entity NOT_8 is
	port(a: in std_logic_vector(7 downto 0);
		  b: out std_logic_vector(7 downto 0)
		  );
end NOT_8;

architecture str of NOT_8 is
	begin
		for1: for i in 0 to 7 generate
			b(i) <= not a(i);
		end generate for1;
end architecture;