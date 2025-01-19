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
		aBus: out std_logic_vector(15 downto 0); dBus: inout std_logic_vector(15 downto 0);
		-- console interface signals
		pause: in std_logic;
		regSelect: in std_logic_vector(1 downto 0);
		dispReg: out std_logic_vector(15 downto 0);
		Abus2,PC_Data_In: out std_logic_vector(15 downto 0):= "0000000000000000";
		PC_Buff_Sel: out std_logic);
	end component;

	signal clk,rst: std_logic := '0';
	signal en, rw, PC_Buff_Sel: std_logic;
	signal aBus, dBus, Abus2, PC_Data_In: std_logic_vector(15 downto 0);
	signal pause: std_logic := '0';
	
	signal regSelect: std_logic_vector(1 downto 0) := "10";
	signal dispReg: std_logic_vector(15 downto 0);
	
	
	type regarray is array(54 downto 0) of std_logic_vector(15 downto 0);
	signal Memory: regarray:=(
		0 =>  "0000000100010010",
		1 =>  "0101010001100001", 
		2 =>  "0000000000000001",
		3 =>  "0000000000000010",
		4 =>  "0000000000000000", 
		
		5 =>  "0000000000000000", 
		6 =>  "0000000000000000", 
		7 =>  "0000000000000000", 
		8 =>  "0000000000000000", 
		
		9 =>  "0000000000000000", 
		10 => "0000000000000000", 
		11 => "0000000000000000", 
		12 => "0000000000000000",
		
		13 => "0000000000000000", 
		14 => "1111111111111111", 
		15 => "0000000000000110",
		16 => "0000000000000111",
		
		17 => "0000000000000000",
		18=>  "1111111111110011",
		19 => "0001000000000011",
		20 => "1100000000000001",
		
		21 => "0101000000000100",
		22 => "0011000000000010",
		23 => "1000000000000001",
		24 => "1100000000000011",
		
		25 => "0110000000001111",
		26 => "1000000000001110", 
		27 => "0101000000000101", 
		28 => "0001111111111101", 
		29 => "0000000000000001",
		
		30 => "0101000000000111", 
		31 => "0011000000010000", 
		32 => "0101000000010001",
		33 => "0011000000001111",
		
		34 => "1000000000010001",
		35 => "0101000000010001",
		36 => "0010000000001111",
		37 => "1000000000000010",
		
		38 => "0101000000001111",
		39 => "0010000000010000",
		40 => "1000000000000010",
		41 => "0101000000010000",
		
		42 => "0010000000010001", 
		43 => "0110000000010000", 
		44 => "0010000000010000",
		45 => "1000000000010010",
		
		46 => "0000001000000011",
		47 => "0000010011110001",
		48 => "0010000000000010",
		49 => "0000001111101100",
		
		others => x"0000");

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
					if aBus /= "ZZZZZZZZZZZZZZZZ" then
						dBus <= Memory(to_integer(unsigned(aBus)));
					else
						dBus <= "ZZZZZZZZZZZZZZZZ";
					end if;
				end if;
			end if;
		end process;

end architecture;