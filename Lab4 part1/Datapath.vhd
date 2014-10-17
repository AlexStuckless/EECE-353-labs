library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Datapath is
	port (CLOCK			: IN STD_LOGIC;
			reset 		: IN STD_LOGIC;
			drawing 		: IN STD_LOGIC;
			erasing		: IN STD_LOGIC;
			
			done				: OUT STD_LOGIC;
			y_val			: OUT std_logic_vector(6 downto 0); 
			x_val 		: OUT std_logic_vector(7 downto 0);
			colour		: OUT std_logic_vector(2 downto 0)
						
	);
end Datapath;

architecture behavioural of Datapath is
	signal x      : std_logic_vector(7 downto 0) := (others => '0');
	signal y      : std_logic_vector(6 downto 0) := (others => '0');
begin

process(reset, cloCK)
	variable dx : unsigned(7 downto 0);
	variable dy : unsigned(6 downto 0);
	variable var_done : Std_LOGIC;
begin 
	if( reset = '1') then 
		x <= "00000000";
		y <= "0000000";
		var_done := '0';
		done <= '0';
		
	elsif (rising_edge(cloCK)) then
		
		if(erasing = '1' and var_done = '0') then
			colour <= "000";
			if( to_integer( unsigned(x) ) = 160) then
				y <= std_logic_vector(unsigned(y) + 1);
				x <= "00000000";
			else 
				x <= std_logic_vector(unsigned(x) + 1);
			end if;
			if(to_integer(unsigned(y)) = 120) then 
				y <= "0000000";
				x <= "00000000";
				var_done := '1';
			end if;
		
		elsif(drawing = '1') then
			dx := "00000001";
			dy := "0000001";
			colour <= "001";
			var_done := '0';
			if( to_integer( unsigned(x) ) < 160) then
				x <= std_logic_vector(unsigned(x) + dx);
			else
				var_done := '1';
			end if;
			if(to_integer(unsigned(y)) < 120) then
				y <= std_logic_vector(unsigned(y) + dy);
			end if;
		end if;
		done <= var_done;
	end if;
end process;

y_val <= y;
x_val <= x;

 end behavioural;
	