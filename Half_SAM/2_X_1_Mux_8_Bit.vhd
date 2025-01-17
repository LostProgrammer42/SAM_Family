library ieee;
use ieee.std_logic_1164.all;

entity mux_2x1_8bit is
	port (I1, I0 : in std_logic_vector(7 downto 0); 
			S : in std_logic; 
			Y : out std_logic_vector(7 downto 0):="00000000");
end entity;

architecture beh of mux_2x1_8bit is
begin
	process(S, I1, I0) begin
		case S is
			when '0' => Y <= I0;
			when '1' => Y <= I1;
			when others => null;
		end case;
	end process;
end architecture;
