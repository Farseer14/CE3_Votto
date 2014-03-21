----------------------------------------------------------------------------------
-- Company: USAFA/DFEC
-- Engineer: Silva
-- 
-- Create Date:    	10:33:47 07/07/2012 
-- Design Name:		CE3
-- Module Name:    	SevenElevatorController_Shell - Behavioral 
-- Description: 		Shell for completing CE3
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SevenElevatorController_Shell is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           desired1 : IN std_logic;
			  desired2 : IN std_logic;
			  desired3 : IN std_logic;
           floor : out  STD_LOGIC_VECTOR (3 downto 0));
end SevenElevatorController_Shell;

architecture Behavioral of SevenElevatorController_Shell is

--Below you create a new variable type! You also define what values that 
--variable type can take on. Now you can assign a signal as 
--"floor_state_type" the same way you'd assign a signal as std_logic 
type floor_state_type is (floor0, floor1, floor2, floor3, floor4, floor5, floor6, floor7);

--Here you create a variable "floor_state" that can take on the values
--defined above. Neat-o!
signal floor_state : floor_state_type;

begin
---------------------------------------------
--Below you will code your next-state process
---------------------------------------------
floor_state_machine: process(clk)

begin
	
	if clk'event and clk='1' then
		
		if reset='1' then
			floor_state <= floor0;
		
		else
			case floor_state is
				
				when floor0 =>
					if (desired3='1') then 
						floor_state <= floor1;
					else
						if (desired2='1') then 
							floor_state <= floor1;
						else
							if (desired1='1') then 
								floor_state <= floor1;
							else
								floor_state <= floor0;
							end if;
						end if;
					end if;
				when floor1 => 
					if (desired3='1') then 
						floor_state <= floor2;
					else
						if (desired2='1') then 
							floor_state <= floor2;
						else
							if (desired1='1') then 
								floor_state <= floor1;
							else
								floor_state <= floor0;
							end if;
						end if;
					end if;
				when floor2 => 
					if (desired3='1') then 
						floor_state <= floor3;
					else
						if (desired2='1' and desired1 = '1') then 
							floor_state <= floor3;
						elsif (desired2 = '1' and desired1 = '0') then
							floor_state <= floor2;
						else
							floor_state <= floor1;
						end if;
					end if;
				when floor3 => 					
					if (desired3='1') then 
						floor_state <= floor4;
					else
						if (desired2='1' and desired1 = '1') then 
							floor_state <= floor3;
						else
							floor_state <= floor2;
						end if;
					end if;
				when floor4 =>
					if (desired3 = '1') then
						if (desired2 = '1' or desired1 = '1') then
							floor_state <= floor5;
						else
							floor_state <= floor4;
						end if;
					else
						floor_state <= floor3;
					end if;
				when floor5 => 
					if (desired3 = '1' and desired2 = '1') then
						floor_state <= floor6;
					elsif (desired3 = '1' and desired1 = '1') then
						floor_state <= floor5;
					else
						floor_state <= floor4;
					end if;
				when floor6 => 
					if (desired3 = '1' and desired2 = '1' and desired1 = '1') then
						floor_state <= floor7;
					elsif (desired3 = '1' and desired2 = '1') then
						floor_state <= floor6;
					else
						floor_state <= floor5;
					end if;
				when floor7 => 
					if (desired3 = '1' and desired2 = '1' and desired1 = '1') then
						floor_state <= floor7;
					else
						floor_state <= floor6;
					end if;
				
				when others =>
					floor_state <= floor0;
			end case;
		end if;
	end if;
end process;

-- Here you define your output logic. Finish the statements below
floor <= "0000" when (floor_state = floor0) else
			"0001" when (floor_state = floor1) else
			"0010" when (floor_state = floor2) else
			"0011" when (floor_state = floor3) else
			"0100" when (floor_state = floor4) else
			"0101" when (floor_state = floor5) else
			"0110" when (floor_state = floor6) else
			"0111" when (floor_state = floor7) else			
			"0001";

end Behavioral;

