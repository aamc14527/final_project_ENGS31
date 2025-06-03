-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SCI_Tx_tb is
end SCI_Tx_tb;

architecture behavior of SCI_Tx_tb is

    -- Component declaration for SCI_Tx
    component SCI_Tx
        port(
            clk       : in  std_logic;
            data_in   : in  std_logic;
            byte_out  : out std_logic_vector(7 downto 0);
            byte_ready: out std_logic
        );
    end component;

    signal byte : std_logic_vector(7 downto 0) := "10101010";

    -- Signals for testbench
    signal clk       : std_logic := '0';
    signal data_in   : std_logic := '1'; -- idle state of UART line
    signal byte_out  : std_logic_vector(7 downto 0);
    signal byte_ready: std_logic;

    -- Clock period (10 MHz = 100 ns period)
    constant CLK_PERIOD : time := 100 ns;

    -- BAUD period based on constant in DUT (320 * 100ns = 32 us)
    constant BAUD_PERIOD : time := 32 us;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: SCI_Tx
        port map (
            clk        => clk,
            data_in    => data_in,
            byte_out   => byte_out,
            byte_ready => byte_ready
        );

    -- Clock generation
    clk_process :process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
        begin
        
            -- Start bit
            data_in <= '0';
            wait for 6*BAUD_PERIOD;

            -- Data bits (LSB first)
            for i in 0 to 7 loop
                data_in <= byte(i);
                wait for BAUD_PERIOD;
            end loop;

            -- Stop bit
            data_in <= '1';
            wait for 6.5*BAUD_PERIOD;
            
            data_in <= '0';
            wait for 6*BAUD_PERIOD;

            -- Data bits (LSB first)
            for i in 0 to 7 loop
                data_in <= byte(i);
                wait for BAUD_PERIOD;
            end loop;
            
            wait;
        end process;

end behavior;
