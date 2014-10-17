library ieee;
use ieee.std_logic_1164.all;

entity FSM is
	port (CLOCK 				: IN STD_LOGIC;
			reset 				: IN STD_LOGIC;
			new_line				: IN STD_LOGIC;
			finished				: IN STD_LOGIC;
			
			erasing 				: OUT STD_LOGIC;
			drawing 				: OUT STD_LOGIC		
	);
end FSM;

architecture behavioural of FSM is 

begin 
process(reset, cloCK)
	type state_type is (reset, draw, done);
	variable state : state_type := reset;
begin
	if (reset = '1') then 
		state := reset;
		
	elsif (rising_edge(cloCK)) then
		if(state = reset) then 
			erasing <= '1';
			drawing <= '0';
			if(finished = '1') then
				state := done;
			end if;
			
		elsif(state = draw) then 
			erasing <= '0';
			drawing <= '1';
			if(finished = '1') then 
				state := done;
			end if;
			
		else --the done state
			erasing <= '0';
			drawing <= '0';
			if(new_line = '1') then 
				state := draw;
			end if;
		end if;
	end if;
end process;

end behavioural;
				