library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU_testbench is
end entity;

architecture behav of CPU_testbench is
	
	component Toplevel is port (
		clk, rst: in std_logic;
		-- memory signals
		en, rw: out std_logic;
		aBus: out std_logic_vector(7 downto 0); dBus: inout std_logic_vector(7 downto 0);
		-- console interface signals
		pause: in std_logic;
		regSelect: in std_logic_vector(1 downto 0);
		dispReg: out std_logic_vector(7 downto 0);
		Abus2, PC_Data_In: out std_logic_vector(7 downto 0):= "00000000";
		PC_Buff_Sel: out std_logic);
	end component;

	signal clk,rst: std_logic := '0';
	signal en, rw, PC_Buff_Sel: std_logic;
	signal aBus, dBus, Abus2, PC_Data_In: std_logic_vector(7 downto 0);
	signal pause: std_logic := '0';
	
	signal regSelect: std_logic_vector(1 downto 0) := "10";
	signal dispReg: std_logic_vector(7 downto 0);
	
	
	type regarray is array(63 downto 0) of std_logic_vector(7 downto 0);
	signal Memory: regarray:=(
		0 =>  "00010111", -- branch 8
		1 =>  "01100001", -- data
		2 =>  "00000001", -- data
		3 =>  "00000010", -- data
		4 =>  "00000000", -- data
		
		5 =>  "00000000", -- data
		6 =>  "00000000", -- data
		7 =>  "11111101", -- data (-3)
		8 =>  "00010111", -- branch 8
		
		9 =>  "00000000", -- data
		10 => "00000000", -- data
		11 => "11110110", -- data (-10)
		12 => "00000111", -- data (7)
		
		13 => "00000000", -- register
		14 => "11111111", -- data
		15 => "00000110", -- data
		16 => "00010010", -- branch 3
		
		17 => "00000000", -- na
		18 => "00000000", -- na
		19 => "01100011", -- cload #3H
		20 => "11000001", -- andd 1H
		
		21 => "10010100", -- dstore 4H
		22 => "10000010", -- iload 2H
		23 => "10110001", -- add 1H
		24 => "11000011", -- andd 3H
		
		25 => "10101111", -- istore FH
		26 => "10111110", -- add EH
		27 => "10010101", -- dstore 5H
		28 => "01110111", -- dload 7H
		29 => "00000001", -- negate
		
		30 => "10010111", -- dstore 7H
		31 => "10001100", -- iload CH
		32 => "10011101", -- dtore DH
		33 => "10001111", -- iload FH
		
		34 => "10111101", -- add DH
		35 => "10011101", -- dstore DH
		36 => "01111111", -- dload FH
		37 => "10110010", -- add 2H
		
		38 => "10011111", -- dstore FH
		39 => "01111100", -- dload CH
		40 => "10110010", -- add 2H
		41 => "10011100", -- dstore CH
		
		42 => "01111101", -- dload DH
		43 => "10101100", -- istore CH
		44 => "01111100", -- dload CH
		45 => "10111011", -- add BH
		
		46 => "00100001", -- brZero 2H
		47 => "01011000", -- brInd 9H
		48 => "01110010", -- dload 2H
		49 => "00110001", -- brPos 2H
		
		50 => "00000000", -- halt
		51 => "01111011", -- dload BH
		52 => "01000001", -- brNeg 2H
		53 => "10011001", -- dstore 9H
		54 => "00000000", -- halt
		55 => "10011000", -- dstore 8H
		56 => "00100001", -- data
		others => x"00");

	begin
		CPU: toplevel port map(clk=>clk,rst=>rst,en=>en,rw=>rw,aBus=>aBus,dBus=>dBus,pause=>pause,regSelect=>regSelect,
		dispreg=>dispreg, Abus2=>Abus2,PC_Buff_Sel=>PC_Buff_Sel,PC_Data_In=>PC_Data_In);
		
		clk_process: process
		begin
			clk <= not clk after 10ns;
			wait for 10ns;
		end process clk_process;
		
		rst_process: process
		begin
			rst <= '1';
			wait for 20ns;
			rst <= '0';
			wait;
		end process;
		
	
		Mem_process: process(clk)
		begin
			if rising_edge(clk) then
				if rw = '0' and en='1' then
					report "Writing value: " & integer'image(to_integer(unsigned(dBus))) &" to memory address: " & integer'image(to_integer(unsigned(aBus)));
					Memory(to_integer(unsigned(aBus))) <= dBus ;
				elsif rw = '1' and en='1' then
					if aBus /= "ZZZZZZZZ" then
						dBus <= Memory(to_integer(unsigned(aBus)));
					else
						dBus <= "ZZZZZZZZ";
					end if;
				end if;
			end if;
		end process;

end architecture;