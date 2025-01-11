library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_4x1_16bit is
	port (I3,I2,I1,I0 : in std_logic_vector(15 downto 0); 
			S : in std_logic_vector(1 downto 0); 
			Y : out std_logic_vector(15 downto 0));
end entity;

architecture beh of mux_4x1_16bit is
begin
	process (S, I0, I1, I2, I3) begin
		case S is
			when "00" => Y <= I0;
			when "01" => Y <= I1;
			when "10" => Y <= I2;
			when "11" => Y <= I3;
			when others=> NULL;
		end case;
	end process;
end architecture;
