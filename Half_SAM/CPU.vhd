library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is port (
			IReg_En, Mux_PC_Add_Sel, Mux_PC_In_Sel, PC_En, IAR_En, Acc_En : out std_logic;
			IReg_Buffer_Sel, PC_Buffer_Sel, IAR_Buffer_Sel, Acc_Buffer_Sel: out std_logic:='0';
			clk, rst: in std_logic; 
			Mux_Acc_In_Sel, ALU_Sel: out std_logic_vector(1 downto 0);
			En,Rw: out std_logic;
			IReg_Data_Out, PC_Data_Out: in std_logic_vector(7 downto 0):="00000000";
			Acc_Data_Out: in std_logic_vector(7 downto 0):="00000000";
			regSelect: in std_logic_vector(1 downto 0);
			dispReg: out std_logic_vector(7 downto 0);
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
begin
	
	with regSelect select
		dispReg <= 	IReg_Data_Out when "00",
						PC_Data_Out when "01",
						Acc_Data_Out when "10",
						"ZZZZZZZZ" when others ;
	
	with state select
		ALU_Sel <= 	"00" when negate,
						"01" when add,
						"10" when andd,
						"11" when others ; -- ALU should output 0
						
	process (clk)
	
	function decode(instr: std_logic_vector(7 downto 0)) return state_type is 
	begin
		case instr(7 downto 4) is
			when x"0" =>
				case instr(3 downto 0) is
					when x"0" => return halt;
					when x"1" => return negate;
					when others => return halt;
				end case;
			when x"1" => return branch;
			when x"2" => return brZero;
			when x"3" => return brPos;
			when x"4" => return brNeg;
			when x"5" => return brInd;
			when x"6" => return cload;
			when x"7" => return dload;
			when x"8" => return iload;
			when x"9" => return dstore;
			when x"a" => return istore;
			when x"b" => return add;
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
				Acc_En <= '0';
				IAR_En <= '0';
				PC_En <= '0';
				IReg_En <= '0';
				Mux_PC_Add_Sel <= '0';
				Mux_PC_In_Sel <= '0';
				Mux_Acc_In_Sel <= "00";
				state <= rstState;
				tick <= x"0";
				this <= (others => '0');
			else 
				tick <= tick + 1;
				Acc_En <= '0';
				IAR_En <= '0';
				PC_En <= '0';
				IReg_En <= '0';
				Mux_PC_Add_Sel <= '1';
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
						PC_En <= '1';
						IReg_En <= '1';
					elsif tick = 3 then
						state <= decode(IReg_Data_Out);
						tick <= x"0";
						this <= PC_Data_Out;
						Mux_PC_Add_Sel <= '1';
					end if;
				else 
					case state is
						when branch =>
							if tick = 0 then
								PC_en <= '1';
							elsif tick =1 then
								wrapup;
							end if;
						when brZero =>
							if tick = 0 then
								if Acc_Data_Out = x"00" then
									PC_en <= '1';
								end if;
							elsif tick = 1 then
								wrapup;
							end if;
						when brPos =>
							if tick = 0 then
								if Acc_Data_Out /= x"00" and Acc_Data_Out(7) = '0' then
									PC_en <= '1';
								end if;
							elsif tick = 1 then
								wrapup;
							end if;
						when brNeg =>
							if tick = 0 then
								if Acc_Data_Out(7) = '1' then
									PC_en <= '1';
								end if;
							elsif tick = 1 then
								wrapup;
							end if;
						when brInd =>
							if tick = 0 then
								PC_en <= '1';
							elsif tick = 2 then
								Mux_PC_In_Sel <= '1';
								PC_en <= '1';
							elsif tick = 3 then
								wrapup;
							end if;
						when cload =>
							if tick = 1 then
								Mux_Acc_In_Sel <= "01";
								Acc_En <= '1';
							elsif tick =1 then
								wrapup;
							end if;
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
							if tick = 2 then
								wrapup;
							end if;
						when istore => 
							if tick = 0 then
								IAR_En <= '1';
							elsif tick = 3 then
								wrapup;
							end if;
						when negate =>
							if tick = 1 then
								Mux_Acc_In_Sel <= "11";
								Acc_En <= '1';
							elsif tick = 2 then
								wrapup;
							end if;
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
							elsif tick = 2 then
								wrapup;
							end if;
						when others =>
							state <= halt;
						end case;
				end if;
			end if;
		end if;
	end process;
	
	process (state,tick) 
	begin
		en <= '0'; 
		rw <= '1';
		PC_Buffer_Sel <= '0';
		IReg_Buffer_Sel <= '0';
		IAR_Buffer_Sel <= '0';
		Acc_BUffer_Sel <= '0';
		case state is
			when fetch =>
				if tick = 0 then
					en <= '1'; 
					PC_Buffer_Sel <= '1';
				end if;
			when branch | brZero | brPos | brNeg => null
			when brInd =>
				if tick = 2 then
					en <= '1'; 
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
				elsif tick = 1 then
					en <= '1';
					rw <= '0';
					IReg_Buffer_Sel <= '1';
					Acc_BUffer_Sel <= '1';
				end if;
			when iStore =>
				if tick = 0 then
					en <= '1'; 
					IReg_Buffer_Sel <= '1';
				elsif tick = 1 then
					en <= '1';
				elsif tick = 2 then
					en <= '1'; 
					rw <= '0';
					IAR_Buffer_Sel <= '1'; 
					Acc_BUffer_Sel <= '1';
				end if;
				
			when others => null;
		end case;
	end process;
end cpuArch;




	
	