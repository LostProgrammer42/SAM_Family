library ieee;
use ieee.std_logic_1164.all;


entity datapath is
	port (IReg_En, Mux_PC_Add_Sel, PC_En, IAR_En, Acc_En : in std_logic;
			IReg_Buffer_Sel, PC_Buffer_Sel, IAR_Buffer_Sel, Acc_Buffer_Sel,Mux_PC_In_Sel: in std_logic :='0';
			clk, rst, Addr_Sel: in std_logic;
			Mux_Acc_In_Sel, ALU_Sel: in std_logic_vector(1 downto 0);
			Data_Bus: inout std_logic_vector(15 downto 0) :="0000000000000000";
			Address_Bus : out std_logic_vector(15 downto 0) := "0000000000000000";
			IReg_Data_Out, PC_Data_Out: buffer std_logic_vector(15 downto 0) := "0000000000000000";
			Acc_Data_Out: buffer std_logic_vector(15 downto 0) := "0000000000000000";
			Abus2,PC_Data_In: buffer std_logic_vector(15 downto 0):= "0000000000000000");
end entity;

architecture beh of datapath is
	component pipo_register is
		port (din : in std_logic_vector(15 downto 0):="0000000000000000";
				en, rst, clk : in std_logic;
				dout : out std_logic_vector(15 downto 0):="0000000000000000");
	end component;
	
	component kogge_stone_adder_subtractor is
		port(
			A : in std_logic_vector(15 downto 0);
			B : in std_logic_vector(15 downto 0);
			M: in std_logic := '0';
			S: out std_logic_vector(15 downto 0);
			Cout: out std_logic);
	end component;
	
	component mux_2x1 is
		port (I1, I0 : in std_logic; 
				S : in std_logic; 
				Y : out std_logic);
	end component;
	
	
	component mux_2x1_16bit is
		port (I1, I0 : in std_logic_vector(15 downto 0); 
				S : in std_logic; 
				Y : out std_logic_vector(15 downto 0):="0000000000000000");
	end component;
	
	
	component mux_4x1_16bit is
		port (I3,I2,I1,I0 : in std_logic_vector(15 downto 0); 
				S : in std_logic_vector(1 downto 0); 
				Y : out std_logic_vector(15 downto 0):="0000000000000000");
	end component;
	
		
	component ALU is
		port (a,b : in std_logic_vector(15 downto 0); 
				ALU_Sel: in std_logic_vector(1 downto 0); --1 for Add, 0 for Negate, 2 for AND
				c : out std_logic_vector(15 downto 0));
	end component;
	
	signal IReg_Data_In, IAR_Data_In, Acc_Data_In, ALU_Data_Out, IReg_Mux_Out : std_logic_vector(15 downto 0) := "0000000000000000";
	signal IAR_Data_Out: std_logic_vector(15 downto 0):="0000000000000000";
	signal IReg_Acc_Signal, PC_Incremented_Signal, PC_Adding_Signal: std_logic_vector(15 downto 0):="0000000000000000";
	signal opAdr, target: std_logic_vector(15 downto 0) :="0000000000000000" ;
	
	signal Abus1,Abus3: std_logic_vector(15 downto 0):= "0000000000000000";
	
	begin
		IReg_Data_In <= Data_Bus;	
		Address_Bus <= Abus2 when PC_Buffer_Sel = '1' else Abus1 when IReg_Buffer_Sel = '1' else Abus3;
		IReg: pipo_register port map(din=>IReg_Data_In, dout=>IReg_Data_Out, en=>IReg_En, rst=>rst, clk=>clk);
		IReg_Tristate_Buffer: mux_2x1_16bit port map(I0=>"ZZZZZZZZZZZZZZZZ", I1=>IReg_Mux_Out, S=>IReg_Buffer_Sel, Y=>Abus1);
		opAdr <= PC_Data_Out(15 downto 12) & IReg_Data_Out(11 downto 0);
		target <= ((15 downto 8 => IReg_Data_Out(7)) & IReg_Data_Out(7 downto 0));
		Mux_IReg_Out: mux_2x1_16bit port map(I0=>opAdr,I1=>target,S=>Addr_Sel,Y=>IReg_Mux_Out);
		
		Mux_PC_Add: mux_2x1_16bit port map(I1=>"0000000000000001", I0=>IReg_Mux_Out, S=>Mux_PC_Add_Sel, Y=>PC_Adding_Signal);
		Mux_PC_Input_Sel: mux_2x1_16bit port map(I0=>PC_Incremented_Signal, I1=>Data_Bus, S=>Mux_PC_In_Sel, Y=> PC_Data_In);
		Adder: kogge_stone_adder_subtractor port map (A=>PC_Adding_Signal, B=>PC_Data_Out, M=>'0', S=>PC_Incremented_Signal, Cout=>open);
		PC: pipo_register port map(din=>PC_Data_In, dout=>PC_Data_Out, en=>PC_En, rst=>rst, clk=>clk);
		PC_Tristate_Buffer: mux_2x1_16bit port map(I0=>"ZZZZZZZZZZZZZZZZ", I1=>PC_Data_out, S=>PC_Buffer_Sel, Y=>Abus2);
		
		IAR_Data_In <= Data_Bus;
		IAR: pipo_register port map(din=>IAR_Data_In, dout=>IAR_Data_Out, en=>IAR_En, rst=>rst, clk=>clk);
		IAR_Tristate_Buffer: mux_2x1_16bit port map(I0=>"ZZZZZZZZZZZZZZZZ", I1=>IAR_Data_out, S=>IAR_Buffer_Sel, Y=>Abus3);
		
		IReg_Acc_Signal <= ((15 downto  12=> IReg_Data_Out(11)) & IReg_Data_Out(11 downto 0));
		Mux_ACC: mux_4x1_16bit port map(I3=>ALU_Data_Out, I2=>Data_Bus, I1=> IReg_Acc_Signal, I0=>"ZZZZZZZZZZZZZZZZ", S=>Mux_Acc_In_Sel, Y=>Acc_Data_In);
		ACC: pipo_register port map(din=>Acc_Data_In, dout=>Acc_Data_Out, en=>Acc_En, rst=>rst, clk=>clk);
		ACC_Tristate_Buffer: mux_2x1_16bit port map(I0=>"ZZZZZZZZZZZZZZZZ", I1=>ACC_Data_out, S=>ACC_Buffer_Sel, Y=>Data_Bus);
		
		AL_Unit: ALU port map(a=>ACC_Data_out, b=>Data_bus, c=>ALU_Data_Out, ALU_Sel=>ALU_Sel);
end architecture;