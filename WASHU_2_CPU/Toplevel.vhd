library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Toplevel is port (
	clk, rst: in std_logic;
	-- memory signals
	en, rw: buffer std_logic;
	aBus: out std_logic_vector(15 downto 0); 
	dBus: inout std_logic_vector(15 downto 0);
	-- console interface signals
	pause: in std_logic;
	regSelect: in std_logic_vector(1 downto 0);
	dispReg: out std_logic_vector(15 downto 0);
	write_enable: buffer std_logic);
end entity;

architecture str of Toplevel is
	component cpu is 
		port (
			IReg_En, Mux_PC_Add_Sel, Mux_PC_In_Sel, PC_En, IAR_En, Acc_En : out std_logic;
			IReg_Buffer_Sel, PC_Buffer_Sel, IAR_Buffer_Sel, Acc_Buffer_Sel: out std_logic;
			clk, rst: in std_logic; 
			Addr_Sel: out std_logic;
			Mux_Acc_In_Sel, ALU_Sel: out std_logic_vector(1 downto 0);
			En,Rw: out std_logic;
			IReg_Data_Out, PC_Data_Out: in std_logic_vector(15 downto 0);
			Acc_Data_Out: in std_logic_vector(15 downto 0);
			regSelect: in std_logic_vector(1 downto 0);
			dispReg: out std_logic_vector(15 downto 0);
			pause: in std_logic);
	end component cpu;
	
	
	component datapath is
		port (IReg_En, Mux_PC_Add_Sel, Mux_PC_In_Sel, PC_En, IAR_En, Acc_En : in std_logic;
				IReg_Buffer_Sel, PC_Buffer_Sel, IAR_Buffer_Sel, Acc_Buffer_Sel: in std_logic;
				clk, rst, Addr_Sel: in std_logic;
				Mux_Acc_In_Sel, ALU_Sel: in std_logic_vector(1 downto 0);
				Data_Bus_out: out std_logic_vector(15 downto 0);
				Data_Bus_in: in std_logic_vector(15 downto 0);
				Address_Bus : out std_logic_vector(15 downto 0);
				IReg_Data_Out, PC_Data_Out: buffer std_logic_vector(15 downto 0);
				Acc_Data_Out: buffer std_logic_vector(15 downto 0));
	end component;
	
	signal IReg_En, Mux_PC_Add_Sel, Mux_PC_In_Sel, PC_En, IAR_En, Acc_En: std_logic;
	signal IReg_Buffer_Sel, PC_Buffer_Sel, IAR_Buffer_Sel, Acc_Buffer_Sel, Addr_Sel: std_logic;
	signal Mux_Acc_In_Sel, ALU_Sel: std_logic_vector(1 downto 0);
	signal IReg_Data_Out, PC_Data_Out, Acc_Data_Out: std_logic_vector(15 downto 0);
	signal data_bus_out, data_bus_in: std_logic_vector(15 downto 0);
	
	
	begin
		CP_Unit: CPU port map (IReg_En=>IReg_En, Mux_PC_Add_Sel=>Mux_PC_Add_Sel, Mux_PC_In_Sel=>Mux_PC_In_Sel, 
		PC_En=>PC_En, IAR_En=>IAR_En, Acc_En=>Acc_En, IReg_Buffer_Sel=>IReg_Buffer_Sel,
		PC_Buffer_Sel=>PC_Buffer_Sel, IAR_Buffer_Sel=>IAR_Buffer_Sel, Acc_Buffer_Sel=>Acc_Buffer_Sel,
		clk=>clk,rst=>rst,Addr_Sel=>Addr_Sel, Mux_Acc_In_Sel => Mux_Acc_In_Sel, ALU_Sel=>ALU_Sel, En => en, Rw => rw,
		IReg_Data_Out=>IReg_Data_Out, PC_Data_Out=>PC_Data_Out, Acc_Data_Out=>Acc_Data_Out, regSelect=>regSelect, 
		dispReg=>dispReg, pause=>pause);
		
		DPath: Datapath port map (IReg_En=>IReg_En, Mux_PC_Add_Sel=>Mux_PC_Add_Sel, Mux_PC_In_Sel=>Mux_PC_In_Sel,
		PC_En=>PC_En, IAR_En=>IAR_En, Acc_En=>Acc_En, IReg_Buffer_Sel=>IReg_Buffer_Sel, PC_Buffer_Sel=>Pc_Buffer_Sel,
		IAR_Buffer_Sel=>IAR_Buffer_Sel, ACC_Buffer_Sel=>ACC_Buffer_Sel, clk=>clk, rst=>rst, Addr_Sel=>Addr_Sel,
		Mux_Acc_In_Sel=>Mux_Acc_In_Sel, ALU_Sel=>ALU_Sel, Data_Bus_in=>data_bus_in, Data_Bus_out => data_bus_out, 
		Address_Bus=>aBus, IReg_Data_Out=>IReg_Data_Out,PC_Data_Out=>PC_Data_Out, Acc_Data_Out=>ACC_Data_Out);
		
		write_enable <= Acc_Buffer_Sel or (not rw);
		
		 -- Assign dout to data_bus_in when output_enable = '0' (input mode)
		 data_bus_in <= dbus;

		 -- Drive dout with data_bus_out when output_enable = '1' (output mode)
		 dbus <= data_bus_out when write_enable = '1' else (others => 'Z');
		
		
end architecture;
