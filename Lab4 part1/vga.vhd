library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is
	port(CLOCK_50            : in  std_logic;
		  KEY                 : in  std_logic_vector(3 downto 0);
        SW                  : in  std_logic_vector(17 downto 0);
		  VGA_R, VGA_G, VGA_B : out std_logic_vector(9 downto 0);  -- The outs go to VGA controller
		  VGA_HS              : out std_logic;
		  VGA_VS              : out std_logic;
		  VGA_BLANK           : out std_logic;
		  VGA_SYNC            : out std_logic;
		  VGA_CLK             : out std_logic
	);
end vga;

architecture rtl of vga is

	component FSM 
		port (CLOCK 				: IN std_logic;
				reset 				: IN std_logic;
				new_line				: IN std_logic;
				finished				: IN std_logic;
				
				erasing 				: OUT std_logic;
				drawing 				: OUT std_logic	
		);
	end component;
	
	component Datapath 
		port (CLOCK			: IN std_logic;
				reset 		: IN std_logic;
				drawing 		: IN std_logic;
				erasing		: IN std_logic;
				
				done			: OUT std_logic;
				y_val			: OUT std_logic_vector(6 downto 0); 
				x_val 		: OUT std_logic_vector(7 downto 0);
				colour		: OUT std_logic_vector(2 downto 0) 		
		);
	end component;

	component vga_adapter
		generic(RESOLUTION : string);
		port (resetn                                       : in  std_logic;
				clock                                        : in  std_logic;
				colour                                       : in  std_logic_vector(2 downto 0);
				x                                            : in  std_logic_vector(7 downto 0);
				y                                            : in  std_logic_vector(6 downto 0);
				plot                                         : in  std_logic;
				VGA_R, VGA_G, VGA_B                          : out std_logic_vector(9 downto 0);
				VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK : out std_logic);
		end component;

	signal plot 	: std_logic;
	signal done 	: std_logic;
	signal erasing : std_logic;
	signal drawing : std_logic;
	signal x      	: std_logic_vector(7 downto 0);
	signal y      	: std_logic_vector(6 downto 0);
	signal colour	: std_logic_vector(2 downto 0); 
	
begin

	u0 : FSM
		port map (clock 		=> cloCK_50, 
					 reset 		=> not KEY(3), 
					 new_line 	=> not KEY(0), 
					 finished 	=> done, 
					 erasing 	=> erasing,
					 drawing 	=> drawing);
		
	u1 : Datapath
		port map (clock 		=> cloCK_50,
					 reset 		=> not KEY(3),
					 erasing 	=> erasing,
					 drawing 	=> drawing,
					 done 		=> done,
					 x_val		=> x,
					 y_val 		=> y,
					 colour 		=> colour);
	
	plot <= not cloCK_50;

	vga_u0 : vga_adapter
		generic map(RESOLUTION => "160x120") 
		port map(resetn    => Key(3),
					clock     => clock_50,
					colour    => colour,
					x         => x,
					y         => y,
					plot      => plot,
					VGA_R     => VGA_R,
					VGA_G     => VGA_G,
					VGA_B     => VGA_B,
					VGA_HS    => VGA_HS,
					VGA_VS    => VGA_VS,
					VGA_BLANK => VGA_BLANK,
					VGA_SYNC  => VGA_SYNC,
					VGA_CLK   => VGA_CLK);	
end RTL;


