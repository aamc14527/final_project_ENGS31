--=============================================================================
--ENGS 31/ CoSc 56
--Lab 4 Shell
--Ben Dobbins
--Eric Hansen
--=============================================================================

--=============================================================================
--Library Declarations:
--=============================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

--=============================================================================
--Entity Declaration:
--=============================================================================
entity lab4_shell is
    Port ( 	
			clk_ext_port		: in std_logic;		-- mapped to external IO device (100 MHz Clock)				
			left_ext_port 	    : in std_logic;		-- mapped to external IO device (slide switch 15)
			right_ext_port		: in std_logic;		-- mapped to external IO device (slide switch  0)
			LC_ext_port			: out std_logic;    -- mapped to external IO device (LED 15)
			LB_ext_port			: out std_logic;    -- mapped to external IO device (LED 14)
			LA_ext_port			: out std_logic;    -- mapped to external IO device (LED 13)
			RA_ext_port			: out std_logic;    -- mapped to external IO device (LED  2)
			RB_ext_port			: out std_logic;    -- mapped to external IO device (LED  1)
			RC_ext_port			: out std_logic );  -- mapped to external IO device (LED  0)
end lab4_shell;

--=============================================================================
--Architecture Type:
--=============================================================================
architecture behavioral_architecture of lab4_shell is

--=============================================================================
--Sub-Component Declarations:
--=============================================================================
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--System Clock Generation:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
component lab4_system_clock_generation is
    Port (
        --External Clock:
            input_clk_port		: in std_logic;
        --System Clock:
            system_clk_port		: out std_logic);
end component;

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Thunderbird Tail Light FSM:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
component lab4_thunderbird_fsm is
    Port ( 
		--timing:
			clk_port 		: in std_logic;
		--control inputs:
			left_port 	    : in std_logic;
			right_port      : in std_logic;
		--LED outputs:
			LC_port			: out std_logic;
			LB_port			: out std_logic;
			LA_port			: out std_logic;
			RA_port			: out std_logic;
			RB_port			: out std_logic;
			RC_port			: out std_logic );
end component;

--=============================================================================
--Signal Declarations: 
--=============================================================================
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Timing:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
signal system_clk: std_logic := '0';

--=============================================================================
--Port Mapping (wiring the component blocks together): 
--=============================================================================
begin
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Wire the system clock generator into the shell with a port map:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
clocking: lab4_system_clock_generation port map(
    input_clk_port  => clk_ext_port,     -- External clock
    system_clk_port => system_clk );     -- System clock
    
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Wire the Thunderbird tail light FSM into the shell with a port map:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Student design instantiated
-- All ports are mapped to the top level ports except clk_port and y_port
FSM: lab4_thunderbird_fsm port map(
    clk_port 		=> system_clk,           	-- mapped to clock divider
    left_port 	    => left_ext_port,		-- mapped to external IO device (slide switch 15)
    right_port      => right_ext_port,		-- mapped to external IO device (slide switch  0)
	LC_port         => LC_ext_port,			-- mapped to external IO device (LED 15)
	LB_port         => LB_ext_port,			-- mapped to external IO device (LED 14)
	LA_port         => LA_ext_port,			-- mapped to external IO device (LED 13)
	RA_port         => RA_ext_port,			-- mapped to external IO device (LED  2)
	RB_port         => RB_ext_port,			-- mapped to external IO device (LED  1)
	RC_port         => RC_ext_port );		-- mapped to external IO device (LED  0)

end behavioral_architecture;
