library ieee;
use ieee.std_logic_1164.all;

entity NOT_16 is
	port(a: in std_logic_vector(15 downto 0);
		  b: out std_logic_vector(15 downto 0)
		  );
end NOT_16;

architecture str of NOT_16 is
	begin
		for1: for i in 0 to 15 generate
			b(i) <= not a(i);
		end generate for1;
end architecture;