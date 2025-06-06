
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Andrew Swack
-- 
-- Create Date: 06/02/2025 10:10:15 PM
-- Design Name: DDS_counter
-- Module Name: DDS_Counter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: uses equation Fm = mFs/N by incrementing a counter by m until it reaches 
-- N-1. It does so at the speed dictated by Fs (from DDS_Clk_Divider). Fm is the frequency 
-- sent to the ROM as an address (labelled DDS_ROM_ADDR) to tell it how quickly and at what 
-- stride to move through the ROM (contains a sin wave) 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DDS_Counter is
    Port (  counter_clk : in std_logic;
            m_value    : in std_logic_vector(7 downto 0);
            DDS_ROM_ADDR: out std_logic_vector(15 downto 0)
    );
end DDS_Counter;

architecture Behavioral of DDS_Counter is

constant N : integer := 4096; --max value for counter, must be same size as ROM
signal m : unsigned(7 downto 0) := "00000001"; --this is rate determined by tone_sig converted to m_value by a lookup table
signal ADDR : unsigned(15 downto 0) := (others => '1');

begin

m <= unsigned(m_value);

Ncounter : process (counter_clk, ADDR)
begin
    if rising_edge(counter_clk) then
        ADDR <= ADDR + m;
        if(ADDR >= N-1) then
            ADDR <= (others => '0');
        end if;
    end if;
    

end process Ncounter;

DDS_ROM_ADDR <= std_logic_vector(ADDR);

end Behavioral;
