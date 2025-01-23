library ieee;
use ieee.std_logic_1164.all;

entity mux_2x1 is
	port (I1, I0 : in std_logic; 
			S : in std_logic; 
			Y : out std_logic);
end entity;

architecture beh of mux_2x1 is
begin
	process(S, I1, I0) begin
		case S is
			when '0' => Y <= I0;
			when '1' => Y <= I1;
			when others => Y <= 'U';
		end case;
	end process;
end architecture;
