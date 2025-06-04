----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/03/2025 05:21:42 PM
-- Design Name: 
-- Module Name: DDS_TopLevel - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DDS_TopLevel is
Port ( clk      : in std_logic;
       tone_sig : in std_logic_vector(7 downto 0);
       sin_sig  : out std_logic_vector(15 downto 0)
);
end DDS_TopLevel;

architecture Behavioral of DDS_TopLevel is

--==============================================================
--  Component Declarations
--==============================================================
component dds_compiler_0 is
  PORT (
    aclk : IN STD_LOGIC;
    --s_axis_phase_tvalid : IN STD_LOGIC; dont think this is needed
    s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
   -- m_axis_data_tvalid : OUT STD_LOGIC; same here
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
            tone_sig    : in std_logic_vector(7 downto 0);
            DDS_ROM_ADDR: out std_logic_vector(11 downto 0)
    );
end component DDS_Counter;

--==============================================================
--  signals for moving values between components
--==============================================================
signal ADDR : std_logic_vector (11 downto 0); --for the address from counter
signal slow_clk : std_logic; --for counter clk
signal m : std_logic_vector(7 downto 0); --m value determined by note signal`

begin
--==============================================================
--  port maping
--==============================================================
DDS_ROM : dds_compiler_0 PORT MAP(
    aclk => slow_clk,
    s_axis_phase_tvalid => '1', --dont think this is needed
    s_axis_phase_tdata => "0000" & ADDR,--seems weird, ask Tad
    m_axis_data_tvalid => open,
    m_axis_data_tdata => sin_sig
);

DDS_CLK : DDS_Clk_Divider PORT MAP(
    fast_clk => clk,
    counter_clk => slow_clk
);

Counter : DDS_Counter PORT MAP(
    counter_clk => slow_clk,
    tone_sig => m,
    DDS_rom_addr => ADDR
);
end Behavioral;
