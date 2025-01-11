library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is port (
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
end cpu;

architecture cpuArch of cpu is
	type state_type is (
		rstState, pauseState, fetch,
		halt, negate,
		branch, brZero, brPos, brNeg, brInd,
		cLoad, dLoad, iLoad,
		dStore, iStore,
		add, andd
	);
	signal state: state_type;
	signal tick: unsigned(3 downto 0);
	
	signal this: std_logic_vector(15 downto 0);
	
begin
	
	with regSelect select
		dispReg <= 	IReg_Data_Out when "00",
						this when "01",
						Acc_Data_Out when "10",
						"ZZZZZZZZZZZZZZZZ" when others ;
	
	with state select
		ALU_Sel <= 	"00" when negate,
						"01" when add,
						"10" when andd,
						"11" when others ; -- ALU should output 0
						
	process (clk)
	
	function decode(instr: std_logic_vector(15 downto 0)) return state_type is 
	begin
		case instr(15 downto 12) is
			when x"0" =>
				case instr(11 downto 8) is
					when x"0" =>
						if instr(11 downto 0) = x"000" then
							return halt;
						elsif instr(11 downto 0) = x"001" then
							return negate;
						else
							return halt;
						end if;
					when x"1" => return branch;
					when x"2" => return brZero;
					when x"3" => return brPos;
					when x"4" => return brNeg;
					when x"5" => return brInd;
					when others => return halt;
				end case;
			when x"1" => return cLoad;
			when x"2" => return dLoad;
			when x"3" => return iLoad;
			when x"5" => return dStore;
			when x"6" => return iStore;
			when x"8" => return add;
			when x"c" => return andd;
			when others => return halt;
		end case;
	end function decode;
	
	procedure wrapup is 
	begin
		if pause = '1' then
			state <= pauseState;
		else
			state <= fetch;
			tick <= x"0";
		end if;
	end procedure wrapup;
	
	begin
		if rising_edge(clk) then
			if rst = '1' then
				state <= rstState;
				tick <= x"0";
				this <= (others => '0');
				Acc_En <= '0';
				IAR_En <= '0';
				PC_En <= '0';
				IReg_En <= '0';
				Mux_PC_Add_Sel <= '0';
				Mux_PC_In_Sel <= '0';
				Mux_Acc_In_Sel <= "00";
			else 
				tick <= tick + 1;
				Acc_En <= '0';
				IAR_En <= '0';
				PC_En <= '0';
				IReg_En <= '0';
				Mux_PC_Add_Sel <= '0';
				Mux_PC_In_Sel <= '0';
				Mux_Acc_In_Sel <= "00";
				if state = rstState then
					state <= fetch;
					tick <= x"0";
				elsif state = pauseState then
					if pause = '0' then
						state <= fetch;
						tick <= x"0";
					end if;
				elsif state = fetch then
					if tick = 1 then
						IReg_En <= '1';
						PC_En <= '1';
					elsif tick = 3 then
						state <= decode(IReg_Data_Out);
						tick <= x"0";
						this <= PC_Data_Out;
						Mux_PC_Add_Sel <= '1';
					end if;
				else 
					case state is
						when branch =>
							if tick = 1 then
								PC_en <= '1';
								wrapup;
							end if;
						when brZero =>
							if tick = 1 then
								if Acc_Data_Out = x"0000" then
									PC_en <= '1';
									wrapup;
								end if;
							end if;
						when brPos =>
							if tick = 1 then
								if Acc_Data_Out /= x"0000" and Acc_Data_Out(15) = '0' then
									PC_en <= '1';
									wrapup;
								end if;
							end if;
						when brNeg =>
							if tick = 1 then
								if Acc_Data_Out(15) = '1' then
									PC_en <= '1';
									wrapup;
								end if;
							end if;
						when brInd =>
							if tick = 1 then
								PC_en <= '1';
							elsif tick = 3 then
								Mux_PC_In_Sel <= '1';
								PC_en <= '1';
								wrapup;
							end if;
						when cload =>
							Mux_Acc_In_Sel <= "01";
							Acc_En <= '1';
							wrapup;
						when dload => 
							if tick = 1 then
								Mux_Acc_In_Sel <= "10";
								Acc_En <= '1';
								wrapup;
							end if;
						when iload =>
							if tick = 0 then
								IAR_En <= '1';
							elsif tick = 3 then
								Mux_Acc_In_Sel <= "10";
								Acc_En <= '1';
							elsif tick = 4 then
								wrapup;
							end if;
						when dstore => 
							wrapup;
						when istore => 
							if tick = 1 then
								IAR_En <= '1';
							elsif tick = 2 then
								wrapup;
							end if;
						when negate =>
							Mux_Acc_In_Sel <= "11";
							wrapup;
						when add =>
							if tick = 1 then
								Mux_Acc_In_Sel <= "11"; 
								Acc_En <= '1';
							elsif tick = 2 then
								wrapup;
							end if;
						when andd =>
							if tick = 1 then
								Mux_Acc_In_Sel <= "11"; 
								Acc_En <= '1';
								wrapup;
							end if;
						when others =>
							state <= halt;
						end case;
				end if;
			end if;
		end if;
	end process;
	
	process (ireg_Data_Out,pc_Data_Out,acc_Data_Out,this,state,tick) 
	begin
		en <= '0'; 
		rw <= '1';
		PC_Buffer_Sel <= '0';
		IReg_Buffer_Sel <= '0';
		Addr_Sel <= '0';
		IAR_Buffer_Sel <= '0';
		Acc_BUffer_Sel <= '0';
		case state is
			when fetch =>
				if tick = 0 then
					en <= '1'; 
					PC_Buffer_Sel <= '1';
				end if;
			when branch | brZero | brPos | brNeg =>
				if tick = 0 then
					en <= '1'; 
					Addr_Sel <= '1';
				end if;
			when brInd =>
				if tick = 0 then
					en <= '1'; 
					Addr_Sel <= '1'; -- to select target
				elsif tick = 2 then
					PC_Buffer_Sel <= '1';
				end if;
			when dLoad | add | andd =>
				if tick = 0 then
					en <= '1'; 
					IReg_Buffer_Sel <= '1';
				end if;
			when iLoad =>
				if tick = 0 then
					en <= '1'; 
					IReg_Buffer_Sel <= '1';
				elsif tick = 2 then
					en <= '1'; 
					IAR_Buffer_Sel <= '1';
				end if;
			when dStore =>
				if tick = 0 then
					en <= '1'; 
					rw <= '0';
					IReg_Buffer_Sel <= '1';
					Acc_BUffer_Sel <= '1';
				end if;
			when iStore =>
				if tick = 0 then
					en <= '1'; 
					IReg_Buffer_Sel <= '1';
				elsif tick = 2 then
					en <= '1'; 
					rw <= '0';
					IAR_Buffer_Sel <= '1'; 
					Acc_BUffer_Sel <= '1';
				end if;
			when others =>
		end case;
	end process;
end cpuArch;




	
	