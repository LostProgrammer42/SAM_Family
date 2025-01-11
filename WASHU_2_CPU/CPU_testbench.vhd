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
	
	
	type regarray is array(31 downto 0) of std_logic_vector(15 downto 0);
	signal Memory: regarray:=(
		0 => "0001000000001010",
		1 => "1000001000000001", 
		2 =>  "0000000001010000",
		3 =>  "1011010011000110",
		4 =>  "0000000000010000", 
		5 =>  "0000000000000001", 
		6 =>  "0110000001010000",
		7 =>  "1000000000000111",
		8 =>  "1001000000000100",
		9 =>  "1010000110001110",
		14=>  "0000000000000000",
		15 => "1100100110000010",
		18 => "1111000001000000",
		27 => "1101000000000011",
		30 => "1011000001000101",
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
		
		Mem_process: process(en,rw,dBus,aBus,clk)
		begin
				if rw = '0' and en='1' and rising_edge(clk) then
					report "Writing value: " & integer'image(to_integer(unsigned(dBus))) &" to memory address: " & integer'image(to_integer(unsigned(aBus)));
					Memory(to_integer(unsigned(aBus))) <= dBus ;
				elsif rw = '1' and en='1' and rising_edge(clk) then
					dBus <= Memory(to_integer(unsigned(aBus)));
				end if;
		end process;
	
end architecture;