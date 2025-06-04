----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Asa Chard
-- 
-- Create Date: 06/03/2025 07:26:41 PM
-- Design Name: 
-- Module Name: m_lookup - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Takes input 8 bit signal (reads hex) and outputs an 8 bit signal (m) based on the hex val
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
        when x"30" =>
			m_val <= "00100010";
        when x"31" =>
			m_val <= "00100100";
		when x"32" =>
			m_val <= "00100110";
		when x"33" =>
			m_val <= "00101000";
		when x"34" =>
			m_val <= "00101010";
		when x"35" =>
			m_val <= "00101101";
		when x"36"
			m_val <= "00101111";
		when x"37"
			m_val <= "00110010";
		when x"38"
			m_val <= "00110101";
		when x"39"
			m_val <= "00111000";
		when x"3A"
			m_val <= "00111100";
		when x"3B"
			m_val <= "00111111";
		when x"3C"
			m_val <= "01000011";
		when x"3D"
			m_val <= "01000111";
		when x"3E"
			m_val <= "01001011";
		when x"3F"
			m_val <= "01010000";
		when x"40"
			m_val <= "01010101";
		when x"41"
			m_val <= "01011010";
		when x"42"
			m_val <= "01011111";
		when x"43"
			m_val <= "01100101";
		when x"44"
			m_val <= "01101010";
		when x"45"
			m_val <= "01110001";
		when x"46"
			m_val <= "01111000";
		when x"47"
			m_val <= "01111111";
		when x"48"
			m_val <= "10000110";
		when others =>
			null;
    end case;
end process;

end Behavioral;
