----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/03/2025 07:26:41 PM
-- Design Name: 
-- Module Name: m_lookup - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity m_lookup is
Port (  tone_sig : in std_logic_vector(7 downto 0);
        m_value : out std_logic_vector(7 downto 0)
 );
end m_lookup;

architecture Behavioral of m_lookup is

begin

find_m_val : process(tone_Sig)
begin
    case tone_sig is
        when "00000001" =>

        when "00000010" =>
    end case;
end process;

end Behavioral;
