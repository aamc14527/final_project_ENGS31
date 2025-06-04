
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Andrew Swack
-- 
-- Create Date: 06/02/2025 08:40:28 PM
-- Design Name: DDS_Clk_Divider
-- Module Name: DDS_Clk_Divider - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: divides clock so that counter in dds incremenets at proper time so that it can converse with ROM properly
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;			--Needed for Math
library UNISIM;						--Needed for special BUFG buffer
use UNISIM.VComponents.all;			--Needed for special BUFG buffer

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DDS_Clk_Divider is
    Port (  fast_clk            : in STD_LOGIC;
            counter_clk         : out std_logic
          );
end DDS_Clk_Divider;

--have a 12 bit ROM (N = 4096) and want a base frequency (F0) less than 10
--if we choose 16khz for fs we get a base frequency (16000/4096) = 3.90625
--thus the clock divider should be 6250 but divide by two because that is .0625ms up and down

architecture Behavioral of DDS_Clk_Divider is

constant CLK_DIVIDER : integer := 3125;


signal clk_cycle_counter        : unsigned(24 downto 0) := (others => '0');    -- clock divider counter
signal unbuffered_clk_toggle    : std_logic := '0';                        	   -- unbuffered clock signal

--=============================================================================
--Processes: 
--=============================================================================
begin
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Frequency Divider:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Count to half of the clock period:
cycle_counter: process(fast_clk)
begin
	if rising_edge(fast_clk) then
	   	if clk_cycle_counter = CLK_DIVIDER-1 then 	-- Counts to 1/2 clk period
			clk_cycle_counter <= (others => '0');			-- Reset
		else
			clk_cycle_counter <= clk_cycle_counter + 1; 	-- Count up
		end if;
	end if;
end process cycle_counter;

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Toggle Function:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Toggle the unbuffered clock at TC:
toggle_flop: process(fast_clk)
begin
	if rising_edge(fast_clk) then
	   	if clk_cycle_counter = CLK_DIVIDER-1 then
	   		unbuffered_clk_toggle <= NOT(unbuffered_clk_toggle); -- Generates a T-flip flop
		end if;
	end if;
end process toggle_flop;

Slow_clock_buffer: BUFG
      port map (I => unbuffered_clk_toggle,		--Input to the buffer  (exists in programmable logic)
                O => counter_clk );			--Output of the buffer (exists on clocking tree)
				
end Behavioral;
