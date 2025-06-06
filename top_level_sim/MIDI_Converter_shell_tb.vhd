----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/05/2025 12:18:12 PM
-- Design Name: 
-- Module Name: Midi_Converter_Shell_tb - Behavioral
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

entity top_shell_tb is
end top_shell_tb;

architecture behavior of top_shell_tb is

    component top_shell
        port (
            clk         : in std_logic;
            data_in : in std_logic;
            --MISO        : in std_logic;
            MOSI        : out std_logic;
            SCLK        : out std_logic;
            CS          : out std_logic;
            light_16    : out std_logic;
            light_15    : out std_logic;
            light_14    : out std_logic;
            light_13    : out std_logic;
            light_12    : out std_logic; 
            light_11    : out std_logic; 
            light_10    : out std_logic; 
            light_9    : out std_logic; 
            light_8   : out std_logic;
            light_7   : out std_logic;
            light_6   : out std_logic;
            light_5   : out std_logic;
            light_4   : out std_logic;
            light_3   : out std_logic;
            light_2   : out std_logic;
            light_1   : out std_logic  
        );
    end component;

    -- signals
    signal clk         : std_logic := '0';
    signal data_in     : std_logic := '0';
    --signal MISO        : std_logic := '0';
    signal MOSI        : std_logic;
    signal SCLK        : std_logic;
    signal CS          : std_logic;
    --signal light_on    : std_logic;
    signal light_16    : std_logic;
    signal light_15    : std_logic;
    signal light_14    : std_logic;
    signal light_13    : std_logic;
    signal light_12    : std_logic; 
    signal light_11    : std_logic; 
    signal light_10    : std_logic; 
    signal light_9    : std_logic; 
    signal light_8   : std_logic;
    signal light_7   : std_logic;
    signal light_6   : std_logic;
    signal light_5   : std_logic;
    signal light_4   : std_logic;
    signal light_3   : std_logic;
    signal light_2   : std_logic;
    signal light_1   : std_logic; 
            
    constant clk_period : time := 10 ns;
    
    constant BAUD_PERIOD : time := 32 us;
    
    signal data : std_logic_vector(7 downto 0) := "10101010";


begin

    -- DUT instantiation
    uut: top_shell
        port map (
            clk         => clk,
            data_in     => data_in,
            --MISO        => MISO,
            MOSI        => MOSI,
            SCLK        => SCLK,
            CS          => CS,
            light_16    => light_16,
        light_15    => light_15,
        light_14    => light_14,
        light_13    => light_13,
        light_12    => light_12,
        light_11    => light_11,
        light_10    => light_10,
        light_9     => light_9,
        light_8     => light_8,
        light_7     => light_7,
        light_6     => light_6,
        light_5     => light_5,
        light_4     => light_4,
        light_3     => light_3,
        light_2     => light_2,
        light_1     => light_1

        );

    -- Clock process
    clk_process : process
    begin
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Wait for reset/setup
        wait for 20 ns;

        -- Send start bit
        data_in <= '0';
        wait for BAUD_PERIOD;

        for i in 0 to 7 loop
            data_in <= data(i);
            wait for BAUD_PERIOD;
        end loop;

        -- stop bit
        data_in <= '1';
        wait for 6.5*BAUD_PERIOD; --checking midpoint measuring ability 
        
        -- start  bit 
        data_in <= '0';
        wait for BAUD_PERIOD;
        
        data <= x"39";
        
        for i in 0 to 7 loop
            data_in <= data(i);
            wait for BAUD_PERIOD;
        end loop;
        
        --stop bit
        data_in <= '1';
        wait for 6.5*BAUD_PERIOD; --checking midpoint measuring ability 
        
        -- start  bit 
        data_in <= '0';
        wait for BAUD_PERIOD;
        
        data <= "11111111";
        
        for i in 0 to 7 loop
            data_in <= data(i);
            wait for BAUD_PERIOD;
        end loop;
        
        --stop bit
        data_in <= '1';
        
        wait for 300*BAUD_PERIOD;
        
        -- Send start bit
        data_in <= '0';
        wait for BAUD_PERIOD;
        data <= "10010000";

        for i in 0 to 7 loop
            data_in <= data(i);
            wait for BAUD_PERIOD;
        end loop;

        -- stop bit
        data_in <= '1';
        wait for 6.5*BAUD_PERIOD; --checking midpoint measuring ability 
        
        -- start  bit 
        data_in <= '0';
        wait for BAUD_PERIOD;
        
        data <= x"48";
        
        for i in 0 to 7 loop
            data_in <= data(i);
            wait for BAUD_PERIOD;
        end loop;
        
        --stop bit
        data_in <= '1';
        wait for 6.5*BAUD_PERIOD; --checking midpoint measuring ability 
        
        -- start  bit 
        data_in <= '0';
        wait for BAUD_PERIOD;
        
        data <= "11110000";
        
        for i in 0 to 7 loop
            data_in <= data(i);
            wait for BAUD_PERIOD;
        end loop;
        
        --stop bit
        data_in <= '1';
        -- Idle
        wait for 200 ns;

        wait;
    end process;

end behavior;
