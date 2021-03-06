----------------------------------------------------------------------------------
-- Company: USAFA/DFEC
-- Engineer: Silva
-- 
-- Create Date:    	10:33:47 07/07/2012 
-- Design Name:		CE3
-- Module Name:    	MooreElevatorController_Shell - Behavioral 
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

entity MealyElevatorController_Shell is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           up_down : in  STD_LOGIC;
           floor : out  STD_LOGIC_VECTOR (3 downto 0);
			  next_floor : out STD_LOGIC_VECTOR (3 downto 0));
end MealyElevatorController_Shell;

architecture Behavioral of MealyElevatorController_Shell is

--Below you create a new variable type! You also define what values that 
--variable type can take on. Now you can assign a signal as 
--"floor_state_type" the same way you'd assign a signal as std_logic 
type floor_state_type is (floor1, floor2, floor3, floor4);

--Here you create a variable "floor_state" that can take on the values
--defined above. Neat-o!
signal floor_state : floor_state_type;

begin
---------------------------------------------
--Below you will code your next-state process
---------------------------------------------

--This line will set up a process that is sensitive to the clock
floor_state_machine: process(clk)
begin
	--clk'event and clk='1' is VHDL-speak for a rising edge
	if clk'event and clk='1' then
		--reset is active high and will return the elevator to floor1
		--Question: is reset synchronous or asynchronous?
		if reset='1' then
			floor_state <= floor1;
		--now we will code our next-state logic
		else
			case floor_state is
				--when our current state is floor1
				when floor1 =>
					--if up_down is set to "go up" and stop is set to 
					--"don't stop" which floor do we want to go to?
					if (up_down='1' and stop='0') then 
						--floor2 right?? This makes sense!
						floor_state <= floor2;
					--otherwise we're going to stay at floor1
					else
						floor_state <= floor1;
					end if;
				--when our current state is floor2
				when floor2 => 
					--if up_down is set to "go up" and stop is set to 
					--"don't stop" which floor do we want to go to?
					if (up_down='1' and stop='0') then 
						floor_state <= floor3; 			
					--if up_down is set to "go down" and stop is set to 
					--"don't stop" which floor do we want to go to?
					elsif (up_down='0' and stop='0') then 
						floor_state <= floor1;
					--otherwise we're going to stay at floor2
					else
						floor_state <= floor2;
					end if;
				
--COMPLETE THE NEXT STATE LOGIC ASSIGNMENTS FOR FLOORS 3 AND 4
				when floor3 =>
					-- descending
					if (up_down = '0' and stop = '0') then 
						floor_state <= floor2;
					-- ascending
					elsif (up_down = '1' and stop = '0') then 
						floor_state <= floor4;	
					-- staying
					else
						floor_state <= floor3;
					end if;
					
				--Floor four cannot go up and unless it says to go down it will stay
				when floor4 =>
					--if decending
					if (up_down = '0' and stop = '0') then 
						floor_state <= floor3;
					--all other cases
					else 
						floor_state <= floor4;
					end if;
				
				--This line accounts for phantom states -- should there be any?
				when others =>
					floor_state <= floor1;
			end case;
		end if;
	end if;
end process;

-- Here you define your output logic. Finish the statements below
floor <= "0001" when (floor_state = floor1) else
			"0010" when (floor_state = floor2) else
			"0011" when (floor_state = floor3) else
			"0100" when (floor_state = floor4) else
			"0001";
			
next_floor <= "0001" when (floor_state = floor1 and stop = '1') else --stay
				  "0001" when (floor_state = floor1 and up_down = '0') else --down
				  "0010" when (floor_state = floor1 and up_down = '1') else --up
				  
				  "0010" when (floor_state = floor2 and stop = '1') else --stay
				  "0001" when (floor_state = floor2 and up_down = '0') else --down
				  "0011" when (floor_state = floor2 and up_down = '1') else --up
				  
				  "0011" when (floor_state = floor3 and stop = '1') else --stay 
				  "0010" when (floor_state = floor3 and up_down = '0') else --down
				  "0100" when (floor_state = floor3 and up_down = '1') else --up
				  
				  "0100" when (floor_state = floor4 and stop = '1') else --stay
				  "0011" when (floor_state = floor4 and up_down = '0') else --down
				  "0100" when (floor_state = floor4 and up_down = '1') else --up
				  "0001";
end Behavioral;



