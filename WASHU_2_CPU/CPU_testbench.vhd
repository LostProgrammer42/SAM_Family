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
		write_enable: buffer std_logic);
	end component;

	signal clk,rst: std_logic := '0';
	signal en, rw: std_logic;
	signal aBus, dBus: std_logic_vector(15 downto 0);
	signal pause: std_logic := '0';
	
	signal regSelect: std_logic_vector(1 downto 0) := "10";
	signal dispReg: std_logic_vector(15 downto 0);
	
	signal databus_o, databus_i: std_logic_vector(15 downto 0);
	signal write_enable: std_logic;
	
	type regarray is array(31 downto 0) of std_logic_vector(15 downto 0);
	signal Memory: regarray:=(
		0 => "0001000000001001",
		1 => "1000000000000110", 
		2 =>  "0000000000000001",
		3 =>  "1100000000000111",
		4 =>  "0000000000010000", 
		5 =>  "0000000000000001", 
		6 =>  "0000000000000110",
		7 =>  "0000000000011000",
		8 =>  "1001000000000100",
		9 =>  "0000000000000011",
		14=>  "0000000000000000",
		15 => "1100100110000010",
		18 => "1111000001000000",
		27 => "1101000000000011",
		30 => "1011000001000101",
		others => x"0000");

	begin
		CPU: toplevel port map(clk=>clk,rst=>rst,en=>en,rw=>rw,aBus=>aBus,dBus=>dBus,pause=>pause,regSelect=>regSelect,
		dispreg=>dispreg, write_enable => write_enable);
		
		clk_process: process
		begin
			clk <= not clk after 10ns;
			wait for 10ns;
		end process clk_process;
		
		Mem_process: process(en,rw,databus_o, databus_i, aBus,clk)
		begin
				if rw = '0' and en='1' and rising_edge(clk) then
					Memory(to_integer(unsigned(aBus))) <= databus_i ;
				elsif rw = '1' and en='1' and rising_edge(clk) then
					databus_o <= Memory(to_integer(unsigned(aBus)));
				end if;
		end process;
		
		databus_i <= dbus;

		 -- Drive dout with data_bus_out when output_enable = '1' (output mode)
		 dbus <= databus_o when write_enable = '0' else (others => 'Z');
		
		rst_proc : process
		begin
			rst <= '1';
			wait for 50ns;
			rst <= '0';
			wait;
		end process;
	
end architecture;