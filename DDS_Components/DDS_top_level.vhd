
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Andrew Swack
-- 
-- Create Date: 06/03/2025 05:21:42 PM
-- Design Name: 
-- Module Name: DDS_TopLevel - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Wiring for all the DDS components. Note that the ROM gives a 16 bit signal
-- so we had to take the 12 msb's to send as the output to the SPI transmitter
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DDS_TopLevel is
Port ( clk      : in std_logic;
       tone_sig : in std_logic_vector(7 downto 0);
       sin_sig  : out std_logic_vector(11 downto 0);
       data_valid : out std_logic --wired to slow clock
);
end DDS_TopLevel;

architecture Behavioral of DDS_TopLevel is

--==============================================================
--  Component Declarations
--==============================================================
component dds_compiler_0 is
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_phase_tvalid : IN STD_LOGIC; --dont think this is needed
    s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC; 
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
end component dds_compiler_0;

component DDS_Clk_Divider is
    Port (  fast_clk            : in STD_LOGIC;
            counter_clk         : out std_logic
          );
end component DDS_Clk_Divider;

component DDS_Counter is
    Port (  counter_clk : in std_logic;
            m_value    : in std_logic_vector(7 downto 0);
            DDS_ROM_ADDR: out std_logic_vector(15 downto 0)
    );
end component DDS_Counter;

component m_lookup is
Port (  tone : in std_logic_vector(7 downto 0);
        m_val : out std_logic_vector(7 downto 0)
 );
end component m_lookup;
--==============================================================
--  signals for moving values between components
--==============================================================
signal ADDR : std_logic_vector (15 downto 0); --for the address from counter
signal slow_clk : std_logic; --for counter clk
signal m : std_logic_vector(7 downto 0) := (others => '0'); --m value determined by note signal`
signal sin_wave : std_logic_vector(15 downto 0); --need to shortn output from ROM to receive a sine wave, do this by passing to a signal then taking 12 lsb's as output

begin

sin_sig <= sin_wave(15 downto 4); --take 12 msb's outputed by ROM
data_valid <= slow_clk;

--==============================================================
--  port maping
--==============================================================
DDS_ROM : dds_compiler_0 PORT MAP(
    aclk => slow_clk,
    s_axis_phase_tvalid => '1', --s_axis_phase_tvalid, dont think this is needed
    s_axis_phase_tdata => ADDR,--cannot stop it from being 16 bit signal. converted to 12 bits by sin_wave signal
    m_axis_data_tvalid => open,--m_axis_data_tvalid, same here
    m_axis_data_tdata => sin_wave
);

DDS_CLK : DDS_Clk_Divider PORT MAP(
    fast_clk => clk,
    counter_clk => slow_clk
);

Counter : DDS_Counter PORT MAP(
    counter_clk => slow_clk,
    m_value => m,
    DDS_rom_addr => ADDR
);

Lookup_table : m_lookup PORT MAP(
    tone => tone_sig,
    m_val => m
);
end Behavioral;
