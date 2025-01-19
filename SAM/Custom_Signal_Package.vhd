library ieee;
use ieee.std_logic_1164.all;

package my_package is
    type address is array (15 downto 0) of std_logic;
	 subtype word is address;
end package my_package;
