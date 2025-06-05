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
            CS          : out std_logic
        );
    end component;

    -- signals
    signal clk         : std_logic := '0';
    signal data_in     : std_logic := '0';
    --signal MISO        : std_logic := '0';
    signal MOSI        : std_logic;
    signal SCLK        : std_logic;
    signal CS          : std_logic;

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
            CS          => CS
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
